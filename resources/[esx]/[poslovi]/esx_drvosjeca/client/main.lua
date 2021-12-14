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
local SpawnMarker = false
local SpawnMarker2 = false
local Ulica = false
local Blipic = nil
local Udario = {}

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
	PlayerData = ESX.GetPlayerData()
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
	AddTextComponentString("Drvosjeca")
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
				ZavrsiPosao()
			end
			if data.current.value == 'job_wear' then
				isInService = true
				setUniform(PlayerPedId())
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), 1, false, true)
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

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "phantom" then
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
				DoScreenFadeOut(100)
				while not IsScreenFadedOut() do
					Wait(1)
				end
				ESX.Game.SpawnVehicle("phantom", {
					x = 1194.62,
					y = -1286.95,
					z = 34.12
				}, 267.04, function(callback_vehicle)
					Vozilo = callback_vehicle
					TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
				end)
				while Vozilo == nil do
					Wait(1)
				end
				--Wait(200)
				ESX.Game.SpawnVehicle("TRFlat", {
					x = 1194.62,
					y = -1286.95,
					z = 34.12
				}, 267.04, function(callback_vehicle)
					local retval = GetVehiclePedIsIn(PlayerPedId(), false)
					AttachVehicleToTrailer(retval, callback_vehicle, 5)
					Prikolica = callback_vehicle
				end)
				while Prikolica == nil do
					Wait(1)
				end
				Radis = true
				Blipic = AddBlipForCoord(1856.0534667969, 4991.2924804688, 53.533576965332)
				SetBlipRoute(Blipic, true)
				SpawnMarker = true
				Ulica = true
				DoScreenFadeIn(100)
				while not IsScreenFadedIn() do
					Wait(1)
				end
				ESX.ShowNotification("Odite na lokaciju i srusite drva!")
			else
				ESX.ShowNotification("Trenutno nemamo slobodnih prikolica!")
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

function SpawnObjekte()
		for i=1, #Config.Objekti, 1 do
			local x,y,z = table.unpack(Config.Objekti[i])
			ESX.Game.SpawnLocalObject('prop_tree_fallen_pine_01', {
					x = x,
					y = y,
					z = z-1.6
			}, function(obj)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
			FreezeEntityPosition(Objekti[i], true)
			end)
			Blipara[i] = AddBlipForCoord(x, y, z)
			SetBlipSprite (Blipara[i], 237)
			SetBlipDisplay(Blipara[i], 8)
			SetBlipColour (Blipara[i], 2)
			SetBlipScale  (Blipara[i], 1.4)
		end
		Broj = #Config.Objekti
		Spawno = true
		ESX.ShowNotification("Izrezite drva!")
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

function IsJobDrvosjeca()
	if ESX.PlayerData.posao ~= nil then
		local kosac = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'drvosjeca' then
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
			TriggerServerEvent('esx_joblisting:setJob', 3)
			ESX.ShowNotification("Zaposlio si se kao drvosjeca!")
		end
    end
)

AddEventHandler('esx_drvosjeca:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_drvosjeca", "Upit za posao", "Dali se zelite zaposliti kao drvosjeca?")
	end
	
	if zone == 'ulica' then
		local vehara = GetVehiclePedIsIn(PlayerPedId(), false)
		local retval, trailer = GetVehicleTrailerVehicle(vehara)
		if IsVehicleModel(vehara, Config.Trucks[1]) and IsVehicleModel(trailer, "TRFlat") then
			DoScreenFadeOut(100)
			while not IsScreenFadedOut() do
				Wait(1)
			end
			SpawnObjekte()
			ESX.Game.DeleteVehicle(Vozilo)
			ESX.Game.DeleteVehicle(Prikolica)
			Vozilo = nil
			Prikolica = nil
			RemoveBlip(Blipic)
			Blipic = nil
			SpawnMarker = false
			Wait(500)
			DoScreenFadeIn(100)
		else
			ESX.ShowNotification("Niste u vozilu koje ste dobili od firme ili nemate prikolicu!")
		end
	end
	
	if zone == 'vracanje' then
		if ESX.Game.IsSpawnPointClear({
				x = 1803.3953857422,
				y = 4841.2504882813,
				z = 41.600612640381
			}, 5.0) then
			ESX.ShowNotification("Utovar drva na prikolicu")
			DoScreenFadeOut(100)
			while not IsScreenFadedOut() do
				Wait(1)
			end
			ESX.Game.SpawnVehicle("phantom", {
					x = 1803.3953857422,
					y = 4841.2504882813,
					z = 41.600612640381
				}, 187.11, function(callback_vehicle)
				Vozilo = callback_vehicle
				TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			end)
			while Vozilo == nil do
				Wait(1)
			end
			--Wait(200)
			ESX.Game.SpawnVehicle("trailerlogs", {
					x = 1803.3953857422,
					y = 4841.2504882813,
					z = 41.600612640381
				}, 187.11, function(callback_vehicle)
				local retval = GetVehiclePedIsIn(PlayerPedId(), false)
				AttachVehicleToTrailer(retval, callback_vehicle, 5)
				Prikolica = callback_vehicle
			end)
			while Prikolica == nil do
				Wait(1)
			end
			for k,v in pairs(Config.Zones) do
				if k == "VehicleDeletePoint" then
					Blipic = AddBlipForCoord(v.Pos)
				end
			end
			SetBlipRoute(Blipic, true)
			DoScreenFadeIn(100)
			while not IsScreenFadedIn() do
				Wait(1)
			end
			SpawnMarker2 = false
			ESX.ShowNotification("Odite na lokaciju i ostavite drva!")
		else
			ESX.ShowNotification("Trenutno nemamo slobodnih prikolica!")
		end
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobDrvosjeca() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobDrvosjeca() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

function ZavrsiPosao()
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
	end
	if Prikolica ~= nil then
		ESX.Game.DeleteVehicle(Prikolica)
	end
	if Blipic ~= nil then
		RemoveBlip(Blipic)
	end
	for i=1, #Config.Objekti, 1 do
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
	Blipic = nil
	Spawno = false
	Radis = false
	Ulica = false
	SpawnMarker = false
end

AddEventHandler('esx_drvosjeca:hasExitedMarker', function(zone)
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
	local waitara = 500
    while true do
        Citizen.Wait(waitara)
		local naso = 0
		if IsJobDrvosjeca() then
			if Spawno == true and Broj > 0 then
				naso = 1
				waitara = 0
					if Ulica == true then
						for i=1, #Config.Objekti, 1 do
							local kordic = GetEntityCoords(PlayerPedId())
							if #(kordic-Config.Objekti[i]) <= 3.0 then
							--if GetDistanceBetweenCoords(Config.Objekti[i].x,  Config.Objekti[i].y,  Config.Objekti[i].z,  kordic.x,  kordic.y,  kordic.z,  true) <= 3.0 then
								local x,y,z = table.unpack(Config.Objekti[i])
								DrawMarker(27, x, y, z-1.6, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
							end
						end
						if IsControlJustPressed(0, 24) then
							local retval = GetSelectedPedWeapon(PlayerPedId())
							if retval == GetHashKey("WEAPON_HATCHET") then
								local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_tree_fallen_pine_01")
								for i=1, #Config.Objekti, 1 do
									if Objekti[i] == NewBin then
										if NewBinDistance <= 3 then
											if Udario[i] == nil then
												Udario[i] = 0
											end
											Udario[i] = Udario[i]+1
											Wait(1000)
											if Udario[i] == 5 then
												local cord = GetEntityCoords(Objekti[i])
												ESX.Game.DeleteObject(Objekti[i])
												local x,y,z = table.unpack(cord)
												ESX.Game.SpawnLocalObject('prop_tree_fallen_01', {
														x = x,
														y = y,
														z = z-0.6
												}, function(obj)
													Objekti[i] = obj
													FreezeEntityPosition(Objekti[i], true)
												end)
												Udario[i] = 0
												TriggerServerEvent("drvosjeca:platituljanu")
												TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
											end
										end
									end
								end
								local NewBin2, NewBinDistance2 = ESX.Game.GetClosestObject("prop_tree_fallen_01")
								for i=1, #Config.Objekti, 1 do
									if Objekti[i] == NewBin2 then
										if NewBinDistance2 <= 3 then
											if IsControlJustPressed(0, 24) then
												local retval = GetSelectedPedWeapon(PlayerPedId())
												if retval == GetHashKey("WEAPON_HATCHET") then
													if Udario[i] == nil then
														Udario[i] = 0
													end
													Udario[i] = Udario[i]+1
													Wait(1000)
													if Udario[i] == 5 then
														local cord = GetEntityCoords(Objekti[i])
														DeleteObject(Objekti[i])
														local x,y,z = table.unpack(cord)
														ESX.Game.SpawnLocalObject('prop_tree_log_01', {
																x = x,
																y = y,
																z = z+1
														}, function(obj)
															Objekti[i] = obj
															PlaceObjectOnGroundProperly(obj)
															FreezeEntityPosition(Objekti[i], true)
														end)
														Udario[i] = 0
														TriggerServerEvent("drvosjeca:platituljanu")
														SpawnMarker2 = true
														if DoesBlipExist(Blipara[i]) then
															RemoveBlip(Blipara[i])
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
			end
			if CurrentAction ~= nil then
				naso = 1
				waitara = 0
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) and IsJobDrvosjeca() then

					if CurrentAction == 'Obrisi' then
						ZavrsiPosao()
					end
					CurrentAction = nil
				end
			end
		end
		if naso == 0 then
			waitara = 500
		end
    end
end)

local nekak = vector3(1856.0534667969, 4991.2924804688, 52.533576965332)
local kord2 = vector3(1819.4777832031, 4879.6391601563, 41.798355102539)
-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local isInMarker  = false
		local currentZone = nil
		if IsJobDrvosjeca() then
			local coords      = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.Zones) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if Radis == true and Ulica == true and (#(coords-nekak) < 3.0) then
				local cordara = GetEntityCoords(Prikolica)
				if #(cordara-nekak) < 6.0 then
				--if GetDistanceBetweenCoords(cordara, 1856.0534667969, 4991.2924804688, 52.533576965332, true) < 6.0 then
					isInMarker  = true
					currentZone = "ulica"
				end
			end
			
			if Radis == true and Ulica == true and SpawnMarker2 and (#(coords-kord2) < 3.0) then
				isInMarker  = true
				currentZone = "vracanje"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_drvosjeca:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_drvosjeca:hasExitedMarker', lastZone)
			end

			
			if SpawnMarker and #(coords-nekak) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 1856.0534667969, 4991.2924804688, 52.533576965332, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			if SpawnMarker2 and #(coords-kord2) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 1819.4777832031, 4879.6391601563, 40.798355102539, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			for k,v in pairs(Config.Zones) do

				if isInService and (v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end

			for k,v in pairs(Config.Cloakroom) do

				if(v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
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
				TriggerEvent('esx_drvosjeca:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_drvosjeca:hasExitedMarker', lastZone)
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