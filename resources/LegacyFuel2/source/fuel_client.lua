local Pumpe = {}
if Config.UseESX then
	ESX = nil

	Citizen.CreateThread(function()
		while not ESX do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(100)
		end
		Wait(5000)
		ESX.TriggerServerCallback('pumpe:DohvatiPumpe', function(pumpe)
			Pumpe = pumpe
		end)
	end)
end

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local GUI                       = {}
GUI.Time                        = 0
local BlizuPumpe 				= nil
local ZadnjeGorivo 				= 0.0
local NemaStruje 				= false

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle))
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end
	local limitic = 0
	local model = GetEntityModel(vehicle)
	local klasa = GetVehicleClass(vehicle)
	if IsThisModelABike(model) or IsThisModelAQuadbike(model) then
		limitic = Config.Classes[8]
	else
		limitic = Config.Classes[klasa]
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (limitic or 1.0) / 10)
	end
end

RegisterNetEvent('elektricar:NemaStruje')
AddEventHandler('elektricar:NemaStruje', function(br)
	NemaStruje = br
end)

RegisterCommand("uredipumpe", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			ESX.UI.Menu.CloseAll()
			local elements = {
				{label = "Lista pumpi", value = "lpumpi"},
				{label = "Dodaj pumpu", value = "npumpa"}
			}

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'upumpe',
				{
					title    = "Izaberite opciju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "npumpa" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ipumpe', {
							title = "Upisite cijenu pumpe",
						}, function (datari, menuri)
							local cPumpe = datari.value
							if cPumpe == nil then
								ESX.ShowNotification('Greska.')
							else
								local coords = GetEntityCoords(PlayerPedId())
								TriggerServerEvent("pumpe:DodajPumpu", coords, cPumpe)
								menuri.close()
								menu.close()
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					elseif data.current.value == "lpumpi" then
						local elements = {}
						for i=1, #Pumpe, 1 do
							if Pumpe[i] ~= nil then
								table.insert(elements, {label = Pumpe[i].Ime, value = Pumpe[i].Ime})
							end
						end
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'lpumpe',
							{
								title    = "Izaberite pumpu",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								local elements = {
									{label = "Portaj se do pumpe", value = "port"},
									{label = "Premjesti pumpu", value = "premj"},
									{label = "Promjeni cijenu", value = "vrij"},
									{label = "Promjeni kolicinu goriva", value = "gvrij"},
									{label = "Postavi koordinate dostave goriva", value = "kdostava"},
									{label = "Makni vlasnika", value = "vlasn"},
									{label = "Obrisi pumpu", value = "brisi"}
								}
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'lpumpe2',
									{
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									},
									function(data3, menu3)
										if data3.current.value == "premj" then
											local korda = GetEntityCoords(PlayerPedId())
											TriggerServerEvent("pumpe:Premjesti", data2.current.value, korda)
											menu3.close()
											ESX.ShowNotification("Premjestili ste pumpu "..data2.current.value)
										elseif data3.current.value == "brisi" then
											TriggerServerEvent("pumpe:Obrisi", data2.current.value)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Obrisali ste pumpu "..data2.current.value)
										elseif data3.current.value == "port" then
											menu3.close()
											menu2.close()
											for i=1, #Pumpe, 1 do
												if Pumpe[i] ~= nil and Pumpe[i].Koord ~= nil then
													if Pumpe[i].Ime == data2.current.value then
														SetEntityCoords(PlayerPedId(), Pumpe[i].Koord)
													end
												end
											end
											ESX.ShowNotification("Portali ste se do pumpe "..data2.current.value)
										elseif data3.current.value == "vlasn" then
											TriggerServerEvent("pumpe:MakniVlasnika", data2.current.value)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Maknuli ste vlasnika za pumpu "..data2.current.value)
										elseif data3.current.value == "kdostava" then
											local koord = GetEntityCoords(PlayerPedId())
											TriggerServerEvent("pumpe:SpremiDostavu", data2.current.value, koord)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Postavili ste koordinate dostave za pumpu "..data2.current.value)
										elseif data3.current.value == "vrij" then
											menu3.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vrpumpe', {
												title = "Upisite cijenu pumpe",
											}, function (datari69, menuri69)
												local cijPumpe = datari69.value
												if cijPumpe == nil or tonumber(cijPumpe) <= 0 then
													ESX.ShowNotification('Greska.')
												else
													TriggerServerEvent("pumpe:UrediCijenu", data2.current.value, cijPumpe)
													ESX.ShowNotification("Promjenili ste cijenu pumpe "..data2.current.value.." na $"..cijPumpe)
													menuri69.close()
												end
											end, function (datari69, menuri69)
												menuri69.close()
											end)
										elseif data3.current.value == "gvrij" then
											menu3.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vrpumpe2', {
												title = "Upisite kolicinu goriva (npr. 500)",
											}, function (datari69, menuri69)
												local kolGoriva = datari69.value
												if kolGoriva == nil or tonumber(kolGoriva) <= 0 then
													ESX.ShowNotification('Greska.')
												else
													TriggerServerEvent("pumpe:UrediKolicinu", data2.current.value, kolGoriva)
													ESX.ShowNotification("Promjenili ste kolicinu goriva pumpe "..data2.current.value.." na "..kolGoriva.." litara")
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
					end
				end,
				function(data, menu)
					menu.close()
				end
			)
		end
	end)
end, false)

-- Display markers
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

      if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_pumpa' then
          OpenPumpaMenu(CurrentActionData.ime)
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
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Koord ~= nil then
			local kordara = Pumpe[i].Koord
			if (kordara.x ~= 0 and kordara.x ~= nil) and (kordara.y ~= 0 and kordara.y ~= nil) and (kordara.z ~= 0 and kordara.z ~= nil) then
				if #(coords-kordara) < 50.0 then
					waitara = 0
					naso = 1
					DrawMarker(1, kordara.x, kordara.y, kordara.z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					Draw3DText(kordara.x, kordara.y, kordara.z-1.800, Pumpe[i].Ime, 4, 0.1, 0.1)
					if not Pumpe[i].Vlasnik then
						Draw3DText( kordara.x, kordara.y, kordara.z  -2.000, "Benzinska pumpa na prodaju!", 4, 0.1, 0.1)
						Draw3DText( kordara.x, kordara.y, kordara.z  -2.200, Pumpe[i].Cijena.."$", 4, 0.1, 0.1)
					else
						Draw3DText( kordara.x, kordara.y, kordara.z  -2.000, "Vlasnik: "..Pumpe[i].VlasnikIme, 4, 0.1, 0.1)
						Draw3DText( kordara.x, kordara.y, kordara.z  -2.200, "Cijena goriva: $"..Pumpe[i].GCijena, 4, 0.1, 0.1)
						Draw3DText( kordara.x, kordara.y, kordara.z  -2.400, "Kolicina goriva: "..Pumpe[i].Gorivo.." litara", 4, 0.1, 0.1)
					end
				end
				if #(coords-kordara) < 1.5 then
					isInMarker     = true
					currentStation = Pumpe[i].Ime
					currentPart    = 'Pumpa'
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
			TriggerEvent('pumpe:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation             = currentStation
		LastPart                = currentPart
		LastPartNum             = currentPartNum

		TriggerEvent('pumpe:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	end

	if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		waitara = 0
		naso = 1
		HasAlreadyEnteredMarker = false

		TriggerEvent('pumpe:hasExitedMarker', LastStation, LastPart, LastPartNum)
	end
	if naso == 0 then
		waitara = 500
	end
  end
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

AddEventHandler('pumpe:hasEnteredMarker', function(station, part, partNum)
  if part == 'Pumpa' then
    CurrentAction     = 'menu_pumpa'
    CurrentActionMsg  = "Pritisnite E da otvorite menu!"
    CurrentActionData = { ime = station }
  end
end)

AddEventHandler('pumpe:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

function OpenPumpaMenu(ime)
  local elements = {}
  ESX.UI.Menu.CloseAll()
  
  local Kupljen = false
  local Kapacitet = false
  local Cijena = 0
  local Gorivo = 0
  for i=1, #Pumpe, 1 do
	if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
		Cijena = Pumpe[i].Cijena
		Gorivo = Pumpe[i].Gorivo
		if Pumpe[i].Vlasnik ~= nil then
			Kupljen = true
		end
		if Pumpe[i].Kapacitet == true then
			Kapacitet = true
		end
		break
	end
  end
  local mere = false
  local racunica = 0
  if Kupljen == true then
	ESX.TriggerServerCallback('pumpe:JelVlasnik', function(vlasnik)
		if vlasnik then
			local brojcic = 500
			if Kapacitet then
				brojcic = 1000
			end
			racunica = math.ceil((brojcic-tonumber(Gorivo))*1.2)
			table.insert(elements, {label = "Stanje sefa", value = 'stanje'})
			table.insert(elements, {label = "Uzmi iz sefa", value = 'sef'})
			table.insert(elements, {label = "Ostavi u sef", value = 'sef2'})
			if racunica > 0 then
				table.insert(elements, {label = "Naruci gorivo ($"..racunica..")", value = 'naruci'})
			end
			table.insert(elements, {label = "Promjeni cijenu goriva", value = 'gcij'})
			table.insert(elements, {label = "Promjeni cijenu kanistera", value = 'kcij'})
			if not Kapacitet then
				table.insert(elements, {label = "Povecaj kapacitet pumpe", value = 'kkap'})
			end
			table.insert(elements, {label = "Prodaj firmu igracu", value = 'prodaj2'})
			table.insert(elements, {label = "Prodaj firmu", value = 'prodaj'})
		else
			table.insert(elements, {label = "Ova firma nije tvoja!", value = 'error'})
		end
		mere = true
	end, ime)
  else
	table.insert(elements, {label = "Kupite benzinsku pumpu za $"..Cijena, value = 'kupi'})
	mere = true
  end
	while not mere do
		Wait(100)
	end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pumpa',
      {
        title    = "Benzinska pumpa",
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      if data.current.value == 'stanje' then
		TriggerServerEvent("pumpe:DajStanje", ime)
      end
	  
	  if data.current.value == 'naruci' then
		TriggerServerEvent("pumpe:NapraviNarudzbu", ime, racunica)
      end

      if data.current.value == 'sef' then
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'pumpa_daj_lovu',
			{
				title = "Unesite koliko novca zelite podici"
			},
			function(data3, menu3)

			local count = tonumber(data3.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu3.close()
				TriggerServerEvent("pumpe:UzmiIzSefa", ime, count)
			end
			end,
			function(data3, menu3)
				menu3.close()
			end
		)
      end
	  
	  if data.current.value == 'sef2' then
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'pumpa_ostav_lovu',
			{
				title = "Unesite koliko novca zelite ostaviti"
			},
			function(data3, menu3)

			local count = tonumber(data3.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu3.close()
				TriggerServerEvent("pumpe:OstaviUSef", ime, count)
			end
			end,
			function(data3, menu3)
				menu3.close()
			end
		)
      end
	  
	  if data.current.value == 'gcij' then
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'pumpa_stavi_gcijenu',
			{
				title = "Unesite koju cijenu goriva zelite (npr. 3.5)"
			},
			function(data3, menu3)
			local count = tonumber(data3.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu3.close()
				TriggerServerEvent("pumpe:PostaviCijenu", 1, ime, count)
			end
			end,
			function(data3, menu3)
				menu3.close()
			end
		)
      end
	  
	  if data.current.value == 'kcij' then
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'pumpa_daj_lovu',
			{
				title = "Unesite koju cijenu kanistera zelite (npr. 270)"
			},
			function(data3, menu3)

			local count = tonumber(data3.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu3.close()
				TriggerServerEvent("pumpe:PostaviCijenu", 2, ime, count)
			end
			end,
			function(data3, menu3)
				menu3.close()
			end
		)
      end
	  
	  if data.current.value == "error" then
		
	  end
	  
	  if data.current.value == "kkap" then
			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'pumpa',
			  {
				title    = "Zelite li povecati kapacitet na 1000 litara?",
				align    = 'top-left',
				elements = {
					{label = "Da (100000$)", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
			  },

			 function(data69, menu69)

			  menu69.close()

			  if data69.current.value == 'da' then
				TriggerServerEvent("pumpe:PovecajKapacitet", ime)
			  end

			  if data69.current.value == 'ne' then
				menu69.close()
			  end
			end,
			function(data69, menu69)
			  menu69.close()
			end
		  )
	  end
	  
	  if data.current.value == "kupi" then
			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'pumpa',
			  {
				title    = "Zelite li kupiti benzinsku pumpu za $"..Cijena,
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
			  },

			 function(data69, menu69)

			  menu69.close()

			  if data69.current.value == 'da' then
				TriggerServerEvent("pumpe:KupiPumpu", ime)
			  end

			  if data69.current.value == 'ne' then
				menu69.close()
			  end
			end,
			function(data69, menu69)
			  menu69.close()
			end
		  )
	  end
	  
	  if data.current.value == "prodaj2" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance ~= -1 and distance <= 3.0 then
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'pumpa_prodaj_igr',
				{
					title = "Unesite cijenu za koju zelite prodati pumpu"
				},
				function(data3, menu3)

				local count = tonumber(data3.value)

				if count == nil then
					ESX.ShowNotification("Kriva vrijednost!")
				else
					menu3.close()
					menu.close()
					TriggerServerEvent("pumpe:ProdajIgracu", ime, GetPlayerServerId(player), count)
				end
				end,
				function(data3, menu3)
					menu3.close()
					menu.close()
				end
			)
		else
			ESX.ShowNotification('Nema igraca u blizini!')
		end
	  end
	  
	  if data.current.value == "prodaj" then
			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'pumpa',
			  {
				title    = "Zelite li prodati benzinsku pumpu za $"..math.floor(Cijena/2),
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
			  },

			 function(data69, menu69)

			  menu69.close()

			  if data69.current.value == 'da' then
				TriggerServerEvent("pumpe:ProdajPumpu", ime)
			  end

			  if data69.current.value == 'ne' then
				menu69.close()
			  end
			end,
			function(data69, menu69)
			  menu69.close()
			end
		  )
	  end
	  
      CurrentAction     = 'menu_pumpa'
      CurrentActionMsg  = "Pritisnite E da otvorite menu!"
	  CurrentActionData = { ime = ime }

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_pumpa'
      CurrentActionMsg  = "Pritisnite E da otvorite menu!"
	  CurrentActionData = { ime = ime }
    end
  )

end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for i = 1, #Config.Blacklist do
		if type(Config.Blacklist[i]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[i])] = true
		else
			Config.Blacklist[Config.Blacklist[i]] = true
		end
	end

	for i = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, i)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local blizu = false
	local pumpObject = 0
	local pumpDistance = 1000
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil then
			if #(coords-Pumpe[i].Koord) <= 50.0 then
				blizu = true
				BlizuPumpe = Pumpe[i].Ime
			end
		end
	end
	if blizu then
		local fuelPumps = {}
		local handle, object = FindFirstObject()
		local success

		repeat
			if Config.PumpModels[GetEntityModel(object)] then
				table.insert(fuelPumps, object)
			end

			success, object = FindNextObject(handle, object)
		until not success

		EndFindObject(handle)

		for k,v in pairs(fuelPumps) do
			local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(v))

			if dstcheck < pumpDistance then
				pumpDistance = dstcheck
				pumpObject = v
			end
		end
	end
	return pumpObject, pumpDistance
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject
			if Config.UseESX then
				currentCash = ESX.GetPlayerData().money
			end
		else
			if isNearPump then
				BlizuPumpe = nil
			end
			isNearPump = false
			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

RegisterNetEvent('pumpe:SaljiPumpe')
AddEventHandler('pumpe:SaljiPumpe', function(pumpe) 
	Pumpe = pumpe
end)

RegisterNetEvent('pumpe:PitajProdaju')
AddEventHandler('pumpe:PitajProdaju', function(ime, cijena, pid)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'pumpara',
		{
				title    = "Zelite li kupiti benzinsku pumpu "..ime.." za $"..cijena.."?",
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
		},
		function(data69, menu69)
			menu69.close()
			if data69.current.value == 'da' then
				TriggerServerEvent("pumpe:PrihvatioProdaju", ime, cijena, pid)
			end

			if data69.current.value == 'ne' then
				ESX.ShowNotification("Odbili ste ponudu za kupnju pumpe!")
				TriggerServerEvent("pumpe:OdbioProdaju", pid)
				menu69.close()
			end
		end,
		function(data69, menu69)
			 menu69.close()
		end
	)
end)

RegisterNetEvent('EoSvimaGorivo')
AddEventHandler('EoSvimaGorivo', function(nid, gor) 
	if NetworkDoesNetworkIdExist(nid) then
		local retval = NetworkGetEntityFromNetworkId(nid)
		if DoesEntityExist(retval) then
			SetVehicleFuelLevel(retval, gor + 0.0)
			DecorSetFloat(retval, Config.FuelDecor, GetVehicleFuelLevel(retval))
		end
	end
end)

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)
	ZadnjeGorivo = currentFuel
	local UkupnoGoriva = 0
	local cijena = 0
	local gorivo = 0
	local ImalVlasnika = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil then
			if Pumpe[i].Ime == BlizuPumpe then
				cijena = Pumpe[i].GCijena
				gorivo = Pumpe[i].Gorivo
				if Pumpe[i].Vlasnik ~= nil then
					ImalVlasnika = true
				end
				break
			end
		end
	end
	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd * cijena

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		currentCost = currentCost + extraCost

		if pumpObject then
			if currentCash >= currentCost then
				if tonumber(gorivo) > 0 and tonumber(gorivo) >= tonumber(UkupnoGoriva) then
					SetFuel(vehicle, currentFuel)
					local retval = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("SyncajToGorivo", retval, GetVehicleFuelLevel(vehicle))
					UkupnoGoriva = math.ceil(GetVehicleFuelLevel(vehicle)-ZadnjeGorivo)
				else
					isFueling = false
				end
			else
				isFueling = false
			end
		else
			SetFuel(vehicle, currentFuel)
			local retval = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("SyncajToGorivo", retval, GetVehicleFuelLevel(vehicle))
		end
	end

	if pumpObject then
		TriggerServerEvent('gorivo:foka', currentCost, BlizuPumpe, UkupnoGoriva, ImalVlasnika)
	end

	currentCost = 0.0
	UkupnoGoriva = 0
end)

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		Citizen.Wait(1)

		for k,v in pairs(Config.DisableKeys) do
			DisableControlAction(0, v)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""

			if Config.UseESX then
				extraString = "\n" .. Config.Strings.TotalCost .. ": ~g~$" .. Round(currentCost, 1)
			end

			DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		else
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelFuelingJerryCan .. "\nKanister goriva: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vozilo: " .. Round(currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (pumpObject and isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, Config.Strings.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if GetSelectedPedWeapon(ped) == 883325847 then
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true
									TriggerEvent('fuel:refuelFromPump', false, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								if currentCash > 0 then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.EToRefuel)

									if IsControlJustReleased(0, 38) then
										if not NemaStruje then
											isFueling = true
											TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
											LoadAnimDict("timetable@gardener@filling_can")
										else
											ESX.ShowNotification("Ne mozemo vam naplatiti posto nemamo struje.")
										end
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
								end
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)
					local cijena = 250
					local gorivo = 0
					local ImalVlasnika = false
					for i=1, #Pumpe, 1 do
						if Pumpe[i] ~= nil then
							if Pumpe[i].Ime == BlizuPumpe then
								cijena = Pumpe[i].KCijena
								gorivo = Pumpe[i].Gorivo
								if Pumpe[i].Vlasnik ~= nil then
									ImalVlasnika = true
								end
								break
							end
						end
					end
					if currentCash >= cijena then
						if not HasPedGotWeapon(ped, 883325847) then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, "Pritisnite ~g~E ~w~da kupite kanister goriva za ~g~$" .. cijena)

							if IsControlJustReleased(0, 38) then
								if not NemaStruje then
									if gorivo >= 50 then
										GiveWeaponToPed(ped, 883325847, 4500, false, true)
										
										TriggerServerEvent('gorivo:foka', cijena, BlizuPumpe, 50, ImalVlasnika)

										currentCash = ESX.GetPlayerData().money
									else
										ESX.ShowNotification("Nema dovoljno goriva!")
									end
								else
									ESX.ShowNotification("Nismo u mogucnosti vam prodati gorivo posto nemamo struje!")
								end
							end
						else
							if Config.UseESX then
								local refillCost = Round(Config.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))
								local Racunica = math.ceil((1-GetAmmoInPedWeapon(ped, 883325847) / 4500)*100)
								if refillCost > 0 and Racunica <= gorivo then
									if currentCash >= refillCost then
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.RefillJerryCan .. refillCost)

										if IsControlJustReleased(0, 38) then
											if not NemaStruje then
												TriggerServerEvent('gorivo:foka', refillCost, BlizuPumpe, Racunica, ImalVlasnika)

												SetPedAmmo(ped, 883325847, 4500)
											else
												ESX.ShowNotification("Nismo u mogucnosti vam prodati gorivo posto nemamo struje!")
											end
										end
									else
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCashJerryCan)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanFull)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.RefillJerryCan)

								if IsControlJustReleased(0, 38) then
									SetPedAmmo(ped, 883325847, 4500)
								end
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
					end
				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end
	end
end)

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.9)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Benzinska postaja")
	EndTextCommandSetBlipName(blip)

	return blip
end

if Config.ShowNearestGasStationOnly then
	Citizen.CreateThread(function()
		local currentGasBlip = 0

		while true do
			Citizen.Wait(10000)

			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for i=1, #Pumpe, 1 do
				if Pumpe[i] ~= nil then
					local dstcheck = #(coords-Pumpe[i].Koord)

					if dstcheck < closest then
						closest = dstcheck
						closestCoords = Pumpe[i].Koord
					end
				end
			end
			--[[for k,v in pairs(Config.GasStations) do
				local dstcheck = GetDistanceBetweenCoords(coords, v)

				if dstcheck < closest then
					closest = dstcheck
					closestCoords = v
				end
			end]]

			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end

			currentGasBlip = CreateBlip(closestCoords)
		end
	end)
elseif Config.ShowAllGasStations then
	Citizen.CreateThread(function()
		for k,v in pairs(Config.GasStations) do
			CreateBlip(v)
		end
	end)
end

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

if Config.EnableHUD then
	local function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end

	local mph = 0
	local kmh = 0
	local fuel = 0
	local displayHud = false

	local x = 0.01135
	local y = 0.002

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(50)

			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) and not (Config.RemoveHUDForBlacklistedVehicle and inBlacklisted) then
				local vehicle = GetVehiclePedIsIn(ped)
				local speed = GetEntitySpeed(vehicle)

				mph = tostring(math.ceil(speed * 2.236936))
				kmh = tostring(math.ceil(speed * 3.6))
				fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))

				displayHud = true
			else
				displayHud = false

				Citizen.Wait(500)
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)

			if displayHud then
				DrawAdvancedText(0.130 - x, 0.77 - y, 0.005, 0.0028, 0.6, mph, 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.174 - x, 0.77 - y, 0.005, 0.0028, 0.6, kmh, 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.2195 - x, 0.77 - y, 0.005, 0.0028, 0.6, fuel, 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.148 - x, 0.7765 - y, 0.005, 0.0028, 0.4, "mp/h              km/h              Fuel", 255, 255, 255, 255, 6, 1)
			else
				Citizen.Wait(750)
			end
		end
	end)
end
