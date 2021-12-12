--[[Citizen.CreateThread(function()
	local isDead = false

	while true do
		Citizen.Wait(10)

		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()
			if not isDead then
				if IsPedFatallyInjured(playerPed) then
					isDead = true
					
					local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
					local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

					if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
						PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
					else
						PlayerKilled(deathCause)
					end
				end
			else
				if not IsPedFatallyInjured(playerPed) then
					isDead = false
				end
			end
		end
	end
end)]]

RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function(ktype, koord)
	local playerPed = PlayerPedId()
    local deathCause = GetPedCauseOfDeath(playerPed)
	PlayerKilled(deathCause)
end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(kid, ostalo)
	local playerPed = PlayerPedId()
    local deathCause = GetPedCauseOfDeath(playerPed)
	PlayerKilledByPlayer(kid, GetPlayerFromServerId(kid), deathCause)
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = ESX.Math.Round(killerCoords.x, 1), y = ESX.Math.Round(killerCoords.y, 1), z = ESX.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = ESX.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled(deathCause)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end