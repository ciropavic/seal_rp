-- optimizations
local tonumber            = tonumber
local unpack              = table.unpack
local CreateThread        = Citizen.CreateThread
local Wait                = Citizen.Wait
local TriggerEvent        = TriggerEvent
local RegisterCommand     = RegisterCommand
local PlayerPedId         = PlayerPedId
local IsPedInAnyVehicle   = IsPedInAnyVehicle
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehiclePedIsIn   = GetVehiclePedIsIn
local GetIsTaskActive     = GetIsTaskActive
local SetPedIntoVehicle   = SetPedIntoVehicle
local disabled            = false
local UVozilu 			  = false
local Sjedalo 			  = nil
local Vozilo = nil

ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	UVozilu = true
	Sjedalo = currentSeat
	Vozilo = currentVehicle
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

CreateThread(function()
	local waitara = 200
    while true do
        Wait(waitara)
		local naso = 0
        if UVozilu and not disabled then
            local veh = Vozilo
            if Sjedalo == 0 then
				waitara = 0
				naso = 1
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
		if naso == 0 then
			waitara = 200
		end
    end
end)

RegisterCommand("prebaci", function()
    CreateThread(function()
        disabled = true
        Wait(3000)
        disabled = false
		Sjedalo = GetPedVehicleSeat(PlayerPedId())
		if Sjedalo == -1 then
			local globalplate  = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
			if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
				ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
					TriggerEvent("EoTiIzSalona", mj)
				end, globalplate)
			end
		end
    end)
end)

TriggerEvent('chat:addSuggestion', '/prebaci', 'Koristite da se prebacite na vozacevo mjesto!')