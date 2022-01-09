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

local Oruzje					= nil
local Cijena 					= 0
local Prodavac					= nil
local Metci 					= 0
local GUI                       = {}
GUI.Time                        = 0

local CijenaDroge 				= 0
local Kolicina 					= 0
local Prodavac2 				= nil
local perm 						= 0

local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local aduty 					= false

local defaultScale = 0.5 -- Text scale
local color = { r = 230, g = 230, b = 230, a = 255 } -- Text color
local font = 0 -- Text font
local displayTime = 5000 -- Duration to display the text (in ms)
local distToDraw = 250 -- Min. distance to draw 
local pedDisplaying = {}

local disabled            = false
local UVozilu 			  = false
local Sjedalo 			  = nil
local Vozilo = nil

local zones = {
	{ ['x'] = -265.00201416016, ['y'] = -963.61010742188, ['z'] = 31.218370437622 },
	{ ['x'] = -1021.9768676758, ['y'] = -2711.5302734375, ['z'] = 13.80286026001 },
	{ ['x'] = -33.46459197998, ['y'] = -1102.023071289, ['z'] = 26.422609329224 },
	{ ['x'] = 1799.8345947266, ['y'] = 2489.1350097656, ['z'] = -119.02998352051 },
	{ ['x'] = 1009.6475830078, ['y'] = -3100.6489257813, ['z'] = -38.999870300293 },
	{ ['x'] = 2406.6475830078, ['y'] = 4984.6489257813, ['z'] = 46.999870300293 },
	{ ['x'] = 2319.6475830078, ['y'] = 5043.6489257813, ['z'] = 45.999870300293 },
	{ ['x'] = 2316.6475830078, ['y'] = 5139.6489257813, ['z'] = 50.999870300293 },
	{ ['x'] = 2241.6475830078, ['y'] = 5169.6489257813, ['z'] = 59.999870300293 },
	{ ['x'] = 2148.6475830078, ['y'] = 5191.6489257813, ['z'] = 57.999870300293 },
	{ ['x'] = 2070.6475830078, ['y'] = 5187.6489257813, ['z'] = 53.999870300293 },
	{ ['x'] = 2149.6475830078, ['y'] = 5125.6489257813, ['z'] = 47.999870300293 },
	{ ['x'] = 2210.6475830078, ['y'] = 5063.6489257813, ['z'] = 46.999870300293 },
	{ ['x'] = 2217.6475830078, ['y'] = 5059.6489257813, ['z'] = 47.999870300293 },
	{ ['x'] = 2277.6475830078, ['y'] = 5000.6489257813, ['z'] = 42.999870300293 },
	{ ['x'] = 2345.6475830078, ['y'] = 4955.6489257813, ['z'] = 42.999870300293 },
	{ ['x'] = 2428.6475830078, ['y'] = 5032.6489257813, ['z'] = 46.999870300293 },
	{ ['x'] = 2384.6475830078, ['y'] = 5076.6489257813, ['z'] = 47.999870300293 },
	{ ['x'] = 2312.6475830078, ['y'] = 5121.6489257813, ['z'] = 49.999870300293 },
	{ ['x'] = 2182.6475830078, ['y'] = 5212.6489257813, ['z'] = 60.999870300293 },
	{ ['x'] = 203.6475830078, ['y'] = -911.6489257813, ['z'] = 30.999870300293 },
	{ ['x'] = 181.6475830078, ['y'] = -969.6489257813, ['z'] = 30.999870300293 },
	{ ['x'] = 251.6475830078, ['y'] = -740.6489257813, ['z'] = 32.999870300293 },
	{ ['x'] = 305.6403503418, ['y'] = -591.42596435546, ['z'] = 43.291831970214 },
	{ ['x'] = 917.81231689454, ['y'] = 51.503299713134, ['z'] = 80.898887634278 },
	{ ['x'] = 218.20721435547, ['y'] = -882.64978027344, ['z'] = 18.319725036621}
}
local notifIn = false
local notifOut = false
local closestZone = 1

ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  ProvjeriPosao()
end)

Citizen.CreateThread(function()
  while	true do
	Citizen.Wait(3600000) --1h
	local porez = 0
	--kuca
	ESX.TriggerServerCallback('loaf_housing:ImalKucu', function(br)
		if br then
			porez = porez+1
		end
	end)
	--trgovine
	ESX.TriggerServerCallback('esx_firme:DajBrojTrgovina', function(br)
		porez = porez+br
	end)
	--Gunshopovi
	ESX.TriggerServerCallback('esx_gun:DajBrojTrgovina', function(br)
		porez = porez+br
	end)
	--Pumpe
	ESX.TriggerServerCallback('pumpe:DajBrojPumpi', function(br)
		porez = porez+br
	end)
	Citizen.Wait(2000)
	if porez > 0 then
		TriggerServerEvent("prodajoruzje:PlatiPorez", porez)
	end
  end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 50.0 then  ------------------------------------------------------------------------------ Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			naso = 1
			waitara = 0
			if not notifIn then																			  -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#1E90FF'>Vi ste u safe zoni</b>",
					type = "success",
					timeout = (3000),
					layout = "bottomcenter",
					queue = "global"
				})
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#1E90FF'>Napustili ste safe zonu</b>",
					type = "error",
					timeout = (3000),
					layout = "bottomcenter",
					queue = "global"
				})
				notifOut = true
				notifIn = false
			end
		end
		if notifIn then
			naso = 1
			waitara = 0
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			DisableControlAction(0, 106, true) -- Disable in-game mouse controls
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 263, true)
			if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#1E90FF'>Ne mozete koristiti oruzja u safe zoni</b>",
					type = "error",
					timeout = (3000),
					layout = "bottomcenter",
					queue = "global"
				})
			end
			if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#1E90FF'>Ne mozete to raditi u safe zoni</b>",
					type = "error",
					timeout = (3000),
					layout = "bottomcenter",
					queue = "global"
				})
			end
		end
		if naso == 0 then
			waitara = 500
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
		--if DoesEntityExist(player) then	      --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
			--DrawMarker(1, zones[closestZone].x, zones[closestZone].y, zones[closestZone].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 232, 255, 155, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
			--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
		--end
	end
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	UVozilu = true
	Sjedalo = currentSeat
	Vozilo = currentVehicle
	if Sjedalo == 0 then
		Citizen.CreateThread(function ()
			while UVozilu do
				Citizen.Wait(0)
				if not disabled then
					local veh = Vozilo
					if Sjedalo == 0 then
						local ped = PlayerPedId()
						if not GetIsTaskActive(ped, 164) and GetIsTaskActive(ped, 165) then
							local veh = Vozilo
							local angle = GetVehicleDoorAngleRatio(veh, 1)
							if angle ~= 0.0 then
								SetVehicleDoorControl(veh, 1, 1, 0.0)
							end
							SetPedIntoVehicle(PlayerPedId(), veh, 0)
						end
					end
				end
			end
		end)
	end
	if GetVehicleClass(Vozilo) == 18 then
		ModifyVehicleTopSpeed(GetVehiclePedIsIn(Vozilo, false), 70.0)
	end
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, modelName, netId)
	UVozilu = false
	Sjedalo = nil
	Vozilo = nil
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

RegisterCommand("zvukvozila", function(source, args, raw)
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local currentradio = GetPlayerRadioStationIndex(vehicle)
	if tonumber(args[1]) == 1 then
		ForceVehicleEngineAudio(vehicle, "s85b50")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "s85b50")
	elseif tonumber(args[1]) == 2 then
		ForceVehicleEngineAudio(vehicle, "n55b30t0")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "n55b30t0")
	elseif tonumber(args[1]) == 3 then
		ForceVehicleEngineAudio(vehicle, "s55b30")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "s55b30")
	elseif tonumber(args[1]) == 4 then
		ForceVehicleEngineAudio(vehicle, "audicrdb")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "audicrdb")
	elseif tonumber(args[1]) == 5 then
		ForceVehicleEngineAudio(vehicle, "audi7a")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "audi7a")
	elseif tonumber(args[1]) == 6 then
		ForceVehicleEngineAudio(vehicle, "audiea855")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "audiea855")
	elseif tonumber(args[1]) == 7 then
		ForceVehicleEngineAudio(vehicle, "audiwx")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "audiwx")
	elseif tonumber(args[1]) == 8 then
		ForceVehicleEngineAudio(vehicle, "ferrarif154")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "ferrarif154")
	elseif tonumber(args[1]) == 9 then
		ForceVehicleEngineAudio(vehicle, "hondaf20c")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "hondaf20c")
	elseif tonumber(args[1]) == 10 then
		ForceVehicleEngineAudio(vehicle, "gallardov10")
		Citizen.Wait(200)
		print("changing radio")
		if currentradio ~= 255 then
			SetRadioToStationIndex(currentradio)
		else
			SetRadioToStationName("OFF")
		end
		local netid = VehToNet(vehicle)
		TriggerServerEvent("vozila:PromjeniZvuk", GetPlayerServerId(PlayerId()), netid, "gallardov10")
	end
end)

RegisterNetEvent('vozila:NoviZvuk')
AddEventHandler('vozila:NoviZvuk', function(id, netid, zvuk)
	if GetPlayerServerId(PlayerId()) ~= id then
		Wait(500)
		if NetworkDoesEntityExistWithNetworkId(netid) then
			print("postojim")
			local vehicle = NetToVeh(netid)
			ForceVehicleEngineAudio(vehicle, zvuk)
		end
	end
end)

RegisterCommand("prebaci", function()
    Citizen.CreateThread(function()
        disabled = true
        Wait(3000)
        disabled = false
		Sjedalo = GetPedVehicleSeat(PlayerPedId())
		if Sjedalo == -1 then
			TriggerEvent("gameEventTriggered", "CEventNetworkPlayerEnteredVehicle", {128, GetVehiclePedIsIn(PlayerPedId(), false)})
			local globalplate  = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
			if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
				ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
					TriggerEvent("EoTiIzSalona", mj)
				end, globalplate)
			end
			UVozilu = false
			Wait(200)
			UVozilu = true
		end
    end)
end)

TriggerEvent('chat:addSuggestion', '/prebaci', 'Koristite da se prebacite na vozacevo mjesto!')

local islandVec = vector3(4840.571, -5174.425, 2.0)
Citizen.CreateThread(function()
    while true do
		local pCoords = GetEntityCoords(GetPlayerPed(-1))		
		local distance1 = #(pCoords - islandVec)
		if distance1 < 2000.0 then
			SetIslandHopperEnabled("HeistIsland", true)  -- load the map and removes the city
			SetToggleMinimapHeistIsland(true) -- load the minimap/pause map and removes the city minimap/pause map
		else
			SetIslandHopperEnabled("HeistIsland", false)
			SetToggleMinimapHeistIsland(false)
		end
		Citizen.Wait(5000)
    end
end)

-- OBJ : draw text in 3d
-- PARAMETERS :
--      - coords : world coordinates to where you want to draw the text
--      - text : the text to display
local function DrawText3D2(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    --if onScreen then

        -- Format the text
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextScale(0.0, defaultScale * scale)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextDropShadow()
        SetTextCentre(true)

        -- Diplay the text
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetDrawOrigin(coords, 0)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()

    --end
end

-- OBJ : handle the drawing of text above a ped head
-- PARAMETERS :
--      - coords : world coordinates to where you want to draw the text
--      - text : the text to display
local function Display(ped, text, koord)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local dist = #(playerCoords - koord)

    if dist <= distToDraw then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        -- Timer
        local display = true

        Citizen.CreateThread(function()
            Wait(displayTime)
            display = false
        end)

        -- Display
        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D2(vector3(x, y, z), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

-- --------------------------------------------
-- Event
-- --------------------------------------------

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId, koord)
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    Display(ped, text, koord)
end)

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand("gepek", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
			local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else
				if not locked then
					SetVehicleDoorOpen(closecar, door, false, false)
					TriggerEvent("gepeke:OtvoriGa")
				else
					ShowInfo("Vozilo je zakljucano.")
				end
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("hauba", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else	
                SetVehicleDoorOpen(closecar, door, false, false)
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("vrata", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/vrata [vrata]")
        ShowInfo("~y~Moguce vrata:")
        ShowInfo("1(Prednja ljeva), 2(Prednja desna)")
        ShowInfo("3(Straznja ljeva), 4(Straznja desna)")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
            else	
                SetVehicleDoorOpen(veh, door, false, false)
            end
        else
            if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
                if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                    SetVehicleDoorShut(closecar, door, false)
                else	
                    SetVehicleDoorOpen(closecar, door, false, false)
                end
            else
                ShowInfo("Previse ste udaljeni od vozila.")
            end
        end
    end
end)

--Voda
function IsFacingWater()
  local ped = PlayerPedId()
  local headPos = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
  local offsetPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, -25.0)
  local hit, hitPos = TestProbeAgainstWater(headPos.x, headPos.y, headPos.z, offsetPos.x, offsetPos.y, offsetPos.z)
  return hit, hitPos
end

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	local model = GetHashKey("a_m_m_beach_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	local npc = CreatePed(4, model, 94.828460693359, 3756.8435058594, 39.770915985107, 160.21, false, true)
	SetModelAsNoLongerNeeded(model)
			
	SetEntityHeading(npc, 160.21)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
	SetPlayerCanDoDriveBy(PlayerId(), false)
	
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end

RegisterCommand("ss", function(source)
    exports['screenshot-basic']:requestScreenshot(function(data)
		TriggerEvent('chat:addMessage', { template = '<img src="{0}" style="max-width: 300px;" />', args = { data } })
	end)
end)

RegisterCommand("hash", function(source, args, raw)
    print(GetHashKey(args[1]))
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("Teleportiran.")
            else
                ESX.ShowNotification("Stavite vas marker prvo.")
            end
        else
            ESX.ShowNotification("Nemate ovlasti za ovu komandu.")
        end
    end)
end

AddEventHandler("playerSpawned", function()
	SetPedComponentVariation(PlayerPedId(), 1, 0 ,0, 2)
	--StatSetInt(GetHashKey('MP0_STAMINA'), 20, true)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, 0, 0, 0, true) <= 10.0 then
		SetEntityCoords(PlayerPedId(), -825.510, -440.8749, 35.6722)
	end
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

RegisterNetEvent('es_admin:setPerm')
AddEventHandler('es_admin:setPerm', function()
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

RegisterNetEvent('loto:IzaberiBroj')
AddEventHandler('loto:IzaberiBroj', function()
	TriggerEvent("esx_invh:closeinv")
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vrloto', {
		title = "Upisite broj za loto (1-120)",
	}, function (datari69, menuri69)
		local br = datari69.value
		if br == nil or tonumber(br) <= 0 then
			ESX.ShowNotification('Krivi iznos!')
		else
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vrloto2', {
				title = "Upisite koliku uplatu hocete (1-15000$)",
			}, function (datari70, menuri70)
				local br2 = datari70.value
				if br2 == nil or tonumber(br2) <= 0 or tonumber(br2) > 15000 then
					ESX.ShowNotification('Krivi iznos!')
				else
					TriggerServerEvent("loto:UplatiBroj", br, br2)
					menuri70.close()
				end
			end, function (datari70, menuri70)
				menuri70.close()
			end)
			menuri69.close()
		end
	end, function (datari69, menuri69)
		menuri69.close()
	end)
end)

--[[AddEventHandler("gameEventTriggered", function(name, data)
	print(name)
	--(targetId, playerId, nezz, jelUmro, hashOruzja, nezz(mijenja se kada se sudaris autom), nezz(mijenja se kada se sudaris autom), nezz, nezz(mijenja se kada headas peda), nezz, mijenja se ovisno o tome koji dio vozila pucas)
	print(json.encode(data))
end)]]

RegisterNetEvent('VratiTamoSkin')
AddEventHandler('VratiTamoSkin', function(pid)
	local retval = NetworkGetNetworkIdFromEntity(PlayerPedId())
	TriggerServerEvent("EoTiSkinara", retval, GetEntityModel(PlayerPedId()), pid)
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        ESX.Game.DeleteObject(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        ESX.Game.DeleteObject(currentGear.tank)
		currentGear.tank = 0
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		TriggerServerEvent("minute:SpremiIh")
	end
end)

RegisterCommand("upoznaj", function(source, args, rawCommandString)
	local players      = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
	local foundPlayers = false

	for i=1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true
		end
	end

	if not foundPlayers then
		ESX.ShowNotification("Nema igraca u blizini!")
		return
	end

	foundPlayers = false

	TriggerServerEvent("prodajoruzje:Upoznaj1", GetPlayerServerId(players[1]))
end, false)

RegisterNetEvent('ronjenje:PocniRonit')
AddEventHandler('ronjenje:PocniRonit', function()
    if currentGear.enabled == false then
		GearAnim()
		DeleteGear()
		Wait(2000)
		local maskModel = GetHashKey("p_d_scuba_mask_s")
		local tankModel = GetHashKey("p_s_scuba_tank_s")
		
		RequestModel(tankModel)
		while not HasModelLoaded(tankModel) do
			Citizen.Wait(1)
		end
		TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
		local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
		AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
		currentGear.tank = TankObject
		
		RequestModel(maskModel)
		while not HasModelLoaded(maskModel) do
			Citizen.Wait(1)
		end
				
		MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
		local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
		AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
		currentGear.mask = MaskObject
		
		SetEnableScuba(GetPlayerPed(-1), true)
		SetPedMaxTimeUnderwater(GetPlayerPed(-1), 2000.00)
		currentGear.enabled = true
		ClearPedTasks(GetPlayerPed(-1))
		ESX.ShowNotification("Obukli ste opremu za ronjenje!")
	else
		GearAnim()
		Wait(2000)
        DeleteGear()
        SetEnableScuba(GetPlayerPed(-1), false)
        SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
        currentGear.enabled = false
        ClearPedTasks(GetPlayerPed(-1))
		ESX.ShowNotification("Skinuli ste opremu za ronjenje!")
	end
end)

local Upaljeno = false

RegisterNetEvent('prodajoruzje:grebalica')
AddEventHandler('prodajoruzje:grebalica', function()
	SendNUIMessage({
		prikazi = true
	})
	SetNuiFocus(true, true)
	Upaljeno = true
	Citizen.CreateThread(function()
		while Upaljeno do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
	end)
end)

RegisterNUICallback(
    "kraj",
    function(data, cb)
		SetNuiFocus(false)
		TriggerServerEvent("prodajoruzje:KoiKuracJeOvo", data.broj)
    end
)

RegisterNUICallback(
    "vratik",
    function(data, cb)
		Upaljeno = false
    end
)

RegisterNetEvent('prodajoruzje:petarde')
AddEventHandler('prodajoruzje:petarde', function()
			local modele = "prop_cs_dildo_01"
			ESX.Streaming.RequestModel(modele)
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(modele), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 57005)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 145.0, 0.0, true, true, false, true, 1, true)
			local forceTypes = {
				MinForce = 0,
				MaxForceRot = 1,
				MinForce2 = 2,
				MaxForceRot2 = 3,
				ForceNoRot = 4,
				ForceRotPlusForce = 5
			}

			local forceType = forceTypes.MaxForceRot2
			local cor = GetEntityCoords(PlayerPedId())
			local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -8.0, 1.0 , -7.0)
			local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, cordsa.z-cor.z)
			local rotation = vector3(0.0, 0.0, 0.0)
			RequestAnimDict("weapons@projectile@")
			while not HasAnimDictLoaded("weapons@projectile@") do
				Citizen.Wait(1000)
			end
			Wait(500)
			TaskPlayAnim(PlayerPedId(),"weapons@projectile@", "throw_m_fb_stand", 8.0, -8, -1, 2, 0, 0, 0, 0)
			Wait(400)
			ClearPedTasks(PlayerPedId())
			DetachEntity(prop, true, false)
			ApplyForceToEntity(
				prop,
				forceType,
				direction,
				rotation,
				0,
				false,
				true,
				true,
				false,
				true
			)
			Wait(3000)
			cordsa = GetEntityCoords(prop)
			AddExplosion(
				cordsa.x, 
				cordsa.y, 
				cordsa.z, 
				18, 
				0.0, 
				true, 
				false, 
				false,
				false
			)
			DeleteEntity(prop)
end)

local skupljanje = vector3(59.282123565674, -774.98114013672, 17.823108673096)
local cprerada = vector3(2433.5622558594, 4968.9677734375, 42.347618103027)
local cijev = vector3(94.248916625977, 3755.9348144531, 40.77135848999)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local playerPed = GetPlayerPed(-1)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
		local hasExited = false
		if CurrentAction ~= nil then
			waitara = 0
			naso = 1
	  
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then
				if CurrentAction == 'menu_prerada' then
					OpenPreradaMenu()
				elseif CurrentAction == 'menu_skupljanje' then
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                    local vrime = GetGameTimer()
					while GetGameTimer()-vrime < 15000 do
						Wait(1)
						DisableAllControlActions()
					end
					ClearPedTasksImmediately(playerPed)
					local kordic = GetEntityCoords(playerPed)
					if not IsEntityDead(playerPed) and #(kordic-skupljanje) <= 5.0 then
						TriggerServerEvent("kraft:SkupiGa")
						ESX.ShowNotification("Dobili ste 1x zeljeza!")
						currentStation = 1
						currentPart    = 'Skupljanje'
						currentPartNum = 1
					end
					isInMarker = false
					HasAlreadyEnteredMarker = false
				elseif CurrentAction == 'menu_cijev' then
					OpenCijevMenu()
				end
				GUI.Time = GetGameTimer()
				CurrentAction = nil
			end
		end
		local coords    = GetEntityCoords(playerPed)
		
		if #(coords-cprerada) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, cprerada, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-cprerada) < 2.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Prerada'
			currentPartNum = 1
		end
		
		if #(coords-skupljanje) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, skupljanje, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-skupljanje) < 2.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Skupljanje'
			currentPartNum = 1
		end
		
		if #(coords-cijev) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, cijev, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-cijev) < 1.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Cijev'
			currentPartNum = 1
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
			waitara = 0
			naso = 1
			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('prodajoruzje:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('prodajoruzje:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('prodajoruzje:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
	
		if naso == 0 then
			waitara = 500
		end
	end
end)

AddEventHandler('prodajoruzje:hasEnteredMarker', function(station, part, partNum)
	if part == 'Prerada' then
		CurrentAction     = 'menu_prerada'
		CurrentActionMsg  = "Pritisnite E da otvorite menu prerade!"
		CurrentActionData = {}
	elseif part == 'Skupljanje' then
		CurrentAction     = 'menu_skupljanje'
		CurrentActionMsg  = "Pritisnite E da pocnete skupljati zeljezo!"
		CurrentActionData = {}
	elseif part == 'Cijev' then
		CurrentAction     = 'menu_cijev'
		CurrentActionMsg  = "Pritisnite E da otvorite menu!"
		CurrentActionData = {}
	end
end)

AddEventHandler('prodajoruzje:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

function OpenPreradaMenu()
    local elements = {}
    table.insert(elements, {label = 'Kundak za assault rifle (5 zeljeza)', value = "kkundak"})
	table.insert(elements, {label = 'Kundak za carbine rifle (10 zeljeza)', value = "ckundak"})
	table.insert(elements, {label = 'Kundak za special carbine (15 zeljeza)', value = "skundak"})
	table.insert(elements, {label = 'Kundak za SMG (4 zeljeza)', value = "smkundak"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'kraft_prerada',
      {
        title    = "Izaberite koji kundak zelite",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kraft:ProvjeriKolicinu', function(imal)
			  if imal then
					local itemic = data.current.value
					menu.close()
					ESX.ShowNotification("Zapoceli ste preradu zeljeza u kundak!")
					RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
					while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
						Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, -1, 17, 1.0, 0, 0, 0)
					local vrime = GetGameTimer()
					while GetGameTimer()-vrime < 15000 do
						Wait(1)
						DisableAllControlActions()
					end
					ClearPedTasksImmediately(PlayerPedId())
					local kordic = GetEntityCoords(PlayerPedId())
					if not IsEntityDead(PlayerPedId()) and #(kordic-cprerada) <= 5.0 then
						TriggerServerEvent("kraft:DajKundak", itemic)
						ESX.ShowNotification("Zavrsili ste preradu zeljeza u kundak!")
					end
					HasAlreadyEnteredMarker = false
			  else
					ESX.ShowNotification("Nemate dovoljno zeljeza ili nemate mjesta u inventoryju za kundak!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_prerada'
		CurrentActionMsg  = "Pritisnite E da otvorite menu prerade!"
		CurrentActionData = {}
      end
    )
end

function OpenCijevMenu()
    local elements = {}
    table.insert(elements, {label = 'Cijev za assault rifle ($5000)', value = "kcijev"})
	table.insert(elements, {label = 'Cijev za carbine rifle ($6000)', value = "ccijev"})
	table.insert(elements, {label = 'Cijev za special carbine ($7000)', value = "scijev"})
	table.insert(elements, {label = 'Cijev za smg ($4000)', value = "smcijev"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'kraft_cijev',
      {
        title    = "Izaberite koju cijev zelite",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kraft:ProvjeriKolicinu2', function(imal)
			  if imal then
					menu.close()
					CurrentAction     = 'menu_cijev'
					CurrentActionMsg  = "Pritisnite E da otvorite menu!"
					CurrentActionData = {}
					ESX.ShowNotification("Kupili ste cijev!")
			  else
					ESX.ShowNotification("Nemate dovoljno novca ili nemate mjesta u inventoryju za cijev!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_cijev'
		CurrentActionMsg  = "Pritisnite E da otvorite menu!"
		CurrentActionData = {}
      end
    )
end

RegisterNetEvent('prodajoruzje:SloziOruzje')
AddEventHandler('prodajoruzje:SloziOruzje', function(br)
	SendNUIMessage({
		prikazi2 = true,
		broj = br,
		ktijelo = true,
		kkundak = true,
		clip = true,
		kcijev = true
	})
	SetNuiFocus(true, true)
end)

RegisterNetEvent('prodajoruzje:AdminChat')
AddEventHandler('prodajoruzje:AdminChat', function(naslov, tekst)
	if perm == 1 then
		TriggerEvent('chat:addMessage', { args = { naslov, tekst } })
	end
end)

RegisterNetEvent('prodajoruzje:SetajChameSkin')
AddEventHandler('prodajoruzje:SetajChameSkin', function(sk, br)
	if br then
		if sk == 1 then
			local modelHash = GetHashKey("a_m_y_downtown_01")
			ESX.Streaming.RequestModel(modelHash, function()
				SetPlayerModel(PlayerId(), modelHash)
				SetModelAsNoLongerNeeded(modelHash)
				TriggerEvent('esx:restoreLoadout')
			end)
		else
			local modelHash = GetHashKey("csb_sol")
			ESX.Streaming.RequestModel(modelHash, function()
				SetPlayerModel(PlayerId(), modelHash)
				SetModelAsNoLongerNeeded(modelHash)
				TriggerEvent('esx:restoreLoadout')
			end)
		end
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end)
	end
end)

RegisterNUICallback(
    "slozi",
    function(data, cb)
		SendNUIMessage({
			prikazi2 = true,
			broj = data.broj
		})
		SetNuiFocus(false)
		TriggerServerEvent("prodajoruzje:KoiKuracJeOvo2", data.broj)
    end
)

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		if br == 1 then
			TriggerServerEvent("prodajoruzje:Upoznaj", data.args)
		end
    end
)

RegisterCommand("testpitanje2", function(source, args, rawCommandString)
	TriggerEvent("upit:OtvoriPitanje", "prodajoruzje", "Upit za posao", "Dali se zelite zaposliti kao vozac kamiona?")
end, false)

RegisterCommand("lc", function(source, args, rawCommandString)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local deri = true
		local veha = GetVehiclePedIsIn(PlayerPedId(), false)
		SetVehicleHandbrake(veha, true)
		while deri do
			if IsControlJustPressed(0, 71) then
				SetVehicleHandbrake(veha, false)
				deri = false
			end
			SetVehicleCurrentRpm(veha, 0.8)
			Wait(1)
		end
	else
		ESX.ShowNotification("Morate biti u vozilu!")
	end
end, false)

RegisterCommand("aduty", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if not aduty then
				aduty = true
				ESX.ShowNotification("Otisli ste na admin duznost!")
			else
				aduty = false
				ESX.ShowNotification("Otisli ste s admin duznosti!")
			end
			TriggerServerEvent("tagovi:staffTag", aduty)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

local beba = false

RegisterCommand("beba", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if not beba then
				beba = true
				local modelHash = GetHashKey("Baby")
				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			else
				beba = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0
					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)
				end)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("psate", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ESX.TriggerServerCallback('minute:DohvatiSate', function(elem)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sati_list', {
					title    = "Sati igraca",
					align    = 'top-left',
					elements = elem
				}, function(data, menu)
					menu.close()	
				end, function(data, menu)
					menu.close()
				end)
			end)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("ndv", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent("esx:deleteVehicle2")
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterNetEvent('esx:deleteVehicle2')
AddEventHandler('esx:deleteVehicle2', function()
    local vehicle   = ESX.Game.GetVehicleInDirection()
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
end)

RegisterCommand("obrisivatromet", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("ind_prop_firework_03")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("obrisikontenjer", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_contr_03b_ld")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				DeleteEntity(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("obrisikutiju", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_box_wood05a")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				DeleteEntity(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
				print(NewBin)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("aodg", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			--local playerIdx = GetPlayerFromServerId(tonumber(args[1]))
			--if playerIdx ~= -1 then
				if args[1] ~= nil and args[2] ~= nil then
					local razlog = table.concat(args, " ", 2)
					TriggerServerEvent("prodajoruzje:PosaljiAdmOdgovor", args[1], razlog)
					local playerName = GetPlayerName(PlayerId())
					TriggerServerEvent("prodajoruzje:SaljiInfoSvima", razlog, playerName, args[1])
					local komando = "/aodg "..args[1].." "..razlog
					TriggerServerEvent("DiscordBot:RegCmd", GetPlayerServerId(PlayerId()), komando)
				else
					name = "Admin"..":"
					message = "/aodg [ID igraca][Odgovor]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end	
			--else
				--ESX.ShowNotification("Igrac nije online!")
			--end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("mute", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			local minu = 0
			id = tonumber(args[1])
			minu = tonumber(args[2])
			if id ~= 0 and id ~= nil and minu ~= 0 and minu ~= nil then
				TriggerServerEvent("esx_rpchat:MuteGa", id, minu)
			else
				name = "Admin"..": "
				message = "/mute [id][minute]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("unmute", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("esx_rpchat:UnmuteGa", id)
			else
				name = "Admin"..": "
				message = "/unmute [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

local kucica = nil

RegisterCommand("testkucu", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if kucica == nil then
				local cord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
				local x,y,z = table.unpack(cord)
				local model = GetHashKey("lf_house_11_")
				RequestModel(model)
				kucica = CreateObject(model, x, y, z-1.6, true, true, false)
				FreezeEntityPosition(kucica, true)
				PlaceObjectOnGroundProperly(kucica)
				FreezeEntityPosition(PlayerPedId(), true)
				Citizen.CreateThread(function()
					while kucica ~= nil do
						if IsControlPressed(0, 32) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.0, 0.1, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 33) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.0, -0.1, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 34) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.1, 0.0, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 35) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, -0.1, 0.0, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 52) then
							local head = GetEntityHeading(kucica)
							SetEntityHeading(kucica, head+1.0)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 51) then
							local head = GetEntityHeading(kucica)
							SetEntityHeading(kucica, head-1.0)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlJustPressed(0, 191) then
							FreezeEntityPosition(PlayerPedId(), false)
							break
						end
						Citizen.Wait(10)
					end
				end)
			else
				ESX.Game.DeleteObject(kucica)
				kucica = nil
				FreezeEntityPosition(PlayerPedId(), false)
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("testumor", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			StatSetInt(GetHashKey('MP0_STAMINA'), tonumber(args[1]), true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

local FishRod = nil
RegisterCommand("teststap", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if FishRod == nil then
				local model = GetHashKey("prop_fishing_rod_01")
				RequestModel(model)
				
				while not HasModelLoaded(model) do
					Wait(1)
				end
				BoneID = GetPedBoneIndex(PlayerPedId(), 60309)
				FishRod = CreateObject(model,  1729.73,  6403.90,  34.56,  true,  true,  true)
				vX,vY,vZ = table.unpack(GetEntityCoords(PlayerPedId()))
				xRot, yRot, zRot = table.unpack(GetEntityRotation(PlayerPedId(),2))
				AttachEntityToEntity(FishRod,  PlayerPedId(),  BoneID, 0,0,0, 0,0,0,  false, false, false, false, 2, true)
				SetModelAsNoLongerNeeded(model)
				--FishRod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
			else
				DeleteEntity(FishRod)
				FishRod = nil
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

local trajeanim = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if FishRod ~= nil then
			if IsControlPressed(1, 24) then
				if not trajeanim then
					RequestAnimDict("amb@world_human_stand_fishing@idle_a")
					while not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a") do
						Citizen.Wait(1000)
					end
					TaskPlayAnim(PlayerPedId(),"amb@world_human_stand_fishing@idle_a","idle_b", 8.0, -8, -1, 2, 0, 0, 0, 0)
					trajeanim = true
				end
			else
				if trajeanim then
					RequestAnimDict("amb@world_human_stand_fishing@base")
					while not HasAnimDictLoaded("amb@world_human_stand_fishing@base") do
						Citizen.Wait(1000)
					end
					TaskPlayAnim(PlayerPedId(),"amb@world_human_stand_fishing@base","base", 8.0, -8, -1, 2, 0, 0, 0, 0)
					trajeanim = false
				end
			end
		end
	end
end)

RegisterCommand("testanim", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			RequestAnimDict(args[1])
			while not HasAnimDictLoaded(args[1]) do
				Citizen.Wait(1000)
			end
			TaskPlayAnim(PlayerPedId(),args[1],args[2], 8.0, -8, -1, 2, 0, 0, 0, 0)
			--TaskStartScenarioInPlace(PlayerPedId(), args[1], 0, true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("testscenario", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TaskStartScenarioInPlace(PlayerPedId(), args[1], 0, true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("dajmuskin", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("prodajoruzje:TestSkinaa", id)
			else
				name = "Admin"..":"
				message = "/dajmuskin [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("setskin", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("prodajoruzje:DajSkin", id)
			else
				name = "Admin"..":"
				message = "/setskin [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("oduzmisociety", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local ime = args[1]
			local broj = tonumber(args[2])
			if ime ~= nil and (args[2] ~= nil or args[2] ~= 0) then
				local soc = "society_"..ime
				TriggerServerEvent("ObrisiSociety", soc, broj)
			else
				name = "Admin"..":"
				message = "/oduzmisociety [Ime mafije][Iznos]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerClientEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("a", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
				if args[1] ~= nil then
					local playerName = GetPlayerName(PlayerId())
					TriggerServerEvent("prodajoruzje:PosaljiRadio2Server", table.concat(args, " "), playerName)
				else
					name = "System"..":"
					message = " /a [Poruka]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end	
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end) 

RegisterNetEvent('prodajoruzje:TestSkina')
AddEventHandler('prodajoruzje:TestSkina', function()
	SetPedComponentVariation(PlayerPedId(), 1, 0 ,0, 2)
end) 

RegisterNetEvent('prodajoruzje:EoTiSkinic')
AddEventHandler('prodajoruzje:EoTiSkinic', function()
	local model = "s_m_m_pilot_01"
	RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end) 

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RegisterCommand("sjedi", function(source, args, rawCommandString)
	local ped = PlayerPedId()
	local cord = GetEntityCoords(ped)
	local head = GetEntityHeading(ped)
	--TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", 0, true)
	
	ESX.Streaming.RequestAnimDict("anim@heists@prison_heistunfinished_biztarget_idle", function()
		TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistunfinished_biztarget_idle", "target_idle", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
	
	ESX.ShowNotification("Pritisnite X da se ustanete")
end, false)

RegisterCommand("prodajkokain", function(source, args, rawCommandString)
	local kol = args[1]
	local cijena = args[2]
	local t, distance = GetClosestPlayer()
	local igrac = GetPlayerServerId(t)
	if(distance ~= -1 and distance < 5) then
		if kol ~= nil and tonumber(kol) > 0 then
			if cijena ~= nil and tonumber(cijena) > 0 then
				TriggerServerEvent("prodajoruzje:Posalji3", tonumber(igrac), cijena, kol, GetPlayerServerId(PlayerId()))
			else
				name = "System"..":"
				message = " /prodajkokain [Kolicina (min 1)][Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " /prodajkokain [Kolicina (min 1)][Cijena (min 1$)]"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
		end
	else
		ESX.ShowNotification("Nema igraca blizu vas!")
	end
end, false)

RegisterCommand("prodajdrogu", function(source, args, rawCommandString)
	if ESX.PlayerData.job.name == "mafia" or ESX.PlayerData.job.name == "yakuza" or ESX.PlayerData.job.name == "cartel" or ESX.PlayerData.job.name == "britvasi" or ESX.PlayerData.job.name == "shelby" or ESX.PlayerData.job.name == "nomads" or ESX.PlayerData.job.name == "camorra" or ESX.PlayerData.job.name == "ballas" or ESX.PlayerData.job.name == "zemunski" then
		local kol = args[1]
		local cijena = args[2]
		local t, distance = GetClosestPlayer()
		local igrac = GetPlayerServerId(t)
		if(distance ~= -1 and distance < 5) then
			if kol ~= nil and tonumber(kol) > 0 then
				if cijena ~= nil and tonumber(cijena) > 0 then
					TriggerServerEvent("prodajoruzje:Posalji2", tonumber(igrac), cijena, kol, GetPlayerServerId(PlayerId()))
				else
					name = "System"..":"
					message = " /prodajdrogu [Kolicina (min 1)][Cijena (min 1$)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /prodajdrogu [Kolicina (min 1)][Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			ESX.ShowNotification("Nema igraca blizu vas!")
		end
	else
		ESX.ShowNotification("Niste clan mafije!")
	end
end, false)

RegisterCommand("prodajoruzje", function(source, args, rawCommandString)
	if ESX.PlayerData.job.name == "mafia" or ESX.PlayerData.job.name == "yakuza" or ESX.PlayerData.job.name == "cartel" or ESX.PlayerData.job.name == "britvasi" or ESX.PlayerData.job.name == "shelby" or ESX.PlayerData.job.name == "nomads" or ESX.PlayerData.job.name == "camorra" then
		local cijena = args[1]
		local t, distance = GetClosestPlayer()
		local igrac = GetPlayerServerId(t)
		if(distance ~= -1 and distance < 5) then
			if cijena ~= nil and tonumber(cijena) > 0 then
				local retval, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
				if retval == 1 then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("prodajoruzje:Posalji", tonumber(igrac), weaponHash, cijena, ammo, GetPlayerServerId(PlayerId()))
				ESX.ShowNotification("Ponudili ste igracu oruzje!")
				else
				ESX.ShowNotification("Nemate oruzje u ruci!")
				end
			else
				name = "System"..":"
				message = " /prodajoruzje [Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			ESX.ShowNotification("Nema igraca blizu vas!")
		end
	else
		ESX.ShowNotification("Niste clan mafije!")
	end
end, false)

RegisterCommand("prihvatikokain", function(source, args, rawCommandString)
	if Prodavac2 ~= nil then
		TriggerServerEvent("dajpro:oruzje3", GetPlayerServerId(PlayerId()), CijenaDroge, Kolicina, Prodavac2)
		CijenaDroge = 0
		Kolicina = 0
		Prodavac2 = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio kokain!")
	end
end, false)

RegisterCommand("prihvatidrogu", function(source, args, rawCommandString)
	if Prodavac2 ~= nil then
		TriggerServerEvent("dajpro:oruzje2", GetPlayerServerId(PlayerId()), CijenaDroge, Kolicina, Prodavac2)
		CijenaDroge = 0
		Kolicina = 0
		Prodavac2 = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio drogu!")
	end
end, false)

RegisterCommand("vtest", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false) , 1000000000)
			print("doso tu ")
			Citizen.CreateThread(function()
				while true do
					SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 500.0)
					Wait(0)
				end
			end)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("prihvatioruzje", function(source, args, rawCommandString)
	if Oruzje ~= nil then
		TriggerServerEvent("dajpro:oruzje", GetPlayerServerId(PlayerId()), DajImeOruzja(Oruzje), Cijena, Metci, Prodavac)
		Oruzje = nil
		Cijena = 0
		Metci = 0
		Prodavac = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio oruzje!")
	end
end, false)

function DajImeOruzja(hash)
	local ime = "Nema"
	if hash == -102323637 then
		ime = "WEAPON_BOTTLE"
	elseif hash == -1813897027 then
		ime = "WEAPON_GRENADE"
	elseif hash == 741814745 then
		ime = "WEAPON_STICKYBOMB"
	elseif hash == -494615257 then
		ime = "WEAPON_ASSAULTSHOTGUN"
	elseif hash == -1654528753 then
		ime = "WEAPON_BULLPUPSHOTGUN"
	elseif hash == 2017895192 then
		ime = "WEAPON_SAWNOFFSHOTGUN"
	elseif hash == 487013001 then
		ime = "WEAPON_PUMPSHOTGUN"
	elseif hash == 205991906 then
		ime = "WEAPON_HEAVYSNIPER"
	elseif hash == 100416529 then
		ime = "WEAPON_SNIPERRIFLE"
	elseif hash == -1357824103 then
		ime = "WEAPON_ADVANCEDRIFLE"
	elseif hash == -2084633992 then
		ime = "WEAPON_CARBINERIFLE"
	elseif hash == 2144741730 then
		ime = "WEAPON_COMBATMG"
	elseif hash == -1660422300 then
		ime = "WEAPON_MG"
	elseif hash == -270015777 then
		ime = "WEAPON_ASSAULTSMG"
	elseif hash == 736523883 then
		ime = "WEAPON_SMG"
	elseif hash == 324215364 then
		ime = "WEAPON_MICROSMG"
	elseif hash == 911657153 then
		ime = "WEAPON_STUNGUN"
	elseif hash == 584646201 then
		ime = "WEAPON_APPISTOL"
	elseif hash == -1716589765 then
		ime = "WEAPON_PISTOL50"
	elseif hash == 1593441988 then
		ime = "WEAPON_COMBATPISTOL"
	elseif hash == 453432689 then
		ime = "WEAPON_PISTOL"
	elseif hash == -1076751822 then
		ime = "WEAPON_SNSPISTOL"
	elseif hash == -1045183535 then
		ime = "WEAPON_REVOLVER"   
	elseif hash == -538741184 then   
		ime = "WEAPON_SWITCHBLADE"   
	elseif hash == 317205821 then    
		ime = "WEAPON_AUTOSHOTGUN"   
	elseif hash == -853065399 then   
		ime = "WEAPON_BATTLEAXE"   
	elseif hash == 125959754 then    
		ime = "WEAPON_COMPACTLAUNCHER"  
	elseif hash == -1121678507 then   
		ime = "WEAPON_MINISMG"    
	elseif hash == -1169823560 then    
		ime = "WEAPON_PIPEBOMB"    
	elseif hash == -1810795771 then    
		ime = "WEAPON_POOLCUE"    
	elseif hash == 419712736 then    
		ime = "WEAPON_WRENCH"   
	elseif hash == -1420407917 then   
		ime = "WEAPON_PROXMINE"   
	elseif hash == 1672152130 then    
		ime = "WEAPON_HOMINGLAUNCHER"    
	elseif hash == 3219281620 then    
		ime = "WEAPON_PISTOL_MK2"    
	elseif hash == 2024373456 then    
		ime = "WEAPON_SMG_MK2"   
	elseif hash == 961495388 then   
		ime = "WEAPON_ASSAULTRIFLE_MK2"
	elseif hash == -1074790547 then
		ime = "WEAPON_ASSAULTRIFLE"
	elseif hash == 4208062921 then   
		ime = "WEAPON_CARBINERIFLE_MK2"    
	elseif hash == 3686625920 then    
		ime = "WEAPON_COMBATMG_MK2"   
	elseif hash == 177293209 then    
		ime = "WEAPON_HEAVYSNIPER_MK2"    
	elseif hash == -1951375401 then    
		ime = "WEAPON_FLASHLIGHT"   
	elseif hash == 1198879012 then    
		ime = "WEAPON_FLAREGUN"    
	elseif hash == -581044007 then    
		ime = "WEAPON_MACHETE"   
	elseif hash == -619010992 then    
		ime = "WEAPON_MACHINEPISTOL"   
	elseif hash == -275439685 then
		ime = "WEAPON_DBSHOTGUN" 
	elseif hash == 1649403952 then   
		ime = "WEAPON_COMPACTRIFLE"   
	elseif hash == 171789620 then   
		ime = "WEAPON_COMBATPDW"  
	elseif hash == -771403250 then   
		ime = "WEAPON_HEAVYPISTOL"   
	elseif hash == -1063057011 then  
		ime = "WEAPON_SPECIALCARBINE"   
	elseif hash == -656458692 then   
		ime = "WEAPON_KNUCKLE"   
	elseif hash == -598887786 then   
		ime = "WEAPON_MARKSMANPISTOL"    
	elseif hash == 2132975508 then    
		ime = "WEAPON_BULLPUPRIFLE"    
	elseif hash == -1834847097 then   
		ime = "WEAPON_DAGGER"   
	elseif hash == 137902532 then   
		ime = "WEAPON_VINTAGEPISTOL"   
	elseif hash == 2138347493 then    
		ime = "WEAPON_FIREWORK"   
	elseif hash == -1466123874 then   
		ime = "WEAPON_MUSKET"    
	elseif hash == 984333226 then    
		ime = "WEAPON_HEAVYSHOTGUN"  
	elseif hash == -952879014 then   
		ime = "WEAPON_MARKSMANRIFLE"   
	elseif hash == 1627465347 then 
		ime = "WEAPON_GUSENBERG"  
	elseif hash == -102973651 then   
		ime = "WEAPON_HATCHET" 
	elseif hash == 1834241177 then  
		ime = "WEAPON_RAILGUN"  
	elseif hash == 1119849093 then  
		ime = "WEAPON_MINIGUN"   
	elseif hash ==3415619887 then   
		ime = "WEAPON_REVOLVER_MK2"    
	elseif hash == 2548703416 then    
		ime = "WEAPON_DOUBLEACTION"  
	elseif hash ==2526821735 then   
		ime = "WEAPON_SPECIALCARBINE_MK2"    
	elseif hash == 2228681469 then   
		ime = "WEAPON_BULLPUPRIFLE_MK2"    
	elseif hash == 1432025498 then   
		ime = "WEAPON_PUMPSHOTGUN_MK2"
	elseif hash == 1785463520 then 
		ime = "WEAPON_MARKSMANRIFLE_MK2"
	end
	return ime
end

RegisterCommand('rpchat', function(source, args, rawCommand)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerServerEvent("PromjeniGlobal")
		end
	--end)
end, false)
	
RegisterCommand("uauto", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
			if closestVehicle ~= nil then
				if Distance <= 8.0 then
					NetworkRequestControlOfEntity(closestVehicle)
					TaskWarpPedIntoVehicle(PlayerPedId(), closestVehicle, -1)	
				end
			end
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)

RegisterCommand("dvi", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiBlizu()
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)

RegisterCommand("dvu", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiUnisten()
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)


RegisterCommand("brnace", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiBrnace()
		end
	--end)
end, false)

local a = GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDragCoeff')
local b = GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel')

RegisterCommand("testspeed", function(source, args, rawCommandString)
	local drag = 8
	local speed = 0.4
	if tonumber(args[1]) == 1 then
		drag = 8-2
		speed = 0.3
	elseif tonumber(args[1]) == 2 then
		drag = 8-4
		speed = 0.2
	elseif tonumber(args[1]) == 3 then
		drag = 8-6
		speed = 0.1
	elseif tonumber(args[1]) == 4 then
		drag = 0
		speed = 0.0
	end
	local br = a+drag
	local br2 = b-(b*speed)
	print(GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDragCoeff'))
	--SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel',139.20) --stage 3 -20.0
	--SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel',129.20) --stage 2 -10.0
	--SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel', 119.20) --stage 1 -10.0
	SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDragCoeff', br) --stage 0 -10.0
	SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel', br2)
	--SetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveForce', 0.24) --stage 0 -10.0
	ModifyVehicleTopSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 16.11)
	print(GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDragCoeff'))
end, false)

RegisterCommand("resetstage", function(source, args, rawCommandString)
	a = GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDragCoeff')
	b = GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), 'CHandlingData', 'fInitialDriveMaxFlatVel')
	print(a)
end, false)

RegisterCommand("guma", function(source, args, rawCommandString)
	local playerVehe = GetVehiclePedIsIn(PlayerPedId(), false)
	--SetVehicleFixed(playerVeh)
	print("aaaa")
	SetVehicleDeformationFixed(playerVehe)
	Wait(500)
	if tonumber(args[1]) == 0 then
		SetVehicleWheelXOffset(playerVeh, 1, -1500)
		SetVehicleWheelXOffset(playerVeh, 2, -1500)
		SetVehicleWheelXOffset(playerVeh, 3, -1500)
	elseif tonumber(args[1]) == 1 then
		SetVehicleWheelXOffset(playerVeh, 2, -1500)
		SetVehicleWheelXOffset(playerVeh, 3, -1500)
	elseif tonumber(args[1]) == 2 then
		SetVehicleWheelXOffset(playerVeh, 3, -1500)
	end
end, false)

RegisterCommand("testdamage", function(source, args, rawCommandString)
	local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleDoorBroken(playerVeh, 0, true)
	SetVehicleDoorBroken(playerVeh, 1, true)
	SetVehicleDoorBroken(playerVeh, 2, true)
	SetVehicleDoorBroken(playerVeh, 3, true)
	SetVehicleDoorBroken(playerVeh, 4, true)
	SetVehicleDoorBroken(playerVeh, 5, true)
	SetVehicleDoorBroken(playerVeh, 6, true)
	SetVehicleDoorBroken(playerVeh, 7, true)
	SetVehicleWheelXOffset(playerVeh, 0, -1500)
	SetVehicleWheelXOffset(playerVeh, 1, -1500)
	SetVehicleWheelXOffset(playerVeh, 2, -1500)
	SetVehicleWheelXOffset(playerVeh, 3, -1500)
end, false)

local objektic = nil
local off1, off2, off3, off4
local vrata = 0
RegisterCommand("spawnga", function(source, args, rawCommandString)
	local coords = vector3(2583.7958984375, 1771.0428466797, 32.378147125244)
	local head = 180.00
	local hashVehicule = "bmci"
	ESX.Streaming.RequestModel(hashVehicule)
	objektic = CreateVehicle(hashVehicule, coords, head, true, false)
	FreezeEntityPosition(objektic, true)
	SetEntityCollision(objektic, false, true)
	SetVehicleDoorBroken(objektic, 0, true)
	SetVehicleDoorBroken(objektic, 1, true)
	SetVehicleDoorBroken(objektic, 2, true)
	SetVehicleDoorBroken(objektic, 3, true)
	SetVehicleDoorBroken(objektic, 4, true)
	SetVehicleDoorBroken(objektic, 5, true)
	SetVehicleDoorBroken(objektic, 6, true)
	SetVehicleDoorBroken(objektic, 7, true)
	off1 = GetVehicleWheelXOffset(objektic, 0)
	off2 = GetVehicleWheelXOffset(objektic, 1)
	off3 = GetVehicleWheelXOffset(objektic, 2)
	off4 = GetVehicleWheelXOffset(objektic, 3)
	SetVehicleWheelXOffset(objektic, 0, -1500)
	SetVehicleWheelXOffset(objektic, 1, -1500)
	SetVehicleWheelXOffset(objektic, 2, -1500)
	SetVehicleWheelXOffset(objektic, 3, -1500)
	Citizen.CreateThread(function()
		while true do
			local coords2 = GetEntityCoords(objektic)
			local object = GetClosestObjectOfType(coords2, 10.0, GetHashKey('stt_prop_track_speedup'), false, false, false)
			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				SetEntityCoordsNoOffset(objektic, coords2.x, coords2.y, objCoords.z+0.5)
			end
			Citizen.Wait(2000)
		end
	end)
end, false)

local dict = "core"
local particleName = "ent_dst_electrical" --bul_stungun_metal ent_brk_sparking_wires ent_dst_electrical
local check
local gume = 0
RegisterCommand("prvidio", function(source, args, rawCommandString)
	Wait(5000)
	local coords = vector3(2583.7958984375, 1771.0428466797, 32.378147125244)
	local head = 180.00
	local hashVehicule = GetHashKey("bmci")
	ESX.Streaming.RequestModel(hashVehicule)
	objektic = CreateVehicle(hashVehicule, coords, head, true, false)
	SetVehicleDoorsLockedForAllPlayers(objektic, true)
	SetVehicleCustomPrimaryColour(objektic, 141, 141, 141)
	SetVehicleCustomSecondaryColour(objektic, 141, 141, 141)
	SetVehicleDirtLevel(objektic, 0.1)
	SetModelAsNoLongerNeeded(hashVehicule)
	FreezeEntityPosition(objektic, true)
	SetEntityCollision(objektic, false, true)
	SetVehicleDoorBroken(objektic, 0, true)
	SetVehicleDoorBroken(objektic, 1, true)
	SetVehicleDoorBroken(objektic, 2, true)
	SetVehicleDoorBroken(objektic, 3, true)
	SetVehicleDoorBroken(objektic, 4, true)
	SetVehicleDoorBroken(objektic, 5, true)
	SetVehicleDoorBroken(objektic, 6, true)
	SetVehicleDoorBroken(objektic, 7, true)
	off1 = GetVehicleWheelXOffset(objektic, 0)
	off2 = GetVehicleWheelXOffset(objektic, 1)
	off3 = GetVehicleWheelXOffset(objektic, 2)
	off4 = GetVehicleWheelXOffset(objektic, 3)
	SetVehicleWheelXOffset(objektic, 0, -1500)
	SetVehicleWheelXOffset(objektic, 1, -1500)
	SetVehicleWheelXOffset(objektic, 2, -1500)
	SetVehicleWheelXOffset(objektic, 3, -1500)
	Citizen.CreateThread(function()
		while true do
			local coords2 = GetEntityCoords(objektic)
			local object = GetClosestObjectOfType(coords2, 10.0, GetHashKey('stt_prop_track_speedup'), false, false, false)
			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				SetEntityCoordsNoOffset(objektic, coords2.x, coords2.y, objCoords.z+0.5)
			end
			Citizen.Wait(500)
		end
	end)
	coords = vector3(2583.8186035156, 1733.0377197266, 32.4089012146)
	local coords2 = GetEntityCoords(objektic)
	Citizen.CreateThread(function()
		-- Request the particle dictionary.
		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end
		local a = 0
		while #(coords-coords2) > 3.0 do
			Citizen.Wait(50)
			coords2 = GetEntityCoords(objektic)
			--SetVehicleForwardSpeed(objektic, 15.0)
			local korde = GetOffsetFromEntityInWorldCoords(objektic, 0.0, 0.1, 0.0)
			SetEntityCoordsNoOffset(objektic, korde)
			a=a+1
			if a%10 == 0 then
				UseParticleFxAssetNextCall(dict)
				-- Create a new non-looped particle effect, we don't need to store the particle handle because it will
				-- automatically get destroyed once the particle has finished it's animation (it's non-looped).
				StartNetworkedParticleFxNonLoopedOnEntity(particleName, objektic, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, 3.0, false, false, false)
			end
		end
		RemoveNamedPtfxAsset(dict)
		SetVehicleWheelXOffset(objektic, 0, -1500)
		SetVehicleWheelXOffset(objektic, 1, -1500)
		SetVehicleWheelXOffset(objektic, 2, -1500)
		SetVehicleWheelXOffset(objektic, 3, -1500)
		local broj = GetNumberOfVehicleDoors(objektic)
		local ad = "anim@heists@box_carry@"
		RequestAnimDict(ad)
		while not HasAnimDictLoaded(ad) do
			Citizen.Wait(1000)
		end
		for i = 0, broj-2 do
			local bagModel
			ESX.ShowNotification("Odite po dio od auta")
			local check = CreateCheckpoint(45, 2593.595703125, 1762.615234375, 28.540013122559, 0, 0, 0, 2.0, 50, 50, 204, 255)
			local korda2 = vector3(2593.595703125, 1762.615234375, 29.740013122559)
			local korda = GetEntityCoords(PlayerPedId())
			while #(korda-korda2) > 3 do
				Citizen.Wait(100)
				korda = GetEntityCoords(PlayerPedId())
			end
			DeleteCheckpoint(check)
			TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			if broj == 6 then
				if vrata > 3 then
					bagModel = 'prop_car_bonnet_01'
				else
					bagModel = 'prop_car_door_01'
				end
			else
				if vrata > 1 then
					bagModel = 'prop_car_bonnet_01'
				else
					bagModel = 'prop_car_door_01'
				end
			end
			local bagspawned = CreateObject(GetHashKey(bagModel), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(bagspawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.00, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
			ESX.ShowNotification("Pokupili ste dio auta")
			korda2 = vector3(2589.1394042969, 1738.6391601562, 29.740001678467)
			check = CreateCheckpoint(45, 2589.1394042969, 1738.6391601562, 28.540001678467, 0, 0, 0, 2.0, 50, 50, 204, 255)
			while #(korda-korda2) > 3 do
				Citizen.Wait(100)
				korda = GetEntityCoords(PlayerPedId())
			end
			ClearPedTasks(PlayerPedId())
			ESX.ShowNotification("Namontirali ste dio na auto")
			DeleteObject(bagspawned)
			DeleteCheckpoint(check)
			local veh = objektic
			SetVehicleFixed(veh)
			for j = 0, broj-2 do
				if j > vrata then
					SetVehicleDoorBroken(veh, j, true)
				end
			end
			vrata = vrata+1
		end
		RemoveAnimDict(ad)
		--drugi dio
		coords = vector3(2583.9887695312, 1684.3585205078, 30.209987640381)
		coords2 = GetEntityCoords(objektic)
		-- Request the particle dictionary.
		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end
		local a = 0
		while #(coords-coords2) > 3.0 do
			Citizen.Wait(50)
			coords2 = GetEntityCoords(objektic)
			--SetVehicleForwardSpeed(objektic, 15.0)
			local korde = GetOffsetFromEntityInWorldCoords(objektic, 0.0, 0.1, 0.0)
			SetEntityCoordsNoOffset(objektic, korde)
			a=a+1
			if a%10 == 0 then
				UseParticleFxAssetNextCall(dict)
				-- Create a new non-looped particle effect, we don't need to store the particle handle because it will
				-- automatically get destroyed once the particle has finished it's animation (it's non-looped).
				StartNetworkedParticleFxNonLoopedOnEntity(particleName, objektic, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, 3.0, false, false, false)
			end
		end
		RemoveNamedPtfxAsset(dict)
		Citizen.Wait(5000)
		--treci dio
		SetEntityCoords(PlayerPedId(), 2563.6135253906, 1600.9143066406, 29.299989700317)
		coords = vector3(2565.6665039062, 1586.4141845703, 30.228687286377)
		SetEntityCoordsNoOffset(objektic, coords)
		SetEntityHeading(objektic, 0.69)
		SetVehicleFixed(objektic)
		SetVehicleDirtLevel(objektic, 0.1)
		SetEntityCollision(objektic, true, true)
		FreezeEntityPosition(objektic, false)
		ActivatePhysics(objektic)
		local pos1, pos2, pos3, pos4
		local guma = GetEntityBoneIndexByName(objektic, "wheel_lf")
		pos1 = GetWorldPositionOfEntityBone(objektic, guma)
		guma = GetEntityBoneIndexByName(objektic, "wheel_rf")
		pos2 = GetWorldPositionOfEntityBone(objektic, guma)
		guma = GetEntityBoneIndexByName(objektic, "wheel_lr")
		pos3 = GetWorldPositionOfEntityBone(objektic, guma)
		guma = GetEntityBoneIndexByName(objektic, "wheel_rr")
		pos4 = GetWorldPositionOfEntityBone(objektic, guma)
		for i = 0, 3 do
			SetVehicleWheelXOffset(objektic, 0, -1500)
			SetVehicleWheelXOffset(objektic, 1, -1500)
			SetVehicleWheelXOffset(objektic, 2, -1500)
			SetVehicleWheelXOffset(objektic, 3, -1500)
		end
		local korda = GetEntityCoords(PlayerPedId())
		ad = "anim@heists@box_carry@"
		RequestAnimDict(ad)
		while not HasAnimDictLoaded(ad) do
			Citizen.Wait(1000)
		end
		for i = 0, 3 do
			ESX.ShowNotification("Odite po felgu.")
			check = CreateCheckpoint(45, 2554.818359375, 1588.7712402344, 30.048974990845, 0, 0, 0, 2.0, 50, 50, 204, 255)
			korda2 = vector3(2554.818359375, 1588.7712402344, 31.048974990845)
			while #(korda-korda2) > 3 do
				Citizen.Wait(100)
				korda = GetEntityCoords(PlayerPedId())
			end
			DeleteCheckpoint(check)
			TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			bagModel = 'prop_wheel_01'
			local bagspawned = CreateObject(GetHashKey(bagModel), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(bagspawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.00, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
			local pos
			local off
			if i == 0 then
				pos = pos1
				off = off1
			elseif i == 1 then
				pos = pos2
				off = off2
			elseif i == 2 then
				pos = pos3
				off = off3
			else
				pos = pos4
				off = off4
			end
			check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
			while #(korda-pos) > 3 do
				Citizen.Wait(100)
				korda = GetEntityCoords(PlayerPedId())
			end
			ClearPedTasks(PlayerPedId())
			DeleteObject(bagspawned)
			DeleteCheckpoint(check)
			SetVehicleWheelXOffset(objektic, i, off)
			ActivatePhysics(objektic)
			ESX.ShowNotification("Postavili ste felgu.")
		end
		RemoveAnimDict(ad)
		SetVehicleFixed(objektic)
		SetEntityCoords(PlayerPedId(), 2560.8967285156, 1747.6520996094, 29.169984817505)
		coords = vector3(2558.7841796875, 1753.4254150391, 28.599960327148)
		SetEntityCoordsNoOffset(objektic, coords)
		SetEntityHeading(objektic, 180.0)
		SetVehicleDirtLevel(objektic, 0.1)
		ESX.ShowNotification("Obojajte auto")
		local br = GetNumberOfVehicleDoors(objektic)
		if br == 6 then
			for i = 0, br-1 do
				if i == 0 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_dside_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 1 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_pside_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 2 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_dside_r"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 3 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_pside_r"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 4 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "bumper_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				else
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "platelight"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
					SetVehicleCustomPrimaryColour(objektic, 0, 162, 255)
					SetVehicleCustomSecondaryColour(objektic, 0, 162, 255)
				end
			end
		else
			for i = 0, br-1 do
				if i == 0 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_dside_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 1 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "door_pside_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				elseif i == 2 then
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "bumper_f"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
				else
					local pos = GetWorldPositionOfEntityBone(objektic, GetEntityBoneIndexByName(objektic, "platelight"))
					check = CreateCheckpoint(45, pos.x, pos.y, pos.z-1.0, 0, 0, 0, 1.0, 50, 50, 204, 255)
					korda = GetEntityCoords(PlayerPedId())
					while #(korda-pos) > 1 do
						Citizen.Wait(100)
						korda = GetEntityCoords(PlayerPedId())
					end
					DeleteCheckpoint(check)
					Sprejaj()
					SetVehicleCustomPrimaryColour(objektic, 0, 162, 255)
					SetVehicleCustomSecondaryColour(objektic, 0, 162, 255)
				end
			end
		end
		SetVehicleDirtLevel(objektic, 0.1)
		ESX.ShowNotification("Auto je spreman!")
		Citizen.Wait(10000)
		DeleteVehicle(objektic)
		objektic = nil
	end)
end, false)

function Sprejaj()
	FreezeEntityPosition(PlayerPedId(), true)
	local ped = PlayerPedId()
	local canPos = vector3(0.072, 0.041, -0.06)
	local canRot = vector3(33.0, 38.0, 0.0)
	local canObj = CreateObject(
		'ng_proc_spraycan01b',
		0.0, 0.0, 0.0,
		true, false, false
	)
	AttachEntityToEntity(
		canObj, ped, 
		GetPedBoneIndex(ped, 57005), 
		canPos.x, canPos.y, canPos.z, 
		canRot.x, canRot.y, canRot.z, 
		true, true, false, true, 1, true
	)
	RequestAnimDict('anim@amb@business@weed@weed_inspecting_lo_med_hi@')
	while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_lo_med_hi@') do
		Citizen.Wait(1000)
	end
	TaskPlayAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_spraybottle_stand_spraying_01_inspector', 1.0, 1.0, 10000, 16, 0, 0, 0, 0 )
	local a = 0
	local dict = "scr_recartheft"
	local name = "scr_wheel_burnout"
	while a < 2 do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local fwd = GetEntityForwardVector(ped)
		local coords = GetEntityCoords(ped) + fwd * 0.5 + vector3(0.0, 0.0, -0.5)

		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end

		local heading = GetEntityHeading(ped)

		UseParticleFxAssetNextCall(dict)
		SetParticleFxNonLoopedColour(0/255, 162/255, 255/255)
		SetParticleFxNonLoopedAlpha(1.0)
		local ptr = StartNetworkedParticleFxNonLoopedAtCoord(
			name, 
			coords.x, coords.y, coords.z + 2.0, 
			0.0, 0.0, heading, 
			0.7, 
			0.0, 0.0, 0.0
		)
		RemoveNamedPtfxAsset(dict)
		a = a + 1
		
		-- Wait 5000ms before triggering the next particle.
		Citizen.Wait(5000)
	end
	RemoveAnimDict('anim@amb@business@weed@weed_inspecting_lo_med_hi@')
	RemoveNamedPtfxAsset(dict)
	FreezeEntityPosition(PlayerPedId(), false)
	DeleteObject(canObj)
end
		
RegisterCommand("testspray", function(source, args, rawCommandString)
	local ped = PlayerPedId()
	local canPos = vector3(0.072, 0.041, -0.06)
	local canRot = vector3(33.0, 38.0, 0.0)
	local canObj = CreateObject(
		'ng_proc_spraycan01b',
		0.0, 0.0, 0.0,
		true, false, false
	)
	AttachEntityToEntity(
		canObj, ped, 
		GetPedBoneIndex(ped, 57005), 
		canPos.x, canPos.y, canPos.z, 
		canRot.x, canRot.y, canRot.z, 
		true, true, false, true, 1, true
	)
	RequestAnimDict('anim@amb@business@weed@weed_inspecting_lo_med_hi@')
	while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_lo_med_hi@') do
		Citizen.Wait(1000)
	end
    TaskPlayAnim(ped, 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_spraybottle_stand_spraying_01_inspector', 1.0, 1.0, 10000, 16, 0, 0, 0, 0 )
	local a = 0
	while a < 2 do
		Citizen.Wait(1000)
		local dict = "scr_recartheft"
		local name = "scr_wheel_burnout"
		
		local ped = PlayerPedId()
		local fwd = GetEntityForwardVector(ped)
		local coords = GetEntityCoords(ped) + fwd * 0.5 + vector3(0.0, 0.0, -0.5)

		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end

		local heading = GetEntityHeading(ped)

		UseParticleFxAssetNextCall(dict)
		SetParticleFxNonLoopedColour(61/255, 28/255, 152/255)
		SetParticleFxNonLoopedAlpha(1.0)
		local ptr = StartNetworkedParticleFxNonLoopedAtCoord(
			name, 
			coords.x, coords.y, coords.z + 2.0, 
			0.0, 0.0, heading, 
			0.7, 
			0.0, 0.0, 0.0
		)
		RemoveNamedPtfxAsset(dict)
		a = a + 1
		
		-- Wait 5000ms before triggering the next particle.
		Citizen.Wait(5000)
	end
	DeleteObject(canObj)
end, false)

RegisterCommand("drugidio", function(source, args, rawCommandString)
	local coords = vector3(2583.9887695312, 1684.3585205078, 30.209987640381)
	local coords2 = GetEntityCoords(objektic)
	Citizen.CreateThread(function()
		-- Request the particle dictionary.
		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end
		local a = 0
		while #(coords-coords2) > 3.0 do
			Citizen.Wait(50)
			coords2 = GetEntityCoords(objektic)
			--SetVehicleForwardSpeed(objektic, 15.0)
			local korde = GetOffsetFromEntityInWorldCoords(objektic, 0.0, 0.1, 0.0)
			SetEntityCoordsNoOffset(objektic, korde)
			a=a+1
			if a%10 == 0 then
				UseParticleFxAssetNextCall(dict)
				-- Create a new non-looped particle effect, we don't need to store the particle handle because it will
				-- automatically get destroyed once the particle has finished it's animation (it's non-looped).
				StartNetworkedParticleFxNonLoopedOnEntity(particleName, objektic, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, 3.0, false, false, false)
			end
		end
	end)
end, false)

RegisterCommand("trecidio", function(source, args, rawCommandString)
	local coords = vector3(2565.6665039062, 1586.4141845703, 30.228687286377)
	SetEntityCoordsNoOffset(objektic, coords)
	SetEntityHeading(objektic, 0.69)
	SetVehicleFixed(objektic)
	SetEntityCollision(objektic, true, true)
	FreezeEntityPosition(objektic, false)
	ActivatePhysics(objektic)
	SetVehicleWheelXOffset(objektic, 0, -1500)
	SetVehicleWheelXOffset(objektic, 1, -1500)
	SetVehicleWheelXOffset(objektic, 2, -1500)
	SetVehicleWheelXOffset(objektic, 3, -1500)
end, false)

RegisterCommand("trecidiog", function(source, args, rawCommandString)
	SetVehicleWheelXOffset(objektic, 0, off1)
	ActivatePhysics(objektic)
	Wait(5000)
	SetVehicleWheelXOffset(objektic, 1, off2)
	ActivatePhysics(objektic)
	Wait(5000)
	SetVehicleWheelXOffset(objektic, 2, off3)
	ActivatePhysics(objektic)
	Wait(5000)
	SetVehicleWheelXOffset(objektic, 3, off4)
	ActivatePhysics(objektic)
end, false)

RegisterCommand("cetvrtidio", function(source, args, rawCommandString)
	local coords = vector3(2558.7841796875, 1753.4254150391, 28.599960327148)
	SetEntityCoordsNoOffset(objektic, coords)
	SetEntityHeading(objektic, 180.0)
end, false)

RegisterCommand("part", function(source, args, rawCommandString)
	local dict = "core"
	local particleName = args[1]

	-- Create a new thread.
	Citizen.CreateThread(function()
		-- Request the particle dictionary.
		RequestNamedPtfxAsset(dict)
		-- Wait for the particle dictionary to load.
		while not HasNamedPtfxAssetLoaded(dict) do
			Citizen.Wait(0)
		end
		
		-- Get the position of the player, this will be used as the
		-- starting position of the particle effects.
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped, true))

		local a = 0
		while a < 5 do
			-- Tell the game that we want to use a specific dictionary for the next particle native.
			UseParticleFxAssetNextCall(dict)
			-- Create a new non-looped particle effect, we don't need to store the particle handle because it will
			-- automatically get destroyed once the particle has finished it's animation (it's non-looped).
			StartParticleFxNonLoopedAtCoord(particleName, 2558.7841796875, 1753.4254150391, 28.599960327148, 0.0, 0.0, 0.0, 1.0, false, false, false)
		
			a = a + 1
			
			-- Wait 500ms before triggering the next particle.
			Citizen.Wait(500)
		end
	end)
end, false)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function ObrisiBlizu()
	local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
	if closestVehicle ~= nil then
		if Distance <= 8.0 then
			local attempt = 0
			while not NetworkHasControlOfEntity(closestVehicle) and attempt < 100 and DoesEntityExist(closestVehicle) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(closestVehicle)
				attempt = attempt + 1
			end

			if DoesEntityExist(closestVehicle) and NetworkHasControlOfEntity(closestVehicle) then
				ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
					if odg ~= false then
						NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
						ESX.Game.DeleteObject(NetToObj(odg.Obj1))
						ESX.Game.DeleteObject(NetToObj(odg.Obj2))
						ESX.Game.DeleteObject(NetToObj(odg.Obj3))
						ESX.Game.DeleteVehicle(closestVehicle)
					else
						ESX.Game.DeleteVehicle(closestVehicle)
					end
				end, VehToNet(closestVehicle))
			end
		end
	end
end

function ObrisiUnisten()
	local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
	NetworkRequestControlOfEntity(closestVehicle)
	if closestVehicle ~= nil then
		if Distance <= 8.0 then
			if GetEntityHealth(closestVehicle) == 0 then
				ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
					if odg ~= false then
						NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
						ESX.Game.DeleteObject(NetToObj(odg.Obj1))
						ESX.Game.DeleteObject(NetToObj(odg.Obj2))
						ESX.Game.DeleteObject(NetToObj(odg.Obj3))
						SetEntityAsNoLongerNeeded(closestVehicle)
						ESX.Game.DeleteVehicle(closestVehicle)
					else
						SetEntityAsNoLongerNeeded(closestVehicle)
						ESX.Game.DeleteVehicle(closestVehicle)
					end
				end, VehToNet(closestVehicle))
            end				
		end
	end
end


function ObrisiBrnace()
    local ped = PlayerPedId()
    local coords = GetEntityCoords( ped )
	for veh in EnumerateVehicles() do
            if DoesEntityExist(veh) then
				local vcord = GetEntityCoords(veh)
				if GetDistanceBetweenCoords(coords, vcord, false) <= 5.0 then
					SetEntityAsNoLongerNeeded(veh)
					ESX.Game.DeleteVehicle(veh)
				end
			end
	end
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
	local player
    repeat
	  player = false
      for i = 0, 255 do
          if (id == GetPlayerPed(i)) then
            player = true
          end
      end
	  if not player then
        coroutine.yield(id)
	  end
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
		
RegisterNetEvent("prodajoruzje:PokaziClanove")
AddEventHandler('prodajoruzje:PokaziClanove', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Online clanovi",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PokaziLidere")
AddEventHandler('prodajoruzje:PokaziLidere', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Online lideri",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PokaziSveLidere")
AddEventHandler('prodajoruzje:PokaziSveLidere', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Svi lideri",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PosaljiRadio")
AddEventHandler('prodajoruzje:PosaljiRadio', function(odg, ime, posao)
	if ESX ~= nil then
		if ESX.PlayerData.job ~= nil then
			if ESX.PlayerData.job.name == posao then
				if ESX.PlayerData.job.name == "police" then
					TriggerEvent('chat:addMessage', {
								template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 51, 204, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[Policija] {0}:<br> {1}</div>',
								args = { ime, odg }
					})
				else
					TriggerEvent('chat:addMessage', {
								template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 51, 204, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[Mehanicari] {0}:<br> {1}</div>',
								args = { ime, odg }
					})
				end
			end
		end
	end
end)

RegisterNetEvent("prodajoruzje:VratiInfoSvima")
AddEventHandler('prodajoruzje:VratiInfoSvima', function(odg, ime, ime2)
	while ESX == nil do
		Wait(0)
	end
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(226, 109, 17, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[ADMIN ODGOVOR] {0} je odgovorio {1}: <br> {2}</div>',
						args = { ime, ime2, odg }
			})
		end
	--end)
end)

RegisterNetEvent("prodajoruzje:PosaljiRadio2")
AddEventHandler('prodajoruzje:PosaljiRadio2', function(odg, ime)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[ADMIN CHAT] {0}:<br> {1}</div>',
						args = { ime, odg }
			})
		end
	--end)
end)

RegisterNetEvent("prodajoruzje:VratiAdmOdgovor")
AddEventHandler('prodajoruzje:VratiAdmOdgovor', function(odg)
	TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 255, 97, 0.6); border-radius: 3px;"><i class="fas fa-user-shield"></i> {0}:<br> {1}</div>',
					args = { "Odgovor admina", odg }
	})
end)

RegisterNetEvent("prodajoruzje:Saljem3")
AddEventHandler('prodajoruzje:Saljem3', function(cijena, kol, pid)
	CijenaDroge = cijena
	Kolicina = kol
	Prodavac2 = pid
	local str = "Ukoliko zelite kupiti "..kol.."g kokaina za "..cijena.."$ upisite /prihvatikokain"
	ESX.ShowNotification(str)
end)

RegisterNetEvent("prodajoruzje:Saljem2")
AddEventHandler('prodajoruzje:Saljem2', function(cijena, kol, pid)
	CijenaDroge = cijena
	Kolicina = kol
	Prodavac2 = pid
	local str = "Ukoliko zelite kupiti "..kol.."g marihuane za "..cijena.."$ upisite /prihvatidrogu"
	ESX.ShowNotification(str)
end)

RegisterNetEvent("prodajoruzje:Saljem")
AddEventHandler('prodajoruzje:Saljem', function(oruzje, cijena, ammo, pid)
    Oruzje = oruzje
	Cijena = cijena
	Metci = ammo
	Prodavac = pid
	local label = ESX.GetWeaponLabel(DajImeOruzja(oruzje))
	local str = "Ukoliko zelite kupiti "..label.." sa "..Metci.." metaka za "..cijena.."$ upisite /prihvatioruzje"
	ESX.ShowNotification(str)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)
