local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

--esx_marker
ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

--discord
ESX.RegisterServerCallback("discord:DohvatiIgrace", function(source, cb)
	cb(#GetPlayers())
end)

RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	DropPlayer(source, "Bili ste AFK predugo.")
end)

-- OBJ : transform a table into a string (using spaces)
-- PARAMETERS :
--		- tab : the table to transform
local function TableToString(tab)
	local str = ""
	for i = 1, #tab do
		str = str .. " " .. tab[i]
	end
	return str
end

RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	print("got to srv cmg3_animations:sync")
	print("got that fucking attach flag as: " .. tostring(attachFlag))
	TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)


-- --------------------------------------------
-- Commands
-- --------------------------------------------

RegisterCommand('me', function(source, args)
    local text = "*" .. TableToString(args) .. " *"
	local player = source
	local ped = GetPlayerPed(player)
	local koord = GetEntityCoords(ped)
    TriggerClientEvent('3dme:shareDisplay', -1, text, source, koord)
end)

RegisterCommand("restartsrw", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	if Source ~= 0 then
		local id = Source
		local xPlayer = ESX.GetPlayerFromId(id)
		local Vrati = 0
		local result = MySQL.Sync.fetchAll('SELECT permission_level FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})
		local vr = result[1].permission_level
		if vr > 0 then
			Vrati = 1
		else
			Vrati = 0
		end
	else
		Vrati = 1
	end
	if Vrati == 1 then
		ESX.SavePlayers()
		if Source == 0 then
			print("Spremili ste sve")
		else
			TriggerClientEvent('esx:showNotification', source, "Spremili ste sve!")
		end
	end
end, false)

-- Make the kit usable!
ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if Config.AllowMecano then
		TriggerClientEvent('esx_repairkit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mecano' then
			TriggerClientEvent('esx_repairkit:onUse', _source)
		end
	end
end)

RegisterNetEvent('skriptice:SpremiLogin')
AddEventHandler('skriptice:SpremiLogin', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute("UPDATE users SET zadnji_login=@datum WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@datum'] = os.date("%d/%m/%Y %X")})
end)

RegisterNetEvent('esx_repairkit:removeKit')
AddEventHandler('esx_repairkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not Config.InfiniteRepairs then
		xPlayer.removeInventoryItem('repairkit', 1)
		TriggerClientEvent('esx:showNotification', _source, _U('used_kit'))
	end
end)

--esx_getout
ESX.RegisterServerCallback('esx_getout:DohvatiPermisiju', function(source, cb)
    local id = source
    local xPlayer = ESX.GetPlayerFromId(id)
	local Vrati = 0
	local result = MySQL.Sync.fetchAll('SELECT permission_level FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	local vr = result[1].permission_level
	if vr > 0 then
		Vrati = 1
	else
		Vrati = 0
	end
	cb(Vrati)
end)

RegisterServerEvent("esx_getout:DajAdmina")
AddEventHandler("esx_getout:DajAdmina", function()
	local id = source
    local xPlayer = ESX.GetPlayerFromId(id)
	local Vrati = 0
	local result = MySQL.Sync.fetchAll('SELECT permission_level FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	local vr = result[1].permission_level
	if vr > 0 then
		Vrati = 1
	else
		Vrati = 0
	end
	TriggerClientEvent("esx_getout:VratiAdmina", source, Vrati)
end)