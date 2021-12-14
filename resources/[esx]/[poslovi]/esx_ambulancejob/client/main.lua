Keys = {
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

local FirstSpawn, PlayerLoaded = true, false
local NemojUmrijet = false
local NemojOdbrojavat = 0
local poslao = 0
local Glava = true

IsDead = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

parts = {
    ['RFoot'] = 52301,
    ['LFoot'] = 14201,
    ['RHand'] = 57005,
    ['LHand'] = 18905,
    ['RKnee'] = 36864,
    ['LKnee'] = 63931,
    ['Head'] = 31086,
    ['Neck'] = 39317,
    ['RArm'] = 28252,
    ['LArn'] = 61163,
    ['Chest'] = 24818,
    ['Pelvis'] = 11816,
    ['RShoulder'] = 40269,
    ['LShoulder'] = 45509,
    ['RWrist'] = 28422,
    ['LWrist'] = 60309,
    ['Tounge'] = 47495,
    ['UpperLip'] = 20178,
    ['LowerLip'] = 17188,
    ['RThigh'] = 51826,
    ['LThigh'] = 58217,
}

function GetKeyOfValue(Table, SearchedFor)
    for Key, Value in pairs(Table) do
        if SearchedFor == Value then
            return Key
        end
    end
    return nil
end

RegisterNetEvent('glava:NemojGa')
AddEventHandler('glava:NemojGa', function(br)
	Glava = br
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_ambulancejob:PostaviGa')
AddEventHandler('esx_ambulancejob:PostaviGa', function(ata)
	NemojUmrijet = ata
end)

AddEventHandler('playerSpawned', function()
		IsDead = false

		if FirstSpawn then
			exports.spawnmanager:setAutoSpawn(false) -- disable respawn
			FirstSpawn = false

			if Config.AntiCombatLog then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end

				ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
					if shouldDie then
						ESX.ShowNotification(_U('combatlog_message'))
						RemoveItemsAfterRPDeath()
					end
				end)
			end
			Wait(5000)
			Glava = false
		end
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NemojUmrijet == false then
			if IsDead then
				DisableAllControlActions(0)
				EnableControlAction(0, Keys['G'], true)
				EnableControlAction(0, Keys['T'], true)
				EnableControlAction(0, Keys['E'], true)
				EnableControlAction(0, Keys['N'], true)
				EnableControlAction(0, Keys['F7'], true)
			else
				Citizen.Wait(500)
			end
		end
	end
end)

function OnPlayerDeath()
	if NemojUmrijet == false then
		local koord = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(koord, 3097.6840820313, -4800.4282226563, 2.0371627807617, false) <= 300 then
			RemoveItemsAfterRPDeath()
		else
			IsDead = true
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

			StartDeathTimer()
			StartDistressSignal()

			ClearPedTasksImmediately(GetPlayerPed(-1))
			StartScreenEffect('DeathFailOut', 0, false)
		end
	end
end

RegisterNetEvent('esx_ambulancejob:NemojOdbrojavat')
AddEventHandler('esx_ambulancejob:NemojOdbrojavat', function(br)
	NemojOdbrojavat = br
end)

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
	
			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer
		UpaliF7()
		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)
			if IsControlPressed(0, Keys['G']) then
				SendDistressSignal()
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if IsDead and NemojOdbrojavat == 0 then
						StartDistressSignal()
					end
				end)
				break
			end
		end
	end)
end

function UpaliF7()
	Citizen.CreateThread(function()
		local vrime = 0
		while IsDead do
			Citizen.Wait(2)
			if vrime > 0 then
				vrime = vrime-1
			end
			if IsControlPressed(0, Keys['F7']) and vrime == 0 then
				vrime = 2000
				ClearPedTasksImmediately(PlayerPedId())
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	PedPosition = GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	ESX.ShowNotification(_U('distress_sent'))
	TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', _U('distress_message'), PlayerCoords, {

	PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end
	
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}
	--[[RespawnPed2(playerPed, formattedCoords, 0.0)
	
	RequestAnimDict("dead")
	while not HasAnimDictLoaded("dead") do
		Citizen.Wait(100)
	end
	TaskPlayAnim(playerPed, "dead", "dead_e", 1.0, 0.0, -1, 9, 9, 1, 1, 1)
	GivePlayerRagdollControl(PlayerId(), false)
	Citizen.CreateThread(function()
		while IsDead do
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance < 10.0 then
				TaskPlayAnim(playerPed, "dead", "dead_e", 1.0, 0.0, -1, 9, 9, 1, 1, 1)
			end
			Citizen.Wait(1000)
		end
	end)]]

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead and NemojOdbrojavat == 0 do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead and NemojOdbrojavat == 0 do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead and NemojOdbrojavat == 0 do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead and NemojOdbrojavat == 0 do
			Citizen.Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, Keys['E']) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, Keys['E']) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
			
		if bleedoutTimer < 1 and IsDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

RegisterNetEvent('esx_hitna:umrisine')
AddEventHandler('esx_hitna:umrisine', function()
	RemoveItemsAfterRPDeath()
end)

local kamerica = nil
local kamerica2 = nil
local lijesic = nil
local voza = nil
local pilot = nil
local nkamera = nil
local nkamera2 = nil
local Pedovi = {}

local peds = {
	{ped = "s_m_m_highsec_02", x = -1760.3403320313, y = -262.24594116211, z = 49.120899200439, h = 65.8},
	{ped = "s_m_m_highsec_01", x = -1761.0487060547, y = -263.23056030273, z = 48.968826293945, h = 65.7},
	{ped = "s_f_y_clubbar_01", x = -1761.6750488281, y = -264.23788452148, z = 48.834083557129, h = 65.9},
	{ped = "s_m_m_movprem_01", x = -1762.3959960938, y = -265.20248413086, z = 48.711822509766, h = 65.8},
	{ped = "ig_djtalaurelia", x = -1765.60546875, y = -263.4482421875, z = 48.967601776123, h = 238.8},
	{ped = "u_f_m_promourn_01", x = -1764.8334960938, y = -262.40744018555, z = 49.061019897461, h = 238.7},
	{ped = "ig_sol", x = -1764.2279052734, y = -261.53298950195, z = 49.153144836426, h = 238.9},
	{ped = "u_f_y_jewelass_01", x = -1763.6989746094, y = -260.55987548828, z = 49.25745010376, h = 238.8},
	{ped = "ig_priest", x = -1764.6151123047, y = -265.59930419922, z = 48.620185852051, h = 328.58782958984}
}

function RemoveItemsAfterRPDeath()
	IsDead = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('ambulanta:kradenakonsmrti', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)
			ESX.SetPlayerData('loadout', {})

			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)

			StopScreenEffect('DeathFailOut')
			local hashVehicule = "romero"
			local pilotModel = GetHashKey("s_m_m_highsec_01")
			RequestModel(pilotModel)
			while not HasModelLoaded(pilotModel) do
				Citizen.Wait(0)
			end
			if HasModelLoaded(pilotModel) then
				local ped = PlayerPedId()
				SetEntityCoords(ped, -1769.68359375, -269.84204101563, 47.151058197021)
				FreezeEntityPosition(ped, true)
				SetEntityInvincible(ped, true)
				SetEntityCollision(ped, false, false)
				SetEntityVisible(ped, false)
				ESX.Streaming.RequestModel(hashVehicule)
				local retval = GetHashKey(hashVehicule)
				voza = CreateVehicle(hashVehicule, -1721.3801269531, -254.02830505371, 50.666568756104, 125.25465393066, false, false)
				SetVehicleEngineOn(voza, true, true, false)
				pilot = CreatePedInsideVehicle(voza, 6, pilotModel, -1, false, false)
				--TaskWarpPedIntoVehicle(ped,  voza,  0)
				SetVehicleDoorsLocked(voza, 4)
				TaskVehicleDriveToCoord(pilot, voza, -1753.0358886719, -270.93640136719, 48.004440307617, 5.0, 0, GetEntityModel(voza), 411, 1.0, true)
				SetPedKeepTask(pilot, true)
				nkamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1737.732, -262.9628, 58.68971, -20.62686, -0, -61.17438, 50.0, true, 2)
				RenderScriptCams(true, false, 0, 1, 0)
				nkamera2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1767.425, -275.9615, 53.68555, -10.29001, -0, -68.77937, 50.0, true, 2)
				SetCamActiveWithInterp(nkamera2, nkamera, 10000, 1, 1)
				DoScreenFadeIn(800)
				SetModelAsNoLongerNeeded(pilotModel)
				SetModelAsNoLongerNeeded(retval)
				Wait(12000)
				DoScreenFadeOut(800)

				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				local kolica = GetClosestObjectOfType(-1763.0450439453, -262.83541870117, 47.250373840332, 5.0, 1430257647, false, false, false)
				ESX.Game.DeleteObject(kolica)
				ESX.Game.SpawnLocalObject('prop_coffin_01', {
					x = -1763.0450439453,
					y = -262.83541870117,
					z = 47.250373840332
					}, function(obj)
					SetEntityHeading(obj, 330.0)
					PlaceObjectOnGroundProperly(obj)
					lijesic = obj
				end)
				for i=1, #peds, 1 do
					if DoesEntityExist(Pedovi[i]) then
						DeleteEntity(Pedovi[i])
					end
					local model = RequestModel(peds[i].ped)
					while not HasModelLoaded(peds[i].ped) do
						Wait(1)
					end
					Pedovi[i] = CreatePed(5, model, peds[i].x, peds[i].y, peds[i].z , peds[i].h, false, true)
					SetModelAsNoLongerNeeded(model)
					if i % 2 == 0 then 
						ESX.Streaming.RequestAnimDict("random@car_thief@agitated@idle_a", function()
							TaskPlayAnim(Pedovi[i], "random@car_thief@agitated@idle_a", "agitated_idle_a", 4.0, 1.0, -1, 49, 0, 0, 0, 0 )
						end)
						RemoveAnimDict("random@car_thief@agitated@idle_a")
					else
						if i ~= 9 then
							ESX.Streaming.RequestAnimDict("anim@mp_player_intupperface_palm", function()
								TaskPlayAnim(Pedovi[i], "anim@mp_player_intupperface_palm", "idle_a", 4.0, 1.0, -1, 49, 0, 0, 0, 0 )
							end)
							RemoveAnimDict("anim@mp_player_intupperface_palm")
						end
					end
					Wait(150)
				end
				Wait(400)
				kamerica = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1769.119, -269.359, 53.06057, -29.02936, -2.561321e-06, -42.33167, 50.0, true, 2)
				RenderScriptCams(true, false, 0, 1, 0)
				DoScreenFadeIn(800)
				Wait(2000)
				kamerica2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1764.959, -266.1406, 50.16794, -25.86417, -0, -32.42023, 50.000003814697, true, 2)
				SetCamActiveWithInterp(kamerica2, kamerica, 5000, 1, 1)
				Wait(10000)
				DoScreenFadeOut(800)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				RemovePedElegantly(pilot)
				pilot = nil
				ESX.Game.DeleteVehicle(voza)
				voza = nil
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(nkamera, true)
				DestroyCam(nkamera2, true)
				nkamera = nil
				nkamera2 = nil
				ESX.Game.DeleteObject(lijesic)
				lijesic = nil
				DestroyCam(kamerica, true)
				DestroyCam(kamerica2, true)
				kamerica = nil
				kamerica2 = nil
				for i=1, #peds, 1 do
					if DoesEntityExist(Pedovi[i]) then
						DeleteEntity(Pedovi[i])
					end
				end
				FreezeEntityPosition(ped, false)
				SetEntityInvincible(ped, false)
				SetEntityCollision(ped, true, true)
				SetEntityVisible(ped, true)
				SetEntityCoordsNoOffset(ped, Config.RespawnPoint.coords.x, Config.RespawnPoint.coords.y, Config.RespawnPoint.coords.z, false, false, false, true)
				SetEntityHeading(ped, Config.RespawnPoint.heading)
				DoScreenFadeIn(800)
			end
		end)
	end)
	IsDead = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	
	RemoveAllPedWeapons(ped, false)
	TriggerEvent('esx:restoreLoadout')

	ESX.UI.Menu.CloseAll()
end

function RespawnPed2(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if NemojUmrijet == false then
		OnPlayerDeath()
	end
end)


RegisterNetEvent('ambu:ozivi')
AddEventHandler('ambu:ozivi', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerEvent("pullout:PostaviGa", false)

	isDead = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)

	TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		
	TriggerEvent("esx_policejob:Mrtav", 0)

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end