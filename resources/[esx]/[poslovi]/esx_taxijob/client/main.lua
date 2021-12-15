local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead, CurrentActionData = false, false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end
	
	SetPedAsNoLongerNeeded(CurrentCustomer)
	local scope = function(customer)
		ESX.SetTimeout(3000, function()
			DeletePed(customer)
		end)
	end

	scope(CurrentCustomer)

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end

function StartTaxiJob()
	ShowLoadingPromt(_U('taking_service'), 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub(_U('mission_complete'), 5000)
end

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'top-left',
		elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = _U('wear_work'),    value = 'recrue_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			exports["rp-radio"]:SetRadio(false)
			exports["rp-radio"]:RemovePlayerAccessToFrequency(5)
		elseif data.current.value == 'recrue_wear' then
			setUniform(data.current.value, PlayerPedId())
			exports["rp-radio"]:SetRadio(true)
			exports["rp-radio"]:GivePlayerAccessToFrequency(5)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].EUP == false or Config.Uniforms[job].EUP == nil then
				if Config.Uniforms[job].male then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
				end
			else
				local jobic = "EUP"..job
				local outfit = Config.Uniforms[jobic].male
				TriggerEvent('skinchanger:loadClothes', skin, outfit)
			end
		else
			if Config.Uniforms[job].EUP == false or Config.Uniforms[job].EUP == nil then
				if Config.Uniforms[job].female then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
				end
			else
				local jobic = "EUP"..job
				local outfit = Config.Uniforms[jobic].female
				TriggerEvent('skinchanger:loadClothes', skin, outfit)
			end
		end
	end)
end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {}

	if Config.EnableSocietyOwnedVehicles then

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

			for i=1, #vehicles, 1 do
				table.insert(elements, {
					label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
					value = vehicles[i]
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('spawn_veh'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
					ESX.ShowNotification(_U('spawnpoint_blocked'))
					return
				end

				menu.close()

				local vehicleProps = data.current.value
				ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					local playerPed = PlayerPedId()
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'taxi', vehicleProps)

			end, function(data, menu)
				CurrentAction     = 'vehicle_spawner'
				CurrentActionMsg  = _U('spawner_prompt')
				CurrentActionData = {}

				menu.close()
			end)
		end, 'taxi')

	else -- not society vehicles

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
		{
			title		= _U('spawn_veh'),
			align		= 'top-left',
			elements	= Config.AuthorizedVehicles
		}, function(data, menu)
			if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
				ESX.ShowNotification(_U('spawnpoint_blocked'))
				return
			end

			menu.close()
			ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
				local playerPed = PlayerPedId()
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			end)
			ESX.ShowNotification("Da date nekome racun pritisnite F6!")
			Wait(500)
			if OnJob then
				StopTaxiJob()
			end
		end, function(data, menu)
			CurrentAction     = 'vehicle_spawner'
			CurrentActionMsg  = _U('spawner_prompt')
			CurrentActionData = {}

			menu.close()
		end)
	end
end

function DeleteJobVehicle()
	local playerPed = PlayerPedId()

	if Config.EnableSocietyOwnedVehicles then
		local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
		TriggerServerEvent('esx_society:putVehicleInGarage', 'taxi', vehicleProps)
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	else
		if IsInAuthorizedVehicle() then
			ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			ClearCurrentMission()
			if Config.MaxInService ~= -1 then
				TriggerServerEvent('esx_service:disableService', 'taxi')
			end
		else
			ESX.ShowNotification(_U('only_taxi'))
		end
	end
end

function OtvoriListuZaposlenih()
	ESX.TriggerServerCallback('esx_policejob:dohvatiZaposlene', function(datae)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_bossa', {
			title    = 'Lista zaposlenih',
			align    = 'top-left',
			elements = datae
		}, function(data, menu)
			local user = data.current.value
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_akc', {
				title    = 'Boss menu',
				align    = 'top-left',
				elements = {
					{label = "Rank", value = 'rank'},
					{label = "Otpusti", value = 'otpusti'}
			}}, function(data3, menu3)
				if data3.current.value == 'rank' then
					ESX.TriggerServerCallback('esx_policejob:dohvatiRankove', function(data2)
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_rankova', {
							title    = "Odaberite rank",
							align    = 'top-left',
							elements = data2
						}, function(data2, menu2)
							local action = data2.current.value
							TriggerServerEvent("policija:PostaviRank", user, ESX.PlayerData.job.id, action)
							menu2.close()
						end, function(data2, menu2)
							menu2.close()
						end)
					end, ESX.PlayerData.job.name)
				elseif data3.current.value == 'otpusti' then
					TriggerServerEvent("policija:OtpustiIgraca", user)
					menu3.close()
					menu.close()
					ESX.UI.Menu.CloseAll()
					OtvoriBossMenu()
				end
			end, function(data3, menu3)
				menu3.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, ESX.PlayerData.job.id)
end

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		local br = data.br
		local args = data.args
		if br == 1 then
			TriggerServerEvent("taxi:Zaposli2", args.posao, args.id)
		end
    end
)

function OtvoriZaposljavanje()
	ESX.TriggerServerCallback('policija:getOnlinePlayers', function(rad)
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'fdsfae',
			{
				title    = "Popis igraca",
				align    = 'bottom-right',
				elements = rad,
			},
			function(datalr2, menulr2)
				TriggerServerEvent("taxi:Zaposli", ESX.PlayerData.job.id, datalr2.current.value)
				menulr2.close()
				ESX.UI.Menu.CloseAll()
				OtvoriBossMenu()
			end,
			function(datalr2, menulr2)
				menulr2.close()
			end
		)
	end, ESX.PlayerData.job.id)
end

function OtvoriBossMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meh_boss', {
		title    = 'Lider menu',
		align    = 'top-left',
		elements = {
			{label = "Zaposlenici", value = 'zaposlenici'},
			{label = "Place", value = 'place'}
	}}, function(data, menu)
		if data.current.value == 'zaposlenici' then
			local elements = {
				{label = "Lista zaposlenika", value = 'lista'},
				{label = "Zaposli", value = 'zaposli'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_zap', {
				title    = "Zaposlenici",
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'lista' then
					OtvoriListuZaposlenih()
				elseif action == 'zaposli' then
					OtvoriZaposljavanje()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'place' then
			ESX.TriggerServerCallback('esx_policejob:dohvatiPlace', function(data2)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lista_rankovaplace', {
					title    = "Odaberite rank",
					align    = 'top-left',
					elements = data2
				}, function(data2, menu2)
					local rankid = data2.current.value
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'place_broj', {
						title = "Unesite novu placu ranka"
					}, function(data3, menu3)
						local count = tonumber(data3.value)
						if count == nil then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu3.close()
							menu2.close()
							TriggerServerEvent("policija:PostaviPlacu", rankid, count)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end, ESX.PlayerData.job.name)
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenTaxiActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			OtvoriBossMenu()
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenMobileTaxiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = {
			{label = _U('billing'),   value = 'billing'},
			{label = "NPC posao",   value = 'npc'},
			{label = "Zaustavi NPC posao",   value = 'npcstop'}
	}}, function(data, menu)
		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil or amount > 5000 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_near'))
					else
						TriggerServerEvent('esx_billing:posaljiTuljana', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
						ESX.ShowNotification(_U('billing_sent'))
					end

				end

			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'npc' then
			if not OnJob then
				if IsInAuthorizedVehicle() then
					PokreniNPC()
				else
					ESX.ShowNotification(_U('only_taxi'))
				end
			else
				ESX.ShowNotification("Vec imate pokrenut posao!")
			end
		elseif data.current.value == 'npcstop' then
			if OnJob then
				StopTaxiJob()
			else
				ESX.ShowNotification("Nemate pokrenut NPC posao!")
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function PokreniNPC()
	OnJob = true
	local playerCoords = GetEntityCoords(PlayerPedId())
	local modelic = Config.Modeli[GetRandomIntInRange(1, #Config.Modeli)]
	targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
	local distance = #(playerCoords - targetCoords)
	while distance < Config.MinimumDistance do
		Citizen.Wait(5)

		targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
		distance = #(playerCoords - targetCoords)
	end
	local model = RequestModel(GetHashKey(modelic))
	while not HasModelLoaded(GetHashKey(modelic)) do
		Wait(1)
	end
	--CurrentCustomer = CreatePed(5, model, targetCoords, 260, true, true)
	--SetModelAsNoLongerNeeded(model)
	CurrentCustomerBlip = AddBlipForCoord(targetCoords)
	SetBlipAsFriendly(CurrentCustomerBlip, true)
	SetBlipColour(CurrentCustomerBlip, 2)
	SetBlipCategory(CurrentCustomerBlip, 3)
	SetBlipRoute(CurrentCustomerBlip, true)
	--SetEntityAsMissionEntity(CurrentCustomer, true, false)
	--ClearPedTasksImmediately(CurrentCustomer)
	--SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)
	--local standTime = GetRandomIntInRange(60000, 180000)
	--TaskStandStill(CurrentCustomer, standTime)
	local spawno = false
	Posao = 1
	ESX.ShowNotification("Idite do checkpointa kako bih ste pokupili musteriju!")
	while not spawno and Posao == 1 do
		Wait(500)
		if targetCoords ~= nil and #(GetEntityCoords(PlayerPedId())-targetCoords) <= 100.0 then
			spawno = true
			CurrentCustomer = CreatePed(5, model, targetCoords, 260, true, true)
			SetModelAsNoLongerNeeded(model)
			SetEntityAsMissionEntity(CurrentCustomer, true, false)
			ClearPedTasksImmediately(CurrentCustomer)
			SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)
			local standTime = GetRandomIntInRange(60000, 180000)
			TaskStandStill(CurrentCustomer, standTime)
		end
	end
	Citizen.CreateThread(function()
		while Posao == 1 do
			local korda = GetEntityCoords(PlayerPedId())
			if targetCoords ~= nil and GetDistanceBetweenCoords(korda, targetCoords, true) <= 8.0 then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)
					
					SetPedAsNoLongerNeeded(CurrentCustomer)
					
					DeleteEntity(CurrentCustomer)
					
					Posao = 0
					PokreniNPC()

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, nil
				end
				if not CustomerIsEnteringVehicle then
					local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

					for i=maxSeats - 1, 0, -1 do
						if IsVehicleSeatFree(vehicle, i) then
							freeSeat = i
							break
						end
					end

					if freeSeat then
						RemoveBlip(CurrentCustomerBlip)
						CurrentCustomerBlip = nil
						TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
						CustomerIsEnteringVehicle = true
					end
				end
				if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
					if not CustomerEnteredVehicle then
						local playerCoords = GetEntityCoords(PlayerPedId())
						targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
						local distance = #(playerCoords - targetCoords)
						while distance < Config.MinimumDistance do
							Citizen.Wait(5)

							targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
							distance = #(playerCoords - targetCoords)
						end
						DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
						BeginTextCommandSetBlipName('STRING')
						AddTextComponentSubstringPlayerName('Destinacija')
						EndTextCommandSetBlipName(DestinationBlip)
						SetBlipRoute(DestinationBlip, true)
						CustomerEnteredVehicle = true
					end
					if GetDistanceBetweenCoords(korda, targetCoords, true) <= 10.0 then
						TaskLeaveVehicle(CurrentCustomer, vehicle, 0)
						
						TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
						SetEntityAsMissionEntity(CurrentCustomer, false, true)
						TriggerServerEvent('esx_tuljotaxi:uspijeh;')
						OnJob = false
						RemoveBlip(DestinationBlip)
						SetPedAsNoLongerNeeded(CurrentCustomer)
						local scope = function(customer)
							ESX.SetTimeout(3000, function()
								DeletePed(customer)
							end)
						end

						scope(CurrentCustomer)

						CurrentCustomer, CurrentCustomerBlip, DestinationBlip, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, nil
						Posao = 0
						PokreniNPC()
					end
				end
			end
			if CustomerEnteredVehicle and GetDistanceBetweenCoords(korda, targetCoords.x, targetCoords.y, targetCoords.z, true) < 100.0 then
				DrawMarker(1, targetCoords.x, targetCoords.y, targetCoords.z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			Citizen.Wait(1)
		end
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Taxi Stock',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_taxijob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_taxijob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard', -- not used
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_taxijob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_taxijob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_taxijob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)

-- Enter / Exit marker events, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep, currentZone = false, true

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('esx_taxijob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_taxijob:hasExitedMarker', LastZone)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			if CurrentAction and not IsDead then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
					if CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'taxi_actions_menu' then
						OpenTaxiActionsMenu()
					elseif CurrentAction == 'vehicle_spawner' then
						OpenVehicleSpawnerMenu()
					elseif CurrentAction == 'delete_vehicle' then
						DeleteJobVehicle()
					end

					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and not IsDead and Config.EnablePlayerManagement then
				OpenMobileTaxiActionsMenu()
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)
