--[[

  ESX RP Chat

--]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Global = 0
local CekajZaOglas = 0
local Mute = {}

AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	CancelEvent()
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', _U('unknown_command', command_args[1]) } })
end)

ESX.RegisterServerCallback('rpchat:DohvatiMute', function(source, cb)
	local src = source
	if Mute[src] == nil then
		cb(false)
	else
		cb(true)
	end
end)

function getIdentity(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function (result)
        if result[1] ~= nil then
			local identity = result[1]
			cb({
				firstname = identity['firstname'],
				lastname = identity['lastname']
			})
		else
			cb(nil)
		end
    end)
end

 AddEventHandler('chatMessage', function(source, name, message)
	  CancelEvent()
	  if string.sub(message, 1, string.len("/")) ~= "/" then
		if Mute[source] == nil then
			  local playerName = GetPlayerName(source)
			  getIdentity(source, function (name)
				  local fal = name.firstname .. " " .. name.lastname
				  local msg = message
				  local imee = fal
				  if Global == 1 then
					  TriggerClientEvent('chat:addMessage', -1, {
							template = '(OOC) {0}:<br> {1}</div>',
							args = { imee, msg }
					  })
				  else
					local player = source
					local ped = GetPlayerPed(player)
					local koord = GetEntityCoords(ped)
					TriggerClientEvent('sendProximityMessage', -1, source, imee, msg, koord)
				  end
			  end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Morate pricekati jos "..Mute[source].." minuta do unmutea!" } })
		end
	  end
  end)
  
  
	RegisterNetEvent("PromjeniGlobal")
	AddEventHandler('PromjeniGlobal', function()
		if Global == 1 then
			TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEM ', "Chat(T) je lokalan (osobe blizu vas vide sta pisete)" } })
			Global = 0
		else
			TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEM ', "Chat(T) je globalan (svi vide sta pisete)" } })
			Global = 1
		end
	end)
  
  -- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  --    local name = getIdentity(source)
  --    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 



  --- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  ---    local name = getIdentity(source)
  ---    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 
  --[[TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    table.remove(args, 2)
    TriggerClientEvent('sendProximityMessageMe', -1, source, name.firstname, table.concat(args, " "))
end)--]]

RegisterCommand('me', function(source, args, rawCommand)
	if args[1] ~= nil then
		if Mute[source] == nil then
			getIdentity(source, function (name)
				local player = source
				local ped = GetPlayerPed(player)
				local koord = GetEntityCoords(ped)
				TriggerClientEvent('sendProximityMessageMe', -1, source, name.firstname, table.concat(args, " "), koord)
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Morate pricekati jos "..Mute[source].." minuta do unmutea!" } })
		end
	end
end, false)

RegisterCommand('do', function(source, args, rawCommand)
	if args[1] ~= nil then
		if Mute[source] == nil then
			getIdentity(source, function (name)
				local player = source
				local ped = GetPlayerPed(player)
				local koord = GetEntityCoords(ped)
				TriggerClientEvent('sendProximityMessageDo', -1, source, name.firstname, table.concat(args, " "), koord)
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Morate pricekati jos "..Mute[source].." minuta do unmutea!" } })
		end
	end
end, false)

RegisterServerEvent('rpchat:PogleMute')
AddEventHandler('rpchat:PogleMute', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		MySQL.Async.fetchScalar('SELECT mute FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local mi = result
			if mi <= 0 then
				Mute[_source] = nil
				TriggerClientEvent("BrojiMute", _source, 0)
				TriggerEvent("report:Mutan", _source, 0)
			else
				Mute[_source] = mi
				TriggerClientEvent("BrojiMute", _source, mi)
				TriggerEvent("report:Mutan", _source, mi)
			end
		end)
	end
end)

RegisterServerEvent('esx_rpchat:UnmuteGa')
AddEventHandler('esx_rpchat:UnmuteGa', function(idic)
	local id = tonumber(idic)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		Mute[id] = nil
		TriggerClientEvent("BrojiMute", id, nil)
		TriggerEvent("report:Mutan", id, nil)
		TriggerClientEvent('chat:addMessage', id, { args = { '^1SYSTEM ', " Unmuteani ste od strane admina!" } })
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Unmute ste igraca "..GetPlayerName(id).."("..id..")!" } })
		MySQL.Async.execute('UPDATE users SET mute = @mut WHERE identifier = @identifier', {
			['@mut']        = 0,
			['@identifier'] = xPlayer.identifier
		})
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Igrac nije online!" } })
	end
end)

RegisterServerEvent('esx_rpchat:MuteGa')
AddEventHandler('esx_rpchat:MuteGa', function(idic, mi)
	local id = tonumber(idic)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		local minute = tonumber(mi)
		Mute[id] = minute
		TriggerClientEvent("BrojiMute", id, mi)
		TriggerEvent("report:Mutan", id, mi)
		TriggerClientEvent('chat:addMessage', id, { args = { '^1SYSTEM ', " Utisani ste na "..mi.." minuta od strane admina!" } })
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Utisali ste igraca "..GetPlayerName(id).."("..id..") na "..mi.." minuta!" } })
		local xPlayer = ESX.GetPlayerFromId(id)

		MySQL.Async.execute('UPDATE users SET mute = @mut WHERE identifier = @identifier', {
			['@mut']        = mi,
			['@identifier'] = xPlayer.identifier
		})
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Igrac nije online!" } })
	end
end)

RegisterServerEvent('esx_rpchat:VratiMinute')
AddEventHandler('esx_rpchat:VratiMinute', function(mi)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if mi <= 0 then
		Mute[_source] =  nil
		TriggerEvent("report:Mutan", _source, nil)
		MySQL.Async.execute('UPDATE users SET mute = @mut WHERE identifier = @identifier', {
			['@mut']        = 0,
			['@identifier'] = xPlayer.identifier
		})
	else
		Mute[_source] = mi
		TriggerEvent("report:Mutan", _source, mi)
		MySQL.Async.execute('UPDATE users SET mute = @mut WHERE identifier = @identifier', {
			['@mut']        = mi,
			['@identifier'] = xPlayer.identifier
		})
	end
end)

 --[[RegisterCommand('ooc', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
        args = { playerName, msg }
    })
end, false)--]]


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
