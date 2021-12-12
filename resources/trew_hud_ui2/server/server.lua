ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'toggleui', function()
end, { help = _U('toggleui') })

RegisterServerEvent('trew_hud_ui:getServerInfo')
AddEventHandler('trew_hud_ui:getServerInfo', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local job

	if xPlayer ~= nil then
		if xPlayer.job.label == xPlayer.job.grade_label then
			job = xPlayer.job.grade_label
		else
			job = xPlayer.job.label .. ': ' .. xPlayer.job.grade_label
		end

		local info = {
			job = job,
			money = xPlayer.getMoney(),
			bankMoney = xPlayer.getBank()
		}

		TriggerClientEvent('trew_hud_ui:setInfo', source, info)
	end
end)

RegisterServerEvent('trew_hud_ui:syncCarLights')
AddEventHandler('trew_hud_ui:syncCarLights', function(status)
	TriggerClientEvent('trew_hud_ui:syncCarLights', -1, source, status)
end)

RegisterServerEvent('vozilo:dodajKm')
AddEventHandler('vozilo:dodajKm', function(plate, km)
    MySQL.Async.execute('UPDATE owned_vehicles SET kilometri = @kms WHERE plate = @plate', {['@plate'] = plate, ['@kms'] = km})
end)

ESX.RegisterServerCallback('vozilo:dajKilometre', function(source, cb, plate)
	MySQL.Async.fetchAll(
		'SELECT kilometri, plate FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate
		},
		function(result)
			if #result > 0 then
				cb(result[1].kilometri)
			else
				cb(0)
			end
		end
	)
end)