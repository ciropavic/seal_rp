local playersProcessingChemicalsToHydrochloricAcid = {}

RegisterServerEvent('esx_illegal:pickedUpChemicals')
AddEventHandler('esx_illegal:pickedUpChemicals', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('chemicals')
	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		xPlayer.showNotification(_U('Chemicals_inventoryfull'))
	else
		xPlayer.addInventoryItem('chemicals', 1)
	end
end)

RegisterServerEvent('esx_illegal:ChemicalsConvertionMenu')
AddEventHandler('esx_illegal:ChemicalsConvertionMenu', function(itemName, amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xItem = xPlayer.getInventoryItem(itemName)
	local xChemicals = xPlayer.getInventoryItem('chemicals')

	if xChemicals.count < amount then
		TriggerClientEvent('esx:showNotification', src, _U('Chemicals_notenough', xItem.label))
		return
	end
	TriggerClientEvent("kemikalija:EoTiGaFreeze", src, true)
	Citizen.Wait(5000)
	TriggerClientEvent("kemikalija:EoTiGaFreeze", src, false)
	xPlayer.addInventoryItem(itemName, amount)

	xPlayer.removeInventoryItem('chemicals', amount)

	TriggerClientEvent('esx:showNotification', src, _U('Chemicals_made', xItem.label))
end)

ESX.RegisterServerCallback('esx_illegal:CheckLisense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xChemicalsLisence = xPlayer.getInventoryItem('chemicalslisence')

	if xChemicalsLisence.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)