-- AreCoordsCollidingWithExterior()
local OwnedHouse = nil
local AvailableHouses = {}
local blips = {}
local Knockings = {}
local GarazaV 					= nil
local Vblip 					= nil
local Objekti = {}
local Izrasla = false
local Kosim = false
local prop_ent = nil
local Broj = 0
local UKuci = false

--[[Citizen['CreateThread'](function()
    while true do
        Wait(0)
        DrawEdge(PlayerPedId())
        local coords = GetEntityCoords(PlayerPedId())
        local found, coords, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 3.0, 100.0, 2.5)
        if IsControlJustReleased(0, 38) then
            SetEntityCoords(PlayerPedId(), coords)
            SetEntityHeading(PlayerPedId(), heading)
        end
    end
end)]]

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

function OpenGarageMenu(co,he)
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)

 	for _,v in pairs(vehicles) do
		if v.brod == 0 then
			ESX.TriggerServerCallback('pijaca:JelNaProdaju', function(br)
				if not br then
					local hashVehicule = v.model
					local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
					local labelvehicle
					if v.state == 1 then
						labelvehicle = vehicleName..' <font color="green">U garazi</font>'
					elseif v.state == 2 then
						labelvehicle = vehicleName..' <font color="red">Ukradeno</font>'
					elseif v.state == 0 then
						labelvehicle = vehicleName..' <font color="red">Izvan garaze</font>'
					end    
					table.insert(elements, {label =labelvehicle , value = v})
				end
			end)
        end
   	 end
		Wait(500)
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = "Garaza",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if data.current.value.state == 1 then
				menu.close()
				data.current.value.vehicle.model = data.current.value.model
				SpawnVehicle(data.current.value.vehicle, co, he)
			elseif data.current.value.state == 2 then
				exports.pNotify:SendNotification({ text = "Vase vozilo je ukradeno", queue = "right", timeout = 3000, layout = "centerLeft" })
			else
				ESX.UI.Menu.CloseAll()

				local elements2 = {
					{label = "Da $"..Config.Price, value = 'yes'},
					{label = "Ne", value = 'no'},
				}
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'plati_menu',
					{
						title    = "Zelite li platiti vracanje vozila u garazu?",
						align    = 'top-left',
						elements = elements2,
					},
					function(data2, menu2)

						
						if(data2.current.value == 'yes') then
							ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
								if hasEnoughMoney then
									menu2.close()
									TriggerServerEvent('garaza:tuljaniziraj2')
									data.current.value.vehicle.model = data.current.value.model
									SpawnVehicle(data.current.value.vehicle, co, he)
								else
									menu2.close()
									exports.pNotify:SendNotification({ text = "Nemate dovoljno novca", queue = "right", timeout = 3000, layout = "centerLeft" })
								end
							end)
						end
						if(data2.current.value == 'no') then
							menu2.close()
						end
					end,
					function(data2, menu2)
						menu2.close()
					end
				)	
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
	)	
	end)
end

function SpawnVehicle(vehicle, co, he)
	if GarazaV ~= nil then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
	TriggerServerEvent("kuce:SpawnVozilo", vehicle, co, he)
end

RegisterNetEvent('loaf_housing:SaljiKucice')
AddEventHandler('loaf_housing:SaljiKucice', function(kuce)
	Config.Houses = kuce
end)

RegisterNetEvent('kuce:VratiVozilo')
AddEventHandler('kuce:VratiVozilo', function(nid, vehicle, co)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	if attempt < 100 then
		local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		while not DoesEntityExist(callback_vehicle) do
			Wait(1)
			callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		end
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	else
		print("Greska prilikom kreiranja vozila. NetID: "..nid)
		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, co)
		local coords = GetEntityCoords(ped)
		local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
		local callback_vehicle = veh
		--ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	end
end)

RegisterCommand("zavrsikosenje", function(source, args, rawCommandString)
	if Kosim == true then
		Kosim = false
		if prop_ent ~= nil then
			DeleteObject(prop_ent)
			prop_ent = nil
		end
		SendNUIMessage({
			stop = true
		})
		ClearPedSecondaryTask(PlayerPedId())
		ESX.ShowNotification("Prestali ste kositi!")
	else
		ESX.ShowNotification("Ne kosite travu!")
	end
end, false)

function IzrastiTravo()
	if OwnedHouse.houseId > 0 then
		if Config.Trava[OwnedHouse.houseId] ~= nil then
			for i=1, #Config.Trava[OwnedHouse.houseId], 1 do
				local xa, ya, za = table.unpack(Config.Trava[OwnedHouse.houseId][i])
				ESX.Game.SpawnLocalObject('prop_veg_grass_02_a', {
					x = xa,
					y = ya,
					z = za
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					Objekti[i] = obj
				end)
			end
			Broj = #Config.Trava[OwnedHouse.houseId]
			Izrasla = true
		end
	end
end

function PokreniProvjeru()
    while Kosim do
        Citizen.Wait(20)
		if Izrasla == true and Broj > 0 then
			local cora = GetEntityCoords(prop_ent)
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_veg_grass_02_a", cora)
			for i=1, #Objekti, 1 do
				if Objekti[i] == NewBin then
					if NewBinDistance <= 0.8 then
						ESX.Game.DeleteObject(Objekti[i])
						Broj = Broj-1
						if Broj == 0 then
							DeleteObject(prop_ent)
							SendNUIMessage({
								stop = true
							})
							prop_ent = nil
							Izrasla = false
							Kosim = false
							Broj = 0
							ClearPedSecondaryTask(PlayerPedId())
							ESX.ShowNotification("Uspjesno zavrseno kosenje!")
							SetTimeout(Config.RastTrave, IzrastiTravo)
						end
					end
				end
			end
		end
    end
end

AddEventHandler('esx:onPlayerDeath', function(data)
	if Kosim == true then
		Kosim = false
		if prop_ent ~= nil then
			DeleteObject(prop_ent)
			prop_ent = nil
		end
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
	while #Config.Houses == 0 do Wait(1000) end
    TriggerServerEvent('loaf_housing:getOwned')
    while OwnedHouse == nil do Wait(5000) end

    if Config.IKEABlip['Enabled'] then
        local blip = AddBlipForCoord(Config.Furnituring['enter'])
        SetBlipSprite(blip, Config.IKEABlip['Sprite'])
        SetBlipColour(blip, Config.IKEABlip['Colour'])
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.IKEABlip['Scale'])
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Strings['ikea'])
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

	if OwnedHouse.houseId > 0 then
		IzrastiTravo()
	end

    while true do
        Citizen.Wait(1500)
        for ka, v in pairs(Config.Houses) do
			local k = v['ID']
            if Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 2.5 then
                local text = 'error'
                while Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 2.5 do
                    if OwnedHouse.houseId == k then
                        text = (Strings['Press_E']):format(Strings['Manage_House'])
                    else
                        if not AvailableHouses[k] then
                            if OwnedHouse.houseId ~= 0 then
                                text = Strings['Must_Sell']
                            else
                                text = (Strings['Press_E']):format((Strings['Buy_House']):format(k, v['price']))
                            end
                        else
                            text = (Strings['Press_E']):format(Strings['Knock_House'])
                        end
                    end
                    HelpText(text, v['door'])
                    if IsControlJustReleased(0, 38) then
                        if OwnedHouse.houseId == k then
                            ESX.UI.Menu.CloseAll()
                            elements = {
                                {label = Strings['Enter_House'], value = 'enter'},
                                {label = (Strings['Sell_House']):format(math.floor(Config.Houses[ka]['price']*(Config.SellPercentage/100))), value = 'sell'},
                            }
                            if Config.EnableGarage then
                                table.insert(elements, {label = Strings['Garage'], value = 'garage'})
                            end
							if Config.Trava[OwnedHouse.houseId] ~= nil then
								if Kosim == false then
									table.insert(elements, {label = "Pokosite travu", value = 'trava'})
								else
									table.insert(elements, {label = "Prestanite kositi", value = 'trava2'})
								end
							end
                            ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'manage_house',
                                {
                                    title = Strings['Manage_House'],
                                    align = 'top-left',
                                    elements = elements
                                },
                                function(data, menu)
                                    if data.current.value == 'enter' then
										if Kosim == false then
											TriggerServerEvent('loaf_housing:enterHouse', k, ka)
											menu.close()
										else
											ESX.ShowNotification("Zavrsite sa kosenjem prvo!")
										end
                                    elseif data.current.value == 'garage' then
										if Kosim == false then
											local coords = Config.Houses[ka]['door']
											local found, coords, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 4, 10.0, 0)
											if found then
												ESX.UI.Menu.CloseAll()
												--TriggerServerEvent('esx_garage:viewVehicles', coords, heading, 'housing')
												OpenGarageMenu(coords,heading)
												return
											else
												ESX.ShowNotification(Strings['No_Spawn'])
											end
										else
											ESX.ShowNotification("Zavrsite sa kosenjem prvo!")
										end
                                    elseif data.current.value == 'sell' then
										if Kosim == false then
											if v['prodaja'] == 0 then
												ESX.UI.Menu.Open(
													'default', GetCurrentResourceName(), 'sell',
												{
													title = (Strings['Sell_Confirm']):format(math.floor(Config.Houses[ka]['price']*(Config.SellPercentage/100))),
													align = 'top-left',
													elements = {
														{label = Strings['yes'], value = 'yes'},
														{label = Strings['no'], value = 'no'}
													},
												},
												function(data2, menu2)
													if data2.current.value == 'yes' then
														if Izrasla then
															for i=1, #Config.Trava[OwnedHouse.houseId], 1 do
																ESX.Game.DeleteObject(Objekti[i])
															end
															Objekti = {}
															Izrasla = false
														end
														OwnedHouse.houseId = 0
														Kosim = false
														TriggerServerEvent('loaf_housing:sellHouse')
														ESX.UI.Menu.CloseAll()
														Wait(5000)
													else
														menu2.close()
													end
												end, 
													function(data2, menu2)
													menu2.close()
												end)
											else
												ESX.ShowNotification("Ne mozete prodati kucu koju imate na svom zemljistu!")
											end
										else
											ESX.ShowNotification("Zavrsite sa kosenjem prvo!")
										end
									elseif data.current.value == 'trava' then
                                        if Izrasla and Kosim == false then
											ESX.UI.Menu.CloseAll()
											local x,y,z = table.unpack(Config.Trava[OwnedHouse.houseId][8])
											SetEntityCoords(PlayerPedId(), x,y,z, false, false, false, true)
											Kosim = true
											if prop_ent ~= nil then
												DeleteObject(prop_ent)
											end
											ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
												TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50)
											end)
											local modele = "prop_lawnmower_01"
											ESX.Streaming.RequestModel(modele)
											prop_ent = CreateObject(GetHashKey(modele), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0), true, false, false)
											AttachEntityToEntityPhysically(prop_ent, PlayerPedId(), 0, GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis"), 0.175, 0.90, -0.86, -0.075, 0.90, -0.86, 0.0, 0.5, 181.0, 10000.0, true, true, true, false, 2)
											SetModelAsNoLongerNeeded(modele)
											SendNUIMessage({
												start = true
											})
											ESX.ShowNotification("Da prestanete kositi upisite /zavrsikosenje")
											PokreniProvjeru()
										else
											ESX.ShowNotification("Trava nije izrasla ili vec kosite!")
										end
									elseif data.current.value == 'trava2' then
                                        if Kosim == true then
											ESX.UI.Menu.CloseAll()
											Kosim = false
											if prop_ent ~= nil then
												DeleteObject(prop_ent)
												prop_ent = nil
											end
											ClearPedSecondaryTask(PlayerPedId())
											ESX.ShowNotification("Prestali ste kositi!")
										else
											ESX.ShowNotification("Ne kosite travu!")
										end
                                    end
                                end,
                            function(data, menu)
                                menu.close()
                            end)
                        else
                            if not AvailableHouses[k] and OwnedHouse.houseId == 0 then
                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'buy',
                                {
                                    title = (Strings['Buy_House_Confirm']):format(k, v['price']),
                                    align = 'top-left',
                                    elements = {
                                        {label = Strings['yes'], value = 'yes'},
                                        {label = Strings['no'], value = 'no'}
                                    },
                                },
                                function(data, menu)
                                    if data.current.value == 'yes' then
										ESX.TriggerServerCallback('zemljista:ImalZemljiste', function(imal)
											if not imal then
												TriggerServerEvent('loaf_housing:buyHouse', k, ka)
												ESX.UI.Menu.CloseAll()
												Wait(5000)
												SetTimeout(Config.RastTrave, IzrastiTravo)
											else
												ESX.ShowNotification("Vec imate kupljeno zemljiste!")
												ESX.UI.Menu.CloseAll()
											end
										end)
                                    else
                                        menu.close()
                                    end
                                end, 
                                    function(data, menu)
                                    menu.close()
                                end)
                            else
                                if AvailableHouses[k] then
                                    TriggerServerEvent('loaf_housing:knockDoor', ka)
                                    while Vdist2(GetEntityCoords(PlayerPedId()), v['door']) <= 4.5 do Wait(0) HelpText(Strings['Waiting_Owner'], v['door']) end
                                    TriggerServerEvent('loaf_housing:unKnockDoor', ka)
                                end
                            end
                        end
                        Wait(5000)
                    end
                    Wait(0)
                end
            else
                if OwnedHouse.houseId == k then
                    local coords = v['door']
                    local found, coords, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 4, 10.0, 0)
                    if found then
                        while #(GetEntityCoords(PlayerPedId()) - coords) <= 45.0 and IsPedInAnyVehicle(PlayerPedId(), false) and Config.EnableGarage do
                            Wait(0)
                            DrawMarker(1, coords-vector3(0.0, 0.0, 0.5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.2), 255, 255, 25, 150, false, false, 2, false, false, false)

                            if #(GetEntityCoords(PlayerPedId()) - coords) <= 5.0 and IsPedInAnyVehicle(PlayerPedId(), false) and Config.EnableGarage then
                                HelpText(Strings['Store_Garage'], coords)
                                if IsControlJustReleased(0, 38) then
                                    --TriggerEvent('esx_garage:storeVehicle', 'housing')
									TriggerEvent("eden_garage:vrativozilo")
                                end
                            end

                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while OwnedHouse == nil do Wait(0) end
	local waitara = 500
    while true do
        Wait(waitara)
        local dist = Vdist2(GetEntityCoords(PlayerPedId()), Config.Furnituring['enter']) 
        if dist <= 50.0 then
			waitara = 0
            DrawMarker(27, Config.Furnituring['enter'], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
            if dist <= 1.5 then
                HelpText((Strings['Press_E']):format(Strings['Buy_Furniture']), Config.Furnituring['enter'])
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    local currentcategory = 1
                    local category = Config.Furniture['Categories'][currentcategory]

                    local current = 1
                    local cooldown = GetGameTimer()

                    local model = GetHashKey(Config.Furniture[category[1]][current][2])

                    if IsModelValid(model) then
                        local startedLoading = GetGameTimer()
                        while not HasModelLoaded(model) do 
                            RequestModel(model) Wait(0) 
                            if GetGameTimer() - startedLoading >= 1500 then
                                ESX.ShowNotification(('Modelu (%s) treba previse da se ucita. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                                break
                            end
                        end
                        furniture = CreateObject(model, Config.Furnituring['teleport'])
                        SetEntityHeading(furniture, 0.0)
                    else
                        ESX.ShowNotification(('Model (%s) ne postoji. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                    end

                    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
                    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.0))
                    PointCamAtCoord(cam, GetEntityCoords(furniture))
                    RenderScriptCams(1, 0, 0, 1, 1)
                    SetCamActive(cam, true) 
                    FreezeEntityPosition(PlayerPedId(), true)
                    while true do
                        Wait(0)
                        HelpText((Strings['Buying_Furniture']):format(category[2], Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]))

                        DrawText3D(GetEntityCoords(furniture), ('%s (~g~$%s~w~)'):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]), 0.5)

                        DisableControlAction(0, 24)
                        DisableControlAction(0, 25)
                        DisableControlAction(0, 14)
                        DisableControlAction(0, 15)
                        DisableControlAction(0, 16)
                        DisableControlAction(0, 17)
                        NetworkOverrideClockTime(15, 0, 0)
                        ClearOverrideWeather()
                        ClearWeatherTypePersist()
                        SetWeatherTypePersist('EXTRASUNNY')
                        SetWeatherTypeNow('EXTRASUNNY')
                        SetWeatherTypeNowPersist('EXTRASUNNY')

                        if IsControlJustReleased(0, 194) then
                            break
                        elseif IsControlJustReleased(0, 172) then
                            if Config.Furniture['Categories'][currentcategory + 1] then
                                category = Config.Furniture['Categories'][currentcategory + 1]
                                currentcategory = currentcategory + 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][1]
                                currentcategory = 1
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('Modelu (%s) treba previse da se ucita. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('Model (%s) ne postoji. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlPressed(0, 34) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) + 0.25)
                        elseif IsControlPressed(0, 35) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) - 0.25)
                        elseif IsDisabledControlPressed(0, 96) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z + 0.1 <= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.5).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z + 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsDisabledControlPressed(0, 97) then
                            print('hej')
                            local currentCoord = GetCamCoord(cam)
                            print(currentCoord)
                            if currentCoord.z - 0.1 >= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 0.1).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z - 0.1)
                                print(currentCoord)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsControlPressed(0, 33) then
                            local fov = GetCamFov(cam)
                            if fov + 0.1 >= 129.9 then fov = 129.9 else fov = fov + 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlPressed(0, 32) then
                            local fov = GetCamFov(cam)
                            if fov - 0.1 <= 1.1 then fov = 1.1 else fov = fov - 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlJustReleased(0, 173) then
                            if Config.Furniture['Categories'][currentcategory - 1] then
                                category = Config.Furniture['Categories'][currentcategory - 1]
                                currentcategory = currentcategory - 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][#Config.Furniture['Categories']]
                                currentcategory = #Config.Furniture['Categories']
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('Modelu (%s) treba previse da se ucita. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('Model (%s) ne postoji. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlJustReleased(0, 191) then
                            local answered = false
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'buy_furniture',
                            {
                                title = (Strings['Confirm_Purchase']):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]),
                                align = 'center',
                                elements = {
                                    {label = Strings['yes'], value = 'yes'},
                                    {label = Strings['no'], value = 'no'}
                                },
                            },
                            function(data, menu)
                                menu.close()
                                if data.current.value == 'yes' then
                                    TriggerServerEvent('loaf_housing:buy_furniture', currentcategory, current)
                                    DoScreenFadeOut(250)
                                    Wait(1500)
                                    DoScreenFadeIn(500)
                                end
                                answered = true
                            end, 
                                function(data, menu)
                                    answered = true
                                    menu.close()
                                end
                            )
                            while not answered do Wait(0) end
                        elseif IsControlPressed(0, 190) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current + 1] then
                                current = current + 1
                            else
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('Modelu (%s) treba previse da se ucita. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('Model (%s) ne postoji. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        elseif IsControlPressed(0, 189) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current - 1] then
                                current = current - 1
                            else
                                current = #Config.Furniture[category[1]]
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('Modelu (%s) treba previse da se ucita. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObject(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('Model (%s) ne postoji. Javite vlasniku servera.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        end
                    end
                    FreezeEntityPosition(PlayerPedId(), false)
                    DeleteObject(furniture)
                    RenderScriptCams(false, false, 0, true, false)
                    DestroyCam(cam)
                end
            end
		else
			waitara = 500
        end
		if prop_ent ~= nil then
			waitara = 0
			SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
		end
    end
end)

RegisterNetEvent('loaf_housing:spawnHouse')
AddEventHandler('loaf_housing:spawnHouse', function(coords, furniture)
	local ida = 0
	for ka, v in pairs(Config.Houses) do
		local k = v['ID']
		if k == OwnedHouse.houseId then
			ida = ka
			break
		end
	end
    local prop = Config.Houses[ida]['prop']
    local house = EnterHouse(Config.Props[prop], coords)
    local placed_furniture = {}
    for k, v in pairs(OwnedHouse['furniture']) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
        table.insert(placed_furniture, object)
    end
	TriggerServerEvent("kuce:UKuci", true)
    SetEntityHeading(house, 0.0)
    local exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])
    local storage = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['storage'])
    TriggerServerEvent('loaf_housing:setInstanceCoords', exit, coords, prop, OwnedHouse['furniture'])
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(50)
    end
	Wait(1500)
	local pada = IsPedFalling(PlayerPedId())
	if pada then
		Wait(10000)
		SetEntityCoords(PlayerPedId(), exit)
	end
    DoScreenFadeIn(1500)
    local in_house = true
    ClearPedWetness(PlayerPedId())
    while in_house do
        NetworkOverrideClockTime(15, 0, 0)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')

        DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                ESX.UI.Menu.CloseAll()

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'storage',
                {
                    title = Strings['Storage_Title'],
                    align = 'top-left',
                    elements = {
                        {label = Strings['Items'], value = 'i'},
                        {label = Strings['Weapons'], value = 'w'},
						{label = "Promjeni odjecu", value = 'odjeca'},
						{label = "Obrisi odjecu", value = 'obrisiodj'},
                    },
                },
                function(data, menu)
                    if data.current.value == 'i' then
                        itemStorage(OwnedHouse.houseId)
                    elseif data.current.value == 'w' then
                        weaponStorage(OwnedHouse.houseId)
					elseif data.current.value == 'odjeca' then
                        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
							local elements = {}

							for i=1, #dressing, 1 do
								table.insert(elements, {
									label = dressing[i],
									value = i
								})
							end

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
								title    = "Vasa odjeca",
								align    = 'top-left',
								elements = elements
							}, function(data2, menu2)
								TriggerEvent('skinchanger:getSkin', function(skin)
									ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
										TriggerEvent('skinchanger:loadClothes', skin, clothes)
										TriggerEvent('esx_skin:setLastSkin', skin)

										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_skin:save', skin)
										end)
									end, data2.current.value)
								end)
							end, function(data2, menu2)
								menu2.close()
							end)
						end)
					elseif data.current.value == 'obrisiodj' then
                        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
							local elements = {}

							for i=1, #dressing, 1 do
								table.insert(elements, {
									label = dressing[i],
									value = i
								})
							end

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
								title    = "Brisanje odjece",
								align    = 'top-left',
								elements = elements
							}, function(data2, menu2)
								menu2.close()
								TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
								ESX.ShowNotification("Maknuli ste outfit iz ormara!")
							end, function(data2, menu2)
								menu2.close()
							end)
						end)
                    end
                end, 
                    function(data, menu)
                    menu.close()
                end)

            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), exit) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Manage_Door']), exit)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()

                local elements = {
                    {label = Strings['Accept'], value = 'accept'},
                    {label = Strings['Furnish'], value = 'furnish'},
                    {label = Strings['Re_Furnish'], value = 'refurnish'},
                    {label = Strings['Exit'], value = 'exit'},
                }

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'manage_door',
                {
                    title = Strings['Manage_Door'],
                    align = 'top-left',
                    elements = elements,
                },
                function(data, menu)
                    if data.current.value == 'exit' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests2', function(has)
                            if not has then
                                ESX.UI.Menu.CloseAll()
                                TriggerServerEvent('loaf_housing:deleteInstance')
                                Wait(3500)
                                in_house = false
                                return
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end, OwnedHouse.houseId)
                    elseif data.current.value == 'refurnish' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests', function(has)
                            if not has then
                                local elements = {}
                                for k, v in pairs(OwnedHouse['furniture']) do
                                    table.insert(elements, {label = (Strings['Remove']):format(v['name'], k), value = k})
                                end
                                local editing = true
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'edit_furniture',
                                {
                                    title = Strings['Re_Furnish'],
                                    align = 'top-left',
                                    elements = elements,
                                },
                                function(data2, menu2)
                                    DeleteObject(placed_furniture[data2.current.value])
                                    if furniture[OwnedHouse['furniture'][data2.current.value]['object']] then
                                        furniture[OwnedHouse['furniture'][data2.current.value]['object']]['amount'] = furniture[OwnedHouse['furniture'][data2.current.value]['object']]['amount'] + 1
                                    else
                                        furniture[OwnedHouse['furniture'][data2.current.value]['object']] = {amount = 1, name = OwnedHouse['furniture'][data2.current.value]['name']}
                                    end
                                    table.remove(OwnedHouse['furniture'], data2.current.value)
                                    for k, v in pairs(placed_furniture) do
                                        DeleteObject(v)
                                    end
                                    placed_furniture = {}
                                    for k, v in pairs(OwnedHouse['furniture']) do
                                        local model = GetHashKey(v['object'])
                                        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), true, false, true)
                                        SetEntityHeading(object, v['heading'])
                                        FreezeEntityPosition(object, true)
                                        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                        table.insert(placed_furniture, object)
                                    end
                                    TriggerServerEvent('loaf_housing:furnish', OwnedHouse, furniture)
                                    menu2.close()
                                    editing = false
                                end, 
                                    function(data2, menu2)
                                        editing = false
                                    menu2.close()
                                end)
                                while editing do
                                    Wait(0)
                                    for k, v in pairs(placed_furniture) do
                                        DrawText3D(GetEntityCoords(v), ('%s (#%s)'):format(OwnedHouse['furniture'][k]['name'], k), 0.3)
                                    end
                                end
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end)
                    elseif data.current.value == 'furnish' then
                        ESX.TriggerServerCallback('loaf_housing:hasGuests', function(has)
                            if not has then
                                local elements = {}
                                for k, v in pairs(furniture) do 
                                    table.insert(elements, {label = ('x%s %s'):format(v['amount'], v['name']), value = k, name = v['name']})
                                end
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'furnish',
                                {
                                    title = Strings['Furnish'],
                                    align = 'top-left',
                                    elements = elements,
                                },
                                function(data2, menu2)
                                    ESX.UI.Menu.CloseAll()
                                    local model = GetHashKey(data2.current.value)
                                    while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                    local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['spawn_furniture']), true, false, true)
                                    SetEntityCollision(object, false, false)
                                    SetEntityHasGravity(object, false)
                                    Wait(250)
                                    while true do
                                        Wait(0)
                                        HelpText(Strings['Furnishing'])
                                        ESX.UI.Menu.CloseAll() -- test
                                        DisableControlAction(0, 24)
                                        DisableControlAction(0, 25)
                                        DisableControlAction(0, 14)
                                        DisableControlAction(0, 15)
                                        DisableControlAction(0, 16)
                                        DisableControlAction(0, 17)
                                        -- DrawEdge(object) -- w.i.p
                                        DrawText3D(GetEntityCoords(object), ('%s, %s: %s'):format(data2.current.name, Strings['Rotation'], string.format("%.2f", GetEntityHeading(object))), 0.3)
                                        if IsControlPressed(0, 172) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.01, 0.0))
                                        elseif IsControlPressed(0, 173) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, -0.01, 0.0))
                                        elseif IsControlPressed(0, 96) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, 0.01))
                                        elseif IsControlPressed(0, 97) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, -0.01))
                                        elseif IsControlPressed(0, 174) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, -0.01, 0.0, 0.0))
                                        elseif IsControlPressed(0, 175) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.01, 0.0, 0.0))
                                        elseif IsDisabledControlPressed(0, 24) then
                                            SetEntityHeading(object, GetEntityHeading(object)+0.5)
                                        elseif IsDisabledControlPressed(0, 25) then
                                            SetEntityHeading(object, GetEntityHeading(object)-0.5)
                                        elseif IsControlJustReleased(0, 47) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local houseHeight = GetEntityHeight(house, GetEntityCoords(house), true, false)
                                            SetEntityCoords(object, objCoords.x, objCoords.y, (objCoords.z-(objCoords.z-houseCoords.z))+houseHeight)
                                        elseif IsControlPressed(0, 215) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local furn_offs = objCoords - houseCoords
                                            local furnished = {['offset'] = {furn_offs.x, furn_offs.y, furn_offs.z}, ['object'] = data2.current.value, ['name'] = data2.current.name, ['heading'] = GetEntityHeading(object)}
                                            table.insert(OwnedHouse['furniture'], furnished)
                                            if furniture[data2.current.value]['amount'] > 1 then
                                                furniture[data2.current.value]['amount'] = furniture[data2.current.value]['amount'] - 1
                                            else -- ugly code, idk how to improve ¯\_(ツ)_/¯ couldn't get table.remove to work on this shit
                                                local oldFurniture = furniture
                                                furniture = {}
                                                for k, v in pairs(oldFurniture) do
                                                    if k ~= data2.current.value then
                                                        furniture[k] = v
                                                    end
                                                end
                                            end
                                            DeleteObject(object)

                                            for k, v in pairs(placed_furniture) do
                                                DeleteObject(v)
                                            end
                                            placed_furniture = {}
                                            for k, v in pairs(OwnedHouse['furniture']) do
                                                local model = GetHashKey(v['object'])
                                                while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                                local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), true, false, true)
                                                SetEntityHeading(object, v['heading'])
                                                FreezeEntityPosition(object, true)
                                                SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                                table.insert(placed_furniture, object)
                                            end

                                            TriggerServerEvent('loaf_housing:furnish', OwnedHouse, furniture)
                                            break
                                        elseif IsControlPressed(0, 202) then
                                            DeleteObject(object)
                                            break
                                        end
                                    end
                                end, 
                                    function(data2, menu2)
                                    menu2.close()
                                end)
                            else
                                ESX.ShowNotification(Strings['Guests'])
                            end
                        end)
                    elseif data.current.value == 'accept' then
                        local elements = {}
                        for k, v in pairs(Knockings) do
                            table.insert(elements, v)
                        end
                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'let_in',
                        {
                            title = Strings['Let_In'],
                            align = 'top-left',
                            elements = elements,
                        },
                        function(data2, menu2)
                            if Knockings[data2.current.value] then
                                TriggerServerEvent('loaf_housing:letIn', data2.current.value, storage)
                            end
                            menu2.close()
                        end, 
                            function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end, 
                    function(data, menu)
                    menu.close()
                end)
            end
        end
        Wait(0)
    end
    DeleteObject(house)
    for k, v in pairs(placed_furniture) do
        DeleteObject(v)
    end
end)

local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		ESX.TriggerServerCallback('loaf_housing:DohvatiZadnjuKucu', function(id, kuce)
			Config.Houses = kuce
			if id ~= 0 then
				local xa,ya,za
				for ka, v in pairs(Config.Houses) do
					local k = v['ID']
					if k == id then
						xa,ya,za = table.unpack(v['door'])
					end
				end
				local formattedCoords = {
					x = xa,
					y = ya,
					z = za
				}
				ESX.SetPlayerData('lastPosition', formattedCoords)
				SetEntityCoords(PlayerPedId(), xa, ya, za)
				TriggerServerEvent("kuce:UKuci", false)
				TriggerServerEvent("loaf_housing:MakniSpremljenuKucu")
			end
		end)
		connected = true
	end
end)

RegisterNetEvent('loaf_housing:leaveHouse')
AddEventHandler('loaf_housing:leaveHouse', function(house)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(),  Config.Houses[house]['door'])
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
        Wait(50)
    end
    DoScreenFadeIn(1500)
	UKuci = false
	TriggerServerEvent("kuce:UKuci", false)
end)

RegisterNetEvent('loaf_housing:leaveHouse2')
AddEventHandler('loaf_housing:leaveHouse2', function(house)
    DoScreenFadeOut(750)
    for k, v in pairs(placed_furniture) do
        DeleteObject(v)
    end
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
        Wait(50)
    end
    DeleteObject(prop)
    DoScreenFadeIn(1500)
	UKuci = false
	TriggerServerEvent("kuce:UKuci", false)
    TriggerServerEvent('loaf_housing:leaveHouse', house)
end)

RegisterNetEvent('loaf_housing:knockAccept')
AddEventHandler('loaf_housing:knockAccept', function(coords, house, storage, spawnpos, furniture, host)
    local prop = Config.Houses[house]['prop']
    prop = EnterHouse(Config.Props[prop], spawnpos)
    local placed_furniture = {}
    for k, v in pairs(furniture) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObject(model, GetOffsetFromEntityInWorldCoords(prop, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
		SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(prop, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
        table.insert(placed_furniture, object)
    end
    SetEntityHeading(prop, 0.0)

    while not DoesEntityExist(prop) do Wait(0) end

    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), coords)
	UKuci = true
	TriggerServerEvent("kuce:UKuci", true)
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(),  coords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), coords)
        Wait(50)
    end
	Wait(1500)
	local pada = IsPedFalling(PlayerPedId())
	if pada then
		Wait(10000)
		SetEntityCoords(PlayerPedId(), coords)
	end
    DoScreenFadeIn(1500)
    local timer = GetGameTimer() + 500
    local delete = false
    while UKuci do
        Wait(0)
        if timer <= GetGameTimer() then
            timer = GetGameTimer() + 500
            ESX.TriggerServerCallback('loaf_housing:hostOnline', function(online)
                if not online then
                    delete = true
                end
            end, host)
        end
        if delete then
            ESX.UI.Menu.CloseAll()
            DoScreenFadeOut(750)
            for k, v in pairs(placed_furniture) do
                DeleteObject(v)
            end
            while not IsScreenFadedOut() do Wait(0) end
            SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
            for i = 1, 25 do
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                Wait(50)
            end
            DeleteObject(prop)
            DoScreenFadeIn(1500)
            ESX.ShowNotification(Strings['Host_Left'])
			UKuci = false
			TriggerServerEvent("kuce:UKuci", false)
            return
        end
        DrawMarker(27, coords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        if Vdist2(GetEntityCoords(PlayerPedId()), coords) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Exit']), coords)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()
                DoScreenFadeOut(750)
                for k, v in pairs(placed_furniture) do
                    DeleteObject(v)
                end
                while not IsScreenFadedOut() do Wait(0) end
                SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                for i = 1, 25 do
                    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                    Wait(50)
                end
                while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                    SetEntityCoords(PlayerPedId(), Config.Houses[house]['door'])
                    Wait(50)
                end
                DeleteObject(prop)
                DoScreenFadeIn(1500)
				UKuci = false
				TriggerServerEvent("kuce:UKuci", false)
                TriggerServerEvent('loaf_housing:leaveHouse', house)
                return
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                ESX.UI.Menu.CloseAll()

                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'storage',
                {
                    title = Strings['Storage_Title'],
                    align = 'top-left',
                    elements = {
                        {label = Strings['Items'], value = 'i'},
                        {label = Strings['Weapons'], value = 'w'}
                    },
                },
                function(data, menu)
                    if data.current.value == 'i' then
                        itemStorage(house)
                    elseif data.current.value == 'w' then
                        weaponStorage(house)
                    end
                end, 
                    function(data, menu)
                    menu.close()
                end)

            end
        end
    end
	for k, v in pairs(placed_furniture) do
        DeleteObject(v)
    end
end)

RegisterNetEvent('loaf_housing:reloadHouses')
AddEventHandler('loaf_housing:reloadHouses', function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('loaf_housing:getOwned')
end)

RegisterNetEvent('loaf_housing:knockedDoor')
AddEventHandler('loaf_housing:knockedDoor', function(src)
    ESX.ShowNotification(Strings['Someone_Knocked'])
    if not Knockings[src] then
        Knockings[src] = {label = (Strings['Accept_Player']):format(GetPlayerName(GetPlayerFromServerId(src))), value = src}
    end
end)

RegisterNetEvent('loaf_housing:removeDoorKnock')
AddEventHandler('loaf_housing:removeDoorKnock', function(src)
    local newTable = {}
    for k, v in pairs(Knockings) do
        if v.value ~= src then
            table.remove(newTable, v)
        end
    end
    Knockings = newTable
end)

RegisterNetEvent('loaf_housing:setHouse')
AddEventHandler('loaf_housing:setHouse', function(house, purchasedHouses)
    OwnedHouse = house

    for k, v in pairs(blips) do
        RemoveBlip(v)
    end

    for k, v in pairs(purchasedHouses) do
        if v.houseid ~= OwnedHouse.houseId then
            AvailableHouses[v.houseid] = v.houseid
        end
    end

    for ka, v in pairs(Config.Houses) do
		local k = v['ID']
        if OwnedHouse.houseId == k then
            CreateBlip(v['door'], 40, 3, 0.75, Strings['Your_House'])
        else
            if not AvailableHouses[k] then
                if Config.AddHouseBlips then
                    CreateBlip(v['door'], 374, 0, 0.45, '')
                end
            else
                if Config.AddBoughtHouses then
                    CreateBlip(v['door'], 374, 2, 0.45, Strings['Player_House'])
                end
            end
        end
    end
end)

EnterHouse = function(prop, coords)
    local obj = CreateObject(prop, coords, false)
    FreezeEntityPosition(obj, true)
    return obj
end

HelpText = function(msg, coords)
    if not coords or not Config.Use3DText then
        AddTextEntry(GetCurrentResourceName(), msg)
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
    else
        DrawText3D(coords, string.gsub(msg, "~INPUT_CONTEXT~", "~r~[~w~E~r~]~w~"), 0.35)
    end
end

CreateBlip = function(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
end

--[[DrawText3D = function(coords, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end]]

rgb = function(speed)
    local result = {}
    local n = GetGameTimer() / 200
    result.r = math.floor(math.sin(n * speed + 0) * 127 + 128)
    result.g = math.floor(math.sin(n * speed + 2) * 127 + 128)
    result.b = math.floor(math.sin(n * speed + 4) * 127 + 128)
    return result
end

DrawEdge = function(entity)
    local left, right = GetModelDimensions(GetEntityModel(entity))
    local leftoffset, rightoffset = GetOffsetFromEntityInWorldCoords(entity, left.x, left.y, left.z), GetOffsetFromEntityInWorldCoords(entity, right.x, right.y, right.z)
    local coords = GetEntityCoords(entity)

    local color = rgb(0.5)

    -- DrawBox(GetOffsetFromEntityInWorldCoords(entity, left.x, left.y, left.z), GetOffsetFromEntityInWorldCoords(entity, right.x, right.y, right.z), 255, 255, 255, 50)
    --DrawBox(coords+left, coords+right, 255, 255, 255, 50)

    DrawLine(rightoffset, rightoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset, leftoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, leftoffset, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, leftoffset.z, color.r, color.g, color.b, 255)

    --[[DrawLine(coords+left, (coords+left).x, (coords+left).y, (coords+right).z, color.r, color.g, color.b, 255)
    DrawLine(coords+right, (coords+right).x, (coords+right).y, (coords+left).z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+right.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+left.y, coords.z+left.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)

    DrawLine(coords.x+right.x, coords.y+left.y, coords.z+left.z, coords+left, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+left.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+right.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+right.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)

    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+right.z, coords.x+left.x, coords.y+right.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+right.z, coords.x+right.x, coords.y+left.y, coords.z+right.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+left.x, coords.y+left.y, coords.z+left.z, coords.x+left.x, coords.y+right.y, coords.z+left.z, color.r, color.g, color.b, 255)
    DrawLine(coords.x+right.x, coords.y+right.y, coords.z+left.z, coords.x+right.x, coords.y+left.y, coords.z+left.z, color.r, color.g, color.b, 255)]]
end