ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil

RegisterServerEvent('lscs:kupiPeraje')
AddEventHandler('lscs:kupiPeraje', function(model, price, veh)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	if Config.IsMechanicJobOnly then

		--local societyAccount = nil
		--TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			--societyAccount = account
		--end)
		--if price < societyAccount.money then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			--societyAccount.removeMoney(price)
			price = 1.30*price
			TriggerClientEvent('esx_meha:PucajCijenu', _source, veh, price)
		--else
			--TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			--TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		--end

	else

		if price < xPlayer.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end

	end
end)

RegisterServerEvent('meh:PromjeniMjenjac')
AddEventHandler('meh:PromjeniMjenjac', function(br, plate)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `mjenjac` = @mj WHERE `plate` = @plate',
	{
		['@plate']   = plate,
		['@mj'] = br
	})
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."(".._source..") je pokusao zamjeniti model vozila!")
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT model, price, category FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price,
					category = result[i].category
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)