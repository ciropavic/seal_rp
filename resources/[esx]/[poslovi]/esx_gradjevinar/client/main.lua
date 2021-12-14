ESX = nil
local Objekti = {}
local Spawno = false
local Radis = false
local Broj = 0
local UzmiCiglu = false
local OstaviCiglu = false
local ZadnjaCigla = nil
local PrvaCigla = nil
local OstaviKoord = nil
local prop = nil
local RandomPosao = 0
local Vozilo = nil
local Prikolica = nil
local Valjak = nil
local Blipic = nil
local SpawnMarker = false
local ObjBr = 1
local Blipara				  = {}

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
	AddTextComponentString("Gradjevinar")
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
				ZavrsiPosao()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
				TriggerEvent("dpemotes:Radim", false)
			end
			if data.current.value == 'job_wear' then
				if not Radis then
					isInService = true
					setUniform(PlayerPedId())
					--PokreniPosao()
				else
					ESX.ShowNotification("Vec imas uniformu na sebi!")
				end
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

function SpawnObjekte()
	for i,p in ipairs(Config.Objekti) do
		local x,y,z = table.unpack(p)
		ESX.Game.SpawnLocalObject('gravel_stone_small', {
				x = x,
				y = y,
				z = z
			}, function(obj)
			SetEntityRotation(obj, -0, -0, -19.00465, 2, true)
			FreezeEntityPosition(obj, true)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
		end)
		Blipara[i] = AddBlipForCoord(p.x,  p.y,  p.z)
		SetBlipSprite (Blipara[i], 1)
		SetBlipDisplay(Blipara[i], 8)
		SetBlipColour (Blipara[i], 2)
		SetBlipScale  (Blipara[i], 1.4)
	end
	Broj = #Config.Objekti
	Spawno = true
	ESX.ShowNotification("Poravnajte asfalt!")
end

function PokreniPosao()
	ObjBr = 1
	Radis = true
	TriggerEvent("dpemotes:Radim", true)
	Objekti = {}
	UzmiCiglu = true
	RandomPosao = math.random(1,2)
	if RandomPosao == 1 then
		OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
	elseif RandomPosao == 2 then
		OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
	end
	ESX.ShowNotification("Idite do markera da uzmete blok!")
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

function IsJobGradjevinar()
	if ESX.PlayerData.posao ~= nil then
		local gradj = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'gradjevinar' then
			gradj = true
		end
		return gradj
	end
end

function MenuVehicleSpawner()
	local elements = {}

	table.insert(elements, {label = "Gradjenje zida", value = "zid"})
	table.insert(elements, {label = "Ravnanje asfalta", value = "asfalt"})


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "zid" then
			PokreniPosao()
		elseif data.current.value == "asfalt" then
			if ESX.Game.IsSpawnPointClear({
					x = 1373.7517089844,
					y = -739.28570556641,
					z = 67.23291015625
				}, 5.0) then
				if Vozilo ~= nil then
					ESX.Game.DeleteVehicle(Vozilo)
					Vozilo = nil
				end
				if Prikolica ~= nil then
					if DoesEntityExist(Prikolica) then
						ESX.Game.DeleteVehicle(Prikolica)
					else
						TriggerServerEvent("gradjevinar:ObrisiVozila")
					end
					Prikolica = nil
				end
				if Valjak ~= nil then
					ESX.Game.DeleteVehicle(Valjak)
					Valjak = nil
				end
				DoScreenFadeOut(100)
				while not IsScreenFadedOut() do
					Wait(1)
				end
				ESX.Game.SpawnVehicle("bobcat3", {
					x = 1373.7517089844,
					y = -739.28570556641,
					z = 67.23291015625
				}, 74.24, function(callback_vehicle)
					Vozilo = callback_vehicle
					TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
				end)
				while Vozilo == nil do
					Wait(1)
				end
				--Wait(200)
				ESX.Game.SpawnVehicle("cartrailer", {
					x = 1373.7517089844,
					y = -739.28570556641,
					z = 67.23291015625
				}, 74.24, function(callback_vehicle)
					local retval = GetVehiclePedIsIn(PlayerPedId(), false)
					AttachVehicleToTrailer(retval, callback_vehicle, 5)
					Prikolica = callback_vehicle
					SetVehicleExtra(callback_vehicle, 1, true)
				end)
				while Prikolica == nil do
					Wait(1)
				end
				local nid = NetworkGetNetworkIdFromEntity(Prikolica)
				--Wait(200)
				ESX.Game.SpawnVehicle("worktruck", {
					x = 1373.7517089844,
					y = -739.28570556641,
					z = 67.23291015625
				}, 74.24, function(callback_vehicle)
					AttachVehicleOnToTrailer(callback_vehicle, Prikolica, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
					AttachEntityToEntity(callback_vehicle, Prikolica, -1, 0, -2.0, 0.3, 0, 0, 0, false, false, false, false, 0, true)
					Valjak = callback_vehicle
					--FreezeEntityPosition(callback_vehicle, true)
				end)
				while Valjak == nil do
					Wait(1)
				end
				local nid2 = NetworkGetNetworkIdFromEntity(Valjak)
				Radis = true
				Blipic = AddBlipForCoord(132.90596008301, -997.96264648438, 29.332862854004)
				SetBlipRoute(Blipic, true)
				SpawnMarker = true
				DoScreenFadeIn(100)
				while not IsScreenFadedIn() do
					Wait(1)
				end
				TriggerServerEvent("gradjevinar:SpremiNetID", nid, nid2)
				TriggerEvent("dpemotes:Radim", true)
				ESX.ShowNotification("Odite na lokaciju i poravnajte asfalt!")
			else
				ESX.ShowNotification("Trenutno nemamo slobodnih valjaka!")
			end
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		if br == 1 then
			TriggerServerEvent('esx_joblisting:setJob', 7)
			ESX.ShowNotification("Zaposlio si se kao gradjevinar!")
		end
    end
)

AddEventHandler('esx_gradjevinar:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_gradjevinar", "Upit za posao", "Dali se zelite zaposliti kao gradjevinar?")
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobGradjevinar() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobGradjevinar() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
	
	if zone == 'ulica' then
		DoScreenFadeOut(100)
		while not IsScreenFadedOut() do
			Wait(1)
		end
		SpawnObjekte()
		ESX.Game.DeleteVehicle(Vozilo)
		ESX.Game.DeleteVehicle(Prikolica)
		ESX.Game.DeleteVehicle(Valjak)
		Vozilo = nil
		Prikolica = nil
		Valjak = nil
		RemoveBlip(Blipic)
		Blipic = nil
		SpawnMarker = false
		ESX.Streaming.RequestModel("worktruck")
		Valjak = CreateVehicle("worktruck", 118.11275482178, -1015.9954223633, 29.291589736938, 247.9, true, false)
		platenum = math.random(10000, 99999)
		SetModelAsNoLongerNeeded("worktruck")
		ObjBr = 1
		SetVehicleNumberPlateText(Valjak, "SIK"..platenum)             
		plaquevehicule = "SIK"..platenum			
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), Valjak, -1)
		Wait(500)
		DoScreenFadeIn(100)
		TriggerEvent("baseevents:enteredVehicle", GetVehiclePedIsIn(PlayerPedId()), -1, 69, 69)
	end
	
	if zone == 'Uzmiciglu' then
		UzmiCiglu = false
		OstaviCiglu = true
		ESX.Streaming.RequestAnimDict('creatures@rottweiler@tricks@', function()
			FreezeEntityPosition(PlayerPedId(), true)
			TaskPlayAnim(PlayerPedId(), 'creatures@rottweiler@tricks@', 'petting_franklin', 8.0, -8, -1, 36, 0, 0, 0, 0)
			Citizen.Wait(2000)
			ClearPedSecondaryTask(PlayerPedId())
			FreezeEntityPosition(PlayerPedId(), false)
			RemoveAnimDict("creatures@rottweiler@tricks@")
		end)
		ESX.Streaming.RequestAnimDict('amb@world_human_bum_freeway@male@base', function()
			TaskPlayAnim(PlayerPedId(), 'amb@world_human_bum_freeway@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		prop = CreateObject(GetHashKey("prop_wallbrick_01"), x, y, z+2, false, false, false)
		local boneIndex = GetPedBoneIndex(playerPed, 57005)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.068, -0.241, 0.0, 90.0, 20.0, true, true, false, true, 1, true)
		ESX.ShowNotification("Idite do markera da ostavite blok!")
	end
	
	if zone == 'Ostaviciglu' then
		OstaviCiglu = false
		if ObjBr == 1 then
			ESX.Streaming.RequestAnimDict('random@domestic', function()
				FreezeEntityPosition(PlayerPedId(), true)
				TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
				Wait(500)
				DeleteObject(prop)
				prop = nil
				Citizen.Wait(1700)
				ClearPedSecondaryTask(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(), false)
				RemoveAnimDict("random@domestic")
			end)
			if RandomPosao == 1 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1373.352,
							y =  -781.0687,
							z = 66.01108
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset
				end)
			elseif RandomPosao == 2 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1367.143,
							y =  -779.98,
							z = 66.02597
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset
				end)
			end
			ObjBr = ObjBr+1
			UzmiCiglu = true
			TriggerServerEvent("gradjevinar:tuljaniplivaju")
			TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
		else
			if ObjBr > 1 and ObjBr ~= 16 and ObjBr ~= 31 and ObjBr ~= 46 and ObjBr ~= 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(ZadnjaCigla, -0.42, 0.0, -0.073) --lijevo
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = prvioffset.x,
							y =  prvioffset.y,
							z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					if ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
						if RandomPosao == 1 then
							OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
						elseif RandomPosao == 2 then
							OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
						end
					else
						local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
						OstaviKoord = prvioffset2
					end
				end)
				ObjBr = ObjBr+1
				if ObjBr == 76 then
					ESX.ShowNotification("Zavrsili ste sa poslom!")
					ESX.ShowNotification("Da pocnete ponovno raditi ostavite i uzmite opremu!")
				else
					UzmiCiglu = true
				end
				TriggerServerEvent("gradjevinar:tuljaniplivaju")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
			elseif ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(PrvaCigla, 0.0, 0.0, 0.07) --gore
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
					x = prvioffset.x,
					y =  prvioffset.y,
					z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset2
				end)
				ObjBr = ObjBr+1
				UzmiCiglu = true
				TriggerServerEvent("gradjevinar:tuljaniplivaju")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
			end
		end
	end
end)

function ZavrsiPosao()
	if Valjak ~= nil then
		if Vozilo ~= nil then
			ESX.Game.DeleteVehicle(Vozilo)
		end
		if DoesEntityExist(Prikolica) then
			ESX.Game.DeleteVehicle(Prikolica)
		else
			TriggerServerEvent("gradjevinar:ObrisiVozila")
		end
		if Valjak ~= nil then
			ESX.Game.DeleteVehicle(Valjak)
		end
		if Blipic ~= nil then
			RemoveBlip(Blipic)
			Blipic = nil
		end
		for i=1, #Objekti, 1 do
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
		Valjak = nil
		Spawno = false
		Radis = false
		SpawnMarker = false
		TriggerEvent("dpemotes:Radim", false)
	end
	if Radis == true then
		for i=1, #Objekti, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
			end
		end
		Radis = false
		TriggerEvent("dpemotes:Radim", false)
		OstaviCiglu = false
		UzmiCiglu = false
		ZadnjaCigla = nil
		OstaviKoord = nil
	end
end

-- Key Controls
Citizen.CreateThread(function()
	local waitara = 500
    while true do
        Citizen.Wait(waitara)
		local naso = 0
		if IsJobGradjevinar() then
			if Spawno == true and Broj > 0 then
				waitara = 20
				naso = 1
				local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
				if tablica == plaquevehicule then
					--local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_veg_grass_02_a")
					--local koord = GetEntityCoords(PlayerPedId())
					--for i=1, #Config.Objekti3, 1 do
						if Objekti[ObjBr] ~= nil then
							local koord = GetEntityCoords(PlayerPedId())
							if #(koord-Config.Objekti[ObjBr]) <= 1.5 then
							--if GetDistanceBetweenCoords(koord, Config.Objekti[ObjBr].x, Config.Objekti[ObjBr].y, Config.Objekti[ObjBr].z, false) <= 1 then
								--if NewBinDistance <= 2 then
									Wait(100)
									ESX.Game.DeleteObject(Objekti[ObjBr])
									Objekti[ObjBr] = nil
									if DoesBlipExist(Blipara[ObjBr]) then
										RemoveBlip(Blipara[ObjBr])
									end
									Broj = Broj-1
									ObjBr = ObjBr+1
									TriggerServerEvent("gradjevinar:tuljaniplivaju2")
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
										Blipic = AddBlipForCoord(1384.1656494141, -741.45233154297, 66.193939208984)
										SetBlipRoute(Blipic, true)
										Broj = 0
										local novacor = GetEntityCoords(PlayerPedId())
										local x,y,z = table.unpack(novacor)
										--local retval, outPosition, outHeading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3.0, 0)
										local kord1 = vector3(198.33883666992, -1037.0025634766, 28.142356872559)
										ESX.Game.SpawnVehicle("bobcat3", kord1, 249.80, function(callback_vehicle)
											Vozilo = callback_vehicle
											TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
										end)
										while Vozilo == nil do
											Wait(1)
										end
										--Wait(200)
										local kord2 = vector3(191.92486572266, -1034.5772705078, 28.13547706604)
										ESX.Game.SpawnVehicle("cartrailer", kord2, 252.15, function(callback_vehicle)
											local retval = GetVehiclePedIsIn(PlayerPedId(), false)
											AttachVehicleToTrailer(retval, callback_vehicle, 5)
											Prikolica = callback_vehicle
											SetVehicleExtra(callback_vehicle, 1, true)
										end)
										while Prikolica == nil do
											Wait(1)
										end
										--Wait(200)
										local kord3 = vector3(184.1916809082, -1032.0869140625, 28.130422592163)
										ESX.Game.SpawnVehicle("worktruck", kord3, 252.14, function(callback_vehicle)
											AttachVehicleOnToTrailer(callback_vehicle, Prikolica, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
											AttachEntityToEntity(callback_vehicle, Prikolica, -1, 0, -2.0, 0.3, 0, 0, 0, false, false, false, false, 0, true)
											Valjak = callback_vehicle
											--FreezeEntityPosition(callback_vehicle, true)
										end)
										DoScreenFadeIn(100)
										while not IsScreenFadedIn() do
											Wait(1)
										end
										TriggerEvent("baseevents:enteredVehicle", GetVehiclePedIsIn(PlayerPedId()), -1, 69, 69)
										ESX.ShowNotification("Uspjesno zavrsen posao, sada vratite valjak do sjedista!")
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
		end
		if naso == 0 then
			waitara = 500
		end
    end
end)

AddEventHandler('esx_gradjevinar:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local koord1 = vector3(1380.8416748047, -773.89587402344, 65.999649047852)
local koord2 = vector3(132.90596008301, -997.96264648438, 28.332862854004)
-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local isInMarker  = false
		local currentZone = nil
		if IsJobGradjevinar() then
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
			
			if Radis and UzmiCiglu and (#(coords-koord1) < 2.0) then
				isInMarker  = true
				currentZone = "Uzmiciglu"
			end
			
			if Radis and OstaviCiglu and (GetDistanceBetweenCoords(coords, OstaviKoord, false) < 0.5) then
				isInMarker  = true
				currentZone = "Ostaviciglu"
			end
			
			if Radis == true and SpawnMarker == true and (#(coords-koord2) < 3.0) then
				local cordara = GetEntityCoords(Prikolica)
				if #(cordara-koord2) < 6.0 then
				--if GetDistanceBetweenCoords(cordara, 132.90596008301, -997.96264648438, 29.332862854004, true) < 6.0 then
					isInMarker  = true
					currentZone = "ulica"
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_gradjevinar:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_gradjevinar:hasExitedMarker', lastZone)
			end

		
			if Radis and UzmiCiglu and #(coords-koord1) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 1380.8416748047, -773.89587402344, 65.999649047852, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			if Radis and OstaviCiglu and #(coords-OstaviKoord) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(0, OstaviKoord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			if SpawnMarker and #(coords-koord2) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 132.90596008301, -997.96264648438, 28.332862854004, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
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
			
			if CurrentAction ~= nil then
				waitara = 0
				naso = 1
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) and IsJobGradjevinar() then

					if CurrentAction == 'Obrisi' then
						local retval, trailer = GetVehicleTrailerVehicle(Vozilo)
						if trailer ~= Prikolica then
							ESX.ShowNotification("Oduzeto vam je 1000 dolara zato sto ste se vratili bez prikolice")
							TriggerServerEvent("gradjevinar:Penali")
						end
						ZavrsiPosao()
					end
					CurrentAction = nil
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
				TriggerEvent('esx_gradjevinar:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_gradjevinar:hasExitedMarker', lastZone)
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