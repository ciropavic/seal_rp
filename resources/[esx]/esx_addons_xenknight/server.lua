
ESX                       = nil

local Centrala 			  = false
local IDIgraca 			  = nil
local PhoneNumbers        = {}

-- PhoneNumbers = {
--   ambulance = {
--     type  = "ambulance",
--     sources = {
--        ['1'] = true
--     }
--   }
-- }

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
	local mess = alert.message
	if alert.coords ~= nil then
		mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y..' #'..alert.numero
	end
    for k, _ in pairs(listSrc) do
      getPhoneNumber(tonumber(k), function (n)
        if n ~= nil then
          TriggerEvent('xenknight:_internalAddMessage', number, n, mess, 0, function (smsMess)
            TriggerClientEvent("xenknight:receiveMessage", tonumber(k), smsMess)
          end)
        end
      end)
    end
  end
end

AddEventHandler('esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('= INFO = Registriran novi broj ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type          = type,
    sources       = {},
    alerts        = {}
	}
end)

ESX.RegisterServerCallback('murja:JelSlobodnaCentrala', function(source, cb)
	cb(Centrala)
end)

RegisterServerEvent('murja:UCentrali')
AddEventHandler('murja:UCentrali', function(br)
    if br then
		Centrala = true
		IDIgraca = source
	else
		Centrala = false
		IDIgraca = nil
	end
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
  if lastJob.name == "sipa" then
	lastJob.name = "police"
  end
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('esx_addons_xenknight:removeSource', lastJob.name, source)
  end
  if job.name == "sipa" then
	job.name = "police"
  end
  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('esx_addons_xenknight:addSource', job.name, source)
  end
end)

AddEventHandler('esx_addons_xenknight:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_xenknight:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('xenknight:sendMessage')
AddEventHandler('xenknight:sendMessage', function(number, message)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
          message = message,
          numero = phone,
        }, PhoneNumbers[number].sources)
      end)
    end
end)

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function (number, message, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
	if number == "police" then
		if not Centrala then
			getPhoneNumber(source, function (phone) 
			  notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phone,
			  }, PhoneNumbers[number].sources)
			end)
		else
			TriggerClientEvent("mobitel:Testiraj", -1, number, message, coords)
		end
	else
		getPhoneNumber(source, function (phone) 
		  notifyAlertSMS(number, {
			message = message,
			coords = coords,
			numero = phone,
		  }, PhoneNumbers[number].sources)
		end)
	end
  else
    print('= WARNING = Appels sur un service non enregistre => numero : ' .. number)
  end
end)

RegisterServerEvent('murja:SaljiGa')
AddEventHandler('murja:SaljiGa', function (number, message, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function (phone) 
		  notifyAlertSMS(number, {
			message = message,
			coords = coords,
			numero = phone,
		  }, PhoneNumbers[number].sources)
		end)
  else
    print('= WARNING = Appels sur un service non enregistre => numero : ' .. number)
  end
end)

AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchScalar('SELECT phone_number FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result
    xPlayer.set('phoneNumber', phoneNumber)
	local posao = xPlayer.job.name
	if xPlayer.job.name == "sipa" then
		posao = "police"
	end
    if PhoneNumbers[posao] ~= nil then
      TriggerEvent('esx_addons_xenknight:addSource', posao, source)
    end
  end)

end)


AddEventHandler('esx:playerDropped', function(source)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local posao = xPlayer.job.name
  if xPlayer.job.name == "sipa" then
	posao = "police"
  end
  if PhoneNumbers[posao] ~= nil then
    TriggerEvent('esx_addons_xenknight:removeSource', posao, source)
  end
  if IDIgraca == source then
	Centrala = false
	IDIgraca = nil
  end
end)


function getPhoneNumber (source, callback) 
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then
    callback(nil)
  end
  MySQL.Async.fetchScalar('SELECT phone_number FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result)
  end)
end



RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    -- print('esx_phone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)