ESX                             = nil
local Minute = 0
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.TriggerServerCallback('pkuca:DohvatiVrijeme', function (vrijeme)
		Minute = vrijeme
		if vrijeme > 0 then
			BrojiVrijeme()
		end
	end)
end)

local objektici = {
	[1] = {
		["Saffron"] = { Pos = vector3(118.25135040283, 543.99011230469, 183.89744567871), pretrazio = false},
		["Speaker"]  = { Pos = vector3(125.09645843506, 547.57025146484, 184.09689331055), pretrazio = false},
		["Laptop"] = { Pos = vector3(118.00344085693, 548.41369628906, 184.09690856934), pretrazio = false},
		["Bag of Cocaine"] = { Pos = vector3(123.20567321777, 555.37945556641, 184.29708862305), pretrazio = false},
		["Book"]  = { Pos = vector3(118.44779205322, 543.353515625, 180.49751281738), pretrazio = false},
		["Coupon"] = { Pos = vector3(113.94953155518, 562.17327880859, 176.6971282959), pretrazio = false},
		["Toothpaste"] = { Pos = vector3(119.49589538574, 570.03479003906, 176.69709777832), pretrazio = false}
	},
	[2] = {
		["Saffron"] = { Pos = vector3(265.89379882813, -999.44171142578, -99.008590698242), pretrazio = false},
		["Speaker"]  = { Pos = vector3(264.13989257813, -995.4775390625, -99.008590698242), pretrazio = false},
		["Laptop"] = { Pos = vector3(261.95956420898, -995.1552734375, -99.008636474609), pretrazio = false},
		["Bag of Cocaine"] = { Pos = vector3(261.52496337891, -1002.5629272461, -99.008636474609), pretrazio = false},
		["Book"]  = { Pos = vector3(263.00848388672, -1003.0875854492, -99.008636474609), pretrazio = false}
	},
	[3] = {
		["Saffron"] = { Pos = vector3(-674.51049804688, 584.60119628906, 145.16969299316), pretrazio = false},
		["Speaker"]  = {Pos = vector3(-671.81317138672, 581.19378662109, 144.97027587891), pretrazio = false},
		["Laptop"] = { Pos = vector3(-668.32434082031, 588.04925537109, 145.16967773438), pretrazio = false},
		["Bag of Cocaine"] = { Pos = vector3(-671.60125732422, 581.06695556641, 141.57061767578), pretrazio = false},
		["Book"]  = { Pos = vector3(-666.57220458984, 587.11364746094, 141.59564208984), pretrazio = false},
		["Coupon"] = { Pos = vector3(-682.54266357422, 595.76135253906, 137.76582336426), pretrazio = false},
		["Toothpaste"] = { Pos = vector3(-679.27862548828, 585.32684326172, 137.76976013184), pretrazio = false}
	},
}

local interijeri = {
    [1] = { x = 117.20292663574, y = 560.08514404297, z = 183.30488586426 },
    [2] = {x = 266.00659179688, y = -1007.4967651367, z = -102.00854492188},
    [3] = {x = -682.39172363281, y = 592.84936523438, z = 144.37977600098}
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('pkuca:DohvatiVrijeme', function (vrijeme)
		Minute = vrijeme
		if vrijeme > 0 then
			BrojiVrijeme()
		end
	end)
end)

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'pljacka', function(instance)
		
	end, function(instance)
		
	end)
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	if instance.type == 'pljacka' then
		ESX.ShowNotification("Provalili ste u kucu!")
	end
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(instance)
	if instance.type == 'pljacka' then
		ESX.ShowNotification("Izasli ste iz kuce!")
		Wait(1000)
		SetEntityCollision(PlayerPedId(), true, true)
		SetEntityVisible(PlayerPedId(), true, false)
	end
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'pljacka' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('instance:leave')
	end
end)

AddEventHandler('pkuca:hasEnteredMarker', function(zone)
	if zone == 'prodaja' then
		CurrentAction     = 'prodaj'
        CurrentActionMsg  = "Pritisnite E da prodate nakit!"
	end
end)

AddEventHandler('pkuca:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

Citizen.CreateThread(function()
	local unutra = false
	local brojac = 0
	local izlaz = nil
	local zadnjakuca = nil
	local ulaz = nil
	local kuca = nil
	local nekakoord = vector3(6.1003332138062, 6469.1396484375, 30.425291061401)
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local kordic = GetEntityCoords(PlayerPedId())
		if #(nekakoord-kordic) <= 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(27, nekakoord, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
		
		local isInMarker  = false
		local currentZone = nil

		if(#(kordic-nekakoord) < 2.25) then
			isInMarker  = true
			currentZone = "prodaja"
		end
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('pkuca:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('pkuca:hasExitedMarker', lastZone)
		end
		local retval = GetSelectedPedWeapon(PlayerPedId())
		if retval == GetHashKey("WEAPON_CROWBAR") then
			for k, v in pairs(Config.Houses) do
				local vrataCoords = v['door']
				local xo,yo,zo = table.unpack(v['door'])
				if #(vrataCoords-GetEntityCoords(PlayerPedId())) <= 2 then
				--if GetDistanceBetweenCoords(vrataCoords, GetEntityCoords(PlayerPedId()), true) <= 2 then
					waitara = 0
					naso = 1
					if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 140) then
						if Minute <= 0 then
							local retval = GetSelectedPedWeapon(PlayerPedId())
							if retval == GetHashKey("WEAPON_CROWBAR") then
								if zadnjakuca ~= nil then
									if zadnjakuca ~= k then
										brojac = 0
									end
								end
								zadnjakuca = k
								brojac = brojac+1
								Citizen.Wait(1000)
								if brojac == 10 then
									DoScreenFadeOut(100)
									while not IsScreenFadedOut() do
										Wait(1)
									end
									local alarm = math.random(1,10)
									if alarm == 1 or alarm == 3 or alarm == 5 or alarm == 7 or alarm == 9 then
										local PlayerCoords = { x = xo, y = yo, z = zo }
										TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Oglasio se glasan alarm u kuci", PlayerCoords, {
											PlayerCoords = { x = xo, y = yo, z = zo },
										})
									end
									kuca = math.random(1, 3)
									ulaz = GetEntityCoords(PlayerPedId())
									local ime = "Pljacka"..GetPlayerServerId(PlayerId())
									TriggerEvent('instance:create', 'pljacka', {property = ime, owner = ESX.GetPlayerData().identifier})
									SetEntityCoords(PlayerPedId(), interijeri[kuca].x, interijeri[kuca].y, interijeri[kuca].z)
									izlaz = vector3(interijeri[kuca].x, interijeri[kuca].y, interijeri[kuca].z)
									brojac = 0
									unutra = true
									TriggerServerEvent("pkuca:SpremiVrijeme", 30)
									TriggerServerEvent("pkuca:NekiEvent", true)
									Minute = 30
									Wait(300)
									DoScreenFadeIn(100)
								end
							end
						else
							if Minute >= 2 and Minute <= 4 then
								ESX.ShowNotification("Vi ne mozete pljackati novu kucu jos "..Minute.." minute")
							elseif Minute == 1 then
								ESX.ShowNotification("Vi ne mozete pljackati novu kucu jos "..Minute.." minutu")
							else
								ESX.ShowNotification("Vi ne mozete pljackati novu kucu jos "..Minute.." minuta")
							end
						end
					end
				end
			end
		end
		if unutra then
			waitara = 0
			naso = 1
			for k,v in pairs(objektici[kuca]) do
				if v.pretrazio == false then
					local playerPed = PlayerPedId()
					local coords = GetEntityCoords(playerPed)
					local dist   = #(v.Pos-coords)
					if dist <= 1.2 then
						DrawText3D(v.Pos.x, v.Pos.y, v.Pos.z, "Pritisnite E da pretrazite!", 0.4)
						if dist <= 0.5 and IsControlJustPressed(0, 38) then
							v.pretrazio = true
							FreezeEntityPosition(playerPed, true)
							TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
							Citizen.Wait(10000)
							ClearPedTasks(playerPed)
							FreezeEntityPosition(playerPed, false)
							TriggerServerEvent("pkuca:DajItem", v)
						end
					end
				end
			end
			if #(izlaz-GetEntityCoords(PlayerPedId())) <= 2 then
			--if GetDistanceBetweenCoords(izlaz, GetEntityCoords(PlayerPedId()), true) <= 2 then
				DrawText3D(izlaz.x, izlaz.y, izlaz.z, "Pritisnite E da izadjete iz kuce!", 0.4)
				if IsControlJustPressed(0, 38) then
					DoScreenFadeOut(100)
					while not IsScreenFadedOut() do
						Wait(1)
					end
					SetEntityCoords(PlayerPedId(), ulaz)
					brojac = 0
					unutra = false
					for k,v in pairs(objektici[kuca]) do
						if v.pretrazio == true then
							v.pretrazio = false
						end
					end
					kuca = nil
					TriggerEvent('instance:leave')
					TriggerEvent('instance:close')
					TriggerServerEvent("pkuca:NekiEvent", false)
					SetEntityCollision(PlayerPedId(), true, true)
					SetEntityVisible(PlayerPedId(), true, false)
					BrojiVrijeme()
					Wait(300)
					DoScreenFadeIn(100)
				end
			end
		end
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustPressed(0, 38) then
				if CurrentAction == 'prodaj' then
					TriggerServerEvent("pkuca:ProdajStvari")
				end
				CurrentAction = nil
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function BrojiVrijeme()
	Citizen.CreateThread(function()
		while Minute > 0 do
			Wait(60000)
			Minute = Minute-1
			TriggerServerEvent("pkuca:SpremiVrijeme", Minute)
		end
	end)
end

function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end