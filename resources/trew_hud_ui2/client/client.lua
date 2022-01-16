local ESX	 = nil
local Poslao = -69
local PrviSpawn = false
local ZabraniHud = false
local Dozvoljeno = true
local UVozilu = false
local Vozilo = nil
local Klasa = nil
local Sjedalo = nil
local Kilometri = 0.0
local ZadnjaPoz = nil
local Tablica = nil
local glad = 0
local zedj = 0
local Statusi = nil
local IsDead = false
local IsAnimated = false
local ZabraniCmd = false

local vehica = 0
local orgsusp
local orgy
local eng

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
	
	
	if Config.ui.showVoice == true then
		if Config.voice.levels.current == 0 then
			NetworkSetTalkerProximity(Config.voice.levels.default)
		elseif Config.voice.levels.current == 1 then
			NetworkSetTalkerProximity(Config.voice.levels.shout)
		elseif Config.voice.levels.current == 2 then
			NetworkSetTalkerProximity(Config.voice.levels.whisper)
		end
	end
	TriggerServerEvent('trew_hud_ui:getServerInfo')
	DisplayRadar(true)

	ESX.TriggerServerCallback('status:dohvatiStatuse', function(status)
		Statusi = status
		Status()
	end)
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('status:set', 'hunger', 50)
	TriggerEvent('status:set', 'thirst', 50)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('status:set', 'hunger', 100)
	TriggerEvent('status:set', 'thirst', 100)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

RegisterNetEvent('status:set')
AddEventHandler('status:set', function(ime, br)
	local playerStatus 
	playerStatus = { action = 'setStatus', status = {} }
	for i=1, #Statusi, 1 do
		if Statusi[i].name == ime then
			Statusi[i].percent = math.floor(br)
		end
	end
	TriggerServerEvent("status:SpremiStatuse", Statusi)
	local glad = 0
	local zedj = 0
	for i=1, #Statusi, 1 do
		if Statusi[i].name == "hunger" then
			glad = math.floor(Statusi[i].percent)
		elseif Statusi[i].name == "thirst" then
			zedj = math.floor(Statusi[i].percent)
		end
	end
	playerStatus['status'][1] = {
		name = 'hunger',
		value = math.floor(100-glad)
	}
	playerStatus['status'][2] = {
		name = 'thirst',
		value = math.floor(100-zedj)
	}
	SendNUIMessage(playerStatus)
end)

RegisterNetEvent('status:add')
AddEventHandler('status:add', function(ime, br)
	local playerStatus 
	playerStatus = { action = 'setStatus', status = {} }
	for i=1, #Statusi, 1 do
		if Statusi[i].name == ime then
			Statusi[i].percent = Statusi[i].percent-math.floor(br)
			if Statusi[i].percent < 0 then
				Statusi[i].percent = 0
			end
		end
	end
	TriggerServerEvent("status:SpremiStatuse", Statusi)
	local glad = 0
	local zedj = 0
	for i=1, #Statusi, 1 do
		if Statusi[i].name == "hunger" then
			glad = math.floor(Statusi[i].percent)
		elseif Statusi[i].name == "thirst" then
			zedj = math.floor(Statusi[i].percent)
		end
	end
	playerStatus['status'][1] = {
		name = 'hunger',
		value = math.floor(100-glad)
	}
	playerStatus['status'][2] = {
		name = 'thirst',
		value = math.floor(100-zedj)
	}
	SendNUIMessage(playerStatus)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 145.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
	local playerPed = GetPlayerPed(-1)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(playerPed)
end) 

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)
RegisterNetEvent('esx_basicneeds:onEatChocolate')
AddEventHandler('esx_basicneeds:onEatChocolate', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.035, 0.009, -30.0, -240.0, -120.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatCupCake')
AddEventHandler('esx_basicneeds:onEatCupCake', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'ng_proc_food_ornge1a'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.045, 0.06, 45.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatChips')
AddEventHandler('esx_basicneeds:onEatChips', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'v_ret_ml_chips4'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatSandwich')
AddEventHandler('esx_basicneeds:onEatSandwich', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_sandwich_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.03, -240.0, -180.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkCocaCola')
AddEventHandler('esx_basicneeds:onDrinkCocaCola', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ecola_can' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkIceTea')
AddEventHandler('esx_basicneeds:onDrinkIceTea', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_can_01' --ng_proc_sodacan_01b
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkCoffe')
AddEventHandler('esx_basicneeds:onDrinkCoffe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_fib_coffee'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.01, -0.03, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Bar drinks
RegisterNetEvent('esx_basicneeds:onDrinkBeer')
AddEventHandler('esx_basicneeds:onDrinkBeer', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_amb_beer_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, 0.0, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkWine')
AddEventHandler('esx_basicneeds:onDrinkWine', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_bot_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkVodka')
AddEventHandler('esx_basicneeds:onDrinkVodka', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_vodka_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkWhisky')
AddEventHandler('esx_basicneeds:onDrinkWhisky', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_whiskey_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.2, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkTequila')
AddEventHandler('esx_basicneeds:onDrinkTequila', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_tequila_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkMilk')
AddEventHandler('esx_basicneeds:onDrinkMilk', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_milk_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.100, 10.0, 135.0, 95.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Disco
RegisterNetEvent('esx_basicneeds:onDrinkGin')
AddEventHandler('esx_basicneeds:onDrinkGin', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_rum_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkAbsinthe')
AddEventHandler('esx_basicneeds:onDrinkAbsinthe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_bottle_cognac'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'mamb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkChampagne')
AddEventHandler('esx_basicneeds:onDrinkChampagne', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_white'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_cigarett:startSmoke')
AddEventHandler('esx_cigarett:startSmoke', function(source)
	SmokeAnimation()
end)

function SmokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)               
	end)
end

-- Optionalneeds
function Drunk(level, start)
  
  Citizen.CreateThread(function()
     local playerPed = GetPlayerPed(-1)
     if start then
      DoScreenFadeOut(800)
      Wait(1000)
    end
     if level == 0 then
       RequestAnimSet("move_m@drunk@slightlydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
     elseif level == 1 then
       RequestAnimSet("move_m@drunk@moderatedrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
     elseif level == 2 then
       RequestAnimSet("move_m@drunk@verydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
      end
       SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
     end
     SetTimecycleModifier("spectator5")
     SetPedMotionBlur(playerPed, true)
     SetPedIsDrunk(playerPed, true)
     if start then
      DoScreenFadeIn(800)
     end
   end)
end

function Reality()
   Citizen.CreateThread(function()
     	local playerPed = GetPlayerPed(-1)
     	DoScreenFadeOut(800)
     	Wait(1000)
     	ClearTimecycleModifier()
    	ResetScenarioTypesEnabled()
    	ResetPedMovementClipset(playerPed, 0)
    	SetPedIsDrunk(playerPed, false)
    	SetPedMotionBlur(playerPed, false)
     	DoScreenFadeIn(800)
   end)
end

RegisterNetEvent('iens:Dozvoljeno')
AddEventHandler('iens:Dozvoljeno', function(br)
	Dozvoljeno = br
end)

function round2(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local AllWeapons = json.decode('{"melee":{"dagger":"0x92A27487","bat":"0x958A4A8F","bottle":"0xF9E6AA4B","crowbar":"0x84BD7BFD","unarmed":"0xA2719263","flashlight":"0x8BB05FD7","golfclub":"0x440E4788","hammer":"0x4E875F73","hatchet":"0xF9DCBF2D","knuckle":"0xD8DF3C3C","knife":"0x99B507EA","machete":"0xDD5DF8D9","switchblade":"0xDFE37640","nightstick":"0x678B81B1","wrench":"0x19044EE0","battleaxe":"0xCD274149","poolcue":"0x94117305","stone_hatchet":"0x3813FC08"},"handguns":{"pistol":"0x1B06D571","pistol_mk2":"0xBFE256D4","combatpistol":"0x5EF9FEC4","appistol":"0x22D8FE39","stungun":"0x3656C8C1","pistol50":"0x99AEEB3B","snspistol":"0xBFD21232","snspistol_mk2":"0x88374054","heavypistol":"0xD205520E","vintagepistol":"0x83839C4","flaregun":"0x47757124","marksmanpistol":"0xDC4DB296","revolver":"0xC1B3C3D1","revolver_mk2":"0xCB96392F","doubleaction":"0x97EA20B8","raypistol":"0xAF3696A1"},"smg":{"microsmg":"0x13532244","smg":"0x2BE6766B","smg_mk2":"0x78A97CD0","assaultsmg":"0xEFE7E2DF","combatpdw":"0xA3D4D34","machinepistol":"0xDB1AA450","minismg":"0xBD248B55","raycarbine":"0x476BF155"},"shotguns":{"pumpshotgun":"0x1D073A89","pumpshotgun_mk2":"0x555AF99A","sawnoffshotgun":"0x7846A318","assaultshotgun":"0xE284C527","bullpupshotgun":"0x9D61E50F","musket":"0xA89CB99E","heavyshotgun":"0x3AABBBAA","dbshotgun":"0xEF951FBB","autoshotgun":"0x12E82D3D"},"assault_rifles":{"assaultrifle":"0xBFEFFF6D","assaultrifle_mk2":"0x394F415C","carbinerifle":"0x83BF0278","carbinerifle_mk2":"0xFAD1F1C9","advancedrifle":"0xAF113F99","specialcarbine":"0xC0A3098D","specialcarbine_mk2":"0x969C3D67","bullpuprifle":"0x7F229F94","bullpuprifle_mk2":"0x84D6FAFD","compactrifle":"0x624FE830"},"machine_guns":{"mg":"0x9D07F764","combatmg":"0x7FD62962","combatmg_mk2":"0xDBBD7280","gusenberg":"0x61012683"},"sniper_rifles":{"sniperrifle":"0x5FC3C11","heavysniper":"0xC472FE2","heavysniper_mk2":"0xA914799","marksmanrifle":"0xC734385A","marksmanrifle_mk2":"0x6A6C02E0"},"heavy_weapons":{"rpg":"0xB1CA77B1","grenadelauncher":"0xA284510B","grenadelauncher_smoke":"0x4DD2DC56","minigun":"0x42BF8A85","firework":"0x7F7497E5","railgun":"0x6D544C99","hominglauncher":"0x63AB0442","compactlauncher":"0x781FE4A","rayminigun":"0xB62D1F67"},"throwables":{"grenade":"0x93E220BD","bzgas":"0xA0973D5E","smokegrenade":"0xFDBC8A50","flare":"0x497FACC3","molotov":"0x24B17070","stickybomb":"0x2C3731D9","proxmine":"0xAB564B93","snowball":"0x787F0BB","pipebomb":"0xBA45E8B8","ball":"0x23C9F95C"},"misc":{"petrolcan":"0x34A67B97","fireextinguisher":"0x60EC506","parachute":"0xFBAB5776"}}')

local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,17,18,19,20};

-- Vehicle Info
local vehicleCruiser
local vehicleSignalIndicator = 'off'
local seatbeltEjectSpeed = 45.0 
local seatbeltEjectAccel = 100.0
local seatbeltIsOn = false
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}

Citizen.CreateThread(function()
	local Waitara = 500
	while true do

		Citizen.Wait(Waitara)
		local vehicleInfo

		if UVozilu and ZabraniHud == false then
			Waitara = 200
			local player = GetPlayerPed(-1)
			local vehicle = Vozilo
			local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)
			if vehicleIsOn or Klasa == 21 then
				local vehicleClass = Klasa


				if Config.ui.showMinimap == false then
					DisplayRadar(true)
				end

				-- Vehicle Speed
				local vehicleSpeedSource = GetEntitySpeed(vehicle)
				local vehicleSpeed
				if Config.vehicle.speedUnit == 'MPH' then
					vehicleSpeed = math.ceil(vehicleSpeedSource * 2.237)
				else
					vehicleSpeed = math.ceil(vehicleSpeedSource * 3.6)
				end

				-- Vehicle RPM
				local vehicleRPM = round2(GetVehicleCurrentRpm(vehicle), 2)*100

				-- Vehicle Gradient Speed
				local vehicleNailSpeed

				if vehicleSpeed > Config.vehicle.maxSpeed then
					vehicleNailSpeed = math.ceil(  280 - math.ceil( math.ceil(Config.vehicle.maxSpeed * 205) / Config.vehicle.maxSpeed) )
				else
					vehicleNailSpeed = math.ceil(  280 - math.ceil( math.ceil(vehicleSpeed * 205) / Config.vehicle.maxSpeed) )
				end


				
				-- Vehicle Fuel and Gear
				local vehicleFuel
				vehicleFuel = GetVehicleFuelLevel(vehicle)
				local vehicleGear = GetVehicleCurrentGear(vehicle)
				if Poslao == -69 then
					if (vehicleSpeed == 0 and vehicleGear == 0) or (vehicleSpeed == 0 and vehicleGear == 1) then
						vehicleGear = 'N'
					elseif vehicleSpeed > 0 and vehicleGear == 0 then
						vehicleGear = 'R'
					end
				end

				-- Vehicle Lights
				local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
				local vehicleIsLightsOn
				if vehicleLights == 1 and vehicleHighlights == 0 then
					vehicleIsLightsOn = 'normal'
				elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
					vehicleIsLightsOn = 'high'
				else
					vehicleIsLightsOn = 'off'
				end






				-- Vehicle Siren
				local vehicleSiren

				if IsVehicleSirenOn(vehicle) then
					vehicleSiren = true
				else
					vehicleSiren = false
				end






				-- Vehicle Seatbelt
				if has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8 and Dozvoljeno then

					local prevSpeed = currSpeed
					currSpeed = vehicleSpeedSource

					SetPedConfigFlag(PlayerPedId(), 32, true)

					if not seatbeltIsOn then
						local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
						local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
						if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
							local position = GetEntityCoords(player)
							SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
							SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
							SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
						else
							-- Update previous velocity for ejecting player
							prevVelocity = GetEntityVelocity(vehicle)
						end

					else

						DisableControlAction(0, 75)

					end



				end

				
				if Poslao == -69 then
					vehicleInfo = {
						action = 'updateVehicle',

						status = true,
						speed = vehicleSpeed,
						RPM = vehicleRPM,
						km = round2(Kilometri, 0),
						nail = vehicleNailSpeed,
						gear = vehicleGear,
						fuel = vehicleFuel,
						lights = vehicleIsLightsOn,
						signals = vehicleSignalIndicator,
						cruiser = vehicleCruiser,
						type = vehicleClass,
						siren = vehicleSiren,
						seatbelt = {},

						config = {
							speedUnit = Config.vehicle.speedUnit,
							maxSpeed = Config.vehicle.maxSpeed
						}
					}
				else
					vehicleInfo = {
						action = 'updateVehicle',

						status = true,
						speed = vehicleSpeed,
						RPM = vehicleRPM,
						km = round2(Kilometri, 0),
						nail = vehicleNailSpeed,
						gear = Poslao,
						fuel = vehicleFuel,
						lights = vehicleIsLightsOn,
						signals = vehicleSignalIndicator,
						cruiser = vehicleCruiser,
						type = vehicleClass,
						siren = vehicleSiren,
						seatbelt = {},

						config = {
							speedUnit = Config.vehicle.speedUnit,
							maxSpeed = Config.vehicle.maxSpeed
						}
					}
				end

				vehicleInfo['seatbelt']['status'] = seatbeltIsOn
				SendNUIMessage(vehicleInfo)
			else
				Waitara = 500
				if not vehicleIsOn then
					if Config.ui.showMinimap == false then
						DisplayRadar(false)
					end
					vehicleCruiser = false
					vehicleNailSpeed = 0
					vehicleSignalIndicator = 'off'

					seatbeltIsOn = false
					vehicleInfo = {}
					vehicleInfo = {
						action = 'updateVehicle',
						status = false,
						nail = vehicleNailSpeed,
						seatbelt = { status = seatbeltIsOn },
						cruiser = vehicleCruiser,
						signals = vehicleSignalIndicator,
						type = 0,
					}
					SendNUIMessage(vehicleInfo)
				end
			end
		else
			Waitara = 500
			if not GetIsVehicleEngineRunning(Vozilo) then
				if Config.ui.showMinimap == false then
					DisplayRadar(false)
				end
				vehicleCruiser = false
				vehicleNailSpeed = 0
				vehicleSignalIndicator = 'off'

				seatbeltIsOn = false
				vehicleInfo = {}
				vehicleInfo = {
					action = 'updateVehicle',

					status = false,
					nail = vehicleNailSpeed,
					seatbelt = { status = seatbeltIsOn },
					cruiser = vehicleCruiser,
					signals = vehicleSignalIndicator,
					type = 0,
				}
				SendNUIMessage(vehicleInfo)
			end
		end
	end
end)

function toggleEngine()
    if UVozilu and Sjedalo == -1 and not ZabraniCmd then
		vehica = Vozilo
		eng = (not GetIsVehicleEngineRunning(vehica))
        SetVehicleEngineOn(Vozilo, (not GetIsVehicleEngineRunning(Vozilo)), false, true)
		local globalplate  = GetVehicleNumberPlateText(Vozilo)
		price = 5000*1.30
		if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
			ESX.TriggerServerCallback('stage:ProvjeriVozilo',function(st)
				if st ~= 0 and st.zracni == 1 then
					local speed = GetEntitySpeed(vehica)
					local kmh = (speed * 3.6)
					if kmh == 0.0 then
						ZabraniCmd = true
						if not eng then
							if orgsusp == nil then
								local prosliy = GetVehicleWheelYRotation(vehica, 0)
								orgy = prosliy
								local susppr = GetVehicleSuspensionHeight(vehica)
								orgsusp = susppr
								local netid = VehToNet(vehica)
								TriggerServerEvent("ovjes:SyncSvima", GetPlayerServerId(PlayerId()), netid, orgy, orgsusp, 1)
								local novibr = -0.1
								while prosliy > novibr do
									SetVehicleWheelYRotation(vehica, 0, prosliy-0.0008)
									SetVehicleWheelYRotation(vehica, 1, -prosliy-0.0008)
									SetVehicleWheelYRotation(vehica, 2, prosliy-0.0008)
									SetVehicleWheelYRotation(vehica, 3, -prosliy-0.0008)
									prosliy = prosliy-0.0008
									Wait(1)
								end
								local nbr = 0.13
								while nbr > susppr do
									SetVehicleSuspensionHeight(vehica, susppr+0.0008)
									susppr = susppr+0.0008
									Wait(1)
								end
								ZabraniCmd = false
								local veho = vehica
								while not eng do
									if vehica ~= 0 then
										if IsControlJustPressed(0, 71) then
											local netid = VehToNet(veho)
											TriggerServerEvent("ovjes:SyncSvima", GetPlayerServerId(PlayerId()), netid, prosliy, orgsusp, 0)
											local nbr = GetVehicleSuspensionHeight(veho)
											while nbr > orgsusp do
												SetVehicleSuspensionHeight(veho, nbr-0.0008)
												nbr = nbr-0.0008
												Wait(1)
											end
											local novibr = 0.0
											while prosliy < novibr do
												SetVehicleWheelYRotation(veho, 0, prosliy+0.0008)
												SetVehicleWheelYRotation(veho, 1, -prosliy+0.0008)
												SetVehicleWheelYRotation(veho, 2, prosliy+0.0008)
												SetVehicleWheelYRotation(veho, 3, -prosliy+0.0008)
												prosliy = prosliy+0.0008
												Wait(1)
											end
											prosliy = 0.0
											orgy = -0.2
											orgsusp = nil
											eng = true
										end
									else
										eng = true
									end
									vehica = GetVehiclePedIsIn(PlayerPedId())
									Wait(1)
								end
							end
						else
							if orgsusp ~= nil then
								local netid = VehToNet(vehica)
								TriggerServerEvent("ovjes:SyncSvima", GetPlayerServerId(PlayerId()), netid, orgy, orgsusp, 0)
								local nbr = GetVehicleSuspensionHeight(vehica)
								while nbr > orgsusp do
									SetVehicleSuspensionHeight(vehica, nbr-0.0008)
									nbr = nbr-0.0008
									Wait(1)
								end
								local novibr = -0.1
								while orgy > novibr do
									SetVehicleWheelYRotation(vehica, 0, novibr+0.0008)
									SetVehicleWheelYRotation(vehica, 1, -novibr+0.0008)
									SetVehicleWheelYRotation(vehica, 2, novibr+0.0008)
									SetVehicleWheelYRotation(vehica, 3, -novibr+0.0008)
									novibr = novibr+0.0008
									Wait(1)
								end
								orgy = -0.2
								orgsusp = nil
								ZabraniCmd = false
							end
						end
						ZabraniCmd = false
					end
				end
			end, globalplate)
		end
    end
end

RegisterNetEvent('ovjes:EoVamOvjes')
AddEventHandler('ovjes:EoVamOvjes', function(id, nid, y, susp, br)
	if GetPlayerServerId(PlayerId()) ~= id then
		Wait(500)
		if NetworkDoesEntityExistWithNetworkId(nid) then
			if br == 1 then
				local vehica = NetToVeh(nid)
				local prosliy = y
				local susppr = susp
				local novibr = -0.1
				while prosliy > novibr do
					SetVehicleWheelYRotation(vehica, 0, prosliy-0.0008)
					SetVehicleWheelYRotation(vehica, 1, -prosliy-0.0008)
					SetVehicleWheelYRotation(vehica, 2, prosliy-0.0008)
					SetVehicleWheelYRotation(vehica, 3, -prosliy-0.0008)
					prosliy = prosliy-0.0008
					Wait(1)
				end
				local nbr = 0.13
				while nbr > susppr do
					SetVehicleSuspensionHeight(vehica, susppr+0.0008)
					susppr = susppr+0.0008
					Wait(1)
				end
			else
				local vehica = NetToVeh(nid)
				local orgsusp = susp
				local prosliy = y
				local nbr = GetVehicleSuspensionHeight(vehica)
				while nbr > orgsusp do
					SetVehicleSuspensionHeight(vehica, nbr-0.0008)
					nbr = nbr-0.0008
					Wait(1)
				end
				local novibr = -0.1
				while prosliy > novibr do
					SetVehicleWheelYRotation(vehica, 0, novibr+0.0008)
					SetVehicleWheelYRotation(vehica, 1, -novibr+0.0008)
					SetVehicleWheelYRotation(vehica, 2, novibr+0.0008)
					SetVehicleWheelYRotation(vehica, 3, -novibr+0.0008)
					novibr = novibr+0.0008
					Wait(1)
				end
			end
		end
	end
end)

RegisterNetEvent('ovjes:EoVamOvjes2')
AddEventHandler('ovjes:EoVamOvjes2', function(ovj)
	Wait(500)
	for i=1, #ovj, 1 do
		local nid = ovj[i].netid
		local y = ovj[i].roty
		local susp = ovj[i].susp
		if NetworkDoesEntityExistWithNetworkId(nid) then
			local vehica = NetToVeh(nid)
			local prosliy = y
			local susppr = susp
			local novibr = -0.1
			while prosliy > novibr do
				SetVehicleWheelYRotation(vehica, 0, prosliy-0.0008)
				SetVehicleWheelYRotation(vehica, 1, -prosliy-0.0008)
				SetVehicleWheelYRotation(vehica, 2, prosliy-0.0008)
				SetVehicleWheelYRotation(vehica, 3, -prosliy-0.0008)
				prosliy = prosliy-0.0008
				Wait(1)
			end
			local nbr = 0.13
			while nbr > susppr do
				SetVehicleSuspensionHeight(vehica, susppr+0.0008)
				susppr = susppr+0.0008
				Wait(1)
			end
		end
	end
end)

RegisterCommand('motor', function()
    toggleEngine()
end, false)
RegisterKeyMapping('motor', 'Paljenje/gasenje motora', 'keyboard', 'k')

RegisterCommand('+pojas', function()
    local vehicle = Vozilo
	local vehicleClass = Klasa
	if GetIsVehicleEngineRunning(vehicle) then
		if has_value(vehiclesCars, vehicleClass) == true and vehicleClass ~= 8 then
			seatbeltIsOn = not seatbeltIsOn
		end
	end
end, false)
RegisterKeyMapping('+pojas', 'Pojas', 'keyboard', 'g')

RegisterCommand('+zlijevi', function()
	local vehicleClass = Klasa
    local vozac = Sjedalo
	-- Vehicle Signal Lights
	if has_value(vehiclesCars, vehicleClass) == true and vozac == -1 then
		local menui = #ESX.UI.Menu.GetOpenedMenus()
		if menui == nil or menui == 0 then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'left'
			else
				vehicleSignalIndicator = 'off'
			end

			TriggerEvent('trew_hud_ui:setCarSignalLights', vehicleSignalIndicator)
		end
	end
end, false)
RegisterKeyMapping('+zlijevi', 'Lijevi zmigavac', 'keyboard', 'left')

RegisterCommand('+zdesni', function()
	local vehicleClass = Klasa
    local vozac = Sjedalo
	if has_value(vehiclesCars, vehicleClass) == true and vozac == -1 then
		local menui = #ESX.UI.Menu.GetOpenedMenus()
		if menui == nil or menui == 0 then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'right'
			else
				vehicleSignalIndicator = 'off'
			end

			TriggerEvent('trew_hud_ui:setCarSignalLights', vehicleSignalIndicator)
		end
	end
end, false)
RegisterKeyMapping('+zdesni', 'Desni zmigavac', 'keyboard', 'right')

RegisterCommand('+zsvi', function()
	local vehicleClass = Klasa
    local vozac = Sjedalo
	if has_value(vehiclesCars, vehicleClass) == true and vozac == -1 then
		local menui = #ESX.UI.Menu.GetOpenedMenus()
		if menui == nil or menui == 0 then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'both'
			else
				vehicleSignalIndicator = 'off'
			end

			TriggerEvent('trew_hud_ui:setCarSignalLights', vehicleSignalIndicator)
		end
	end
end, false)
RegisterKeyMapping('+zsvi', 'Sva 4 zmigavca', 'keyboard', 'down')

-- Player status
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if Config.ui.showHealth == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['isdead'] = false

			playerStatus['status'][showPlayerStatus] = {
				name = 'health',
				value = GetEntityHealth(GetPlayerPed(-1)) - 100
			}

			if IsEntityDead(GetPlayerPed(-1)) then
				playerStatus.isdead = true
			end
		end

		if Config.ui.showArmor == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'armor',
				value = GetPedArmour(GetPlayerPed(-1)),
			}
		end

		if Config.ui.showStamina == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'stamina',
				value = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
			}
		end

		--TriggerServerEvent('trew_hud_ui:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end

	end
end)

function Status()
	local ped = PlayerPedId()
	local playerStatus 
	playerStatus = { action = 'setStatus', status = {} }
	local glad = 0
	local zedj = 0
	for i=1, #Statusi, 1 do
		if Statusi[i].name == "hunger" then
			glad = math.floor(Statusi[i].percent)
			if glad > 0 then
				glad = glad-1
			else
				if not IsEntityDead(ped) then
					SetEntityHealth(ped, GetEntityHealth(ped)-5)
					ESX.ShowNotification("Umirete zbog toga sto ste gladni!")
				end
			end
			Statusi[i].percent = glad
		elseif Statusi[i].name == "thirst" then
			zedj = math.floor(Statusi[i].percent)
			if zedj > 0 then
				zedj = zedj-1
			else
				if not IsEntityDead(ped) then
					SetEntityHealth(ped, GetEntityHealth(ped)-5)
					ESX.ShowNotification("Umirete zbog toga sto ste zedni!")
				end
			end
			Statusi[i].percent = zedj
		end
	end
	TriggerServerEvent("status:SpremiStatuse", Statusi)
	playerStatus['status'][1] = {
		name = 'hunger',
		value = math.floor(100-glad)
	}
	playerStatus['status'][2] = {
		name = 'thirst',
		value = math.floor(100-zedj)
	}
	SendNUIMessage(playerStatus)
	SetTimeout(60000, Status)
end

RegisterNetEvent('MakniHud')
AddEventHandler('MakniHud', function(br)
	ZabraniHud = br
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer

	-- Job
	local job = data.job
	
	local ime
	if job.label ==  job.grade_label then
		ime = job.grade_label
	else
		ime = job.label..": "..job.grade_label
	end
end)

-- Overall Info
RegisterNetEvent('trew_hud_ui:setInfo')
AddEventHandler('trew_hud_ui:setInfo', function(info)

	TriggerEvent('esx:getSharedObject', function(obj)
		ESX = obj
		ESX.PlayerData = ESX.GetPlayerData()
	end)

	local playerStatus 
	local showPlayerStatus = 0
	playerStatus = { action = 'setStatus', status = {} }


	if Config.ui.showHunger == true then
		showPlayerStatus = (showPlayerStatus+1)

		--[[TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'hunger',
				value = math.floor(100-status.getPercent())
			}
		end)]]

	end

	if Config.ui.showThirst == true then
		showPlayerStatus = (showPlayerStatus+1)

		--[[TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'thirst',
				value = math.floor(100-status.getPercent())
			}
		end)]]
	end

	if showPlayerStatus > 0 then
		SendNUIMessage(playerStatus)
	end


end)


-- Voice detection and distance
Citizen.CreateThread(function()

	if Config.ui.showVoice == true then

	    RequestAnimDict('facials@gen_male@variations@normal')
	    RequestAnimDict('mp_facial')

	    while true do
	        Citizen.Wait(500)
	        local playerID = PlayerId()

	        for _,player in ipairs(GetActivePlayers()) do
	            local boolTalking = NetworkIsPlayerTalking(player)

	            if player ~= playerID then
	                if boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
	                elseif not boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
	                end
	            end
	        end
	    end

	end
end)



Citizen.CreateThread(function()
	if Config.ui.showVoice == true then
		local isTalking = false
		local voiceDistance = nil
		while true do
			Citizen.Wait(500)

			if NetworkIsPlayerTalking(PlayerId()) and not isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			elseif not NetworkIsPlayerTalking(PlayerId()) and isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			end


			if Config.voice.levels.current == 0 then
				voiceDistance = 'normal'
			elseif Config.voice.levels.current == 1 then
				voiceDistance = 'shout'
			elseif Config.voice.levels.current == 2 then
				voiceDistance = 'whisper'
			end

		end
	end
end)




-- Weapons
Citizen.CreateThread(function()
	if Config.ui.showWeapons == true then
		local status = {}
		while true do
			Citizen.Wait(500)

			local player = GetPlayerPed(-1)

			if IsPedArmed(player, 6) then
				local weapon = GetSelectedPedWeapon(player)
				local ammoTotal = GetAmmoInPedWeapon(player,weapon)
				local bool,ammoClip = GetAmmoInClip(player,weapon)
				local ammoRemaining = math.floor(ammoTotal - ammoClip)
				
				status['armed'] = true

				for key,value in pairs(AllWeapons) do

					for keyTwo,valueTwo in pairs(AllWeapons[key]) do
						if weapon == GetHashKey('weapon_'..keyTwo) then
							status['weapon'] = keyTwo

							if key == 'melee' then
								SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
								SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
							else
								if keyTwo == 'stungun' then
									SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
									SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
								else
									SendNUIMessage({ action = 'element', task = 'enable', value = 'weapon_bullets' })
									SendNUIMessage({ action = 'element', task = 'enable', value = 'bullets' })
								end
							end

						end
					end

				end

				SendNUIMessage({ action = 'setText', id = 'weapon_clip', value = ammoClip })
				SendNUIMessage({ action = 'setText', id = 'weapon_ammo', value = ammoRemaining })
				
				SendNUIMessage({ action = 'updateWeapon', status = status })

			else
				if status['armed'] == true then
					status['armed'] = false	
					SendNUIMessage({ action = 'updateWeapon', status = status })
				end
			end

			--SendNUIMessage({ action = 'updateWeapon', status = status })

		end
	end
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	UVozilu = true
	print("zvao")
	Vozilo = currentVehicle
	Klasa = GetVehicleClass(currentVehicle)
	Sjedalo = currentSeat
	Tablica = GetVehicleNumberPlateText(Vozilo)
	ESX.TriggerServerCallback('vozilo:dajKilometre', function(km)
		Kilometri = km
	end, Tablica)
	ESX.TriggerServerCallback('ovjes:DajStari', function(roty, susp)
		prosliy = roty
		orgsusp = susp
		if roty ~= nil then
			local veho = currentVehicle
			eng = false
			while not eng and UVozilu do
				local enge = GetIsVehicleEngineRunning(currentVehicle)
				if IsControlJustPressed(0, 71) or enge then
					local netid = VehToNet(veho)
					TriggerServerEvent("ovjes:SyncSvima", GetPlayerServerId(PlayerId()), netid, prosliy, orgsusp, 0)
					local nbr = GetVehicleSuspensionHeight(veho)
					while nbr > orgsusp do
						SetVehicleSuspensionHeight(veho, nbr-0.0008)
						nbr = nbr-0.0008
						Wait(1)
					end
					local novibr = -0.1
					while prosliy > novibr do
						SetVehicleWheelYRotation(veho, 0, novibr+0.0008)
						SetVehicleWheelYRotation(veho, 1, -novibr+0.0008)
						SetVehicleWheelYRotation(veho, 2, novibr+0.0008)
						SetVehicleWheelYRotation(veho, 3, -novibr+0.0008)
						novibr = novibr+0.0008
						Wait(1)
					end
					orgy = -0.2
					orgsusp = nil
					eng = true
				end
				Wait(1)
			end
		end
	end, netId)
	ZadnjaPoz = GetEntityCoords(Vozilo)
	Citizen.CreateThread(function()
		local zadnjikm = 0
		while UVozilu do
			Citizen.Wait(1000)
			if ZabraniHud == false then
				if Sjedalo == -1 and Klasa ~= 13 and Klasa ~= 14 and Klasa ~= 15 and Klasa ~= 16 and Klasa ~= 17 and Klasa ~= 21 then
					local curPos = GetEntityCoords(Vozilo)
					if IsVehicleOnAllWheels(Vozilo) then
						dist = #(curPos-ZadnjaPoz)
					else
						dist = 0
					end
					Kilometri = Kilometri + math.floor(dist*1.33)/1000
					if Kilometri-zadnjikm >= 1 then
						zadnjikm = Kilometri
						TriggerServerEvent('vozilo:dodajKm', Tablica, Kilometri)
					end
					--[[if Kilometri >= 100 then
						vehica = GetVehiclePedIsIn(PlayerPedId())
						Citizen.CreateThread(function()
							while vehica ~= 0 do
								if not IsControlJustPressed(0, 132) then
									vehica = GetVehiclePedIsIn(PlayerPedId())
									SetVehicleClutch(vehica, 0.0)
								else
									local vrime = GetGameTimer()
									while GetGameTimer()<vrime+500 do
										Citizen.Wait(1)
									end
								end
								Citizen.Wait(1)
							end
						end)
					end]]
					ZadnjaPoz = curPos
				end
			end
		end
	end)
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, modelName, netId)
	ESX.TriggerServerCallback('ovjes:DajStari', function(roty, susp)
		if roty == nil then
			local globalplate = GetVehicleNumberPlateText(currentVehicle)
			if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
				print("uso")
				ESX.TriggerServerCallback('stage:ProvjeriVozilo',function(st)
					local vehica = currentVehicle
					if st ~= 0 and st.zracni == 1 then
						print("ima zracni")
						local speed = GetEntitySpeed(vehica)
						local kmh = (speed * 3.6)
						print(kmh)
						if kmh < 0.1 then
							print("0 kmh")
							local prosliy = GetVehicleWheelYRotation(vehica, 0)
							orgy = prosliy
							local susppr = GetVehicleSuspensionHeight(vehica)
							orgsusp = susppr
							local netid = VehToNet(vehica)
							TriggerServerEvent("ovjes:SyncSvima", GetPlayerServerId(PlayerId()), netid, orgy, orgsusp, 1)
							local novibr = -0.1
							while prosliy > novibr do
								SetVehicleWheelYRotation(vehica, 0, prosliy-0.0008)
								SetVehicleWheelYRotation(vehica, 1, -prosliy-0.0008)
								SetVehicleWheelYRotation(vehica, 2, prosliy-0.0008)
								SetVehicleWheelYRotation(vehica, 3, -prosliy-0.0008)
								prosliy = prosliy-0.0008
								Wait(1)
							end
							local nbr = 0.13
							while nbr > susppr do
								SetVehicleSuspensionHeight(vehica, susppr+0.0008)
								susppr = susppr+0.0008
								Wait(1)
							end
						end
					end
				end, globalplate)
			end
		end
	end, netId)
	UVozilu = false
	Vozilo = nil
	Klasa = nil
	Sjedalo = nil
end)


-- Everything that neededs to be at WAIT 0
Citizen.CreateThread(function()
	local isPauseMenu = false
	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() then -- ESC Key
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = false })
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = true })
			end
			HideHudComponentThisFrame(2)
			if IsHudComponentActive(1) or IsHudComponentActive(3) or IsHudComponentActive(4) or IsHudComponentActive(6) or IsHudComponentActive(7) or IsHudComponentActive(8) or IsHudComponentActive(9) or IsHudComponentActive(13) or IsHudComponentActive(17) or IsHudComponentActive(20) then
				HideHudComponentThisFrame(1)  -- Wanted Stars
				HideHudComponentThisFrame(3)  -- Cash
				HideHudComponentThisFrame(4)  -- MP Cash
				HideHudComponentThisFrame(6)  -- Vehicle Name
				HideHudComponentThisFrame(7)  -- Area Name
				HideHudComponentThisFrame(8)  -- Vehicle Class
				HideHudComponentThisFrame(9)  -- Street Name
				HideHudComponentThisFrame(13) -- Cash Change
				HideHudComponentThisFrame(17) -- Save Game
				HideHudComponentThisFrame(20) -- Weapon State
			end
		end
	end
end)

AddEventHandler('playerSpawned', function()
	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
	
	if Config.ui.showVoice == true then
		if Config.voice.levels.current == 0 then
			NetworkSetTalkerProximity(Config.voice.levels.default)
		elseif Config.voice.levels.current == 1 then
			NetworkSetTalkerProximity(Config.voice.levels.shout)
		elseif Config.voice.levels.current == 2 then
			NetworkSetTalkerProximity(Config.voice.levels.whisper)
		end
	end
	
	if Config.ui.showVoice == true then
	    NetworkSetTalkerProximity(12.0)
	end

	HideHudComponentThisFrame(7) -- Area
	HideHudComponentThisFrame(9) -- Street
	HideHudComponentThisFrame(6) -- Vehicle
	HideHudComponentThisFrame(3) -- SP Cash
	HideHudComponentThisFrame(4) -- MP Cash
	HideHudComponentThisFrame(13) -- Cash changes!
	while ESX.PlayerData.job == nil do
		Wait(0)
	end
	TriggerServerEvent('trew_hud_ui:getServerInfo')
end)









AddEventHandler('trew_hud_ui:setCarSignalLights', function(status)
	local driver = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local hasTrailer,vehicleTrailer = GetVehicleTrailerVehicle(driver,vehicleTrailer)
	local leftLight
	local rightLight

	if status == 'left' then
		leftLight = false
		rightLight = true
		if hasTrailer then driver = vehicleTrailer end

	elseif status == 'right' then
		leftLight = true
		rightLight = false
		if hasTrailer then driver = vehicleTrailer end

	elseif status == 'both' then
		leftLight = true
		rightLight = true
		if hasTrailer then driver = vehicleTrailer end

	else
		leftLight = false
		rightLight = false
		if hasTrailer then driver = vehicleTrailer end

	end

	TriggerServerEvent('trew_hud_ui:syncCarLights', status)

	SetVehicleIndicatorLights(driver, 0, leftLight)
	SetVehicleIndicatorLights(driver, 1, rightLight)
end)



RegisterNetEvent('trew_hud_ui:syncCarLights')
AddEventHandler('trew_hud_ui:syncCarLights', function(driver, status)
	if GetPlayerFromServerId(driver) ~= -1 then
		if GetPlayerFromServerId(driver) ~= PlayerId() then
			local driver = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(driver)), false)

			if status == 'left' then
				leftLight = false
				rightLight = true

			elseif status == 'right' then
				leftLight = true
				rightLight = false

			elseif status == 'both' then
				leftLight = true
				rightLight = true

			else
				leftLight = false
				rightLight = false
			end

			SetVehicleIndicatorLights(driver, 0, leftLight)
			SetVehicleIndicatorLights(driver, 1, rightLight)

		end
	end
end)



function trewDate()
	local timeString = nil
	
	local year, month, day, houra, minutes, second = GetLocalTime()
	
	local hour = houra+1

	local time = nil
	local AmPm = ''


	if Config.date.AmPm == true then

		if hour >= 13 and hour <= 24 then
			hour = hour - 12
			AmPm = 'PM'
		else
			if hour == 0 or hour == 24 then
				hour = 12
			end
			AmPm = 'AM'
		end

	end

	if hour <= 9 then
		hour = '0' .. hour
	end
	if minutes <= 9 then
		minutes = '0' .. minutes
	end

	time = hour .. ':' .. minutes .. ' ' .. AmPm

	local date_format = Locales[Config.Locale]['date_format'][Config.date.format]

	if Config.date.format == 'default' then
		timeString = string.format(
			date_format,
			day, month, year
		)
	elseif Config.date.format == 'simple' then
		timeString = string.format(
			date_format,
			day, month
		)

	elseif Config.date.format == 'simpleWithHours' then
		timeString = string.format(
			date_format,
			time, day, month
		)	
	elseif Config.date.format == 'withWeekday' then
		timeString = string.format(
			date_format,
			weekDay, day, month, year
		)
	elseif Config.date.format == 'withHours' then
		timeString = string.format(
			date_format,
			time, day, month, year
		)
	elseif Config.date.format == 'withWeekdayAndHours' then
		timeString = string.format(
			date_format,
			time, weekDay, day, month, year
		)
	end


	

	return timeString
end






function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



















local toggleui = false
RegisterCommand('toggleui', function()
	if not toggleui then
		SendNUIMessage({ action = 'element', task = 'disable', value = 'ui' })
	else
		SendNUIMessage({ action = 'element', task = 'enable', value = 'ui' })
	end

	toggleui = not toggleui
end)

RegisterNetEvent("SaljiGear")
AddEventHandler("SaljiGear", function(gr)
	Poslao = gr
	local vehicleSpeedSource = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))
	local vehicleSpeed
	if Config.vehicle.speedUnit == 'MPH' then
		vehicleSpeed = math.ceil(vehicleSpeedSource * 2.237)
	else
		vehicleSpeed = math.ceil(vehicleSpeedSource * 3.6)
	end
	vehicleInfo = {
		action = 'updateVehicle',

		status = true,
		gear = gr,
		km = round2(Kilometri, 0),
		speed = vehicleSpeed,
		seatbelt = { status = seatbeltIsOn },
		config = {
			speedUnit = Config.vehicle.speedUnit,
			maxSpeed = Config.vehicle.maxSpeed
		}
	}
	SendNUIMessage(vehicleInfo)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)




exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end)