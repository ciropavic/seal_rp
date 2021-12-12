--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================

function TchatGetMessageChannel (channel, cb)
    MySQL.Async.fetchAll("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
end

function TchatAddMessage (channel, message)
  local xPlayer = ESX.GetPlayerFromId(source)
  local Query = "INSERT INTO phone_app_chat (`channel`, `message`, `identifier`) VALUES(@channel, @message, @ident);"
  local Query2 = 'SELECT * from phone_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message,
	['@ident'] = xPlayer.identifier
  }
  MySQL.Async.insert(Query, Parameters, function (id)
    MySQL.Async.fetchAll(Query2, { ['@id'] = id }, function (reponse)
		if reponse[1].identifier ~= nil then
			local playa = ESX.GetPlayerFromIdentifier(reponse[1].identifier)
			if playa ~= nil then
				reponse[1].ID = playa.source
			end
		end
		TriggerClientEvent('xenknight:tchat_receive', -1, reponse[1])
    end)
  end)
end


RegisterServerEvent('xenknight:tchat_channel')
AddEventHandler('xenknight:tchat_channel', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    for i=1, #messages, 1 do
		if messages[i].identifier ~= nil then
			local playa = ESX.GetPlayerFromIdentifier(messages[i].identifier)
			if playa ~= nil then
				messages[i].ID = playa.source
			end
		end
	end
    TriggerClientEvent('xenknight:tchat_channel', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('xenknight:tchat_addMessage')
AddEventHandler('xenknight:tchat_addMessage', function(channel, message)
  TchatAddMessage(channel, message)
end)