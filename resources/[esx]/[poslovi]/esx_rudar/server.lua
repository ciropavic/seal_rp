ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_mining:getItem')
AddEventHandler('esx_mining:getItem', function(st, tip)
    local xPlayer, randomItem = ESX.GetPlayerFromId(source), Config.Items[math.random(1, #Config.Items)]
    if math.random(0, 100) <= Config.ChanceToGetItem then
        TriggerEvent("esx_firme:DajSkladistu2", st, 1, tip)
        xPlayer.showNotification("Vasa firma je dobila 1g zeljeza")
    end
end)