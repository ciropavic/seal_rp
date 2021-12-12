Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) then
			local veh = GetVehiclePedIsIn(ped, false)
			if veh ~= nil then
				if GetVehicleClass(veh) == 18 then
					SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(ped, false), 70.0)                
				end
			end
		end
	end
end)

print('[CADOJRP][PoliceBoost] Started!')