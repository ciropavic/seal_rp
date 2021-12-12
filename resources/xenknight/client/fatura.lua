--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================
RegisterNetEvent("xenknight:fatura_getBilling")
AddEventHandler("xenknight:fatura_getBilling", function(billingg)
  SendNUIMessage({event = 'fatura_billingg', billingg = billingg})
end)

RegisterNUICallback('fatura_getBilling', function(data, cb)
  TriggerServerEvent('xenknight:fatura_getBilling', data.label, data.amount, data.sender)
end)

RegisterNUICallback('faturapayBill', function(data)
	while ESX == nil do
		Wait(1)
	end
	ESX.TriggerServerCallback('esx_platiii:platituljanu', function()
	end, data.id)
end)


