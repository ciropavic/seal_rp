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
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local SpawnajDropMarker 		= false
local DropCoord
local PokupioCrate 				= false
local DostavaBlip 				= nil
local ZatrazioOruzje = {}
local ZOBr = 0
local BVozilo 					= nil
local Mafije = {}
local Rankovi = {}
local Koord = {}
local Vozila = {}
local Oruzja = {}
local Blipovi = {}
local Boje = {}
local SBlipovi = {}
local OruzarnicaMenu = false
local Vratio = nil
local GarazaV 					= nil
local Vblip 					= nil
local KVozilo					= nil
local ProdajeKokain 			= false
local DostavaID 				= 0
local KBlip 					= nil
local Kamioni 					= {}
local Bucketo 					= false
local tObj 						= nil
local tObj2 					= nil
local tObj3 					= nil
local UnutarLabosa 				= false
local JebenaKanta				= nil

--Legala
local posaov = nil
local prikolca = nil
local Blipara = nil
local LokCPa
local LokCPa2
local LokDosa
local IstovarioTo = 0
local OstavioTo = 1
local Vozis = 0
local blipcic = nil

local dostave = 
{
    vector3(-1107.837524414, 4891.6513671875, 214.53938293458),
	vector3(-284.25085449218, 2545.6098632812, 73.252235412598),
	vector3(-1661.032836914, 3120.3474121094, 30.694063186646),
	vector3(2316.876953125, 2520.1318359375, 45.643600463868),
	vector3(748.51580810546, 1301.3503417968, 359.27239990234),
	vector3(1545.7540283204, 1729.2635498046, 109.0136795044)
}

local Kutije = {
	vector3(1088.719, -3096.676, -39.87434),
	vector3(1091.282, -3096.667, -39.87434),
	vector3(1095.059, -3096.656, -39.87434),
	vector3(1097.569, -3096.648, -39.87434),
	vector3(1101.311, -3096.636, -39.87434),
	vector3(1103.781, -3096.629, -39.87434),
	vector3(1103.781, -3096.629, -37.70496),
	vector3(1101.397, -3096.636, -37.70496),
	vector3(1097.665, -3096.648, -37.70496),
	vector3(1095.126, -3096.656, -37.70496),
	vector3(1091.279, -3096.668, -37.70496),
	vector3(1088.781, -3096.676, -37.70496)
}

local Kutijice = {}

local parachute, crate, pickup, blipa, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood05a"} -- parachute, pickup case, plane, pilot, crate

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

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

RegisterNetEvent('mafije:VratiKamione')
AddEventHandler('mafije:VratiKamione', function(kam)
	Kamioni = kam
end)

RegisterNetEvent('mafije:OdradioBucket')
AddEventHandler('mafije:OdradioBucket', function()
	Bucketo = true
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	for i=1, #Kamioni, 1 do
		if Kamioni[i] ~= nil then
			if NetworkDoesEntityExistWithNetworkId(Kamioni[i].NetID) then
				if currentVehicle == NetToVeh(Kamioni[i].NetID) then
					if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "mechanic" then
						ESX.ShowNotification("Ostavite kamion na oznacenu lokaciju kako bih ste prodali kokain!")
						ProdajeKokain = true
						KVozilo = currentVehicle
						tObj = NetToObj(Kamioni[i].Obj1)
						tObj2 = NetToObj(Kamioni[i].Obj2)
						tObj3 = NetToObj(Kamioni[i].Obj3)
						DostavaID = Kamioni[i].Dostava
						if DoesBlipExist(KBlip) then
							RemoveBlip(KBlip)
							KBlip = nil
						end
						KBlip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
						SetBlipSprite(KBlip, 1)
						SetBlipColour (KBlip, 5)
						SetBlipAlpha(KBlip, 255)
						SetBlipRoute(KBlip,  true)
						Citizen.CreateThread(function()
							while ProdajeKokain and KVozilo ~= nil do
								Citizen.Wait(1000)
								if GetVehicleEngineHealth(KVozilo) <= 0 then
									ESX.Game.DeleteVehicle(KVozilo)
									KVozilo = nil
									ProdajeKokain = false
									if DoesBlipExist(KBlip) then
										RemoveBlip(KBlip)
										KBlip = nil
									end
								end
							end
						end)
					end
					break
				end
			end
		end
	end
end)

function DajRutu()
	i = math.random(1, #Config.Markeri)
	Blipara = AddBlipForCoord(Config.Markeri[i].x,  Config.Markeri[i].y,  Config.Markeri[i].z)
	SetBlipSprite (Blipara, 1)
	SetBlipDisplay(Blipara, 8)
	SetBlipColour (Blipara, 2)
	SetBlipScale  (Blipara, 1.4)
	SetBlipRoute  (Blipara, true)
	LokCPa = vector3(Config.Markeri[i].x,  Config.Markeri[i].y,  Config.Markeri[i].z)
	Citizen.CreateThread(function()
		while IstovarioTo == 0 do
			Wait(0)
			--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
			--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			DrawMarker(1, Config.Markeri[i].x,  Config.Markeri[i].y,  Config.Markeri[i].z, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
	end)
end

function OpenPosaoMenu()
    local elements = {}
	table.insert(elements, {label = "Prijevoz pića", value = 'pice'})
	table.insert(elements, {label = "Prijevoz vozila", value = 'vozila'})
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'posao',
      {
        title    = "Izbor poslova",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'pice' then
			if Vozis == 0 then
				local xa, ya, za, ha
				for i=1, #Koord, 1 do
					if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "PosaoSpawn" then
						xa, ya, za, ha = table.unpack(Koord[i].Coord)
					end
				end
				if xa ~= 0 and xa ~= nil then
					ESX.Game.SpawnVehicle("benson",{
						x=xa,
						y=ya,
						z=za											
						},ha, function(callback_vehicle)
						SetVehRadioStation(callback_vehicle, "OFF")
						--TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
						posaov = callback_vehicle
					end)
					DajRutu()
					ESX.ShowNotification("Sjednite u kamion i idite do lokacije oznacene na mapi!")
					menu.close()
					Vozis = 1
				else
					ESX.ShowNotification("Nije vam postavljena koordinata spawna vozila, zovite admina!")
				end
			else
				ESX.ShowNotification("Vec dostavljate to")
			end
        end

        if data.current.value == 'vozila' then
			if Vozis == 0 then
				local xa, ya, za, ha
				for i=1, #Koord, 1 do
					if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "PosaoSpawn" then
						xa, ya, za, ha = table.unpack(Koord[i].Coord)
					end
				end
				if xa ~= 0 and xa ~= nil then
					ESX.Game.SpawnVehicle("packer", {x = xa, y = ya, z = za}, ha, function(vehicle)	
						--TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
						posaov = vehicle
						ESX.Game.SpawnVehicle("TR4", {x = xa, y = ya, z = za}, ha, function(trailer)
							AttachVehicleToTrailer(vehicle, trailer, 1.1)
							prikolca = trailer
						end)
					end)
					Blipara = AddBlipForCoord(-18.065839767456, -1085.4000244141, 26.079084396362)
					SetBlipSprite (Blipara, 1)
					SetBlipDisplay(Blipara, 8)
					SetBlipColour (Blipara, 2)
					SetBlipScale  (Blipara, 1.4)
					SetBlipRoute  (Blipara, true)
					Vozis = 1
					LokCPa2 = vector3(-18.065839767456, -1085.4000244141, 26.079084396362)
					Citizen.CreateThread(function()
						while IstovarioTo == 0 do
							Wait(0)
							--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
							--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
							DrawMarker(1, -18.065839767456, -1085.4000244141, 26.079084396362, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
						end
					end)
				else
					ESX.ShowNotification("Nije vam postavljena koordinata spawna vozila, zovite admina!")
				end
			else
				ESX.ShowNotification("Vec dostavljate to")
			end
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_posao'
        CurrentActionMsg  = "Pritisnite E da otvorite izbornik"
        CurrentActionData = {}
      end
    )
end

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, modelName, netId)
	for i=1, #Kamioni, 1 do
		if Kamioni[i] ~= nil then
			if NetworkDoesEntityExistWithNetworkId(Kamioni[i].NetID) then
				if currentVehicle == NetToVeh(Kamioni[i].NetID) then
					if DoesBlipExist(KBlip) then
						RemoveBlip(KBlip)
						KBlip = nil
					end
					tObj = nil
					tObj2 = nil
					tObj3 = nil
					ProdajeKokain = false
					KVozilo = nil
					DostavaID = 0
					break
				end
			end
		end
	end
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('mafije:DohvatiMafije', function(mafija)
		Mafije = mafija.maf
		Koord = mafija.kor
		Vozila = mafija.voz
		Oruzja = mafija.oruz
		Boje = mafija.boj
		Rankovi = mafija.rank
		Skladiste = mafija.sklad
	end)
	Wait(5000)
	if Config.Blipovi == true then
		SpawnBlipove()
	end
end

function SpawnBlipove()
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Ime == "SpawnV" then
			if Koord[i].Mafija == PlayerData.job.name then
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					Blipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

					SetBlipSprite (Blipovi[Koord[i].Mafija], 378)
					SetBlipDisplay(Blipovi[Koord[i].Mafija], 4)
					SetBlipScale  (Blipovi[Koord[i].Mafija], 1.2)
					for a=1, #Boje, 1 do
						if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
							SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
							break
						end
					end
					SetBlipAsShortRange(Blipovi[Koord[i].Mafija], true)

					BeginTextCommandSetBlipName("STRING")
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == Koord[i].Mafija then
							AddTextComponentString(firstToUpper(Mafije[j].Label))
							break
						end
					end
					--AddTextComponentString(firstToUpper(Koord[i].Mafija))
					EndTextCommandSetBlipName(Blipovi[Koord[i].Mafija])
				end
			end
		end
		if Koord[i] ~= nil and Koord[i].Ime == "Kokain" then
			if Koord[i].Mafija == PlayerData.job.name then
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					local kupljeno = false
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == Koord[i].Mafija then
							if Mafije[j].Skladiste == 1 then
								kupljeno = true
							end
							break
						end
					end
					if kupljeno then
						SBlipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[Koord[i].Mafija], 357)
						SetBlipDisplay(SBlipovi[Koord[i].Mafija], 4)
						SetBlipScale  (SBlipovi[Koord[i].Mafija], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[Koord[i].Mafija], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab")
						EndTextCommandSetBlipName(SBlipovi[Koord[i].Mafija])
					else
						SBlipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[Koord[i].Mafija], 369)
						SetBlipDisplay(SBlipovi[Koord[i].Mafija], 4)
						SetBlipScale  (SBlipovi[Koord[i].Mafija], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[Koord[i].Mafija], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab na prodaju!")
						EndTextCommandSetBlipName(SBlipovi[Koord[i].Mafija])
					end
				end
			end
		end
		if Koord[i] ~= nil and Koord[i].Ime == "Posao" then
			if Koord[i].Mafija == PlayerData.job.name then
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					blipcic = AddBlipForCoord(x,y,z)

					SetBlipSprite (blipcic, 473)
					SetBlipAsShortRange(blipcic, true)
					for a=1, #Boje, 1 do
						if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
							SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
							break
						end
					end
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Dostava pića/vozila")
					EndTextCommandSetBlipName(blipcic)
				end
			end
		end
	end
end

function SpawnBlip()
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Ime == "SpawnV" then
			if DoesBlipExist(Blipovi[Koord[i].Mafija]) then
				RemoveBlip(Blipovi[Koord[i].Mafija])
			end
			if Koord[i].Mafija == PlayerData.job.name then
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					Blipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

					SetBlipSprite (Blipovi[Koord[i].Mafija], 378)
					SetBlipDisplay(Blipovi[Koord[i].Mafija], 4)
					SetBlipScale  (Blipovi[Koord[i].Mafija], 1.2)
					for a=1, #Boje, 1 do
						if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
							SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
							break
						end
					end
					SetBlipAsShortRange(Blipovi[Koord[i].Mafija], true)

					BeginTextCommandSetBlipName("STRING")
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == Koord[i].Mafija then
							AddTextComponentString(firstToUpper(Mafije[j].Label))
							break
						end
					end
					--AddTextComponentString(firstToUpper(Koord[i].Mafija))
					EndTextCommandSetBlipName(Blipovi[Koord[i].Mafija])
				end
			end
		end
		if Koord[i] ~= nil and Koord[i].Ime == "Kokain" then
			if DoesBlipExist(SBlipovi[Koord[i].Mafija]) then
				RemoveBlip(SBlipovi[Koord[i].Mafija])
			end
			if Koord[i].Mafija == PlayerData.job.name then
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					local kupljeno = false
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == Koord[i].Mafija then
							if Mafije[j].Skladiste == 1 then
								kupljeno = true
							end
							break
						end
					end
					if kupljeno then
						SBlipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[Koord[i].Mafija], 357)
						SetBlipDisplay(SBlipovi[Koord[i].Mafija], 4)
						SetBlipScale  (SBlipovi[Koord[i].Mafija], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[Koord[i].Mafija], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab")
						EndTextCommandSetBlipName(SBlipovi[Koord[i].Mafija])
					else
						SBlipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[Koord[i].Mafija], 369)
						SetBlipDisplay(SBlipovi[Koord[i].Mafija], 4)
						SetBlipScale  (SBlipovi[Koord[i].Mafija], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[Koord[i].Mafija], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab na prodaju!")
						EndTextCommandSetBlipName(SBlipovi[Koord[i].Mafija])
					end
				end
			end
		end
		if Koord[i] ~= nil and Koord[i].Ime == "Posao" then
			if Koord[i].Mafija == PlayerData.job.name then
				if DoesBlipExist(blipcic) then
					RemoveBlip(blipcic)
				end
				local x,y,z = table.unpack(Koord[i].Coord)
				if x ~= 0 and x ~= nil then
					blipcic = AddBlipForCoord(x,y,z)

					SetBlipSprite (blipcic, 473)
					SetBlipAsShortRange(blipcic, true)
					for a=1, #Boje, 1 do
						if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
							SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
							break
						end
					end
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Dostava pića/vozila")
					EndTextCommandSetBlipName(blipcic)
				end
			end
		end
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
	windowTint      = 1,
  }
  if GetEntityModel(vehicle) == GetHashKey("R50") then
	props['modFrontBumper'] = 0
	props['modRearBumper'] = 0
	props['modSideSkirt'] = 0
  end
  ESX.Game.SetVehicleProperties(vehicle, props)

end

RegisterNetEvent("mafije:PosaljiObavijest")
AddEventHandler('mafije:PosaljiObavijest', function(posao, odg)
	if PlayerData.job ~= nil then
		if PlayerData.job.name == posao then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 204, 0, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>Obavijest<br> {0}</div>',
				args = { odg }
			})
			if UnutarLabosa then
				for i = 1, #Kutijice, 1 do
					if Kutijice[i] ~= nil then
						DeleteEntity(Kutijice[i])
					end
				end
				Kutijice = {}
				for i=1, #Skladiste, 1 do
					if Skladiste[i] ~= nil and Skladiste[i].Mafija == PlayerData.job.name then
						local brojic = math.floor((Skladiste[i].Kokain/100)+0.5)
						local model = GetHashKey('ex_prop_crate_narc_bc')
						RequestModel(model)
						while not HasModelLoaded(model) do
							Wait(1)
						end
						for i = 1, brojic, 1 do
							if Kutije[i] ~= nil then
								local objikt = CreateObject(model, Kutije[i].x, Kutije[i].y, Kutije[i].z-0.2, false, false, false)
								table.insert(Kutijice, objikt)
							end
						end
						SetModelAsNoLongerNeeded(model)
						break
					end
				end
			end
		end
	end
end)

RegisterNetEvent("esx_mafije:PosaljiMafia")
AddEventHandler('esx_mafije:PosaljiMafia', function(odg, ime, posao)
	if PlayerData.job ~= nil then
		if PlayerData.job.name == posao then
			TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 204, 0, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[F CHAT] {0}:<br> {1}</div>',
						args = { ime, odg }
			})
		end
	end
end)

RegisterCommand("uredimafiju", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			local elements = {}
			
			for i=1, #Mafije, 1 do
				if Mafije[i] ~= nil then
					table.insert(elements, {label = Mafije[i].Label, value = Mafije[i].Ime})
				end
			end
			
			table.insert(elements, {label = "Kreiraj mafiju", value = "novamaf"})

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'umafiju',
				{
					title    = "Izaberite mafiju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "novamaf" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
							title = "Upisite ime mafije",
						}, function (datari, menuri)
							local mIme = datari.value
														
							if mIme == nil then
								ESX.ShowNotification('Greska.')
							else
								menuri.close()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
									title = "Upisite label mafije",
								}, function (datarl, menurl)
									local mLabel = datarl.value
																
									if mLabel == nil then
										ESX.ShowNotification('Greska.')
									else
										menurl.close()
										menu.close()
										TriggerServerEvent("mafije:NapraviMafiju", mIme, mLabel)
									end
								end, function (datarl, menurl)
									menurl.close()
								end)
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					else
						local ImeMafije = data.current.value
						elements = {}
						table.insert(elements, {label = "Rankovi", value = "rankovi"})
						table.insert(elements, {label = "Vozila", value = "vozila"})
						table.insert(elements, {label = "Oruzja", value = "oruzja"})
						table.insert(elements, {label = "Koordinate", value = "koord"})
						table.insert(elements, {label = "Boje", value = "boje"})
						table.insert(elements, {label = "Promjeni ime", value = "ime"})
						table.insert(elements, {label = "Postavke", value = "postavke"})
						table.insert(elements, {label = "Obrisi mafiju", value = "obrisi"})
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'umafiju2',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								if data2.current.value == "rankovi" then
									elements = {}
									
									for i=1, #Rankovi, 1 do
										if Rankovi[i] ~= nil and Rankovi[i].Mafija == ImeMafije then
											table.insert(elements, {label = Rankovi[i].Ime, value = Rankovi[i].ID})
										end
									end
									
									table.insert(elements, {label = "Napravi novi rank", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite rank ID",
											}, function (datar, menur)
												local rID = tonumber(datar.value)
												
												if rID == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite ime ranka",
													}, function (datari, menuri)
														local rIme = datari.value
														
														if rIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
																title = "Upisite label ranka",
															}, function (datarl, menurl)
																local rLabel = datarl.value
																
																if rLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurl.close()
																	TriggerServerEvent("mafije:NapraviRank", ImeMafije, rID, rIme, rLabel)
																end
															end, function (datarl, menurl)
																menurl.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local rankid = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi rank", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi rank',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite ime ranka",
													}, function (datari, menuri)
														local rIme = datari.value
														
														if rIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
																title = "Upisite label ranka",
															}, function (datarl, menurl)
																local rLabel = datarl.value
																
																if rLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurl.close()
																	TriggerServerEvent("mafije:NapraviRank", ImeMafije, rankid, rIme, rLabel)
																end
															end, function (datarl, menurl)
																menurl.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiRank", rankid, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "vozila" then
									elements = {}
									
									for i=1, #Vozila, 1 do
										if Vozila[i].Mafija == ImeMafije then
											table.insert(elements, {label = Vozila[i].Label, value = Vozila[i].Ime})
										end
									end
									
									table.insert(elements, {label = "Dodaj novo vozilo", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite spawn ime vozila",
											}, function (datar, menur)
												local vIme = datar.value
												
												if vIme == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite naziv vozila(label)",
													}, function (datari, menuri)
														local vLabel = datari.value
														
														if vLabel == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															TriggerServerEvent("mafije:DodajVozilo", ImeMafije, vIme, vLabel)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local voziloime = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi vozilo", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi vozilo',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
														title = "Upisite spawn ime vozila",
													}, function (datar, menur)
														local vIme = datar.value
														
														if vIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menur.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
																title = "Upisite naziv vozila(label)",
															}, function (datari, menuri)
																local vLabel = datari.value
																
																if vLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menuri.close()
																	TriggerServerEvent("mafije:DodajVozilo", ImeMafije, vIme, vLabel, voziloime)
																end
															end, function (datari, menuri)
																menuri.close()
															end)
														end
													end, function (datar, menur)
														menur.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiVozilo", voziloime, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "oruzja" then
									elements = {}
									
									for i=1, #Oruzja, 1 do
										if Oruzja[i].Mafija == ImeMafije then
											table.insert(elements, {label = ESX.GetWeaponLabel(Oruzja[i].Ime), value = Oruzja[i].Ime})
										end
									end
									
									table.insert(elements, {label = "Dodaj novo oruzje", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite spawn ime oruzja(weapon_)",
											}, function (datar, menur)
												local orIme = datar.value
												
												if orIme == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite cijenu oruzja",
													}, function (datari, menuri)
														local orCijena = tonumber(datari.value)
														
														if orCijena == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															TriggerServerEvent("mafije:DodajOruzje", ImeMafije, orIme, orCijena)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local oruzjeime = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi oruzje", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi oruzje',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
														title = "Upisite spawn ime oruzja(weapon_)",
													}, function (datar, menur)
														local orIme = datar.value
														
														if orIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menur.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
																title = "Upisite cijenu oruzja",
															}, function (datari, menuri)
																local orCijena = tonumber(datari.value)
																
																if orCijena == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menuri.close()
																	TriggerServerEvent("mafije:DodajOruzje", ImeMafije, orIme, orCijena, oruzjeime)
																end
															end, function (datari, menuri)
																menuri.close()
															end)
														end
													end, function (datar, menur)
														menur.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiOruzje", oruzjeime, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "koord" then
									elements = {}
									
									table.insert(elements, {label = "Postavi koordinate oruzarnice", value = "1"})
									table.insert(elements, {label = "Postavi koordinate lider menua", value = "2"})
									table.insert(elements, {label = "Postavi koordinate spawna vozila(marker)", value = "3"})
									table.insert(elements, {label = "Postavi koordinate brisanja vozila(marker)", value = "4"})
									table.insert(elements, {label = "Postavi koordinate spawna vozila", value = "5"})
									table.insert(elements, {label = "Postavi koordinate crate dropa", value = "6"})
									table.insert(elements, {label = "Postavi koordinate ulaza u kucu", value = "7"})
									table.insert(elements, {label = "Postavi koordinate izlaza iz kuce", value = "8"})
									table.insert(elements, {label = "Postavi koordinate spawna plovila", value = "9"})
									table.insert(elements, {label = "Postavi koordinate brisanja plovila", value = "10"})
									table.insert(elements, {label = "Postavi koordinate labosa za kokain", value = "11"})
									table.insert(elements, {label = "Postavi koordinate spawna kamiona za prodaju", value = "12"})
									for i=1, #Mafije, 1 do
										if Mafije[i] ~= nil and Mafije[i].Ime == ImeMafije then
											if Mafije[i].Posao == 1 then
												table.insert(elements, {label = "Postavi koordinate za uzimanje legalnog posla", value = "13"})
												table.insert(elements, {label = "Postavi koordinate spawna kamiona za legalni posao", value = "14"})
											end
											break
										end
									end

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local mid = datalr.current.value
										local coord = GetEntityCoords(PlayerPedId())
										local head = GetEntityHeading(PlayerPedId())
										TriggerServerEvent("mafije:SpremiCoord", ImeMafije, coord, tonumber(mid), head)
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "boje" then
									elements = {}
									
									table.insert(elements, {label = "Postavi boju vozila", value = "1"})
									if Config.Blipovi == true then
										table.insert(elements, {label = "Postavi boju blipa", value = "2"})
									end

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "1" then
											local br = datalr.current.value
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite R boju (Rgb)",
											}, function (datar, menur)
												local bojR = tonumber(datar.value)
												
												if bojR == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite G boju (rGb)",
													}, function (datari, menuri)
														local bojG = tonumber(datari.value)
														
														if bojG == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankznj', {
																title = "Upisite B boju (rgB)",
															}, function (datarz, menurz)
																local bojB = tonumber(datarz.value)
																
																if bojB == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurz.close()
																	TriggerServerEvent("mafije:DodajBoju", ImeMafije, br, 2, bojR, bojG, bojB)
																end
															end, function (datarz, menurz)
																menurz.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										elseif datalr.current.value == "2" then
											local br = datalr.current.value
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nestatamo', {
												title = "Upisite ID blip boje",
											}, function (datazn, menuzn)
												local bojID = tonumber(datazn.value)
																	
												if bojID == nil then
													ESX.ShowNotification('Greska.')
												else
													menuzn.close()
													TriggerServerEvent("mafije:DodajBoju", ImeMafije, br, bojID)
												end
											end, function (datazn, menuzn)
												menuzn.close()
											end)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "ime" then
									local mafIme
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mafime', {
										title = "Upisite novo ime(setjob) mafije",
									}, function (datar, menur)
										mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'maflabel', {
												title = "Upisite novi label mafije",
											}, function (datal, menul)
												local mafLabel = datar.value
												if mafLabel == nil then
													ESX.ShowNotification('Greska.')
												else
													menul.close()
													menu2.close()
													menu.close()
													TriggerServerEvent("mafije:PromjeniIme", ImeMafije, mafIme, mafLabel)
												end
											end, function (datar, menur)
												menul.close()
											end)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "postavke" then
									elements = {}
									
									table.insert(elements, {label = "Omoguci/onemoguci legalan posao", value = "1"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'legala',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local mid = datalr.current.value
										TriggerServerEvent("mafije:SpremiPostavke", ImeMafije, tonumber(mid))
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "obrisi" then
									elements = {}
									
									table.insert(elements, {label = "Da", value = "da"})
									table.insert(elements, {label = "Ne", value = "ne"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Zelite li obrisati mafiju?",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "da" then
											menulr.close()
											menu2.close()
											menu.close()
											TriggerServerEvent("mafije:ObrisiMafiju", ImeMafije)
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
		end
	end)
end, false)

function OpenSPitajMenu()
	if PlayerData.job.grade_name == "boss" then
		local elements = {
			{label = "Da (500000$)", value = 'da'},
			{label = "Ne", value = 'ne'}
		}

		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'kskl',
		  {
			title    = "Zelite li kupiti skladiste za $500000?",
			align    = 'top-left',
			elements = elements,
		  },
		  function(data, menu)
			if data.current.value == 'da' then
				menu.close()
				ESX.TriggerServerCallback('mafije:KupiSkladiste', function(mozel)
					if mozel then
						ESX.ShowNotification("Kupili ste skladiste za $500000!")
						CurrentAction     = 'menu_ulazk'
						CurrentActionMsg  = "Pritisnite E da udjete u labos"
						CurrentActionData = {}
						
						
					else
						ESX.ShowNotification("Nemate dovoljno novca u sefu mafije!")
					end
				end, PlayerData.job.name)
			end

			if data.current.value == 'ne' then
				menu.close()
				CurrentAction     = 'menu_ulazkupi'
				CurrentActionMsg  = "Pritisnite E da kupite skladiste"
				CurrentActionData = {}
			end
		  end,
		  function(data, menu)

			menu.close()

			CurrentAction     = 'menu_ulazkupi'
			CurrentActionMsg  = "Pritisnite E da kupite skladiste"
			CurrentActionData = {}
		  end
		)
	else
		ESX.ShowNotification("Niste lider!")
	end
end

function OpenNewMenu()

  if Config.EnableArmoryManagement then
	local grado = 0
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
			if Mafije[i].Gradonacelnik == 1 then
				grado = 1
			end
			break
		end
	end
    local elements = {}
	if grado == 0 then
		table.insert(elements, {label = "Kupovina stvari", value = 'buy_stvar'})
	end
	table.insert(elements, {label = 'Oruzarnica',  value = 'buy_oruzje'})


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'buy_stvar' then
          OpenBuyStvarMenu()
        end

        if data.current.value == 'buy_oruzje' then
			OpenArmoryMenu(grado)
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {}
      end
    )
  end

end

function OpenCloakroomMenu()

  local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    {label = _U('mafia_wear'), value = 'mafia_wear'}
  }

  ESX.UI.Menu.CloseAll()

  if Config.EnableNonFreemodePeds then
      table.insert(elements, {label = _U('sheriff_wear'), value = 'sheriff_wear'})
    table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear'})
    table.insert(elements, {label = _U('commandant_wear'), value = 'commandant_wear'})
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      --Taken from SuperCoolNinja
      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end

        end)

      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
			
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'lieutenant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end


      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(br)
	TriggerEvent("esx:ZabraniInv", true)
	OruzarnicaMenu = false
	local g,h=ESX.Game.GetClosestPlayer()
	if g~=-1 and h<=3.0 then 
		TriggerServerEvent("mafije:ImalKoga", GetPlayerServerId(PlayerId()), GetPlayerServerId(g))
		while Vratio == nil do
			Wait(100)
		end
	end
	Vratio = nil
	if OruzarnicaMenu == false then
		local elements = {}
		if PlayerData.job.grade > 0 or br == 1 then
			--table.insert(elements, {label = "Prodaj oruzje", value = 'sell_weapon'})
			table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
		end
		table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
		if PlayerData.job.grade > 0 or br == 1 then
			table.insert(elements, {label = 'Uzmi stvar',  value = 'get_stock'})
		end
		table.insert(elements, {label = 'Ostavi stvar',  value = 'put_stock'})

		if br == 0 then
			if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik' then
				if PlayerData.job.name == Config.Tijelo then
					table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
				end
			end
		else
			table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()
		local armoryime = "armory"..PlayerData.job.name
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), armoryime,
		  {
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements,
		  },
		  function(data, menu)
			if data.current.value == 'sell_weapon' then
			  OpenSellWeaponMenu()
			end

			if data.current.value == 'get_weapon' then
			  OpenGetWeaponMenu()
			end

			if data.current.value == 'put_weapon' then
			  OpenPutWeaponMenu()
			end

			if data.current.value == 'buy_weapons' then
			  OpenBuyWeaponsMenu(br)
			end

			if data.current.value == 'put_stock' then
				  OpenPutStocksMenu()
				end

				if data.current.value == 'get_stock' then
				  OpenGetStocksMenu()
				end

		  end,
		  function(data, menu)
			TriggerEvent("esx:ZabraniInv", false)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {}
		  end
		)
	end
end

function OpenSellWeaponMenu()

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

	for i=1, #Oruzja, 1 do
		if Oruzja[i].Mafija == PlayerData.job.name then
			local weapon = Oruzja[i]
			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.Ime then
					if weapons[i].count > 0 then
						table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, metci = weapons[i].ammo, kolicina = weapons[i].count})
					end
				end
			end
		end
    end
	table.insert(elements, {label = "Zapocni prodaju", value = "sell_pocni"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = "Prodaja oruzja",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		if data.current.value == 'sell_pocni' then
			TriggerEvent("prodajamb:PokreniProdaju", PlayerData.job.name)
		else
			if data.current.kolicina > 1 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kolicina', {
							title = "Kolicina oruzja"
						}, function(data2, menu2)
							local amount = tonumber(data2.value)

							if amount == nil then
								ESX.ShowNotification("Krivi iznos!")
							else
								if amount <= data.current.kolicina then
										menu2.close()
										menu.close()
										ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
											OpenSellWeaponMenu()
										end, data.current.value, 250, amount, PlayerData.job.name)
								else
									menu2.close()
									ESX.ShowNotification("Nema toliko oruzja!")
								end
							end
						end, function(data2, menu2)
							menu2.close()
						end)
			else
				ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
					OpenSellWeaponMenu()
				end, data.current.value, 250, 1, PlayerData.job.name)
			end
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenGarageMenu()
	local x,y,z,he
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil then
			if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "LokVozila" then
				x,y,z,he = table.unpack(Koord[i].Coord)
				break
			end
		end
    end
	if (x == 0 or x == nil) and (y == 0 or y == nil) and (z == 0 or z == nil) then
		ESX.ShowNotification("Vasoj mafiji nije postavljena lokacija spawna vozila, javite se adminu!")
		return
	end
	local co = vector3(x,y,z)
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
 	for _,v in pairs(vehicles) do
		if v.brod == 0 then
			ESX.TriggerServerCallback('pijaca:JelNaProdaju', function(br)
				if not br then
					local hashVehicule = v.model
					local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
					local labelvehicle
					if v.state == 1 then
						labelvehicle = vehicleName..' <font color="green">U garazi</font>'
					elseif v.state == 2 then
						labelvehicle = vehicleName..' <font color="red">Ukradeno</font>'
					elseif v.state == 0 then
						labelvehicle = vehicleName..' <font color="red">Izvan garaze</font>'
					end    
					table.insert(elements, {label =labelvehicle , value = v})
				end
			end)
        end
   	 end
		Wait(500)
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = "Garaza",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if data.current.value.state == 1 then
				menu.close()
				data.current.value.vehicle.model = data.current.value.model
				SpawnVehicle(data.current.value.vehicle, co, he)
			elseif data.current.value.state == 2 then
				exports.pNotify:SendNotification({ text = "Vase vozilo je ukradeno", queue = "right", timeout = 3000, layout = "centerLeft" })
			else
				ESX.UI.Menu.CloseAll()

				local elements2 = {
					{label = "Da $"..Config.Price, value = 'yes'},
					{label = "Ne", value = 'no'},
				}
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'plati_menu',
					{
						title    = "Zelite li platiti vracanje vozila u garazu?",
						align    = 'top-left',
						elements = elements2,
					},
					function(data2, menu2)

						
						if(data2.current.value == 'yes') then
							ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
								if hasEnoughMoney then
									menu2.close()
									TriggerServerEvent('garaza:tuljaniziraj2')
									data.current.value.vehicle.model = data.current.value.model
									SpawnVehicle(data.current.value.vehicle, co, he)
								else
									menu2.close()
									exports.pNotify:SendNotification({ text = "Nemate dovoljno novca", queue = "right", timeout = 3000, layout = "centerLeft" })
								end
							end)
						end
						if(data2.current.value == 'no') then
							menu2.close()
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
			--CurrentAction = 'open_garage_action'
		end
	)	
	end)
end

function SpawnVehicle(vehicle, co, he)
	if GarazaV ~= nil then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
	TriggerServerEvent("mafije:SpawnVozilo", vehicle, co, he)
end

RegisterNetEvent('mafije:VratiVozilo')
AddEventHandler('mafije:VratiVozilo', function(nid, vehicle, co)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	if attempt < 100 then
		local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		while not DoesEntityExist(callback_vehicle) do
			Wait(1)
			callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		end
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	else
		print("Greska prilikom kreiranja vozila. NetID: "..nid)
		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, co)
		local coords = GetEntityCoords(ped)
		local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
		local callback_vehicle = veh
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	end
end)

function reparation(prix,vehicle,vehicleProps)
	
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = _U('reparation_yes', prix), value = 'yes'},
		{label = _U('reparation_no', prix), value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			title    = _U('reparation'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				TriggerServerEvent('garaza:tuljanizirajhealth', prix)
				ranger(vehicle,vehicleProps)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification(_U('reparation_no_notif'))
			end

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end

function ranger(vehicle,vehicleProps)
	ObrisiVozilo(vehicle)

	TriggerServerEvent('eden_garage:modifystate', vehicleProps, 1)
	exports.pNotify:SendNotification({ text = _U('ranger'), queue = "right", timeout = 3000, layout = "centerLeft" })
end

function ObrisiVozilo(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	Wait(100)
	if DoesEntityExist(vehicle) then
		local entity = vehicle
		carModel = GetEntityModel(entity)
		carName = GetDisplayNameFromVehicleModel(carModel)
		NetworkRequestControlOfEntity(entity)
				
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)
				
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
				
		if (DoesEntityExist(entity)) then 
			DeleteEntity(entity)
		end 
	end
end

-- Function that allows player to enter a vehicle
function StockVehicleMenu()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
    	local coords    = GetEntityCoords(playerPed)
    	local vehicle = GetVehiclePedIsIn(playerPed,false)     
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)

		ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
			if (valid) then
				ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicules)
					local plate = vehicleProps.plate:gsub("^%s*(.-)%s*$", "%1")
					local owned = false
					for _,v in pairs(vehicules) do
						if plate == v.plate then
							ESX.TriggerServerCallback('garaza:JelIstiModel2', function(dane)
								if (dane == vehicleProps.model or dane == nil) then
									TriggerServerEvent("garaza:SpremiModel", plate, nil)
									TriggerEvent("esx_property:ProsljediVozilo", nil, nil)
									owned = true
									GarazaV = nil
									Vblip = nil
									if engineHealth < 1000 then
										local fraisRep= math.floor((1000 - engineHealth)*Config.RepairMultiplier)
										reparation(fraisRep,current,vehicleProps)
									else
										ranger(current,vehicleProps)
									end
								else
									--TriggerEvent("playradio", "https://www.youtube.com/watch?v=LIDKQmT0dCs")
									--Wait(10000)
									--TriggerEvent("stopradio")
									--ESX.ShowNotification("Greska: "..vehicleProps.model)
									--ESX.ShowNotification("Greska: "..dane)
									TriggerServerEvent("ac:MjenjanjeModela")
								end
							end, plate)
							break
						end
					end
					if owned == false then
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						BVozilo = nil
					end
				end)
			else
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				BVozilo = nil
			end
		end,vehicleProps)
	else		
		exports.pNotify:SendNotification({ text = _U('stockv_not_in_veh'), queue = "right", timeout = 3000, layout = "centerLeft" })
	end

end

function OpenKokainMenu()
    local elements = {}
	table.insert(elements, {label = "Stanje", value = 'skl_stanje'})
	table.insert(elements, {label = "Ostavi listove", value = 'ost_list'})
	table.insert(elements, {label = "Ostavi kokain", value = 'ost_koka'})
        table.insert(elements, {label = "Uzmi kokain", value = 'uzm_koka'})
	table.insert(elements, {label = 'Prodaj kokain',  value = 'kok_prodaj'})


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'kizb_menu',
      {
        title    = "Izaberite opciju",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'skl_stanje' then
			TriggerServerEvent("mafije:StanjeSkladista", PlayerData.job.name)
        end

        if data.current.value == 'ost_list' then
			OpenKOstaviMenu()
			menu.close()
        end
		
		if data.current.value == 'ost_koka' then
			OpenKOstaviKMenu()
			menu.close()
        end

if data.current.value == 'uzm_koka' then
			OpenKUzmiKMenu()
			menu.close()
        end
		
		if data.current.value == 'kok_prodaj' then
			if not ProdajeKokain then
				for i=1, #Koord, 1 do
					if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name then
						if Koord[i].Ime == "KamionK" then
							local x,y,z,h = table.unpack(Koord[i].Coord)
							if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
								local rand = math.random(100, 300)
								Wait(rand)
								ESX.TriggerServerCallback('mafije:MorelProdaja', function(odg)
									if odg then
										TriggerServerEvent("mafije:BucketajGa", 0)
										while Bucketo == false do
											Wait(100)
										end
										for i = 1, #Kutijice, 1 do
											if Kutijice[i] ~= nil then
												DeleteEntity(Kutijice[i])
											end
										end
										Kutijice = {}
										if JebenaKanta ~= nil then
											DeleteEntity(JebenaKanta)
											JebenaKanta = nil
										end
										local model = GetHashKey("benson")
										RequestModel(model)
										while not HasModelLoaded(model) do
											Wait(1)
										end
										SetEntityCoords(PlayerPedId(), x, y, z)
										KVozilo = CreateVehicle(model, x, y, z, h, true, true)
										SetModelAsNoLongerNeeded(model)
										TaskWarpPedIntoVehicle(PlayerPedId(), KVozilo, -1)
										local prop_name = GetHashKey("ex_prop_crate_closed_bc")
										RequestModel(prop_name)
										while not HasModelLoaded(prop_name) do
											Wait(0)
										end
										local ent = GetEntityBoneIndexByName(KVozilo, "chassis_dummy")
										local playerPed = PlayerPedId()
										local x,y,z = table.unpack(GetEntityCoords(playerPed))
										tObj = CreateObject(prop_name, x, y, z + 0.2, true, true, false)
										AttachEntityToEntity(tObj, KVozilo, ent, -0.03, -0.5, 0.1, 0.0, 0.0, 0.0, 1, 0, 1, 0, 2, 1)
										tObj2 = CreateObject(prop_name, x, y, z + 0.2, true, true, false)
										AttachEntityToEntity(tObj2, KVozilo, ent, -0.03, -2.0, 0.1, 0.0, 0.0, 0.0, 1, 0, 1, 0, 2, 1)
										tObj3 = CreateObject(prop_name, x, y, z + 0.2, true, true, false)
										AttachEntityToEntity(tObj3, KVozilo, ent, -0.03, -3.5, 0.1, 0.0, 0.0, 0.0, 1, 0, 1, 0, 2, 1)
										SetModelAsNoLongerNeeded(prop_name)
										local KVoziloNet = VehToNet(KVozilo)
										local KObj1 = ObjToNet(tObj)
										local KObj2 = ObjToNet(tObj2)
										local KObj3 = ObjToNet(tObj3)
										ESX.ShowNotification("Zapoceli ste prodaju kokaina!")
										ESX.ShowNotification("Odvezite kokain na oznacenu lokaciju kako bi ste ga prodali!")
										ProdajeKokain = true
										DostavaID = math.random(1,#dostave)
										KBlip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
										SetBlipSprite(KBlip, 1)
										SetBlipColour (KBlip, 5)
										SetBlipAlpha(KBlip, 255)
										SetBlipRoute(KBlip,  true)
										TriggerServerEvent("mafije:ProsljediKamion", KVoziloNet, DostavaID, KObj1, KObj2, KObj3)
										Bucketo = false
										Citizen.CreateThread(function()
											while ProdajeKokain and KVozilo ~= nil do
												Citizen.Wait(1000)
												if GetVehicleEngineHealth(KVozilo) <= 0 then
													ESX.Game.DeleteVehicle(KVozilo)
													KVozilo = nil
													ProdajeKokain = false
													if DoesBlipExist(KBlip) then
														RemoveBlip(KBlip)
														KBlip = nil
													end
												end
											end
										end)
									else
										ESX.ShowNotification("[Skladiste] Nemate dovoljno za prodati (min 300kg)")
									end
								end, PlayerData.job.name)
								break
							else
								ESX.ShowNotification("Nisu vam jos postavljene koordinate spawna kamiona, javite se adminima!")
							end
						end
					end
				end
			else
				ESX.ShowNotification("Vec prodajete kokain!")
			end
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenKOstaviMenu()
	ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'kokain_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
            else
				menu2.close()
				TriggerServerEvent('mafije:OstaviListove', count, PlayerData.job.name)
				OpenKokainMenu()
            end
          end,
        function(data2, menu2)
            menu2.close()
        end
    )
end

function OpenKOstaviKMenu()
	ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'kokain2_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
            else
				menu2.close()
				TriggerServerEvent('mafije:OstaviKoku', count, PlayerData.job.name)
				OpenKokainMenu()
            end
          end,
        function(data2, menu2)
            menu2.close()
        end
    )
end

function OpenKUzmiKMenu()
	ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'kokain3_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
            else
				menu2.close()
                                local torba = 0
				TriggerEvent('skinchanger:getSkin', function(skin)
				  torba = skin['bags_1']
				end)
				if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
				   TriggerServerEvent('esx_biser:startHarvestKoda', true)
                                   TriggerServerEvent('mafije:UzmiKoku', count, PlayerData.job.name, true)
				else
			            TriggerServerEvent('mafije:UzmiKoku', count, PlayerData.job.name, false)
				end
				OpenKokainMenu()
            end
          end,
        function(data2, menu2)
            menu2.close()
        end
    )
end

function OpenIzborMenu()
    local elements = {}
	table.insert(elements, {label = "Vozila mafije", value = 'voz_maf'})
	table.insert(elements, {label = 'Osobna vozila',  value = 'voz_oso'})


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'izb_menu',
      {
        title    = "Izbor kategorije vozila",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'voz_maf' then
          OpenVehicleSpawnerMenu()
        end

        if data.current.value == 'voz_oso' then
          OpenGarageMenu()
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenVehicleSpawnerMenu()

	ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Vozila, 1 do
		if Vozila[i].Mafija == PlayerData.job.name then
			table.insert(elements, {label = Vozila[i].Label, value = Vozila[i].Ime})
		end
    end
	
	local x,y,z,h
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil then
			if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "LokVozila" then
				x,y,z,h = table.unpack(Koord[i].Coord)
				break
			end
		end
    end
	if (x == 0 or x == nil) and (y == 0 or y == nil) and (z == 0 or z == nil) then
		ESX.ShowNotification("Vasoj mafiji nije postavljena lokacija spawna vozila, javite se adminu!")
		return
	end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        --local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        --if not DoesEntityExist(vehicle) then

        local playerPed = GetPlayerPed(-1)

		if BVozilo ~= nil then
			ESX.Game.DeleteVehicle(BVozilo)
			BVozilo = nil
		end
		ESX.Streaming.RequestModel(model)
		if IsThisModelABoat(model) or model == "submersible" or model == "submersible2" then
			local x2,y2,z2,h2
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil then
					if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "LokVozila2" then
						x2,y2,z2,h2 = table.unpack(Koord[i].Coord)
						break
					end
				end
			end
			if (x2 == 0 or x2 == nil) and (y2 == 0 or y2 == nil) and (z2 == 0 or z2 == nil) then
				ESX.ShowNotification("Vasoj mafiji nije postavljena lokacija spawna plovila, javite se adminu!")
				return
			end
			BVozilo = CreateVehicle(model, x2, y2, z2, h2, true, false)
		else
			BVozilo = CreateVehicle(model, x,y,z,h, true, false)
		end
        TaskWarpPedIntoVehicle(playerPed,  BVozilo,  -1)
        SetVehicleMaxMods(BVozilo)
		SetEntityAsMissionEntity(BVozilo,true,true)
		SetVehicleHasBeenOwnedByPlayer(BVozilo, true)
		for i=1, #Boje, 1 do
			if Boje[i].Mafija == PlayerData.job.name and Boje[i].Ime == "Vozilo" then
				SetVehicleCustomPrimaryColour(BVozilo, tonumber(Boje[i].R), tonumber(Boje[i].G), tonumber(Boje[i].B))
				SetVehicleCustomSecondaryColour(BVozilo, tonumber(Boje[i].R), tonumber(Boje[i].G), tonumber(Boje[i].B))
				break
			end
		end

        --else
         -- ESX.ShowNotification(_U('vehicle_out'))
        --end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}

      end
    )
end

function OpenMafiaActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mafia_actions',
    {
      title    = firstToUpper(PlayerData.job.name),
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'}
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('mafije:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('mafije:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('mafije:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('mafije:OutVehicle', GetPlayerServerId(player))
              end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
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

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Musko'
        else
          sex = 'Zensko'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Nepoznata'
      end

      if data.height ~= nil then
        heightLabel = 'Visina : ' .. data.height
      else
        heightLabel = 'Visina : Nepoznata'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Nepoznat'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Dozvole ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

        local elements = {
          {label = _U('name') .. data.name, value = nil}
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Dozvole ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = data.novac
	
	if blackMoney > 0 then
		table.insert(elements, {
		  label          = _U('confiscate_dirty') .. blackMoney,
		  value          = 'black_money',
		  itemType       = 'item_account',
		  amount         = blackMoney
		})
	end

    table.insert(elements, {label = '--- Oruzja ---', value = nil})

    for i=1, #data.weapons, 1 do
		if data.weapons[i].name ~= "WEAPON_HEAVYSNIPER" then
			table.insert(elements, {
				label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.weapons[i].ammo,
			})
		end
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})
	local torba = 0
	TriggerEvent('skinchanger:getSkin', function(skin)
		torba = skin['bags_1']
	end)

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
		if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
			table.insert(elements, {
			  label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
			  value          = data.inventory[i].name,
			  itemType       = 'item_standard',
			  amount         = data.inventory[i].count,
			})
		else
			if data.inventory[i].limit ~= -1 and data.inventory[i].count > data.inventory[i].limit then
				table.insert(elements, {
				  label          = _U('confiscate_inv') .. data.inventory[i].limit .. ' ' .. data.inventory[i].label,
				  value          = data.inventory[i].name,
				  itemType       = 'item_standard',
				  amount         = data.inventory[i].limit,
				})
			else
				table.insert(elements, {
				  label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
				  value          = data.inventory[i].name,
				  itemType       = 'item_standard',
				  amount         = data.inventory[i].count,
				})
			end
		end
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then
			local torba = 0
			TriggerEvent('skinchanger:getSkin', function(skin)
				torba = skin['bags_1']
			end)
			local waitara = math.random(200,800)
			Wait(waitara)
			local imalga = false
			if itemType == "item_weapon" then
				imalga = HasPedGotWeapon(PlayerPedId() , itemName, false)
			end
			if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
				TriggerServerEvent('mafije:zapljeni6', GetPlayerServerId(player), itemType, itemName, amount, true, imalga)
			else
				TriggerServerEvent('mafije:zapljeni6', GetPlayerServerId(player), itemType, itemName, amount, false, imalga)
			end
			OpenBodySearchMenu(player)
		end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end


function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('mafije:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, ammo = weapons[i].ammo})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		local imalga = HasPedGotWeapon(PlayerPedId() , data.current.value, false)
		if not imalga then
			if data.current.ammo >= 250 then
				ESX.TriggerServerCallback('mafije:removeArmoryWeapon', function()
					OpenGetWeaponMenu()
				end, data.current.value, 250, PlayerData.job.name)
			else
				ESX.TriggerServerCallback('mafije:removeArmoryWeapon', function()
					OpenGetWeaponMenu()
				end, data.current.value, data.current.ammo, PlayerData.job.name)
			end
		else
			local torba = 0
			TriggerEvent('skinchanger:getSkin', function(skin)
				torba = skin['bags_1']
			end)
			if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
				if data.current.ammo >= 250 then
					ESX.TriggerServerCallback('mafije:dajWeaponItem', function()
						OpenGetWeaponMenu()
					end, data.current.value, 250, PlayerData.job.name)
				else
					ESX.ShowNotification("Nemate 250 metaka da bi uzeli item oruzja!")
				end
			end
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()
  local ammo = 0

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name, metci = ammo})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
		Wait(200)
        OpenPutWeaponMenu()
      end, data.current.value, data.current.metci, PlayerData.job.name)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(br)

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Oruzja, 1 do
		if Oruzja[i].Mafija == PlayerData.job.name then
			local weapon = Oruzja[i]
			local count  = 0

			for j=1, #weapons, 1 do
				if weapons[j].name == weapon.Ime then
				  count = weapons[j].count
				  break
				end
			end

			table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.Ime) .. ' $' .. weapon.Cijena, value = weapon.Ime, price = weapon.Cijena})
		end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if br == 0 then
			if ZatrazioOruzje[10] ~= nil or ZOBr >= 10 then
				ESX.ShowNotification("Vec imate naruceno 10 oruzja!")
			else
				local x,y,z
				for i=1, #Koord, 1 do
					if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "CrateDrop" then
						x,y,z = table.unpack(Koord[i].Coord)
						break
					end
				end
				if x ~= nil then
					ESX.TriggerServerCallback('mafije:piku4', function(hasEnoughMoney)
						if hasEnoughMoney then
							ZatrazioOruzje[ZOBr] = data.current.value
							ZOBr = ZOBr+1
							TriggerServerEvent('mafije:SpremiIme', PlayerData.job.name, ZatrazioOruzje, ZOBr)
							if ZOBr == 1 then
								ESX.ShowNotification("Uzmite Big 4x4(Guardian) i odite na zeleni kofer oznacen na mapi kako bi ste pokupili paket")
								CrateDrop("weapon_pistol", 55, 400.0, {["x"] = x, ["y"] = y, ["z"] = z})
							end
						else
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end, data.current.price, PlayerData.job.name)
				else
					ESX.ShowNotification("Vasoj mafiji jos nisu postavljene koordinate spawna crate dropa, javite adminima!")
				end
			end
		else
			TriggerServerEvent("mafije:DajOruzje", data.current.value, PlayerData.job.name)
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)
    local crateSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z)
	TriggerServerEvent('mafije:SaljiCrate', crateSpawn, PlayerData.job.name)
end

function CrateDrop2(parachute)
    --Citizen.CreateThread(function()
		local model = GetHashKey("prop_box_wood05a")
		RequestModel(model)
		
		while not HasModelLoaded(model) do
			Wait(1)
		end
		crate = CreateObject(model, parachute, false, false, false)
        soundID = GetSoundId()
        PlaySoundFromEntity(soundID, "Crate_Beeps", crate, "MP_CRATE_DROP_SOUNDS", true, 0)
		local x,y,z = table.unpack(parachute)
		blipa = AddBlipForCoord(x,y,z)
        SetBlipSprite(blipa, 408)
        SetBlipNameFromTextFile(blipa, "AMD_BLIPN")
        SetBlipScale(blipa, 0.7)
        SetBlipColour(blipa, 2)
        SetBlipAlpha(blipa, 255)
		
		DropCoord = vector3(GetEntityCoords(crate))
		SpawnajDropMarker = true

        while PokupioCrate == false do
            Wait(0)
        end
		
		local id = GetPlayerServerId(PlayerId())
		TriggerServerEvent('mafije:BrisiCrate', id, PlayerData.job.name)

        if DoesBlipExist(blipa) then
            RemoveBlip(blipa)
        end

        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    --end)
end

RegisterNetEvent('mafije:JelTiOtvoren')
AddEventHandler('mafije:JelTiOtvoren', function(id)
	local armoryime = "armory"..PlayerData.job.name
	local menu = ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), armoryime)
	TriggerServerEvent("mafije:SaljemOtvoren", id, menu)
end)

RegisterNetEvent('mafije:VracamOtvoren')
AddEventHandler('mafije:VracamOtvoren', function(menu)
	Vratio = true
	OruzarnicaMenu = menu
end)

RegisterNetEvent('mafije:VratiCrate')
AddEventHandler('mafije:VratiCrate', function(par, job)
	if PlayerData.job ~= nil and PlayerData.job.name == job then
		parachute = par
		CrateDrop2(parachute)
	end
end)

RegisterNetEvent('mafije:ObrisiCrate')
AddEventHandler('mafije:ObrisiCrate', function(id, job)
	local ida = GetPlayerServerId(PlayerId())
	if ida ~= id then
		if PlayerData.job ~= nil and PlayerData.job.name == job then
			if DoesEntityExist(crate) then
				DeleteEntity(crate)
				StopSound(soundID)
				ReleaseSoundId(soundID)
				SpawnajDropMarker = false
			end
		end
	end
end)

RegisterNetEvent('mafije:ResetOruzja')
AddEventHandler('mafije:ResetOruzja', function(maf)
	if PlayerData.job ~= nil and PlayerData.job.name == maf then
		for i=0, 10, 1 do
			ZatrazioOruzje[i] = nil
		end
		ZOBr = 0
	end
end)

RegisterNetEvent('mafije:VratiIme')
AddEventHandler('mafije:VratiIme', function(maf, ime, br)
	if PlayerData.job ~= nil and PlayerData.job.name == maf then
		ZatrazioOruzje = ime
		ZOBr = br
	end
end)

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('mafije:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = "Uzmi stvari",
		align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
			  local brojic = tonumber(PlayerId())
			  if brojic >= 1 and brojic <= 4 then
				brojic = brojic*100
			  elseif brojic > 4 and brojic < 10 then
				brojic = brojic*50
			  elseif brojic >= 10 and brojic <= 50 then
				brojic = brojic*10
			  elseif brojic > 50 and brojic < 100 then
				brojic = brojic*5
			  end
			  Wait(brojic)
			  local torba = 0
			  TriggerEvent('skinchanger:getSkin', function(skin)
				torba = skin['bags_1']
			  end)
			  if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
				TriggerServerEvent('mafije:getStockItem', itemName, count, PlayerData.job.name, true)
			  else
				TriggerServerEvent('mafije:getStockItem', itemName, count, PlayerData.job.name, false)
			  end
			  OpenGetStocksMenu()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('mafije:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
		align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)
			if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			else
				for i=1, #inventory.items, 1 do

				  local item = inventory.items[i]

				  if itemName == item.name then
					if item.count >= count then
						menu2.close()
						menu.close()
						if string.find(itemName, "weapon") == nil then
							TriggerServerEvent('mafije:putStockItems', itemName, count, PlayerData.job.name)
							Wait(200)
							OpenPutStocksMenu()
						else
							for i=1, count, 1 do
								ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
									Wait(200)
									OpenPutStocksMenu()
								end, itemName, 250, PlayerData.job.name)
							end
							TriggerServerEvent("mafije:makniOruzjeItem", itemName, count)
						end
					else
						ESX.ShowNotification("Nemate toliko "..itemName)
					end
				  end

				end
			end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

local prvispawn = false

AddEventHandler("playerSpawned", function()
	while PlayerData.job == nil do
		Wait(1)
	end
	if not prvispawn then
		ESX.TriggerServerCallback('mafije:DohvatiKutiju', function(br)
			if br ~= nil then
				ZatrazioOruzje = br.Oruzja
				ZOBr = br.Broj
				if br.Pokupljen == false then
					local x,y,z
					for i=1, #Koord, 1 do
						if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "CrateDrop" then
							x,y,z = table.unpack(Koord[i].Coord)
							break
						end
					end
					CrateDrop("weapon_pistol", 55, 400.0, {["x"] = x, ["y"] = y, ["z"] = z})
				end
			end
		end, PlayerData.job.name)
		prvispawn = true
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	SpawnBlip()
end)

AddEventHandler('mafije:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end
  
  if part == 'Impound' then
    CurrentAction     = 'menu_impound'
    CurrentActionMsg  = "Pritisnite E da zapljenite vozilo"
    CurrentActionData = {station = station}
  end

  if part == 'Istovar' then
	local vehara = GetVehiclePedIsUsing(PlayerPedId())
	local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
	if retval == "BENSON" then
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
		ESX.ShowNotification("Istovarate piće...")
		Wait(10000)
		ESX.ShowNotification("Istovarili ste piće, idite do lokacije oznacene na mapi")
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
		RemoveBlip(Blipara)
		TriggerServerEvent("mafije:PlatiDostavu", 1, PlayerData.job.name)
		ESX.ShowNotification("Vasa mafija je dobila 6000$, a vi ste dobili 3000$")
		IstovarioTo = 1
		local xa, ya, za, ha
		for i=1, #Koord, 1 do
			if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "PosaoSpawn" then
				xa, ya, za, ha = table.unpack(Koord[i].Coord)
				Blipara = AddBlipForCoord(xa, ya, za)
				LokDosa = vector3(xa, ya, za)
			end
		end
		SetBlipSprite(Blipara, 1)
		SetBlipColour (Blipara, 2)
		OstavioTo = 0
		SetBlipRoute(Blipara,  true) -- waypoint to blip
		Citizen.CreateThread(function()
			while OstavioTo == 0 do
				Wait(0)
				--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
				--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				DrawMarker(1, xa, ya, za, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end
		end)
	else
		ESX.ShowNotification("Niste u vozilu za dostavu")
	end
  end
  
  if part == 'Istovar2' then
	local vehara = GetVehiclePedIsUsing(PlayerPedId())
	local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
	if retval == "PACKER" then
		local retvala, trailer = GetVehicleTrailerVehicle(vehara)
		if retvala and trailer == prikolca then
			IstovarioTo = 1
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
			ESX.ShowNotification("Istovarate vozila...")
			Wait(1000)
			DoScreenFadeOut(100)
			ESX.Game.DeleteVehicle(prikolca)
			Wait(10000)
			ESX.Game.SpawnVehicle("TR2", {x = -36.092674255371, y = -1079.3096923828, z = 26.740900039673}, 239.43359375, function(trailer)
				AttachVehicleToTrailer(posaov, trailer, 1.1)
				prikolca = trailer
			end)
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
			DoScreenFadeIn(100)
			TriggerServerEvent("mafije:PlatiDostavu", 2, PlayerData.job.name)
			ESX.ShowNotification("Istovarili ste vozila, idite do lokacije oznacene na mapi")
			ESX.ShowNotification("Vasa mafija je dobila 7500$, a vi ste dobili 3750$")
			RemoveBlip(Blipara)
			local xa, ya, za, ha
			for i=1, #Koord, 1 do
				if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "PosaoSpawn" then
					xa, ya, za, ha = table.unpack(Koord[i].Coord)
					Blipara = AddBlipForCoord(xa, ya, za)
					LokDosa = vector3(xa, ya, za)
				end
			end
			SetBlipSprite(Blipara, 1)
			SetBlipColour (Blipara, 2)
			OstavioTo = 0
			SetBlipRoute(Blipara,  true) -- waypoint to blip
			Citizen.CreateThread(function()
				while OstavioTo == 0 do
					Wait(0)
					--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
					--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
					DrawMarker(1, xa, ya, za, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
				end
			end)
		else
			ESX.ShowNotification("Nemate zakacenu prikolicu ili nije vaša")
		end
	else
		ESX.ShowNotification("Niste u vozilu za dostavu")
	end
  end
  
  if part == 'VratiKamion' then
	RemoveBlip(Blipara)
	ESX.Game.DeleteVehicle(posaov)
	if prikolca ~= nil then
		ESX.Game.DeleteVehicle(prikolca)
	end
	OstavioTo = 1
	IstovarioTo = 0
	ESX.ShowNotification("Uspjesno ste odradili dostavu")
	Vozis = 0
  end
  
  if part == 'Posao' then
    CurrentAction     = 'menu_posao'
    CurrentActionMsg  = "Pritisnite E da otvorite izbornik"
    CurrentActionData = {}
  end
  
  if part == 'Dostava' then
		if KVozilo == GetVehiclePedIsIn(PlayerPedId(), false) then
                     if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
			if DoesBlipExist(KBlip) then
				RemoveBlip(KBlip)
				KBlip = nil
			end
			ProdajeKokain = false
			DostavaID = 0
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
			ESX.ShowNotification("Istovar..")
			Wait(5000)
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
			local naso = false
			for i=1, #Mafije, 1 do
				if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
					TriggerServerEvent("mafije:IsplatiSve", PlayerData.job.name)
					naso = true
					break
				end
			end
			if not naso then
				TriggerServerEvent("mafije:IsplatiSve", nil)
			end
			ESX.ShowNotification("Zavrsili ste prodaju kokaina!")
			TriggerServerEvent("mafije:MakniKamion", VehToNet(KVozilo))
			if DoesEntityExist(tObj) then
				ESX.Game.DeleteObject(tObj)
				tObj = nil
			end
			if DoesEntityExist(tObj2) then
				ESX.Game.DeleteObject(tObj2)
				tObj2 = nil
			end
			if DoesEntityExist(tObj3) then
				ESX.Game.DeleteObject(tObj3)
				tObj3 = nil
			end
			if DoesEntityExist(KVozilo) then
				ESX.Game.DeleteVehicle(KVozilo)
				KVozilo = nil
			end
                    end
		else
			ESX.ShowNotification("Niste u vozilu za prodaju kokaina!")
		end
  end
  
  if part == 'Drop' then
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			if GetPedInVehicleSeat(vehara, -1) == PlayerPedId() then
				--DeleteEntity(crate)
				PokupioCrate = true
				SpawnajDropMarker = false
				DeleteEntity(crate)
				local model = GetHashKey("prop_box_wood05a")
				RequestModel(model)
				
				while not HasModelLoaded(model) do
					Wait(1)
				end
				crate = CreateObject(model, crateSpawn, true, true, false)
				local nid = NetworkGetNetworkIdFromEntity(crate)
				TriggerServerEvent("mafije:SpremiNetID", nid, PlayerData.job.name)
				local veh = GetVehiclePedIsIn(PlayerPedId(), false)
				local ent = GetEntityBoneIndexByName(veh, "boot")
				AttachEntityToEntity(crate, GetVehiclePedIsIn(PlayerPedId(), false), ent, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0, 2, 1)
				ESX.ShowNotification("Odvezite paket do oznacene lokacije!")
				for i=1, #Koord, 1 do
					if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "DeleteV" then
						local x,y,z = table.unpack(Koord[i].Coord)
						DostavaBlip = AddBlipForCoord(x,y,z)
						SetBlipSprite(DostavaBlip, 1)
						SetBlipRoute(DostavaBlip,  true)
					end
				end
			end
		end
	end
  end
  
  if part == 'UlazUKucu' then
	CurrentAction     = 'menu_ulaz'
	CurrentActionMsg  = "Pritisnite E da udjete u kucu"
	CurrentActionData = {station = station, partNum = partNum}
  end
  
  if part == 'UlazUKokain' then
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
			if Mafije[i].Skladiste == 1 then
				CurrentAction     = 'menu_ulazk'
				CurrentActionMsg  = "Pritisnite E da udjete u labos"
				CurrentActionData = {station = station, partNum = partNum}
			else
				CurrentAction     = 'menu_ulazkupi'
				CurrentActionMsg  = "Pritisnite E da kupite skladiste"
				CurrentActionData = {station = station, partNum = partNum}
			end
			break
		end
	end
  end
  
  if part == 'UlazUSkladiste' then
	CurrentAction     = 'menu_ulazsk'
	CurrentActionMsg  = "Pritisnite E da udjete u skladiste"
	CurrentActionData = {station = station, partNum = partNum}
  end
  
  if part == 'KokainMenu' then
	CurrentAction     = 'menu_kokain'
	CurrentActionMsg  = "Pritisnite E da upravljate skladistem"
	CurrentActionData = {station = station, partNum = partNum}
  end
  
  if part == 'IzlazIzSkladiste' then
	CurrentAction     = 'menu_izlazsk'
	CurrentActionMsg  = "Pritisnite E da izadjete iz skladista"
	CurrentActionData = {station = station, partNum = partNum}
  end
  
  if part == 'IzlazIzKuce' then
	CurrentAction     = 'menu_izlaz'
	CurrentActionMsg  = "Pritisnite E da izadjete iz kuce"
	CurrentActionData = {station = station, partNum = partNum}
  end
  
  if part == 'IzlazIzKokain' then
	CurrentAction     = 'menu_izlazk'
	CurrentActionMsg  = "Pritisnite E da izadjete iz labosa"
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleSpawner' then
	CurrentAction     = 'menu_vehicle_spawner'
	CurrentActionMsg  = _U('vehicle_spawner')
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleDeleter' then
	if PokupioCrate == true then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			if GetPedInVehicleSeat(vehara, -1) == PlayerPedId() then
				PokupioCrate = false
				DeleteEntity(crate)
				RemoveBlip(DostavaBlip)
				ESX.ShowNotification("Oruzje vam je dodano u sef mafije!")
				for i=0, 10, 1 do
					if ZatrazioOruzje[i] ~= nil then
						ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
							  --OpenBuyWeaponsMenu(station)
						end, ZatrazioOruzje[i], 250, PlayerData.job.name)
						ZatrazioOruzje[i] = nil
					end
					Wait(100)
				end
				TriggerServerEvent('mafije:ResetirajOruzje', PlayerData.job.name)
				ZOBr = 0
			end
		else
			ESX.ShowNotification("Morate biti u Guardianu!")
		end
	else
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		  local vehicle = GetVehiclePedIsIn(playerPed, false)

		  if DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		  end

		end
	end
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('mafije:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('mafije:oslobodiga')
AddEventHandler('mafije:oslobodiga', function()
	local playerPed = GetPlayerPed(-1)
    if IsHandcuffed then
	  IsHandcuffed = false
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
	  TriggerEvent("NeKickaj", false)
    end
end)

RegisterNetEvent('mafije:handcuff')
AddEventHandler('mafije:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
	  TriggerEvent("NeKickaj", true)
    else
	  TriggerEvent("esx_grovejob:oslobodiga")
	  TriggerEvent("esx_ballasjob:oslobodiga")
	  TriggerEvent("esx_yakuza:oslobodiga")
	  TriggerEvent("esx_mafiajob:oslobodiga")
	  TriggerEvent("esx_policejob:oslobodiga")
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
      TriggerEvent("NeKickaj", false)
    end

  end)
end)

RegisterNetEvent('mafije:drag')
AddEventHandler('mafije:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

RegisterNetEvent('mafije:putInVehicle')
AddEventHandler('mafije:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('mafije:OutVehicle')
AddEventHandler('mafije:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('mafije:PosaljiVozila')
AddEventHandler('mafije:PosaljiVozila', function(maf, voz)
	Vozila = voz
end)

RegisterNetEvent('mafije:UpdateKoord')
AddEventHandler('mafije:UpdateKoord', function(koor)
	Koord = koor
end)

RegisterNetEvent('mafije:UpdateSkladista')
AddEventHandler('mafije:UpdateSkladista', function(skl)
	Skladiste = skl
	if UnutarLabosa then
		for i = 1, #Kutijice, 1 do
			if Kutijice[i] ~= nil then
				DeleteEntity(Kutijice[i])
			end
		end
		Kutijice = {}
		for i=1, #Skladiste, 1 do
			if Skladiste[i] ~= nil and Skladiste[i].Mafija == PlayerData.job.name then
				local brojic = math.floor((Skladiste[i].Kokain/100)+0.5)
				local model = GetHashKey('ex_prop_crate_narc_bc')
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(1)
				end
				for i = 1, brojic, 1 do
					if Kutije[i] ~= nil then
						local objikt = CreateObject(model, Kutije[i].x, Kutije[i].y, Kutije[i].z-0.2, false, false, false)
						table.insert(Kutijice, objikt)
					end
				end
				SetModelAsNoLongerNeeded(model)
				break
			end
		end
	end
end)

RegisterNetEvent('mafije:UpdateMafije')
AddEventHandler('mafije:UpdateMafije', function(maf)
	Mafije = maf
end)

RegisterNetEvent('mafije:UpdateRankove')
AddEventHandler('mafije:UpdateRankove', function(ran)
	Rankovi = ran
end)

RegisterNetEvent('mafije:UpdateImeBlipa')
AddEventHandler('mafije:UpdateImeBlipa', function(maf, ime)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(firstToUpper(ime))
	EndTextCommandSetBlipName(Blipovi[maf])
end)

RegisterNetEvent('mafije:UpdateBoje')
AddEventHandler('mafije:UpdateBoje', function(br, maf, boj)
	Boje = boj
	if Config.Blipovi == true then
		if maf == PlayerData.job.name then
			if br == 2 then
				for i=1, #Boje, 1 do
					if Boje[i] ~= nil and Boje[i].Mafija == maf and Boje[i].Ime == "Blip" then
						SetBlipColour (Blipovi[maf], tonumber(Boje[i].Boja))
						SetBlipColour (SBlipovi[maf], tonumber(Boje[i].Boja))
						SetBlipColour (blipcic, tonumber(Boje[i].Boja))
						break
					end
				end
			end
			if br == 3 then
				RemoveBlip(Blipovi[maf])
				Blipovi[maf] = nil
				RemoveBlip(SBlipovi[maf])
				SBlipovi[maf] = nil
				RemoveBlip(blipcic)
				blipcic = nil
			end
		end
	end
end)

RegisterNetEvent('mafije:PosaljiOruzja')
AddEventHandler('mafije:PosaljiOruzja', function(maf, oruz)
	Oruzja = oruz
end)

RegisterNetEvent('mafije:UpdateSBlip')
AddEventHandler('mafije:UpdateSBlip', function(maf)
	if Config.Blipovi == true then
		if maf == PlayerData.job.name then
			SetBlipSprite (SBlipovi[maf], 357)
			SetBlipDisplay(SBlipovi[maf], 4)
			SetBlipScale  (SBlipovi[maf], 1.2)
			for a=1, #Boje, 1 do
				if Boje[a] ~= nil and Boje[a].Mafija == maf and Boje[a].Ime == "Blip" then
					SetBlipColour(SBlipovi[maf], tonumber(Boje[a].Boja))
					break
				end
			end
			SetBlipAsShortRange(SBlipovi[maf], true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Kokain lab")
			EndTextCommandSetBlipName(SBlipovi[maf])
		end
	end
end)

RegisterNetEvent('mafije:KreirajBlip')
AddEventHandler('mafije:KreirajBlip', function(co, maf, br)
	if Config.Blipovi == true then
		if maf == PlayerData.job.name then
			if br == 1 then
				local x,y,z = table.unpack(co)
				if Blipovi[maf] ~= nil then
					RemoveBlip(Blipovi[maf])
					Blipovi[maf] = nil
				end
				if x ~= 0 and x ~= nil then
					Blipovi[maf] = AddBlipForCoord(x,y,z)

					SetBlipSprite (Blipovi[maf], 378)
					SetBlipDisplay(Blipovi[maf], 4)
					SetBlipScale  (Blipovi[maf], 1.2)
					for i=1, #Boje, 1 do
						if Boje[i] ~= nil and Boje[i].Mafija == maf and Boje[i].Ime == "Blip" then
							SetBlipColour (Blipovi[maf], tonumber(Boje[i].Boja))
							break
						end
					end
					SetBlipAsShortRange(Blipovi[maf], true)

					BeginTextCommandSetBlipName("STRING")
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == maf then
							AddTextComponentString(firstToUpper(Mafije[j].Label))
							break
						end
					end
					EndTextCommandSetBlipName(Blipovi[maf])
				end
			elseif br == 2 then
				local x,y,z = table.unpack(co)
				if SBlipovi[maf] ~= nil then
					RemoveBlip(SBlipovi[maf])
					SBlipovi[maf] = nil
				end
				if x ~= 0 and x ~= nil then
					local kupljeno = false
					for j=1, #Mafije, 1 do
						if Mafije[j] ~= nil and Mafije[j].Ime == maf then
							if Mafije[j].Skladiste == 1 then
								kupljeno = true
							end
							break
						end
					end
					if kupljeno then
						SBlipovi[maf] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[maf], 357)
						SetBlipDisplay(SBlipovi[maf], 4)
						SetBlipScale  (SBlipovi[maf], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == maf and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[maf], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[maf], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab")
						EndTextCommandSetBlipName(SBlipovi[maf])
					else
						SBlipovi[maf] = AddBlipForCoord(x,y,z)

						SetBlipSprite (SBlipovi[maf], 369)
						SetBlipDisplay(SBlipovi[maf], 4)
						SetBlipScale  (SBlipovi[maf], 1.2)
						for a=1, #Boje, 1 do
							if Boje[a] ~= nil and Boje[a].Mafija == maf and Boje[a].Ime == "Blip" then
								SetBlipColour(SBlipovi[maf], tonumber(Boje[a].Boja))
								break
							end
						end
						SetBlipAsShortRange(SBlipovi[maf], true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Kokain lab na prodaju!")
						EndTextCommandSetBlipName(SBlipovi[maf])
					end
				end
			else
				local x,y,z = table.unpack(co)
				if blipcic~= nil then
					RemoveBlip(blipcic)
					blipcic = nil
				end
				if x ~= 0 and x ~= nil then
					blipcic = AddBlipForCoord(x,y,z)

					SetBlipSprite (blipcic, 473)
					SetBlipAsShortRange(blipcic, true)
					for a=1, #Boje, 1 do
						if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
							SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
							break
						end
					end
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Dostava pića/vozila")
					EndTextCommandSetBlipName(blipcic)
				end
			end
		end
	end
end)

function OpenBuyStvarMenu(station)
    local elements = {}
    table.insert(elements, {label = 'Laptop za hakiranje (25000$)', value = 'laptop'})
	table.insert(elements, {label = 'Termitna bomba (5000$)', value = 'termit'})
	
	if PlayerData.job.name == Config.Tijelo then
		table.insert(elements, {label = 'Tijelo za assault rifle (10000$)', value = 'ktijelo'})
		table.insert(elements, {label = 'Tijelo za carbine rifle (15000$)', value = 'ctijelo'})
		table.insert(elements, {label = 'Tijelo za special carbine (20000$)', value = 'stijelo'})
		table.insert(elements, {label = 'Tijelo za smg (7000$)', value = 'smtijelo'})
	end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_stvari',
      {
        title    = "Kupovina stvari",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kupistvari', function(hasEnoughMoney)
			  if hasEnoughMoney then
					ESX.ShowNotification("Uspjesno kupljeno!")
			  else
					if data.current.value == "laptop" or data.current.value == "termit" then
						ESX.ShowNotification("Nemate dovoljno novca ili vec imate dovoljno u inventoryju!")
					else
						ESX.ShowNotification("Vasa mafija nema dovoljno novca ili vec imate dovoljno u inventoryju!")
					end
			  end
		end, data.current.value, PlayerData.job.name)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') and (GetGameTimer() - GUI.Time) > 150 then
			for i=1, #Mafije, 1 do
				if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
					OpenMafiaActionsMenu()
					GUI.Time = GetGameTimer()
					break
				end
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
	if IsHandcuffed then
		waitara = 0
		naso = 1
		if IsDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
			local myped = GetPlayerPed(-1)
			AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			DetachEntity(GetPlayerPed(-1), true, false)
		end
    end
	if IsHandcuffed then
	  waitara = 0
	  naso = 1
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
	  DisableControlAction(0, 167, true) -- f6
    end
	
	if CurrentAction ~= nil then
	  waitara = 0
	  naso = 1
	  
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenNewMenu()
        end
		
		if CurrentAction == 'menu_ulazkupi' then
			OpenSPitajMenu()
        end

		if CurrentAction == 'menu_posao' then
			OpenPosaoMenu()
		end
		
		if CurrentAction == 'menu_impound' then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			local vehicle = ESX.Game.GetVehicleProperties(veh)
			ESX.TriggerServerCallback('mafije:OsobnoVozilo', function(isOwnedVehicle)
				if isOwnedVehicle then
					TriggerServerEvent('eden_garage:modifystate2', vehicle, 2)
					ESX.Game.DeleteVehicle(veh)
					Wait(200)
					if DoesEntityExist(veh) then
						local entity = veh
						carModel = GetEntityModel(entity)
						carName = GetDisplayNameFromVehicleModel(carModel)
						NetworkRequestControlOfEntity(entity)
						
						local timeout = 2000
						while timeout > 0 and not NetworkHasControlOfEntity(entity) do
							Wait(100)
							timeout = timeout - 100
						end

						SetEntityAsMissionEntity(entity, true, true)
						
						local timeout = 2000
						while timeout > 0 and not IsEntityAMissionEntity(entity) do
							Wait(100)
							timeout = timeout - 100
						end

						Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
						
						if (DoesEntityExist(entity)) then 
							DeleteEntity(entity)
						end 
					end
					ESX.ShowNotification("Vozilo spremljeno u garazu!")
				else
					ESX.ShowNotification("Ovo nije osobno vozilo ili se desio bug dupliciranog vozila!")
				end
			end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)))
        end
		
		if CurrentAction == 'menu_ulaz' then
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "Izlaz" then
					local x,y,z = table.unpack(Koord[i].Coord)
					SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
					FreezeEntityPosition(PlayerPedId(), true)
					TriggerServerEvent("kuce:UKuci", true)
					Wait(3000)
					FreezeEntityPosition(PlayerPedId(), false)
				end
			end
        end
		
		if CurrentAction == 'menu_izlaz' then
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "Ulaz" then
					local x,y,z = table.unpack(Koord[i].Coord)
					SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
					TriggerServerEvent("kuce:UKuci", false)
				end
			end
        end
		
		if CurrentAction == 'menu_ulazk' then
			TriggerServerEvent("mafije:BucketajGa", CurrentActionData.partNum)
			SetEntityCoords(PlayerPedId(), 1088.7263183594, -3187.4624023438, -39.993450164795, false, false, false, true)
			SetEntityHeading(PlayerPedId(), 179.78)
			FreezeEntityPosition(PlayerPedId(), true)
			TriggerServerEvent("kuce:UKuci", true)
			UnutarLabosa = true
			Wait(3000)
			FreezeEntityPosition(PlayerPedId(), false)
			if JebenaKanta ~= nil then
				DeleteEntity(JebenaKanta)
				JebenaKanta = nil
			end
			local model2 = GetHashKey('bkr_ware03_bin2')
			RequestModel(model2)
			while not HasModelLoaded(model2) do
				Wait(1)
			end
			JebenaKanta = CreateObject(model2, 1102.112, -3198.685, -39.51907-0.83, false, false, false)
			SetModelAsNoLongerNeeded(model2)
			for i = 1, #Kutijice, 1 do
				if Kutijice[i] ~= nil then
					DeleteEntity(Kutijice[i])
				end
			end
			Kutijice = {}
			for i=1, #Skladiste, 1 do
				if Skladiste[i] ~= nil and Skladiste[i].Mafija == PlayerData.job.name then
					local brojic = math.floor((Skladiste[i].Kokain/100)+0.5)
					local model = GetHashKey('ex_prop_crate_narc_bc')
					RequestModel(model)
					while not HasModelLoaded(model) do
						Wait(1)
					end
					for i = 1, brojic, 1 do
						if Kutije[i] ~= nil then
							local objikt = CreateObject(model, Kutije[i].x, Kutije[i].y, Kutije[i].z-0.2, false, false, false)
							table.insert(Kutijice, objikt)
						end
					end
					SetModelAsNoLongerNeeded(model)
					break
				end
			end
        end
		
		if CurrentAction == 'menu_ulazsk' then
			SetEntityCoords(PlayerPedId(), 1105.1125488281, -3099.4575195313, -39.999969482422, false, false, false, true)
			SetEntityHeading(PlayerPedId(), 87.79)
			FreezeEntityPosition(PlayerPedId(), true)
			Wait(3000)
			FreezeEntityPosition(PlayerPedId(), false)
        end
		
		if CurrentAction == 'menu_izlazsk' then
			SetEntityCoords(PlayerPedId(), 1103.3603515625, -3196.0068359375, -39.993453979492, false, false, false, true)
			SetEntityHeading(PlayerPedId(), 87.79)
			FreezeEntityPosition(PlayerPedId(), true)
			Wait(3000)
			FreezeEntityPosition(PlayerPedId(), false)
        end
		
		if CurrentAction == 'menu_izlazk' then
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "Kokain" then
					local x,y,z = table.unpack(Koord[i].Coord)
					TriggerServerEvent("mafije:BucketajGa", 0)
					SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
					TriggerServerEvent("kuce:UKuci", false)
					UnutarLabosa = false
					for i = 1, #Kutijice, 1 do
						if Kutijice[i] ~= nil then
							DeleteEntity(Kutijice[i])
						end
					end
					Kutijice = {}
					if JebenaKanta ~= nil then
						DeleteEntity(JebenaKanta)
						JebenaKanta = nil
					end
					break
				end
			end
        end
		
		if CurrentAction == 'menu_kokain' then
			OpenKokainMenu()
        end

        if CurrentAction == 'menu_vehicle_spawner' then
			OpenIzborMenu()
        end

        if CurrentAction == 'delete_vehicle' then
			StockVehicleMenu()
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
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
	while PlayerData.job == nil do
		Wait(1)
	end
	if PlayerData.job.name == Config.Automafija then
		if #(coords-Config.Impound) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(1, Config.Impound, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-Config.Impound) < 1.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Impound'
			currentPartNum = 1
		end
	end
	if GetDistanceBetweenCoords(coords,  LokCPa,  true) < Config.MarkerSize.x and IstovarioTo == 0 and Vozis == 1 then
		isInMarker     = true
		currentStation = k
		currentPart    = 'Istovar'
		currentPartNum = i
	end
	
	if GetDistanceBetweenCoords(coords,  LokCPa2,  true) < Config.MarkerSize.x and IstovarioTo == 0 and Vozis == 1 then
		isInMarker     = true
		currentStation = k
		currentPart    = 'Istovar2'
		currentPartNum = i
	end
  
	if GetDistanceBetweenCoords(coords,  LokDosa,  true) < Config.MarkerSize.x and OstavioTo == 0 and Vozis == 1 then
		isInMarker     = true
		currentStation = k
		currentPart    = 'VratiKamion'
		currentPartNum = i
	end
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name then
			if Koord[i].Ime == "Oruzarnica" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 1
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Lider" and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik') then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 2
						currentPart    = 'BossActions'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "SpawnV" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 3
						currentPart    = 'VehicleSpawner'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "DeleteV" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "DeleteV2" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 3.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 2.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Ulaz" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'UlazUKucu'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Izlaz" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'IzlazIzKuce'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Kokain" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'UlazUKokain'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Posao" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'Posao'
						currentPartNum = i
					end
				end
			end
		end
	end
	
	if ProdajeKokain and DostavaID ~= 0 then
		if #(coords-dostave[DostavaID]) < 100 then
			waitara = 0
			naso = 1
			DrawMarker(1, dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-dostave[DostavaID]) < 3.0 then
			isInMarker  = true
			currentPart = "Dostava"
			currentStation = 4
			currentPartNum = 1
		end
	end
	
	if GetDistanceBetweenCoords(coords, 1088.7263183594, -3187.4624023438, -39.993450164795, true) < 100.0 then
		waitara = 0
		naso = 1
		DrawMarker(1, 1088.7263183594, -3187.4624023438, -39.993450164795, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
	end
	if GetDistanceBetweenCoords(coords, 1088.7263183594, -3187.4624023438, -39.993450164795, true) < 1.5 then
		isInMarker     = true
		currentStation = 4
		currentPart    = 'IzlazIzKokain'
		currentPartNum = 1
	end
			
	if GetDistanceBetweenCoords(coords, 1103.3603515625, -3196.0068359375, -39.993453979492, true) < 100.0 then --skladiste ulaz
		waitara = 0
		naso = 1
		DrawMarker(1, 1103.3603515625, -3196.0068359375, -39.993453979492, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
	end
	if GetDistanceBetweenCoords(coords, 1103.3603515625, -3196.0068359375, -39.993453979492, true) < 1.5 then
		isInMarker     = true
		currentStation = 4
		currentPart    = 'UlazUSkladiste'
		currentPartNum = 1
	end
			
	if GetDistanceBetweenCoords(coords, 1105.1125488281, -3099.4575195313, -39.999969482422, true) < 100.0 then --skladiste izlaz
		waitara = 0
		naso = 1
		DrawMarker(1, 1105.1125488281, -3099.4575195313, -39.999969482422, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
	end
	if GetDistanceBetweenCoords(coords, 1105.1125488281, -3099.4575195313, -39.999969482422, true) < 1.5 then
		isInMarker     = true
		currentStation = 4
		currentPart    = 'IzlazIzSkladiste'
		currentPartNum = 1
	end
			
	if GetDistanceBetweenCoords(coords, 1088.4111328125, -3101.2214355469, -39.999961853027, true) < 100.0 then --skladiste menu
		waitara = 0
		naso = 1
		DrawMarker(1, 1088.4111328125, -3101.2214355469, -39.999961853027, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 128, 255, 100, false, true, 2, false, false, false, false)
	end
	if GetDistanceBetweenCoords(coords, 1088.4111328125, -3101.2214355469, -38.999961853027, true) < 1.5 then
		isInMarker     = true
		currentStation = 4
		currentPart    = 'KokainMenu'
		currentPartNum = 1
	end
	

    if PlayerData.job ~= nil then

		if SpawnajDropMarker == true then
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  true) < 100.0 then
				waitara = 0
				naso = 1
				DrawMarker(1, DropCoord.x,  DropCoord.y+2,  DropCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
			end
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  false) < 1.5 then
				isInMarker     = true
				currentStation = 5
				currentPart    = 'Drop'
				currentPartNum = 69
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
				TriggerEvent('mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end

    end
	
	if naso == 0 then
		waitara = 500
	end
  end
end)
---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuMafia')
AddEventHandler('NB:openMenuMafia', function()
	OpenMafiaActionsMenu()
end)
			