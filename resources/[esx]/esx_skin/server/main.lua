ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local spol
	if skin.skin == 0 then
		spol = "m"
	else
		spol = "z"
	end
	MySQL.Async.execute('UPDATE users SET skin = @skin, sex = @spol WHERE ID = @identifier', {
		['@skin'] = json.encode(skin),
		['@spol'] = spol,
		['@identifier'] = xPlayer.getID()
	})
end)

RegisterServerEvent('skin:SpremiPodatke')
AddEventHandler('skin:SpremiPodatke', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET firstname = @first, lastname = @last, dateofbirth = @dat WHERE ID = @identifier', {
		['@first'] = data.ime,
		['@last'] = data.prezime,
		['@dat'] = data.datum,
		['@identifier'] = xPlayer.getID()
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			else
				print(('esx_skin: %s attempted saving skin to file'):format(user.getIdentifier()))
			end
		end)
	end)

end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT skin FROM users WHERE ID = @identifier', {
		['@identifier'] = xPlayer.getID()
	}, function(users)
		local skin

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if users then
			skin = json.decode(users)
		end

		cb(skin, jobSkin)
	end)
end)

-- Commands
TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, args, user)
	TriggerClientEvent('esx_skin:openSaveableMenu', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('skin')})

TriggerEvent('es:addGroupCommand', 'skinsave', 'admin', function(source, args, user)
	TriggerClientEvent('esx_skin:requestSaveSkin', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('saveskin')})
