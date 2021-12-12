ESX                             = nil

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local Biznisi = {}
local Blipovi = {}

local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local GUI                       = {}
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
	ESX.TriggerServerCallback('biznis:DohvatiBiznise', function(biznis)
		Biznisi = biznis.biz
	end)
	Wait(1000)
	SpawnBlipove()
end)

RegisterCommand("napravibiznis", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil and args[2] ~= nil then
				local ime = args[1]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						break
					end
				end
				if naso == 0 then
					table.remove(args, 1)
					local label = table.concat(args, ' ')
					TriggerServerEvent("biznis:NapraviBiznis", ime, label)
				else
					ESX.ShowNotification("Biznis sa tim imenom vec postoji!")
				end
			else
				ESX.ShowNotification("[System] /napravibiznis [Ime][Label]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("bizniskoord", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil then
				local ime = args[1]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						local koord = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("biznis:PostaviKoord", ime, koord)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /bizniskoord [Ime]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("biznisvlasnik", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil and args[2] ~= nil then
				local ime = args[1]
				local id = args[2]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						TriggerServerEvent("biznis:PostaviVlasnika", ime, id)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /biznisvlasnik [Ime][ID]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("biznisposao", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil and args[2] ~= nil then
				local ime = args[1]
				local posao = args[2]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						TriggerServerEvent("biznis:PostaviPosao", ime, posao)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /biznisposao [Ime][Ime posla]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("obrisibiznis", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil then
				local ime = args[1]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						TriggerServerEvent("biznis:ObrisiBiznis", ime)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /obrisibiznis [Ime]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

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

function SpawnBlipove()
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil then
			local x,y,z = table.unpack(Biznisi[i].Coord)
			if x ~= 0 and x ~= nil then
				Blipovi[Biznisi[i].Ime] = AddBlipForCoord(x,y,z)

				SetBlipSprite (Blipovi[Biznisi[i].Ime], 378)
				SetBlipDisplay(Blipovi[Biznisi[i].Ime], 4)
				SetBlipScale  (Blipovi[Biznisi[i].Ime], 1.2)
				local label = "Nema"
				if Biznisi[i].Kupljen == false then
					SetBlipSprite (Blipovi[Biznisi[i].Ime], 375)
					label = "[Firma] "..Biznisi[i].Label.." na prodaju!"
				else
					SetBlipSprite (Blipovi[Biznisi[i].Ime], 374)
					label = "[Firma] "..Biznisi[i].Label
				end
				SetBlipColour(Blipovi[Biznisi[i].Ime], 3)
				SetBlipAsShortRange(Blipovi[Biznisi[i].Ime], true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(label)
				EndTextCommandSetBlipName(Blipovi[Biznisi[i].Ime])
			end
		end
	end
end

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

      if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_biznis' then
          OpenBiznisMenu(CurrentActionData.ime)
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
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Coord ~= nil then
			local x,y,z = table.unpack(Biznisi[i].Coord)
			if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
				if GetDistanceBetweenCoords(coords, x, y, z, true) < 50.0 then
					waitara = 0
					naso = 1
					DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					Draw3DText( x, y, z  -1.400, Biznisi[i].Label, 4, 0.1, 0.1)
					if not Biznisi[i].Kupljen then
						Draw3DText( x, y, z  -1.600, "Firma na prodaju!", 4, 0.1, 0.1)
					else
						Draw3DText( x, y, z  -1.600, "Vlasnik: "..Biznisi[i].VlasnikIme, 4, 0.1, 0.1)
					end
					Draw3DText( x, y, z  -1.800, "Tjedna zarada: $"..Biznisi[i].Tjedan, 4, 0.1, 0.1)
				end
				if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
					isInMarker     = true
					currentStation = Biznisi[i].Ime
					currentPart    = 'Biznis'
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
			TriggerEvent('biznis:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation             = currentStation
		LastPart                = currentPart
		LastPartNum             = currentPartNum

		TriggerEvent('biznis:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	end

	if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		waitara = 0
		naso = 1
		HasAlreadyEnteredMarker = false

		TriggerEvent('biznis:hasExitedMarker', LastStation, LastPart, LastPartNum)
	end
	if naso == 0 then
		waitara = 500
	end
  end
end)

function OpenBiznisMenu(ime)
  local elements = {}
  ESX.UI.Menu.CloseAll()
  
  local Kupljen = false
  local Posao = nil
  for i=1, #Biznisi, 1 do
	if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
		if Biznisi[i].Kupljen == true then
			Posao = Biznisi[i].Posao
			Kupljen = true
		end
		break
	end
  end
  local mere = false
  if Kupljen == true then
	ESX.TriggerServerCallback('biznis:JelVlasnik', function(vlasnik)
		if vlasnik then
			table.insert(elements, {label = "Stanje sefa", value = 'stanje'})
			table.insert(elements, {label = "Uzmi iz sefa", value = 'sef'})
			table.insert(elements, {label = "Radnici", value = 'radnici'})
		else
			table.insert(elements, {label = "Ovaj biznis nije tvoj!", value = 'error'})
		end
		mere = true
	end, ime)
  else
	table.insert(elements, {label = "Kako kupiti biznis saznajte na nasem discordu", value = 'error'})
	mere = true
  end
	while not mere do
		Wait(100)
	end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'biznis',
      {
        title    = "Biznis",
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      if data.current.value == 'stanje' then
		TriggerServerEvent("biznis:DajStanje", ime)
      end

      if data.current.value == 'sef' then
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'biznis_daj_lovu',
			{
				title = "Unesite koliko novca zelite podici"
			},
			function(data3, menu3)

			local count = tonumber(data3.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu3.close()
				TriggerServerEvent("biznis:UzmiIzSefa", ime, count)
			end
			end,
			function(data3, menu3)
				menu3.close()
			end
		)
      end
	  
	  if data.current.value == 'radnici' then
		ESX.TriggerServerCallback('biznis:DohvatiRadnike', function(radnici)
			local elements = {
				head = { "Ime radnika", "Broj odradjenih tura" },
				rows = {}
			}
			for i=1, #radnici, 1 do
				if radnici[i].Posao == Posao then
					table.insert(elements.rows, {
						data = radnici[i],
						cols = {
							radnici[i].Ime,
							radnici[i].Ture
						}
					})
				end
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'biznis_radnici', elements, function(data2, menu2)

			end, function(data2, menu2)
				menu2.close()
			end)
		end)
      end
	  
	  if data.current.value == "error" then
		ExecuteCommand("discord")
	  end
	  
      CurrentAction     = 'menu_biznis'
      CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
	  CurrentActionData = { ime = ime }

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_biznis'
      CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
	  CurrentActionData = { ime = ime }
    end
  )

end

AddEventHandler('biznis:hasEnteredMarker', function(station, part, partNum)
  if part == 'Biznis' then
    CurrentAction     = 'menu_biznis'
    CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
    CurrentActionData = { ime = station }
  end
end)

AddEventHandler('biznis:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('biznis:KreirajBlip')
AddEventHandler('biznis:KreirajBlip', function(co, biz)
	local x,y,z = table.unpack(co)
	if Blipovi[biz] ~= nil then
		RemoveBlip(Blipovi[biz])
		Blipovi[biz] = nil
	end
	
	if x ~= 0 and x ~= nil then
		Blipovi[biz] = AddBlipForCoord(x,y,z)

		SetBlipSprite (Blipovi[biz], 378)
		SetBlipDisplay(Blipovi[biz], 4)
		SetBlipScale  (Blipovi[biz], 1.2)
		local label = "Nema"
		for j=1, #Biznisi, 1 do
			if Biznisi[j] ~= nil and Biznisi[j].Ime == biz then
				if Biznisi[j].Kupljen == false then
					SetBlipSprite (Blipovi[biz], 375)
					label = "[Firma] "..Biznisi[j].Label.." na prodaju!"
				else
					SetBlipSprite (Blipovi[biz], 374)
					label = "[Firma] "..Biznisi[j].Label
				end
			end
		end
		SetBlipColour(Blipovi[biz], 3)
		SetBlipAsShortRange(Blipovi[biz], true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(label)
		EndTextCommandSetBlipName(Blipovi[biz])
	end
end)

RegisterNetEvent('biznis:UpdateBlip')
AddEventHandler('biznis:UpdateBlip', function(biz)
	local x,y,z = 0,0,0
	for j=1, #Biznisi, 1 do
		if Biznisi[j] ~= nil and Biznisi[j].Ime == biz then
			x,y,z = table.unpack(Biznisi[j].Coord)
		end
	end
	if Blipovi[biz] ~= nil then
		RemoveBlip(Blipovi[biz])
		Blipovi[biz] = nil
	end
	
	if x ~= 0 and x ~= nil then
		Blipovi[biz] = AddBlipForCoord(x,y,z)

		SetBlipSprite (Blipovi[biz], 378)
		SetBlipDisplay(Blipovi[biz], 4)
		SetBlipScale  (Blipovi[biz], 1.2)
		local label = "Nema"
		for j=1, #Biznisi, 1 do
			if Biznisi[j] ~= nil and Biznisi[j].Ime == biz then
				if Biznisi[j].Kupljen == false then
					SetBlipSprite (Blipovi[biz], 375)
					label = "[Firma] "..Biznisi[j].Label.." na prodaju!"
				else
					SetBlipSprite (Blipovi[biz], 374)
					label = "[Firma] "..Biznisi[j].Label
				end
			end
		end
		SetBlipColour(Blipovi[biz], 3)
		SetBlipAsShortRange(Blipovi[biz], true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(label)
		EndTextCommandSetBlipName(Blipovi[biz])
	end
end)

RegisterNetEvent('biznis:UpdateBiznise')
AddEventHandler('biznis:UpdateBiznise', function(biz)
	Biznisi = biz
end)