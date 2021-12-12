
local isLoadoutLoaded, isPaused, isPlayerSpawned, isDead = false, false, false, false
local lastLoadout, pickups = {}, {}
local NeOtvaraj = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
	
	-- check if player is coming from loading screen
	if GetEntityModel(PlayerPedId()) == GetHashKey('PLAYER_ZERO') then
		local defaultModel = GetHashKey('mp_m_freemode_01')
		RequestModel(defaultModel)

		while not HasModelLoaded(defaultModel) do
			Citizen.Wait(100)
		end

		SetPlayerModel(PlayerId(), defaultModel)
		local playerPed = PlayerPedId()

		SetPedDefaultComponentVariation(playerPed)
		SetPedRandomComponentVariation(playerPed, true)
		SetModelAsNoLongerNeeded(defaultModel)
		FreezeEntityPosition(playerPed, false)
	end

	if Config.EnableHud then
		for i=1, #xPlayer.accounts, 1 do
			local accountTpl = '<div><img src="img/accounts/' .. xPlayer.accounts[i].name .. '.png"/>&nbsp;{{money}}</div>'

			ESX.UI.HUD.RegisterElement('account_' .. xPlayer.accounts[i].name, i-1, 0, accountTpl, {
				money = 0
			})

			ESX.UI.HUD.UpdateElement('account_' .. xPlayer.accounts[i].name, {
				money = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
			})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if xPlayer.job.grade_label == '' then
			jobTpl = '<div>{{job_label}}</div>'
		end

		ESX.UI.HUD.RegisterElement('job', #xPlayer.accounts, 0, jobTpl, {
			job_label   = '',
			grade_label = ''
		})

		ESX.UI.HUD.UpdateElement('job', {
			job_label   = xPlayer.job.label,
			grade_label = xPlayer.job.grade_label
		})
	else
		TriggerEvent('es:setMoneyDisplay', 0.0)
	end
end)

RegisterNetEvent('esx:JelImasTorbu')
AddEventHandler('esx:JelImasTorbu', function(src, type, itemName, itemCount)
	local torba = 0
	TriggerEvent('skinchanger:getSkin', function(skin)
		torba = skin['bags_1']
	end)
	if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
		TriggerServerEvent("esx:DajTajItem", src, type, itemName, itemCount, true)
	else
		TriggerServerEvent("esx:DajTajItem", src, type, itemName, itemCount, false)
	end
end)

AddEventHandler('playerSpawned', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	-- Restore position
	if ESX.PlayerData.lastPosition then
		SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z)
	end

	TriggerEvent('esx:restoreLoadout') -- restore loadout
	TriggerEvent('markeri:OdradioSpawn')

	isLoadoutLoaded = true
	isPlayerSpawned = true
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	if not NeOtvaraj then
		isDead = true
	end
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	isLoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	ESX.TriggerServerCallback('esx:getPlayerData', function(data)
		local loadout = data.loadout
		for i=1, #loadout, 1 do
			local weaponName = loadout[i].name
			local weaponHash = GetHashKey(weaponName)

			GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
			local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

			for j=1, #loadout[i].components, 1 do
				local weaponComponent = loadout[i].components[j]
				local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end

			if not ammoTypes[ammoType] then
				AddAmmoToPed(playerPed, weaponHash, loadout[i].ammo)
				ammoTypes[ammoType] = true
			end
		end
		isLoadoutLoaded = true
	end)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			ESX.PlayerData.inventory[i] = item
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(true, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:OduzmiTuljanuIzInva')
AddEventHandler('esx:OduzmiTuljanuIzInva', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			ESX.PlayerData.inventory[i] = item
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setFirma')
AddEventHandler('esx:setFirma', function(job)
	ESX.PlayerData.firma = job
end)

RegisterNetEvent('esx:setPosao')
AddEventHandler('esx:setPosao', function(job)
	ESX.PlayerData.posao = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)


RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
	end)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, player, koords)
	local coords = vector3(koords.x, koords.y, koords.z)
	ESX.Game.SpawnLocalObject('prop_money_bag_01', coords, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)

		pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = coords
		}
	end)
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	if pickups[id] and pickups[id].obj then
		ESX.Game.DeleteObject(pickups[id].obj)
		pickups[id] = nil
	end
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
					if odg ~= false then
						NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
						ESX.Game.DeleteObject(NetToObj(odg.Obj1))
						ESX.Game.DeleteObject(NetToObj(odg.Obj2))
						ESX.Game.DeleteObject(NetToObj(odg.Obj3))
						ESX.Game.DeleteVehicle(entity)
					else
						ESX.Game.DeleteVehicle(entity)
					end
				end, VehToNet(entity))
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
				if odg ~= false then
					NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
					NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
					NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
					ESX.Game.DeleteObject(NetToObj(odg.Obj1))
					ESX.Game.DeleteObject(NetToObj(odg.Obj2))
					ESX.Game.DeleteObject(NetToObj(odg.Obj3))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.Game.DeleteVehicle(vehicle)
				end
			end, VehToNet(vehicle))
		end
	end
end)

-- Pause menu disable HUD display
if Config.EnableHud then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(300)

			if IsPauseMenuActive() and not isPaused then
				isPaused = true
				TriggerEvent('es:setMoneyDisplay', 0.0)
				ESX.UI.HUD.SetDisplay(0.0)
			elseif not IsPauseMenuActive() and isPaused then
				isPaused = false
				TriggerEvent('es:setMoneyDisplay', 1.0)
				ESX.UI.HUD.SetDisplay(1.0)
			end
		end
	end)
end

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,v in pairs(missingPickups) do
		ESX.Game.SpawnLocalObject('prop_money_bag_01', v.coords, function(obj)
			SetEntityAsMissionEntity(obj, true, false)
			PlaceObjectOnGroundProperly(obj)

			pickups[pickupId] = {
				id = pickupId,
				obj = obj,
				label = v.label,
				inRange = false,
				coords = vector3(v.coords.x, v.coords.y, v.coords.z)
			}
		end)
	end
end)

-- Save loadout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		local playerPed      = PlayerPedId()
		local loadout        = {}
		local loadoutChanged = false

		for i=1, #Config.Weapons do
			local weaponName = Config.Weapons[i].name
			local weaponHash = GetHashKey(weaponName)
			local weaponComponents = {}

			if HasPedGotWeapon(playerPed, weaponHash, false) and weaponName ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				local components = Config.Weapons[i].components

				for j=1, #components do
					if HasPedGotWeaponComponent(playerPed, weaponHash, components[j].hash) then
						table.insert(weaponComponents, components[j].name)
					end
				end

				if not lastLoadout[weaponName] or lastLoadout[weaponName] ~= ammo then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = ammo

				table.insert(loadout, {
					name = weaponName,
					ammo = ammo,
					label = Config.Weapons[i].label,
					components = weaponComponents
				})
			else
				if lastLoadout[weaponName] then
					loadoutChanged = true
				end

				lastLoadout[weaponName] = nil
			end
		end

		if loadoutChanged and isLoadoutLoaded then
			ESX.PlayerData.loadout = loadout
			TriggerServerEvent('esx:updateLoadout', loadout)
		end
	end
end)

-- Dot above head
if Config.ShowDotAbovePlayer then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)

			local players = ESX.Game.GetPlayers()
			for i = 1, #players, 1 do
				if players[i] ~= PlayerId() then
					local ped    = GetPlayerPed(players[i])
					local headId = CreateMpGamerTag(ped, ('·'), false, false, '', false)
				end
			end
		end
	end)
end

-- Disable wanted level
if Config.DisableWantedLevel then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)

			local playerId = PlayerId()
			if GetPlayerWantedLevel(playerId) ~= 0 then
				SetPlayerWantedLevel(playerId, 0, false)
				SetPlayerWantedLevelNow(playerId, false)
			end
		end
	end)
end

-- pickups
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		-- if there's no nearby pickups we can wait a bit to save performance
		if next(pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(pickups) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if distance <= 5.0 then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			if (closestDistance == -1 or closestDistance > 3) and distance <= 1.0 and not v.inRange and IsPedOnFoot(playerPed) then
				TriggerServerEvent('esx:onPickup', v.id)
				PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
				v.inRange = true
			end
		end
	end
end)]]

-- Pickups
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		for k,v in pairs(pickups) do
			local distance = #(playerCoords - v.coords)

			if distance < 5 then
				local label = v.label
				letSleep = false

				if distance < 1 then
					if IsControlJustReleased(0, 38) then
						if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not v.inRange then
							v.inRange = true

							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
							ESX.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Citizen.Wait(1000)
							local torba = 0
							TriggerEvent('skinchanger:getSkin', function(skin)
								torba = skin['bags_1']
							end)
							if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
								TriggerServerEvent('esx:onPickup', v.id, true)
							else
								TriggerServerEvent('esx:onPickup', v.id, false)
							end
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						end
					end

					label = ('%s~n~%s'):format(label, "Pritisnite ~y~E~s~ da pokupite")
				end

				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, label, 1.2, 1)
			elseif v.inRange then
				v.inRange = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		if ESX.PlayerLoaded and isPlayerSpawned then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)
