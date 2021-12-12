Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		local naso = 0
		Citizen.Wait(waitara)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		--Kemikalije
		if GetDistanceBetweenCoords(coords, 3718.8, 4533.45, 21.67, true) < 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, 3718.8, 4533.45, 21.67, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		--Marihuana
		if GetDistanceBetweenCoords(coords, -1127.7805175781, 2707.9477539062, 18.800426483154, true) < 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, -1127.7805175781, 2707.9477539062, 18.800426483154, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if GetDistanceBetweenCoords(coords, 1066.3044433594, -3183.5666503906, -39.163639068604, true) < 1.50 then
			naso = 1
			waitara = 0
			ESX.ShowHelpNotification("Pritisnite E da izadjete sa prerade marihuane!")
			if IsControlJustReleased(0, Keys['E']) then
				SetEntityCoords(PlayerPedId(), -1127.7805175781, 2707.9477539062, 18.800426483154)
				Citizen.Wait(2000)
			end
		end
		if GetDistanceBetweenCoords(coords, -1127.7805175781, 2707.9477539062, 18.800426483154, true) < 1.50 then
			naso = 1
			waitara = 0
			ESX.ShowHelpNotification("Pritisnite E da udjete na preradu marihuane!")
			if IsControlJustReleased(0, Keys['E']) then
				SetEntityCoords(PlayerPedId(), 1066.3044433594, -3183.5666503906, -39.163639068604)
				Citizen.Wait(2000)
			end
		end
		--Meth
		if GetDistanceBetweenCoords(coords, 1454.6629638672, -1652.0268554688, 66.994934082031, true) < 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, 1454.6629638672, -1652.0268554688, 66.994934082031, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if GetDistanceBetweenCoords(coords, 996.91131591797, -3200.6354980469, -36.393661499023, true) < 1.50 then
			naso = 1
			waitara = 0
			ESX.ShowHelpNotification("Pritisnite E da izadjete sa prerade!")
			if IsControlJustReleased(0, Keys['E']) then
				SetEntityCoords(PlayerPedId(), 1454.6629638672, -1652.0268554688, 66.994934082031)
				Citizen.Wait(2000)
			end
		end
		if GetDistanceBetweenCoords(coords, 1454.6629638672, -1652.0268554688, 66.994934082031, true) < 1.50 then
			naso = 1
			waitara = 0
			ESX.ShowHelpNotification("Pritisnite E da udjete na preradu!")
			if IsControlJustReleased(0, Keys['E']) then
				SetEntityCoords(PlayerPedId(), 996.91131591797, -3200.6354980469, -36.393661499023)
				Citizen.Wait(2000)
			end
		end
		if naso == 0 and waitara == 0 then
			waitara = 500
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
	
	if Config.EnableMapsBlimps then
		local blip = AddBlipForRadius(coords, radius)

		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 1)
		SetBlipAlpha (blip, 128)

		-- create a blip in the middle
		blip = AddBlipForCoord(coords)

		SetBlipHighDetail(blip, true)
		SetBlipSprite (blip, sprite)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(text)
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
	if Config.EnableMapsBlimps then
		for k,zone in pairs(Config.CircleZones) do
			if zone.enabled then
				CreateBlipCircle(zone.blimpcoords, zone.name, zone.radius, zone.color, zone.sprite)
			end
		end
	end
end)