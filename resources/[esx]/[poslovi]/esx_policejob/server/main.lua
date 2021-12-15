ESX = nil

local Cuffan = {}
local BrojObjekata = 0
local Kazne = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM fine_types', {
		['@category'] = category
	}, function(fines)
		Kazne = fines
	end)
end)

RegisterServerEvent('policija:OtpustiIgraca')
AddEventHandler('policija:OtpustiIgraca', function(id)
	local xPlayer = ESX.GetPlayerFromDbId(id)
	if xPlayer then
		xPlayer.setJob(1, 0)
	else
		MySQL.Async.execute('update users set job = 1, job_grade = 0 where ID = @id', {
			['@id'] = id
        })
	end
	local xPlayer2 = ESX.GetPlayerFromId(source)
	xPlayer2.showNotification("Uspjesno otpusten zaposlenik!")
end)

RegisterServerEvent('policija:PostaviRank')
AddEventHandler('policija:PostaviRank', function(id, posao, rank)
	local xPlayer = ESX.GetPlayerFromDbId(id)
	if xPlayer then
		xPlayer.setJob(posao, rank)
	else
		MySQL.Async.execute('update users set job_grade=@grade where ID = @id', {
          	['@grade'] = rank,
			['@id'] = id
        })
	end
	local xPlayer2 = ESX.GetPlayerFromId(source)
	xPlayer2.showNotification("Uspjesno postavljen rank zaposleniku!")
end)

RegisterServerEvent('policija:PostaviPlacu')
AddEventHandler('policija:PostaviPlacu', function(id, placa)
	MySQL.Async.execute('update job_grades set salary=@sal where id = @id', {
		['@sal'] = placa,
		['@id'] = id
	})
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.showNotification("Uspjesno postavljena placa ranku!")
end)

ESX.RegisterServerCallback('policija:getOnlinePlayers', function(source, cb, job)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--if tonumber(xPlayer.getJob().id) ~= tonumber(job) then
			table.insert(players, {
				value      = xPlayer.source,
				identifier = xPlayer.id,
				label      = xPlayer.getRPName()
			})
		--end
		Wait(100)
	end
	cb(players)
end)

RegisterServerEvent('policija:Zaposli')
AddEventHandler('policija:Zaposli', function(posao, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		TriggerClientEvent("upit:OtvoriPitanje", id, "esx_policejob", "Upit za posao", "Pozvani ste da se zaposlite kao policajac. Prihvacate?", {posao = posao, id = id})
	end
end)

RegisterServerEvent('policija:Zaposli2')
AddEventHandler('policija:Zaposli2', function(posao, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		xPlayer.setJob(posao, 0)
		xPlayer.showNotification("Zaposleni ste u policiju!")
		MySQL.Async.execute('UPDATE users SET `job` = @job, `job_grade` = 0 WHERE ID = @id', {
			['@id'] = xPlayer.getID(),
			['@job'] = tonumber(posao)
		})
	end
end)

RegisterServerEvent('popo:zapljeni9')
AddEventHandler('popo:zapljeni9', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
 
    if sourceXPlayer.job.name ~= 'police' then
        print(('esx_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
        return
    end
 
    if itemType == 'item_standard' then
        local targetItem = targetXPlayer.getInventoryItem(itemName)
        local sourceItem = sourceXPlayer.getInventoryItem(itemName)
 
        -- does the target player have enough in their inventory?
        if targetItem.count > 0 and targetItem.count <= amount then
            targetXPlayer.removeInventoryItem(itemName, amount)
			TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.." "..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
            --sourceXPlayer.addInventoryItem   (itemName, amount)
            TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
            TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
        else
            TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
        end
 
    elseif itemType == 'item_account' then
        targetXPlayer.removeMoney(amount)
		MySQL.Async.execute('UPDATE users SET `money` = @money WHERE identifier = @identifier', {
					['@money']      = targetXPlayer.getMoney(),
					['@identifier'] = targetXPlayer.identifier
				}, function(rowsChanged)
		end)
		local societyAccount = nil
		local sime = "society_police"
		TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
			societyAccount = account
		end)
		societyAccount.addMoney(amount)
        --sourceXPlayer.addMoney   (itemName, amount)
		TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo $"..amount.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
        --TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
 
    elseif itemType == 'item_weapon' then
        if amount == nil then amount = 0 end
        targetXPlayer.removeWeapon(itemName, amount)
        --sourceXPlayer.addWeapon   (itemName, amount)
		TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo oruzje "..itemName.." sa "..amount.." metaka od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
        --TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
    end
end)

RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state, nid)
	TriggerClientEvent('heli:spotlight', -1, nid, state)
end)

RegisterNetEvent('policija:UpaliSirenu')
AddEventHandler('policija:UpaliSirenu', function(nid, sir, mut)
	TriggerClientEvent("policija:VratiSirenu", -1, nid, sir, mut)
end)

RegisterNetEvent('policija:MakniObjekt')
AddEventHandler('policija:MakniObjekt', function()
	BrojObjekata = BrojObjekata-1
	if BrojObjekata < 0 then
		BrojObjekata = 0
	end
	TriggerClientEvent("policija:EoObjekti", -1, BrojObjekata)
end)

ESX.RegisterServerCallback('esx_policejob:dohvatiRankove', function(source, cb, posao)
	MySQL.Async.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = @job', {
		['@job'] = posao
	}, function(grades)
		local data = {}
		for i=1, #grades, 1 do
			table.insert(data, {label = grades[i].label, value=grades[i].grade})
		end
		cb(data)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:dohvatiPlace', function(source, cb, posao)
	MySQL.Async.fetchAll('SELECT id, salary, label FROM job_grades WHERE job_name = @job', {
		['@job'] = posao
	}, function(grades)
		local data = {}
		for i=1, #grades, 1 do
			table.insert(data, {label = grades[i].label.." ($"..grades[i].salary..")", value=grades[i].id})
		end
		cb(data)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:dohvatiZaposlene', function(source, cb, posao)
	MySQL.Async.fetchAll('SELECT users.ID, firstname, lastname, job_grades.label FROM users \
	inner join jobs on jobs.pID = users.job \
	inner join job_grades on job_grades.grade = users.job_grade and job_grades.job_name = jobs.name \
	WHERE job = @job', {
		['@job'] = posao
	}, function(users)
		local data = {}
		for i=1, #users, 1 do
			table.insert(data, {label = users[i].firstname.." "..users[i].lastname.." ["..users[i].label.."]", value=users[i].ID})
		end
		cb(data)
	end)
end)

ESX.RegisterServerCallback('policija:DohvatiObjekte', function(source, cb)
	cb(BrojObjekata)
end)

RegisterNetEvent('esx_qalle_brottsregister:add')
AddEventHandler('esx_qalle_brottsregister:add', function(id, reason)
  local identifier = ESX.GetPlayerFromId(id).identifier
  local date = os.date("%Y-%m-%d")
  MySQL.Async.fetchAll(
    'SELECT firstname, lastname FROM users WHERE identifier = @identifier',{['@identifier'] = identifier},
    function(result)
    if result[1] ~= nil then
      MySQL.Async.execute('INSERT INTO qalle_brottsregister (identifier, firstname, lastname, dateofcrime, crime) VALUES (@identifier, @firstname, @lastname, @dateofcrime, @crime)',
        {
          ['@identifier']   = identifier,
          ['@firstname']    = result[1].firstname,
          ['@lastname']     = result[1].lastname,
          ['@dateofcrime']  = date,
          ['@crime']        = reason,
        }
      )
    end
  end)
end)

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]
        return identity
    else
        return nil
    end
end

RegisterServerEvent('esx_dowod:pokaznacke')
AddEventHandler('esx_dowod:pokaznacke', function()	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = xPlayer.job
	local name = getIdentity(source)
	local czy_wazna
	if job.name == "police" or job.name == "sipa" then
		czy_wazna = "~g~DA"
	else
		job.grade_label = "~r~Nema dostupnih podataka"
		czy_wazna = "~r~NE"
	end
	if job.name == "police" or job.name == "sipa" or job.name == "zastitar" or job.name == "Gradonacelnik" then
		TriggerClientEvent("gln:plateanim", _source)
		Citizen.Wait(3000)
		--TriggerClientEvent('esx:dowod_pokazOdznake', -1,_source, '~h~'..name.firstname..' '..name.lastname, 'Znacka LSPD' , 'Stopień ~b~'..job.grade_label..'~s~~n~Znacka jest ważna '..czy_wazna)
		local ped = GetPlayerPed(_source)
		local koord = GetEntityCoords(ped)
		TriggerClientEvent('esx:dowod_pokazZnacka', -1, _source, '~h~'..name.firstname..' '..name.lastname, 'Znacka' , 'Polozaj ~b~'..job.grade_label, koord)
	else
		TriggerClientEvent('esx:showNotification', _source, ('~r~Ne radite u ~s~policiji!'))
	end

end)

--gets brottsregister
ESX.RegisterServerCallback('esx_qalle_brottsregister:grab', function(source, cb, target)
  local identifier = ESX.GetPlayerFromId(target).identifier
  MySQL.Async.fetchAll("SELECT identifier, firstname, lastname, dateofcrime, crime FROM `qalle_brottsregister` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if identifier ~= nil then
        local crime = {}

      for i=1, #result, 1 do
        table.insert(crime, {
          crime = result[i].crime,
          name = result[i].firstname .. ' - ' .. result[i].lastname,
          date = result[i].dateofcrime,
        })
      end
      cb(crime)
    end
  end)
end)

RegisterNetEvent('policija:Cuffan')
AddEventHandler('policija:Cuffan', function(id, tip)
	Cuffan[id] = tip
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	if reason == "Exiting" or reason == "Disconnected." then
		if Cuffan[playerID] then
			TriggerEvent("ac:IzasoVezan", GetPlayerName(playerID))
		end
	end
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target, tip)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:handcuff', target, source, tip)
	else
		print(('esx_policejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:SaljiAnim')
AddEventHandler('esx_policejob:SaljiAnim', function(id, tip)
	TriggerClientEvent('esx_policejob:VratiAnim', id, tip)
end)

RegisterServerEvent('esx_policejob:SaljiAnimv2')
AddEventHandler('esx_policejob:SaljiAnimv2', function(id)
	TriggerClientEvent('esx_policejob:VratiAnimv2', id)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
	else
		print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_policejob:OutVehicle', target, source)
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, money, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height
		local money 	= result[1].money

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			novac 	  = money,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	local Kurac = {}
	for i=1, #Kazne, 1 do
		if Kazne[i] ~= nil and Kazne[i].category == category then
			table.insert(Kurac, { id = Kazne[i].id, amount = Kazne[i].amount, label = Kazne[i].label})
		end
	end
	cb(Kurac)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		cb()
	end
	
	if not removeWeapon then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
			local weapons = store.get('weapons')

			if weapons == nil then
				weapons = {}
			end

			local foundWeapon = false

			for i=1, #weapons, 1 do
				if weapons[i].name == weaponName then
					weapons[i].count = weapons[i].count + 1
					foundWeapon = true
					break
				end
			end

			if not foundWeapon then
				table.insert(weapons, {
					name  = weaponName,
					count = 1
				})
			end

			store.set('weapons', weapons)
			cb()
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum, nesta)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.AuthorizedWeapons[xPlayer.job.grade_name]

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esx_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)
				cb(true)
			else
				cb(false)
			end

		-- Weapon Component
		elseif type == 2 then
				local price = selectedWeapon.components[componentNum]
				local weaponNum, weapon = ESX.GetWeapon(weaponName)

				local component = weapon.components[componentNum]

				if component then
					if nesta == "metci" then
						xPlayer.addWeapon(weaponName, 100)
						print("Type 2 sam");
						cb(true)
					end
					if nesta ~= "metci" then
						if xPlayer.getMoney() >= price then
							xPlayer.removeMoney(price)
							xPlayer.addWeaponComponent(weaponName, component.name)
							cb(true)
						else
							cb(false)
						end
					end
				else
					print(('esx_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
					cb(false)
				end
		end
	end
end)


ESX.RegisterServerCallback('esx_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]
		local shared = Config.AuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)