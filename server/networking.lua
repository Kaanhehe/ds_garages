local function receiveNet(source, netName, data)
    if not Functions[netName] then return end
    
    return Functions[netName](source, data)
end

ESX.RegisterServerCallback("ds_garages:sendNet", function(source, callback, netName, data)
    if not TypeMustBe(data, "table") then return end

    CreateThread(function ()
        callback(receiveNet(source, netName, data))
    end)
end)

