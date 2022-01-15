ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local setGear = GetHashKey('SET_VEHICLE_CURRENT_GEAR') & 0xFFFFFFFF
local function SetVehicleCurrentGear(veh, gear)
	Citizen.InvokeNative(setGear, veh, gear)
end

local nextGear = GetHashKey('SET_VEHICLE_NEXT_GEAR') & 0xFFFFFFFF
local function SetVehicleNextGear(veh, gear)
	Citizen.InvokeNative(nextGear, veh, gear)
end

local function ForceVehicleGear (vehicle, gear)
	SetVehicleCurrentGear(vehicle, gear)
	SetVehicleNextGear(vehicle, gear)
	return gear
end

--------------------------------------------------------------------------------
local Manual = false

local mode

RegisterNetEvent('EoTiIzSalona')
AddEventHandler('EoTiIzSalona', function(br)
	if br == 1 then
		Manual = false
		TriggerEvent("SaljiGear", -69)
	elseif br == 2 then
		Manual = true
	end
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	local globalplate  = GetVehicleNumberPlateText(currentVehicle)
	if currentSeat == -1 then
		if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
			ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
				if mj == 2 then
					Manual = true
				end
			end, globalplate)
		end
	end
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, modelName, netId)
	Manual = false
	odradio = false
	TriggerEvent("SaljiGear", -69)
end)

Citizen.CreateThread(function ()
	local vehicle, lastVehicle, ped
	local gear, maxGear
	local nextMode, maxMode
	local odradio = false

	local braking
	local function HandleVehicleBrake ()
		if gear == 0 then -- Prevent reversing
			DisableControlAction(2, 72, true)
			-- use parking brake once stopped
			if IsDisabledControlPressed(2, 72) then
				SetControlNormal(2, 76, 1.0)
				braking = true
			end
		elseif IsControlPressed(2, 72) then
			braking = true
		end
	end
	
	local function Brejkaj ()
		Citizen.CreateThread(function ()
			if gear == 1 then
				SetVehicleHandbrake(vehicle, true)
				Wait(1000)
				SetVehicleHandbrake(vehicle, false)
			end
		end)
	end

	local function OnTick()
			braking = false

			-- Reverse
			if mode == 1 then
				DisableControlAction(2, 71, true)
				-- gas
				if IsDisabledControlPressed(2, 71) then
					SetControlNormal(2, 72, GetDisabledControlNormal(2, 71))
				else
					HandleVehicleBrake()
				end

			-- Neutral
			elseif mode == 2 then
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, 1)

				-- gas
				DisableControlAction(2, 71, true)
				DisableControlAction(2, 72, true)
				while IsDisabledControlPressed(2, 71) and GetIsVehicleEngineRunning(vehicle) do
					SetVehicleHandbrake(vehicle, true)
					SetVehicleCurrentRpm(vehicle, 0.89)
					Wait(50)
					SetControlNormal(0, 71, 1.0)
					--SetVehicleCurrentRpm(vehicle, 0.7)
					Wait(50)
					SetControlNormal(0, 71, 0.0)
					--SetVehicleCurrentRpm(vehicle, 1.0)
					Wait(1)
				end
				SetVehicleHandbrake(vehicle, false)
				if IsDisabledControlPressed(2, 72) then
					SetVehicleBrakeLights(vehicle, true)
					SetVehicleNextGear(vehicle, 0)
					braking = true
				end
			-- Drive
			else
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, mode - 2)
			end

			-- Brake
			if braking or IsControlPressed(2, 76) then
				SetVehicleBrakeLights(vehicle, true)
				--SetVehicleNextGear(vehicle, 0)
				braking = true
			end
	end
	local waitara = 500
	while true do
		local naso = 0
		if Manual == true then
			naso = 1
			waitara = 0
			ped = PlayerPedId()
			vehicle = GetVehiclePedIsUsing(ped)
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
				gear = GetVehicleCurrentGear(vehicle)

				-- Entered vehicle
				if lastVehicle ~= vehicle then
					lastVehicle = vehicle
					maxGear = GetVehicleHighGear(vehicle)
					maxMode = 2 + maxGear

					-- Use current gear | neutral
					if gear >= 1 then
						mode = gear + 2
					else
						mode = 2
					end
				end
				if odradio == false then
					maxGear = GetVehicleHighGear(vehicle)
					maxMode = 2 + maxGear
					nextMode = math.min(mode, maxMode)
					local modeText = { 'R', 'N'}
					local gira
					if mode >=2 then
						gira = nextMode - 2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					if gira == nil or gira == 0 or gira == '' then
						gira = "N"
					end
					TriggerEvent("SaljiGear", gira)
					odradio = true
				end

				-- Gear up | down
				if IsControlJustPressed(0, 131) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.min(mode + 1, maxMode)
					local modeText = { 'R', 'N'}
					
					local gira
					if mode >=2 then
						gira = nextMode - 2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					TriggerEvent("SaljiGear", gira)
				elseif IsControlJustPressed(0, 132) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.max(mode - 1, 1)
					local modeText = { 'R', 'N'}
					
					local gira
					if nextMode >=2 then
						gira = nextMode-2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					
					if gira == nil or gira == 0 or gira == '' then
						gira = "N"
					end
					TriggerEvent("SaljiGear", gira)
					Brejkaj()
					local speed = GetEntitySpeed(vehicle)
					local kmh = (speed * 3.6)
					if gira ~= "N" and gira ~= "R" and gira ~= 1 and kmh > 5 then
						local vrime = GetGameTimer()
						SetVehicleCurrentRpm(vehicle, 2.0)
						while GetGameTimer()<vrime+500 do
							--SetControlNormal(0, 71, 0)
							--SetVehicleCurrentRpm(vehicle, 1.0)
							--Wait(100)
							--SetControlNormal(0, 71, 1.0)
							--SetVehicleCurrentRpm(vehicle, 2.0)
							SetVehicleClutch(vehicle, 0.0)
							SetControlNormal(0, 71, 1.0)
							Wait(1)
						end
					end
				else
					nextMode = mode
				end
				-- On Shift
				if nextMode ~= mode then
					mode = nextMode
				end

				OnTick()
			elseif lastVehicle then
				lastVehicle = false
				mode = false
			end
			
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				local speed = GetEntitySpeed(vehicle)
				local kmh = (speed * 3.6)
				if IsControlPressed(0, 71) then
					if kmh < 5 then
						if gear > 1 and GetIsVehicleEngineRunning(vehicle) then
							SetVehicleEngineOn( vehicle, false, true, true )
						end
					end
				end
				if kmh < 2 then
					SetVehicleNextGear(vehicle, 0)
				end
			end
		end
		Wait(waitara)
		if naso == 0 then
			waitara = 500
		end
	end
end)

--------------------------------------------------------------------------------
