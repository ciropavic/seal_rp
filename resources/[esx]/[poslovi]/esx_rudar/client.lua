ESX = nil
local mining = false
local tipfirme = nil
local blip1 = nil
local blip2 = nil
local blip3 = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	print("poceo trazit firmu")
	while ESX.GetPlayerData().firma == nil do
		Citizen.Wait(100)
	end
	print("zavrsio trazenje firme")
	ProvjeriPosao()
end)

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	print("dohvatio playerdata 23")
	print(ESX.PlayerData.firma)
	ESX.TriggerServerCallback('esx_firme:DajTipFirme', function(tip)
		print("vratio tip")
		print(tip)
		tipfirme = tip
		ReloadBlip(tip)
	end, ESX.PlayerData.firma)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
	ProvjeriPosao()
end)

RegisterNetEvent('esx:setFirma')
AddEventHandler('esx:setFirma', function(job)
	ESX.PlayerData.firma = job
	ESX.TriggerServerCallback('esx_firme:DajTipFirme', function(tip)
		tipfirme = tip
		ReloadBlip(tip)
	end, job)
end)

function ReloadBlip(tip)
	if blip1 ~= nil then
		RemoveBlip(blip1)
		blip1 = nil
	end
	if blip2 ~= nil then
		RemoveBlip(blip2)
		blip2 = nil
	end
	if blip3 ~= nil then
		RemoveBlip(blip3)
		blip3 = nil
	end
	if tip == 5 then
		local br = 0
		for k, v in pairs(Config.MiningPositions) do
			if br == 0 then
				blip1 = addBlip(v.coords, 762, 5, Strings['mining'])
			elseif br == 1 then
				blip2 = addBlip(v.coords, 762, 5, Strings['mining'])
			else
				blip3 = addBlip(v.coords, 762, 5, Strings['mining'])
			end
			br = br+1
		end
	end
end

Citizen.CreateThread(function()
	while tipfirme == nil do
		Wait(100)
	end
    while true do
        local closeTo = 0
		if tipfirme == 5 then
			for k, v in pairs(Config.MiningPositions) do
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords, true) <= 2.5 then
					closeTo = v
					break
				end
			end
			if type(closeTo) == 'table' then
				while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 2.5 do
					Wait(0)
					helpText(Strings['press_mine'])
					if IsControlJustReleased(0, 38) then
						local player, distance = ESX.Game.GetClosestPlayer()
						if distance == -1 or distance >= 4.0 then
							mining = true
							SetEntityCoords(PlayerPedId(), closeTo.coords)
							SetEntityHeading(PlayerPedId(), closeTo.heading)
							FreezeEntityPosition(PlayerPedId(), true)

							local model = loadModel(GetHashKey(Config.Objects['pickaxe']))
							local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
							AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)

							while mining do
								Wait(0)
								SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
								helpText(Strings['mining_info'])
								DisableControlAction(0, 24, true)
								if IsDisabledControlJustReleased(0, 24) then
									local dict = loadDict('melee@hatchet@streamed_core')
									TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
									local timer = GetGameTimer() + 800
									while GetGameTimer() <= timer do Wait(0) DisableControlAction(0, 24, true) end
									ClearPedTasks(PlayerPedId())
									TriggerServerEvent('esx_mining:getItem', ESX.PlayerData.firma, tipfirme)
								elseif IsControlJustReleased(0, 194) then
									break
								end
							end
							mining = false
							DeleteObject(axe)
							FreezeEntityPosition(PlayerPedId(), false)
						else
							ESX.ShowNotification(Strings['someone_close'])
						end
					end
				end
			end
		end
        Wait(250)
    end
end)

loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

addBlip = function(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
	return blip
end