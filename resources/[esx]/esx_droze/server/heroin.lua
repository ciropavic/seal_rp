local playersProcessingPoppyResin = {}

RegisterServerEvent('esx_illegal:pickedUpPoppy')
AddEventHandler('esx_illegal:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem("poppyresin")
	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		xPlayer.showNotification(_U('poppy_inventoryfull'))
	else
		xPlayer.addInventoryItem('poppyresin', 1)
	end
end)

RegisterServerEvent('esx_illegal:processPoppyResin')
AddEventHandler('esx_illegal:processPoppyResin', function()
	if not playersProcessingPoppyResin[source] then
		local _source = source
		playersProcessingPoppyResin[_source] = ESX.SetTimeout(Config.Delays.HeroinProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPoppyResin = xPlayer.getInventoryItem('poppyresin')
			if xPoppyResin.count > 0 then
				local xItem2 = xPlayer.getInventoryItem("heroin")
				if xItem2.limit ~= -1 and (xItem2.count + 1) > xItem2.limit then
					xPlayer.showNotification(_U('heroin_processingfull'))
				else
					xPlayer.removeInventoryItem('poppyresin', 1)
					xPlayer.addInventoryItem('heroin', 1)
				end
			else
				xPlayer.showNotification(_U('heroin_processingenough'))
			end
			playersProcessingPoppyResin[_source] = nil
		end)
	else
		print(('esx_illegal: %s attempted to exploit heroin processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingPoppyResin[playerID] then
		ESX.ClearTimeout(playersProcessingPoppyResin[playerID])
		playersProcessingPoppyResin[playerID] = nil
	end
end

RegisterServerEvent('esx_illegal:cancelProcessing')
AddEventHandler('esx_illegal:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
