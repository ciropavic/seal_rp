ESX = nil
local blip = nil
local PoslKoord = nil
local PoslNarID = nil
local PoslFirma = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().posao == nil do
	Citizen.Wait(100)
  end
  ProvjeriPosao()
  DodajBlip()
end)

function DodajBlip()
	local blip = AddBlipForCoord(Config.ZaposliSe.Pos.x, Config.ZaposliSe.Pos.y, Config.ZaposliSe.Pos.z)
	SetBlipSprite  (blip, Config.ZaposliSe.Sprite)
	SetBlipDisplay (blip, 4)
	SetBlipScale   (blip, 1.2)
	SetBlipCategory(blip, 3)
	SetBlipColour  (blip, Config.ZaposliSe.BColor)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Dostavljac")
	EndTextCommandSetBlipName(blip)
end
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
--------------------------------------------------------------------------------
local namezone = "Delivery"
local namezonenum = 0
local namezoneregion = 0
local MissionRegion = 0
local viemaxvehicule = 1000
local argentretire = 0
local livraisonnombre = 0
local MissionRetourCamion = false
local MissionNum = 0
local MissionLivraison = false
local isInService = false
local GUI                     = {}
GUI.Time                      = 0
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local plaquevehiculeactuel = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local LokCPa
local LokDos
local PritisoTipku = 0
local vozilo
local IstovarioTo = 0
local prop_ent
local MiciCP = 0
local PrviDio = 0
local lastpickup = nil
--------------------------------------------------------------------------------
function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	if IsJobTrucker() and blip == nil then
		blip = AddBlipForCoord(Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z)
	  
		SetBlipSprite (blip, 85)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.4)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('blip_job'))
		EndTextCommandSetBlipName(blip)
	end
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

	table.insert(elements, {label = "Narudzbe", value=Config.Trucks[1]})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "benson" and data.current.label ~= "Narudzbe" then
			--[[ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint2.Pos, 270.0, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
                MissionLivraisonSelect()
				plaquevehicule = "WAL"..platenum		
				vozilo = vehicle
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
			end)]]
			ESX.ShowNotification("Pritisnite na tražene artikle na traci!")
			SendNUIMessage({
				prikazi = true
			})
			SetNuiFocus(true, true)
		else
			ESX.TriggerServerCallback('esx_firme:DajNarudzbe', function(nar)
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'adfdfaa',
					{
						title    = "Popis narudzbi",
						align    = 'bottom-right',
						elements = nar,
					},
					function(datalr2, menulr2)
						TriggerServerEvent("esx_firme:ZapocniNarudzbu2", datalr2.current.value, 69, datalr2.current.kolicina, datalr2.current.firma)
						menulr2.close()
					end,
					function(datalr2, menulr2)
						menulr2.close()
					end
				)
			end, 69)
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNetEvent('esx_dostavljac:DostaviRobu')
AddEventHandler('esx_dostavljac:DostaviRobu', function(id, br, firma, dost, koord)
	local found2, coords2, heading2 = GetClosestVehicleNodeWithHeading(koord.x, koord.y, koord.z, 4, 10.0, 0)
	if found2 then
		PoslKoord = coords2
		PoslNarID = id
		PoslFirma = firma
		ESX.ShowNotification("Pritisnite na tražene artikle na traci!")
		SendNUIMessage({
			prikazi = true
		})
		SetNuiFocus(true, true)
	end
end)

RegisterNUICallback('gotov', function()
	SetNuiFocus(false)
	vozilo = nil
	ESX.Game.SpawnVehicle("benson", Config.Zones.VehicleSpawnPoint2.Pos, Config.Zones.VehicleSpawnPoint2.Heading, function(vehicle)
		platenum = math.random(10000, 99999)
		SetVehicleNumberPlateText(vehicle, "WAL"..platenum)            
		FreezeEntityPosition(vehicle, true) 
		--MissionLivraisonSelect()
		plaquevehicule = "WAL"..platenum		
		vozilo = vehicle
		SetVehicleDoorOpen(vehicle,5,false, false)
		--TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
	end)
	while vozilo == nil do
		Wait(100)
	end
	SetEntityCoords(PlayerPedId(), 892.65356445312, -889.45477294922, 26.994806289673, true, false, false, false)
	local prop_ent = nil
	if prop_ent ~= nil then
		DeleteObject(prop_ent)
	end
	ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
		TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50)
	end)
	local modele = "prop_flattruck_01a"
	ESX.Streaming.RequestModel(modele)
	prop_ent = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), false, false, false)
	AttachEntityToEntityPhysically(prop_ent, PlayerPedId(), 0, GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis"), -0.03, 1.16, -1.1, -0.03, 0.05, 1.9, 0.0, -0.95, 178.8, 10000.0, true, true, true, false, 2)
	SetModelAsNoLongerNeeded(modele)

	local kut, kut2, kut3, kut4, kut5, kut6
	modele = "ng_proc_box_01a"
	ESX.Streaming.RequestModel(modele)
	--Doljnji red
	kut = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut, prop_ent, -1, 0, 0.4, 0.28, 0.0, 0, 90.0, false, false, false, false, 0, true)

	kut2 = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut2, prop_ent, -1, 0, 0.0, 0.28, 0.0, 0, 90.0, false, false, false, false, 0, true)

	kut3 = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut3, prop_ent, -1, 0, -0.4, 0.28, 0.0, 0, 90.0, false, false, false, false, 0, true)

	--Gornji red
	kut4 = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut4, prop_ent, -1, 0, 0.4, 0.62, 0.0, 0, 90.0, false, false, false, false, 0, true)

	kut5 = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut5, prop_ent, -1, 0, 0.0, 0.62, 0.0, 0, 90.0, false, false, false, false, 0, true)

	kut6 = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)--z
	AttachEntityToEntity(kut6, prop_ent, -1, 0, -0.4, 0.62, 0.0, 0, 90.0, false, false, false, false, 0, true)
	SetModelAsNoLongerNeeded(modele)
	local kordara = GetOffsetFromEntityInWorldCoords(vozilo, 0.0, -8.0, -1.0)
	local zavrsio = false
	while not zavrsio do
		Wait(0)
		DrawMarker(1, kordara, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		if #(GetEntityCoords(PlayerPedId())-kordara) <= 2.0 then
			zavrsio = true
			ESX.Game.DeleteObject(prop_ent)
			ESX.Game.DeleteObject(kut)
			ESX.Game.DeleteObject(kut2)
			ESX.Game.DeleteObject(kut3)
			ESX.Game.DeleteObject(kut4)
			ESX.Game.DeleteObject(kut5)
			ESX.Game.DeleteObject(kut6)
			ESX.ShowNotification("Utovarili ste robu!")
			ClearPedSecondaryTask(PlayerPedId())
		end
	end
	FreezeEntityPosition(vozilo, false) 
	SetVehicleDoorShut(vozilo, 5, true)
	if PoslKoord == nil then
		MissionLivraisonSelect()
	else
		local bogte = vector3(Config.Livraison.AnnulerMission.Pos.x, Config.Livraison.AnnulerMission.Pos.y, Config.Livraison.AnnulerMission.Pos.z)
		DostavaPoslovnici(PoslKoord, bogte)
	end
	TaskWarpPedIntoVehicle(GetPlayerPed(-1), vozilo, -1)
end)

function DostavaPoslovnici(coords2, coords)
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(coords2.x,  coords2.y, coords2.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	local Dostavlja = true
	local Vraca = false
	Citizen.CreateThread(function()
		while Dostavlja do
			Citizen.Wait(1)
			local coordse = GetEntityCoords(GetPlayerPed(-1))
			if Vraca == false then
				if #(coordse-coords2) < 100 then
					DrawMarker(1, coords2.x, coords2.y, coords2.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
				end
				if #(coordse-coords2) < 3 then
					ESX.ShowNotification("Dostavili ste robu, vratite kamion do firme")
					RemoveBlip(Blips['delivery'])
					Blips['delivery'] = nil
					Vraca = true
					TriggerServerEvent("esx_firme:ZavrsiDostavu2", PoslNarID, PoslFirma)
				end
			else
				if Blips['delivery'] == nil then
					Blips['delivery'] = AddBlipForCoord(coords.x,  coords.y, coords.z)
					SetBlipRoute(Blips['delivery'], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('blip_delivery'))
					EndTextCommandSetBlipName(Blips['delivery'])
				end
				if #(coordse-coords) < 100 then
					DrawMarker(1, coords.x, coords.y, coords.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
				end
				if #(coordse-coords) < 3 then
					ESX.ShowNotification("Vratili ste kamion u firmu.")
					RemoveBlip(Blips['delivery'])
					Blips['delivery'] = nil
					ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
					Dostavlja = false
				end
			end
		end
	end)
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

function IsJobTrucker()
	if ESX.PlayerData ~= nil then
		local isJobTrucker = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'deliverer' then
			isJobTrucker = true
		end
		return isJobTrucker
	end
end

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		if br == 1 then
			TriggerServerEvent('esx_joblisting:setJob', 2)
			ESX.ShowNotification("Zaposlio si se kao dostavljac!")
		end
    end
)

AddEventHandler('esx_delivererjob:hasEnteredMarker', function(zone)

	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_deliveryjob", "Upit za posao", "Dali se zelite zaposliti kao dostavljac?")
	end
	
	if zone == 'Pokupi' then
		if isInService and IsJobTrucker() and PrviDio == 0 then
			CurrentAction     = 'Pokupi'
            CurrentActionMsg  = "Pritisnite E da istovarite robu!"
		end
	end
	
	if zone == 'Istovari' then
		if isInService and IsJobTrucker() and LokDos ~= nil then
			CurrentAction     = 'Istovari'
            CurrentActionMsg  = "Pritisnite E da ostavite robu!"
		end
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobTrucker() then
			if MissionRetourCamion or MissionLivraison then
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('already_have_van')
			else
				MenuVehicleSpawner()
			end
		end
	end

	if zone == namezone then
		if isInService and MissionLivraison and MissionNum == namezonenum and MissionRegion == namezoneregion and IsJobTrucker() and MiciCP == 0 then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()
				
				if plaquevehicule == plaquevehiculeactuel then
					if Blips['delivery'] ~= nil then
						RemoveBlip(Blips['delivery'])
						Blips['delivery'] = nil
					end

					CurrentAction     = 'delivery'
                    CurrentActionMsg  = _U('delivery')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('not_your_van2')
			end
		end
	end

	if zone == 'AnnulerMission' then
		if isInService and MissionLivraison and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()
				
				if plaquevehicule == plaquevehiculeactuel then
                    CurrentAction     = 'retourcamionannulermission'
                    CurrentActionMsg  = _U('cancel_mission')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
                CurrentAction     = 'retourcamionperduannulermission'
			end
		end
	end

	if zone == 'RetourCamion' then
		if isInService and MissionRetourCamion and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()

				if plaquevehicule == plaquevehiculeactuel then
                    CurrentAction     = 'retourcamion'
				else
                    CurrentAction     = 'retourcamionannulermission'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
                CurrentAction     = 'retourcamionperdu'
			end
		end
	end

end)

AddEventHandler('esx_delivererjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function nouvelledestination()
	IstovarioTo = 0
	PritisoTipku = 0
	PrviDio = 1
	MiciCP = 0
	livraisonnombre = livraisonnombre+1
	TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
	TriggerServerEvent("esx_delivererposo:platiljantu", destination)
	ESX.ShowNotification("Placeno vam je $"..destination.Paye.." za obavljenu dostavu!")

	if livraisonnombre >= Config.MaxDelivery then
		MissionLivraisonStopRetourDepot()
	else

		livraisonsuite = math.random(0, 100)
		
		if livraisonsuite <= 10 then
			MissionLivraisonStopRetourDepot()
		elseif livraisonsuite <= 99 then
			MissionLivraisonSelect()
		elseif livraisonsuite <= 100 then
			if MissionRegion == 1 then
				MissionRegion = 1
			elseif MissionRegion == 2 then
				MissionRegion = 1
			end
			MissionLivraisonSelect()	
		end
	end
end

function retourcamion_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionRetourCamion = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapaye()
end

function retourcamion_non()
	
	if livraisonnombre >= Config.MaxDelivery then
		ESX.ShowNotification(_U('need_it'))
	else
		ESX.ShowNotification(_U('ok_work'))
		nouvelledestination()
	end
end

function retourcamionperdu_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	MissionRetourCamion = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapayesanscamion()
end

function retourcamionperdu_non()
	ESX.ShowNotification(_U('scared_me'))
end

function retourcamionannulermission_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionLivraison = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapaye()
end

function retourcamionannulermission_non()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function retourcamionperduannulermission_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionLivraison = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapayesanscamion()
end

function retourcamionperduannulermission_non()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function donnerlapaye()
	ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	vievehicule = GetVehicleEngineHealth(vehicle)
	calculargentretire = round(viemaxvehicule-vievehicule)
	
	if calculargentretire <= 0 then
		argentretire = 0
	else
		argentretire = calculargentretire
	end

    ESX.Game.DeleteVehicle(vehicle)
end

function donnerlapayesanscamion()
	ped = GetPlayerPed(-1)
	argentretire = Config.TruckPrice
end

function PostaviCPIzaKamiona()
	ESX.ShowNotification("Izadjite iz kamiona, te odite iza da istovarite robu!")
	local trunk = GetWorldPositionOfEntityBone(vozilo, GetEntityBoneIndexByName(vozilo, "boot"))
	LokCPa = trunk
	PrviDio = 0
	Citizen.CreateThread(function()
		while PritisoTipku == 0 do
			Wait(0)
			--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
			--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			DrawMarker(27, trunk.x , trunk.y, trunk.z-1.0, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
	end)
end

function PostaviIstovarCP()
	ESX.ShowNotification("Idite do zelenog markera da ostavite robu!")
	LokDos = vector3(destination.Dos.x , destination.Dos.y, destination.Dos.z)
	Citizen.CreateThread(function()
		while IstovarioTo == 0 do
			Wait(0)
			--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
			--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			DrawMarker(1, destination.Dos.x , destination.Dos.y, destination.Dos.z, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
	end)
end

-- Key Controls
Citizen.CreateThread(function()
	local waitara = 500
    while true do
        Citizen.Wait(waitara)
		local naso = 0
		local isInMarker  = false
		local currentZone = nil
		if IsJobTrucker() then
			local coords = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
					naso = 1
					waitara = 0
				end
			end
			
			if(GetDistanceBetweenCoords(coords, LokCPa, false) < 1) and PritisoTipku == 0 then
				isInMarker  = true
				currentZone = "Pokupi"
				naso = 1
				waitara = 0
			end
			
			if LokDos ~= nil and (GetDistanceBetweenCoords(coords, LokDos, true) < 2) and IstovarioTo == 0 then
				isInMarker  = true
				currentZone = "Istovari"
				naso = 1
				waitara = 0
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
					naso = 1
					waitara = 0
				end
			end
			
			for k,v in pairs(Config.Livraison) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) and MiciCP == 0 then
					isInMarker  = true
					currentZone = k
					naso = 1
					waitara = 0
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_delivererjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_delivererjob:hasExitedMarker', lastZone)
			end
		
			if MissionLivraison and MiciCP == 0 then
				DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
				DrawMarker(Config.Livraison.AnnulerMission.Type, Config.Livraison.AnnulerMission.Pos.x, Config.Livraison.AnnulerMission.Pos.y, Config.Livraison.AnnulerMission.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Livraison.AnnulerMission.Size.x, Config.Livraison.AnnulerMission.Size.y, Config.Livraison.AnnulerMission.Size.z, Config.Livraison.AnnulerMission.Color.r, Config.Livraison.AnnulerMission.Color.g, Config.Livraison.AnnulerMission.Color.b, 100, false, true, 2, false, false, false, false)
				naso = 1
				waitara = 0
			elseif MissionRetourCamion and MiciCP == 0 then
				DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
				naso = 1
				waitara = 0
			end
			
			for k,v in pairs(Config.Zones) do
				if isInService and (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					naso = 1
					waitara = 0
				end
			end

			for k,v in pairs(Config.Cloakroom) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					naso = 1
					waitara = 0
				end
			end
			if CurrentAction ~= nil then
				naso = 1
				waitara = 0
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, 38) then

					if CurrentAction == 'delivery' then
						--SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false),5,false, false)
						PostaviCPIzaKamiona()
						FreezeEntityPosition(vozilo, true)
						MiciCP = 1
					end
					
					if CurrentAction == 'Pokupi' then
						ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
							TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50)
						end)
						local modele = "prop_sacktruck_02b"
						ESX.Streaming.RequestModel(modele)
						prop_ent = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0))
						AttachEntityToEntity(prop_ent, PlayerPedId(), GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, 0.5, 181.0, true, false, false, true, 1, true)
						SetModelAsNoLongerNeeded(modele)
						--SetVehicleDoorOpen(vozilo,5,false, false)
						FreezeEntityPosition(vozilo, false)
						PritisoTipku = 1
						IstovarioTo = 0
						PostaviIstovarCP()
						if Blips['delivery'] ~= nil then
							RemoveBlip(Blips['delivery'])
							Blips['delivery'] = nil
						end
					end
					
					if CurrentAction == 'Istovari' then
						LokDos = nil
						ClearPedSecondaryTask(PlayerPedId())
						DetachEntity(prop_ent, false, false)
						DeleteObject(prop_ent)
						FreezeEntityPosition(vozilo, false)
						IstovarioTo = 1
						nouvelledestination()
					end

					if CurrentAction == 'retourcamion' then
						retourcamion_oui()
					end

					if CurrentAction == 'retourcamionperdu' then
						retourcamionperdu_oui()
					end

					if CurrentAction == 'retourcamionannulermission' then
						retourcamionannulermission_oui()
					end

					if CurrentAction == 'retourcamionperduannulermission' then
						retourcamionperduannulermission_oui()
					end

					CurrentAction = nil
				end

			end
		else
			local coords = GetEntityCoords(GetPlayerPed(-1))
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
				TriggerEvent('esx_delivererjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_delivererjob:hasExitedMarker', lastZone)
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
function MissionLivraisonSelect()
	if MissionRegion == 0 then
		MissionRegion = 1
	end
	
	if MissionRegion == 1 then -- Los santos
		MissionNum = math.random(1, 10)
		while lastpickup == MissionNum do
			Citizen.Wait(50)
			MissionNum = math.random(1, 10)
		end
		if MissionNum == 1 then destination = Config.Livraison.Delivery1LS namezone = "Delivery1LS" namezonenum = 1 namezoneregion = 1
		elseif MissionNum == 2 then destination = Config.Livraison.Delivery2LS namezone = "Delivery2LS" namezonenum = 2 namezoneregion = 1
		elseif MissionNum == 3 then destination = Config.Livraison.Delivery3LS namezone = "Delivery3LS" namezonenum = 3 namezoneregion = 1
		elseif MissionNum == 4 then destination = Config.Livraison.Delivery4LS namezone = "Delivery4LS" namezonenum = 4 namezoneregion = 1
		elseif MissionNum == 5 then destination = Config.Livraison.Delivery5LS namezone = "Delivery5LS" namezonenum = 5 namezoneregion = 1
		elseif MissionNum == 6 then destination = Config.Livraison.Delivery6LS namezone = "Delivery6LS" namezonenum = 6 namezoneregion = 1
		elseif MissionNum == 7 then destination = Config.Livraison.Delivery7LS namezone = "Delivery7LS" namezonenum = 7 namezoneregion = 1
		elseif MissionNum == 8 then destination = Config.Livraison.Delivery8LS namezone = "Delivery8LS" namezonenum = 8 namezoneregion = 1
		elseif MissionNum == 9 then destination = Config.Livraison.Delivery9LS namezone = "Delivery9LS" namezonenum = 9 namezoneregion = 1
		elseif MissionNum == 10 then destination = Config.Livraison.Delivery10LS namezone = "Delivery10LS" namezonenum = 10 namezoneregion = 1
		end
	end
	lastpickup = MissionNum
	MissionLivraisonLetsGo()
end

-- Fonction active mission livraison
function MissionLivraisonLetsGo()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	Blips['annulermission'] = AddBlipForCoord(Config.Livraison.AnnulerMission.Pos.x,  Config.Livraison.AnnulerMission.Pos.y,  Config.Livraison.AnnulerMission.Pos.z)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_goal'))
	EndTextCommandSetBlipName(Blips['annulermission'])

	if MissionRegion == 1 then -- Los santos
		ESX.ShowNotification(_U('meet_ls'))
	elseif MissionRegion == 2 then -- Blaine County
		ESX.ShowNotification(_U('meet_bc'))
	elseif MissionRegion == 0 then -- au cas ou
		ESX.ShowNotification(_U('meet_del'))
	end

	MissionLivraison = true
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setPosao')
AddEventHandler('esx:setPosao', function(job)
	ESX.PlayerData.posao = job
	if IsJobTrucker() then
		if blip == nil then
			blip = AddBlipForCoord(Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z)
		  
			SetBlipSprite (blip, 85)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.4)
			SetBlipColour (blip, 5)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_job'))
			EndTextCommandSetBlipName(blip)
		end
	else
		if blip ~= nil then
			RemoveBlip(blip)
			blip = nil
		end
		retourcamionperduannulermission_oui()
	end
end)

--Fonction retour au depot
function MissionLivraisonStopRetourDepot()
	destination = Config.Livraison.RetourCamion
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_depot'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end

	ESX.ShowNotification(_U('return_depot'))
	
	MissionRegion = 0
	MissionLivraison = false
	MissionNum = 0
	MissionRetourCamion = true
end

function SavePlaqueVehicule()
	plaquevehicule = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function VerifPlaqueVehiculeActuel()
	plaquevehiculeactuel = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end