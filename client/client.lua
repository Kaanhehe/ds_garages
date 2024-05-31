--[[
    Caching natives
]]

local RegisterNetEvent <const> = RegisterNetEvent
local AddEventHandler <const> = AddEventHandler
local AddBlipForCoord <const> = AddBlipForCoord
local SetBlipSprite <const> = SetBlipSprite
local SetBlipDisplay <const> = SetBlipDisplay
local SetBlipScale <const> = SetBlipScale
local SetBlipColour <const> = SetBlipColour
local SetBlipAsShortRange <const> = SetBlipAsShortRange
local BeginTextCommandSetBlipName <const> = BeginTextCommandSetBlipName
local AddTextComponentSubstringPlayerName <const> = AddTextComponentSubstringPlayerName
local EndTextCommandSetBlipName <const> = EndTextCommandSetBlipName

--[[
    Initializing globals, functions, events
]]

local translate <const> = Config.GarageSystem.Translation

local camera, buttonLoad, currentAction, currentActionGarage, currentActionGarageID, currentGarage, currentGarageID, cantUseReplaceGui, invitedBySomeone, inviterID
local garages, localVehicles, garageGui, garageReplaceGui, garageManagerGui, friendsInviterGui, garageSellerGui = {}, {}, {}, {}, {}, {}, {}
local canOpenGui = false
local usedBefore = false
local playerPed, playerID = PlayerPedId(), PlayerId()

local points = {}
local blips = {}

local function loadBlip(position, color, text, sprite, distance, type, size, markercolor, elevator)
    local blip = AddBlipForCoord(position.x, position.y, position.z)
    if distance then
        local point = lib.points.new({
            coords = position,
            distance = distance,
        })

        function point:nearby()
---@diagnostic disable-next-line: param-type-mismatch
            DrawMarker(type, position.x, position.y, position.z + 1.0, 0, 0, 0, 0, 0, 0, size[1], size[2], size[3], markercolor[1], markercolor[2], markercolor[3], 100, false, true, 2, false, false, false, false)
        end

        table.insert(points, point)
    end
    if elevator then
        local point = lib.points.new({
            coords = elevator.position,
            distance = elevator.markerDistance,
        })

        function point:nearby()
---@diagnostic disable-next-line: param-type-mismatch
            DrawMarker(elevator.markerType, elevator.position.x, elevator.position.y, elevator.position.z + 1.0, 0, 0, 0, 0, 0, 0, elevator.markerSize[1], elevator.markerSize[2], elevator.markerSize[3], elevator.markerColor[1], elevator.markerColor[2], elevator.markerColor[3], 100, false, true, 2, false, false, false, false)
        end
        
        table.insert(points, point)
    end
        

	SetBlipSprite (blip, sprite)
	SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)

    table.insert(blips, blip)

    return blip
end

local function loadPlayerGarages()
    ESX.TriggerServerCallback("ds_garages:sendNet", function(result)
        local owns, blip
        if not result then return end

        for _, v in pairs(result) do
            if type(v) ~= "table" then
                owns = v
            else
                owns = v.garage
            end
            local garage = Config.GarageSystem.garages[owns]
            if not garage then return end

            blip = loadBlip(garage.blipPosition, garage.blipColor, garage.blipText, garage.blipSprite, garage.markerDistance, garage.markerType, garage.markerSize, garage.markerColor, garage.FootEnterMarker)

            garages[owns] = {
                garage = garage,
                blip = blip
            }
        end
    end, "getGarages")
end

AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    for k, v in pairs(points) do
        function v:nearby()
        end
    end
    garages = {}
    points = {}
    blips = {}
    loadPlayerGarages()
    SetupPoints()
end)


local function initialize()
    Debug("initialize")

    -- Initialize all the menus
	garageReplaceGui = MenuV:CreateMenu(translate["guis"]["replaceVehicles"]["title"], translate["guis"]["replaceVehicles"]["subtitle"], 'topleft', 255, 0, 0, 'size-125', 'default', 'menuv', 'ds_garages_replacecars', 'native')
	garageGui = MenuV:CreateMenu(translate["guis"]["availableGarages"]["title"], translate["guis"]["availableGarages"]["subtitle"], 'topleft', 255, 0, 0, 'size-125', 'default', 'menuv', 'ds_garages_mainmenu', 'native')
    garageManagerGui = MenuV:CreateMenu(translate["guis"]["manageGarage"]["title"], translate["guis"]["manageGarage"]["subtitle"], 'topleft', 255, 0, 0, 'size-125', 'default', 'menuv', 'ds_garages_garagemanager', 'native')
    friendsInviterGui = MenuV:CreateMenu(translate["guis"]["manageGarage"]["buttons"]["inviteAFriend"]["subMenu"]["title"], translate["guis"]["manageGarage"]["buttons"]["inviteAFriend"]["subMenu"]["subtitle"], 'topleft', 255, 0, 0, 'size-125', 'default', 'menuv', 'ds_garages_friendsgui', 'native')
    garageSellerGui = MenuV:CreateMenu(translate["guis"]["manageGarage"]["buttons"]["garageSeller"]["subMenu"]["title"], translate["guis"]["manageGarage"]["buttons"]["garageSeller"]["subMenu"]["subtitle"], 'topleft', 255, 0, 0, 'size-125', 'default', 'menuv', 'ds_garages_garageseller', 'native')

    garageGui:On("close", function()
        SetCamActive(camera, false)
        RenderScriptCams(false, false, 0, true, true)
        ClearFocus()

        camera = nil
        buttonLoad = nil

        Wait(300)

        -- avoid collisions problems
        SetPlayerInvincible(playerID, false)
        FreezeEntityPosition(playerPed, false)
    end)

    CreateThread(function()
        loadPlayerGarages()
        SetupPoints()
    end)
end

local function getESXLegacy()
    return exports.es_extended.getSharedObject()
end

local function getESXOld()
    local esx = nil
    TriggerEvent(Config.GarageSystem.triggers.getESX, function(object) esx = object end)
    while esx == nil do Citizen.Wait(0) end
    return esx
end

Citizen.CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    
    initialize()
end)

ESX = Config.GarageSystem.ESXMode == "legacy" and getESXLegacy() or getESXOld()
if not ESX then return Debug("ESX not found") end

local function loadCamera(position, heading)
    if not DoesCamExist(camera) then
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end

    SetCamCoord(camera, position.x, position.y, position.z)
    SetCamRot(camera, 0, 0, heading, 2)
    RenderScriptCams(true, false, 0, true, true)
    SetCamActive(camera, true)
    SetFocusPosAndVel(position.x, position.y, position.z, 0, 0, 0)
end

AddEventHandler("onPlayerDied", function()
    if not currentGarage then return end

    ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
        if not success then return end

        currentAction = nil
        currentGarage = nil
    end, "closeInstance", {inviter = inviterID, jobgarage = currentGarage.jobgarage, garageID = currentGarageID})
end)


--[[
    Spawn NPCs
]]


CreateThread(function()
    if not Config.GarageSystem.npcactive then return end
    for _, npc in pairs(Config.GarageSystem.npcs) do
        local model = GetHashKey(npc.model)

        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(1)
        end

        local npcPed = CreatePed(4, model, npc.position.x, npc.position.y, npc.position.z - 1, npc.heading, false, true)

        FreezeEntityPosition(npcPed, true)
        SetEntityInvincible(npcPed, true)
        SetBlockingOfNonTemporaryEvents(npcPed, true)

        loadBlip(npc.position, npc.blipColor, npc.blipText, npc.blipSprite)
    end
end)


--[[
    Use NPC & Current action
]]

local nearManageGarageMarker = false
function SetupPoints()
    Wait(1000) -- TODO: Find a better way to do this (wait for garages var to be filled by loadPlayerGarages())
    CreateThread(function()
        local action, foundGarage = nil, false
        for garageID, garageData in pairs(garages) do
            local point = lib.points.new({
                coords = garageData.garage.blipPosition,
                distance = 5,
            })
            function point:nearby()
                action = translate["messages"]["actionAccessToGarage"]
                currentActionGarage = garageData.garage
                currentActionGarageID = garageID
                foundGarage = true
            end
            function point:onExit()
                action = nil
                currentActionGarage = nil
                currentActionGarageID = nil
                foundGarage = false
            end
            if garageData.garage.FootEnterMarker then
                local point = lib.points.new({
                    coords = garageData.garage.FootEnterMarker.position,
                    distance = 1.5,
                })
                function point:nearby()
                    action = translate["messages"]["actionAccessToGarage"]
                    currentActionGarage = garageData.garage
                    currentActionGarageID = garageID
                    foundGarage = true
                end
                function point:onExit()
                    action = nil
                    currentActionGarage = nil
                    currentActionGarageID = nil
                    foundGarage = false
                end
            end
        end
        for _, npc in pairs(Config.GarageSystem.npcs) do
            local point = lib.points.new({
                coords = npc.position,
                distance = npc.useDistance,
            })
            function point:nearby()
                action = translate["messages"]["actionAccessToNpc"]
                canOpenGui = true
            end
            function point:onExit()
                action = nil
                canOpenGui = false
            end
        end
        while true do
            if playerPed ~= PlayerPedId() then playerPed = PlayerPedId() end
            -- Not sure if playerID is static
            if playerID ~= PlayerId() then playerID = PlayerId() end

            if action then
                currentAction = action
            elseif not currentGarage then
                currentAction = nil
            end

            if currentGarage then
                Wait(500)
            else
                Wait(800)
            end
        end
    end)
end


--[[
    Draw GUI & Checks
]]


local function spawnLocalVehicles(vehicles, garage, garageId, add)
    if not currentGarage.friendlyfire then
        SetPlayerInvincible(playerID, true)
    end

    for k, v in pairs(vehicles) do
        if k > #garage.vehiclePositions then return end
        
        local vehicleProperties

        if garage then
            vehicleProperties = json.decode(v.vehicle)
        else
            vehicleProperties = v.vehicleProperties
        end

        if not vehicleProperties then goto continue end

        Debug("k=" .. k)
        Debug("model: " .. vehicleProperties.model)
        Debug(garage and json.encode(garage.vehiclePositions[k].position) or json.encode(v.position))
        Debug(garage and json.encode(garage.vehiclePositions[k].heading) or json.encode(v.heading))

        local spawned = false
        if garage.jobgarage and add then

            local spot = k

            while not spawned do
                
                if lib.getClosestVehicle(garage.vehiclePositions[spot].position, 1.5, false) then
                    spot = spot +1
                else
                    spawned = true
                    ESX.TriggerServerCallback("ds_garages:sendNet", function(spawnedVehicle) 

                        if spawnedVehicle == "spawning" then return end

                        spawnedVehicle = NetworkGetEntityFromNetworkId(spawnedVehicle)

                        if not spawnedVehicle then
                            return Notify(translate["messages"]["somethingWentWrong"])
                        end

                        SetVehicleData(spawnedVehicle, vehicleProperties)

                        Debug("spawned vehicle")

                    end, "spawnVehicles", {vehicleProperties = vehicleProperties, coords = garage and garage.vehiclePositions[spot] or v, heading = garage and garage.vehiclePositions[spot].heading or v.heading, garageID = garageId, done = false})
                end
                Wait(0)
            end
        elseif garage.jobgarage then

            spawned = lib.getClosestVehicle(garage.vehiclePositions[k].position, 1.5, false) ~= nil

            if spawned then goto continue end

            ESX.TriggerServerCallback("ds_garages:sendNet", function(spawnedVehicle) 

                if spawnedVehicle == "spawning" then return end

                spawnedVehicle = NetworkGetEntityFromNetworkId(spawnedVehicle)

                if not spawnedVehicle then
                    return Notify(translate["messages"]["somethingWentWrong"])
                end

                SetVehicleData(spawnedVehicle, vehicleProperties)

                Debug("spawned vehicle")

            end, "spawnVehicles", {vehicleProperties = vehicleProperties, coords = garage and garage.vehiclePositions[k] or v, heading = garage and garage.vehiclePositions[k].heading or v.heading, garageID = garageId, done = false})            
        else
            ESX.Game.SpawnLocalVehicle(vehicleProperties.model, garage and garage.vehiclePositions[k].position or v.position, garage and garage.vehiclePositions[k].heading or v.heading, function(spawnedVehicle)
                
                SetVehicleData(spawnedVehicle, vehicleProperties)
    
                localVehicles[#localVehicles + 1] = spawnedVehicle
    
                Debug("spawned local vehicle")

            end)
        end

        ::continue::
    end
    if garage.jobgarage then
        ESX.TriggerServerCallback("ds_garages:sendNet", function() 
        end, "spawnVehicles", {garageID = garageId, done = true})
    end
end

local function spawnVehicles(garage, garageId, vehicle, vehicleProperties)
    if currentGarage and not vehicle then return end

    if vehicle then
        vehicleplate = vehicleProperties.plate
        ESX.TriggerServerCallback("ds_garages:sendNet", function(ownedVehicles)
            spawnLocalVehicles(ownedVehicles, garage, garageId, true)
        end, "getVehiclesFromGarage", {garageID = garageId, plate = vehicleplate})
        return
    end

    Debug("spawn vehicles")
    ESX.TriggerServerCallback("ds_garages:sendNet", function(ownedVehicles)
        spawnLocalVehicles(ownedVehicles, garage, garageId)
    end, "getVehiclesFromGarage", {garageID = garageId})
end

local function launchFade()
    CreateThread(function()
        DoScreenFadeOut(800)
        Wait(1000)
        DoScreenFadeIn(800)
    end)

    Wait(750)
end

local function spawnVehicle(vehicleProperties, leaveSpawnCoords)
    ESX.TriggerServerCallback("ds_garages:sendNet", function(vehicle)
        vehicle = NetworkGetEntityFromNetworkId(vehicle)

        if not vehicle then
            return Notify(translate["messages"]["somethingWentWrong"])
        end

        SetVehicleData(vehicle, vehicleProperties)
        if (Config.GarageSystem.useImpoundSystem) then
            TriggerServerEvent("s1n_impound:addVehicleToCache", NetworkGetNetworkIdFromEntity(vehicle))
        end

        Debug("vehicle spawned on exit")
    end, "spawnVehicle", { vehicleProperties = vehicleProperties, coords = leaveSpawnCoords })
end

local function goIntoGarage(garage, garageId, vehicle)
    CreateThread(function()
        local foundGround, zCoord = false, -500.0
        local vehicleProperties = nil

        while not foundGround do
            zCoord = zCoord + 10.0

            RequestCollisionAtCoord(garage.spawnCoords.position.x, garage.spawnCoords.position.y, zCoord)
            Wait(0)

            foundGround, _ = GetGroundZFor_3dCoord(garage.spawnCoords.position.x, garage.spawnCoords.position.y, zCoord, true)

            if not foundGround and zCoord >= 2000.0 then
                foundGround = true
            end
        end

        if vehicle then
            vehicleProperties = GetVehicleData(vehicle)
            RemoveVehicle(vehicle)
            while DoesEntityExist(vehicle) do
                Wait(0)
            end
        end

        if lib.progressBar({
            duration = 2000,
            label = translate["messages"]["teleportingintoGarage"]:format(garage.name),
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            }
        }) then else return end

        launchFade()
        ESX.Game.Teleport(playerPed, {x = garage.spawnCoords.position.x, y = garage.spawnCoords.position.y, z = garage.spawnCoords.position.z, heading = garage.spawnCoords.heading}, function()
            SetGameplayCamRelativeRotation(0.0, 0.0, garage.spawnCoords.heading)
            ESX.TriggerServerCallback("ds_garages:sendNet", function(shouldSpawnVehicles)
                Notify(translate["messages"]["welcomeIntoYourGarage"]:format(garage.name))
                if shouldSpawnVehicles then
                    spawnVehicles(garage, garageId)
                end
                currentGarage = garage
                currentGarageID = garageId
                if vehicle and not shouldSpawnVehicles then
                    spawnVehicles(garage, garageId, vehicle, vehicleProperties)
                end
                currentAction = translate["messages"]["actionLeaveGarage"]
                local point = lib.points.new({
                    coords = garage.manageGarage.marker.position,
                    distance = garage.manageGarage.marker.useDistance,
                })
                function point:nearby()
                    currentAction = translate["messages"]["actionManageGarage"]
                    nearManageGarageMarker = true
                end
                function point:onExit()
                    currentAction = translate["messages"]["actionLeaveGarage"]
                    nearManageGarageMarker = false
                end
            end, "createInstance", { garageID = currentGarageID, jobgarage = garage.jobgarage })
        end)
    end)
end

local function openGarageReplaceGui(vehicles, garageId)
    garageReplaceGui:ClearItems()

    for _, v in pairs(vehicles) do
        if v.vehicle then
            garageReplaceGui:AddButton({ label = translate["messages"]["listVehicleButtonTitle"]:format(GetDisplayNameFromVehicleModel(v.vehicle.model), v.vehicle.plate), description = translate["messages"]["replaceVehicle"],
                select = function()
                    if cantUseReplaceGui then return end
                    cantUseReplaceGui = true

                    if not IsPedInAnyVehicle(playerPed, false) then
                        return Notify(translate["messages"]["beInVehicleToReplace"])
                    end

                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local vehicleProperties = GetVehicleData(vehicle)
                    local garage = Config.GarageSystem.garages[garageId]

                    if not garage then return end

                    ESX.TriggerServerCallback("ds_garages:sendNet", function()
                        garageReplaceGui:Close()

                        launchFade()
                        RemoveVehicle(vehicle)

                        spawnVehicle(v.vehicle, garage.leaveSpawnCoords)

                        Wait(1000)
                        cantUseReplaceGui = nil
                    end, "replaceVehicleFromGarage", {garageID = garageId, vehicleProperties = vehicleProperties, oldPlate = v.vehicle.plate})
                end
            })
            garageReplaceGui:On("close", function()
                ESX.TriggerServerCallback("ds_garages:sendNet", function() 
                end, "checkifinUse", {garageID = garageId, override = true})
            end)
        end
    end

    garageReplaceGui:Open()
end

local function teleportToGarage(garage, garageID)
    local garageId = currentGarageID

    --Notify(translate["messages"]["verificationPending"])

    currentGarageID = garageID

    if not IsPedInAnyVehicle(playerPed, false) then
        return goIntoGarage(garage, currentGarageID)
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicleProperties = GetVehicleData(vehicle)

    if not vehicleProperties then
        return Notify(translate["messages"]["somethingWentWrong"])
    end
    if garage.blackListVehicles[vehicleProperties.model] then
        return Notify(translate["messages"]["vehicleBlacklisted"])
    end

    if garage.whitelistVehicles.enable then
        if not garage.whitelistVehicles.vehicles[vehicleProperties.model] then
            return Notify(translate["messages"]["vehicleNotWhitelisted"])
        end
    end

    ESX.TriggerServerCallback("ds_garages:sendNet", function(isOwner)

        if not isOwner and not garage.jobgarage then
            return Notify(translate["messages"]["notVehicleOwner"])
        end

        ESX.TriggerServerCallback("ds_garages:sendNet", function(inUse)
            
            if inUse then
                return Notify(translate["messages"]["garageInUse"]:format(garage.name))
            end

            ESX.TriggerServerCallback("ds_garages:sendNet", function(notFull)
                if notFull then
                    return goIntoGarage(garage, currentGarageID, vehicle)
                end

                if garage.jobgarage then
                    Notify(translate["messages"]["garageFull"]:format(garage.name))
                    return
                end

                ESX.TriggerServerCallback("ds_garages:sendNet", function(ownedVehicles)
                    local vehicles = {}

                    for _, v in pairs(ownedVehicles) do
                        vehicles[#vehicles + 1] = {
                            vehicle = json.decode(v.vehicle)
                        }
                    end

                    openGarageReplaceGui(vehicles, currentGarageID)
                end, "getVehiclesFromGarage", {garageID = currentGarageID})

            end, "addVehicleToGarage", {garageID = currentGarageID, vehicleProperties = vehicleProperties})

        end, "checkifinUse", {garageID = currentGarageID, override = false})
    end, "checkVehicleOwner", {plate = vehicleProperties.plate})
end

local function teleportToExit(vehicle, vehicleProperties)
    for _, localvehicle in pairs(localVehicles) do
        RemoveVehicle(localvehicle)
    end

    local SpawnCoords
    if not vehicle and currentGarage.FootleaveSpawnCoords then
        SpawnCoords = currentGarage.FootleaveSpawnCoords
    else
        SpawnCoords = currentGarage.leaveSpawnCoords
    end

    Debug("deleted " .. #localVehicles)

    localVehicles = {}

    ESX.Game.Teleport(playerPed, {x = SpawnCoords.position.x, y = SpawnCoords.position.y, z = SpawnCoords.position.z, heading = SpawnCoords.heading}, function()
        SetGameplayCamRelativeRotation(0.0, 0.0, SpawnCoords.heading)
        ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
            if not success then return end

            if vehicle then
                spawnVehicle(vehicleProperties, SpawnCoords)
            end

            currentAction = nil
            currentGarage = nil

            if invitedBySomeone then
                invitedBySomeone = false
                inviterID = nil
            end

            CreateThread(function ()
                -- avoid killing player
                SetEntityInvincible(playerPed, true)
                Wait(3000)
                SetEntityInvincible(playerPed, false)
            end)
        end, "closeInstance", {inviter = inviterID or false, jobgarage = currentGarage.jobgarage, garageID = currentGarageID})
    end)
end

local function leaveGarage()
    local inVehicle, vehicle, vehicleProperties
    if not currentGarage then return end

    if IsPedInAnyVehicle(playerPed, false) then
        inVehicle = true
    else
        inVehicle = false
    end

    if inVehicle and invitedBySomeone then
        return Notify(translate["messages"]["cantGetOutWithVehicle"])
    end

    if inVehicle and not invitedBySomeone then
        vehicle = GetVehiclePedIsIn(playerPed, false)
        vehicleProperties = GetVehicleData(vehicle)

        RemoveVehicle(vehicle)
        while DoesEntityExist(vehicle) do
            Wait(0)
        end
    end

    if lib.progressBar({
        duration = 2000,
        label = translate["messages"]["teleportingoutofGarage"]:format(currentGarage.name),
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then else return end

    launchFade()

    if not currentGarage.friendlyfire then
        SetPlayerInvincible(playerID, false)
    end

    if not inVehicle or invitedBySomeone then
        Debug("no vehicle with exit")
        return teleportToExit()
    end
    if not vehicleProperties then
        return Notify(translate["messages"]["somethingWentWrong"])
    end
    ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
        if not success then return end

        teleportToExit(vehicle, vehicleProperties)
    end, "leaveGarageWithVehicle", {plate = vehicleProperties.plate, garageID = currentGarageID})
end

local function openGarageGui()
    garageGui:ClearItems()

    -- avoid collisions problems with laggy world loading on client-side
    SetPlayerInvincible(playerID, true)
    FreezeEntityPosition(playerPed, true)

    local first = true

    for k, v in pairs(Config.GarageSystem.garages) do
        if v.jobgarage then goto continue end
        if first then
            first = false

            loadCamera(v.camera.position, v.camera.heading)
        end

        local bought = garages[k]

        garageGui:AddButton({
            label = v.name,
            description = translate["messages"]["descriptionGarage"]:format(#v.vehiclePositions, (not bought and translate["messages"]["labelPrice"]:format(FormatMoney(v.price)) or translate["messages"]["labelBought"])),
            enter = function ()
                if buttonLoad ~= k then
                    buttonLoad = k
                    loadCamera(v.camera.position, v.camera.heading)
                end
            end,
            select = function()
                if bought then
                    return Notify(translate["messages"]["alreadyHaveGarage"])
                end

                ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
                    if not success then
                        return Notify(translate["messages"]["notEnoughMoney"])
                    end

                    bought = true
                    garages[k] = {
                        garage = v,
                        blip = loadBlip(v.blipPosition, v.blipColor, v.blipText, v.blipSprite, v.markerDistance, v.markerType, v.markerSize, v.markerColor, v.FootEnterMarker),
                    }

                    Notify(translate["messages"]["boughtGarage"]:format(v.name, FormatMoney(v.price)))
                end, "buyGarage", {garageID = k})
            end
        })
        ::continue::
    end

    garageGui:Open()
end

local function openFriendsInviterGui()
    friendsInviterGui:ClearItems()

    ESX.TriggerServerCallback("ds_garages:sendNet", function(people)
        for _, person in pairs(people) do
            friendsInviterGui:AddButton({ label = person.name, description = translate["messages"]["notifyPlayerInvitation"],
                select = function()
                    local vehiclesToShow = {}

                    for _, v in pairs(localVehicles) do
                        vehiclesToShow[#vehiclesToShow + 1] = {
                            vehicle = v,
                            vehicleProperties = GetVehicleData(v),
                            position = GetEntityCoords(v),
                            heading = GetEntityHeading(v),
                        }
                    end

                    ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
                        if not success then
                            return Notify(translate["messages"]["somethingWentWrong"])
                        end

                        Notify(translate["messages"]["invitePlayer"]:format(person.name))
                    end, "invitePlayerToGarage", {target = person.serverID, targetPosition = currentGarage.spawnCoords.position, vehiclesToShow = vehiclesToShow, garageID = currentGarageID})
                end
            })
        end
    end, "getPossibleInvites", {garage = currentGarage})
end

local function sellGarage(formatedSalePrice)
    if #localVehicles > 0 then
        return Notify(translate["messages"]["garageContainsVehicles"])
    end

    ESX.TriggerServerCallback("ds_garages:sendNet", function (success)
        if not success then
            return Notify(translate["messages"]["somethingWentWrong"])
        end

        RemoveBlip(garages[currentGarageID].blip)
        local point = points[currentGarageID]
        function point:nearby()
        end
        garages[currentGarageID] = nil
        points[currentGarageID] = nil

        MenuV:CloseAll()
        leaveGarage()

        Notify(translate["messages"]["soldGarage"]:format(formatedSalePrice))
    end, "sellGarage", {garageID = currentGarageID})

    garageSellerGui:Close()
end

local function openGarageSellerGui()
    garageSellerGui:ClearItems()

    local formatedSalePrice = FormatMoney(currentGarage.price * currentGarage.salePourcentage)

    garageSellerGui:AddButton({
        label = translate["guis"]["manageGarage"]["buttons"]["garageSeller"]["subMenu"]["sell"] .. " (" .. formatedSalePrice .. ")",
        select = function () sellGarage(formatedSalePrice) end,
        value = garageSellerGui
    })
end

local function openGarageManagerGui()
    garageManagerGui:ClearItems()
    -- All available actions on the garage manager gui
    local GARAGE_MANAGER_ACTIONS = {
        -- Invite a friend gui
        {
            label = translate["guis"]["manageGarage"]["buttons"]["inviteAFriend"]["label"],
            description = translate["guis"]["manageGarage"]["buttons"]["inviteAFriend"]["description"],
            onSelect = openFriendsInviterGui,
            menu = friendsInviterGui
        },
        -- Sell garage gui
        {
            label = translate["guis"]["manageGarage"]["buttons"]["garageSeller"]["label"],
            description = translate["guis"]["manageGarage"]["buttons"]["garageSeller"]["description"],
            onSelect = openGarageSellerGui,
            menu = garageSellerGui
        }
    }
    for _, action in pairs(GARAGE_MANAGER_ACTIONS) do
        garageManagerGui:AddButton({
            label = action.label,
            description = action.description,
            select = function()
                action.onSelect()
                action.menu:Open()
            end,
        })
    end

    garageManagerGui:Open()
end

local function createCooldown()
    CreateThread(function()
        usedBefore = true

        Wait(3500)

        usedBefore = false
        Debug("timeout cooldown")
    end)
end

CreateThread(function()
    while true do
        local drawingmarker = false
        if IsControlJustReleased(1, 51) then -- E
            Debug("E Pressed")

            if usedBefore then goto continue end

            Debug("E Pressed Pass")
            createCooldown()

            if currentGarage then
                if nearManageGarageMarker then
                    Debug("Onpen Manage Garage Menu")
                    openGarageManagerGui()
                else
                    Debug("Leave garage")
                    leaveGarage()
                end
            else
                if canOpenGui then
                    openGarageGui()
                end

                if currentActionGarage then
                    teleportToGarage(currentActionGarage, currentActionGarageID)
                end
            end
        end

        ::continue::

        if currentGarage and  not currentGarage.jobgarage then
            local marker = currentGarage.manageGarage.marker
            drawingmarker = true

            DrawMarker(
                marker.type,
                marker.position.x,
                marker.position.y,
                marker.position.z,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                marker.size.x,
                marker.size.y,
                marker.size.z,
                marker.color.x,
                marker.color.y,
                marker.color.z,
---@diagnostic disable-next-line: param-type-mismatch
                100, false, true, 2, false, false, false, false
            )
        end

        if currentAction then
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(currentAction)
            EndTextCommandDisplayHelp(0, false, true, -1)
        end

        if drawingmarker or currentAction or currentGarage or currentActionGarage then
            Wait(0)
        else
            Wait(800)
        end
    end
end)

RegisterNetEvent("ds_garages:invite", function (data)
    Notify(translate["messages"]["invitePlayerIntoGarage"]:format(data.inviterName))

    CreateThread(function ()
        local waiting = true

        ESX.SetTimeout(2 * 60 * 1000, function()
            if waiting then
                Notify(translate["messages"]["invitationExpired"])
            end

            waiting = false
        end)

        while waiting do
            Wait(0)

            if IsControlJustReleased(1, 246) then
                waiting = false

                launchFade()

                ESX.TriggerServerCallback("ds_garages:sendNet", function(success)
                    if not success then
                        return Notify(translate["messages"]["impossibleJoiningFriendGarage"])
                    end

                    currentGarage = Config.GarageSystem.garages[data.garageID]
                    currentGarageID = data.garageID
                    currentAction = translate["messages"]["actionLeaveGarage"]
                    invitedBySomeone = true
                    inviterID = data.targetID

                    spawnLocalVehicles(data.vehiclesToShow, currentGarage, currentGarageID)

                    Notify(translate["messages"]["welcomeIntoGarage"]:format(data.inviterName))
                end, "addPlayerToInstance", {targetPosition = data.targetPosition, targetID = data.targetID, garageID = data.garageID})
            end
        end
    end)
end)

RegisterNetEvent("ds_garages:leave", leaveGarage)

AddEventHandler("ds_garages:getGarages", function (func)
    if func then
        func(Config.GarageSystem.garages)
    end
end)
