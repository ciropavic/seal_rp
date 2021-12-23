local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

local zvao = false

AddEventHandler('gameEventTriggered', function (name, data)
    if name == "CEventNetworkPlayerEnteredVehicle" and not zvao then
		if data[1] == 128 then
			zvao = true
			isInVehicle = true
			currentVehicle = data[2]
			currentSeat = GetPedVehicleSeat(PlayerPedId())
			local netId = VehToNet(currentVehicle)
			TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
			TriggerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)

			Citizen.CreateThread(function()
				while isInVehicle do
					local ped = PlayerPedId()
					if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) or currentSeat ~= GetPedVehicleSeat(PlayerPedId()) then
						-- bye, vehicle
						zvao = false
						local model = GetEntityModel(currentVehicle)
						local name = GetDisplayNameFromVehicleModel()
						local netId = VehToNet(currentVehicle)
						TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
						TriggerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
						isInVehicle = false
						currentVehicle = 0
						currentSeat = 0
						print("izaso")
					end
					Citizen.Wait(500)
				end
			end)
		end
	end
end)