ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
end)

AntiCheat = true
AntiCheatStatus = "~g~Active"
PedStatus = 0
whitelisted = false
whiteCheck = false

local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		connected = true
		local broj = GetNumResources()-1
		local imena = {}
		for i = 0, broj do
			local str = GetResourceByFindIndex(i)
			table.insert(imena, str)
		end
		TriggerServerEvent("ac:Provjeraresursa", imena)
	end
end)

--[[ WHITELIST CHECK ]]--
Citizen.CreateThread(function()
	while whiteCheck == true do
		Citizen.Wait( 1000 )
		if ESX.IsPlayerLoaded(PlayerId) then
			--Citizen.Wait( 1000 )
			TriggerServerEvent('Anticheat:Whitelist', GetPlayerServerId(PlayerId()))
			whiteCheck = false
		end
	end
end)
RegisterNetEvent('Anticheat:WLReturn')
AddEventHandler('Anticheat:WLReturn', function(wlstatus)
	
	whitelisted = wlstatus
	--whitelisted = false
	if whitelisted == true then
		print ('player is whitelisted.')
	else
		print ('player is not whitelisted')
	end
	
end)

--[[ BLACKLISTED CAR CHECK ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if (AntiCheat == true and whitelisted == false and whiteCheck == false)then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				v = GetVehiclePedIsIn(playerPed, false)
			end
			playerPed = GetPlayerPed(-1)
			
			if playerPed and v then
				if GetPedInVehicleSeat(v, -1) == playerPed then
					checkCar(GetVehiclePedIsIn(playerPed, false))
				end
			end
		end
	end
end)

--[[ BLACKLISTED WEAPON CHECK ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if (AntiCheat == true and whitelisted == false and whiteCheck == false)then
			for _,theWeapon in ipairs(Config.WeaponBL) do
				Citizen.Wait(1)
				if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
					RemoveAllPedWeapons(PlayerPedId(),false)
				end
			end
		end
	end
end)

RegisterNetEvent('anticheat:ProvjeriImena')
AddEventHandler('anticheat:ProvjeriImena', function(imena)
	if connected then
		local broj = GetNumResources()-1
		local nepoznati = nil
		for i = 0, broj do
			local str = GetResourceByFindIndex(i)
			local naso = 0
			for j = 1, #imena do
				if str == imena[j] then
					naso = 1
				end
			end
			if naso == 0 then
				nepoznati = str
			end
		end
		if nepoznati ~= nil then
			TriggerServerEvent("DiscordBot:Anticheat", GetPlayerName(PlayerId()).."["..GetPlayerServerId(PlayerId()).."] je koristio lua injector ("..nepoznati..")")
			TriggerServerEvent("AntiCheat:Citer", GetPlayerServerId(PlayerId()))
		end
	end
end)

--[[ BLACKLISTED OBJECT CHECK ]]--
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local ped = PlayerPedId()
		local handle, object = FindFirstObject()
		local finished = false
		repeat
		Wait(1)
        if (AntiCheat == true and whitelisted == false and whiteCheck == false)then
			local model = GetEntityModel(object)
			if IsEntityAttached(object) and DoesEntityExist(object) then

				if model == GetHashKey("prop_acc_guitar_01") then
					DeleteObjects(object, true)
				end
			end
			for i=1,#Config.ObjectsBL do
				if model == GetHashKey(Config.ObjectsBL[i]) then
					DeleteObjects(object, false)
				end
			end
		end
		finished, object = FindNextObject(handle)

		until not finished
		EndFindObject(handle)
	end
end)]]--

function DeleteObjects(object, detach)
	if (AntiCheat == true)then
		if DoesEntityExist(object) then
			NetworkRequestControlOfEntity(object)
			while not NetworkHasControlOfEntity(object) do
				Citizen.Wait(1)
			end
			if detach then
				DetachEntity(object, 0, false)
			end

			SetEntityCollision(object, false, false)
			SetEntityAlpha(object, 0.0, true)
			SetEntityAsMissionEntity(object, true, true)
			SetEntityAsNoLongerNeeded(object)
			DeleteEntity(object)

		end
	end
end

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(anticheatm)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

RegisterNetEvent('AntiCheat:Toggle')
AddEventHandler('AntiCheat:Toggle', function()
    if (AntiCheat == false) then
        AntiCheat = true
        AntiCheatStatus = "~g~Active"
        anticheatm = "~y~AntiCheat ~g~Enabled"
        Citizen.Wait(5000)
        anticheatm = false
    	else
		AntiCheat = false
        AntiCheatStatus = "~r~Inactive"
        anticheatm = "~y~AntiCheat ~r~Disabled"
        PedStatus = "OFF"
        Citizen.Wait(5000)
        anticheatm = false
	end
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

function ACstatus(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(-1553120962, 0.0) --undocumented damage modifier. 1st argument is hash, 2nd is modified (0.0-1.0)
        Citizen.Wait(0)
    end
end)

function KillAllPeds()
    local pedweapon
    local pedid
    for ped in EnumeratePeds() do 
        if DoesEntityExist(ped) then
            pedid = GetEntityModel(ped)
            pedweapon = GetSelectedPedWeapon(ped)
            if (AntiCheat == true)then
            if pedweapon == -1312131151 then 
                ApplyDamageToPed(ped, 1000, false)
                DeleteEntity(ped)
            else
                switch = function (choice)
                    choice = choice and tonumber(choice) or choice
                  
                    case =
                    {
                        [451459928] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
                  
                        [1684083350] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [451459928] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
              
                        [1096929346] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [880829941] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,
          
                        [-1404353274] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                        [2109968527] = function ( )
                            ApplyDamageToPed(ped, 1000, false)
                            DeleteEntity(ped)
                        end,

                       default = function ( )
                       end,
                    }

                    if case[choice] then
                       case[choice]()
                    else
                       case["default"]()
                    end
                  
                  end
                  switch(pedid) 
            end
        end
        end
    end
end

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)
      if (AntiCheat == true)then
		if isCarBlacklisted(carModel) then
			_DeleteEntity(car)
			TriggerServerEvent('AntiCheat:Cars',carName )
        end
      end
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(Config.CarsBL) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end

	return false
end

function _DeleteEntity(entity)
	Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end
