--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updateBankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]

-- ES / ESX Implementation
inMenu                      = true
local bank = 0
local firstname = ''
local JelZatvoreno = false
local PrviSpawn = false
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		ESX.TriggerServerCallback('banke:JesteZatvorene', function(br)
			JelZatvoreno = br
		end)
		PrviSpawn = true
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setBankBalance(account.money)
                  break
            end
      end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)

RegisterNetEvent('ZatvoreneBanke')
		AddEventHandler('ZatvoreneBanke', function(br)
			JelZatvoreno = br
		end)

--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	if not JelZatvoreno then
		TriggerServerEvent('xenknight:transfer', data.to, data.amountt)
	else
		ESX.ShowAdvancedNotification('BANKA', 'Obavijest', 'Zbog pljacke jedne od nasih poslovnica nismo u stanju trenutno odradjivati transakcije novca!', "CHAR_BANK_FLEECA", 2)
	end
end)









