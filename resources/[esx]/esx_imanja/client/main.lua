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
local Koord = {}
local Imanja = {}
local Kuce = {}
local Kuca = nil
local Blipovi = {}
local brojic = 1
local ButtonsScaleform = nil
Scaleforms    = mLibs:Scaleforms()

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('imanja:DohvatiImanja', function(imanja)
		Imanja = imanja.voc
		Koord = imanja.kor
	end)
	Wait(5000)
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil then
			if Imanja[i].Kuca ~= nil then
				SpawnKucu(Imanja[i])
			end
			if Imanja[i].MKoord ~= "{}" then
				SpawnBlip(Imanja[i].Ime)
			end
		end
	end
end

function SpawnBlip(ime)
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			for j=1, #Blipovi, 1 do
				if Blipovi[j] ~= nil and Blipovi[j].Imanje == ime then
					RemoveBlip(Blipovi[j].Blip)
				end
			end
			if Imanja[i].Vlasnik == nil then
				local VBlip = AddBlipForCoord(Imanja[i].MKoord.x, Imanja[i].MKoord.y, Imanja[i].MKoord.z)
				SetBlipAlpha(VBlip, 255)
				SetBlipSprite(VBlip, 285)
				SetBlipColour (VBlip, 2)
				SetBlipAsShortRange(VBlip, true)
				SetBlipDisplay(VBlip, 2)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Imanje na prodaju')
				EndTextCommandSetBlipName(VBlip)
				table.insert(Blipovi, {Imanje = ime, Blip = VBlip})
				break
			end
		end
	end
end

RegisterNetEvent('imanja:ObrisiBlip')
AddEventHandler('imanja:ObrisiBlip', function(ime)
	for j=1, #Blipovi, 1 do
		if Blipovi[i] ~= nil and Blipovi[i].Imanje == ime then
			RemoveBlip(Blipovi[i].Blip)
		end
	end
end)

function SpawnKucu(data)
	for i=1, #Kuce, 1 do
		if Kuce[i] ~= nil and Kuce[i].Imanje == data.Ime then
			ESX.Game.DeleteObject(Kuce[i].Objekt)
			table.remove(Kuce, i)
			break
		end
	end
	local model = GetHashKey(data.Kuca)
	RequestModel(model)
	Kuca = CreateObject(model, data.KKoord.x, data.KKoord.y, data.KKoord.z, false, false, false)
	table.insert(Kuce, {Imanje = data.Ime, Objekt = Kuca})
	FreezeEntityPosition(Kuca, true)
	SetEntityCoords(Kuca, data.KKoord.x, data.KKoord.y, data.KKoord.z)
	SetEntityHeading(Kuca, data.Heading)
	SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent('imanja:ObrisiKucu')
AddEventHandler('imanja:ObrisiKucu', function(ime)
	for i=1, #Kuce, 1 do
		if Kuce[i] ~= nil and Kuce[i].Imanje == ime then
			ESX.Game.DeleteObject(Kuce[i].Objekt)
			table.remove(Kuce, i)
			break
		end
	end
end)

RegisterNetEvent('imanja:NovaLokacija')
AddEventHandler('imanja:NovaLokacija', function(ime, kord, head)
	for i=1, #Kuce, 1 do
		if Kuce[i] ~= nil and Kuce[i].Imanje == ime then
			SetEntityCoords(Kuce[i].Objekt, kord)
			SetEntityHeading(Kuce[i].Objekt, head)
			break
		end
	end
end)

CreateControls = function(br)
  local controls
  if br == 1 then
	  controls = {
		  [1] = Config.Controls["direction"],
		  [2] = Config.Controls["heading"],
		  [3] = Config.Controls["height"],
		  [4] = Config.Controls["kuce"],
		  [5] = Config.Controls["camera"],
		  [6] = Config.Controls["zoom"],
	  }
  else
	controls = {
		  [1] = Config.Controls["direction"],
		  [2] = Config.Controls["heading"],
		  [3] = Config.Controls["height"],
		  [4] = Config.Controls["camera"],
		  [5] = Config.Controls["zoom"],
	}
  end
  return controls
end

Instructional = {}

Instructional.Init = function()
  local scaleform = Scaleforms.LoadMovie('INSTRUCTIONAL_BUTTONS')

  Scaleforms.PopVoid(scaleform,'CLEAR_ALL')
  Scaleforms.PopInt(scaleform,'SET_CLEAR_SPACE',200) 

  return scaleform
end

Instructional.SetControls = function(scaleform,controls)
  for i=1,#controls,1 do
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(i-1)
    for k=1,#controls[i].codes,1 do
      ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].codes[k], true))
    end
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(controls[i].text)
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()
  end

  Scaleforms.PopVoid(scaleform,'DRAW_INSTRUCTIONAL_BUTTONS')
  --Scaleforms.PopMulti(scaleform,'SET_BACKGROUND_COLOUR',1,1,1,1)
end

Instructional.Create = function(controls)
  local scaleform = Instructional.Init()
  Instructional.SetControls(scaleform,controls)
  return scaleform
end

function OpenImanjeMenu(ime)
    local elements = {}
	local cijena = 0
	ESX.TriggerServerCallback('imanja:JelVlasnik', function(br, cij, vl, kuca, vrata)
		if br and vl then
			if not kuca then
				table.insert(elements, {label = "Izgradi kucu (100000$)", value = 'kuca'})
			else
				table.insert(elements, {label = "Premjesti kucu", value = 'kuca3'})
				table.insert(elements, {label = "Srusi kucu(30000$)", value = 'kuca2'})
			end
			if kuca then
				if not vrata then
					table.insert(elements, {label = "Postavi ulaz u kucu", value = 'ulaz'})
				else
					table.insert(elements, {label = "Uredi ulaz u kucu", value = 'ulaz2'})
				end
			end
			table.insert(elements, {label = "Prodaj drzavi ("..(cij/2).."$)", value = 'prodaj'})
		elseif not br and not vl then
			table.insert(elements, {label = "Kupi za $"..cij, value = 'kupi'})
		else
			table.insert(elements, {label = "Ovo imanje je kupljeno", value = 'error'})
		end
		cijena = cij
	end, ime)
	while #elements == 0 do
		Wait(100)
	end
	brojic = 1
	local pinkcage = nil
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'imanje',
      {
        title    = "Izaberite opciju",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'kuca' then
			menu.close()
			local cord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
			local x,y,z = table.unpack(cord)
			local kord = nil
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Imanje == ime then
					kord = Koord[i].Coord
				end
			end
			local zadnjimax = kord[1]
			local zadnjimin = kord[1]
			for i=1, #kord, 1 do
				if zadnjimax.x < kord[i].x and zadnjimax.y < kord[i].y then
					zadnjimax = kord[i]
				end
				if zadnjimin.x > kord[i].x and zadnjimin.y > kord[i].y then
					zadnjimin = kord[i]
				end
			end
			local a,b,c = zadnjimin.x, zadnjimin.y, z
			local d,e,f = zadnjimax.x, zadnjimax.y, z
			if a < d then
				x = math.random(math.floor(a), math.floor(d))
				if b < e then
					y = math.random(math.floor(b), math.floor(e))
				else
					y = math.random(math.floor(e), math.floor(b))
				end
			else
				x = math.random(math.floor(d), math.floor(a))
				if b < e then
					y = math.random(math.floor(b), math.floor(e))
				else
					y = math.random(math.floor(e), math.floor(b))
				end
			end
			x = x+0.0
			y = y+0.0
			local model = GetHashKey(Config.Kuce[brojic])
			RequestModel(model)
			Kuca = CreateObject(model, x, y, z, false, false, false)
			FreezeEntityPosition(Kuca, true)
			PlaceObjectOnGroundProperly(Kuca)
			FreezeEntityPosition(PlayerPedId(), true)
			SetModelAsNoLongerNeeded(model)
			local controls = CreateControls(1)
			ButtonsScaleform = Instructional.Create(controls)
			local kordac = GetEntityCoords(Kuca)
			Citizen.CreateThread(function()
				local koordic = GetEntityCoords(PlayerPedId())
				pinkcage = PolyZone:Create(kord, {
					name="test",
					debugGrid = true,
					minZ = koordic.z-5.0,
					maxZ = koordic.z+10.0
				})
				while Kuca ~= nil do
					DrawScaleformMovieFullscreen(ButtonsScaleform,255,255,255,255,0)
						if IsControlJustPressed(0, 175) then
							if (brojic+1) <= 15 then
								brojic = brojic+1
								local kordara = GetEntityCoords(Kuca)
								local model = GetHashKey(Config.Kuce[brojic])
								DeleteObject(Kuca)
								RequestModel(model)
								Kuca = CreateObject(model, kordara.x, kordara.y, kordara.z, false, false, false)
								FreezeEntityPosition(Kuca, true)
								Wait(100)
								PlaceObjectOnGroundProperly(Kuca)
								FreezeEntityPosition(PlayerPedId(), true)
								SetModelAsNoLongerNeeded(model)
							end
						end
						if IsControlJustPressed(0, 174) then
							if (brojic-1) >= 1 then
								brojic = brojic-1
								local kordara = GetEntityCoords(Kuca)
								local model = GetHashKey(Config.Kuce[brojic])
								DeleteObject(Kuca)
								RequestModel(model)
								Kuca = CreateObject(model, kordara.x, kordara.y, kordara.z, false, false, false)
								FreezeEntityPosition(Kuca, true)
								Wait(100)
								PlaceObjectOnGroundProperly(Kuca)
								FreezeEntityPosition(PlayerPedId(), true)
								SetModelAsNoLongerNeeded(model)
							end
						end
						if IsControlPressed(0, 172) then
							local korde1 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, 0.01)
							if corde.z < kordac.z+0.5 then
								SetEntityCoords(Kuca, corde)
								--PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 173) then
							local korde1 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, -0.01)
							if corde.z > kordac.z-0.5 then
								SetEntityCoords(Kuca, corde)
								--PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 32) then
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.1, 0.0)
							SetEntityCoords(Kuca, corde)
							PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 33) then
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, -0.1, 0.0)
							SetEntityCoords(Kuca, corde)
							PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 34) then
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.1, 0.0, 0.0)
							SetEntityCoords(Kuca, corde)
							PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 35) then
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, -0.1, 0.0, 0.0)
							SetEntityCoords(Kuca, corde)
							PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 52) then
							local head = GetEntityHeading(Kuca)
							SetEntityHeading(Kuca, head+1.0)
							--PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 51) then
							local head = GetEntityHeading(Kuca)
							SetEntityHeading(Kuca, head-1.0)
							--PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlJustPressed(0, 191) then
							ESX.TriggerServerCallback('imanja:ImalPara', function(imal)
								if imal then
									if pinkcage:isPointInside(GetEntityCoords(Kuca)) then
										pinkcage:destroy()
										FreezeEntityPosition(PlayerPedId(), false)
										local korda = GetEntityCoords(Kuca)
										local heading = GetEntityHeading(Kuca)
										table.insert(Kuce, {Imanje = ime, Objekt = Kuca})
										TriggerServerEvent("imanja:SpremiKucu", ime, korda, heading, Config.Kuce[brojic])
										CurrentAction     = 'menu_imanje'
										CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
										CurrentActionData = {ime = ime}
										Kuca = nil
									else
										ESX.ShowNotification("Kuca nije unutar zelenog podrucja!")
									end
								else
									ESX.ShowNotification("Nemate dovoljno novca!")
									DeleteObject(Kuca)
									pinkcage:destroy()
									Kuca = nil
									CurrentAction     = 'menu_imanje'
									CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
									CurrentActionData = {ime = ime}
								end
							end, 1)
						end
						if IsControlJustPressed(0, 73) then
							FreezeEntityPosition(PlayerPedId(), false)
							DeleteObject(Kuca)
							pinkcage:destroy()
							Kuca = nil
							CurrentAction     = 'menu_imanje'
							CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
							CurrentActionData = {ime = ime}
							break
						end
						Citizen.Wait(1)
				end
			end)
		elseif data.current.value == 'kuca3' then
			menu.close()
			FreezeEntityPosition(PlayerPedId(), true)
			local kord = nil
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Imanje == ime then
					kord = Koord[i].Coord
				end
			end
			for i=1, #Kuce, 1 do
				if Kuce[i] ~= nil and Kuce[i].Imanje == ime then
					Kuca = Kuce[i].Objekt
					break
				end
			end
			local controls = CreateControls(2)
			ButtonsScaleform = Instructional.Create(controls)
			local kordac = GetEntityCoords(Kuca)
			local headic = GetEntityHeading(Kuca)
			Citizen.CreateThread(function()
				local koordic = GetEntityCoords(PlayerPedId())
				pinkcage = PolyZone:Create(kord, {
					name="test",
					debugGrid = true,
					minZ = koordic.z-5.0,
					maxZ = koordic.z+10.0
				})
				while Kuca ~= nil do
					DrawScaleformMovieFullscreen(ButtonsScaleform,255,255,255,255,0)
					if IsControlPressed(0, 172) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, 0.01)
						if corde.z < kordac.z+0.5 then
							SetEntityCoords(Kuca, corde)
							--PlaceObjectOnGroundProperly(Kuca)
						end
					end
					if IsControlPressed(0, 173) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, -0.01)
						if corde.z > kordac.z-0.5 then
							SetEntityCoords(Kuca, corde)
							--PlaceObjectOnGroundProperly(Kuca)
						end
					end
					if IsControlPressed(0, 32) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.1, 0.0)
						SetEntityCoords(Kuca, corde)
						PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlPressed(0, 33) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, -0.1, 0.0)
						SetEntityCoords(Kuca, corde)
						PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlPressed(0, 34) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.1, 0.0, 0.0)
						SetEntityCoords(Kuca, corde)
						PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlPressed(0, 35) then
						local corde = GetOffsetFromEntityInWorldCoords(Kuca, -0.1, 0.0, 0.0)
						SetEntityCoords(Kuca, corde)
						PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlPressed(0, 52) then
						local head = GetEntityHeading(Kuca)
						SetEntityHeading(Kuca, head+1.0)
						--PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlPressed(0, 51) then
						local head = GetEntityHeading(Kuca)
						SetEntityHeading(Kuca, head-1.0)
						--PlaceObjectOnGroundProperly(Kuca)
					end
					if IsControlJustPressed(0, 191) then
						if pinkcage:isPointInside(GetEntityCoords(Kuca)) then
							pinkcage:destroy()
							FreezeEntityPosition(PlayerPedId(), false)
							local korda = GetEntityCoords(Kuca)
							local heading = GetEntityHeading(Kuca)
							TriggerServerEvent("imanja:UrediKucu", ime, korda, heading)
							CurrentAction     = 'menu_imanje'
							CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
							CurrentActionData = {ime = ime}
							break
						else
							ESX.ShowNotification("Kuca nije unutar zelenog podrucja!")
						end
					end
					if IsControlJustPressed(0, 73) then
						pinkcage:destroy()
						FreezeEntityPosition(PlayerPedId(), false)
						SetEntityCoords(Kuca, kordac)
						SetEntityHeading(Kuca, headic)
						Kuca = nil
						CurrentAction     = 'menu_imanje'
						CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
						CurrentActionData = {ime = ime}
					end
					Citizen.Wait(1)
				end
			end)
		elseif data.current.value == 'prodaj' then
			local elements2 = {
				{label = "Da", value = 'da'},
				{label = "Ne", value = 'ne'}
			}
			ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'imanje2',
			{
				title    = "Zelite li prodati imanje za $"..(cijena/2).."?",
				align    = 'top-left',
				elements = elements2,
			},
			function(data2, menu2)
				if data2.current.value == 'da' then
					menu2.close()
					menu.close()
					TriggerServerEvent("imanja:ProdajImanje", ime)
					CurrentAction     = 'menu_imanje'
					CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
					CurrentActionData = {ime = ime}
				elseif data2.current.value == 'ne' then
					menu2.close()
				end
			end,
			function(data2, menu2)
				menu2.close()
				CurrentAction     = 'menu_imanje'
				CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
				CurrentActionData = {ime = ime}
			end
			)
		elseif data.current.value == 'kuca2' then
			ESX.TriggerServerCallback('imanja:ImalPara', function(imal)
				if imal then
					local elements2 = {
						{label = "Da", value = 'da'},
						{label = "Ne", value = 'ne'}
					}
					ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'imanje2',
					{
						title    = "Zelite li srusiti kucu za $30000?",
						align    = 'top-left',
						elements = elements2,
					},
					function(data2, menu2)
						if data2.current.value == 'da' then
							menu2.close()
							menu.close()
							TriggerServerEvent("imanja:SrusiKucu", ime)
							CurrentAction     = 'menu_imanje'
							CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
							CurrentActionData = {ime = ime}
						elseif data2.current.value == 'ne' then
							menu2.close()
						end
					end,
					function(data2, menu2)
						menu2.close()
						CurrentAction     = 'menu_imanje'
						CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
						CurrentActionData = {ime = ime}
					end
					)
				else
					ESX.ShowNotification("Nemate dovoljno novca!")
				end
			end, 2)
		elseif data.current.value == 'ulaz' then
			menu.close()
			local trazi = true
			ESX.ShowNotification("Prosetajte do ulaza u kucu i pritisnite lijevu tipku misa kako bih ste spremili koordinate!")
			ESX.ShowNotification("Ukoliko ne zelite spremiti koordinate, pritisnite X!")
			Citizen.CreateThread(function()
				while trazi do
					Citizen.Wait(1)
					if IsControlJustPressed(0, 24) then
						local korde = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("imanja:PostaviUlaz", ime, korde)
						trazi = false
						break
					end
					if IsControlPressed(0, 186) then
						trazi = false
						ESX.ShowNotification("Odustali ste od postavljanja ulaza u kucu!")
						break
					end
				end
			end)
		elseif data.current.value == 'ulaz2' then
			menu.close()
			local trazi = true
			ESX.ShowNotification("Prosetajte do ulaza u kucu i pritisnite lijevu tipku misa kako bih ste spremili koordinate!")
			ESX.ShowNotification("Ukoliko ne zelite spremiti koordinate, pritisnite X!")
			Citizen.CreateThread(function()
				while trazi do
					Citizen.Wait(1)
					if IsControlJustPressed(0, 24) then
						local korde = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("imanja:UrediUlaz", ime, korde)
						trazi = false
						CurrentAction     = 'menu_imanje'
						CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
						CurrentActionData = {ime = ime}
						break
					end
					if IsControlPressed(0, 186) then
						trazi = false
						ESX.ShowNotification("Odustali ste od postavljanja ulaza u kucu!")
						CurrentAction     = 'menu_imanje'
						CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
						CurrentActionData = {ime = ime}
						break
					end
				end
			end)
		elseif data.current.value == 'kupi' then
			ESX.TriggerServerCallback('loaf_housing:ImalKucu', function(imal)
				if not imal then
					ESX.TriggerServerCallback('imanja:ImalImanje', function(imal2)
						if not imal2 then
							FreezeEntityPosition(PlayerPedId(), true)
							Citizen.CreateThread(function()
								local kord = nil
								for i=1, #Koord, 1 do
									if Koord[i] ~= nil and Koord[i].Imanje == ime then
										kord = Koord[i].Coord
										break
									end
								end
								local koordic = GetEntityCoords(PlayerPedId())
								pinkcage = PolyZone:Create(kord, {
									name="test",
									debugGrid = true,
									minZ = koordic.z-5.0,
									maxZ = koordic.z+10.0
								})
							end)
							local elements2 = {
								{label = "Da", value = 'da'},
								{label = "Ne", value = 'ne'}
							}
							ESX.UI.Menu.Open(
							  'default', GetCurrentResourceName(), 'imanje2',
							  {
								title    = "Zelite li kupiti imanje za $"..cijena.."?",
								align    = 'top-left',
								elements = elements2,
							  },
							  function(data2, menu2)
								if data2.current.value == 'da' then
									pinkcage:destroy()
									FreezeEntityPosition(PlayerPedId(), false)
									TriggerServerEvent("imanja:Kupi", ime)
									menu2.close()
									menu.close()
									CurrentAction     = 'menu_imanje'
									CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
									CurrentActionData = {ime = ime}
								elseif data2.current.value == 'ne' then
									pinkcage:destroy()
									FreezeEntityPosition(PlayerPedId(), false)
									menu2.close()
									menu.close()
									CurrentAction     = 'menu_imanje'
									CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
									CurrentActionData = {ime = ime}
								end
							  end,
							  function(data2, menu2)
								pinkcage:destroy()
								FreezeEntityPosition(PlayerPedId(), false)
								menu2.close()

								CurrentAction     = 'menu_imanje'
								CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
								CurrentActionData = {ime = ime}
							  end
							)
						else
							ESX.ShowNotification("Vec imate kupljeno imanje!")
						end
					end)
				else
					ESX.ShowNotification("Vec imate kupljenu kucu!")
				end
			end)
        end
      end,
      function(data, menu)
        menu.close()

        CurrentAction     = 'menu_imanje'
		CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
		CurrentActionData = {ime = ime}
      end
    )
end

--[[
X: 0.62 Y: -0.5 Z: 0.2
PX: 0.0 PY: 110.45 PZ: 132.0
Bone: IK_R_Hand Bone final: 6286
]]
local ograda = nil
local ograda2 = nil
local ograda3 = nil
RegisterCommand("testogradu2", function(source, args, raw)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 0.8)
	Ograda(vector3(x,y,z), GetEntityHeading(playerPed))
end)

function Ograda(cord, head)
	local hedara	= nil
	local endara = false
	print(cord.x)
	ESX.Game.SpawnObject('prop_fncwood_08b', {
		x = cord.x,
		y = cord.y,
		z = cord.z
	}, function(obj)
		ograda2 = obj
		SetEntityHeading(obj, head)
		PlaceObjectOnGroundProperly(obj)
		local getara = GetEntityCoords(obj)
		SetEntityCoords(obj, getara.x, getara.y, getara.z-0.1)
		local kord = nil
		local kordara = nil
		local kordara2 = nil
		local moze = true
		while moze do
			Wait(1)
			DisableControlAction(0, 24, true)
			DisableControlAction(2, 37, true)
			--DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 263, true)
			if IsControlJustPressed(0, 174) then
				local head = GetEntityHeading(obj)
				SetEntityHeading(obj, head-1.0)
			end
			if IsControlJustPressed(0, 175) then
				local head = GetEntityHeading(obj)
				SetEntityHeading(obj, head+1.0)
			end
			if IsControlJustPressed(0, 176) then
				kord = GetEntityCoords(obj)
				hedara = GetEntityHeading(obj)
				kordara = GetOffsetFromEntityInWorldCoords(obj, 2.1, 0.0, 0.0)
				kordara2 = kordara
				ESX.Game.DeleteObject(obj)
				ograda2 = nil
				if ograda == nil then
					ESX.Game.SpawnObject('prop_fncwood_14a', {
						x = kord.x,
						y = kord.y,
						z = kord.z
					}, function(obj)
						ograda = obj
						PlaceObjectOnGroundProperly(obj)
						local getara = GetEntityCoords(obj)
						SetEntityCoords(obj, getara.x, getara.y, getara.z-0.1)
					end)
				end
				if ograda2 == nil then
					ESX.Game.SpawnObject('prop_fncwood_14a', {
						x = kordara.x,
						y = kordara.y,
						z = kordara.z
					}, function(obj)
						ograda2 = obj
						PlaceObjectOnGroundProperly(obj)
						local getara = GetEntityCoords(obj)
						SetEntityCoords(obj, getara.x, getara.y, getara.z-0.1)
					end)
				end
				moze = false
			end
			if IsControlJustPressed(0, 73) then
				ESX.Game.DeleteObject(obj)
				ograda2 = nil
				endara = true
				moze = false
			end
		end
		if not endara then
			moze = true
			while moze do
				Wait(1)
				DisableControlAction(0, 24, true)
				DisableControlAction(2, 37, true)
				--DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
				DisableControlAction(0, 106, true)
				DisableControlAction(0, 167, true)
				DisableControlAction(0, 45, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 263, true)
				if kord ~= nil and ograda ~= nil then
					DrawMarker(0, kord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
					if #(GetEntityCoords(PlayerPedId())-kord) <= 1.0 then
						RequestAnimDict("melee@small_wpn@streamed_core")
						while not HasAnimDictLoaded("melee@small_wpn@streamed_core") do
							Citizen.Wait(100)
						end
						local moze2 = true
						local proso = true
						local br = 0
						while moze2 do
							Wait(1)
							DisableControlAction(0, 24, true)
							DisableControlAction(2, 37, true)
							--DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
							DisableControlAction(0, 106, true)
							DisableControlAction(0, 167, true)
							DisableControlAction(0, 45, true)
							DisableControlAction(0, 140, true)
							DisableControlAction(0, 263, true)
							if IsDisabledControlJustPressed(0, 24) and proso then
								proso = false
								TaskPlayAnim(PlayerPedId(),"melee@small_wpn@streamed_core","car_down_attack", 8.0, -8, -1, 2, 0, 0, 0, 0)
								Wait(400)
								local corda = GetEntityCoords(ograda)
								SetEntityCoords(ograda, corda.x, corda.y, corda.z-0.02)
								Wait(300)
								proso = true
								br = br+1
								if br == 10 then
									moze2 = false
									kord = nil
								end
							end
						end
						ClearPedTasksImmediately(PlayerPedId())
						RemoveAnimDict("melee@small_wpn@streamed_core")
					end
				end
				if kordara ~= nil and ograda2 ~= nil then
					DrawMarker(0, kordara, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
					if #(GetEntityCoords(PlayerPedId())-kordara) <= 1.0 then
						RequestAnimDict("melee@small_wpn@streamed_core")
						while not HasAnimDictLoaded("melee@small_wpn@streamed_core") do
							Citizen.Wait(100)
						end
						local moze2 = true
						local proso = true
						local br = 0
						while moze2 do
							Wait(1)
							DisableControlAction(0, 24, true)
							DisableControlAction(2, 37, true)
							--DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
							DisableControlAction(0, 106, true)
							DisableControlAction(0, 167, true)
							DisableControlAction(0, 45, true)
							DisableControlAction(0, 140, true)
							DisableControlAction(0, 263, true)
							if IsDisabledControlJustPressed(0, 24) and proso then
								proso = false
								TaskPlayAnim(PlayerPedId(),"melee@small_wpn@streamed_core","car_down_attack", 8.0, -8, -1, 2, 0, 0, 0, 0)
								Wait(400)
								local corda = GetEntityCoords(ograda2)
								SetEntityCoords(ograda2, corda.x, corda.y, corda.z-0.02)
								Wait(300)
								proso = true
								br = br+1
								if br == 10 then
									moze2 = false
									kordara = nil
								end
							end
						end
						ClearPedTasksImmediately(PlayerPedId())
						RemoveAnimDict("melee@small_wpn@streamed_core")
					end
				end
				if kord == nil and kordara == nil then
					ESX.Game.DeleteObject(ograda)
					ograda = nil
					ESX.Game.DeleteObject(ograda2)
					ograda2 = nil
					ESX.Game.SpawnObject('prop_fncwood_08b', {
						x = cord.x,
						y = cord.y,
						z = cord.z
					}, function(obj)
						PlaceObjectOnGroundProperly(obj)
						local getara = GetEntityCoords(obj)
						SetEntityCoords(obj, getara.x, getara.y, getara.z-0.5)
						ograda = obj
						SetEntityHeading(obj, hedara)
					end)
					moze = false
				end
			end
			while ograda == nil do
				Wait(1)
			end
			local kordo = GetOffsetFromEntityInWorldCoords(ograda, 2.1, 0.0, 0.0)
			Ograda(kordo, GetEntityHeading(ograda))
			ograda = nil
		end
	end)
end

RegisterCommand("obrisiogradu", function(source, args, raw)
	ESX.Game.DeleteObject(ograda)
	ESX.Game.DeleteObject(ograda2)
	ESX.Game.DeleteObject(ograda3)
end)

RegisterCommand("testpoly", function(source, args, raw)
	local trazi = true
	local br = 0
	local tablica = {}
	local markeri = {}
	ESX.ShowNotification("Pritisnite E da spremite marker.")
	ESX.ShowNotification("Pritisnite enter da zavrsite pravljenje.")
	ESX.ShowNotification("Pritisnite X da odustanete.")
	while trazi do
		Citizen.Wait(1)
		if IsControlJustPressed(0, 38) then
			local korde = GetEntityCoords(PlayerPedId())
			local vek = vector2(korde.x, korde.y)
			print(vek)
			table.insert(tablica, vek)
			table.insert(markeri, korde)
		end
		for i=1, #markeri, 1 do
			DrawMarker(0, markeri[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if IsControlPressed(0, 186) then
			trazi = false
			tablica = {}
			ESX.ShowNotification("Odustali ste od postavljanja!")
		end
		if IsControlPressed(0, 191) then
			trazi = false
			ESX.ShowNotification("Zavrsili ste pravljenje!")
		end
	end
	if #tablica > 0 then
		ESX.ShowNotification("Pritisnite enter da zavrsite pregled.")
		local koordic = GetEntityCoords(PlayerPedId())
		local pinkcage = PolyZone:Create(tablica, {
			name="test",
			debugGrid = true,
			minZ = koordic.z-5.0,
			maxZ = koordic.z+10.0
			--minZ = 53.744148254395,
			--maxZ = 54.037460327148
		})
		local lcord = GetEntityCoords(PlayerPedId())
		pinkcage:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
			if isPointInside then
				print("uso")
				lcord = GetEntityCoords(PlayerPedId())
			else
				print("izaso")
				SetEntityCoords(PlayerPedId(), lcord)
			end
		end)
		Wait(1000)
		local gledaj = true
		while gledaj do
			Citizen.Wait(1)
			if IsControlPressed(0, 18) then
				gledaj = false
				pinkcage:destroy()
				ESX.ShowNotification("Zavrsili ste pregled!")
			end
		end
	end
end)

RegisterCommand("urediimanje", function(source, args, raw)
	local elements = {}
	
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil then
			table.insert(elements, {label = Imanja[i].Ime, value = Imanja[i].Ime})
		end
	end
	
	table.insert(elements, {label = "Kreiraj imanje", value = "nova"})

    ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'uimanj',
		{
			title    = "Izaberite imanje",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if data.current.value == "nova" then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cijena', {
					title = "Upisite cijenu imanja",
				}, function (datari, menuri)
					local mCijena = datari.value
												
					if mCijena == nil or tonumber(mCijena) < 0 then
						ESX.ShowNotification('Greska.')
					else
						menuri.close()
						menu.close()
						local korda = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("imanja:NapraviImanje", mCijena, korda)
					end
				end, function (datari, menuri)
					menuri.close()
				end)
			else
				local ime = data.current.value
				elements = {}
				table.insert(elements, {label = "Premjesti marker", value = "mkoord"})
				table.insert(elements, {label = "Postavi koord", value = "koord1"})
				table.insert(elements, {label = "Postavi max koord", value = "koord2"})
				table.insert(elements, {label = "Makni vlasnika", value = "vlasnik"})
				table.insert(elements, {label = "Obrisi kucu", value = "obrisik"})
				table.insert(elements, {label = "Obrisi imanje", value = "obrisi"})
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'uimanj2',
					{
						title    = "Izaberite opciju",
						align    = 'top-left',
						elements = elements,
					},
					function(data2, menu2)
						if data2.current.value == "mkoord" then
							local koord = GetEntityCoords(PlayerPedId())
							TriggerServerEvent("imanja:PremjestiMarker", ime, koord)
						elseif data2.current.value == "koord1" then
							Wait(1000)
							local trazi = true
							local br = 0
							local tablica = {}
							local markeri = {}
							ESX.ShowNotification("Pritisnite E da spremite marker.")
							ESX.ShowNotification("Pritisnite enter da zavrsite pravljenje.")
							ESX.ShowNotification("Pritisnite X da odustanete.")
							while trazi do
								Citizen.Wait(1)
								if IsControlJustPressed(0, 38) then
									local korde = GetEntityCoords(PlayerPedId())
									local vek = vector2(korde.x, korde.y)
									print(vek)
									table.insert(tablica, vek)
									table.insert(markeri, korde)
								end
								for i=1, #markeri, 1 do
									DrawMarker(0, markeri[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
								end
								if IsControlPressed(0, 186) then
									trazi = false
									tablica = {}
									ESX.ShowNotification("Odustali ste od postavljanja!")
								end
								if IsControlPressed(0, 191) then
									trazi = false
									ESX.ShowNotification("Zavrsili ste pravljenje!")
								end
							end
							if #tablica > 0 then
								ESX.ShowNotification("Pritisnite enter da zavrsite pregled.")
								local koordic = GetEntityCoords(PlayerPedId())
								local pinkcage = PolyZone:Create(tablica, {
									name="test",
									debugGrid = true,
									minZ = koordic.z-5.0,
									maxZ = koordic.z+10.0
									--minZ = 53.744148254395,
									--maxZ = 54.037460327148
								})
								local lcord = GetEntityCoords(PlayerPedId())
								pinkcage:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
									if isPointInside then
										print("uso")
										lcord = GetEntityCoords(PlayerPedId())
									else
										print("izaso")
										SetEntityCoords(PlayerPedId(), lcord)
									end
								end)
								Wait(1000)
								local gledaj = true
								while gledaj do
									Citizen.Wait(1)
									if IsControlPressed(0, 18) then
										gledaj = false
										pinkcage:destroy()
										ESX.ShowNotification("Zavrsili ste pregled i spremili koordinate!")
										TriggerServerEvent("imanja:SpremiCoord", ime, tablica, 1)
									end
								end
							end
						elseif data2.current.value == "koord2" then
							local coord = GetEntityCoords(PlayerPedId())
							TriggerServerEvent("imanja:SpremiCoord", ime, coord, 2)
						elseif data2.current.value == "vlasnik" then
							TriggerServerEvent("imanja:MakniVlasnika", ime)
						elseif data2.current.value == "obrisik" then
							TriggerServerEvent("imanja:ObrisiKucu", ime)
						elseif data2.current.value == "obrisi" then
							elements = {}
							
							table.insert(elements, {label = "Da", value = "da"})
							table.insert(elements, {label = "Ne", value = "ne"})

							ESX.UI.Menu.Open(
							  'default', GetCurrentResourceName(), 'zelisli',
							  {
								title    = "Zelite li obrisati imanje?",
								align    = 'top-left',
								elements = elements,
							  },
							  function(datalr, menulr)
								if datalr.current.value == "da" then
									menulr.close()
									menu2.close()
									menu.close()
									TriggerServerEvent("imanja:ObrisiImanje", ime)
								else
									menulr.close()
								end
							  end,
							  function(datalr, menulr)
								menulr.close()
							  end
							)
						end
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
end, false)

RegisterCommand("napraviimanje", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] then
				local korda = GetEntityCoords(PlayerPedId())
				TriggerServerCallback("imanja:NapraviImanje", args[1], korda)
			else
				TriggerClientEvent('esx:showNotification', source, '/napraviimanje [Cijena]')
			end
		end
	end)
end, false)

RegisterCommand("postavikoord", function(source, args, raw)
	if args[1] and args[2] then
		local Postoji = 0
		for i=1, #Imanja, 1 do
			if Imanja[i] ~= nil and Imanja[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 and (tonumber(args[2]) > 0 and tonumber(args[2]) < 3) then
			local coord = GetEntityCoords(PlayerPedId())
			TriggerServerEvent("imanja:SpremiCoord", args[1], coord, tonumber(args[2]))
		else
			ESX.ShowNotification("Imanje ne postoji")
		end
	else
		ESX.ShowNotification("/postavikoord [Ime imanja][1 - x1,y1 | 2 - x2,y2]")
	end
end, false)

RegisterCommand("debug", function(source, args, raw)
	if Kuca ~= nil then
		DeleteObject(Kuca)
		Kuca = nil
	end
end, false)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('imanja:hasEnteredMarker', function(station, part, partNum)
  if part == 'Imanje' then
    CurrentAction     = 'menu_imanje'
    CurrentActionMsg  = "Pritisnite E da vidite opcije imanja"
    CurrentActionData = {ime = partNum}
  end
end)

AddEventHandler('imanja:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('imanja:RefreshBlip')
AddEventHandler('imanja:RefreshBlip', function(ime)
	SpawnBlip(ime)
end)

RegisterNetEvent('imanja:UpdateKoord')
AddEventHandler('imanja:UpdateKoord', function(koor)
	Koord = koor
end)

RegisterNetEvent('imanja:UpdateImanja')
AddEventHandler('imanja:UpdateImanja', function(njiv)
	Imanja = njiv
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil then
			if Imanja[i].Kuca ~= nil then
				SpawnKucu(Imanja[i])
			end
			if Imanja[i].MKoord ~= "{}" then
				SpawnBlip(Imanja[i].Ime)
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		
		if CurrentAction ~= nil then
			naso = 1
			waitara = 1
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then
				if CurrentAction == 'menu_imanje' then
					OpenImanjeMenu(CurrentActionData.ime)
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
		
		for i=1, #Imanja, 1 do
			if Imanja[i] ~= nil and Imanja[i].MKoord ~= "{}" then
				if #(coords-Imanja[i].MKoord) < 100.0 then
					waitara = 1
					naso = 1
					DrawMarker(0, Imanja[i].MKoord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
				end
				if #(coords-Imanja[i].MKoord) < 3.0 then
					waitara = 1
					naso = 1
					isInMarker     = true
					currentStation = 1
					currentPart    = 'Imanje'
					currentPartNum = Imanja[i].Ime
				end
			end
		end
		
		--[[for i=1, #Koord, 1 do
			if Koord[i] ~= nil then
				local x,y,z = table.unpack(Koord[i].Coord)
				if Koord[i].Coord2 ~= nil then
					local x2,y2,z2 = table.unpack(Koord[i].Coord2)
					if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
						if IsEntityInArea(PlayerPedId(), x, y, z, x2, y2, z2, false, false, 0) then
							naso = 1
							waitara = 1
							isInMarker     = true
							currentStation = 1
							currentPart    = 'Imanje'
							currentPartNum = Koord[i].Imanje
						end
					end
				end
			end
		end]]
		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('imanja:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('imanja:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('imanja:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)
