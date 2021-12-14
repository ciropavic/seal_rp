--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil
local Spawno = false
local Broj = 0
local Radis = false
local Vozilo = nil
local Blipic = nil
local LokBroj = nil
local BrTura = 0
local Kvarovi = {}
local Pokvareni = {}
local PopraviMe = nil
local TaLokacija = nil

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
	Wait(5000)
	ESX.TriggerServerCallback('kvarovi:DohvatiKvarove', function(kvarovi)
		Kvarovi = kvarovi
	end)
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
	AddTextComponentString("Elektricar")
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

RegisterCommand("uredikvarove", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			ESX.UI.Menu.CloseAll()
			local elements = {
				{label = "Lista kvarova", value = "lkvar"},
				{label = "Dodaj kvar", value = "nkvar"}
			}

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'ukvarovi',
				{
					title    = "Izaberite opciju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "nkvar" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'radius', {
							title = "Upisite radius kvara (default 40)",
						}, function (datari, menuri)
							local radius = datari.value
							if radius == nil or tonumber(radius) < 1 then
								ESX.ShowNotification('Greska.')
							else
								local coords = GetEntityCoords(PlayerPedId())
								TriggerServerEvent("kvarovi:DodajKvar", coords, radius)
								menuri.close()
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					elseif data.current.value == "lkvar" then
						local elements = {}
						for i=1, #Kvarovi, 1 do
							if Kvarovi[i] ~= nil then
								table.insert(elements, {label = Kvarovi[i].Ime, value = Kvarovi[i].Ime})
							end
						end
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'lkvarovi',
							{
								title    = "Izaberite kvar",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								local elements = {
									{label = "Portaj se do kvara", value = "port"},
									{label = "Premjesti kvar", value = "premj"},
									{label = "Promjeni radius kvara", value = "rad"},
									{label = "Obrisi kvar", value = "brisi"}
								}
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'lkvarovi2',
									{
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									},
									function(data3, menu3)
										if data3.current.value == "premj" then
											local korda = GetEntityCoords(PlayerPedId())
											TriggerServerEvent("kvarovi:Premjesti", data2.current.value, korda)
											menu3.close()
											ESX.ShowNotification("Premjestili ste kvar "..data2.current.value)
										elseif data3.current.value == "brisi" then
											TriggerServerEvent("kvarovi:Obrisi", data2.current.value)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Obrisali ste kvar "..data2.current.value)
										elseif data3.current.value == "rad" then
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'radius', {
												title = "Upisite radius kvara (default 40)",
											}, function (datari, menuri)
												local radius = datari.value
												if radius == nil or tonumber(radius) < 1 then
													ESX.ShowNotification('Greska.')
												else
													local coords = GetEntityCoords(PlayerPedId())
													TriggerServerEvent("kvarovi:UrediRadius", data2.current.value, radius)
													menuri.close()
												end
											end, function (datari, menuri)
												menuri.close()
											end)
										elseif data3.current.value == "port" then
											menu3.close()
											menu2.close()
											for i=1, #Kvarovi, 1 do
												if Kvarovi[i] ~= nil and Kvarovi[i].Koord ~= nil then
													if Kvarovi[i].Ime == data2.current.value then
														SetEntityCoords(PlayerPedId(), Kvarovi[i].Koord)
													end
												end
											end
											ESX.ShowNotification("Portali ste se do kvara "..data2.current.value)
										end
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
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

RegisterNetEvent('kvarovi:SaljiKvarove')
AddEventHandler('kvarovi:SaljiKvarove', function(kvarovi) 
	Kvarovi = kvarovi
end)

RegisterNetEvent('kvarovi:SaljiPokvarene')
AddEventHandler('kvarovi:SaljiPokvarene', function(pokvareni) 
	Pokvareni = pokvareni
end)

RegisterNUICallback(
    "kraj",
    function(data, cb)
		if data.win then
			SendNUIMessage({
				prikazi = true
			})
			SetNuiFocus(false)
			ClearPedTasksImmediately(PlayerPedId())
			if TaLokacija ~= nil then
				TriggerServerEvent("elektricar:platituljanu2")
			else
				TriggerServerEvent("elektricar:platituljanu")
			end
			TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.posao.name)
			if TaLokacija ~= nil then
				TriggerServerEvent("kvarovi:MakniKvar", TaLokacija)
			end
			BrTura = BrTura+1
			if BrTura ~= 10 then
				if TaLokacija == nil then
					SpucajPosao()
				else
					TaLokacija = nil
					SpucajPosao2()
				end
			else
				ESX.ShowNotification("Vratite vozilo u firmu!")
				for k,v in pairs(Config.Zones) do
					if k == "VehicleDeletePoint" then
						Blipic = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
						SetBlipRoute(Blipic, true)
					end
				end
			end
		end
    end
)

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = "Popravak ormarica po gradu", value = Config.Trucks[i]})
	end
	table.insert(elements, {label = "Popravak struje po trgovinama ("..#Pokvareni..")", value = "struja"})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "burrito" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 243.11, true, false)
			platenum = math.random(10000, 99999)
			SetModelAsNoLongerNeeded(data.current.value)
			SetVehicleNumberPlateText(Vozilo, "HUG"..platenum)             
			plaquevehicule = "HUG"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			Radis = true
			SpucajPosao()
		elseif data.current.value == "struja" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			if #Pokvareni > 0 then
				ESX.Streaming.RequestModel("burrito")
				Vozilo = CreateVehicle("burrito", Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 243.11, true, false)
				platenum = math.random(10000, 99999)
				SetModelAsNoLongerNeeded("burrito")
				SetVehicleNumberPlateText(Vozilo, "HUG"..platenum)
				plaquevehicule = "HUG"..platenum
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
				Radis = true
				SpucajPosao2()
			else
				ESX.ShowNotification("Nema prijavljenih kvarova!")
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

function SpucajPosao()
	LokBroj = math.random(1, #Config.Lokacije)
	Blipic = AddBlipForCoord(Config.Lokacije[LokBroj].x, Config.Lokacije[LokBroj].y, Config.Lokacije[LokBroj].z)
	SetBlipRoute(Blipic, true)
	Spawno = true
	ESX.ShowNotification("Idite do ormarica i popravite struju!")
end

function SpucajPosao2()
	if #Pokvareni > 0 then
		LokBroj = math.random(1, #Pokvareni)
		Blipic = AddBlipForCoord(Pokvareni[LokBroj].Koord.x, Pokvareni[LokBroj].Koord.y, Pokvareni[LokBroj].Koord.z)
		TaLokacija = Pokvareni[LokBroj].Ime
		SetBlipRoute(Blipic, true)
		Spawno = true
		PopraviMe = Pokvareni[LokBroj].Koord
		ESX.ShowNotification("Idite do trgovine i popravite struju!")
	else
		ESX.ShowNotification("Nema prijavljenih kvarova, vratite vozilo u firmu!")
		for k,v in pairs(Config.Zones) do
			if k == "VehicleDeletePoint" then
				Blipic = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
				SetBlipRoute(Blipic, true)
			end
		end
	end
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

function IsJobElektricar()
	if ESX.PlayerData.posao ~= nil then
		local kosac = false
		if ESX.PlayerData.posao.name ~= nil and ESX.PlayerData.posao.name == 'elektricar' then
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
			TriggerServerEvent('esx_joblisting:setJob', 4)
			ESX.ShowNotification("Zaposlio si se kao elektricar!")
		end
    end
)

AddEventHandler('esx_elektricar:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == "posao" then
		TriggerEvent("upit:OtvoriPitanje", "esx_elektricar", "Upit za posao", "Dali se zelite zaposliti kao elektricar?")
	end
	
	if zone == 'Radis' then
		LokBroj = nil
		RemoveBlip(Blipic)
		PopraviMe = nil
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
		SendNUIMessage({
			prikazi = true
		})
		SetNuiFocus(true, true)
		ESX.ShowNotification("Povezite zice sa svojim bojama kako bih ste popravili kvar!")
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobElektricar() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobElektricar() then
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
	if Blipic ~= nil then
		RemoveBlip(Blipic)
	end
	BrTura = 0
	Broj = 0
	Vozilo = nil
	Blipic = nil
	Spawno = false
	Radis = false
	PopraviMe = nil
	LokBroj = nil
end

AddEventHandler('esx_elektricar:hasExitedMarker', function(zone)
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
		if IsJobElektricar() then
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) and IsJobElektricar() then
					if CurrentAction == 'Obrisi' then
						ZavrsiPosao()
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
	local odradio = false
	while true do
		Wait(waitara)
		local naso = 0
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local dalekosi = false
		for i=1, #Pokvareni, 1 do
			if Pokvareni[i] ~= nil and Pokvareni[i].Koord ~= nil then
				local kordara = Pokvareni[i].Koord
				if (kordara.x ~= 0 and kordara.x ~= nil) and (kordara.y ~= 0 and kordara.y ~= nil) and (kordara.z ~= 0 and kordara.z ~= nil) then
					if #(coords-kordara) < tonumber(Pokvareni[i].Radius) then
						dalekosi = true
						if not odradio then
							odradio = true
							SetArtificialLightsState(true)
							SetArtificialLightsStateAffectsVehicles(false)
							TriggerEvent("elektricar:NemaStruje", true)
						end
					end
				end
			end
		end
		if odradio and not dalekosi then
			SetArtificialLightsState(false)
			TriggerEvent("elektricar:NemaStruje", false)
			odradio = false
		end
		local isInMarker  = false
		local currentZone = nil
		if IsJobElektricar() then

			for k,v in pairs(Config.Zones) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					waitara = 0
					naso = 1
					isInMarker  = true
					currentZone = k
				end
			end
			
			if LokBroj ~= nil then
				if PopraviMe == nil then
					if #(coords-Config.Lokacije[LokBroj]) < 15.0 then
					--if(GetDistanceBetweenCoords(coords, Config.Lokacije[LokBroj].x, Config.Lokacije[LokBroj].y, Config.Lokacije[LokBroj].z-1.0, true) < 15.0) then
						waitara = 0
						naso = 1
						local x,y,z = table.unpack(Config.Lokacije[LokBroj])
						DrawMarker(1, x, y, z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					end
					if #(coords-Config.Lokacije[LokBroj]) < 1.0 then
					--if(GetDistanceBetweenCoords(coords, Config.Lokacije[LokBroj].x, Config.Lokacije[LokBroj].y, Config.Lokacije[LokBroj].z, true) < 1.0) then
						if not IsPedInAnyVehicle(PlayerPedId(), false) then
							isInMarker  = true
							currentZone = "Radis"
						end
					end
				else
					if #(coords-PopraviMe) < 15.0 then
					--if(GetDistanceBetweenCoords(coords, Config.Lokacije[LokBroj].x, Config.Lokacije[LokBroj].y, Config.Lokacije[LokBroj].z-1.0, true) < 15.0) then
						waitara = 0
						naso = 1
						local x,y,z = table.unpack(PopraviMe)
						DrawMarker(1, x, y, z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					end
					if #(coords-PopraviMe) < 1.0 then
					--if(GetDistanceBetweenCoords(coords, Config.Lokacije[LokBroj].x, Config.Lokacije[LokBroj].y, Config.Lokacije[LokBroj].z, true) < 1.0) then
						if not IsPedInAnyVehicle(PlayerPedId(), false) then
							isInMarker  = true
							currentZone = "Radis"
						end
					end
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
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_elektricar:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_elektricar:hasExitedMarker', lastZone)
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
				TriggerEvent('esx_elektricar:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_elektricar:hasExitedMarker', lastZone)
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