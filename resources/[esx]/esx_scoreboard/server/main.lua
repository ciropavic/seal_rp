ESX = nil
local connectedPlayers = {}
local Murija = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:Broji')
AddEventHandler('esx_scoreboard:Broji', function()
	Murija = Murija+1
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		Murija = 0
		TriggerClientEvent('esx_policejob:DajNaDuznosti2', -1)
		Citizen.Wait(1000)
		TriggerClientEvent('esx_scoreboard:Murija', -1, Murija)
		TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15000)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	if xPlayer ~= nil then
		local playerId = xPlayer.source
		local ping = GetPlayerPing(playerId)
		if ping and ping > 0 then
			connectedPlayers[playerId] = {}
			connectedPlayers[playerId].ping = GetPlayerPing(playerId)
			connectedPlayers[playerId].id = playerId
			connectedPlayers[playerId].name = xPlayer.getName()
			connectedPlayers[playerId].job = xPlayer.job.name

			if update then
				TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
			end
			TriggerClientEvent('esx_scoreboard:toggleID', playerId, true)
		end
	end
end

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	print(#connectedPlayers)
end

function UpdatePing()
	for playerId,v in pairs(connectedPlayers) do
		local ping = GetPlayerPing(playerId)

		if ping and ping > 0 then
			v.ping = ping
		else
			v.ping = 'missing'
		end
	end

	TriggerClientEvent('esx_scoreboard:updatePing', -1, connectedPlayers)
end

TriggerEvent('es:addGroupCommand', 'screfresh', 'admin', function(source, args, user)
	AddPlayersToScoreboard()
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nemate ovlasti.' } })
end, {help = "Refreshaj scoreboard!"})

TriggerEvent('es:addGroupCommand', 'sctoggle', 'admin', function(source, args, user)
	TriggerClientEvent('esx_scoreboard:toggleID', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nemate ovlasti.' } })
end, {help = "Dozvolite kolonu ID na scoreboardu!"})
