local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local Zone						= {}
local Mafije 					= {}
local Mere 						= false
local Osvajam 					= 0
local Zauzima					= false
local Boje 						= {}

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  Wait(5000)
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('zone:DohvatiZone', function(data)
		Zone = data.zone
		if not Config.DinamicneMafije then
			Mafije = data.maf
		end
	end)
	if Config.DinamicneMafije then
		ESX.TriggerServerCallback('mafije:DohvatiMafijev3', function(data)
			Mafije = data.maf
			Boje = data.boj
		end)
	end
	Wait(5000)
	SpawnBlipove()
end

if Config.DinamicneMafije then
	RegisterNetEvent('mafije:UpdateMafije')
	AddEventHandler('mafije:UpdateMafije', function(maf)
		Mafije = maf
	end)
	
	RegisterNetEvent('mafije:UpdateBoje')
	AddEventHandler('mafije:UpdateBoje', function(br, maf, boj)
		Boje = boj
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].Vlasnik ~= nil and Zone[i].Vlasnik == maf then
					for a=1, #Boje, 1 do
						if Zone[i].Vlasnik == Boje[a].Mafija and Boje[a].Ime == "Blip" then
							Zone[i].Boja = Boje[a].Boja
							SetBlipColour (Zone[i].ID, Boje[a].Boja)
							TriggerServerEvent("zone:SpremiBoju", Zone[i].Ime, Boje[a].Boja)
							break
						end
					end
				end
			end
		end
	end)
end

function SpawnBlipove()
	while Zone == nil do
		Wait(100)
	end
	local naso = false
	for i=1, #Mafije, 1 do
		if PlayerData.job.name == Mafije[i].Ime and PlayerData.job.name ~= "automafija" then
			naso = true
			break
		end
	end
	if naso then
		Mere = true
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID == nil then
					local a = tonumber(Zone[i].Velicina)+0.0
					local VBlip = AddBlipForArea(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z, a, a)
					SetBlipRotation(VBlip, Zone[i].Rotacija)
					SetBlipColour (VBlip, Zone[i].Boja)
					SetBlipAlpha(VBlip, 115)
					SetBlipAsShortRange(VBlip, true)
					SetBlipDisplay(VBlip, 8)
					Zone[i].ID = VBlip
				end
			end
		end
	end
end

RegisterNetEvent("zone:VratiOsvajanje")
AddEventHandler('zone:VratiOsvajanje', function(br)
	Osvajam = br
end)

RegisterNetEvent("zone:SpawnZonu")
AddEventHandler('zone:SpawnZonu', function(ime, koord, vel, rot)
	table.insert(Zone, {ID = nil, Ime = ime, Koord = koord, Velicina = vel, Rotacija = rot, Boja = 0, Vlasnik = nil, Label = nil, Vrijeme = 0, Vrijednost = 30000})
	if PlayerData.job ~= nil then
		SpawnBlipove()
	end
end)

RegisterNetEvent("zone:DodajMafiju")
AddEventHandler('zone:DodajMafiju', function(ime, boja)
	table.insert(Mafije, {Ime = ime, Boja = boja})
	if PlayerData.job ~= nil then
		if PlayerData.job.name == ime then
			SpawnBlipove()
		end
	end
end)

RegisterNetEvent("zone:SmanjiVrijeme")
AddEventHandler('zone:SmanjiVrijeme', function(ime, vrijeme)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Vrijeme = vrijeme
				break
			end
		end
	end
end)

RegisterNetEvent("zone:UpdateZonu")
AddEventHandler('zone:UpdateZonu', function(ime, koord, rot)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Koord = koord
				Zone[i].Rotacija = rot
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime and PlayerData.job.name ~= "automafija" then
						naso = true
						break
					end
				end
				if naso then
					SetBlipRotation(Zone[i].ID, rot)
					SetBlipCoords(Zone[i].ID, koord.x, koord.y, koord.z)
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:NapadnutaZona")
AddEventHandler('zone:NapadnutaZona', function(ime, br, vr)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				if br then
					SetBlipFlashes(Zone[i].ID, true)
					if Zone[i].Vlasnik == PlayerData.job.name then
						ESX.ShowNotification("[Teritoriji] Vas teritorij je napadnut!")
					end
				else
					SetBlipFlashes(Zone[i].ID, false)
					Zone[i].Vrijeme = vr
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:UpdateBoju")
AddEventHandler('zone:UpdateBoju', function(ime, boja, maf, lab)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Boja = boja
				Zone[i].Vlasnik = maf
				Zone[i].Label = lab
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime and PlayerData.job.name ~= "automafija" then
						naso = true
						break
					end
				end
				if naso then
					SetBlipColour(Zone[i].ID, boja)
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:UpdateVrijednost")
AddEventHandler('zone:UpdateVrijednost', function(ime, br)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Vrijednost = br
				break
			end
		end
	end
end)

RegisterNetEvent("zone:ObrisiZonu")
AddEventHandler('zone:ObrisiZonu', function(ime)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime and PlayerData.job.name ~= "automafija" then
						naso = true
						break
					end
				end
				if naso then
					RemoveBlip(Zone[i].ID)
					Zone[i].ID = nil
				end
				table.remove(Zone, i)
				break
			end
		end
	end
end)

RegisterNetEvent("zone:ObrisiMafiju")
AddEventHandler('zone:ObrisiMafiju', function(ime)
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil then
			if Mafije[i].Ime == ime then
				if PlayerData.job.name == Mafije[i].Ime and PlayerData.job.name ~= "automafija" then
					for a=1, #Zone, 1 do
						if Zone[a] ~= nil then
							RemoveBlip(Zone[a].ID)
							Zone[i].ID = nil
						end
					end
				end
				table.remove(Mafije, i)
				break
			end
		end
	end
end)

RegisterCommand("uredizone", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			ESX.UI.Menu.CloseAll()
			local elements = {
				{label = "Lista zona", value = "lzona"},
				{label = "Dodaj zonu", value = "nzona"},
				{label = "Uredi postavke", value = "postavke"}
			}

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'uzone',
				{
					title    = "Izaberite opciju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "nzona" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vzone', {
							title = "Upisite velicinu zone(npr. 100.0)",
						}, function (datari, menuri)
							local vZone = datari.value
							if vZone == nil then
								ESX.ShowNotification('Greska.')
							else
								local a = tonumber(vZone)+0.0
								local coords = GetEntityCoords(PlayerPedId())
								local retval = GetEntityRotation(PlayerPedId(), 2)
								TriggerServerEvent("zone:DodajZonu", coords, a, Ceil(retval.z))
								menuri.close()
								menu.close()
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					elseif data.current.value == "lzona" then
						local elements = {}
						for i=1, #Zone, 1 do
							if Zone[i] ~= nil then
								table.insert(elements, {label = Zone[i].Ime, value = Zone[i].Ime})
							end
						end
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'lzone',
							{
								title    = "Izaberite zonu",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								local elements = {
									{label = "Premjesti zonu", value = "premj"},
									{label = "Promjeni vrijednost", value = "vrij"},
									{label = "Obrisi zonu", value = "brisi"}
								}
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'lzone2',
									{
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									},
									function(data3, menu3)
										if data3.current.value == "premj" then
											local korda = GetEntityCoords(PlayerPedId())
											local retval = GetEntityRotation(PlayerPedId(), 2)
											TriggerServerEvent("zone:Premjesti", data2.current.value, korda, Ceil(retval.z))
											menu3.close()
											ESX.ShowNotification("Premjestili ste zonu "..data2.current.value)
										elseif data3.current.value == "brisi" then
											TriggerServerEvent("zone:Obrisi", data2.current.value)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Obrisali ste zonu "..data2.current.value)
										else
											menu3.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vrzone', {
												title = "Upisite vrijednost zone u dolarima(npr. 50000)",
											}, function (datari69, menuri69)
												local vrZone = datari69.value
												if vrZone == nil or tonumber(vrZone) <= 0 then
													ESX.ShowNotification('Greska.')
												else
													TriggerServerEvent("zone:UrediVrijednost", data2.current.value, vrZone)
													ESX.ShowNotification("Promjenili ste vrijednost teritorija "..data2.current.value.." na $"..vrZone)
													menuri69.close()
												end
											end, function (datari69, menuri69)
												menuri69.close()
											end)
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
					else
						
						local elements = {}
						if not Config.DinamicneMafije then
							table.insert(elements, {label = "Uredi mafije", value = "maf"})
						end
						table.insert(elements, {label = "Uredi vrijeme do ponovnog osvajanja", value = "vrij"})
						table.insert(elements, {label = "Uredi vrijeme trajanja osvajanja", value = "osvv"})
						table.insert(elements, {label = "Uredi vrijeme dobijanja novca", value = "nvrij"})
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'pzone',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data4, menu4)
								if data4.current.value == "maf" then
									local elements = {
										{label = "Dodaj mafiju", value = "dodaj"},
										{label = "Obrisi mafiju", value = "obr"}
									}
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'pmzone6',
										{
											title    = "Izaberite opciju",
											align    = 'top-left',
											elements = elements,
										},
										function(data7, menu7)
											if data7.current.value == "dodaj" then
												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pmzone', {
													title = "Upisite ime mafije(job_name)",
												}, function (data5, menu5)
													local vIme = data5.value
													if vIme == nil then
														ESX.ShowNotification('Greska.')
													else
														local ime = vIme
														menu5.close()
														ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pmzoneaaa', {
															title = "Upisite ID blip boje",
														}, function (data69, menu69)
															local vBoja = data69.value
															if vBoja == nil or tonumber(vBoja) < 0 then
																ESX.ShowNotification('Greska.')
															else
																TriggerServerEvent("zone:DodajMafiju", ime, tonumber(vBoja))
																menu69.close()
															end
														end, function (data69, menu69)
															menu69.close()
														end)
													end
												end, function (data5, menu5)
													menu5.close()
												end)
											else
												local elements = {}
												for i=1, #Mafije, 1 do
													if Mafije[i] ~= nil then
														table.insert(elements, {label = Mafije[i].Ime, value = Mafije[i].Ime})
													end
												end
												ESX.UI.Menu.Open(
													'default', GetCurrentResourceName(), 'pmzone7',
													{
														title    = "Izaberite mafiju",
														align    = 'top-left',
														elements = elements,
													},
													function(data8, menu8)
														TriggerServerEvent("zone:ObrisiMafiju", data8.current.value)
														ESX.ShowNotification("Obrisali ste mafiju "..data8.current.value)
														menu8.close()
													end,
													function(data8, menu8)
														menu8.close()
													end
												)
											end
										end,
										function(data7, menu7)
											menu7.close()
										end
									)
								elseif data4.current.value == "vrij" then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pvzone', {
										title = "Upisite sate do ponovnog osvajanja",
									}, function (data6, menu6)
										local vBr = data6.value
										if vBr == nil or tonumber(vBr) <= 0 then
											ESX.ShowNotification('Greska.')
										else
											TriggerServerEvent("zone:UrediVrijeme", vBr)
											ESX.ShowNotification("Promjenili ste vrijeme do ponovnog osvajanja na "..vBr.." sati!")
											menu6.close()
										end
									end, function (data6, menu6)
										menu6.close()
									end)
								elseif data4.current.value == "osvv" then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pvrrrzone', {
										title = "Upisite broj minuta potrebnih za osvojit zonu (npr. 10)",
									}, function (data32, menu32)
										local vMinara = data32.value
										if vMinara == nil or tonumber(vMinara) <= 0 then
											ESX.ShowNotification('Greska.')
										else
											TriggerServerEvent("zone:UrediOsvajanje", vMinara)
											ESX.ShowNotification("Promjenili ste vrijeme potrebno za osvojit zonu na "..vMinara.." minuta!")
											menu32.close()
										end
									end, function (data32, menu32)
										menu32.close()
									end)
								elseif data4.current.value == "nvrij" then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pvrzone', {
										title = "Upisite sat kada ce novac dolaziti svaki dan (npr. 14)",
									}, function (data61, menu61)
										local vSat = data61.value
										if vSat == nil or tonumber(vSat) <= 0 or tonumber(vSat) > 23 then
											ESX.ShowNotification('Greska.')
										else
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pvrzone2', {
												title = "Upisite minute kada ce novac dolaziti svaki dan (npr. 45)",
											}, function (data62, menu62)
												local vMin = data62.value
												if vMin == nil or tonumber(vMin) < 0 or tonumber(vMin) > 59 then
													ESX.ShowNotification('Greska.')
												else
													TriggerServerEvent("zone:UrediNovacVrijeme", vSat, vMin)
													ESX.ShowNotification("Promjenili ste vrijeme dolaska novca mafijama na "..vSat.." sati i "..vMin.." minuta!")
													menu62.close()
												end
											end, function (data62, menu62)
												menu62.close()
											end)
											menu61.close()
										end
									end, function (data61, menu61)
										menu61.close()
									end)
								end
							end,
							function(data4, menu4)
								menu4.close()
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	local naso = false
	for i=1, #Mafije, 1 do
		if job.name == Mafije[i].Ime and PlayerData.job.name ~= "automafija" then
			naso = true
			break
		end
	end
	if naso then
		Mere = true
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID == nil then
					local a = tonumber(Zone[i].Velicina)+0.0
					local VBlip = AddBlipForArea(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z, a, a)
					SetBlipRotation(VBlip, Zone[i].Rotacija)
					SetBlipColour (VBlip, Zone[i].Boja)
					SetBlipAlpha(VBlip, 115)
					SetBlipAsShortRange(VBlip, true)
					SetBlipDisplay(VBlip, 8)
					Zone[i].ID = VBlip
				end
			end
		end
	else
		Mere = false
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID ~= nil then
					RemoveBlip(Zone[i].ID)
					Zone[i].ID = nil
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local waitara = 5000
	while true do
		Citizen.Wait(waitara)
		while PlayerData.job == nil do
			Wait(100)
		end
		if Mere then
			waitara = 5000
			for i=1, #Zone, 1 do
				if Zone[i] ~= nil then
					local korda = GetEntityCoords(PlayerPedId())
					if #(korda-Zone[i].Koord) <= tonumber(Zone[i].Velicina) then
						SetBlipDisplay(Zone[i].ID, 8)
					else
						SetBlipDisplay(Zone[i].ID, 3)
					end
				end
			end
		else
			waitara = 10000
		end
	end
end)

AddEventHandler('zone:hasEnteredMarker', function(station, part, partNum)
  if part == 'Zona' then
    CurrentAction     = 'Zona'
    CurrentActionMsg  = "Pritisnite E da zapocnete sa osvajanjem zone"
    CurrentActionData = {zona = partNum}
  end
end)

AddEventHandler('zone:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Display markers
Citizen.CreateThread(function()
  local waitara = 500
  while true do
    Citizen.Wait(waitara)
	local naso = 0
	if PlayerData.job ~= nil and Mere then
		if CurrentAction ~= nil then
		  waitara = 0
		  naso = 1
		  
		  SetTextComponentFormat('STRING')
		  AddTextComponentString(CurrentActionMsg)
		  DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		  if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
			if CurrentAction == 'Zona' then
				local id = CurrentActionData.zona
				ESX.TriggerServerCallback('zone:JelZauzeta', function(br)
					if not br then
						if Zone[id].Vlasnik == nil or Zone[id].Vlasnik ~= PlayerData.job.name then
							if Zone[id].Vrijeme == 0 then
								ESX.TriggerServerCallback('zone:DajOsvajanje', function(br)
									Osvajam = br
								end)
								while Osvajam == 0 do
									Wait(100)
								end
								TriggerServerEvent("zone:ZapocniZauzimanje", Zone[id].Ime)
								Zauzima = true
								ESX.ShowNotification("Zapoceli ste sa zauzimanjem teritorija!")
								Citizen.CreateThread(function ()
									local sec = Osvajam*60
									local br = 0
									while sec > 0 and #(GetEntityCoords(PlayerPedId())-Zone[id].Koord) <= tonumber(Zone[id].Velicina)/2 do
										Citizen.Wait(1000)
										sec = sec-1
										br = br+1
										if br == 60 then
											br = 0
											Osvajam = Osvajam-1
											if Osvajam > 0 then
												ESX.ShowNotification("Do osvajanja vam je preostalo jos "..Osvajam.." minuta!")
											end
										end
									end
									if not IsEntityDead(PlayerPedId()) and #(GetEntityCoords(PlayerPedId())-Zone[id].Koord) <= tonumber(Zone[id].Velicina)/2 then
										local boja = 0
										if not Config.DinamicneMafije then
											for i=1, #Mafije, 1 do
												if PlayerData.job.name == Mafije[i].Ime and PlayerData.job.name ~= "automafija" then
													boja = Mafije[i].Boja
													break
												end
											end
										else
											for i=1, #Mafije, 1 do
												if PlayerData.job.name == Mafije[i].Ime and PlayerData.job.name ~= "automafija" then
													for a=1, #Boje, 1 do
														if Mafije[i].Ime == Boje[a].Mafija and Boje[a].Ime == "Blip" then
															boja = Boje[a].Boja
															break
														end
													end
													break
												end
											end
										end
										Zauzima = false
										TriggerServerEvent("zone:ZavrsiZauzimanje", Zone[id].Ime)
										ESX.ShowNotification("Uspjesno ste osvojili teritorij!")
										TriggerServerEvent("zone:UpdateBoju", Zone[id].Ime, boja, PlayerData.job.name, PlayerData.job.label)
									else
										Zauzima = false
										ESX.ShowNotification("Niste uspjeli osvojiti teritorij!")
										TriggerServerEvent("zone:ZavrsiZauzimanje", Zone[id].Ime)
									end
								end)
							else
								ESX.ShowNotification("Ova zona se ne može zauzimati još "..Zone[id].Vrijeme.." sati!")
							end
						else
							ESX.ShowNotification("Ovo je vasa zona!")
						end
					else
						ESX.ShowNotification("Netko vec zauzima teritorij!")
					end
				end, Zone[id].Ime)
			end
			CurrentAction = nil
			GUI.Time      = GetGameTimer()
		  end

		end

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
		if not Zauzima then
			for i=1, #Zone, 1 do
				if Zone[i] ~= nil then
					if #(coords-Zone[i].Koord) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(31, Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z+0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
						Draw3DText(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z-1.400, "Zona "..i, 4, 0.1, 0.1)
						if Zone[i].Vlasnik == nil then
							Draw3DText(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z-1.600, "Vlasnik teritorija: Nitko", 4, 0.1, 0.1)
						else
							Draw3DText(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z-1.600, "Vlasnik teritorija: "..Zone[i].Label, 4, 0.1, 0.1)
						end
					end
					if #(coords-Zone[i].Koord) < 1.5 then
						isInMarker     = true
						currentStation = 1
						currentPart    = 'Zona'
						currentPartNum = i
					end
				end
			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
			waitara = 0
			naso = 1
			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('zone:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('zone:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('zone:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end

    end
	
	if naso == 0 then
		waitara = 500
	end
  end
end)
