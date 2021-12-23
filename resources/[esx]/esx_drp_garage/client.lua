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

local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local GarazaV 					= nil
local Vblip 					= nil
local PlayerData                = {}
local Blipara = nil
local Blip = nil
local Vehicles 					= {}

local this_Garage = {}


-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ProvjeriPosao()
	refreshBlips()
	Wait(1000)
	ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

--- Blips Management
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    --TriggerServerEvent('esx_jobs:giveBackCautionInCaseOfDrop')
    refreshBlips()
	ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	refreshBlips()
end)

function refreshBlips()
	while PlayerData.job == nil do
		Citizen.Wait(1)
	end
	local zones = {}
	local blipInfo = {}	
	if DoesBlipExist(Blipara) then
		RemoveBlip(Blipara)
	end
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end
	for zoneKey,zoneValues in pairs(Config.Garages)do
		if zoneValues.PrikaziBlip == 1 then
			Blip = AddBlipForCoord(zoneValues.Pos)
			SetBlipSprite (Blip, Config.BlipInfos.Sprite)
			SetBlipDisplay(Blip, 4)
			SetBlipScale  (Blip, 1.2)
			SetBlipColour (Blip, Config.BlipInfos.Color)
			SetBlipAsShortRange(Blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(zoneValues.Ime)
			EndTextCommandSetBlipName(Blip)
			
			if zoneValues.MunicipalPoundPoint ~= nil then
				if PlayerData.job.name == "automafija" then
					Blipara = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos)
					SetBlipSprite (Blipara, Config.BlipPound.Sprite)
					SetBlipDisplay(Blipara, 4)
					SetBlipScale  (Blipara, 1.2)
					SetBlipColour (Blipara, Config.BlipPound.Color)
					SetBlipAsShortRange(Blipara, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('impound_yard'))
					EndTextCommandSetBlipName(Blipara)
				end
			end
		end
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName("Vozilo se trenutno ucitava, molimo pricekajte")
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

--Menu function

function OpenMenuGarage(PointType)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	
	if PointType == 'spawn' then
		table.insert(elements,{label = _U('list_vehicles'), value = 'list_vehicles'})
	end

	if PointType == 'delete' then
		table.insert(elements,{label = _U('stock_vehicle'), value = 'stock_vehicle'})
	end

	if PointType == 'pound' then
		table.insert(elements,{label = _U('return_vehicle', Config.Price), value = 'return_vehicle'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			title    = _U('garage'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'list_vehicles') then
				ListVehiclesMenu()
			end
			if(data.current.value == 'stock_vehicle') then
				StockVehicleMenu()
			end
			if(data.current.value == 'return_vehicle') then
				ReturnVehicleMenu()
			end

			--local playerPed = GetPlayerPed(-1)
			--SpawnVehicle(data.current.value)

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end


-- View Vehicle Listings
function ListVehiclesMenu()
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
		for _,v in pairs(vehicles) do
			if this_Garage.Brod == nil then
				if v.brod == 0 then
					--ESX.TriggerServerCallback('pijaca:JelNaProdaju', function(br)
						--if not br then
							local hashVehicule = v.model
							local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
							local labelvehicle
							if v.state == 1 then
								labelvehicle = vehicleName..' <font color="green">U garazi</font>'
							elseif v.state == 2 then
								labelvehicle = vehicleName..' <font color="red">Ukradeno</font>'
							elseif v.state == 0 then
								labelvehicle = vehicleName..' <font color="red">Izvan garaze</font>'
							end    
							table.insert(elements, {label =labelvehicle , value = v})
						--end
					--end, v.plate)
				end
			else
				if v.brod == 1 then
					local hashVehicule = v.model
					local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
					local labelvehicle
					if v.state == 1 then
						labelvehicle = vehicleName..' <font color="green">U garazi</font>'
					elseif v.state == 2 then
						labelvehicle = vehicleName..' <font color="red">Ukradeno</font>'
					elseif v.state == 0 then
						labelvehicle = vehicleName..' <font color="red">Izvan garaze</font>'
					end    
					table.insert(elements, {label =labelvehicle , value = v})
				end
			end
		end
		Wait(1000)
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = _U('garage'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if data.current.value.state == 1 then
				menu.close()
				data.current.value.vehicle.model = data.current.value.model
				SpawnVehicle(data.current.value.vehicle)
			elseif data.current.value.state == 2 then
				exports.pNotify:SendNotification({ text = _U('notif_car_impounded'), queue = "right", timeout = 3000, layout = "centerLeft" })
			else
				ESX.UI.Menu.CloseAll()

				local elements2 = {
					{label = "Da $"..Config.Price, value = 'yes'},
					{label = "Ne", value = 'no'},
				}
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'plati_menu',
					{
						title    = "Zelite li platiti vracanje vozila u garazu?",
						align    = 'top-left',
						elements = elements2,
					},
					function(data2, menu2)

						
						if(data2.current.value == 'yes') then
							ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
								if hasEnoughMoney then
									menu2.close()
									TriggerServerEvent('garaza:tuljaniziraj2')
									data.current.value.vehicle.model = data.current.value.model
									SpawnVehicle(data.current.value.vehicle)
								else
									menu2.close()
									exports.pNotify:SendNotification({ text = _U('impound_not_enough_money'), queue = "right", timeout = 3000, layout = "centerLeft" })
								end
							end)
						end
						if(data2.current.value == 'no') then
							menu2.close()
						end
					end,
					function(data2, menu2)
						menu2.close()
					end
				)	
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end)
	end)
end

function reparation(prix,vehicle,vehicleProps)
	
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = _U('reparation_yes', prix), value = 'yes'},
		{label = _U('reparation_no', prix), value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			title    = _U('reparation'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				TriggerServerEvent('garaza:tuljanizirajhealth', prix)
				ranger(vehicle,vehicleProps)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification(_U('reparation_no_notif'))
			end

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end

RegisterNetEvent('garaza:ObrisiProslo')
AddEventHandler('garaza:ObrisiProslo', function()
	if GarazaV ~= nil and DoesEntityExist(GarazaV) then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
end)

RegisterNetEvent('eden_garage:vrativozilo')
AddEventHandler('eden_garage:vrativozilo', function()
	StockVehicleMenu()
end)


function ranger(vehicle,vehicleProps)
	ObrisiVozilo(vehicle)

	TriggerServerEvent('eden_garage:modifystate', vehicleProps, 1)
	exports.pNotify:SendNotification({ text = _U('ranger'), queue = "right", timeout = 3000, layout = "centerLeft" })
end

function ObrisiVozilo(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	Wait(100)
	if DoesEntityExist(vehicle) then
		local entity = vehicle
		carModel = GetEntityModel(entity)
		carName = GetDisplayNameFromVehicleModel(carModel)
		NetworkRequestControlOfEntity(entity)
				
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)
				
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
				
		if (DoesEntityExist(entity)) then 
			DeleteEntity(entity)
		end 
	end
	if this_Garage.Brod ~= nil then
		SetEntityCoords(PlayerPedId(), this_Garage.Vracanje)
		this_Garage = {}
	end
end

-- Function that allows player to enter a vehicle
function StockVehicleMenu()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
    	local coords    = GetEntityCoords(playerPed)
    	local vehicle = GetVehiclePedIsIn(playerPed,false)     
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)

		ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
			if (valid) then
						ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicules)
							local plate = vehicleProps.plate:gsub("^%s*(.-)%s*$", "%1")
							local owned = false
							for _,v in pairs(vehicules) do
								if plate == v.plate then
									ESX.TriggerServerCallback('garaza:JelIstiModel2', function(dane)
										if (dane == vehicleProps.model or dane == nil) then
											TriggerServerEvent("garaza:SpremiModel", plate, nil)
											TriggerEvent("esx_property:ProsljediVozilo", nil, nil)
											owned = true
											GarazaV = nil
											Vblip = nil
											if engineHealth < 1000 then
												local fraisRep= math.floor((1000 - engineHealth)*Config.RepairMultiplier)
												reparation(fraisRep,current,vehicleProps)
											else
												ranger(current,vehicleProps)
											end
										else
											--TriggerEvent("playradio", "https://www.youtube.com/watch?v=LIDKQmT0dCs")
											--Wait(10000)
											--TriggerEvent("stopradio")
											--ESX.ShowNotification("Greska: "..vehicleProps.model)
											--ESX.ShowNotification("Greska: "..dane)
											TriggerServerEvent("ac:MjenjanjeModela")
										end
									end, plate)
								end
							end
							Wait(1500)
							if owned == false then
								exports.pNotify:SendNotification({ text = _U('stockv_not_owned'), queue = "right", timeout = 3000, layout = "centerLeft" })
							end
						end)
			else
				exports.pNotify:SendNotification({ text = _U('stockv_not_owned'), queue = "right", timeout = 3000, layout = "centerLeft" })
			end
		end,vehicleProps)
	else		
		exports.pNotify:SendNotification({ text = _U('stockv_not_in_veh'), queue = "right", timeout = 3000, layout = "centerLeft" })
	end

end


--Function for spawning vehicle
function SpawnVehicle(vehicle)
	if GarazaV ~= nil then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
	if vehicle.model == GetHashKey("DUBSTA") then
		vehicle.model = GetHashKey("G65")
	end
	TriggerServerEvent("garaza:SpawnVozilo", vehicle, this_Garage.SpawnPoint.Pos, this_Garage.SpawnPoint.Heading, 1)
end

RegisterNetEvent('garaza:VratiVozilo')
AddEventHandler('garaza:VratiVozilo', function(nid, vehicle, tip)
	if tip == 1 then
		local attempt = 0
		while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
			Wait(1)
			attempt = attempt+1
		end
		if attempt < 100 then
			WaitForVehicleToLoad(vehicle.model)
			local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
			while not DoesEntityExist(callback_vehicle) do
				Wait(1)
				callback_vehicle = NetworkGetEntityFromNetworkId(nid)
			end
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			--SetEntityHeading(callback_vehicle, he)
			SetVehRadioStation(callback_vehicle, "OFF")
			GarazaV = nid
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
			local plate = GetVehicleNumberPlateText(callback_vehicle)
			local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
			TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
			TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
			TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
			Vblip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite (Vblip, 225)
			SetBlipDisplay(Vblip, 4)
			SetBlipScale  (Vblip, 1.0)
			SetBlipColour (Vblip, 30)
			SetBlipAsShortRange(Vblip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Vase vozilo")
			EndTextCommandSetBlipName(Vblip)
			TriggerEvent("esx_property:ProsljediVozilo", nid, Vblip)
		else
			print("Greska prilikom kreiranja vozila. NetID: "..nid)
			WaitForVehicleToLoad(vehicle.model)
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
			local callback_vehicle = veh
			if GetEntityModel(veh) == vehicle.model then
				ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
				--SetEntityHeading(callback_vehicle, he)
				SetVehRadioStation(callback_vehicle, "OFF")
				GarazaV = nid
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
				local plate = GetVehicleNumberPlateText(callback_vehicle)
				local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
				TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
				TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
				TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
				Vblip = AddBlipForEntity(callback_vehicle)
				SetBlipSprite (Vblip, 225)
				SetBlipDisplay(Vblip, 4)
				SetBlipScale  (Vblip, 1.0)
				SetBlipColour (Vblip, 30)
				SetBlipAsShortRange(Vblip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Vase vozilo")
				EndTextCommandSetBlipName(Vblip)
				TriggerEvent("esx_property:ProsljediVozilo", nid, Vblip)
			end
		end
	elseif tip == 2 then
		local attempt = 0
		while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
			Wait(1)
			attempt = attempt+1
		end
		if attempt < 100 then
			WaitForVehicleToLoad(vehicle.model)
			local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
			while not DoesEntityExist(callback_vehicle) do
				Wait(1)
			end
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			--SetEntityHeading(callback_vehicle, he)
			SetVehRadioStation(callback_vehicle, "OFF")
			local plate = GetVehicleNumberPlateText(callback_vehicle)
			TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
			TriggerServerEvent('eden_garage:modifystate2', vehicle, 0)
		else
			print("Greska prilikom kreiranja vozila. NetID: "..nid)
			WaitForVehicleToLoad(vehicle.model)
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
			local callback_vehicle = veh
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			--SetEntityHeading(callback_vehicle, he)
			SetVehRadioStation(callback_vehicle, "OFF")
			local plate = GetVehicleNumberPlateText(callback_vehicle)
			TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
			TriggerServerEvent('eden_garage:modifystate2', vehicle, 0)
		end
	end
end)

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

--Function for spawning vehicle
function SpawnPoundedVehicle(vehicle)
	ESX.TriggerServerCallback('mafija:DofatiDatum', function(br)
		if br then
			TriggerServerEvent("garaza:SpawnVozilo", vehicle, this_Garage.SpawnMunicipalPoundPoint.Pos, 226.78, 2)
			TriggerServerEvent("mafija:MakniUkraden", vehicle.plate)
			ESX.ShowNotification("Vozilo dostavljeno iz garaze!")
		else
			local vehiclePrice = 50000
			for i=1, #Vehicles, 1 do
				if vehicle.model == GetHashKey(Vehicles[i].model) then
					vehiclePrice = Vehicles[i].price
					TriggerServerEvent("mafija:OdeJedan", vehicle.plate, math.ceil(vehiclePrice*0.15))
					break
				end
			end
		end
	end, vehicle.plate)
end

-- Marker actions
AddEventHandler('eden_garage:hasEnteredMarker', function(zone)

	if zone == 'spawn' then
		CurrentAction     = 'spawn'
		CurrentActionMsg  = _U('spawn')
		CurrentActionData = {}
	end

	if zone == 'delete' then
		CurrentAction     = 'delete'
		CurrentActionMsg  = _U('delete')
		CurrentActionData = {}
	end
	
	if zone == 'pound' then
		while PlayerData.job == nil do
			Wait(1)
		end
		if PlayerData.job.name == 'automafija' then
			CurrentAction     = 'pound_action_menu'
			CurrentActionMsg  = _U('pound_action_menu')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('eden_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)


function ReturnVehicleMenu()
	if PlayerData.job.name == 'automafija' then
		ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)
			local elements = {}
			local brojac = 0
			for _,v in pairs(vehicles) do
				local hashVehicule = v.vehicle.model
				local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
				local labelvehicle

				labelvehicle = vehicleName _U('impound_list', GetLabelText(vehicleName))
				
				ESX.TriggerServerCallback('mafija:DofatiDatum', function(br)
					if br then
						table.insert(elements, {label =labelvehicle.."-"..v.vlasnik.."("..v.tablica..")", value = v.vehicle})
					else
						table.insert(elements, {label =labelvehicle.."-"..v.vlasnik.."(<font color='red'>Isteklo</font>)", value = v.vehicle})
					end
					brojac = brojac+1
				end, v.tablica)
			end
			while brojac ~= #vehicles do
				Wait(1)
			end
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'return_vehicle',
			{
				title    = _U('impound_yard'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
				menu.close()
				SpawnPoundedVehicle(data.current.value)
			end,
			function(data, menu)
				menu.close()
				--CurrentAction = 'open_garage_action'
			end)
		end)
	end
end

-- Display markers 
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)	
		local nasosta = 0
		local coords = GetEntityCoords(GetPlayerPed(-1))			

		for k,v in pairs(Config.Garages) do
			if #(coords-v.Pos) < Config.DrawDistance then
				waitara = 0
				nasosta = 1
				if v.Brod == nil then
					DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, false, false, false, false)	
				else
					DrawMarker(v.SpawnMarker.Marker, v.SpawnMarker.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMarker.Size.x, v.SpawnMarker.Size.y, v.SpawnMarker.Size.z, v.SpawnMarker.Color.r, v.SpawnMarker.Color.g, v.SpawnMarker.Color.b, 100, false, true, 2, false, false, false, false)
				end
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)	
			end
			if v.MunicipalPoundPoint ~= nil then
				if #(coords-v.MunicipalPoundPoint.Pos) < Config.DrawDistance then
					waitara = 0
					nasosta = 1
					DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)	
					DrawMarker(v.SpawnMunicipalPoundPoint.Marker, v.SpawnMunicipalPoundPoint.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMunicipalPoundPoint.Size.x, v.SpawnMunicipalPoundPoint.Size.y, v.SpawnMunicipalPoundPoint.Size.z, v.SpawnMunicipalPoundPoint.Color.r, v.SpawnMunicipalPoundPoint.Color.g, v.SpawnMunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
				end		
			end
		end	
		
		local isInMarker  = false

		for _,v in pairs(Config.Garages) do
			if v.Brod == nil then
				if #(coords-v.SpawnPoint.Pos) < v.Size.x then
					isInMarker  = true
					this_Garage = v
					currentZone = 'spawn'
				end
			else
				if #(coords-v.SpawnMarker.Pos) < v.Size.x then
					isInMarker  = true
					this_Garage = v
					currentZone = 'spawn'
				end
			end

			if #(coords-v.DeletePoint.Pos) < v.Size.x then
				isInMarker  = true
				this_Garage = v
				currentZone = 'delete'
			end
			if v.MunicipalPoundPoint ~= nil then
				if #(coords-v.MunicipalPoundPoint.Pos) < v.MunicipalPoundPoint.Size.x then
					isInMarker  = true
					this_Garage = v
					currentZone = 'pound'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('eden_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('eden_garage:hasExitedMarker', LastZone)
		end
		
		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'pound_action_menu' then
					--OpenMenuGarage('pound')
					ReturnVehicleMenu()
				end
				if CurrentAction == 'spawn' then
					OpenMenuGarage('spawn')
				end
				if CurrentAction == 'delete' then
					OpenMenuGarage('delete')
				end


				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end
		end
		
		if nasosta == 0 then
			waitara = 500
		end
	end
end)
-- Fin controle touche
