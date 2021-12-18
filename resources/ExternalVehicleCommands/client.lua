----------------------------------------------
-- External Vehicle Commands, Made by FAXES --
----------------------------------------------

--- Config ---

usingKeyPress = false -- Allow use of a key press combo (default Ctrl + E) to open trunk/hood from outside
togKey = 38 -- E


--- Code ---

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand("gepek", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
			local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else
				if not locked then
					SetVehicleDoorOpen(closecar, door, false, false)
					TriggerEvent("gepeke:OtvoriGa")
				else
					ShowInfo("Vozilo je zakljucano.")
				end
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("hauba", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else	
                SetVehicleDoorOpen(closecar, door, false, false)
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("vrata", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/vrata [vrata]")
        ShowInfo("~y~Moguce vrata:")
        ShowInfo("1(Prednja ljeva), 2(Prednja desna)")
        ShowInfo("3(Straznja ljeva), 4(Straznja desna)")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
            else	
                SetVehicleDoorOpen(veh, door, false, false)
            end
        else
            if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
                if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                    SetVehicleDoorShut(closecar, door, false)
                else	
                    SetVehicleDoorOpen(closecar, door, false, false)
                end
            else
                ShowInfo("Previse ste udaljeni od vozila.")
            end
        end
    end
end)

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                        else	
                            SetVehicleDoorOpen(vehLast, door, false, false)
                        end
                    else
                        ShowInfo("Previse ste udaljeni od vozila.")
                    end
                end
            end
        end
    end)
end
