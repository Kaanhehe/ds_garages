--[[
    Utils
]]

-- Money formating
function FormatMoney(money)
    local left, num, right = string.match(money,'^([^%d]*%d)(%d*)(.-)$')

	return left .. (num:reverse():gsub('(%d%d%d)','%1' .. "."):reverse()) .. right .. "$"
end

function CleanStringFromSyntaxes(str) -- Syntax doesnt work with some Notifys but too lazy to remove it from every language file
    local replacements = {
        ['~w~'] = '',
        ['~y~'] = '',
        ['~r~'] = '',
        ['~g~'] = '',
        ['~o~'] = '',
        ['~p~'] = '',
        ['~b~'] = '',
        ['~c~'] = '',
        ['~s~'] = '',
        ['~h~'] = '',
        ['~u~'] = '',
        ['~m~'] = '',
        ['~n~'] = '',
      }
  
    for k, v in pairs(replacements) do
      str = str:gsub("%"..k, v)
    end
  
    return str
end

-- Wants to custom the notification? It's here !
function Notify(message)
    --ESX.ShowNotification(message)
    local newMsg = CleanStringFromSyntaxes(message)
    lib.notify({
        title = 'Garage',
        description = newMsg,
        type = 'info'
    })
end

-- Delete vehicle (when you enter the garage and leave it)
function RemoveVehicle(vehicle)
    DeleteVehicle(vehicle)

    -- Needed to remove the vehicles which doesn't want to be deleted client-side for some dark reason
    if not DoesEntityExist(vehicle) then return end
    TriggerServerEvent("ds_garages:deleteVehicle", NetworkGetNetworkIdFromEntity(vehicle))
end

--[[
    IMPORTANT:
    The vehicle data will be managed in the `vehicle` column of `owned_vehicles` table, it will get and update this column.
    Be careful.
]]

-- If you want to custom the way to get vehicle data, this is where you can.
function GetVehicleData(vehicle)
    if DoesEntityExist(vehicle) then
        return lib.getVehicleProperties(vehicle)
    else
        return
    end
end

-- If you want to custom the way to set vehicle data, this is where you can.
function SetVehicleData(vehicle, props)
    if DoesEntityExist(vehicle) then
        lib.setVehicleProperties(vehicle, props)
    end
end
