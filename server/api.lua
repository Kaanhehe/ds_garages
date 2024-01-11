--[[
    Wants to custom the event when a player disconnect?
    Here you can do whatever you want, like set the garage vehicles which are out into a carpound
    stored: 0 equals vehicle out
    stored: 1 equals vehicle parked in garage
]]
function OnPlayerDrop()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if Config.GarageSystem.teleportToGarageExitOnDisconnect then
        local garageID = Player(source).state.garageID
        if not Config.GarageSystem.garages[garageID] then return end

        local currentPosition = {x = Config.GarageSystem.garages[garageID].leaveSpawnCoords.position.x, y = Config.GarageSystem.garages[garageID].leaveSpawnCoords.position.y, z = Config.GarageSystem.garages[garageID].leaveSpawnCoords.position.z}
        currentPosition["heading"] = Config.GarageSystem.garages[garageID].leaveSpawnCoords["heading"]

        Wait(2000)
        MySQL.update.await("UPDATE `users` SET `position` = ? WHERE `identifier` = ?", {json.encode(currentPosition), xPlayer.getIdentifier()})
    end

    if Config.GarageSystem.SetIntoGarageOnReconnect then
        MySQL.update.await("UPDATE `owned_vehicles` SET `stored` = 1 WHERE `stored` = 0 AND `owner` = ? AND `garage` IS NOT NULL", {xPlayer.getIdentifier()})
    end
end

--[[
    Wants to custom the verification of plate ownership?
    Here you can do whatever you want as long as you know what you are doing.

    Important:
    If it returns a value which can be considered as a true boolean the script logic will think the player own the plate.
]]
function IsPlateOwner(identifier, plate)
    return MySQL.scalar.await("SELECT * FROM `owned_vehicles` WHERE `plate` = ? AND `owner` = ?", {plate, identifier})
end

function NotifyByWebhook(source, event, description)
    if Config.GarageSystem.UseOxlibLogger then
        player = ESX.GetPlayerFromId(source).getIdentifier()
        lib.logger(player, event, description)
        return
    else
        if not Config.GarageSystem.discord.enable then return end
        if not Config.GarageSystem.discord["webhookURL"] then return Debug("No Webhook URL") end
        PerformHttpRequest(
            Config.GarageSystem.discord["webhookURL"],
            function(err, text, headers) 
                if err ~= 0 then
                    Debug("Error occurred while sending HTTP request: " .. err)
                end
            end,
            "POST",
            json.encode({ username = Config.GarageSystem.discord["username"], embeds = {
                {
                    ["color"] = Config.GarageSystem.discord["color"],
                    ["title"] = Config.GarageSystem.discord["title"],
                    ["description"] = description
                }
            } }), { ["Content-Type"] = "application/json" }
        )
    end
end

function SpawnVehicle(source, model, coords, warpInto)
    local ped = GetPlayerPed(source)

    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
    while not DoesEntityExist(vehicle) do
        Wait(0)
    end

    if warpInto then
        while GetVehiclePedIsIn(ped, false) ~= vehicle do
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
            Wait(0)
        end
    end

    while NetworkGetEntityOwner(vehicle) ~= source do
        Wait(0)
    end

    return vehicle
end
