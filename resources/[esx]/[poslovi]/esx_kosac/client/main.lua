--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil
local Objekti = {}
local Spawno = false
local Broj = 0
local Radis = false
local Vozilo = nil
local Prikolica = nil
local Mower = nil
local prop_ent = nil
local SpawnMarker = false
local Ulica = false
local Blipic = nil
local ObjBr = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().posao == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
--------------------------------------------------------------------------------
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blipara				  = {}
--------------------------------------------------------------------------------
function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	DodajBlip()
end
function DodajBlip()
	local blip = AddBlipForCoord(Config.ZaposliSe.Pos.x, Config.ZaposliSe.Pos.y, Config.ZaposliSe.Pos.z)
	SetBlipSprite  (blip, Config.ZaposliSe.Sprite)
	SetBlipDisplay (blip, 4)
	SetBlipScale   (blip, 1.2)
	SetBlipCategory(blip, 3)
	SetBlipColour  (blip, Config.ZaposliSe.BColor)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Kosac")
	EndTextCommandSetBlipName(blip)
end
-- MENUS
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
				TriggerEvent("dpemotes:Radim", false)
			end
			if data.current.value == 'job_wear' then
				isInService = true
				setUniform(PlayerPedId())
				--[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)]]
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end
	table.insert(elements, {label = "Obicna kosilica", value = "kosilica"})
	table.insert(elements, {label = "Košenje ulica", value = "ulica"})


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "mower" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 315.28479003906, true, false)
			platenum = math.random(10000, 99999)
			SetModelAsNoLongerNeeded(data.current.value)
			SetVehicleNumberPlateText(Vozilo, "WAL"..platenum)             
			plaquevehicule = "WAL"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			Radis = true
			TriggerEvent("dpemotes:Radim", true)
			SpawnObjekte()
		elseif data.current.value == "kosilica" then
			SetEntityCoords(PlayerPedId(), -1348.0754394531, 128.62022399902, 55.238655090332, false, false, false, true)
			SetEntityHeading(PlayerPedId(), 220.04908752441)
			if prop_ent ~= nil then
				DeleteObject(prop_ent)
			end
			ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
				TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50)
			end)
			local modele = "prop_lawnmower_01"
			ESX.Streaming.RequestModel(modele)
			prop_ent = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)
			AttachEntityToEntityPhysically(prop_ent, PlayerPedId(), 0, GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis"), 0.175, 0.90, -0.86, -0.075, 0.90, -0.86, 0.0, 0.5, 181.0, 10000.0, true, true, true, false, 2)
			SetModelAsNoLongerNeeded(modele)
			TriggerEvent("dpemotes:Radim", true)
			SendNUIMessage({
				start = true
			})
			Radis = true
			SpawnObjekte2()
		elseif data.current.value == "ulica" then
			if ESX.Game.IsSpawnPointClear({
					x = -1382.7465820313,
					y = 96.325782775879,
					z = 54.323829650879
				}, 5.0) then
				if Vozilo ~= nil then
					ESX.Game.DeleteVehicle(Vozilo)
					Vozilo = nil
				end
				if Prikolica ~= nil then
					ESX.Game.DeleteVehicle(Prikolica)
					Prikolica = nil
				end
				if Mower ~= nil then
					ESX.Game.DeleteVehicle(Mower)
					Mower = nil
				end
				DoScreenFadeOut(100)
				while not IsScreenFadedOut() do
					Wait(1)
				end
				ESX.Game.SpawnVehicle("bobcat3", {
					x = -1382.7465820313,
					y = 96.325782775879,
					z = 54.323829650879
				}, 184.33929443359, function(callback_vehicle)
					Vozilo = callback_vehicle
					TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
				end)
				while Vozilo == nil do
					Wait(1)
				end
				--Wait(200)
				ESX.Game.SpawnVehicle("cartrailer", {
					x = -1382.7465820313,
					y = 96.325782775879,
					z = 54.323829650879
				}, 184.33929443359, function(callback_vehicle)
					local retval = GetVehiclePedIsIn(PlayerPedId(), false)
					AttachVehicleToTrailer(retval, callback_vehicle, 5)
					Prikolica = callback_vehicle
					SetVehicleExtra(callback_vehicle, 1, true)
				end)
				while Prikolica == nil do
					Wait(1)
				end
				--Wait(200)
				ESX.Game.SpawnVehicle("mower", {
					x = -1382.7465820313,
					y = 96.325782775879,
					z = 54.323829650879
				}, 184.33929443359, function(callback_vehicle)
					AttachVehicleOnToTrailer(callback_vehicle, Prikolica, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
					AttachEntityToEntity(callback_vehicle, Prikolica, -1, 0, -2.0, 0, 0, 0, 0, false, false, false, false, 0, true)
					Mower = callback_vehicle
					--FreezeEntityPosition(callback_vehicle, true)
				end)
				Radis = true
				Blipic = AddBlipForCoord(1062.2674560547, -396.4440612793,  66.810272216797)
				SetBlipRoute(Blipic, true)
				SpawnMarker = true
				Ulica = true
				DoScreenFadeIn(100)
				while not IsScreenFadedIn() do
					Wait(1)
				end
				TriggerEvent("dpemotes:Radim", true)
				ESX.ShowNotification("Odite na lokaciju i pokosite travu!")
			else
				ESX.ShowNotification("Trenutno nemamo slobodnih kosilica!")
			end
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function setUniform(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms.EUP == false or Config.Uniforms.EUP == nil then
				if Config.Uniforms["uniforma"].male then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["uniforma"].male)
				else
					ESX.ShowNotification("Nema postavljene uniforme!")
				end
			else
				local jobic = "EUPuniforma"
				local outfit = Config.Uniforms[jobic].male
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end

				ped = PlayerPedId()

				for _, comp in ipairs(outfit.components) do
				   SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
				end

				for _, comp in ipairs(outfit.props) do
					if comp[2] == 0 then
						ClearPedProp(ped, comp[1])
					else
						SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
					end
				end
			end
			
		else
			if Config.Uniforms.EUP == false then
				if Config.Uniforms["uniforma"].female then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["uniforma"].female)
				else
					ESX.ShowNotification(_U('no_outfit'))
				end
			else
				local jobic = "EUPuniforma"
				local outfit = Config.Uniforms[jobic].female
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end

				ped = PlayerPedId()

				for _, comp in ipairs(outfit.components) do
				   SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
				end

				for _, comp in ipairs(outfit.props) do
					if comp[2] == 0 then
						ClearPedProp(ped, comp[1])
					else
						SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
					end
				end
			end


		end
	end)
end

function SpawnObjekte3()
		for i=1, #Config.Objekti3, 1 do
			ESX.Game.SpawnLocalObject('prop_veg_grass_02_a', {
					x = Config.Objekti3[i].x,
					y = Config.Objekti3[i].y,
					z = Config.Objekti3[i].z
			}, function(obj)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
			end)
			Blipara[i] = AddBlipForCoord(Config.Objekti3[i].x,  Config.Objekti3[i].y,  Config.Objekti3[i].z)
			SetBlipSprite (Blipara[i], 1)
			SetBlipDisplay(Blipara[i], 8)
			SetBlipColour (Blipara[i], 2)
			SetBlipScale  (Blipara[i], 1.4)
		end
		Broj = #Config.Objekti3
		Spawno = true
		ESX.ShowNotification("Pokosite travu!")
end

function SpawnObjekte2()
		for i=1, #Config.Objekti2, 1 do
			ESX.Game.SpawnLocalObject('prop_veg_grass_02_a', {
					x = Config.Objekti2[i].x,
					y = Config.Objekti2[i].y,
					z = Config.Objekti2[i].z
			}, function(obj)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
			end)
			Blipara[i] = AddBlipForCoord(Config.Objekti2[i].x,  Config.Objekti2[i].y,  Config.Objekti2[i].z)
			SetBlipSprite (Blipara[i], 1)
			SetBlipDisplay(Blipara[i], 8)
			SetBlipColour (Blipara[i], 2)
			SetBlipScale  (Blipara[i], 1.4)
		end
		Broj = #Config.Objekti2
		Spawno = true
		ESX.ShowNotification("Pokosite travu!")
end

function SpawnObjekte()
		for i=1, #Config.Objekti, 1 do
			ESX.Game.SpawnLocalObject('prop_grass_dry_03', {
					x = Config.Objekti[i].x,
					y = Config.Objekti[i].y,
					z = Config.Objekti[i].z
			}, function(obj)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
			end)
			Blipara[i] = AddBlipForCoord(Config.Objekti[i].x,  Config.Objekti[i].y,  Config.Objekti[i].z)
			SetBlipSprite (Blipara[i], 1)
			SetBlipDisplay(Blipara[i], 8)
			SetBlipColour (Blipara[i], 2)
			SetBlipScale  (Blipara[i], 1.4)
		end
		Broj = #Config.Objekti
		Spawno = true
		ESX.ShowNotification("Pokosite travu!")
end

function IsATruck()
	local isATruck = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			isATruck = true
			break
		end
	end
	return isATruck
end

function IsJobKosac()
	if ESX.PlayerData.posao ~= nil then
		local kosac = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'kosac' then
			kosac = true
		end
		return kosac
	end
end

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		if br == 1 then
			TriggerServerEvent('esx_joblisting:setJob', 9)
			ESX.ShowNotification("Zaposlio si se kao kosac!")
		end
    end
)

AddEventHandler('esx_kosac:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_kosac", "Upit za posao", "Dali se zelite zaposliti kao kosac?")
	end

	if zone == 'ulica' then
		DoScreenFadeOut(100)
		while not IsScreenFadedOut() do
			Wait(1)
		end
		SpawnObjekte3()
		ESX.Game.DeleteVehicle(Vozilo)
		ESX.Game.DeleteVehicle(Prikolica)
		ESX.Game.DeleteVehicle(Mower)
		Vozilo = nil
		Prikolica = nil
		Mower = nil
		RemoveBlip(Blipic)
		Blipic = nil
		SpawnMarker = false
		ESX.Streaming.RequestModel("mower")
		Mower = CreateVehicle("mower", Config.Objekti3[1].x, Config.Objekti3[1].y, Config.Objekti3[1].z, 135.62, true, false)
		platenum = math.random(10000, 99999)
		SetModelAsNoLongerNeeded("mower")
		ObjBr = 1
		SetVehicleNumberPlateText(Mower, "WAL"..platenum)             
		plaquevehicule = "WAL"..platenum			
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), Mower, -1)
		Wait(500)
		DoScreenFadeIn(100)
		TriggerEvent("baseevents:enteredVehicle", GetVehiclePedIsIn(PlayerPedId()), -1, 69, 69)
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobKosac() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' or zone == "VehicleDeletePoint2" then
		if isInService and IsJobKosac() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

function ZavrsiPosao()
	if Mower ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		ESX.Game.DeleteVehicle(Prikolica)
		ESX.Game.DeleteVehicle(Mower)
		RemoveBlip(Blipic)
		for i=1, #Config.Objekti3, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
		Broj = 0
		Vozilo = nil
		Prikolica = nil
		Mower = nil
		Spawno = false
		Radis = false
		Ulica = false
		SpawnMarker = false
		TriggerEvent("dpemotes:Radim", false)
	elseif prop_ent == nil then
		for i=1, #Config.Objekti, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
		Broj = 0
		if Vozilo ~= nil then
			ESX.Game.DeleteVehicle(Vozilo)
			Vozilo = nil
		end
		Spawno = false
		Radis = false
		TriggerEvent("dpemotes:Radim", false)
	else
		for i=1, #Config.Objekti2, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
		Broj = 0
		Spawno = false
		Radis = false
		if prop_ent ~= nil then
			DeleteObject(prop_ent)
		end
		SendNUIMessage({
			stop = true
		})
		prop_ent = nil
		ClearPedSecondaryTask(PlayerPedId())
		TriggerEvent("dpemotes:Radim", false)
	end
end

AddEventHandler('esx_kosac:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
		if IsJobKosac() then
			if Spawno == true and Broj > 0 then
				local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
				if tablica == plaquevehicule then
					if Ulica == false then
						local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_grass_dry_03")
						for i=1, #Config.Objekti, 1 do
							if Objekti[i] == NewBin then
								if NewBinDistance <= 2 then
									Wait(600)
									ESX.Game.DeleteObject(Objekti[i])
									if DoesBlipExist(Blipara[i]) then
										RemoveBlip(Blipara[i])
									end
									Broj = Broj-1
									TriggerServerEvent("kosaaac:platituljanu")
									TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
									if Broj == 0 then
										local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
										ESX.Game.DeleteVehicle(vehicle)
										Spawno = false
										Radis = false
										Broj = 0
										ESX.ShowNotification("Uspjesno zavrsen posao!")
										TriggerEvent("dpemotes:Radim", false)
									end
								end
							end
						end
					else
						--local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_veg_grass_02_a")
						--local koord = GetEntityCoords(PlayerPedId())
						--for i=1, #Config.Objekti3, 1 do
							if Objekti[ObjBr] ~= nil then
								local koord = GetEntityCoords(PlayerPedId())
								if GetDistanceBetweenCoords(koord, Config.Objekti3[ObjBr].x, Config.Objekti3[ObjBr].y, Config.Objekti3[ObjBr].z, false) <= 1 then
									--if NewBinDistance <= 2 then
										Wait(100)
										ESX.Game.DeleteObject(Objekti[ObjBr])
										Objekti[ObjBr] = nil
										if DoesBlipExist(Blipara[ObjBr]) then
											RemoveBlip(Blipara[ObjBr])
										end
										Broj = Broj-1
										ObjBr = ObjBr+1
										TriggerServerEvent("kosaaac:platituljanu3")
										TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
										if Broj == 0 then
											DoScreenFadeOut(100)
											while not IsScreenFadedOut() do
												Wait(1)
											end
											ObjBr = 1
											local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
											ESX.Game.DeleteVehicle(vehicle)
											Spawno = false
											Radis = false
											Ulica = false
											Blipic = AddBlipForCoord(-1399.4075927734, 94.852767944336, 52.881084442139)
											SetBlipRoute(Blipic, true)
											Broj = 0
											local novacor = GetEntityCoords(PlayerPedId())
											local x,y,z = table.unpack(novacor)
											local retval, outPosition, outHeading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3.0, 0)
											ESX.Game.SpawnVehicle("bobcat3", outPosition, outHeading, function(callback_vehicle)
												Vozilo = callback_vehicle
												TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
											end)
											while Vozilo == nil do
												Wait(1)
											end
											--Wait(200)
											ESX.Game.SpawnVehicle("cartrailer", outPosition, outHeading, function(callback_vehicle)
												local retval = GetVehiclePedIsIn(PlayerPedId(), false)
												AttachVehicleToTrailer(retval, callback_vehicle, 5)
												Prikolica = callback_vehicle
												SetVehicleExtra(callback_vehicle, 1, true)
											end)
											while Prikolica == nil do
												Wait(1)
											end
											--Wait(200)
											ESX.Game.SpawnVehicle("mower", outPosition, outHeading, function(callback_vehicle)
												AttachVehicleOnToTrailer(callback_vehicle, Prikolica, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
												AttachEntityToEntity(callback_vehicle, Prikolica, -1, 0, -2.0, 0, 0, 0, 0, false, false, false, false, 0, true)
												Mower = callback_vehicle
												--FreezeEntityPosition(callback_vehicle, true)
											end)
											DoScreenFadeIn(100)
											while not IsScreenFadedIn() do
												Wait(1)
											end
											TriggerEvent("baseevents:enteredVehicle", GetVehiclePedIsIn(PlayerPedId()), -1, 69, 69)
											ESX.ShowNotification("Uspjesno zavrsen posao, sada vratite kosilicu do sjedista!")
											TriggerEvent("dpemotes:Radim", false)
										end
										--break
									--end
								else
									Wait(100)
								end
							end
						--end
					end
				end
				local cora = GetEntityCoords(prop_ent)
				local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_veg_grass_02_a", cora)
				for i=1, #Config.Objekti2, 1 do
					if Objekti[i] == NewBin then
						if NewBinDistance <= 0.8 then
							ESX.Game.DeleteObject(Objekti[i])
							if DoesBlipExist(Blipara[i]) then
								RemoveBlip(Blipara[i])
							end
							Broj = Broj-1
							TriggerServerEvent("kosaaac:platituljanu2")
							TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
							if Broj == 0 then
								DeleteObject(prop_ent)
								SendNUIMessage({
									stop = true
								})
								prop_ent = nil
								Spawno = false
								Radis = false
								Broj = 0
								ClearPedSecondaryTask(PlayerPedId())
								ESX.ShowNotification("Uspjesno zavrsen posao!")
								TriggerEvent("dpemotes:Radim", false)
							end
						end
					end
				end
			end
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) and IsJobKosac() then

					if CurrentAction == 'Obrisi' then
						ZavrsiPosao()
					end
					CurrentAction = nil
				end
			end
		else
			Citizen.Wait(500)
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local isInMarker  = false
		local currentZone = nil
		if IsJobKosac() then
			if prop_ent ~= nil then
				waitara = 0
				naso = 1
				SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
				ResetPedMovementClipset(PlayerPedId())
				DisableControlAction(0, 21, true)
				DisableControlAction(0, 22, true)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
			end

			local coords      = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if Radis == true and Ulica == true and (GetDistanceBetweenCoords(coords, 1062.2674560547, -396.4440612793, 65.810272216797, true) < 3.0) then
				local cordara = GetEntityCoords(Prikolica)
				if GetDistanceBetweenCoords(cordara, 1062.2674560547, -396.4440612793, 65.810272216797, true) < 6.0 then
					isInMarker  = true
					currentZone = "ulica"
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_kosac:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_kosac:hasExitedMarker', lastZone)
			end

		
			if SpawnMarker and GetDistanceBetweenCoords(coords, 1062.2674560547, -396.4440612793, 65.810272216797, true) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 1062.2674560547, -396.4440612793, 65.810272216797, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			for k,v in pairs(Config.Zones) do

				if isInService and (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end

			for k,v in pairs(Config.Cloakroom) do

				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end
		else
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			if(Config.ZaposliSe.Type ~= -1 and #(coords-Config.ZaposliSe.Pos) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(Config.ZaposliSe.Type, Config.ZaposliSe.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZaposliSe.Size.x, Config.ZaposliSe.Size.y, Config.ZaposliSe.Size.z, Config.ZaposliSe.Color.r, Config.ZaposliSe.Color.g, Config.ZaposliSe.Color.b, 100, false, true, 2, false, false, false, false)
			end
			if #(coords-Config.ZaposliSe.Pos) < Config.ZaposliSe.Size.x then
				waitara = 0
				naso = 1
				isInMarker  = true
				currentZone = "posao"
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_kosac:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_kosac:hasExitedMarker', lastZone)
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setPosao')
AddEventHandler('esx:setPosao', function(job)
	ESX.PlayerData.posao = job
	ZavrsiPosao()
end)