--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================
local Oglasi = nil

function YellowGetPagess (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT * FROM yellow_tweets
	  ORDER BY time DESC LIMIT 50
      ]===], {}, cb)
  end
end

MySQL.ready(function()
	YellowGetPagess(nil, function (pagess)
		Oglasi = pagess
    end)
end)

function getUserYellow(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT identifier, firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
    ['@phone_number'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end


function YellowPostPages (phone_number, firstname, lastname, message, sourcePlayer, cb)
    getUserYellow(phone_number, firstname, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.insert("INSERT INTO yellow_tweets (`phone_number`, `firstname`, `lastname`, `message`) VALUES(@phone_number, @firstname, @lastname, @message);", {
	  ['@phone_number'] = phone_number,
	  ['@firstname'] = firstname,
	  ['@lastname'] = lastname,
      ['@message'] = message
    }, function (id)
      MySQL.Async.fetchAll('SELECT * from yellow_tweets WHERE id = @id', {
        ['@id'] = id
      }, function (pagess)
        pages = pagess[1]
        pages['firstname'] = user.firstname
        pages['phone_number'] = user.phone_number
		local ide = nil
		local xTarget = ESX.GetPlayerFromNumber(user.phone_number)
		if xTarget then
			ide = xTarget.source
			pages.ID = ide
		end
		table.insert(Oglasi, {phone_number = user.phone_number, firstname = user.firstname, lastname = lastname, message = message, time = pages.time, ID = ide})
		table.sort(Oglasi, function(a,b) return a.time > b.time end)
		if string.find(pages.message, "@anon") ~= nil then
			pages.firstname = "Anonimno"
			pages.lastname = ""
		end
		table.remove(Oglasi, #Oglasi)
        TriggerClientEvent('xenknight:yellow_newPagess', -1, pages)
      end)
    end)
  end)
end


function YellowShowError (sourcePlayer, title, message)
  TriggerClientEvent('xenknight:yellow_showError', sourcePlayer, message)
end
function YellowShowSuccess (sourcePlayer, title, message)
  TriggerClientEvent('xenknight:yellow_showSuccess', sourcePlayer, title, message)
end

RegisterServerEvent('xenknight:yellow_getPagess')
AddEventHandler('xenknight:yellow_getPagess', function(phone_number, firstname)
  local sourcePlayer = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
  if phone_number ~= nil and phone_number ~= "" and firstname ~= nil and firstname ~= "" then
    getUserYellow(phone_number, firstname, function (user)
      local accountId = user and user.id
      YellowGetPagess(accountId, function (pagess)
        TriggerClientEvent('xenknight:yellow_getPagess', sourcePlayer, pagess)
      end)
    end)
  else
    --YellowGetPagess(nil, function (pagess)
	for i=1, #Oglasi, 1 do
		if string.find(Oglasi[i].message, "@anon") ~= nil then
			Oglasi[i].firstname = "Anonimno"
			Oglasi[i].lastname = ""
		end
		local xTarget = ESX.GetPlayerFromNumber(Oglasi[i].phone_number)
		if xTarget then
			Oglasi[i].ID = xTarget.source
		end
	end
    TriggerClientEvent('xenknight:yellow_getPagess', sourcePlayer, Oglasi)
	--end)
  end
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			phone_number = identity['phone_number'],
		}
	else
		return nil
	end
end

RegisterServerEvent('xenknight:yellow_postPagess')
AddEventHandler('xenknight:yellow_postPagess', function(firstname, phone_number, lastname, message)
  local sourcePlayer = tonumber(source)
  local name = getIdentity(source)
  YellowPostPages(name.phone_number, name.firstname, name.lastname, message, sourcePlayer)
end)


function deleteYellow(id)
    MySQL.Sync.execute("DELETE FROM yellow_tweets WHERE `id` = @id", {
        ['@id'] = id
    })
end

RegisterServerEvent('xenknight:deleteYellow')
AddEventHandler('xenknight:deleteYellow', function(id)
    deleteYellow(id)
end)


