local HasAlreadyEnteredMarker, IsInShopMenu = false, false
local CurrentAction, CurrentActionMsg, LastZone, CurrentVehicleData
local CurrentActionData, Vehicles, Categories = {}, {}, {}
local currentDisplayVehicle = nil

local VoziloID 				  = nil
local UTestu 				  = 0
local Vrijeme 				  = 0
local GarazaV 				  = nil
local Vblip 				  = nil
local vehicleData			  = nil
local vehiclesByCategory 	  = {}
local Kategorija = nil
local SBroj = 1
local Brod = false
local Saloni = {}
local Cpovi = {}
local blip = {}
local ImamSalon = false
local Blipara = nil
local Vozila = {}
local LokalnaVozila = {}
local OtvorenHTML = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)

	if Config.EnablePlayerManagement then
		if ESX.PlayerData.job.name == 'cardealer' then
			Config.Zones.ShopEntering.Type = 1

			if ESX.PlayerData.job.grade_name == 'boss' then
				Config.Zones.BossActions.Type = 1
			end

		else
			Config.Zones.ShopEntering.Type = -1
			Config.Zones.BossActions.Type  = -1
		end
	end

	ESX.TriggerServerCallback('saloni:DohvatiSalone', function(sal, voz)
		Saloni = sal
		Vozila = voz
	end)
	Citizen.Wait(1000)
	SpawnCpove()
	ReloadBlip()
	ESX.TriggerServerCallback('saloni:ImasLiSalon', function(imal)
		ImamSalon = imal
	end)
end)

function SpawnCpove()
	if #Cpovi > 0 then
		for i=1, #Cpovi, 1 do
		  	if Cpovi[i] ~= nil then
			  	if Cpovi[i].Spawnan then
					DeleteCheckpoint(Cpovi[i].ID)
					Cpovi[i].Spawnan = false
			  	end
		  	end
		end
	end
	Cpovi = {}
	for i=1, #Saloni, 1 do
		if Saloni[i].Kupovina then
			table.insert(Cpovi, {sID = Saloni[i].ID, Ime = Saloni[i].Ime, ID = check, Koord = Saloni[i].Kupovina, Spawnan = false, r = Config.MarkerColor.r, g = Config.MarkerColor.g, b = Config.MarkerColor.b})
		end
	end
end

RegisterNetEvent('saloni:ReloadBlip')
AddEventHandler('saloni:ReloadBlip', function()
	ReloadBlip()
end)

function ReloadBlip()
	while ESX == nil do
		Wait(0)
	end
	for i = 1, #Saloni, 1 do
		local st = Saloni[i].ID
		RemoveBlip(blip[st])
		local koord = Saloni[i].Kupovina
		if koord ~= nil then
			ESX.TriggerServerCallback('saloni:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 225)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Autosalon")
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 225)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 2)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Autosalon")
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		end
	end
	ESX.TriggerServerCallback('saloni:ImasLiSalon', function(imal)
		ImamSalon = imal
		RemoveBlip(Blipara)
		if ImamSalon then
			Blipara = AddBlipForCoord(Config.Zones.ShopEntering.Pos)

			SetBlipSprite (Blipara, 326)
			SetBlipDisplay(Blipara, 4)
			SetBlipScale  (Blipara, 1.0)
			SetBlipAsShortRange(Blipara, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('car_dealer'))
			EndTextCommandSetBlipName(Blipara)
		end
	end)
end

function getVehicleLabelFromModel(model)
	for k,v in ipairs(Vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

RegisterCommand("uredisalone", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			local elements = {}
			
			for i=1, #Saloni, 1 do
				if Saloni[i] ~= nil then
					table.insert(elements, {label = Saloni[i].Ime, value = Saloni[i].ID})
				end
			end
			
			table.insert(elements, {label = "Kreiraj salon", value = "novisalon"})

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'umafiju',
				{
					title    = "Izaberite salon",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "novisalon" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime2', {
							title = "Upisite cijenu salona",
						}, function (datari2, menuri2)
							local mCijena = datari2.value						
							if mCijena == nil then
								ESX.ShowNotification('Greska.')
							else
								menuri2.close()
								menu.close()
								TriggerServerEvent("saloni:NapraviSalon", mCijena)
								ExecuteCommand("uredisalone")
							end
						end, function (datari2, menuri2)
							menuri2.close()
						end)
					else
						local IDSalona = data.current.value
						elements = {}
						table.insert(elements, {label = "Koordinate", value = "koord"})
						table.insert(elements, {label = "Promjeni ime", value = "ime"})
						table.insert(elements, {label = "Promjeni cijenu", value = "cijena"})
						table.insert(elements, {label = "Makni vlasnika", value = "vlasnik"})
						table.insert(elements, {label = "Obrisi salon", value = "obrisi"})
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'umafiju2',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								if data2.current.value == "koord" then
									elements = {}
									
									table.insert(elements, {label = "Postavi koordinate kupovine firme", value = "1"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local mid = datalr.current.value
										local coord = GetEntityCoords(PlayerPedId())
										TriggerServerEvent("saloni:SpremiCoord", IDSalona, coord, tonumber(mid))
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "ime" then
									local mafIme
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mafime', {
										title = "Upisite novo ime salona",
									}, function (datar, menur)
										mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											TriggerServerEvent("saloni:PromjeniIme", IDSalona, mafIme)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "vlasnik" then
									TriggerServerEvent("saloni:MakniVlasnika", IDSalona)
								elseif data2.current.value == "cijena" then
									local mafIme
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mafime', {
										title = "Upisite novu cijenu salona",
									}, function (datar, menur)
										mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											TriggerServerEvent("saloni:PromjeniCijenu", IDSalona, mafIme)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "obrisi" then
									elements = {}
									
									table.insert(elements, {label = "Da", value = "da"})
									table.insert(elements, {label = "Ne", value = "ne"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Zelite li obrisati salon?",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "da" then
											menulr.close()
											menu2.close()
											menu.close()
											TriggerServerEvent("saloni:ObrisiSalon", IDSalona)
										else
											menulr.close()
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
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
				end
			)
		end
	end)
end, false)

RegisterNetEvent('saloni:PosaljiSalone')
AddEventHandler('saloni:PosaljiSalone', function(sal)
	Saloni = sal
	ReloadBlip()
	SpawnCpove()
end)

RegisterNetEvent('saloni:PosaljiVozila')
AddEventHandler('saloni:PosaljiVozila', function(vol)
	Vozila = vol
	ReloadLokalna()
end)

function ReloadLokalna()
	for i=1, #Cpovi, 1 do
		if Cpovi[i] ~= nil then
			if Cpovi[i].Spawnan then
				DeleteCheckpoint(Cpovi[i].ID)
				ObrisiVozila()
				Cpovi[i].Spawnan = false
			end
			local playerCoords = GetEntityCoords(PlayerPedId())
			if #(playerCoords-Cpovi[i].Koord) < 100 then
				if Cpovi[i].Spawnan == false then
					local kord = Cpovi[i].Koord
					local range = 2.0
					local check = CreateCheckpoint(47, kord.x, kord.y, kord.z, 0, 0, 0, range, Cpovi[i].r, Cpovi[i].g, Cpovi[i].b, 100)
					SetCheckpointCylinderHeight(check, range, range, range)
					Cpovi[i].ID = check
					Cpovi[i].Spawnan = true
					SpawnVozila(Cpovi[i].sID)
				end
			end
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	if Config.EnablePlayerManagement then
		if ESX.PlayerData.job.name == 'cardealer' then
			Config.Zones.ShopEntering.Type = 1

			if ESX.PlayerData.job.grade_name == 'boss' then
				Config.Zones.BossActions.Type = 1
			end

		else
			Config.Zones.ShopEntering.Type = -1
			Config.Zones.BossActions.Type  = -1
		end
	end
	TriggerServerEvent("ProvjeraObrisanihVozila")
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function(categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

function DeleteDisplayVehicleInsideShop()
	if currentDisplayVehicle and DoesEntityExist(currentDisplayVehicle) then
		ESX.Game.DeleteVehicle(currentDisplayVehicle)
		currentDisplayVehicle = nil
	end
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for k,v in ipairs(vehicles) do
			local returnPrice = ESX.Math.Round(v.price * 0.75)
			local vehicleLabel = getVehicleLabelFromModel(v.vehicle)

			table.insert(elements, {
				label = ('%s [<span style="color:orange;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(returnPrice))),
				value = v.vehicle
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_provider_menu', {
			title    = _U('return_provider_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_vehicleshop:returnProvider', data.current.value)

			Citizen.Wait(300)
			menu.close()
			ReturnVehicleProvider()
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(0)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		local playerPed = PlayerPedId()
		SBroj = 1
		
		DeleteDisplayVehicleInsideShop()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		if not Brod then
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
		else
			SetEntityCoords(playerPed, Config.Zones.ShopEntering2.Pos)
		end

		IsInShopMenu = false
    end
)

RegisterNUICallback(
    "svijetla",
    function(data, cb)
		if data.svijetla == true then
			SetVehicleLights(currentDisplayVehicle, 2)
		else
			SetVehicleLights(currentDisplayVehicle, 0)
		end
    end
)

RegisterNUICallback(
    "vrata",
    function(data, cb)
		if data.otvori == true then
			SetVehicleDoorOpen(currentDisplayVehicle, 0, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 1, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 2, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 3, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 4, false, false) --hauba
			SetVehicleDoorOpen(currentDisplayVehicle, 5, false, false) --gepek
		else
			SetVehicleDoorsShut(currentDisplayVehicle, false)
		end
    end
)

RegisterNUICallback(
    "pogled",
    function(data, cb)
		if data.pogled == true then
			SetNuiFocus(false)
			SendNUIMessage({
				prikazi = true
			})
			CurrentAction     = 'shop_pregled'
			CurrentActionMsg  = "Pritisnite ~INPUT_FRONTEND_RRIGHT~ da izadjete iz pregleda vozila!"
			CurrentActionData = {}
		end
    end
)

RegisterNUICallback(
    "staviboju",
    function(data, cb)
		if data.ime == "crvena" then
			local props = {}
			props['color1'] = 27
			props['color2'] = 27
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "bijela" then
			local props = {}
			props['color1'] = 111
			props['color2'] = 111
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "plava" then
			local props = {}
			props['color1'] = 64
			props['color2'] = 64
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "orange" then
			local props = {}
			props['color1'] = 38
			props['color2'] = 38
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "zuta" then
			local props = {}
			props['color1'] = 89
			props['color2'] = 89
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "siva" then
			local props = {}
			props['color1'] = 10
			props['color2'] = 10
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "zelena" then
			local props = {}
			props['color1'] = 53
			props['color2'] = 53
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		elseif data.ime == "crna" then
			local props = {}
			props['color1'] = 0
			props['color2'] = 0
			ESX.Game.SetVehicleProperties(currentDisplayVehicle, props)
		end
    end
)

RegisterNUICallback(
    "spawnauto",
    function(data, cb)
		SBroj = 1
		vehicleData = vehiclesByCategory[data.naziv][1]
		Kategorija = data.naziv
		local playerPed   = PlayerPedId()
		--ESX.Game.DeleteVehicle(GetVehiclePedIsIn(playerPed, false))
		DeleteDisplayVehicleInsideShop()
		WaitForVehicleToLoad(vehicleData.model)
		if currentDisplayVehicle ~= nil then
			ESX.Game.DeleteVehicle(currentDisplayVehicle)
			currentDisplayVehicle = nil
		end
		if not Brod then
			ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
				currentDisplayVehicle = vehicle
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
				SetVehicleDirtLevel(vehicle, 0)
			end)
		else
			ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside2.Pos, Config.Zones.ShopInside2.Heading, function(vehicle)
				currentDisplayVehicle = vehicle
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
				SetVehicleDirtLevel(vehicle, 0)
			end)
		end
		while currentDisplayVehicle == nil do
			Wait(1)
		end
		SendNUIMessage({
			postaviime = true,
			imevozila = vehicleData.name,
			cijenavozila = vehicleData.price.."$"
		})
    end
)

RegisterNetEvent('salon:VratiVozilo')
AddEventHandler('salon:VratiVozilo', function(nid, vehicle, plate, mj, co)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	if attempt < 100 then
		local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		while not DoesEntityExist(callback_vehicle) do
			Wait(1)
			callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		end
		local playerPed = PlayerPedId()
		--SetEntityHeading(callback_vehicle, he)
		TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		Wait(100)
		SetVehicleNumberPlateText(callback_vehicle, plate)
		SetVehicleDirtLevel(callback_vehicle, 0)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		TriggerEvent("EoTiIzSalona", mj)
		
		GarazaV = nid
		local propse = ESX.Game.GetVehicleProperties(callback_vehicle)
		local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
		
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	else
		print("Greska prilikom kreiranja vozila. NetID: "..nid)
		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, co)
		local coords = GetEntityCoords(ped)
		local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
		local callback_vehicle = veh
		local playerPed = ped
		--SetEntityHeading(callback_vehicle, he)
		TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		Wait(100)
		SetVehicleNumberPlateText(callback_vehicle, plate)
		SetVehicleDirtLevel(callback_vehicle, 0)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		TriggerEvent("EoTiIzSalona", mj)
		
		GarazaV = nid
		local propse = ESX.Game.GetVehicleProperties(callback_vehicle)
		local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
		
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	end
end)

RegisterNUICallback(
    "kupi",
    function()
		SetNuiFocus(false)
		SendNUIMessage({
			prikazi = true
		})
		local playerPed = PlayerPedId()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_izaberiga', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			align = 'bottom-right',
			elements = {
				{label = "Kupi vozilo", value = 'kupi'}
			}
		}, function(data2, menu2)
			if not Brod then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mjenjac', {
					title    = "Izbor mjenjaca",
					align    = 'bottom-right',
					elements = {
						{label = "Rucni",  value = 'rucni'},
						{label = "Automatik ($5000)", value = 'auto'}
					}
				}, function (data69, menu69)
					if data69.current.value == 'rucni' then
						local mjenjac = 2
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
							title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
							align = 'bottom-right',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
						}}, function(data4, menu4)
							if data4.current.value == 'yes' then
								local generatedPlate = GeneratePlate()

								ESX.TriggerServerCallback('autosalon:sealion', function(success)
									if success then
										IsInShopMenu = false
										menu4.close()
										menu69.close()
										menu2.close()
										DeleteDisplayVehicleInsideShop()
										local playerPed = PlayerPedId()

										CurrentAction     = 'shop_menu'
										CurrentActionMsg  = _U('shop_menu')
										CurrentActionData = {}

										FreezeEntityPosition(playerPed, false)
										SetEntityVisible(playerPed, true)
										SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
									else
										ESX.ShowNotification(_U('not_enough_money'))
									end
								end, vehicleData.model, generatedPlate, mjenjac, ESX.Game.GetVehicleProperties(currentDisplayVehicle))
							else
								menu4.close()
							end
						end, function(data4, menu4)
							menu4.close()
						end)
					elseif data69.current.value == 'auto' then
						local mjenjac = 1
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
							title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price+5000)),
							align = 'bottom-right',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
						}}, function(data4, menu4)
							if data4.current.value == 'yes' then
								local generatedPlate = GeneratePlate()

								ESX.TriggerServerCallback('autosalon:sealion', function(success)
									if success then
										IsInShopMenu = false
										menu4.close()
										menu69.close()
										menu2.close()
										DeleteDisplayVehicleInsideShop()
										local playerPed = PlayerPedId()

										CurrentAction     = 'shop_menu'
										CurrentActionMsg  = _U('shop_menu')
										CurrentActionData = {}

										FreezeEntityPosition(playerPed, false)
										SetEntityVisible(playerPed, true)
										SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
									else
										ESX.ShowNotification(_U('not_enough_money'))
									end
								end, vehicleData.model, generatedPlate, mjenjac, ESX.Game.GetVehicleProperties(currentDisplayVehicle))
							else
								menu4.close()
							end
						end, function(data4, menu4)
							menu4.close()
						end)
					end
				end, function (data69, menu69)
					menu69.close()
				end)
			else
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
							title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price+5000)),
							align = 'bottom-right',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
				}}, function(data4, menu4)
					if data4.current.value == 'yes' then
						if Config.EnablePlayerManagement then
							ESX.TriggerServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(success)
								if success then
									IsInShopMenu = false
									DeleteDisplayVehicleInsideShop()

									CurrentAction     = 'shop_menu'
									CurrentActionMsg  = _U('shop_menu')
									CurrentActionData = {}

									FreezeEntityPosition(playerPed, false)
									SetEntityVisible(playerPed, true)
									SetEntityCoords(playerPed, Config.Zones.ShopEntering2.Pos)

									menu4.close()
									menu2.close()
									ESX.ShowNotification(_U('vehicle_purchased'))
								else
									ESX.ShowNotification(_U('broke_company'))
								end
							end, vehicleData.model)
						else
							local generatedPlate = GeneratePlate()

							ESX.TriggerServerCallback('autosalon:sealion', function(success)
								if success then
									IsInShopMenu = false
									menu4.close()
									menu2.close()
									local propi = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
											
									DeleteDisplayVehicleInsideShop()
											
									if GarazaV ~= nil then
										TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
										GarazaV = nil
										if Vblip ~= nil then
											RemoveBlip(Vblip)
											Vblip = nil
										end
									end
									
									TriggerServerEvent("salon:SpawnVozilo", propi, Config.Zones.ShopOutside2.Pos, Config.Zones.ShopOutside2.Heading, generatedPlate, 3)
								else
									ESX.ShowNotification(_U('not_enough_money'))
								end
							end, vehicleData.model, generatedPlate, 3, ESX.Game.GetVehicleProperties(currentDisplayVehicle))
						end
					else
						menu4.close()
					end
				end, function(data4, menu4)
					menu4.close()
				end)
			end
		end, function (data2, menu2)
			menu2.close()
			for i=1, #Categories, 1 do
				local category         = Categories[i]
				if not Brod then
					if category.brod == 0 then
						if category.name ~= "obrisani" then
							SendNUIMessage({
								dodajkat = true,
								ime = category.name,
								label = category.label
							})
						end
					end
				else
					if category.brod == 1 then
						if category.name ~= "obrisani" then
							SendNUIMessage({
								dodajkat = true,
								ime = category.name,
								label = category.label
							})
						end
					end
				end
			end
			SendNUIMessage({
				prikazi = true
			})
			SetNuiFocus(true, true)
		end)
    end
)

RegisterNUICallback(
    "lijevo",
    function()
		if SBroj-1 ~= 0 then
			SBroj = SBroj-1
			vehicleData = vehiclesByCategory[Kategorija][SBroj]
			local playerPed   = PlayerPedId()
			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)
			if currentDisplayVehicle ~= nil then
				ESX.Game.DeleteVehicle(currentDisplayVehicle)
				currentDisplayVehicle = nil
			end
			if not Brod then
				ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
					currentDisplayVehicle = vehicle
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					FreezeEntityPosition(vehicle, true)
					SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
					SetVehicleDirtLevel(vehicle, 0)
				end)
			else
				ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside2.Pos, Config.Zones.ShopInside2.Heading, function(vehicle)
					currentDisplayVehicle = vehicle
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					FreezeEntityPosition(vehicle, true)
					SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
					SetVehicleDirtLevel(vehicle, 0)
				end)
			end
			while currentDisplayVehicle == nil do
				Wait(1)
			end
			SendNUIMessage({
				postaviime = true,
				imevozila = vehicleData.name,
				cijenavozila = vehicleData.price.."$"
			})
		end
    end
)

RegisterNUICallback(
    "desno",
    function()
		if vehiclesByCategory[Kategorija][SBroj+1] ~= nil then
			SBroj = SBroj+1
			vehicleData = vehiclesByCategory[Kategorija][SBroj]
			local playerPed   = PlayerPedId()
			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)
			if currentDisplayVehicle ~= nil then
				ESX.Game.DeleteVehicle(currentDisplayVehicle)
				currentDisplayVehicle = nil
			end
			if not Brod then
				ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
					currentDisplayVehicle = vehicle
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					FreezeEntityPosition(vehicle, true)
					SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
					SetVehicleDirtLevel(vehicle, 0)
				end)
			else
				ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside2.Pos, Config.Zones.ShopInside2.Heading, function(vehicle)
					currentDisplayVehicle = vehicle
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					FreezeEntityPosition(vehicle, true)
					SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
					SetVehicleDirtLevel(vehicle, 0)
				end)
			end
			while currentDisplayVehicle == nil do
				Wait(1)
			end
			SendNUIMessage({
				postaviime = true,
				imevozila = vehicleData.name,
				cijenavozila = vehicleData.price.."$"
			})
		end
    end
)

function OpenShopMenu()
	if #Vehicles == 0 then
		print('[esx_vehicleshop] [^3ERROR^7] No vehicles found')
		return
	end

	IsInShopMenu = true

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	if not Brod then
		SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos)
	else
		SetEntityCoords(playerPed, Config.Zones.ShopInside2.Pos)
	end

	vehiclesByCategory = {}
	local elements           = {}
	local firstVehicleData   = nil

	for i=1, #Categories, 1 do
		vehiclesByCategory[Categories[i].name] = {}
	end

	for i=1, #Vehicles, 1 do
		if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
			table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
		else
			print(('[esx_vehicleshop] [^3ERROR^7] Vehicle "%s" does not exist'):format(Vehicles[i].model))
		end
	end

	for k,v in pairs(vehiclesByCategory) do
		table.sort(v, function(a, b)
			return a.name < b.name
		end)
	end
	local NasoGa = false
	for i=1, #Categories, 1 do
		if not Brod then
			if Categories[i].brod == 0 then
				local category         = Categories[i]
				local categoryVehicles = vehiclesByCategory[category.name]
				local options          = {}

				for j=1, #categoryVehicles, 1 do
					local vehicle = categoryVehicles[j]

					if i == 1 and j == 1 then
						firstVehicleData = vehicle
					end

					table.insert(options, ('%s <span style="color:green;">%s</span>'):format(vehicle.name, _U('generic_shopitem', ESX.Math.GroupDigits(vehicle.price))))
				end
				
				--table.sort(options)
				if category.name ~= "obrisani" then
					SendNUIMessage({
						dodajkat = true,
						ime = category.name,
						label = category.label
					})
					table.insert(elements, {
						name    = category.name,
						label   = category.label,
						value   = 0,
						type    = 'slider',
						max     = #Categories[i],
						options = options
					})
				end
			end
		else
			if Categories[i].brod == 1 then
				local category         = Categories[i]
				local categoryVehicles = vehiclesByCategory[category.name]
				local options          = {}
				for j=1, #categoryVehicles, 1 do
					local vehicle = categoryVehicles[j]
					if not NasoGa then
						firstVehicleData = vehicle
						NasoGa = true
						break
					end

					table.insert(options, ('%s <span style="color:green;">%s</span>'):format(vehicle.name, _U('generic_shopitem', ESX.Math.GroupDigits(vehicle.price))))
				end
				
				--table.sort(options)
				if category.name ~= "obrisani" then
					SendNUIMessage({
						dodajkat = true,
						ime = category.name,
						label = category.label
					})
					table.insert(elements, {
						name    = category.name,
						label   = category.label,
						value   = 0,
						type    = 'slider',
						max     = #Categories[i],
						options = options
					})
				end
			end
		end
	end
	
	vehicleData = firstVehicleData
	
	WaitForVehicleToLoad(firstVehicleData.model)
	if currentDisplayVehicle ~= nil then
		ESX.Game.DeleteVehicle(currentDisplayVehicle)
		currentDisplayVehicle = nil
	end
	if not Brod then
		ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
			currentDisplayVehicle = vehicle
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(GetHashKey(firstVehicleData.model))
			SetVehicleDirtLevel(vehicle, 0)
		end)
	else
		ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside2.Pos, Config.Zones.ShopInside2.Heading, function(vehicle)
			currentDisplayVehicle = vehicle
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(GetHashKey(firstVehicleData.model))
			SetVehicleDirtLevel(vehicle, 0)
		end)
	end
	while currentDisplayVehicle == nil do
		Wait(1)
	end
	SendNUIMessage({
		postaviime = true,
		imevozila = firstVehicleData.name,
		cijenavozila = firstVehicleData.price.."$"
	})
	SendNUIMessage({
		prikazi = true
	})
	SetNuiFocus(true, true)

	--[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('car_dealer'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_izaberiga', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			align = 'top-left',
			elements = {
				{label = "Testna voznja",  value = 'test'},
				{label = "Kupi vozilo", value = 'kupi'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'test' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mjenjac', {
					title = "Izaberite mjenjac",
					align = 'top-left',
					elements = {
						{label = "Rucni",  value = 'rucni'},
						{label = "Automatik", value = 'auto'}
					}}, function (data70, menu70)
					if data70.current.value == 'rucni' then
						ESX.ShowNotification("Imate 5 minuta testne voznje, pazite da ne ostetite vozilo!")
						ESX.ShowNotification("Da prekinete testnu voznju upisite /zavrsitest")
						ESX.ShowNotification("Brzine mjenjate sa lijevim shiftom i ctrlom!")
						local playerPed = PlayerPedId()
						IsInShopMenu = false
						menu70.close()
						menu2.close()
						menu.close()
						DeleteDisplayVehicleInsideShop()
						if VoziloID ~= nil and DoesEntityExist(VoziloID) then
							ESX.Game.DeleteVehicle(VoziloID)
							VoziloID = nil
						end
						ESX.Streaming.RequestModel(vehicleData.model)
						Vrijeme = 5
						UTestu = 1
						VoziloID = CreateVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos.x, Config.Zones.ShopOutside.Pos.y, Config.Zones.ShopOutside.Pos.z, Config.Zones.ShopOutside.Heading, true, false)
						TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
						SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
						TriggerServerEvent("salon:PokreniTimer", VoziloID)
						Citizen.CreateThread(function()
							while true do
								Citizen.Wait(60000)
								if VoziloID ~= nil and DoesEntityExist(VoziloID) then
									SaljiVrijeme(VoziloID)
								end
							end
						end)
						SetVehicleDirtLevel(VoziloID, 0)
						SetVehicleNumberPlateText(VoziloID, "Test")
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
						Wait(100)
						TriggerEvent("EoTiIzSalona", 2)
					elseif data70.current.value == 'auto' then
						ESX.ShowNotification("Imate 5 minuta testne voznje, pazite da ne ostetite vozilo!")
						ESX.ShowNotification("Da prekinete testnu voznju upisite /zavrsitest")
						local playerPed = PlayerPedId()
						IsInShopMenu = false
						menu70.close()
						menu2.close()
						menu.close()
						DeleteDisplayVehicleInsideShop()
						if VoziloID ~= nil and DoesEntityExist(VoziloID) then
							ESX.Game.DeleteVehicle(VoziloID)
							VoziloID = nil
						end
						ESX.Streaming.RequestModel(vehicleData.model)
						Vrijeme = 5
						UTestu = 1
						VoziloID = CreateVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos.x, Config.Zones.ShopOutside.Pos.y, Config.Zones.ShopOutside.Pos.z, Config.Zones.ShopOutside.Heading, true, false)
						TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
						SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
						TriggerServerEvent("salon:PokreniTimer", VoziloID)
						Citizen.CreateThread(function()
							while true do
								Citizen.Wait(60000)
								if VoziloID ~= nil and DoesEntityExist(VoziloID) then
									SaljiVrijeme(VoziloID)
								end
							end
						end)
						SetVehicleDirtLevel(VoziloID, 0)
						SetVehicleNumberPlateText(VoziloID, "Test")
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
						Wait(100)
						TriggerEvent("EoTiIzSalona", 1)
					end
				end, function (data70, menu70)
					menu70.close()
				end)
			else
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mjenjac', {
					title    = "Izbor mjenjaca",
					align    = 'top-left',
					elements = {
						{label = "Rucni",  value = 'rucni'},
						{label = "Automatik ($5000)", value = 'auto'}
					}
				}, function (data69, menu69)
					if data69.current.value == 'rucni' then
						local mjenjac = 2
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
							title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
							align = 'top-left',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
						}}, function(data4, menu4)
							if data4.current.value == 'yes' then
								if Config.EnablePlayerManagement then
									ESX.TriggerServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(success)
										if success then
											IsInShopMenu = false
											DeleteDisplayVehicleInsideShop()

											CurrentAction     = 'shop_menu'
											CurrentActionMsg  = _U('shop_menu')
											CurrentActionData = {}

											local playerPed = PlayerPedId()
											FreezeEntityPosition(playerPed, false)
											SetEntityVisible(playerPed, true)
											SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

											menu4.close()
											menu69.close()
											menu2.close()
											menu.close()
											ESX.ShowNotification(_U('vehicle_purchased'))
										else
											ESX.ShowNotification(_U('broke_company'))
										end
									end, vehicleData.model)
								else
									local generatedPlate = GeneratePlate()

									ESX.TriggerServerCallback('autosalon:sealion', function(success)
										if success then
											IsInShopMenu = false
											menu4.close()
											menu69.close()
											menu2.close()
											menu.close()
											local propi = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
											DeleteDisplayVehicleInsideShop()
											
											if GarazaV ~= nil and DoesEntityExist(GarazaV) then
												local prop = ESX.Game.GetVehicleProperties(GarazaV)
												local pla = prop.plate:gsub("^%s*(.-)%s*$", "%1")
												ESX.Game.DeleteVehicle(GarazaV)
												GarazaV = nil
												TriggerServerEvent("garaza:SpremiModel", pla, nil)
												if Vblip ~= nil then
													RemoveBlip(Vblip)
													Vblip = nil
												end
											end
											

											ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function(vehicle)
												TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
												ESX.Game.SetVehicleProperties(vehicle, propi)
												SetVehicleNumberPlateText(vehicle, generatedPlate)
												SetVehicleDirtLevel(vehicle, 0)
												FreezeEntityPosition(playerPed, false)
												SetEntityVisible(playerPed, true)
											end)
											Wait(200)
											SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
											local vehe = GetVehiclePedIsIn(PlayerPedId())
											GarazaV = vehe
											local propse = ESX.Game.GetVehicleProperties(GarazaV)
											local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
											TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
											
											Vblip = AddBlipForEntity(GarazaV)
											SetBlipSprite (Vblip, 225)
											SetBlipDisplay(Vblip, 4)
											SetBlipScale  (Vblip, 1.0)
											SetBlipColour (Vblip, 30)
											SetBlipAsShortRange(Vblip, true)
											BeginTextCommandSetBlipName("STRING")
											AddTextComponentString("Vase vozilo")
											EndTextCommandSetBlipName(Vblip)
												
											TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, vehicleData.model, generatedPlate, mjenjac, ESX.Game.GetVehicleProperties(currentDisplayVehicle))
								end
							else
								menu4.close()
							end
						end, function(data4, menu4)
							menu4.close()
						end)
					elseif data69.current.value == 'auto' then
						local mjenjac = 1
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
							title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price+5000)),
							align = 'top-left',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
						}}, function(data4, menu4)
							if data4.current.value == 'yes' then
								if Config.EnablePlayerManagement then
									ESX.TriggerServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(success)
										if success then
											IsInShopMenu = false
											DeleteDisplayVehicleInsideShop()

											CurrentAction     = 'shop_menu'
											CurrentActionMsg  = _U('shop_menu')
											CurrentActionData = {}

											local playerPed = PlayerPedId()
											FreezeEntityPosition(playerPed, false)
											SetEntityVisible(playerPed, true)
											SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

											menu4.close()
											menu69.close()
											menu2.close()
											menu.close()
											ESX.ShowNotification(_U('vehicle_purchased'))
										else
											ESX.ShowNotification(_U('broke_company'))
										end
									end, vehicleData.model)
								else
									local generatedPlate = GeneratePlate()

									ESX.TriggerServerCallback('autosalon:sealion', function(success)
										if success then
											IsInShopMenu = false
											menu4.close()
											menu69.close()
											menu2.close()
											menu.close()
											local propi = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
											
											DeleteDisplayVehicleInsideShop()
											
											if GarazaV ~= nil and DoesEntityExist(GarazaV) then
												local prop = ESX.Game.GetVehicleProperties(GarazaV)
												local pla = prop.plate:gsub("^%s*(.-)%s*$", "%1")
												ESX.Game.DeleteVehicle(GarazaV)
												GarazaV = nil
												TriggerServerEvent("garaza:SpremiModel", pla, nil)
												if Vblip ~= nil then
													RemoveBlip(Vblip)
													Vblip = nil
												end
											end
											

											ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function(vehicle)
												TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
												ESX.Game.SetVehicleProperties(vehicle, propi)
												SetVehicleNumberPlateText(vehicle, generatedPlate)
												SetVehicleDirtLevel(vehicle, 0)
												FreezeEntityPosition(playerPed, false)
												SetEntityVisible(playerPed, true)
											end)
											Wait(200)
											SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
											local vehe = GetVehiclePedIsIn(PlayerPedId())
											GarazaV = vehe
											local propse = ESX.Game.GetVehicleProperties(GarazaV)
											local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
											TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
											
											Vblip = AddBlipForEntity(GarazaV)
											SetBlipSprite (Vblip, 225)
											SetBlipDisplay(Vblip, 4)
											SetBlipScale  (Vblip, 1.0)
											SetBlipColour (Vblip, 30)
											SetBlipAsShortRange(Vblip, true)
											BeginTextCommandSetBlipName("STRING")
											AddTextComponentString("Vase vozilo")
											EndTextCommandSetBlipName(Vblip)
												
											TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
										else
											ESX.ShowNotification(_U('not_enough_money'))
										end
									end, vehicleData.model, generatedPlate, mjenjac, ESX.Game.GetVehicleProperties(currentDisplayVehicle))
								end
							else
								menu4.close()
							end
						end, function(data4, menu4)
							menu4.close()
						end)
					end
				end, function (data69, menu69)
					menu69.close()
				end)
			end
		end, function (data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		--ESX.Game.DeleteVehicle(GetVehiclePedIsIn(playerPed, false))
		DeleteDisplayVehicleInsideShop()
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)

		IsInShopMenu = false
	end, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()
		--ESX.Game.DeleteVehicle(GetVehiclePedIsIn(playerPed, false))
		DeleteDisplayVehicleInsideShop()
		WaitForVehicleToLoad(vehicleData.model)
		if currentDisplayVehicle ~= nil then
			ESX.Game.DeleteVehicle(currentDisplayVehicle)
			currentDisplayVehicle = nil
		end
		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
			currentDisplayVehicle = vehicle
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
			SetVehicleDirtLevel(vehicle, 0)
		end)
		while currentDisplayVehicle == nil do
			Wait(1)
		end
	end)

	--ESX.Game.DeleteVehicle(GetVehiclePedIsIn(playerPed, false))

	DeleteDisplayVehicleInsideShop()
	WaitForVehicleToLoad(firstVehicleData.model)
	if currentDisplayVehicle ~= nil then
		ESX.Game.DeleteVehicle(currentDisplayVehicle)
		currentDisplayVehicle = nil
	end
	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
		currentDisplayVehicle = vehicle
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(GetHashKey(firstVehicleData.model))
		SetVehicleDirtLevel(vehicle, 0)
	end)
	while currentDisplayVehicle == nil do
		Wait(1)
	end]]
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)
		SendNUIMessage({
			zabrani = true
		})
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
		BusyspinnerOff()
		SendNUIMessage({
			zabrani = true
		})
	end
end

function OpenResellerMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller', {
		title    = _U('car_dealer'),
		align    = 'top-left',
		elements = {
			{label = _U('buy_vehicle'),                    value = 'buy_vehicle'},
			{label = _U('pop_vehicle'),                    value = 'pop_vehicle'},
			{label = _U('depop_vehicle'),                  value = 'depop_vehicle'},
			{label = _U('return_provider'),                value = 'return_provider'},
			{label = _U('create_bill'),                    value = 'create_bill'},
			{label = _U('get_rented_vehicles'),            value = 'get_rented_vehicles'},
			{label = _U('set_vehicle_owner_sell'),         value = 'set_vehicle_owner_sell'},
			{label = _U('set_vehicle_owner_rent'),         value = 'set_vehicle_owner_rent'},
			{label = _U('deposit_stock'),                  value = 'put_stock'},
			{label = _U('take_stock'),                     value = 'get_stock'}
	}}, function(data, menu)
		local action = data.current.value

		if action == 'buy_vehicle' then
			OpenShopMenu()
		elseif action == 'put_stock' then
			OpenPutStocksMenu()
		elseif action == 'get_stock' then
			OpenGetStocksMenu()
		elseif action == 'pop_vehicle' then
			OpenPopVehicleMenu()
		elseif action == 'depop_vehicle' then
			if currentDisplayVehicle then
				DeleteDisplayVehicleInsideShop()
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		elseif action == 'return_provider' then
			ReturnVehicleProvider()
		elseif action == 'create_bill' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer ~= -1 and closestDistance < 3 then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_sell_amount', {
					title = _U('invoice_amount')
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu2.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_U('no_players'))
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_cardealer', _U('car_dealer'), tonumber(data2.value))
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				ESX.ShowNotification(_U('no_players'))
			end
		elseif action == 'get_rented_vehicles' then
			OpenRentedVehiclesMenu()
		elseif action == 'set_vehicle_owner_sell' then
			if currentDisplayVehicle then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDistance < 3 then
					local newPlate = GeneratePlate()
					local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle)
					vehicleProps.plate = newPlate
					SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
					TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps, CurrentVehicleData.model, CurrentVehicleData.name)
					currentDisplayVehicle = nil
				else
					ESX.ShowNotification(_U('no_players'))
				end
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		elseif action == 'set_vehicle_owner_rent' then
			if currentDisplayVehicle then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer ~= -1 and closestDistance < 3 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_rent_amount', {
						title = _U('rental_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if not amount then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer ~= -1 and closestDistance < 3 then
								local newPlate = 'RENT' .. string.upper(ESX.GetRandomString(4))
								local model = CurrentVehicleData.model
								SetVehicleNumberPlateText(currentDisplayVehicle, newPlate)
								TriggerServerEvent('esx_vehicleshop:rentVehicle', model, newPlate, amount, GetPlayerServerId(closestPlayer))
								currentDisplayVehicle = nil
							else
								ESX.ShowNotification(_U('no_players'))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification(_U('no_players'))
				end
			else
				ESX.ShowNotification(_U('no_current_vehicle'))
			end
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'reseller_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

function OpenPopVehicleMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		for k,v in ipairs(vehicles) do
			local vehicleLabel = getVehicleLabelFromModel(v.vehicle)

			table.insert(elements, {
				label = ('%s [MSRP <span style="color:green;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(v.price))),
				value = v.vehicle
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'commercial_vehicles', {
			title    = _U('vehicle_dealer'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local model = data.current.value
			DeleteDisplayVehicleInsideShop()

			ESX.Game.SpawnVehicle(model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function(vehicle)
				currentDisplayVehicle = vehicle

				for i=1, #Vehicles, 1 do
					if model == Vehicles[i].model then
						CurrentVehicleData = Vehicles[i]
						break
					end
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenRentedVehiclesMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getRentedVehicles', function(vehicles)
		local elements = {}

		for k,v in ipairs(vehicles) do
			local vehicleLabel = getVehicleLabelFromModel(v.name)

			table.insert(elements, {
				label = ('%s: %s - <span style="color:orange;">%s</span>'):format(v.playerName, vehicleLabel, v.plate),
				value = v.name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rented_vehicles', {
			title    = _U('rent_vehicle'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller',{
		title    = _U('dealer_boss'),
		align    = 'top-left',
		elements = {
			{label = _U('boss_actions'), value = 'boss_actions'},
			{label = _U('boss_sold'), value = 'sold_vehicles'}
	}}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'cardealer', function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'sold_vehicles' then

			ESX.TriggerServerCallback('esx_vehicleshop:getSoldVehicles', function(customers)
				local elements = {
					head = { _U('customer_client'), _U('customer_model'), _U('customer_plate'), _U('customer_soldby'), _U('customer_date') },
					rows = {}
				}

				for i=1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].client,
							customers[i].model,
							customers[i].plate,
							customers[i].soldby,
							customers[i].date
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('dealership_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('amount')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					TriggerServerEvent('esx_vehicleshop:getStockItem', itemName, count)
					menu2.close()
					menu.close()
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_vehicleshop:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('amount')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					TriggerServerEvent('esx_vehicleshop:putStockItems', itemName, count)
					menu2.close()
					menu.close()
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('salon:ObrisiVozilo')
AddEventHandler('salon:ObrisiVozilo', function (vid)
	if vid ~= nil and DoesEntityExist(vid) then
		ESX.Game.DeleteVehicle(vid)
	end
end)

function SaljiVrijeme(vid)
	if Vrijeme > 1 then
		Vrijeme = Vrijeme-1
		if Vrijeme == 1 then
			ESX.ShowNotification("Preostalo vam je jos "..Vrijeme.." minuta do kraja testne voznje!")
		else
			ESX.ShowNotification("Preostalo vam je jos "..Vrijeme.." minute do kraja testne voznje!")
		end
	else
		if vid ~= nil and DoesEntityExist(vid) then
			local heal = GetVehicleEngineHealth(vid)
			local ukupno = math.ceil((1000-heal)*10)
			TriggerServerEvent("salon:PlatiStetu", ukupno)
			ESX.ShowNotification("Platili ste stetu na vozilu "..ukupno.."$.")
			ESX.Game.DeleteVehicle(vid)
		end
		Vrijeme = 0
		UTestu = 0
		ESX.ShowNotification("Vasa testna voznja je zavrsila!")
		VoziloID = nil
		if not Brod then
			SetEntityCoords(PlayerPedId(), Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		else
			SetEntityCoords(PlayerPedId(), Config.Zones.ShopEntering2.Pos.x, Config.Zones.ShopEntering2.Pos.y, Config.Zones.ShopEntering2.Pos.z)
		end
	end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	if Config.EnablePlayerManagement then
		if ESX.PlayerData.job.name == 'cardealer' then
			Config.Zones.ShopEntering.Type = 1

			if ESX.PlayerData.job.grade_name == 'boss' then
				Config.Zones.BossActions.Type = 1
			end
		else
			Config.Zones.ShopEntering.Type = -1
			Config.Zones.BossActions.Type  = -1
		end
	end
end)

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function(zone, id)
	if zone == 'ShopEntering' then

		if Config.EnablePlayerManagement then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'cardealer' then
				CurrentAction     = 'reseller_menu'
				CurrentActionMsg  = _U('shop_menu')
				CurrentActionData = {}
			end
		else
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('shop_menu')
			CurrentActionData = {}
			Brod = false
		end

	elseif zone == 'GiveBackVehicle' and Config.EnablePlayerManagement then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			CurrentAction     = 'give_back_vehicle'
			CurrentActionMsg  = _U('vehicle_menu')
			CurrentActionData = {vehicle = vehicle}
		end
	elseif zone == 'vlasnik_menu' then
		CurrentAction     = 'vlasnik_menu'
		CurrentActionMsg  = "Pritisnite E da otvorite menu vlasnika"
		CurrentActionData = {sID = id}
	elseif zone == 'ResellVehicle' or zone == 'ResellVehicle2' then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then

			local vehicle     = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate
			local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)
					if isOwnedVehicle then
						ESX.TriggerServerCallback('garaza:JelIstiModel', function(dane)
							if (dane) then
								for i=1, #Vehicles, 1 do
									if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
										vehicleData = Vehicles[i]
										break
									end
								end
								local koord = GetEntityCoords(PlayerPedId())
								if GetDistanceBetweenCoords(koord, -44.569271087646, -1081.7122802734, 25.685205459595, true) <= 3.0 or GetDistanceBetweenCoords(koord, -731.54217529297, -1334.6604003906, 0.28573158383369, true) <= 3.0 then
									resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
									model = GetEntityModel(vehicle)
									plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

									CurrentAction     = 'resell_vehicle'
									CurrentActionMsg  = _U('sell_menu', vehicleData.name, ESX.Math.GroupDigits(resellPrice))

									CurrentActionData = {
										vehicle = vehicle,
										label = vehicleData.name,
										price = resellPrice,
										model = model,
										plate = plate,
										kategorija = vehicleData.category
									}
								end
							else
								TriggerServerEvent("ac:MjenjanjeModela")
							end
						end, vehicleProps.plate, vehicleProps.model)
					end
				end, vehicleProps.plate)
			end
		end

	elseif zone == 'BossActions' and Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'cardealer' and ESX.PlayerData.job.grade_name == 'boss' then
		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	elseif zone == 'ShopEntering2' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
		Brod = true
	end
end)

AddEventHandler('esx_vehicleshop:hasExitedMarker', function(zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			if not Brod then
				SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos)
			else
				SetEntityCoords(playerPed, Config.Zones.ShopEntering2.Pos)
			end
		end
		DeleteDisplayVehicleInsideShop()
	end
end)

RegisterCommand("zavrsitest", function(source, args, rawCommandString)
	if UTestu == 1 then
		if VoziloID ~= nil and DoesEntityExist(VoziloID) then
			local heal = GetVehicleEngineHealth(VoziloID)
			local ukupno = math.ceil((1000-heal)*10)
			TriggerServerEvent("salon:PlatiStetu", ukupno)
			ESX.ShowNotification("Platili ste stetu na vozilu "..ukupno.."$.")
			ESX.Game.DeleteVehicle(VoziloID)
		end
		Vrijeme = 0
		UTestu = 0
		ESX.ShowNotification("Vasa testna voznja je zavrsila!")
		VoziloID = nil
		if not Brod then
			SetEntityCoords(PlayerPedId(), Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		else
			SetEntityCoords(PlayerPedId(), Config.Zones.ShopEntering2.Pos.x, Config.Zones.ShopEntering2.Pos.y, Config.Zones.ShopEntering2.Pos.z)
		end
	end
end, false)

if Config.EnablePlayerManagement then
	RegisterNetEvent('esx_phone:loaded')
	AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
		local specialContact = {
			name       = _U('dealership'),
			number     = 'cardealer',
			base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAMAAABrrFhUAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAADMzMzszM0M0M0w0M1Q1M101M2U2M242M3Y3M383Moc4MpA4Mpg5MqE5Mqk6MrI6Mro7Mrw8Mr89M71DML5EO8I+NMU/NcBMLshANctBNs5CN8RULMddKsheKs9YLtBCONZEOdlFOtxGO99HPNhMNsplKM1nKM1uJtRhLddiLt5kMNJwJ9B2JNR/IeNIPeVJPehKPuRQOuhSO+lZOOlhNuloM+p3Lep/KupwMMFORsVYUcplXc1waNJ7delUSepgVexrYe12bdeHH9iIH9qQHd2YG+udH+OEJeuGJ+uOJeuVIuChGeSpF+aqGOykHOysGeeyFeuzFuyzFuq6E+27FO+Cee3CEdaGgdqTjvCNhfKYkvOkngAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJezdycAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGHRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4xLjb9TgnoAAAQGElEQVR4Xt2d+WMUtxXHbS6bEGMPMcQQ04aEUnqYo9xJWvC6kAKmQLM2rdn//9+g0uir2Tl0PElPszP7+cnH7Fj6rPTeG2lmvfKld2azk8lk/36L/cnkZDbDIT3Sp4DZ8QS9dTI57tNDTwJOOu+4j/0TvDQz+QXMSG+7mUn+sZBZQELnNROcKhMZBXx+gS4k8+IzTpmBXAJOnqPxTDzPFRKyCODuvSKPgwwC2EZ+lxf4E4xwCzhBU7PBPQx4BWR88+fwDgNGAbMsM9/Ec8bygE3A5966L3nOlhiZBGSf+l2YggGLgBna1DMsE4FBQH9zvw1HLEgX0Evkt5GeEVIFMFztpJF6rZQm4DNasVDSEkKSgIVN/ibP0ZwoEgQsfPTPSZgH8QIG8vYr4gdBrIABvf2K2EEQKWBQb78ichBECRhE8O8SlQ5iBAQvcffFPhoYQoSAAQ5/TcQ0CBYw0OGvCZ4GoQIGF/3bhGaDQAELvfKhERgIwgQMePrPCQsEQQLwFwYPmksiQMCC1n1iCFgooQtYwLJfPPQFQ7KAUfU/wABVwMj6TzdAFDDY6tcOMR3SBIyw/1QDJAGj7D/RAEXA6Oa/hhIHCAJG23+SAb+AEfefYsArYET1nwlvTegVgBONFnTDik8ATjNi0BEbHgGjuP5147k6dgsYaQHQxF0OOAUMfv2LhnOVzCVg4OufdFwrpS4BePkSgA6ZcAhYggCocQRCu4ClCIAaeyC0CliaAKCwhgGrALxwaUC3OtgELFEAUNjCgEXAklQAdSzVgEUAXrRUoGstzAKWbgJIzJPAKGAJJ4DEOAmMAvCCpQPda2ASsJQTQGKa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',
		}

		TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
	end)
end

-- Create Blips
Citizen.CreateThread(function()
	local blip2 = AddBlipForCoord(Config.Zones.ShopEntering2.Pos)

	SetBlipSprite (blip2, 404)
	SetBlipDisplay(blip2, 4)
	SetBlipScale  (blip2, 1.0)
	SetBlipAsShortRange(blip2, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Salon brodova")
	EndTextCommandSetBlipName(blip2)
end)

function SpawnVozila(id)
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil and Vozila[i].SalonID == id and Vozila[i].Lokacija ~= nil and Vozila[i].Lokacija ~= "{}" then
			ESX.Game.SpawnLocalVehicle(tonumber(Vozila[i].Model), Vozila[i].Lokacija, Vozila[i].Heading, function(vehicle)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(GetHashKey(tonumber(Vozila[i].Model)))
				SetVehicleDirtLevel(vehicle, 0)
				ESX.Game.SetVehicleProperties(vehicle, Vozila[i].Prop)
				table.insert(LokalnaVozila, {ID = vehicle, Mjenjac = Vozila[i].Mjenjac, sID = Vozila[i].SalonID, Cijena = Vozila[i].Cijena, vID = Vozila[i].ID})
			end)
		end
	end
end

function ObrisiVozila()
	for i=1, #LokalnaVozila, 1 do
		if LokalnaVozila[i] ~= nil then
			if DoesEntityExist(LokalnaVozila[i].ID) then
				ESX.Game.DeleteVehicle(LokalnaVozila[i].ID)
			end
		end
	end
	LokalnaVozila = {}
end

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	if currentSeat == -1 then
		if OtvorenHTML == false then
			for i=1, #LokalnaVozila, 1 do
				if LokalnaVozila[i] ~= nil then
					if DoesEntityExist(LokalnaVozila[i].ID) then
						if currentVehicle == LokalnaVozila[i].ID then
							local turbo = "Ne"
							if IsToggleModOn(currentVehicle, 18) then
								turbo = "Da"
							end
							local mjenjac2 = "Automatik"
							Mjenjac = tonumber(LokalnaVozila[i].Mjenjac)
							if Mjenjac == 2 then
								mjenjac2 = "Rucni"
							end
							local armor
							local kocnice
							local mjenjac
							local motor
							local suspenzija
							if GetVehicleMod(currentVehicle, 16) == -1 then
								armor = "Default"
							else
								armor = "Level "..GetVehicleMod(currentVehicle, 16)
							end
							if GetVehicleMod(currentVehicle, 12) == -1 then
								kocnice = "Default"
							else
								kocnice = "Level "..GetVehicleMod(currentVehicle, 12)
							end
							if GetVehicleMod(currentVehicle, 13) == -1 then
								mjenjac = "Default"
							else
								mjenjac = "Level "..GetVehicleMod(currentVehicle, 13)
							end
							if GetVehicleMod(currentVehicle, 11) == -1 then
								motor = "Default"
							else
								motor = "Level "..GetVehicleMod(currentVehicle, 11)
							end
							if GetVehicleMod(currentVehicle, 15) == -1 then
								suspenzija = "Default"
							else
								suspenzija = "Level "..GetVehicleMod(currentVehicle, 15)
							end
							SendNUIMessage({
								prikazi2 = true
							})
							SendNUIMessage({
								postavisve = true,
								armor = armor,
								kocnice = kocnice,
								mjenjac = mjenjac,
								vmjenjac = mjenjac2,
								motor = motor,
								suspenzija = suspenzija,
								turbo = turbo
							})
							local arge = {vID = LokalnaVozila[i].vID, Mjenjac = LokalnaVozila[i].Mjenjac, sID = LokalnaVozila[i].sID}
							TriggerEvent("upit:OtvoriPitanje", "esx_vehicleshop", "Kupovina vozila", "Zelite li kupiti ovo vozilo za $"..LokalnaVozila[i].Cijena.."?", arge)
							OtvorenHTML = true
							break
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, modelName, netId)
	if OtvorenHTML then
		SendNUIMessage({
			prikazi2 = true
		})
		OtvorenHTML = false
	end
end)

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		local arg = data.args
		if br == 1 then
			if GarazaV ~= nil then
				TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
				GarazaV = nil
				if Vblip ~= nil then
					RemoveBlip(Vblip)
					Vblip = nil
				end
			end
			local generatedPlate = GeneratePlate()
			local veh = GetVehiclePedIsIn(PlayerPedId())
			local corda = GetEntityCoords(veh)
			local head = GetEntityHeading(veh)
			local prop = ESX.Game.GetVehicleProperties(veh)
			prop.plate = generatedPlate
			ESX.TriggerServerCallback('autosalon:sealion2', function(success)
				if success then
					TriggerServerEvent("salon:SpawnVozilo", prop, corda, head, generatedPlate, arg.Mjenjac)
				else
					ESX.ShowNotification("Nemate dovoljno novca!")
				end
			end, arg.vID, generatedPlate)
		else
			for i=1, #Saloni, 1 do
				if Saloni[i] ~= nil and Saloni[i].ID == arg.sID then
					if Saloni[i].Vlasnik == ESX.PlayerData.identifier then
						--Ovdje ide menu za cijenu i vracanje u garazu
						local elements = {
							{label = "Promjeni cijenu", item = "cij"},
							{label = "Vrati u garazu", item = "garaza"}
						}
						ESX.UI.Menu.CloseAll()
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop2a3', {
							title    = "Izaberite opciju",
							align    = 'bottom-right',
							elements = elements
						}, function(data, menu)
							if data.current.item == 'garaza' then
								TriggerServerEvent('saloni:SpremiUGarazu', arg.vID)
								menu.close()
							elseif data.current.item == 'cij' then
								ESX.UI.Menu.Open(
								'dialog', GetCurrentResourceName(), 'shops_daj_lovufds',
								{
									title = "Unesite cijenu vozila"
								},
								function(data3, menu3)

									local count = tonumber(data3.value)

									if count == nil then
										ESX.ShowNotification("Kriva vrijednost!")
									elseif count < 1 then
										ESX.ShowNotification("Kriva vrijednost!")
									else
										menu3.close()
										menu.close()
										TriggerServerEvent("saloni:PostaviCijenu", arg.vID, count)
									end
								end,
								function(data3, menu3)
									menu3.close()
								end
								)
							end
						end, function(data, menu)
							menu.close()
							TaskLeaveAnyVehicle(PlayerPedId(), true, 0)	
						end)
					else
						TaskLeaveAnyVehicle(PlayerPedId(), true, 0)	
					end
					break
				end
			end
		end
    end
)

-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true
		local ID = nil

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < Config.DrawDistance then
				letSleep = false

				if v.Type ~= -1 and k ~= "ShopEntering" then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
				end

				if k == "ShopEntering" and ImamSalon then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
				end

				if distance < v.Size.x then
					if k == "ShopEntering" then
						if ImamSalon then
							isInMarker, currentZone = true, k
						end
					else
						isInMarker, currentZone = true, k
					end
				end
			end
		end

		if #Cpovi > 0 then
			for i=1, #Cpovi, 1 do
				if Cpovi[i] ~= nil then
					if #(playerCoords-Cpovi[i].Koord) > 100 then
						if Cpovi[i].Spawnan then
							DeleteCheckpoint(Cpovi[i].ID)
							ObrisiVozila()
							Cpovi[i].Spawnan = false
						end
					else
						if Cpovi[i].Spawnan == false then
							local kord = Cpovi[i].Koord
							local range = 2.0
							local check = CreateCheckpoint(47, kord.x, kord.y, kord.z, 0, 0, 0, range, Cpovi[i].r, Cpovi[i].g, Cpovi[i].b, 100)
							SetCheckpointCylinderHeight(check, range, range, range)
							Cpovi[i].ID = check
							Cpovi[i].Spawnan = true
							SpawnVozila(Cpovi[i].sID)
						end
					end
				end
			end
			for i=1, #Cpovi, 1 do
				if Cpovi[i] ~= nil and Cpovi[i].Spawnan then
					if #(playerCoords-Cpovi[i].Koord) < 1.5 then
						letSleep = false
						isInMarker  = true
						currentZone = "vlasnik_menu"
						ID = Cpovi[i].sID
						break
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			LastZone = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone, ID)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(500)
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

function OpenUpitProdajeMenu(cardata)
		local elements = {}
		table.insert(elements, {
			label = 'Da ($'..ESX.Math.GroupDigits(cardata.price)..')',
			value = 'da'
		})
		
		table.insert(elements, {
			label = 'Ne',
			value = 'ne'
		})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upit_prodaja_menu', {
			title    = "Jeste li sigurni da zelite prodati vase vozilo?",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == "da" then
				local koord = GetEntityCoords(PlayerPedId())
				if GetDistanceBetweenCoords(koord, -44.569271087646, -1081.7122802734, 25.685205459595, true) <= 3.0 or GetDistanceBetweenCoords(koord, -731.54217529297, -1334.6604003906, 0.28573158383369, true) <= 3.0 then
					if cardata.kategorija ~= "donatorski" and cardata.kategorija ~= "razz" then
						ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
							if vehicleSold then
								if GarazaV ~= nil then
									TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
									GarazaV = nil
									if Vblip ~= nil then
										RemoveBlip(Vblip)
										Vblip = nil
									end
								else
									local veh = GetVehiclePedIsIn(PlayerPedId())
									local prop = ESX.Game.GetVehicleProperties(veh)
									local pla = prop.plate:gsub("^%s*(.-)%s*$", "%1")
									ESX.Game.DeleteVehicle(veh)
									TriggerServerEvent("garaza:SpremiModel", pla, nil)
									GarazaV = nil
									TriggerEvent("esx_property:ProsljediVozilo", nil, nil)
									if Vblip ~= nil then
										RemoveBlip(Vblip)
										Vblip = nil
									end
								end
								ESX.ShowNotification(_U('vehicle_sold_for', cardata.label, ESX.Math.GroupDigits(cardata.price)))
							else
								ESX.ShowNotification(_U('not_yours'))
							end
						end, cardata.plate, cardata.model)
					else
						ESX.ShowNotification("Ne smijete prodati donatorsko vozilo!")
					end
				end
			end
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
end

function OtvoriVlasnikMenu(id)
	local elements = {}
	local lova = 0
	ESX.TriggerServerCallback('saloni:DajSef', function(lov)
		lova = lov
	end, id)
	Wait(400)
	local cij = 0
	local skoord = nil
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == id then
			cij = Saloni[i].Cijena
			skoord = Saloni[i].Kupovina
		end
	end
	ESX.TriggerServerCallback('saloni:DajDostupnost', function(jelje)
		if jelje == 1 then
			table.insert(elements, {
				label      = "Kupite salon ($"..cij..")",
				label_real = "kupi",
				item       = "kupit",
				price      = cij,
			})
		else
			ESX.TriggerServerCallback('saloni:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					table.insert(elements, {
						label      = "Podignite novac $"..lova,
						label_real = "podigni",
						item       = "podignin",
						price      = 0,
					})
					table.insert(elements, {
						label      = "Izvezi vozila",
						label_real = "izvoz",
						item       = "izvoz",
						price      = 0,
					})
					table.insert(elements, {
						label      = "Prodaj igracu",
						label_real = "prodaj2",
						item       = "prodajt2",
						price      = 0,
					})
					table.insert(elements, {
						label      = "Prodaj ($"..math.floor(cij/2)..")",
						label_real = "prodaj",
						item       = "prodajt",
						price      = 0,
					})
				end
			end, id)
		end
	end, id)
	Wait(1000)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop23', {
		title    = "Izaberite opciju",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.item == 'kupit' then
			TriggerServerEvent('saloni:piku2', id)
			menu.close()
			HasAlreadyEnteredMarker = false
		elseif data.current.item == 'podignin' then
			ESX.UI.Menu.Open(
			  'dialog', GetCurrentResourceName(), 'shops_daj_lovu',
			  {
				title = "Unesite koliko novca zelite podici"
			  },
			  function(data3, menu3)

				local count = tonumber(data3.value)

				if count == nil then
					ESX.ShowNotification("Kriva vrijednost!")
				elseif lova < count then
					ESX.ShowNotification("Nemate toliko u sefu!")
				else
					menu3.close()
					menu.close()
					TriggerServerEvent("saloni:OduzmiSef", id, count)
					HasAlreadyEnteredMarker = false
				end
			  end,
			  function(data3, menu3)
				menu3.close()
			  end
			)
		elseif data.current.item == "izvoz" then
			menu.close()
			local elements2 = {}
			
			for i=1, #Vozila, 1 do
				if Vozila[i] ~= nil and Vozila[i].SalonID == id and (Vozila[i].Lokacija == nil or Vozila[i].Lokacija == "{}") then
					table.insert(elements2, {label = GetDisplayNameFromVehicleModel(tonumber(Vozila[i].Model)), value = Vozila[i].ID, prop = Vozila[i].Prop, mjenjac = Vozila[i].Mjenjac, model = tonumber(Vozila[i].Model)})
				end
			end

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'sdgfsdfgff',
			  {
				title    = "Izaberite vozilo",
				align    = 'bottom-right',
				elements = elements2,
			  },
			  function(datalr, menulr)
				menulr.close()
				local br = datalr.current.value
				ESX.Game.SpawnVehicle(datalr.current.model, {
					x = skoord.x,
					y = skoord.y,
					z = skoord.z
				}, 184.33929443359, function(callback_vehicle)
					TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
					ESX.Game.SetVehicleProperties(callback_vehicle, datalr.current.prop)
					TriggerEvent("EoTiIzSalona", datalr.current.mjenjac)
					local saloniram = true
					Citizen.CreateThread(function()
						while saloniram do
							Citizen.Wait(0)
							ESX.ShowHelpNotification("Pritisnite ~INPUT_CONTEXT~ da parkirate vozilo ili ~INPUT_VEH_DUCK~ da odustanete")
							if IsControlJustReleased(0, 51) then
								local koord = GetEntityCoords(callback_vehicle)
								local head = GetEntityHeading(callback_vehicle)
								TriggerServerEvent("saloni:SpremiVozilo", id, br, koord, head)
								ESX.Game.DeleteVehicle(callback_vehicle)
								saloniram = false
							end
							if IsControlJustReleased(0, 73) then
								ESX.Game.DeleteVehicle(callback_vehicle)
								saloniram = false
							end
						end
					end)
				end)
			  end,
			  function(datalr, menulr)
				menulr.close()
			  end
			)
		elseif data.current.item == 'prodajt' then
			menu.close()
			TriggerServerEvent("saloni:Prodaj", id)
		elseif data.current.item == 'prodajt2' then
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'trg_prodaj_igr23',
					{
						title = "Unesite cijenu za koju zelite prodati salon"
					},
					function(data3, menu3)

					local count = tonumber(data3.value)

					if count == nil then
						ESX.ShowNotification("Kriva vrijednost!")
					else
						menu3.close()
						menu.close()
						TriggerServerEvent("saloni:ProdajIgracu", id, GetPlayerServerId(player), count)
					end
					end,
					function(data3, menu3)
						menu3.close()
						menu.close()
					end
				)
			else
				ESX.ShowNotification('Nema igraca u blizini!')
			end
		end
	end, function(data, menu)
		menu.close()
		HasAlreadyEnteredMarker = false
	end)
end

RegisterNetEvent('saloni:PitajProdaju')
AddEventHandler('saloni:PitajProdaju', function(ime, cijena, pid)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'trgovaraa',
		{
				title    = "Zelite li kupiti salon "..ime.." za $"..cijena.."?",
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
		},
		function(data69, menu69)
			menu69.close()
			if data69.current.value == 'da' then
				TriggerServerEvent("saloni:PrihvatioProdaju", ime, cijena, pid)
			end

			if data69.current.value == 'ne' then
				ESX.ShowNotification("Odbili ste ponudu za kupnju salona!")
				TriggerServerEvent("saloni:OdbioProdaju", pid)
				menu69.close()
			end
		end,
		function(data69, menu69)
			 menu69.close()
		end
	)
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 202) then
				if CurrentAction == 'shop_pregled' then
					for i=1, #Categories, 1 do
						local category         = Categories[i]
						if not Brod then
							if category.brod == 0 then
								if category.name ~= "obrisani" then
									SendNUIMessage({
										dodajkat = true,
										ime = category.name,
										label = category.label
									})
								end
							end
						else
							if category.brod == 1 then
								if category.name ~= "obrisani" then
									SendNUIMessage({
										dodajkat = true,
										ime = category.name,
										label = category.label
									})
								end
							end
						end
					end
					SendNUIMessage({
						prikazi = true
					})
					SetNuiFocus(true, true)
					CurrentAction = nil
				end
			end
			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					if Config.LicenseEnable then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDriversLicense)
							if hasDriversLicense then
								OpenShopMenu()
							else
								ESX.ShowNotification(_U('license_missing'))
							end
						end, GetPlayerServerId(PlayerId()), 'drive')
					else
						OpenShopMenu()
					end
				elseif CurrentAction == 'reseller_menu' then
					OpenResellerMenu()
				elseif CurrentAction == 'vlasnik_menu' then
					OtvoriVlasnikMenu(CurrentActionData.sID)
				elseif CurrentAction == 'give_back_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:giveBackVehicle', function(isRentedVehicle)
						if isRentedVehicle then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('delivered'))
						else
							ESX.ShowNotification(_U('not_rental'))
						end
					end, ESX.Math.Trim(GetVehicleNumberPlateText(CurrentActionData.vehicle)))
				elseif CurrentAction == 'resell_vehicle' then
					OpenUpitProdajeMenu(CurrentActionData)
				elseif CurrentAction == 'boss_actions_menu' then
					OpenBossActionsMenu()
				end
				if CurrentAction ~= "shop_pregled" then
					CurrentAction = nil
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)
