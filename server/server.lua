--[[
    Initialize
]]

local GetPlayerPed <const> = GetPlayerPed
local GetEntityCoords <const> = GetEntityCoords
local DeleteEntity <const> = DeleteEntity
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn

local function getESXLegacy()
    return exports.es_extended.getSharedObject()
end

local function getESXOld()
    local esx = nil
    TriggerEvent(Config.GarageSystem.triggers.getESX, function(object) esx = object end)
    return esx
end

ESX = Config.GarageSystem.ESXMode == "legacy" and getESXLegacy() or getESXOld()

if not ESX then return Debug("ESX not found") end
if not instance then return Debug("pmc-instance not found") end

local function loadScript()
    if Config.GarageSystem.SetIntoGarage then
        MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 1 WHERE `stored` = 0 AND `garage` IS NOT NULL")
    end

    Debug("garage loaded")
end

loadScript()


local translate <const> = Config.GarageSystem.Translation
local spawnedVehicles <const> = {}
local inUse <const> = {}
local spawning <const> = {}
local spawner = nil
local spawned <const> = {}

--[[
    Initialize Trigger Server Callbacks
--]]


local garageInstances = {}
local garageQueue = {}

local function addToQueue(element)
    garageQueue[#garageQueue + 1] = element
end

CreateThread(function()
    while true do
        for _, element in ipairs(garageQueue) do
            if garageInstances[element] then
                if #garageInstances[element]:getPlayers() == 0 then
                    garageInstances[element] = nil
                end
            end
        end

        Wait(1800000)
    end
end)

Functions = {
    -- Instance manager
    ["createInstance"] = function (source, data)
        local source <const> = source
        local sourceID <const> = tonumber(source)
        if data.jobgarage then
            targetdim = data.garageID
        else
            targetdim = tonumber(source)
        end

        if not data.garageID then return Debug("createInstance: no garageID specified") end

        if garageInstances[targetdim] and not data.jobgarage then
            if #garageInstances[targetdim]:getPlayers() > 0 then return false end
        elseif garageInstances[targetdim] and data.jobgarage then
            if spawned[targetdim] then
                garageInstances[targetdim]:addPlayer(sourceID)
                Player(source).state.garageID = data.garageID

                NotifyByWebhook(source, 'PlayerEnteredGarage', translate["messages"]["discordPlayerEnteredGarage"]:format(GetPlayerName(source), targetdim, data.garageID))
                return false
            end
        end

        garageInstances[targetdim] = instance.new(targetdim)
        garageInstances[targetdim]:addPlayer(sourceID)
        spawned[targetdim] = true
        Player(source).state.garageID = data.garageID

        NotifyByWebhook(source, 'PlayerEnteredGarage', translate["messages"]["discordPlayerEnteredGarage"]:format(GetPlayerName(source), targetdim, data.garageID))
        return true
    end,

    ["closeInstance"] = function (source, data)
        local defaultSource <const> = source
        local invited <const> = data.inviter and tonumber(defaultSource)
        local source <const> = data.inviter and data.inviter or tonumber(defaultSource)
        if data.jobgarage then
            targetdim = data.garageID
        else 
            targetdim = data.inviter and data.inviter or tonumber(defaultSource)
        end

        if not garageInstances[targetdim] then return Debug("closeInstance: instance not found") end

        Player(defaultSource).state.garageID = nil

        if data.inviter then
            Debug("closeInstance: detect been invited")

            garageInstances[data.inviter]:removePlayer(invited)
        else
            Debug("closeInstance: len=" .. #garageInstances[targetdim]:getPlayers())

            for _, playerID in pairs(garageInstances[targetdim]:getPlayers()) do
                local playerID = tostring(playerID)

                if GetPlayerPed(playerID) ~= 0 and playerID ~= tostring(targetdim) and not data.jobgarage then
                    TriggerClientEvent("ds_garages:leave", playerID)
                end
            end

            garageInstances[targetdim]:removePlayer(source)
            Debug("closeInstance: final len=" .. #garageInstances[targetdim]:getPlayers())
            addToQueue(source)
        end

        NotifyByWebhook(source, 'PlayerLeftGarage', translate["messages"]["discordPlayerLeftGarage"]:format(GetPlayerName(source), targetdim))

        return true
    end,

    ["addPlayerToInstance"] = function (source, data)
        local source <const> = source

        if not data.targetID then return Debug("addPlayerToInstance: no targetID specified") end
        if not garageInstances[data.targetID] then return Debug("addPlayerToInstance: instance not found") end
        if not data.targetPosition then return Debug("addPlayerToInstance: no targetPosition specified") end
        if not data.garageID then return Debug("addPlayerToInstance: no garageID specified") end

        garageInstances[data.targetID]:addPlayer(tonumber(source))
        Player(source).state.garageID = data.garageID
        SetEntityCoords(GetPlayerPed(source), data.targetPosition.x, data.targetPosition.y, data.targetPosition.z, false, false, false, false)

        NotifyByWebhook(source, 'PlayerJoinedGarage', translate["messages"]["discordPlayerJoinedGarage"]:format(GetPlayerName(source), source, data.garageID, GetPlayerName(tostring(data.targetID)), data.targetID))

        return true
    end,

    -- Garage logic
    ["checkVehicleOwner"] = function (source, data)
        if not data.plate then return Debug("checkVehicleOwner: plate not found") end

        return IsPlateOwner(ESX.GetPlayerFromId(source).getIdentifier(), data.plate)
    end,

    ["getGarages"] = function (source)
        local xPlayer = ESX.GetPlayerFromId(source)

        -- avoid using trigger to detect player first loaded
        while not xPlayer do
            xPlayer = ESX.GetPlayerFromId(source)

            Wait(0)
        end

        local garages = MySQL.query.await("SELECT `garage` FROM `ds_garages` WHERE `identifier` = ?", {
            xPlayer.getIdentifier()
        })

        for k, v in pairs(Config.GarageSystem.garages) do
            if v.jobgarage then
                if xPlayer.job.name == v.job then
                    table.insert(garages, k)
                end
            end
        end

        return garages
    end,

    ["buyGarage"] = function (source, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        if not data.garageID then return Debug("buyGarage: garageID not specified") end

        local garage = Config.GarageSystem.garages[data.garageID]
        if not garage then return end

        if xPlayer.getMoney() < garage.price then return end

        MySQL.insert.await("INSERT INTO `ds_garages` (`identifier`, `garage`) VALUES (?, ?)", {
            xPlayer.getIdentifier(),
            data.garageID
        })

        xPlayer.removeMoney(garage.price)
        NotifyByWebhook(source, 'PlayerBoughtGarage', translate["messages"]["discordPlayerBoughtGarage"]:format(GetPlayerName(source), source, garage.name, data.garageID))

        return true
    end,

    ["getVehiclesFromGarage"] = function(source, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        if not data.garageID then return Debug("getVehiclesFromGarage: garageID not specified") end

        local garage = Config.GarageSystem.garages[data.garageID]
        if not garage then return end
        if garage.jobgarage and data.plate then
            result = MySQL.query.await("SELECT `vehicle` FROM `owned_vehicles` WHERE `garage` = ? AND `stored` = 1 AND `plate` = ?", {
                data.garageID,
                data.plate
            })
        elseif garage.jobgarage then
            result = MySQL.query.await("SELECT `vehicle` FROM `owned_vehicles` WHERE `garage` = ? AND `stored` = 1", {
                data.garageID
            })
        else
            result = MySQL.query.await("SELECT `vehicle` FROM `owned_vehicles` WHERE `owner` = ? AND `garage` = ? AND `stored` = 1", {
                xPlayer.getIdentifier(),
                data.garageID
            })
        end

        return result
    end,

    ["addVehicleToGarage"] = function (source, data)
        local xPlayer <const> = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        if not data.garageID then return Debug("addVehicleToGarage: garageID not specified") end
        if not data.vehicleProperties then return Debug("addVehicleToGarage: vehicleProperties not specified") end

        local garage = Config.GarageSystem.garages[data.garageID]
        if not garage then return end

        if garage.blackListVehicles[data.vehicleProperties.model] then return end

        if garage.whitelistVehicles.enable then
            if not garage.whitelistVehicles.vehicles[data.vehicleProperties.model] then return end
        end

        local plate <const> = data.vehicleProperties.plate
        if not garage.jobgarage then
            if not IsPlateOwner(xPlayer.getIdentifier(), plate) then return end
        end

        if garage.jobgarage then
            local result <const> = MySQL.query.await("SELECT `plate` FROM `owned_vehicles` WHERE `garage` = ? AND `stored` = 1", {
                data.garageID
            })
            if #result == #garage.vehiclePositions then return end
            if #result >= #garage.vehiclePositions then return NotifyByWebhook(source, 'GarageOverfull', translate["messages"]["discordGarageOverfull"]:format(GetPlayerName(source), source, plate, data.garageID, #garage.vehiclePositions, #result)) end
        else
            local result <const> = MySQL.query.await("SELECT `plate` FROM `owned_vehicles` WHERE `owner` = ? AND `garage` = ? AND `stored` = 1", {
                xPlayer.getIdentifier(),
                data.garageID
            })
            if #result == #garage.vehiclePositions then return end
            if #result >= #garage.vehiclePositions then return NotifyByWebhook(source, 'GarageOverfull', translate["messages"]["discordGarageOverfull"]:format(GetPlayerName(source), source, plate, data.garageID, #garage.vehiclePositions, #result)) end
        end

        if garage.jobgarage then
            local updateQuery = "UPDATE `owned_vehicles` SET `stored` = 1, `vehicle` = ?, `garage` = ? WHERE `plate` = ?"
            local updateParams = {
                json.encode(data.vehicleProperties),
                data.garageID,
                plate
            }
            MySQL.update.await(updateQuery, updateParams)
            inUse[data.garageID] = false
        else
            local updateQuery = "UPDATE `owned_vehicles` SET `stored` = 1, `vehicle` = ?, `garage` = ? WHERE `plate` = ? AND `owner` = ?"
            local updateParams = {
                json.encode(data.vehicleProperties),
                data.garageID,
                plate,
                xPlayer.getIdentifier()
            }
            MySQL.update.await(updateQuery, updateParams)
            inUse[data.garageID] = false
        end

        NotifyByWebhook(source, 'PlayerAddedVehicle', translate["messages"]["discordPlayerAddedVehicle"]:format(GetPlayerName(source), source, plate, data.garageID))

        return true
    end,

    ["replaceVehicleFromGarage"] = function (source, data)
        local xPlayer <const> = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        if not data.garageID then return Debug("replaceVehicleFromGarage: garageID not specified") end
        if not data.vehicleProperties then return Debug("replaceVehicleFromGarage: vehiclesProperties not specified") end
        if not data.oldPlate then return Debug("replaceVehicleFromGarage: oldPlate not specified") end

        local garage <const> = Config.GarageSystem.garages[data.garageID]
        if not garage then return end

        if garage.blackListVehicles[data.vehicleProperties.model] then return end

        if garage.whitelistVehicles.enable then
            if not garage.whitelistVehicles.vehicles[vehicleProperties.model] then return end
        end

        local plate <const> = data.vehicleProperties.plate
        if not IsPlateOwner(xPlayer.getIdentifier(), plate) then return end

        if garage.jobgarage then
            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 0, `garage` = NULL WHERE `plate` = ?", {
                data.oldPlate
            })
            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 1, `vehicle` = ?, `garage` = ? WHERE `plate` = ?", {
                json.encode(data.vehicleProperties),
                data.garageID,
                plate
            })
            inUse[data.garageID] = false
        else
            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 0, `garage` = NULL WHERE `owner` = ? AND `plate` = ?", {
                xPlayer.getIdentifier(),
                data.oldPlate
            })

            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 1, `vehicle` = ?, `garage` = ? WHERE `owner` = ? AND `plate` = ?", {
                json.encode(data.vehicleProperties),
                data.garageID,
                xPlayer.getIdentifier(),
                plate
            })
            inUse[data.garageID] = false
        end

        NotifyByWebhook(source, 'PlayerReplaceVehicle', translate["messages"]["discordPlayerReplaceVehicle"]:format(GetPlayerName(source), source, data.oldPlate, plate, data.garageID))

        return true
    end,

    ["leaveGarageWithVehicle"] = function (source, data)
        local xPlayer <const> = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        if not data.plate then return Debug("leaveGarageWithVehicle: plate not specified") end
        if not data.garageID then return Debug("leaveGarageWithVehicle: garageID not specified") end
        local garage <const> = Config.GarageSystem.garages[data.garageID]
        if not garage then return end
        if garage.jobgarage then
            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 0 WHERE `plate` = ? AND `garage` = ?", {
                data.plate,
                data.garageID
            })
        else
            MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 0 WHERE `plate` = ? AND `owner` = ? AND `garage` = ?", {
                data.plate,
                xPlayer.getIdentifier(),
                data.garageID
            })
        end

        NotifyByWebhook(source, 'PlayerLeftWithVehicle', translate["messages"]["discordPlayerLeftWithVehicle"]:format(GetPlayerName(source), source, data.garageID, data.plate))

        return true
    end,

    -- Invites logic
    ["getPossibleInvites"] = function (source, data)
        local xPlayer <const> = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        local players, playersInArea = ESX.GetPlayers(), {}

        for i=1, #players, 1 do
            local target = GetPlayerPed(players[i])
            local targetCoords = GetEntityCoords(target)

            if #(data.garage.inviteFriends.areaPosition - targetCoords) <= data.garage.inviteFriends.areaDetectPlayers then
                playersInArea[#playersInArea+1] = {serverID = players[i], name = GetPlayerName(players[i])}
            end
        end

        return playersInArea
    end,

    ["invitePlayerToGarage"] = function (source, data)
        if not data.target then return Debug("invitePlayerToGarage: target not specified") end
        if not data.vehiclesToShow then return Debug("invitePlayerToGarage: vehiclesToShow not specified") end
        if not data.garageID then return Debug("invitePlayerToGarage: garageID not specified") end
        TriggerClientEvent("ds_garages:invite", data.target, {
            targetPosition = data.targetPosition,
            targetID = tonumber(source),
            inviterName = GetPlayerName(source),
            vehiclesToShow = data.vehiclesToShow,
            garageID = data.garageID,
        })

        NotifyByWebhook(source, 'PlayerInviteSomeone', translate["messages"]["discordPlayerInviteSomeone"]:format(GetPlayerName(source), source, GetPlayerName(data.target), data.target, data.garageID))

        return true
    end,

    ["sellGarage"] = function(source, data)
        if not data.garageID then return Debug("sellGarage: garageID not specified") end

        local garage <const> = Config.GarageSystem.garages[data.garageID]
        if not garage then return Debug("sellGarage: garage with ID = " .. data.garageID .. " not found") end

        local xPlayer <const> = ESX.GetPlayerFromId(source)
        if not xPlayer then return Debug("sellGarage: ESX Player not found") end

        -- Check if player owns the garage to sell
        local result <const> = MySQL.query.await("SELECT 1 FROM `ds_garages` WHERE `identifier` = ? AND `garage` = ?",
        {
            xPlayer.getIdentifier(),
            data.garageID
        })

        if not result[1] then return Debug("sellGarage: " .. xPlayer.getIdentifier() .. "tried to sell garage ID = " .. data.garageID .. " without owning it.") end

        -- Remove garage owning for the player
        MySQL.query.await("DELETE FROM `ds_garages` WHERE `identifier` = ? AND `garage` = ?", {
            xPlayer.getIdentifier(),
            data.garageID
        })

        MySQL.update.await("UPDATE `owned_vehicles` SET `garage` = NULL WHERE `owner` = ? AND `garage` = ?", {
            xPlayer.getIdentifier(),
            data.garageID
        })

        -- Define the sale price for the garage
        local salePrice <const> = garage.price * garage.salePourcentage

        xPlayer.addMoney(salePrice)
        Debug("sellGarage: sold garage for $" .. salePrice)

        return true
    end,

    ["spawnVehicle"] = function (source, data)
        if not data.vehicleProperties then return Debug("spawnVehicle: vehicleProperties not specified") end
        if not data.coords then return Debug("spawnVehicle: coords not specified") end

        local vehicle <const> = SpawnVehicle(source, data.vehicleProperties.model,
            {
                x = data.coords.position.x,
                y = data.coords.position.y,
                z = data.coords.position.z,
                w = data.coords.heading,
            },
        true)

        while not DoesEntityExist(vehicle) do
            Wait(0)
        end

        return NetworkGetNetworkIdFromEntity(vehicle)
    end,

    ["spawnVehicles"] = function (source, data)
        if data.done then
            spawning[data.garageID] = false
            spawner = nil
            return
        end
        if not data.vehicleProperties then return Debug("spawnVehicle: vehicleProperties not specified") end
        if not data.coords then return Debug("spawnVehicle: coords not specified") end

        if not spawning[data.garageID] then
            spawning[data.garageID] = true
            spawner = source
        elseif spawning[data.garageID] and spawner ~= source then
            return "spawning"
        end

        local vehicle <const> = SpawnVehicle(source, data.vehicleProperties.model,
            {
                x = data.coords.position.x,
                y = data.coords.position.y,
                z = data.coords.position.z,
                w = data.coords.heading,
            },
        false)

        while not DoesEntityExist(vehicle) do
            Wait(0)
        end

        FreezeEntityPosition(vehicle, true)

        table.insert(spawnedVehicles, vehicle)

        return NetworkGetNetworkIdFromEntity(vehicle)
    end,
    
    ["checkifinUse"] = function (source, data)
        if not data.garageID then return Debug("checkifinUse: garageID not specified") end
        ESX.SetTimeout(5000, function()
            inUse[data.garageID] = false
        end)
        if data.override then
            inUse[data.garageID] = false
            return false
        end
        if inUse[data.garageID] then
            return true
        else
            inUse[data.garageID] = true
            return false
        end
    end
}

AddEventHandler('onResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for _, vehicle in ipairs(spawnedVehicles) do
        DeleteEntity(NetworkGetEntityFromNetworkId(vehicle))
        DeleteEntity(vehicle)
    end
end)


--[[
    Events Handlers
]]


AddEventHandler("playerDropped", function()
    OnPlayerDrop()
end)

RegisterNetEvent("ds_garages:deleteVehicle", function()
    local vehicle <const> = GetVehiclePedIsIn(GetPlayerPed(source), false)
    if not vehicle then return end

    DeleteEntity(NetworkGetEntityFromNetworkId(vehicle))
    DeleteEntity(vehicle)
end)