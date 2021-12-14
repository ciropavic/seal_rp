ESX = nil
local Vlak = nil
local PlayerData              = nil
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Radis = false
local Odradio = 1
local Blipara = {}

local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

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
	AddTextComponentString("Vlakovodja")
	EndTextCommandSetBlipName(blip)
end

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
			end
			if data.current.value == 'job_wear' then
				isInService = true
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
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

	table.insert(elements, {label = "Vlak", value = "vlak"})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
			if data.current.value == "vlak" then
				createTrain(Config.TrainLocations[2].trainID, Config.TrainLocations[2].trainX, Config.TrainLocations[2].trainY, Config.TrainLocations[2].trainZ)
				PokreniPosao()
				Radis = true
			end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function PokreniPosao()
	Blipara[Odradio] = AddBlipForCoord(Config.Stanice[Odradio])
	SetBlipSprite (Blipara[Odradio], 1)
	SetBlipDisplay(Blipara[Odradio], 8)
	SetBlipColour (Blipara[Odradio], 2)
	SetBlipScale  (Blipara[Odradio], 1.0)
	SetBlipAsShortRange(Blipara[Odradio], true)
	ESX.ShowNotification("Vozite do prve stanice!")
end

function IsJobVlak()
	if PlayerData ~= nil then
		local kosac = false
		if PlayerData.posao.name ~= nil and PlayerData.posao.name == 'vlak' then
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
			TriggerServerEvent('esx_joblisting:setJob', 12)
			ESX.ShowNotification("Zaposlio si se kao vlakovodja!")
		end
    end
)

AddEventHandler('esx_vlak:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_vlak", "Upit za posao", "Dali se zelite zaposliti kao vlakovodja?")
	end
	
	if zone == 'stanica' then
		CurrentAction     = 'stanica'
        CurrentActionMsg  = "Pritisnite E da zapocnete istovar tereta!"
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobVlak() and Radis == false  then
			MenuVehicleSpawner()
		end
	end
end)

AddEventHandler('esx_vlak:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		if CurrentAction ~= nil then
			waitara = 0
			naso = 1
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and IsJobVlak() then
                if CurrentAction == 'stanica' then
					Config.Speed = 0
					SetTrainSpeed(Config.TrainVeh, 0)
					ESX.ShowNotification("Pricekajte istovar tereta!")
					RemoveBlip(Blipara[Odradio])
					Odradio = Odradio+1
					local timer = GetGameTimer()
					while GetGameTimer() - timer < 10000 do
						Wait(0)
						DisableAllControlActions(0)
					end
					TriggerServerEvent("esx_vlak:platiTuljanu")
					TriggerServerEvent("biznis:DodajTuru", PlayerData.posao.name)
					if Config.Stanice[Odradio] ~= nil then
						Blipara[Odradio] = AddBlipForCoord(Config.Stanice[Odradio])
						SetBlipSprite (Blipara[Odradio], 1)
						SetBlipDisplay(Blipara[Odradio], 8)
						SetBlipColour (Blipara[Odradio], 2)
						SetBlipScale  (Blipara[Odradio], 1.0)
						SetBlipAsShortRange(Blipara[Odradio], true)
						ESX.ShowNotification("Mozete nastaviti!")
					else
						Odradio = 1
						Radis = false
						DeleteMissionTrain(Vlak)
						Config.inTrain = false -- F while train doesn't have driver
						Config.inTrainAsPas = false -- F while train has driver
						Config.TrainVeh = 0
						Config.Speed = 0
						ESX.ShowNotification("Zavrsili ste sa poslom!")
						SetEntityCoords(PlayerPedId(), 684.48742675781, -716.92510986328, 25.025840759277)
					end
                end
                CurrentAction = nil
            end
		end

		local coords = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
		if IsJobVlak() then
			for k,v in pairs(Config.Zones) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					waitara = 0
					naso = 1
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					waitara = 0
					naso = 1
					isInMarker  = true
					currentZone = k
				end
			end
			
			if #(coords-Config.Stanice[Odradio]) < 3.0 and Radis then
			--if(GetDistanceBetweenCoords(coords, Config.Stanice[Odradio].x,  Config.Stanice[Odradio].y,  Config.Stanice[Odradio].z, true) < 3.0) then
				waitara = 0
				naso = 1
				isInMarker  = true
				currentZone = "stanica"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_vlak:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vlak:hasExitedMarker', lastZone)
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
				TriggerEvent('esx_vlak:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vlak:hasExitedMarker', lastZone)
			end
		end
		
		if isInService and Radis and IsJobVlak() and Config.Stanice[Odradio] ~= nil and #(coords-Config.Stanice[Odradio]) < Config.DrawDistance then
			waitara = 0
			naso = 1
			DrawMarker(1, Config.Stanice[Odradio], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobVlak() and v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobVlak() and v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
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
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setPosao')
AddEventHandler('esx:setPosao', function(job)
	PlayerData.posao = job
	Radis = false
end)

if (Config.Debug) then
	Citizen.CreateThread(function()
		Log("Train Markers Init.")
		while true do		
			Wait(0)
			if Config.ModelsLoaded then	
				for i=1, #Config.TrainLocations, 1 do
					local coords = GetEntityCoords(GetPlayerPed(-1))
					local trainLocation = Config.TrainLocations[i]
					if #(coords-trainLocation.koord) < Config.DrawDistance then
					--if(GetDistanceBetweenCoords(coords, trainLocation.x, trainLocation.y, trainLocation.z, true) < Config.DrawDistance) then
						DrawMarker(Config.MarkerType, trainLocation.koord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z-2.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
					if #(coords-trainLocation.koord) < Config.MarkerSize.x / 2 then
					--if(GetDistanceBetweenCoords(coords, trainLocation.x, trainLocation.y, trainLocation.z, true) < Config.MarkerSize.x / 2) then
						if(IsControlPressed(0,58) and(GetGameTimer() - Config.EnterExitDelay) > Config.EnterExitDelayMax) then -- G
							Config.EnterExitDelay = 0
							Wait(60)
							createTrain(trainLocation.trainID, trainLocation.trainX, trainLocation.trainY, trainLocation.trainZ)
						end
					end
				end
			end
		end
	end)
end

function doTrains()
	if Config.ModelsLoaded then
		if (Config.EnterExitDelay == 0) then
			Config.EnterExitDelay = GetGameTimer()
		end
		if (Config.inTrain) then
			-- Speed Up/Forwards (W)
			if (IsControlPressed(0,71) and IsControlPressed(0,72) and Config.Debug and Config.Speed ~= 0) then -- D(E)bug Break (W+S)
				debugLog("break:" .. GetEntityCoords(Config.TrainVeh))
				Config.Speed = 0
				SetTrainSpeed(Config.TrainVeh, 0)
			elseif (IsControlPressed(0,73)) then -- E Break (X)
				Config.Speed = 0
			elseif (IsControlPressed(0,71) and Config.Speed < getTrainSpeeds(Config.TrainVeh).MaxSpeed) then  -- Forward (W)
				debugLog("W: " .. Config.Speed)
				Config.Speed = Config.Speed + getTrainSpeeds(Config.TrainVeh).Accel
			elseif (IsControlPressed(0,72) and Config.Speed  > -getTrainSpeeds(Config.TrainVeh).MaxSpeed)then -- Backwards (S)
				debugLog("S: " .. Config.Speed)
				Config.Speed = Config.Speed - getTrainSpeeds(Config.TrainVeh).Dccel
			end
			
			SetTrainCruiseSpeed(Config.TrainVeh,Config.Speed)
		elseif IsPedInAnyTrain(GetPlayerPed(-1)) then -- Should fix not being able to drive trains after restart resource.
			debugLog("I'm in a train? Did the resource restart...")
			if GetVehiclePedIsIn(GetPlayerPed(-1), false) == 0 then
				debugLog("Unable to get train, re-enter the train, or wait!")
			else
				debugLog("T:" .. GetVehiclePedIsIn(GetPlayerPed(-1), false) .. "|M:" .. GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
				Config.TrainVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				Config.inTrain = true
			end
		end
	end
end

function createTrain(type,x,y,z)
	Vlak = CreateMissionTrain(type,x,y,z,true)
	SetTrainSpeed(Vlak,0)
	SetTrainCruiseSpeed(Vlak,0)
	SetEntityAsMissionEntity(Vlak, true, false)
	debugLog("createTrain.")
	Config.TrainVeh = Vlak
	SetPedIntoVehicle(GetPlayerPed(-1),Config.TrainVeh,-1)
	Config.inTrain = true
	SetVehicleDoorsLocked(Vlak, 4)
end

-- Load Models
Citizen.CreateThread(function()
	function RequestModelSync(mod) -- eh
		tempmodel = GetHashKey(mod)
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
	end

	function LoadTrainModels()
		DeleteAllTrains()
		Config.ModelsLoaded = false
		Log("Loading Train Models.")
		RequestModelSync("freight")
		RequestModelSync("freightcar")
		RequestModelSync("freightgrain")
		RequestModelSync("freightcont1")
		RequestModelSync("freightcont2")
		RequestModelSync("freighttrailer")
		RequestModelSync("tankercar")
		RequestModelSync("metrotrain")
		RequestModelSync("s_m_m_lsmetro_01")
		Log("Done Loading Train Models.")
		Config.ModelsLoaded = true
	end
	LoadTrainModels()
	
	if (Config.Debug) then
		Log("Loading Train Blips.")
		for i=1, #Config.TrainLocations, 1 do
			local blip = AddBlipForCoord(Config.TrainLocations[i])      
			SetBlipSprite (blip, Config.BlipSprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, 2)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Trains")
			EndTextCommandSetBlipName(blip)
		end
		Log("Done Loading Train Blips.")
	end
	
	while true do
		Wait(0)
		doTrains()
	end
end)