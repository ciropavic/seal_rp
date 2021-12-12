ESX = nil
local lastSkin, playerLoaded, cam, isCameraActive
local firstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0
local Moze = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenMenu(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()
	TriggerEvent("NeKickaj", true)

	TriggerEvent('skinchanger:getSkin', function(skin)
		lastSkin = skin
	end)

	TriggerEvent('skinchanger:getData', function(components, maxVals)
		local elements    = {}
		local _components = {}

		-- Restrict menu
		if restrict == nil then
			for i=1, #components, 1 do
				_components[i] = components[i]
			end
		else
			for i=1, #components, 1 do
				local found = false

				for j=1, #restrict, 1 do
					if components[i].name == restrict[j] then
						found = true
					end
				end

				if found then
					table.insert(_components, components[i])
				end
			end
		end

		-- Insert elements
		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed, _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
				textureof = _components[i].textureof,
				zoomOffset= _components[i].zoomOffset,
				camOffset = _components[i].camOffset,
				type      = 'slider'
			}

			for k,v in pairs(maxVals) do
				if k == _components[i].name then
					data.max = v
					break
				end
			end

			table.insert(elements, data)
		end

		CreateSkinCam()
		zoomOffset = _components[1].zoomOffset
		camOffset = _components[1].camOffset

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
			title    = _U('skin_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerEvent('skinchanger:getSkin', function(skin)
				lastSkin = skin
			end)

			submitCb(data, menu)
			DeleteSkinCam()
		end, function(data, menu)
			menu.close()
			DeleteSkinCam()
			TriggerEvent('skinchanger:loadSkin', lastSkin)

			if cancelCb ~= nil then
				cancelCb(data, menu)
			end
		end, function(data, menu)
			local skin, components, maxVals

			TriggerEvent('skinchanger:getSkin', function(getSkin)
				skin = getSkin
			end)

			zoomOffset = data.current.zoomOffset
			camOffset = data.current.camOffset

			if skin[data.current.name] ~= data.current.value then
				-- Change skin element
				TriggerEvent('skinchanger:change', data.current.name, data.current.value)

				-- Update max values
				TriggerEvent('skinchanger:getData', function(comp, max)
					components, maxVals = comp, max
				end)

				local newData = {}

				for i=1, #elements, 1 do
					newData = {}
					newData.max = maxVals[elements[i].name]

					if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					end

					menu.update({name = elements[i].name}, newData)
				end
				
				menu.refresh()
			end
		end, function(data, menu)
			DeleteSkinCam()
		end)
	end)
end

function CreateSkinCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

	isCameraActive = true
	SetCamRot(cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
	TriggerEvent("NeKickaj", false)
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isCameraActive then
			DisableControlAction(2, 30, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 33, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 35, true)
			DisableControlAction(0, 25, true) -- Input Aim
			DisableControlAction(0, 24, true) -- Input Attack

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			local angle = heading * math.pi / 180.0
			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + (zoomOffset * theta.x),
				y = coords.y + (zoomOffset * theta.y)
			}

			local angleToLook = heading - 140.0
			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0
			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + (zoomOffset * thetaToLook.x),
				y = coords.y + (zoomOffset * thetaToLook.y)
			}

			SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
			PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

			ESX.ShowHelpNotification(_U('use_rotate_view'))
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local angle = 90

	while true do
		Citizen.Wait(0)

		if isCameraActive then
			if IsControlPressed(0, 108) then
				angle = angle - 1
			elseif IsControlPressed(0, 109) then
				angle = angle + 1
			end

			if angle > 360 then
				angle = angle - 360
			elseif angle < 0 then
				angle = angle + 360
			end

			heading = angle + 0.0
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		lastSkin = skin
	end)

	OpenMenu(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			DoScreenFadeOut(1)
			TriggerEvent("MakniHud", true)
			CreatePlane(-2598.599609375, -2432.763671875, 500.94445800782, 241.49998474122, "AIRP")
			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)

	end, cancelCb, restrict)
end

function CreatePlane(xa, ya, za, heading, destination)

	modelHash = GetHashKey("nimbus")
	pilotModel = GetHashKey("s_m_m_pilot_01")
	
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Citizen.Wait(0)
	end

	RequestModel(pilotModel)
	while not HasModelLoaded(pilotModel) do
		Citizen.Wait(0)
	end

	if HasModelLoaded(modelHash) and HasModelLoaded(pilotModel) then
		ClearAreaOfEverything(xa, ya, za, 1500, false, false, false, false, false)
		
		local spawnCoords  = {
						x = xa,
						y = ya,
						z = za
					}

		--AirPlane = CreateVehicle(modelHash, x, y, z-1.0, heading, true, false)
		ESX.Game.SpawnLocalVehicle(modelHash, spawnCoords, heading, function(AirPlane)
		SetVehicleEngineOn(AirPlane, true, true, true)
		SetEntityProofs(AirPlane, true, true, true, true, true, true, true, false)
		SetVehicleHasBeenOwnedByPlayer(AirPlane, true)

		pilot = CreatePedInsideVehicle(AirPlane, 6, pilotModel, -1, false, false)

		SetBlockingOfNonTemporaryEvents(pilot, true)

		totalSeats = GetVehicleModelNumberOfSeats(modelHash)
		--TaskWarpPedIntoVehicle(PlayerPedId(), AirPlane, 2)
		TaskWarpPedIntoVehicle(PlayerPedId(),  AirPlane,  2)

		SetModelAsNoLongerNeeded(modelHash)
		SetModelAsNoLongerNeeded(pilotModel)
		if destination == "DESRT" then
		TaskPlaneMission(pilot, AirPlane, 0, 0, -107.2212, 2717.5534, 61.9673, 4, GetVehicleModelMaxSpeed(modelHash), 1.0, 0.0, 10.0, 40.0)
		elseif destination == "AIRP" then
		--TaskVehicleDriveToCoordLongrange(pilot, AirPlane, 1403.0020751953, 2995.9179, 40.5507, GetVehicleModelMaxSpeed(modelHash), 16777216, 0.0)
		--Wait(5000)
		--TaskPlaneMission(pilot, AirPlane, 0, 0, -1571.5589, -556.7288, 114.4482, 4, GetVehicleModelMaxSpeed(modelHash), 1.0, 0.0, 5.0, 40.0)
		TaskPlaneLand(pilot, AirPlane, -1792.00122, -2882.29980, 13.9440+1.0001, -998.5266, -3341.3579, 13.9444+1.0001)
		SetPedKeepTask(pilot, true)
		end
		local lPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(lPed)
		local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
		local PrviCam = true
		local DrugiCam = true
		AttachCamToEntity(cam, AirPlane, -0.3,1.7,0.4, true)
		--AttachCamToEntity(cam, AirPlane, 0.0,-25.0,0.0, true)
		DoScreenFadeIn(500)
		SendNUIMessage({
					prikaziintro = true
					})
		Citizen.CreateThread(function()
		  while PrviCam == true do
			local retval = GetEntityRotation(AirPlane, 2)
			SetCamRot(cam, retval.x, retval.y, retval.z-17)
			--SetCamRot(cam, retval.x, retval.y, retval.z)
			RenderScriptCams(true, false, 0, 1, 0)
			DisableControlAction(0, 75, true)  				-- Disable exit vehicle
			DisableControlAction(27, 75, true) 				-- Disable exit vehicle
			Citizen.Wait(0)
		  end
		end)
		Wait(30000)
		PrviCam = false
		SendNUIMessage({
					zatvoriintro = true
					})
		AttachCamToEntity(cam, AirPlane, 0.0,-25.0,0.6, true)
		Citizen.CreateThread(function()
		  while DrugiCam == true do
			local retval = GetEntityRotation(AirPlane, 2)
			--SetCamRot(cam, retval.x, retval.y, retval.z-17)
			SetCamRot(cam, retval.x, retval.y, retval.z)
			RenderScriptCams(true, false, 0, 1, 0)
			DisableControlAction(0, 75, true)  				-- Disable exit vehicle
			DisableControlAction(27, 75, true) 				-- Disable exit vehicle
			Citizen.Wait(0)
		  end
		end)
		Wait(30000)
		DrugiCam = false
		DoScreenFadeOut(1)
		RenderScriptCams(false, false, 0, 1, 0)
		RemovePedElegantly(pilot)
		ESX.Game.DeleteVehicle(AirPlane)
		SetEntityCoords(GetPlayerPed(-1), -1036.5201416016, -2731.6596679688, 13.756643295288, 1, 0, 0, 1)
		SetEntityHeading(GetPlayerPed(-1), 329.84741210938)
		TriggerEvent("MakniHud", false)
		DoScreenFadeIn(500)
		TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 113, 0, 0.6); border-radius: 3px;"><i class="fas fa-info"></i> {0}:<br> {1}</div>',
            args = { "Server", "Za vise informacija oko komandi, tipki i pravila upisite /help" }
		})
		--SetCamRot(cam, 0.0,0.0,GetEntityHeading(AirPlane))
		--RenderScriptCams(true, false, 0, 1, 0)
		end)
	end
end

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not playerLoaded do
			Citizen.Wait(100)
		end

		if firstSpawn then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
						local characterModel
						characterModel = GetHashKey('mp_m_freemode_01')

						RequestModel(characterModel)

						Citizen.CreateThread(function()
							while not HasModelLoaded(characterModel) do
								RequestModel(characterModel)
								Citizen.Wait(0)
							end

							if IsModelValid(characterModel) then
								SetPlayerModel(PlayerId(), characterModel)
								SetPedDefaultComponentVariation(PlayerPedId())
							end

							SetModelAsNoLongerNeeded(characterModel)
						end)
						--TriggerEvent('skinchanger:loadDefaultModel', true, cb)
						--TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					SendNUIMessage({
						prikazispawn = true
					})
					SetNuiFocus(true, true)
				end
			end)
			firstSpawn = false
		end
	end)
end)

RegisterNUICallback('spawn', function(data, cb)
	cb('ok')
	local br = data.izbor
	if br == 1 then
		print("Spawn na spawnu")
	elseif br == 2 then
		print("Spawn u orgi")
	elseif br == 3 then
		print("Spawn u kuci")
	else
		local PlayerData = ESX.GetPlayerData()
		if PlayerData.lastPosition then
			SetEntityCoords(PlayerPedId(), PlayerData.lastPosition.x, PlayerData.lastPosition.y, PlayerData.lastPosition.z)
		end
		ESX.ShowNotification("Izabrali ste spawn na posljednjoj lokaciji.")
		SendNUIMessage({
			zatvorispawn = true
		})
		SetNuiFocus(false)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
	cb(lastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	lastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	local characterModel
	characterModel = GetHashKey('mp_m_freemode_01')

	RequestModel(characterModel)

	Citizen.CreateThread(function()
		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end

		if IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(PlayerPedId())
		end

		SetModelAsNoLongerNeeded(characterModel)
	end)
	OpenSaveableMenu(submitCb, cancelCb, nil)
	Moze = true
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:responseSaveSkin', skin)
	end)
end)
