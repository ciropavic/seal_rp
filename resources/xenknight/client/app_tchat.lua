--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================
local perm = 0
Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
	end
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

local prvispawn = false
AddEventHandler("playerSpawned", function()
	if not prvispawn then
		ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
			perm = br
		end)
		prvispawn = true
	end
end)

function hasPhone (cb)
	if (ESX == nil) then return cb(false) end
	ESX.TriggerServerCallback('xenknight:getItemAmount', function(imal)
		cb(imal)
	end)
end

RegisterNetEvent("xenknight:tchat_receive")
AddEventHandler("xenknight:tchat_receive", function(message)
	hasPhone(function (hasPhone)
        if hasPhone == true then
			if perm > 0 then
				if message.ID ~= nil then
					message.message = message.message.." (ID: "..message.ID..")"
				end
			end
			SendNUIMessage({event = 'tchat_receive', message = message})
		end
	end)
end)

RegisterNetEvent("xenknight:tchat_channel")
AddEventHandler("xenknight:tchat_channel", function(channel, messages)
	if perm > 0 then
		for i=1, #messages, 1 do
			if messages[i].ID ~= nil then
				messages[i].message = messages[i].message.." (ID: "..messages[i].ID..")"
			end
		end
	end
	SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('xenknight:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('xenknight:tchat_channel', data.channel)
end)
