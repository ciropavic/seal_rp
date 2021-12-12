ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local instances = {}
local houses = {}
local trava = {}

RegisterServerEvent('loaf_housing:enterHouse')
AddEventHandler('loaf_housing:enterHouse', function(id, ka)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT house, bought_furniture FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result[1].house)
        local furniture = json.decode(result[1]['bought_furniture'])
        if house.houseId == id then
            for k, v in pairs(Config.HouseSpawns) do
                if not v['taken'] then
					MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = id})
                    TriggerClientEvent('loaf_housing:spawnHouse', xPlayer.source, v['coords'], furniture)
                    instances[src] = {['id'] = ka, ['owner'] = src, ['coords'] = v['coords'], ['housespawn'] = k, ['players'] = {}}
                    instances[src]['players'][src] = src
                    houses[ka] = src
                    v['taken'] = true
                    return
                end
            end
        else
            print(('There seems to be some kind of error in the script "%s", #%s tried to enter house %s but he/she doesn\'t own house #%s.'):format(GetCurrentResourceName(), xPlayer.identifier, id, id))
        end
    end)
end)

MySQL.ready(function ()
	MySQL.Async.fetchAll('SELECT * FROM kuce', {}, function(result)
		for i=1, #result, 1 do
			local data = json.decode(result[i].door)
			table.insert(Config.Houses, {['ID'] = result[i].ID, ['prop'] = result[i].prop, ['door'] = vector3(data.x, data.y, data.z), ['price'] = result[i].price, ['prodaja'] = result[i].prodaja})
		end
		Wait(1000)
		TriggerClientEvent("loaf_housing:SaljiKucice", -1, Config.Houses)
	end)
end)

RegisterNetEvent('loaf_housing:DodajKucu')
AddEventHandler('loaf_housing:DodajKucu', function(id, prop, door, price, prod, src)
	table.insert(Config.Houses, {['ID'] = id, ['prop'] = prop, ['door'] = door, ['price'] = price, ['prodaja'] = prod})
	TriggerClientEvent("loaf_housing:SaljiKucice", -1, Config.Houses)
	
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT house FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result)
        if house.houseId == 0 then
            MySQL.Async.fetchScalar("SELECT houseid FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = id}, function(result)
                local newHouse = ('{"owns":false,"furniture":[],"houseId":%s}'):format(id)
                if not result then
                    MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = newHouse}) 
					MySQL.Sync.execute("INSERT INTO bought_houses (houseid) VALUES (@houseid)", {['houseid'] = id})
                end
            end)
        end
    end)
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

RegisterNetEvent('loaf_housing:UrediKucu')
AddEventHandler('loaf_housing:UrediKucu', function(id, door, src)
	for k, v in pairs(Config.Houses) do
		if v['ID'] == id then
			v['door'] = door
			break
		end
	end
	TriggerClientEvent("loaf_housing:SaljiKucice", -1, Config.Houses)
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

RegisterNetEvent('loaf_housing:ObrisiKucu')
AddEventHandler('loaf_housing:ObrisiKucu', function(id)
	for ka, v in pairs(Config.Houses) do
		local k = v['ID']
		if k == id then
			table.remove(Config.Houses, ka)
			break
		end
	end
	TriggerClientEvent("loaf_housing:SaljiKucice", -1, Config.Houses)
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

ESX.RegisterServerCallback('loaf_housing:DohvatiZadnjuKucu', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchScalar('SELECT last_house FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result, Config.Houses)
    end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

RegisterNetEvent('kuce:SpawnVozilo')
AddEventHandler('kuce:SpawnVozilo', function(vehicle, co, he)
	local _source = source
	local veh = CreateVehicle(vehicle.model, co, he, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	TriggerClientEvent("kuce:VratiVozilo", _source, netid, vehicle, co)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('loaf_housing:buy_furniture')
AddEventHandler('loaf_housing:buy_furniture', function(category, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hadMoney = false
    if Config.Furniture[Config.Furniture['Categories'][category][1]][id] then
        if xPlayer.getAccount('bank').money >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
            xPlayer.removeAccountMoney('bank', Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
            hadMoney = true
        else
            if xPlayer.getMoney() >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
                xPlayer.removeMoney(Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
                hadMoney = true
            else
                TriggerClientEvent('esx:showNotifciation', xPlayer.source, Strings['no_money'])
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'There seems to be some kind of error in the script, could not buy furniture.')
    end

    if hadMoney then
        MySQL.Async.fetchScalar("SELECT bought_furniture FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
            local furniture = json.decode(result)
            if furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] then 
                furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] = furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] + 1
            else
                furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] = {['amount'] = 1, ['name'] = Config.Furniture[Config.Furniture['Categories'][category][1]][id][1]}
            end
            MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@bought_furniture'] = json.encode(furniture)}) 
            TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Bought_Furniture']):format(Config.Furniture[Config.Furniture['Categories'][category][1]][id][1], Config.Furniture[Config.Furniture['Categories'][category][1]][id][3]))
        end)
    end
end)

RegisterServerEvent('loaf_housing:leaveHouse')
AddEventHandler('loaf_housing:leaveHouse', function(house)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    if instances[houses[house]]['players'][src] then
        local oldPlayers = instances[houses[house]]['players']
        local newPlayers = {}
        for k, v in pairs(oldPlayers) do
            if v ~= src then
                newPlayers[k] = v
            end
        end
        instances[houses[house]]['players'] = newPlayers
		MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = 0})
    end
end)

RegisterServerEvent('loaf_housing:MakniSpremljenuKucu')
AddEventHandler('loaf_housing:MakniSpremljenuKucu', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = 0})
end)

RegisterServerEvent('loaf_housing:deleteInstance')
AddEventHandler('loaf_housing:deleteInstance', function()
    local src = source
    if instances[src] then
        Config.HouseSpawns[instances[src]['housespawn']]['taken'] = false
        for k, v in pairs(instances[src]['players']) do
            TriggerClientEvent('loaf_housing:leaveHouse', v, instances[src]['id'])
			local xPlayer = ESX.GetPlayerFromId(v)
			MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = 0})
        end
        instances[src] = {}
    end
end)

RegisterServerEvent('loaf_housing:letIn')
AddEventHandler('loaf_housing:letIn', function(plr, storage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(plr)
    if instances[src] then
        if not instances[src]['players'][plr] then 
            instances[src]['players'][plr] = plr

            local spawnpos = instances[src]['housecoords']
            local furniture = instances[src]['furniture']
            TriggerClientEvent('loaf_housing:knockAccept', plr, instances[src]['coords'], instances[src]['id'], storage, spawnpos, furniture, src)
			MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = instances[src]['id']})
        end
    end
end)

RegisterServerEvent('loaf_housing:unKnockDoor')
AddEventHandler('loaf_housing:unKnockDoor', function(id)
    local src = source
    if instances[houses[id]] then
        TriggerClientEvent('loaf_housing:removeDoorKnock', instances[houses[id]]['owner'], src)
    end
end)

RegisterServerEvent('loaf_housing:knockDoor')
AddEventHandler('loaf_housing:knockDoor', function(id)
    local src = source
    if instances[houses[id]] then
        TriggerClientEvent('loaf_housing:knockedDoor', instances[houses[id]]['owner'], src)
    else
        TriggerClientEvent('esx:showNotification', src, Strings['Noone_Home'])
    end
end)

RegisterServerEvent('loaf_housing:setInstanceCoords')
AddEventHandler('loaf_housing:setInstanceCoords', function(coords, housecoords, prop, placedfurniture)
    local src = source
    if instances[src] then
        instances[src]['coords'] = coords
        instances[src]['housecoords'] = housecoords
        instances[src]['furniture'] = placedfurniture
    end
end)

RegisterServerEvent('loaf_housing:exitHouse')
AddEventHandler('loaf_housing:exitHouse', function(id)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    if instances[src] then
        for k, v in pairs(instances['players']) do
            TriggerClientEvent('loaf_housing:exitHouse', v, id)
            table.remove(instances, src)
            table.remove(houses, id)
        end
    else
        for k, v in pairs(instances) do
            if v['players'][src] then
                table.remove(v['players'], src)
            end
        end
    end
	MySQL.Async.execute("UPDATE users SET last_house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = 0})
end)

RegisterServerEvent('loaf_housing:buyHouse')
AddEventHandler('loaf_housing:buyHouse', function(id, ka)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT house FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result)
        if house.houseId == 0 then
            MySQL.Async.fetchScalar("SELECT houseid FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = id}, function(result)
                local newHouse = ('{"owns":false,"furniture":[],"houseId":%s}'):format(id)
                if not result then
                    if xPlayer.getAccount('bank').money >= Config.Houses[ka]['price'] then
                        xPlayer.removeAccountMoney('bank', Config.Houses[ka]['price'])
                        MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = newHouse}) 
                        MySQL.Sync.execute("INSERT INTO bought_houses (houseid) VALUES (@houseid)", {['houseid'] = id})
                    else
                        if xPlayer.getMoney() >= Config.Houses[ka]['price'] then
                            xPlayer.removeMoney(Config.Houses[ka]['price'])
                            MySQL.Sync.execute("INSERT INTO bought_houses (houseid) VALUES (@houseid)", {['houseid'] = id})
                            MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = newHouse}) 
                        else
                            TriggerClientEvent('esx:showNotification', xPlayer.source, Strings['No_Money'])
                        end
                    end
                end
            end)
        end
    end)
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

ESX.RegisterServerCallback('loaf_housing:ImalKucu', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT house FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result)
        if house.houseId == 0 then
			cb(false)
		else
			cb(true)
		end
	end)
end)

RegisterServerEvent('loaf_housing:sellHouse')
AddEventHandler('loaf_housing:sellHouse', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT house FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result)
        if Config.Houses[house.houseId]['price'] then
            xPlayer.addMoney(Config.Houses[house.houseId]['price'] * (Config.SellPercentage/100))
            TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Sold_House']):format(math.floor(Config.Houses[house.houseId]['price'] * (Config.SellPercentage/100))))
            MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
            MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = house.houseId})
            local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(src).."("..xPlayer.identifier..") je dobio $"..(Config.Houses[house.houseId]['price']*(Config.SellPercentage/100))
	    TriggerEvent("SpremiLog", por)
        end
    end)
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

RegisterServerEvent('loaf_housing:getOwned')
AddEventHandler('loaf_housing:getOwned', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT house FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        local house = json.decode(result)
        MySQL.Async.fetchAll("SELECT houseid FROM bought_houses", {}, function(result2)
            TriggerClientEvent('loaf_housing:setHouse', xPlayer.source, house, result2)
        end)
    end)
end)

RegisterServerEvent('loaf_housing:furnish')
AddEventHandler('loaf_housing:furnish', function(house, furniture)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = json.encode(house)}) 
    MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@bought_furniture'] = json.encode(furniture)}) 
end)

ESX.RegisterServerCallback('loaf_housing:hasGuests', function(source, cb)
    local hasGuest = false
    for k, v in pairs(instances[source]['players']) do
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if v ~= source and v == tonumber(src) then
                hasGuest = true
                break
            end
        end
    end
    cb(hasGuest)
end)

ESX.RegisterServerCallback('loaf_housing:hasGuests2', function(source, cb, kuca)
    local hasGuest = false
    for k, v in pairs(instances[source]['players']) do
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if v ~= source and v == tonumber(src) then
                TriggerClientEvent("loaf_housing:leaveHouse", v, kuca)
            end
        end
    end
    cb(hasGuest)
end)

ESX.RegisterServerCallback('loaf_housing:hostOnline', function(source, cb, host)
    local online = false
    if instances[host] then
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if host == tonumber(src) then
                online = true
                break
            end
        end
        if not online then
			if instances[host]['housespawn'] ~= nil then
				Config.HouseSpawns[instances[host]['housespawn']]['taken'] = false
				instances[host] = {}
			end
        end
    end
    cb(online)
end)

ESX.RegisterServerCallback('loaf_housing:getInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    cb({['items'] = xPlayer.inventory, ['weapons'] = xPlayer.getLoadout()})
end)

ESX.RegisterServerCallback('loaf_housing:getHouseInv', function(source, cb, owner)
	local xPlayer = ESX.GetPlayerFromId(source)
    local items, weapons = {}, {}
    
    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']

            TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                items = inventory.items
            end)

            TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(storage)
                weapons = storage.get('weapons') or {}
            end)

            cb({['items'] = items, ['weapons'] = weapons})
        end
    end
end)

RegisterServerEvent('loaf_housing:withdrawItem')
AddEventHandler('loaf_housing:withdrawItem', function(type, item, amount, owner, torba)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']
            if type == 'item' then

                TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                    if inventory.getItem(item)['count'] >= amount then
						local xItem = xPlayer.getInventoryItem(item)
						if torba then
							if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit*2 then
								TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise u inventory!")
							else
								TriggerClientEvent('esx:showNotification', src, (Strings['You_Withdrew']):format(amount, inventory.getItem(item)['label']))
								xPlayer.addInventoryItem(item, amount)
								inventory.removeItem(item, amount)
							end
						else
							if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit then
								TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise u inventory!")
							else
								TriggerClientEvent('esx:showNotification', src, (Strings['You_Withdrew']):format(amount, inventory.getItem(item)['label']))
								xPlayer.addInventoryItem(item, amount)
								inventory.removeItem(item, amount)
							end
						end
                    else
                        TriggerClientEvent('esx:showNotification', src, Strings['Not_Enough_House'])
                    end
                end)

            elseif type == 'weapon' then

                TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(weapons)
                    local loadout = weapons.get('weapons') or {}

                    for i = 1, #loadout do
                        if loadout[i]['name'] == item then
                            
                            table.remove(loadout, i)
                            weapons.set('weapons', loadout)
                            xPlayer.addWeapon(item, amount)

                            break
                        end
                    end
                end)
            end
        end

    end
    
end)

RegisterServerEvent('loaf_housing:storeItem')
AddEventHandler('loaf_housing:storeItem', function(type, item, amount, owner)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']
            if type == 'item' then

                if xPlayer.getInventoryItem(item)['count'] >= amount then
                    TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                        xPlayer.removeInventoryItem(item, amount)
                        inventory.addItem(item, amount)
                        TriggerClientEvent('esx:showNotification', src, (Strings['You_Stored']):format(amount, inventory.getItem(item)['label']))
                    end)
                else
                    TriggerClientEvent('esx:showNotification', src, Strings['Not_Enough'])
                end

            elseif type == 'weapon' then

                local loadout, hasweapon = xPlayer.getLoadout(), false
                for k, v in pairs(loadout) do
                    if v['name'] == item then
                        hasweapon = true
                        break
                    end
                end

                if hasweapon then
                    TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(weapons)
                        local storage = weapons.get('weapons') or {}

                        table.insert(storage, {name = item, ammo = amount})

                        weapons.set('weapons', storage)
                        xPlayer.removeWeapon(item)
                    end)
                else
                    TriggerClientEvent('esx:showNotification', src, Strings['No_Weapon'])
                end
            end
        end

	end
end)