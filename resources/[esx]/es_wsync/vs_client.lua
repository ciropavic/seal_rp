CurrentWeather = 'CLEAR'
local lastWeather = CurrentWeather
local minute = 0
local timer = 0
local sati = 0
local blackout = false

RegisterNetEvent('es_wsync:updateWeather')
AddEventHandler('es_wsync:updateWeather', function(NewWeather, newblackout)
	CurrentWeather = NewWeather
	blackout = newblackout
end)

Citizen.CreateThread(function()
	while true do
		if lastWeather ~= CurrentWeather then
			lastWeather = CurrentWeather
			SetWeatherTypeOverTime(CurrentWeather, 15.0)
			Citizen.Wait(15000)
		end
		Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
		--SetBlackout(blackout)
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(lastWeather)
		SetWeatherTypeNow(lastWeather)
		SetWeatherTypeNowPersist(lastWeather)
		if lastWeather == 'XMAS' then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end
	end
end)

RegisterNetEvent('es_wsync:updateTime')
AddEventHandler('es_wsync:updateTime', function(s, m)
	sati = s
	minute = m
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		NetworkOverrideClockTime(sati, minute, 0)
	end
end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('es_wsync:requestSync')
end)
