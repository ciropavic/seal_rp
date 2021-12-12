--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('xenknight:transfer')
AddEventHandler('xenknight:transfer', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Transfer Novca',
                               'Ne mozete prebacit novac samom sebi!',
                               'CHAR_BANK_MAZE', 9)
		else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Nemate dovoljno novca za transfer!',
                                   'CHAR_BANK_MAZE', 9)
            else
				amountt = ESX.Math.Round(amountt)
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
				TriggerEvent("DiscordBot:Inventory", GetPlayerName(_source).." je transfer igracu "..GetPlayerName(to).." $"..amountt)
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Prebacili ste ~r~$' .. amountt ..
                                       '~s~ osobi ~r~' .. GetPlayerName(to) .. ' .',
                                   'CHAR_BANK_MAZE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Banka',
                                   'Transfer Novca', 'Primili ste ~r~$' ..
                                       amountt .. '~s~ od ~r~' .. GetPlayerName(_source) ..
                                       ' .', 'CHAR_BANK_MAZE', 9)
            end

        end
    end

end)


function myfirstname(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
    ['@phone_number'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end