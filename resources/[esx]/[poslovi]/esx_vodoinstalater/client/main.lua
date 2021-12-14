ESX = nil
local Radis = false
local Vozilo = nil
local TrajeIntervencija = false
local Blipara = nil
local NoviObj = nil
local NoviObj2 = nil
local NoviObj3 = nil
local NoviObj4 = nil
local NoviObj5 = nil
local Lokacija = nil
local SpawnMarker = false

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
	AddTextComponentString("Vodoinstalater")
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
				MakniKvar()
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
				menu.close()
				if TrajeIntervencija == false then
					Wait(20000)
					SpawnajKvar()
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
		if data.current.value == "utillitruck3" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 178.63403320313, true, false)
			SetModelAsNoLongerNeeded(GetHashKey(data.current.value))
			platenum = math.random(10000, 99999)
			SetVehicleNumberPlateText(Vozilo, "SIK"..platenum)             
			plaquevehicule = "SIK"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			ESX.ShowNotification("Pricekajte dojavu o kvaru!")
			Radis = true
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

function IsJobVodoinstalater()
	if ESX.PlayerData.posao ~= nil then
		local vatr = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'vodoinstalater' then
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
			TriggerServerEvent('esx_joblisting:setJob', 13)
			ESX.ShowNotification("Zaposlio si se kao vodoinstalater!")
		end
    end
)

AddEventHandler('esx_vodoinstalater:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_vodoinstalater", "Upit za posao", "Dali se zelite zaposliti kao vodoinstalater?")
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobVodoinstalater() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'kvar' then
		if isInService and IsJobVodoinstalater() and Radis == true and not IsPedInAnyVehicle(PlayerPedId(), false) then
			SpawnMarker = false
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 0, false)
			Wait(20000)
			TrajeIntervencija = false
			local retval = false
			local x,y,z = table.unpack(Lokacija)
			retval = IsExplosionActiveInArea(13, x, y, z, x, y, z)
			while retval do
				Wait(500)
				retval = IsExplosionActiveInArea(13, x, y, z, x, y, z)
			end
			ClearPedTasks(PlayerPedId())
			ESX.ShowNotification("Uspjesno popravljen kvar!")
			TriggerServerEvent("vodaa:platituljanu")
			TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
			RemoveBlip(Blipara)
			--TriggerServerEvent("vodoinstalater:MaknutKvar", GetPlayerServerId(PlayerId()))
			ESX.Game.DeleteObject(NoviObj)
			ESX.Game.DeleteObject(NoviObj2)
			ESX.Game.DeleteObject(NoviObj3)
			ESX.Game.DeleteObject(NoviObj4)
			ESX.Game.DeleteObject(NoviObj5)
			NoviObj = nil
			NoviObj2 = nil
			NoviObj3 = nil
			NoviObj4 = nil
			NoviObj5 = nil
			Blipara = nil
			Wait(20000)
			SpawnajKvar()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobVodoinstalater() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

AddEventHandler('esx_vodoinstalater:hasExitedMarker', function(zone)
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
		if IsJobVodoinstalater() then
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then

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
		if IsJobVodoinstalater() then

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
			
			if Radis == true and SpawnMarker == true and (#(coords-Lokacija) < 2.0) then
				isInMarker  = true
				currentZone = "kvar"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_vodoinstalater:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vodoinstalater:hasExitedMarker', lastZone)
			end

		
			if SpawnMarker and #(coords-Lokacija) < Config.DrawDistance then
				waitara = 0
				naso = 1
				local x,y,z = table.unpack(Lokacija)
				DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
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
				TriggerEvent('esx_vodoinstalater:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vodoinstalater:hasExitedMarker', lastZone)
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function MakniKvar()
	TrajeIntervencija = false
	Radis = false
	RemoveBlip(Blipara)
	ESX.Game.DeleteObject(NoviObj)
	ESX.Game.DeleteObject(NoviObj2)
	ESX.Game.DeleteObject(NoviObj3)
	ESX.Game.DeleteObject(NoviObj4)
	ESX.Game.DeleteObject(NoviObj5)
	NoviObj = nil
	NoviObj2 = nil
	NoviObj3 = nil
	NoviObj4 = nil
	NoviObj5 = nil
	Blipara = nil
	SpawnMarker = false
	Lokacija = nil
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
	--TriggerServerEvent("vodoinstalater:MaknutKvar", GetPlayerServerId(PlayerId()))
end

function SpawnajKvar()
	if isInService then
		local novacor = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 350.0, 0.0)
		local xa,ya,za = table.unpack(novacor)
		local retval, outPosition = GetClosestVehicleNode(xa, ya, za, 0, 3.0, 0)
		local JelKoBlizu = false
		local KodGlavne = false
		local kvarpos = vector3(228.61502075195, -793.43957519531, 30.63419342041)
		if #(kvarpos-outPosition) <= 80.0 then
		--if GetDistanceBetweenCoords(228.61502075195, -793.43957519531, 30.63419342041, outPosition, false) <= 80.0 then
			KodGlavne = true
		end
		if KodGlavne == false then
			for _,player in ipairs(GetActivePlayers()) do
				Wait(1)
				local kore = GetEntityCoords(GetPlayerPed(player))
				if #(kore-outPosition) <= 50.0 then
				--if GetDistanceBetweenCoords(kore, outPosition, false) <= 50.0 then
					JelKoBlizu = true
				end
			end
		end
		if JelKoBlizu == false and KodGlavne == false then
			ESX.ShowNotification("Imamo dojavu o puknucu cijevi, oznacena vam je lokacija na GPS-u!")
			Lokacija = outPosition
			SpawnMarker = true
			Blipara = AddBlipForCoord(outPosition)
			SetBlipSprite (Blipara, 402)
			SetBlipDisplay(Blipara, 8)
			SetBlipColour (Blipara, 49)
			SetBlipScale  (Blipara, 1.4)
			
			local x,y,z = table.unpack(outPosition)
			AddExplosion(x, y, z, 13, 1.0, true, false, 0.0, true)
			local model = GetHashKey('prop_cs_dildo_01')
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end
			local model2 = GetHashKey('prop_barrier_work06b')
			RequestModel(model2)
			while not HasModelLoaded(model2) do
				Wait(1)
			end
			NoviObj = CreateObject(model, x, y, z-1.0, false, false, false)
			FreezeEntityPosition(NoviObj, true)
			local prvioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 0.0, 2.0, 1.0)
			local drugioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 0.0, -2.0, 1.0)
			local trecioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 2.0, 0.0, 1.0)
			local cetvrtioffset = GetOffsetFromEntityInWorldCoords(NoviObj, -2.0, 0.0, 1.0)
			local heading = GetEntityHeading(NoviObj)
			NoviObj2 = CreateObject(model2, prvioffset.x, prvioffset.y, prvioffset.z, false, false, false)
			FreezeEntityPosition(NoviObj2, true)
			SetEntityHeading(NoviObj2, heading+180)

			NoviObj3 = CreateObject(model2, drugioffset.x, drugioffset.y, drugioffset.z, false, false, false)
			FreezeEntityPosition(NoviObj3, true)

			NoviObj4 = CreateObject(model2, trecioffset.x, trecioffset.y, trecioffset.z, false, false, false)
			FreezeEntityPosition(NoviObj4, true)
			SetEntityHeading(NoviObj4, heading+90)

			NoviObj5 = CreateObject(model2, cetvrtioffset.x, cetvrtioffset.y, cetvrtioffset.z, false, false, false)
			FreezeEntityPosition(NoviObj5, true)
			SetEntityHeading(NoviObj5, heading-90)
			Wait(200)
			SetModelAsNoLongerNeeded(model)
			SetModelAsNoLongerNeeded(model2)
			TrajeIntervencija = true
			
			Citizen.CreateThread(function()
				while TrajeIntervencija do
					Citizen.Wait(10000)
					AddExplosion(x, y, z, 13, 1.0, true, false, 0.0, true)
				end
			end)
		else
			Wait(5000)
			SpawnajKvar()
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
	if TrajeIntervencija then
		MakniKvar()
	end
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
	Radis = false
end)