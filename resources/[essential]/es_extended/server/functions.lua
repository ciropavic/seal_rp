ESX.Trace = function(str)
	if Config.EnableDebug then
		print('ESX> ' .. str)
	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] ~= nil then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print('es_extended: TriggerServerCallback => [' .. name .. '] does not exist')
	end
	--print("Pozivam callback: "..name)
end

ESX.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- Inventory items
	for i=1, #xPlayer.inventory, 1 do
		if ESX.LastPlayerData[xPlayer.source].items[xPlayer.inventory[i].name] ~= xPlayer.inventory[i].count then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_inventory SET `count` = @count WHERE identifier = @identifier AND item = @item', {
					['@count']      = xPlayer.inventory[i].count,
					['@identifier'] = xPlayer.getID(),
					['@item']       = xPlayer.inventory[i].name
				}, function(rowsChanged)
					cb()
				end)
			end)

			ESX.LastPlayerData[xPlayer.source].items[xPlayer.inventory[i].name] = xPlayer.inventory[i].count
		end
	end

	-- Job, loadout and position
	table.insert(asyncTasks, function(cb)
		MySQL.Async.execute('UPDATE users SET `job` = @job, `posao` = @pos, `money` = @money, `job_grade` = @job_grade, `loadout` = @loadout, `position` = @position, `firma` = @firma, `status` = @st WHERE identifier = @identifier', {
			['@job']        = xPlayer.job.id,
			['@pos']		= xPlayer.posao.id,
			['@money']      = xPlayer.getMoney(),
			['@job_grade']  = xPlayer.job.grade,
			['@loadout']    = json.encode(xPlayer.getLoadout()),
			['@position']   = json.encode(xPlayer.getLastPosition()),
			['@identifier'] = xPlayer.identifier,
			['@firma'] 		= xPlayer.getFirma(),
			['@st'] 		= json.encode(xPlayer.getStatus())
		}, function(rowsChanged)
			cb()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		if xPlayer.name ~= nil then
			RconPrint('[SAVED] ' .. xPlayer.name .. "^7\n")
		end
		if cb ~= nil then
			cb()
		end
	end)
end

ESX.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			ESX.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('[SAVED] All players' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		SetTimeout(5 * 60 * 1000, saveData)
	end

	SetTimeout(5 * 60 * 1000, saveData)
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetPlayerFromDbId = function(id)
	for k,v in pairs(ESX.Players) do
		if v.id == id then
			return v
		end
	end
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.GetPlayerFromNumber = function(number)
	for k,v in pairs(ESX.Players) do
		if v.number == number then
			return v
		end
	end
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item](source)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] ~= nil then
		return ESX.Items[item].label
	end
end

ESX.CreatePickup = function(type, name, count, label, playerId)
	local pickupId = (ESX.PickupId == 65635 and 0 or ESX.PickupId + 1)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	ESX.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count,
		label = label,
		coords = xPlayer.getCoords()
	}

	TriggerClientEvent('esx:pickup', -1, pickupId, label, playerId, xPlayer.getCoords())
	ESX.PickupId = pickupId
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.DoesPosaoExist = function(job)

	if job then
		if ESX.Poslovi[job] then
			return true
		end
	end

	return false
end