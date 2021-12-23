ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('mjenjac:ProvjeriVozilo', function(source, cb, vehicleplate)
    MySQL.Async.fetchScalar(
        'SELECT mjenjac FROM owned_vehicles WHERE plate = @pl',
        {
            ['@pl'] = vehicleplate
        },
        function(result)
            if result ~= nil then
                cb(result)
			else
				cb(0)
            end
    end)
end)