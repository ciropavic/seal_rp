local Keys = {
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

ESX =					nil
local Vehicles =		{}
local PlayerData		= {}
local lsMenuIsShowed	= false
local isInLSMarker		= false
local myCar				= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_lscustom:installMod')
AddEventHandler('esx_lscustom:installMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if (GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId()) then
		vehicle = GetPlayersLastVehicle(PlayerPedId())
	end
	ESX.Game.SetVehicleProperties(vehicle, myCar)
	if not (myCar.modTurbo) then
		ToggleVehicleMod(vehicle,  18, false)
	end
	if not (myCar.modXenon) then
		ToggleVehicleMod(vehicle,  22, false)
	end
	if not (myCar.windowTint) then
		SetVehicleWindowTint(vehicle, 0)
	end
end)

function OpenLSMenu(elems, menuName, menuTitle, parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		title    = menuTitle,
		align    = 'top-left',
		elements = elems
	}, function(data, menu)
		local isRimMod, found, isMjenjac, isSvijetla, isDodaci, isSwap = false, false, false, false, false, false
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local tablica = vehicleProps.plate

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end
		
		if data.current.modType == "mjenjac" then
			isMjenjac = true
		end
		
		if data.current.modType == "swap" then
			isSwap = true
		end
		
		if data.current.modType == "dodaci" then
			isDodaci = true
		end
		
		if data.current.modType == "svijetlaColor" then
			isSvijetla = true
		end

		for k,v in pairs(Config.Menus) do

			if k == data.current.modType or isRimMod or isMjenjac or isSvijetla or isDodaci or isSwap then

				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					ESX.ShowNotification(_U('already_own', data.current.label))
					TriggerEvent('esx_lscustom:installMod')
				else
					local vehiclePrice = 50000

					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							vehiclePrice = Vehicles[i].price
							break
						end
					end

					if isRimMod then
						price = math.floor(vehiclePrice * data.current.price / 800)
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 800)
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
					elseif v.modType == 17 then
						price = math.floor(vehiclePrice * v.price[1] / 800)
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
					elseif isSvijetla then
						price = math.floor(vehiclePrice * 1.10 / 800)
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
					elseif isMjenjac then
						price = 5000
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
						if data.current.modNum == 1 then
							ESX.ShowNotification("Kupio si automatski mjenjac!")
							TriggerEvent("EoTiIzSalona", 1)
						elseif data.current.modNum == 2 then
							ESX.ShowNotification("Kupio si rucni mjenjac!")
							TriggerEvent("EoTiIzSalona", 2)
						end
						local globalplate = GetVehicleNumberPlateText(vehicle)
						TriggerServerEvent("meh:PromjeniMjenjac", data.current.modNum, globalplate)
					elseif isSwap then
						price = 5000
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
						if data.current.modNum == 1 then
							ESX.ShowNotification("Kupio si v10 motor!")
							SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", 1.800000)
							SetVehicleHandlingInt(vehicle, "CHandlingData", "nInitialDriveGears", 6)
							SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", 230.000000)
							SetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift", 6.000000)
							SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia", 1.000000)
							SetVehicleMaxSpeed(vehicle, 230.0)
							ForceVehicleEngineAudio(vehicle, "BANSHEE2")
							SetVehRadioStation(vehicle, "OFF")
						end
					elseif isDodaci then
						price = 50
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
						SetVehicleExtra(vehicle, data.current.modNum, data.current.odradi)
					else
						price = math.floor(vehiclePrice * v.price / 800)
						TriggerServerEvent("lscs:kupiPeraje", GetEntityModel(vehicle), price, tablica)
						TriggerServerEvent("DiscordBot:Mehanicari", GetPlayerName(PlayerId()).." je kupio dio za $"..price)
					end
				end

				menu.close()
				found = true
				break
			end

		end

		if not found then
			GetAction(data.current)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		TriggerEvent('esx_lscustom:cancelInstallMod')

		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDoorsShut(vehicle, false)

		if parent == nil then
			lsMenuIsShowed = false
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			FreezeEntityPosition(vehicle, false)
			myCar = {}
		end
	end, function(data, menu) -- on change
		UpdateMods(data.current)
	end)
end

function UpdateMods(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if data.modType ~= nil then
		local props = {}
		
		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end
		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 50000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k,v in pairs(Config.Menus) do
		if data.value == k then
			menuName  = k
			menuTitle = v.label
			parent    = v.parent
			if data.value == "svijetlaColor" and not currentMods.modXenon then
				ESX.ShowNotification("Vozilo mora imati ugradjena xenon svijetla!")
				return
			end

			if v.modType ~= nil then
				
				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
				elseif v.modType == 17 then
					table.insert(elements, {label = " " .. _U('no_turbo'), modType = k, modNum = false})
 				else
					if v.modType ~= "mjenjac" and v.modType ~= "dodaci" then
						table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
					end
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor((vehiclePrice * v.price / 800)*1.30)
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor((vehiclePrice * v.price / 800)*1.30)
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- NEON
					local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						price = math.floor((vehiclePrice * v.price / 800)*1.30)
						_label = _U('neon') .. ' - <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor((vehiclePrice * v.price / 800)*1.30)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor((vehiclePrice * v.price / 800)*1.30)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'swap' then
					local globalplate  = GetVehicleNumberPlateText(vehicle)
					local _label = ''
					price = 5000*1.30
					if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
						_label = 'v10 motor - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = 1})
					end
				elseif v.modType == 'mjenjac' then
					local globalplate  = GetVehicleNumberPlateText(vehicle)
					local _label = ''
					price = 5000*1.30
					if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
						ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
							if mj == 1 then
								_label = 'Automatski mjenjac - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = 'Automatski mjenjac - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = 1})
							if mj == 2 then
								_label = 'Rucni mjenjac - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = 'Rucni mjenjac - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = 2})
						end, globalplate)
					end
					Wait(200)
				elseif v.modType == 'dodaci' then
					local globalplate  = GetVehicleNumberPlateText(vehicle)
					local _label = ''
					price = 50
					if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
						for i = 1, 14 do
							if DoesExtraExist(vehicle, i) then
								if IsVehicleExtraTurnedOn(vehicle, i) then
									_label = 'Dodatak #'..i..' - <span style="color:cornflowerblue;">'.. 'instalirano' ..' $'..price..'</span>'
									table.insert(elements, {label = _label, modType = k, modNum = i, odradi = true})
								else
									_label = 'Dodatak #'..i..' - <span style="color:green;">$' .. price .. ' </span>'
									table.insert(elements, {label = _label, modType = k, modNum = i, odradi = false})
								end
							end
						end
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor((vehiclePrice * v.price / 800)*1.30)
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 800)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price*1.30 .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					SetVehicleModKit(vehicle, 0)
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					if modCount > 0 then
						for j = 0, modCount, 1 do
							local _label = ''
							if j == currentMods[k] then
								_label = _U('level', j+1) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								if v.price[j+1] == nil then
									v.price[j+1] = v.price[j]+30
								end
								price = math.floor((vehiclePrice * v.price[j+1] / 800)*1.30)
								_label = _U('level', j+1) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
							if j == modCount-1 then
								break
							end
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor((vehiclePrice * v.price[1] / 800)*1.30) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor((vehiclePrice * v.price / 800)*1.30)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'svijetlaColor' then
					for j=1, 12, 1 do
						price = math.floor((vehiclePrice * 1.10 / 800)*1.30)
						if j == 1 then
							local ime = GetSvijetla(-1)
							_label = ime .. ' - <span style="color:green;">$' .. price .. ' </span>'
							if -1 == currentMods[k] then
								_label = ime .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = ime .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = -1})
						else
							local ime = GetSvijetla(j-1)
							_label = ime .. ' - <span style="color:green;">$' .. price .. ' </span>'
							if j-1 == currentMods[k] then
								_label = ime .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								_label = ime .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j-1})
						end
					end
				end
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent)
end

-- Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		if v.PBlip == 1 then
			local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
			SetBlipSprite(blip, 72)
			SetBlipScale(blip, 0.8)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local coords      = GetEntityCoords(PlayerPedId())
			local currentZone = nil
			local zone 		  = nil
			local lastZone    = nil
			local benny 	  = false
			if (PlayerData.job ~= nil and PlayerData.job.name == 'mechanic') or Config.IsMechanicJobOnly == false then
				for k,v in pairs(Config.Zones) do
					if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) and lsMenuIsShowed == false then
						naso = 1
						waitara = 0
						isInLSMarker  = true
						ESX.ShowHelpNotification(v.Hint)
						if k == "ls6" then
							benny = true
						end
						break
					else
						isInLSMarker  = false
					end
				end
			end

			if IsControlJustReleased(0, Keys['E']) and not lsMenuIsShowed and isInLSMarker then
				if (PlayerData.job ~= nil and PlayerData.job.name == 'mechanic') or Config.IsMechanicJobOnly == false then
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					local JelRazz = false
					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							if Vehicles[i].category == "razz" then
								JelRazz = true
							end
							break
						end
					end
					if not JelRazz or benny then
						lsMenuIsShowed = true

						FreezeEntityPosition(vehicle, true)

						myCar = ESX.Game.GetVehicleProperties(vehicle)

						ESX.UI.Menu.CloseAll()
						GetAction({value = 'main'})
					else
						ESX.ShowNotification("Ne mozete tunirati Razz Motoring vozilo!")
					end
				end
			end

			if isInLSMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
			end

			if not isInLSMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
			end

		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if lsMenuIsShowed then
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F7'], true)
			DisableControlAction(2, Keys['F'], true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)
