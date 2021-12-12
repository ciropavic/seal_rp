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

RegisterNetEvent("xenknight:yellow_getPagess")
AddEventHandler("xenknight:yellow_getPagess", function(pagess)
	if perm > 0 then
		for i=1, #pagess, 1 do
			if string.find(pagess[i].lastname, "ID:") == nil and pagess[i].ID ~= nil then
				pagess[i].lastname = pagess[i].lastname.." (ID: "..pagess[i].ID..")"
			end
		end
	end
	SendNUIMessage({event = 'yellow_pagess', pagess = pagess})
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

RegisterNetEvent("xenknight:yellow_newPagess")
AddEventHandler("xenknight:yellow_newPagess", function(pages)
	hasPhone(function (hasPhone)
		if hasPhone == true then
			if perm > 0 then
				if string.find(pages.lastname, "ID:") == nil and pages.ID ~= nil then
					pages.lastname = pages.lastname.." (ID: "..pages.ID..")"
				end
			end
			SendNUIMessage({event = 'yellow_newPages', pages = pages})
		end
	end)
end)

RegisterNetEvent("xenknight:yellow_showError")
AddEventHandler("xenknight:yellow_showError", function(title, message)
  SendNUIMessage({event = 'yellow_showError', message = message, title = title})
end)

RegisterNetEvent("xenknight:yellow_showSuccess")
AddEventHandler("xenknight:yellow_showSuccess", function(title, message)
  SendNUIMessage({event = 'yellow_showSuccess', message = message, title = title})
end)

RegisterNUICallback('yellow_getPagess', function(data, cb)
  TriggerServerEvent('xenknight:yellow_getPagess', data.firstname, data.phone_number)
end)

RegisterNUICallback('yellow_postPages', function(data, cb)
	ESX.TriggerServerCallback('rpchat:DohvatiMute', function(odg)
		if not odg then
			TriggerServerEvent('xenknight:yellow_postPagess', data.firstname or '', data.phone_number or '', data.lastname or '', data.message)
		else
			ESX.ShowNotification("Utisani ste!")
		end
	end)
end)

RegisterNUICallback('deleteYellow', function(data)
  TriggerServerEvent('xenknight:deleteYellow', data.id)
end)



