local group = "user"
local states = {}
states.frozen = false
states.frozenPos = nil
local noclipEntity = nil
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if (IsControlJustPressed(1, 212) and IsControlJustPressed(1, 213)) then
			ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
				if br == 1 then
					SetNuiFocus(true, true)
					getPlayers(true)
				end
			end)
		end
	end
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" then
		TriggerServerEvent('es_admin:all', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)
local noclip = false

--test
RegisterNetEvent('es_admin:viewname')
AddEventHandler('es_admin:viewname', function(t)
	local xPlayers = ESX.Game.GetPlayers()
	for id=1, 255, 1 do
            if  NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then

                ped = GetPlayerPed( id )
                blip = GetBlipFromEntity( ped )
	        ida = GetPlayerServerId(id)

                -- HEAD DISPLAY STUFF --

                -- Create head display (this is safe to be spammed)
		local testic = GetPlayerName(id).." ("..ida..")"
                headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, testic, false, false, "", false )

                -- Speaking display
                if NetworkIsPlayerTalking( id ) then

                    Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, true ) -- Add speaking sprite

                else

                    Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, false ) -- Remove speaking sprite

                end

            end

        end
end)--test

RegisterNetEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(t, target, kord)
	if t == "slay" then SetEntityHealth(PlayerPedId(), 0) end
	if t == "goto" then SetPedCoordsKeepVehicle(PlayerPedId(), kord) end
	if t == "bring" then 
		states.frozenPos = kord
		SetPedCoordsKeepVehicle(PlayerPedId(), kord) 
	end
	if t == "crash" then 
		Citizen.Trace("Kreten od admina te crashao.\n")
		Citizen.CreateThread(function()
			while true do end
		end) 
	end
	if t == "slap" then ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
	if t == "noclip" then
		local msg = "ugasen"
		if(noclip == false)then
			noclip_pos = GetEntityCoords(PlayerPedId(), false)
		end

		noclip = not noclip

		if(noclip)then
			msg = "upaljen"
		end

		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip je ^2^*" .. msg)
	end
	if t == "freeze" then
		local player = PlayerId()

		local ped = PlayerPedId()

		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)

		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		else
			Citizen.Wait(200)
		end
	end
end)

function GetInputMode()
    return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end

local heading = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(noclip)then
			local currentSpeed = 2
			noclipEntity =
            IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
            FreezeEntityPosition(PlayerPedId(-1), true)
            SetEntityInvincible(PlayerPedId(-1), true)

            local newPos = GetEntityCoords(entity)

            DisableControlAction(0, 32, true)
            DisableControlAction(0, 268, true)

            DisableControlAction(0, 31, true)

            DisableControlAction(0, 269, true)
            DisableControlAction(0, 33, true)

            DisableControlAction(0, 266, true)
            DisableControlAction(0, 34, true)

            DisableControlAction(0, 30, true)

            DisableControlAction(0, 267, true)
            DisableControlAction(0, 35, true)

            DisableControlAction(0, 44, true)
            DisableControlAction(0, 20, true)

            local yoff = 0.0
            local zoff = 0.0

            if GetInputMode() == "MouseAndKeyboard" then
              if IsDisabledControlPressed(0, 32) then
                yoff = 0.5
              end
              if IsDisabledControlPressed(0, 33) then
                yoff = -0.5
              end
              if IsDisabledControlPressed(0, 34) then
                SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) + 3.0)
              end
              if IsDisabledControlPressed(0, 35) then
                SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) - 3.0)
              end
              if IsDisabledControlPressed(0, 27) then
                zoff = 0.21
              end
              if IsDisabledControlPressed(0, 173) then
                zoff = -0.21
              end
            end

            newPos =
            GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)

            SetEntityCollision(noclipEntity, false, false)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

            FreezeEntityPosition(noclipEntity, false)
            SetEntityInvincible(noclipEntity, false)
            --SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
	SetPedCoordsKeepVehicle(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:fix')
AddEventHandler('es_admin:fix', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		TriggerEvent("iens:repair")
		SetVehicleFixed(vehicle)
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Tvoje vozilo je popravljeno!")
	else
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Niste u vozilu!")
	end
end)

RegisterNetEvent('es_admin:clean')
AddEventHandler('es_admin:clean', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Vase vozilo je ocisceno!")
	else
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Niste u vozilu!")
	end
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "upaljen"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(not noclip)then
		msg = "ugasen"
		SetEntityCollision(noclipEntity, true, true)
		FreezeEntityPosition(PlayerPedId(-1), false)
        SetEntityInvincible(PlayerPedId(-1), false)
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip je ^2^*" .. msg)
end)

function getPlayers(br)
	ESX.TriggerServerCallback('es_admin:DohvatiIgrace', function(igraci)
		local players = {}
		for i=1, #igraci, 1 do
			table.insert(players, {id = igraci[i].ID, name = igraci[i].Ime})
		end
		if br then
			SendNUIMessage({type = 'open', players = players})
		else
			return players
		end
	end)
end
