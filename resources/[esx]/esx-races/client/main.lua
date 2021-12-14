ESX                           = nil

local RaceVehicle = nil
local Rx = 0.0
local Ry = 0.0
local Rz = 0.0
local Rh = 0.0
local Rx2 = 0.0
local Ry2 = 0.0
local Rz2 = 0.0
local Rh2 = 0.0
local LastPosX = 0.0
local LastPosY = 0.0
local LastPosZ = 0.0
local ucitao = 0
local Lokacija = 0
local Prvi = 0
local UUtrci = 0
local PokrenutaUtrka = 0
local PocelaUtrka = 0
local USudjeluje = 0
local Pozicija = 1
local NazivUtrke = nil
local Permisija = 0
local MaxTada = 0
local Minuta = 0
local Startajj = 0
local CheckPoint
local Blip
local isRacing = false
local PrikazoUI = false
local PozicijaCP = {}
local ZatvoriUI = false

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(1)
    end
end) 

function StartRace(currentRace)
	Startajj = 0
    local currentCheckPoint = 1
    local nextCheckPoint = 2
	ucitao = 0
	Prvi = 0
	Lokacija = 0
	Pozicija = 1
	SetVehicleDoorsLocked(RaceVehicle, 0)
	TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
	
	local ata = GetMaxCheckPoints(Config.CheckPoints, currentRace)
	for i = 1,ata,1 do 
	   PozicijaCP[i] = 1
	end

    StartTime = GetGameTimer()

    Citizen.CreateThread(function()

        CheckPoint = CreateCheckpoint(5, Config.CheckPoints[currentRace][currentCheckPoint].x,  Config.CheckPoints[currentRace][currentCheckPoint].y,  Config.CheckPoints[currentRace][currentCheckPoint].z + 2, Config.CheckPoints[currentRace][nextCheckPoint].x, Config.CheckPoints[currentRace][nextCheckPoint].y, Config.CheckPoints[currentRace][nextCheckPoint].z, 8.0, 255, 255, 255, 100, 0)
        Blip = AddBlipForCoord(Config.CheckPoints[currentRace][currentCheckPoint].x, Config.CheckPoints[currentRace][currentCheckPoint].y, Config.CheckPoints[currentRace][currentCheckPoint].z)   
		local hashara = GetHashKey("WEAPON_UNARMED")
        while isRacing do
            Citizen.Wait(5)
			
			SetCurrentPedWeapon(PlayerPedId(),hashara,true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			SetPlayerCanDoDriveBy(PlayerId(), false)

            local PlayerCoords = GetEntityCoords(PlayerPedId())

            local currentTime = formatTimer(StartTime, GetGameTimer())

            --ESX.Game.Utils.DrawText3D({x = PlayerCoords.x, y = PlayerCoords.y, z = PlayerCoords.z + 1.2}, currentCheckPoint .. ' / ' ..GetMaxCheckPoints(Config.CheckPoints, currentRace), 0.4)
            --ESX.Game.Utils.DrawText3D({x = PlayerCoords.x, y = PlayerCoords.y, z = PlayerCoords.z + 1.4}, currentTime, 0.4)
			local cptekstic = currentCheckPoint .. '/' ..GetMaxCheckPoints(Config.CheckPoints, currentRace)
			if ZatvoriUI == false then
				if PrikazoUI == false then
					SendNUIMessage({
					prikazirace = true,
					updatevrijeme = true,
					updatecp = true,
					vrijeme = currentTime,
					cp = cptekstic
					})
					PrikazoUI = true
				else
					SendNUIMessage({
					updatevrijeme = true,
					updatecp = true,
					vrijeme = currentTime,
					cp = cptekstic
					})
				end
			end
			

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CheckPoints[currentRace][currentCheckPoint].x,  Config.CheckPoints[currentRace][currentCheckPoint].y,  Config.CheckPoints[currentRace][currentCheckPoint].z) < 7.5 then

                if currentCheckPoint == GetMaxCheckPoints(Config.CheckPoints, currentRace) - 1 then
                    currentCheckPoint = GetMaxCheckPoints(Config.CheckPoints, currentRace)
                    PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
                    DeleteCheckpoint(CheckPoint)
                    RemoveBlip(Blip)
					local straa = PozicijaCP[currentCheckPoint-1].."/10"
					SendNUIMessage({
						updatepoz = true,
						poz = straa
					})
					PozicijaCP[currentCheckPoint-1] = PozicijaCP[currentCheckPoint-1]+1
					TriggerServerEvent("SpremiPozicijuCP", currentCheckPoint-1, PozicijaCP[currentCheckPoint-1])
                    CheckPoint = CreateCheckpoint(9, Config.CheckPoints[currentRace][currentCheckPoint].x,  Config.CheckPoints[currentRace][currentCheckPoint].y,  Config.CheckPoints[currentRace][currentCheckPoint].z + 2, Config.CheckPoints[currentRace][nextCheckPoint].x, Config.CheckPoints[currentRace][nextCheckPoint].y, Config.CheckPoints[currentRace][nextCheckPoint].z, 8.0, 255, 255, 255, 100, 0)
					Blip = AddBlipForCoord(Config.CheckPoints[currentRace][currentCheckPoint].x, Config.CheckPoints[currentRace][currentCheckPoint].y, Config.CheckPoints[currentRace][currentCheckPoint].z)
                elseif currentCheckPoint == GetMaxCheckPoints(Config.CheckPoints, currentRace) then
                    PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                    DeleteCheckpoint(CheckPoint)
                    RemoveBlip(Blip)
					SetPlayerCanDoDriveBy(PlayerId(), true)
					isRacing = false
                    ESX.ShowNotification("Zavrsili ste utrku " .. currentRace .. " sa vremenom " .. currentTime .. " sekundi !")
					ESX.ShowNotification("Bio si " .. Pozicija .. ". od " .. MaxTada .. "!")
					TriggerServerEvent('utrka:DiSuDajPare', Pozicija)
                    TriggerServerEvent('esx-qalle-races:addTime', currentTime, currentRace)
                    DeleteEntity(RaceVehicle)
					TriggerServerEvent("utrke:BucketajGa", false)
					USudjeluje = 0
					TriggerEvent("radarce:NemojGa", 0)
					TriggerEvent("NPC:MakniNPC", 0)
					ZatvoriUI = true
					SendNUIMessage({
						zatvorirace = true
					})
					PrikazoUI = false
					SetEntityCoords(GetPlayerPed(-1), LastPosX, LastPosY, LastPosZ)
					UUtrci = UUtrci-1
					TriggerServerEvent("SpremiBroj", UUtrci)
					if UUtrci == 0 then
					UUtrci = 0
					MaxTada = 0
					ucitao = 0
					Lokacija = 0
					Prvi = 0
					TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
					TriggerServerEvent("SpremiTada", MaxTada)
					TriggerServerEvent("SpremiBroj", UUtrci)
					Pozicija = 1
					TriggerServerEvent("SpremiPoziciju", Pozicija)
					NazivUtrke = nil
					TriggerServerEvent("SpremiUtrku", NazivUtrke)
					PokrenutaUtrka = 0
					TriggerServerEvent("SpremiPokret", PokrenutaUtrka)
					PocelaUtrka = 0
					TriggerServerEvent("SpremiPocela", PocelaUtrka)
					end
					Pozicija = Pozicija+1
					TriggerServerEvent("SpremiPoziciju", Pozicija)
                    return
                else
                    PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
                    DeleteCheckpoint(CheckPoint)
                    RemoveBlip(Blip)
                    currentCheckPoint = currentCheckPoint + 1
					local straa = PozicijaCP[currentCheckPoint-1].."/10"
					SendNUIMessage({
						updatepoz = true,
						poz = straa
					})
					PozicijaCP[currentCheckPoint-1] = PozicijaCP[currentCheckPoint-1]+1
					TriggerServerEvent("SpremiPozicijuCP", currentCheckPoint-1, PozicijaCP[currentCheckPoint-1])
                    nextCheckPoint = nextCheckPoint + 1
                    CheckPoint = CreateCheckpoint(5, Config.CheckPoints[currentRace][currentCheckPoint].x,  Config.CheckPoints[currentRace][currentCheckPoint].y,  Config.CheckPoints[currentRace][currentCheckPoint].z + 2, Config.CheckPoints[currentRace][nextCheckPoint].x, Config.CheckPoints[currentRace][nextCheckPoint].y, Config.CheckPoints[currentRace][nextCheckPoint].z, 8.0, 255, 255, 255, 100, 0)
                    Blip = AddBlipForCoord(Config.CheckPoints[currentRace][currentCheckPoint].x, Config.CheckPoints[currentRace][currentCheckPoint].y, Config.CheckPoints[currentRace][currentCheckPoint].z)   
                end

            end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CheckPoints[currentRace][currentCheckPoint].x,  Config.CheckPoints[currentRace][currentCheckPoint].y,  Config.CheckPoints[currentRace][currentCheckPoint].z, true) >= 650.0 and USudjeluje == 1 then
                ESX.Game.DeleteVehicle(RaceVehicle)
				TriggerServerEvent("utrke:BucketajGa", false)
                ESX.ShowNotification("Otisli ste predaleko od utrke.")
                DeleteCheckpoint(CheckPoint)
                RemoveBlip(Blip)
				SetPlayerCanDoDriveBy(PlayerId(), true)
                isRacing = false
				USudjeluje = 0
				TriggerEvent("radarce:NemojGa", 0)
				TriggerEvent("NPC:MakniNPC", 0)
				ZatvoriUI = true
				SendNUIMessage({
						zatvorirace = true
				})
				PrikazoUI = false
				SetEntityCoords(GetPlayerPed(-1), LastPosX, LastPosY, LastPosZ)
				UUtrci = UUtrci-1
				TriggerServerEvent("SpremiBroj", UUtrci)
				if UUtrci == 0 then
					UUtrci = 0
					TriggerServerEvent("SpremiBroj", UUtrci)
					Pozicija = 1
					TriggerServerEvent("SpremiPoziciju", Pozicija)
					ucitao = 0
					Lokacija = 0
					Prvi = 0
					TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
					NazivUtrke = nil
					TriggerServerEvent("SpremiUtrku", NazivUtrke)
					PokrenutaUtrka = 0
					TriggerServerEvent("SpremiPokret", PokrenutaUtrka)
					PocelaUtrka = 0
					TriggerServerEvent("SpremiPocela", PocelaUtrka)
				end
                return
            end
			if not IsPedInAnyVehicle(PlayerPedId(), false) and USudjeluje == 1 then
                ESX.Game.DeleteVehicle(RaceVehicle)
				TriggerServerEvent("utrke:BucketajGa", false)
                ESX.ShowNotification("Napustili ste vozilo te ste izbaceni iz utrke!")
                DeleteCheckpoint(CheckPoint)
                RemoveBlip(Blip)
				SetPlayerCanDoDriveBy(PlayerId(), true)
                isRacing = false
				USudjeluje = 0
				TriggerEvent("radarce:NemojGa", 0)
				TriggerEvent("NPC:MakniNPC", 0)
				ZatvoriUI = true
				SendNUIMessage({
						zatvorirace = true
				})
				PrikazoUI = false
				SetEntityCoords(GetPlayerPed(-1), LastPosX, LastPosY, LastPosZ)
				UUtrci = UUtrci-1
				TriggerServerEvent("SpremiBroj", UUtrci)
				if UUtrci == 0 then
					UUtrci = 0
					TriggerServerEvent("SpremiBroj", UUtrci)
					Pozicija = 1
					TriggerServerEvent("SpremiPoziciju", Pozicija)
					NazivUtrke = nil
					TriggerServerEvent("SpremiUtrku", NazivUtrke)
					ucitao = 0
					Lokacija = 0
					Prvi = 0
					TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
					PokrenutaUtrka = 0
					TriggerServerEvent("SpremiPokret", PokrenutaUtrka)
					PocelaUtrka = 0
					TriggerServerEvent("SpremiPocela", PocelaUtrka)
				end
                return
            end
        end
    end)
end

RegisterCommand("napustiutrku", function(source, args, rawCommandString)
	if USudjeluje == 1 then
	ESX.Game.DeleteVehicle(RaceVehicle)
	TriggerServerEvent("utrke:BucketajGa", false)
    ESX.ShowNotification("Napustili ste utrku!")
    DeleteCheckpoint(CheckPoint)
	TriggerEvent("NPC:MakniNPC", 0)
	TriggerEvent("radarce:NemojGa", 0)
    RemoveBlip(Blip)
	SetPlayerCanDoDriveBy(PlayerId(), true)
    isRacing = false
	Startajj = 0
	ZatvoriUI = true
	SendNUIMessage({
		zatvorirace = true
	})
	PrikazoUI = false
	USudjeluje = 0
	UUtrci = UUtrci-1
	TriggerServerEvent("SpremiBroj", UUtrci)
	SetEntityCoords(GetPlayerPed(-1), LastPosX, LastPosY, LastPosZ)
	else
	ESX.ShowNotification("Niste u utrci!")
	end
end, false)

RegisterCommand("pokreniutrku", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local utrka = args[1]
			local raceInfo = Config.RaceInformations[utrka]
			if raceInfo ~= nil then
				if PokrenutaUtrka == 0 then
					ucitao = 0
					Lokacija = 0
					Prvi = 0
					TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
					PokrenutaUtrka = 1
					NazivUtrke = utrka
					TriggerServerEvent("SpremiUtrku", NazivUtrke)
					TriggerServerEvent("SpremiPokret", PokrenutaUtrka)
					TriggerServerEvent("PosaljiPoruku")
					if PokrenutaUtrka == 1 then
						local Sekundice = 60
						TriggerServerEvent("SyncajVrijeme", Sekundice)
					end
					Wait(30000)
					if UUtrci < 10 and PokrenutaUtrka == 1 then
						TriggerServerEvent("PosaljiPoruku2")
					end
				else
					ESX.ShowNotification("Vec je pokrenuta utrka!")
				end
			else
				name = "Admin"..":"
				message = "/pokreniutrku [Ime utrke]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				name = "Popis utrka"
				local testa = ""
				local br = 0
				for race, val in pairs(Config.RaceInformations) do
					if br == 0 then
						testa = race
					else
						testa = testa.."\n"..race
					end
					br = br+1
					--TriggerEvent('chat:addMessage', { args = { name, race }, color = r,g,b })
				end
				TriggerEvent('chat:addMessage', {
				template = '<div style="position:relative;left:-25px; padding: 0.5vw; width:98%; margin: 0.5vw; background-color: rgba(0, 190, 255, 0.6); border-radius: 3px;"><font style="position:relative; left:45px;"><i class="fab fa-etsy"></i> {0}:<br> {1}</font></div>',
				multiline = true, args = { name, testa }
				})
				--TriggerEvent('chat:addMessage', { multiline = true, args = { name, testa }, color = r,g,b })
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("zaustaviutrku", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
		local raceInfo = Config.RaceInformations[NazivUtrke]
		if raceInfo ~= nil then
		PokrenutaUtrka = 0
		TriggerServerEvent("SpremiPokret", PokrenutaUtrka)
		PocelaUtrka = 0
		TriggerServerEvent("SpremiPocela", PocelaUtrka)
		NazivUtrke = nil
		TriggerServerEvent("SpremiUtrku", NazivUtrke)
		UUtrci = 0
		TriggerServerEvent("SpremiBroj", UUtrci)
		Pozicija = 1
		TriggerServerEvent("SpremiPoziciju", Pozicija)
		TriggerServerEvent("PrekiniUtrku")
		else
		ESX.ShowNotification("Nema pokrenute utrke!")
		end
		else
		ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("escoreboard", function(source, args, rawCommandString)
	if PokrenutaUtrka == 1 then
		if USudjeluje == 1 and NazivUtrke ~= nil then
			OpenScoreboard(NazivUtrke)
		else
			ESX.ShowNotification("Nise u utrci")
		end
	else
		ESX.ShowNotification("Nema pokrenute utrke")
	end
end, false)

RegisterCommand("join", function(source, args, rawCommandString)
	if PokrenutaUtrka == 1 and PocelaUtrka == 0 then
		if UUtrci < 10 then
			if USudjeluje == 0 then
				USudjeluje = 1
				Pozicija = 1
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				LastPosX = x
				LastPosY = y
				LastPosZ = z
				TriggerEvent("NPC:MakniNPC", 1)
				TriggerEvent("radarce:NemojGa", 1)
				Citizen.CreateThread(function()
					local hashara = GetHashKey("WEAPON_UNARMED")
					while isRacing == false and USudjeluje == 1 do
						Citizen.Wait(0)
						SetCurrentPedWeapon(PlayerPedId(),hashara,true)
						DisableControlAction(0, 24, true)
						DisableControlAction(0, 25, true)
						SetPlayerCanDoDriveBy(PlayerId(), false)
					end
				end)
				PrikazoUI = false
				ZatvoriUI = false
				SpawnajGa(NazivUtrke)
				UUtrci = UUtrci+1
				TriggerServerEvent("SpremiBroj", UUtrci)
				MaxTada = UUtrci
				TriggerServerEvent("SpremiTada", MaxTada)
				ESX.ShowNotification("Kako bih ste napustili utrku upisite /napustiutrku")
				TriggerEvent("EoTiIzSalona", 1)
				local elem = {}

				ESX.TriggerServerCallback('esx-qalle-races:getScoreboard', function(Races)
					if Races[1] ~= nil then
					local tekst = 'Rekord utrke drzi '..Races[1].name..' ('..tonumber(string.format("%.2f", Races[1].time))..')'
					ESX.ShowNotification(tekst)
					end
				end, NazivUtrke)
				ESX.ShowNotification("Kako bih ste vidjeli scoreboard utrke upisite /escoreboard")
				Startajj = 1
				PratiPocetak()
			else
				ESX.ShowNotification("Vec ste u utrci")
			end
		else
			ESX.ShowNotification("Utrka je popunjena")
		end
	else
		ESX.ShowNotification("Nema pokrenute utrke")
	end
end, false)

function PratiPocetak()
local Aha1 = 0
local Aha2 = 0
local Aha3 = 0
local AhaGo = 0
Citizen.CreateThread(function()
	while Startajj == 1 do
		Citizen.Wait(0)
		if Minuta == 3 and Aha1 == 0 then
		TriggerEvent("pNotify:SendNotification", {text = "3", type = "info", timeout = 1000, layout = "bottomCenter"})
		PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
		Aha1 = 1
		end
		if Minuta == 2 and Aha2 == 0 then
		TriggerEvent("pNotify:SendNotification", {text = "2", type = "info", timeout = 1000, layout = "bottomCenter"})
		PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
		Aha2 = 1
		end
		if Minuta == 1 and Aha3 == 0 then
		TriggerEvent("pNotify:SendNotification", {text = "1", type = "info", timeout = 1000, layout = "bottomCenter"})
		PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
		Aha3 = 1
		end
		if Minuta == 0 and AhaGo == 0 then
		TriggerEvent("pNotify:SendNotification", {text = "GO", type = "info", timeout = 1000, layout = "bottomCenter"})
		PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
		AhaGo = 1
		FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
		isRacing = true
		StartRace(NazivUtrke)
		PocelaUtrka = 1
		TriggerServerEvent("SpremiPocela", PocelaUtrka)
		--StartCountdown()
		Startajj = 0
		end
	end
end)
end

function SpawnajGa(race)
    DoScreenFadeOut(1)

    local raceInfo = Config.RaceInformations[race]
	
	local model = GetHashKey(raceInfo['Vehicle'])

    LoadModel(model)
	TriggerServerEvent("utrke:BucketajGa", true)
	local waitara = math.random(300, 800)
	Wait(waitara)
	if ucitao == 0 then
		Lokacija = 1
		ucitao = 1
		TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
		Rx = raceInfo['StartPosition']['x']
		Ry = raceInfo['StartPosition']['y']
		Rz = raceInfo['StartPosition']['z']
		Rh = raceInfo['StartPosition']['h']
		Rx2 = raceInfo['StartPosition']['x']
		Ry2 = raceInfo['StartPosition']['y']
		Rz2 = raceInfo['StartPosition']['z']
		Rh2 = raceInfo['StartPosition']['h']
		SetEntityCoords(PlayerPedId(), Rx, Ry, Rz, 1, 0, 0, 1)
		Wait(200)
		RaceVehicle = CreateVehicle(model, Rx, Ry, Rz, Rh, true, false)
		SetModelAsNoLongerNeeded(model)
		while not DoesEntityExist(RaceVehicle) do
			Wait(100)
		end
		FreezeEntityPosition(RaceVehicle, true)
		local cordsa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 0.0, -6.0 , 0.0)
		Rx = cordsa.x
		Ry = cordsa.y
		Rz = cordsa.z
		TriggerServerEvent("SpremiKoord", Rx, Ry, Rz, Rh)
		local cordsaa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 4.0, 0.0 , 0.0)
		Rx2 = cordsaa.x
		Ry2 = cordsaa.y
		Rz2 = cordsaa.z
		TriggerServerEvent("SpremiKoord2", Rx2, Ry2, Rz2, Rh2)
	else
		if Lokacija == 0 then
			Lokacija = 1
			TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
			SetEntityCoords(PlayerPedId(), Rx, Ry, Rz, 1, 0, 0, 1)
			Wait(200)
			RaceVehicle = CreateVehicle(model, Rx, Ry, Rz, Rh, true, false)
			SetModelAsNoLongerNeeded(model)
			while not DoesEntityExist(RaceVehicle) do
				Wait(100)
			end
			FreezeEntityPosition(RaceVehicle, true)
			local cordsa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 0.0, -6.0 , 0.0)
			Rx = cordsa.x
			Ry = cordsa.y
			Rz = cordsa.z
			TriggerServerEvent("SpremiKoord", Rx, Ry, Rz, Rh)
			local cordsaa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 4.0, 0.0 , 0.0)
			Rx2 = cordsaa.x
			Ry2 = cordsaa.y
			Rz2 = cordsaa.z
			TriggerServerEvent("SpremiKoord2", Rx2, Ry2, Rz2, Rh2)
		else
			if Prvi == 0 then
				Prvi = 1
				Lokacija = 0
				TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
				SetEntityCoords(PlayerPedId(), Rx2, Ry2, Rz2, 1, 0, 0, 1)
				Wait(200)
				RaceVehicle = CreateVehicle(model, Rx2, Ry2, Rz2, Rh2, true, false)
				SetModelAsNoLongerNeeded(model)
				while not DoesEntityExist(RaceVehicle) do
					Wait(100)
				end
				FreezeEntityPosition(RaceVehicle, true)
				local cordsa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 0.0, -6.0 , 0.0)
				Rx2 = cordsa.x
				Ry2 = cordsa.y
				Rz2 = cordsa.z
				TriggerServerEvent("SpremiKoord2", Rx2, Ry2, Rz2, Rh2)
			else
				Lokacija = 0
				TriggerServerEvent("SpremiPomocne", Lokacija, ucitao, Prvi)
				SetEntityCoords(PlayerPedId(), Rx2, Ry2, Rz2, 1, 0, 0, 1)
				Wait(200)
				RaceVehicle = CreateVehicle(model, Rx2, Ry2, Rz2, Rh2, true, false)
				SetModelAsNoLongerNeeded(model)
				while not DoesEntityExist(RaceVehicle) do
					Wait(100)
				end
				FreezeEntityPosition(RaceVehicle, true)
				local cordsa = GetOffsetFromEntityInWorldCoords(RaceVehicle, 0.0, -6.0 , 0.0)
				Rx2 = cordsa.x
				Ry2 = cordsa.y
				Rz2 = cordsa.z
				TriggerServerEvent("SpremiKoord2", Rx2, Ry2, Rz2, Rh2)
			end
		end
	end
	exports["LegacyFuel2"]:SetFuel(RaceVehicle, 100)
    TaskWarpPedIntoVehicle(PlayerPedId(), RaceVehicle, -1)
	SetVehicleDoorsLocked(RaceVehicle, 4)
    Citizen.Wait(1500)
	SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
	--FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeIn(100)
	--Wait(1000)
	--FreezeEntityPosition(PlayerPedId(), false)
end

function Zaustavi()
	if USudjeluje == 1 then
		isRacing = false
		ZatvoriUI = true
		TriggerEvent("NPC:MakniNPC", 0)
		TriggerEvent("radarce:NemojGa", 0)
		Startajj = 0
		ucitao = 0
		Lokacija = 0
		SendNUIMessage({
			zatvorirace = true
		})
		PrikazoUI = false
		Prvi = 0
		ESX.Game.DeleteVehicle(RaceVehicle)
		TriggerServerEvent("utrke:BucketajGa", false)
		ESX.ShowNotification("Utrka je zavrsila!")
		DeleteCheckpoint(CheckPoint)
		SetPlayerCanDoDriveBy(PlayerId(), true)
		RemoveBlip(Blip)
		USudjeluje = 0
		SetEntityCoords(GetPlayerPed(-1), LastPosX, LastPosY, LastPosZ)
	end
end

RegisterNetEvent("PokreniAUtrku")
AddEventHandler('PokreniAUtrku', function(ime)
    local utrka = ime
	local raceInfo = Config.RaceInformations[utrka]
	if raceInfo ~= nil then
		if PokrenutaUtrka == 0 then
			ucitao = 0
			Lokacija = 0
			Prvi = 0
			PokrenutaUtrka = 1
			NazivUtrke = utrka
			TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Zapocelo je popunjavanje utrke, da se pridruzite upisite /join!', 'CHAR_PLANESITE', 1)
			TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Utrka ce poceti za 60 sekundi!', 'CHAR_PLANESITE', 1)
			Wait(30000)
			if UUtrci < 10 and PokrenutaUtrka == 1 then
				TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'U utrci jos ima mjesta, ukoliko zelite sudjelovati upisite /join!', 'CHAR_PLANESITE', 1)
				TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Utrka ce poceti za 30 sekundi!', 'CHAR_PLANESITE', 1)
			end
		else
			PokrenutaUtrka = 0
			PocelaUtrka = 0
			NazivUtrke = nil
			UUtrci = 0
			Pozicija = 1
			Zaustavi()
			ucitao = 0
			Lokacija = 0
			Prvi = 0
			PokrenutaUtrka = 1
			NazivUtrke = utrka
			TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Zapocelo je popunjavanje utrke, da se pridruzite upisite /join!', 'CHAR_PLANESITE', 1)
			TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Utrka ce poceti za 60 sekundi!', 'CHAR_PLANESITE', 1)
			Wait(30000)
			if UUtrci < 10 and PokrenutaUtrka == 1 then
				TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'U utrci jos ima mjesta, ukoliko zelite sudjelovati upisite /join!', 'CHAR_PLANESITE', 1)
				TriggerEvent('esx:showAdvancedNotification', 'Event System', 'Utrka', 'Utrka ce poceti za 30 sekundi!', 'CHAR_PLANESITE', 1)
			end
		end
	else
		ESX.ShowNotification("Greska sa auto utrkama!")
	end
end)

RegisterNetEvent("Vrime")
AddEventHandler('Vrime', function(vr)
    Minuta = vr
end)

RegisterNetEvent("VratiPermisiju")
AddEventHandler('VratiPermisiju', function(br)
    Permisija = br
end)

RegisterNetEvent("VratiPocela")
AddEventHandler('VratiPocela', function(br)
    PocelaUtrka = br
end)

RegisterNetEvent("ZaustaviUtrku")
AddEventHandler('ZaustaviUtrku', function()
    Zaustavi()
end)

RegisterNetEvent("VratiUtrku")
AddEventHandler('VratiUtrku', function(utr)
    NazivUtrke = utr
end)

RegisterNetEvent("VratiPoziciju")
AddEventHandler('VratiPoziciju', function(br)
    Pozicija = br
end)

RegisterNetEvent("VratiPozicijuCP")
AddEventHandler('VratiPozicijuCP', function(cp, br)
    PozicijaCP[cp] = br
end)

RegisterNetEvent("VratiBroj")
AddEventHandler('VratiBroj', function(br)
    UUtrci = br
end)

RegisterNetEvent("VratiTada")
AddEventHandler('VratiTada', function(br)
    MaxTada = br
end)

RegisterNetEvent("VratiPokret")
AddEventHandler('VratiPokret', function(Pokr)
    PokrenutaUtrka = Pokr
end)

RegisterNetEvent("StartajUtrku")
AddEventHandler('StartajUtrku', function(utr)
    StartCountdown(utr)
end)

RegisterNetEvent("VratiPomocne")
AddEventHandler('VratiPomocne', function(Lok, uci, pr)
    Lokacija = Lok
	ucitao = uci
	Prvi = pr
end)

RegisterNetEvent("VratiKoord")
AddEventHandler('VratiKoord', function(aRx, aRy, aRz, aRh)
    Rx = aRx
	Ry = aRy
	Rz = aRz
	Rh = aRh
end)

RegisterNetEvent("VratiKoord2")
AddEventHandler('VratiKoord2', function(aRx, aRy, aRz, aRh)
    Rx2 = aRx
	Ry2 = aRy
	Rz2 = aRz
	Rh2 = aRh
end)

function OpenRaceMenu(race)
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'racing_menu',
        {
            title    = race,
            align    = 'top-left',
            elements = {
                {label = 'Start Race ( ' .. Config.Price .. ' SEK)', value = 'start'},
                {label = 'Check Scoreboard', value = 'scoreboard'}
            }
        },
        function(data, menu)
            local action = data.current.value

            if action == 'start' then
                if ESX.Game.IsSpawnPointClear(Config.RaceInformations[race]['StartPosition'], 5.0) then
                    ESX.TriggerServerCallback('trke:nemapara', function(hasEnough)
                        if hasEnough then
                            menu.close()
                            StartCountdown(race)
                        else
                            ESX.ShowNotification("You don't have enough money to race in " .. race)
                        end
                    end, Config.Price)
                else
                    ESX.ShowNotification("It's already someone thats racing!")
                end

            elseif action == 'scoreboard' then
                OpenScoreboard(race)
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

function OpenScoreboard(race)

    local elem = {}

    ESX.TriggerServerCallback('esx-qalle-races:getScoreboard', function(Races)

        for i=1, #Races, 1 do
            table.insert(elem, {label = Races[i].name .. ' ' ..tonumber(string.format("%.2f", Races[i].time)) .. 's'})
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'racing_scoreboard',
            {
                title    = race .. ' Tider',
                align    = 'top-left',
                elements = elem
            },
            function(data, menu)

            end,
        function(data, menu)
            menu.close()
        end)
    end, race)
end

--Counts the Config.checkpoints
function GetMaxCheckPoints(table, race)
    local checkpoints = 0

    for index, values in pairs(table[race]) do
        checkpoints = checkpoints + 1 
    end

    return checkpoints
end

function formatTimer(startTime, currTime)
    local newString = currTime - startTime
    local ms = string.sub(newString, -3, -2)
    local sec = string.sub(newString, -5, -4)
    local mina = string.sub(newString, -7, -6)
	

	newString = string.format("%s%s.%s", mina, sec, ms)
    return newString
end

LoadModel = function(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end
