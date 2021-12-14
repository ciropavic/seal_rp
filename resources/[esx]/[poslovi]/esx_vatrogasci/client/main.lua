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
local TrajePozar = false
local ZadnjeVozilo = nil
local Blipara = nil
local LokacijaVatre = nil

local vozila = {
{ime = "buffalo"},
{ime = "infernus"},
{ime = "elegy"},
{ime = "tempesta"},
{ime = "italigtb"},
{ime = "nero"},
{ime = "specter"},
{ime = "penetrator"},
{ime = "gp1"},
{ime = "retinue"},
{ime = "cyclone"},
{ime = "rapidgt3"},
{ime = "yosemite"},
{ime = "comet2"},
{ime = "hermes"},
{ime = "sc1"},
{ime = "gt500"},
{ime = "sentinel3"},
{ime = "hustler"},
{ime = "dominator3"},
}

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
	AddTextComponentString("Vatrogasac")
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
				ZaustaviPozar()
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
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FIREEXTINGUISHER"), 200, false, true)
				menu.close()
				if TrajePozar == false then
					StartajVatru()
				end
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
		if data.current.value == "firetruk" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 319.94915771484, true, false)
			SetModelAsNoLongerNeeded(GetHashKey(data.current.value))
			platenum = math.random(10000, 99999)
			SetVehicleNumberPlateText(Vozilo, "WAL"..platenum)             
			plaquevehicule = "WAL"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			Radis = true
			ESX.ShowNotification("Pricekajte dojavu o pozaru!")
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

function IsJobVatrogasac()
	if ESX.PlayerData.posao ~= nil then
		local vatr = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'vatrogasac' then
			vatr = true
		end
		return vatr
	end
end

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		if br == 1 then
			TriggerServerEvent('esx_joblisting:setJob', 11)
			ESX.ShowNotification("Zaposlio si se kao vatrogasac!")
		end
    end
)

AddEventHandler('esx_vatrogasac:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_vatrogasci", "Upit za posao", "Dali se zelite zaposliti kao vatrogasac?")
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobVatrogasac() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobVatrogasac() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

AddEventHandler('esx_vatrogasac:hasExitedMarker', function(zone)
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
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustPressed(0, 38) and IsJobVatrogasac() then

                if CurrentAction == 'Obrisi' then
					if Vozilo ~= nil then
						ESX.Game.DeleteVehicle(Vozilo)
						Vozilo = nil
					end
					Radis = false
                end
                CurrentAction = nil
            end
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
		
		if IsJobVatrogasac() then
			if IsATruck() then
				naso = 1
				waitara = 0
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					if IsControlJustReleased(0, 86) then
						if UpaljenaSirena then
							local nid = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false))
							TriggerServerEvent("policija:UpaliSirenu", nid, true, false)
							UpaljenaSirena = false
						end
					end
					if IsControlJustReleased(0, 137) then
						if not UpaljenaSirena then
							local nid = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false))
							TriggerServerEvent("policija:UpaliSirenu", nid, true, true)
							UpaljenaSirena = true
						else
							local nid = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false))
							TriggerServerEvent("policija:UpaliSirenu", nid, false, false)
							UpaljenaSirena = false
						end
					end
				end
			end

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
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_vatrogasac:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vatrogasac:hasExitedMarker', lastZone)
			end
		else
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
				TriggerEvent('esx_vatrogasac:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vatrogasac:hasExitedMarker', lastZone)
			end
		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobVatrogasac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobVatrogasac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function ZaustaviPozar()
	TrajePozar = false
	Radis = false
	StopFireInRange(LokacijaVatre, 5.0)
	RemoveBlip(Blipara)
	if ZadnjeVozilo ~= nil then
		local retval, script = GetEntityScript(ZadnjeVozilo)
		if retval == "esx_vatrogasci" then
			ESX.Game.DeleteVehicle(ZadnjeVozilo)
			ZadnjeVozilo = nil
		end
	end
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
end

function StartajVatru()
	if isInService then
		local core
		local novacor = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 350.0, 0.0)
		local x,y,z = table.unpack(novacor)
		local retval, outPosition, outHeading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3.0, 0)
		ESX.ShowNotification("Imamo dojavu o pozaru, oznacena vam je lokacija na GPS-u!")
		Blipara = AddBlipForCoord(outPosition)
		SetBlipSprite (Blipara, 436)
		SetBlipDisplay(Blipara, 8)
		SetBlipColour (Blipara, 49)
		SetBlipScale  (Blipara, 1.4)
		local veh = vozila[math.random(1, #vozila)]
		local hashVehicule = veh.ime
		ESX.Streaming.RequestModel(hashVehicule)
		ZadnjeVozilo = CreateVehicle(hashVehicule, outPosition, outHeading, false, false)
		SetModelAsNoLongerNeeded(GetHashKey(hashVehicule))
		SetEntityAsMissionEntity(ZadnjeVozilo, true, true)
		local bonic = GetEntityBoneIndexByName(ZadnjeVozilo, "engine")
		core = GetWorldPositionOfEntityBone(ZadnjeVozilo, bonic)
		LokacijaVatre = core
		StartScriptFire(core, 25, true)
		TrajePozar = true
		SetDisableVehicleEngineFires(ZadnjeVozilo, true)
		SetVehicleEngineCanDegrade(ZadnjeVozilo, false)
		SetVehicleFuelLevel(ZadnjeVozilo, 0)
		SetVehicleCanEngineOperateOnFire(ZadnjeVozilo, false)
		SetVehicleEngineHealth(ZadnjeVozilo, -1)
		FreezeEntityPosition(ZadnjeVozilo, true)
		NetworkRequestControlOfEntity(ZadnjeVozilo)
		SetVehicleHasBeenOwnedByPlayer(ZadnjeVozilo, true)
		SetVehicleEngineTemperature(ZadnjeVozilo, 300)
		while TrajePozar do
			Citizen.Wait(0)
			local br = GetNumberOfFiresInRange(core, 4.0)
			Wait(200)
			if br == 0 then
				TrajePozar = false
				if ESX.PlayerData.posao.name == "vatrogasac" then
					RemoveBlip(Blipara)
				end
				FreezeEntityPosition(ZadnjeVozilo, false)
				local cor = GetEntityCoords(PlayerPedId())
				if GetDistanceBetweenCoords(core, cor, false) < 20 and ESX.PlayerData.posao.name == "vatrogasac" and isInService then
					TriggerServerEvent("vatraaa:platituljanu")
					TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
					ESX.ShowNotification("Uspjesno ugasen pozar!")
				end
				local retvala, script = GetEntityScript(ZadnjeVozilo)
				if retvala == "esx_vatrogasci" then
					Wait(8000)
					ESX.Game.DeleteVehicle(ZadnjeVozilo)
				end
				Wait(20000)
				StartajVatru()
			end
		end
	end
end
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
	if TrajePozar then
		ZaustaviPozar()
	end
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
	Radis = false
end)