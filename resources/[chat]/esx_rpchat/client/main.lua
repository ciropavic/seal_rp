--[[

  ESX RP Chat

--]]

ESX = nil
local perm = nil
local Minute = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	TriggerServerEvent("rpchat:PogleMute")
end)

AddEventHandler("playerSpawned", function()
	Wait(1000)
	TriggerServerEvent("rpchat:PogleMute")
end)

RegisterNetEvent('BrojiMute')
AddEventHandler('BrojiMute', function(mi)
	Minute = mi
	while Minute ~= nil and Minute > 0 do
		Wait(60000)
		Minute = Minute-1
		TriggerServerEvent("esx_rpchat:VratiMinute", Minute)
	end
end)

RegisterNetEvent('rpchat:SaljiTweet')
AddEventHandler('rpchat:SaljiTweet', function(name, message, id)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0} ({2}):<br> {1}</div>',
				args = { name, message, id }
			})
		else
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
				args = { name, message }
			})
		end
end)

RegisterNetEvent('rpchat:SaljiAnon')
AddEventHandler('rpchat:SaljiAnon', function(name, message)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
        			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @Anonymous ({0}):<br> {1}</div>',
        			args = { name, message}
    			})
		else
			TriggerEvent('chat:addMessage', {
        			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @Anonymous:<br> {1}</div>',
        			args = { name, message}
    			})
		end
end)

RegisterNetEvent('rpchat:SaljiOglas')
AddEventHandler('rpchat:SaljiOglas', function(name, message, broj)
		--local msg = message.." Broj: "..broj
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px;"><i class="fas fa-ad"></i> Oglas ({0}):<br> {1} | Broj: {2}<br></div>',
					args = { name, message, broj }
				})
		else
			TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px;"><i class="fas fa-ad"></i> Oglas:<br> {1} | Broj: {2}<br></div>',
					args = { name, message, broj }
				})
		end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message, koord)
	if Minute <= 0 then
	  local myId = PlayerId()
	  local pid = GetPlayerFromServerId(id)
	  if pid == myId then
		TriggerEvent('chat:addMessage', {
					template = '{0}: {1}',
					args = { name, message }
		})
	  elseif #(GetEntityCoords(GetPlayerPed(myId))-koord) < 19.999 then
		TriggerEvent('chat:addMessage', {
					template = '{0}: {1}',
					args = { name, message }
		})
	  end
	else
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM ', " Morate pricekati jos "..Minute.." minuta do unmutea!" } })
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message, koord)
		local myId = PlayerId()
		local pid = GetPlayerFromServerId(id)
		if pid == myId then
			--TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
			TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 204, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> **{0} (/me):<br> {1}</div>',
					args = { name, message }
			})
		elseif #(GetEntityCoords(GetPlayerPed(myId))-koord) < 19.999 then
			--TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
			TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 204, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> **{0} (/me):<br> {1}</div>',
					args = { name, message }
			})
		end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message, koord)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    --TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> (({0})) (/do):<br> {1}</div>',
            args = { name, message }
	})
  elseif #(GetEntityCoords(GetPlayerPed(myId))-koord) < 19.999 then
    --TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> (({0})) (/do):<br> {1}</div>',
            args = { name, message }
	})
  end
end)

--[[AddEventHandler('esx-qalle-chat:me', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 125, 188, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> {0}:<br> {1}</div>',
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 15.4 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 125, 188, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> {0}:<br> {1}</div>',
            args = { name, message }
        })
    end
end)--]]