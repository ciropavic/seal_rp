ESX = nil
local categories, vehicles = {}, {}
local br         = 0
local VoziloID   = {}
local Saloni = {}
local Vozila = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[esx_vehicleshop] [^3WARNING^7] Plate character count reached, %s/8 characters!'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT name, label, brod FROM vehicle_categories', {}, function(_categories)
		categories = _categories

		MySQL.Async.fetchAll('SELECT name, model, price, category, brod FROM vehicles', {}, function(_vehicles)
			vehicles = _vehicles

			for k,v in ipairs(vehicles) do
				for k2,v2 in ipairs(categories) do
					if v2.name == v.category then
						vehicles[k].categoryLabel = v2.label
						break
					end
				end
			end

			-- send information after db has loaded, making sure everyone gets vehicle information
			TriggerClientEvent('esx_vehicleshop:sendCategories', -1, categories)
			TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vehicles)
		end)
	end)
	MySQL.Async.fetchAll('SELECT ID, Ime, Cijena, Vlasnik, Kupovina, Sef FROM saloni', {}, function(result)
		Saloni = {}
		print(#result)
		for i=1, #result, 1 do
			print(result[i].Kupovina)
			local kup = json.decode(result[i].Kupovina)
			if kup ~= "{}" and kup.x ~= nil then
				kup = vector3(kup.x, kup.y, kup.z-1.0)
			else
				kup = nil
			end
			table.insert(Saloni, { ID = result[i].ID, Ime = result[i].Ime, Kupovina = kup, Vlasnik = result[i].Vlasnik, Cijena = result[i].Cijena, Sef = result[i].Sef })
		end
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
	end)
	MySQL.Async.fetchAll('SELECT ID, Tablica, SalonID, Cijena, Prop, Model, Mjenjac, Lokacija, Heading FROM saloni_vozila', {}, function(result)
		Vozila = {}
		for i=1, #result, 1 do
			local kup = json.decode(result[i].Lokacija)
			if kup ~= "{}" and kup.x ~= nil then
				kup = vector3(kup.x, kup.y, kup.z-1.0)
			else
				kup = nil
			end
			table.insert(Vozila, { ID = result[i].ID, Tablica = result[i].Tablica, SalonID = result[i].SalonID, Cijena = result[i].Cijena, Prop = json.decode(result[i].Prop), Model = result[i].Model, Mjenjac = result[i].Mjenjac, Lokacija = kup, Heading = result[i].Heading })
		end
		TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
	end)
end)

RegisterNetEvent('saloni:NapraviSalon')
AddEventHandler('saloni:NapraviSalon', function(cij)
	local src = source
	local kurac = "Salon "..(#Saloni+1)
	MySQL.Async.insert('INSERT INTO saloni (Ime, Cijena) VALUES (@ime, @cij)',{
		['@ime'] = kurac,
		['@cij'] = tonumber(cij)
	}, function(insertId)
		print(insertId)
		table.insert(Saloni, {ID = insertId, Ime = kurac, Vlasnik = nil, Cijena = cij, Sef = 0})
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
		TriggerClientEvent('esx:showNotification', src, kurac..' uspjesno kreiran!')
	end)
end)

ESX.RegisterServerCallback('saloni:DohvatiSalone', function(source, cb)
	cb(Saloni, Vozila)
end)

ESX.RegisterServerCallback('saloni:DajDostupnost', function(source, cb, store)
	local naso = false
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == store then
			if Saloni[i].Vlasnik == nil then
				cb(1)
				naso = true
				break
			end
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('saloni:ImasLiSalon', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].Vlasnik == xPlayer.getID() then
			cb(true)
			naso = true
			break
		end
	end
	if not naso then
		cb(false)
	end
end)

ESX.RegisterServerCallback('saloni:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == zona and Saloni[i].Vlasnik == xPlayer.getID() then
			cb(1)
			naso = true
			break
		end
	end
	if not naso then
		cb(0)
	end
end)

RegisterServerEvent('saloni:piku2')
AddEventHandler('saloni:piku2', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lova = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == id then
			lova = tonumber(Saloni[i].Cijena)
		end
	end
	-- can the player afford this item?
	if xPlayer.getMoney() >= lova then
		xPlayer.removeMoney(lova)
		local store = id
		MySQL.Async.execute('UPDATE saloni SET `Vlasnik` = @identifier WHERE ID = @store', {
			['@identifier'] = xPlayer.getID(),
			['@store'] = store
		})
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste salon za $"..lova)
		TriggerClientEvent("saloni:ReloadBlip", _source)
		for i=1, #Saloni, 1 do
			if Saloni[i] ~= nil and Saloni[i].ID == store then
				Saloni[i].Vlasnik = xPlayer.getID()
				break
			end
		end
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
	else
		local missingMoney = lova - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

RegisterServerEvent('saloni:Prodaj')
AddEventHandler('saloni:Prodaj', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lova = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == firma then
			lova = Saloni[i].Cijena
		end
	end
	xPlayer.addMoney(lova/2)
    local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..lova
	TriggerEvent("SpremiLog", por)
	MySQL.Async.execute('UPDATE saloni SET `Vlasnik` = null WHERE ID = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali salon!")
	TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
	TriggerClientEvent("saloni:ReloadBlip", -1)
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == firma then
			Saloni[i].Vlasnik = nil
			break
		end
	end
end)

RegisterServerEvent('saloni:ProdajIgracu')
AddEventHandler('saloni:ProdajIgracu', function(ime, id, cijena)
	local src = source
	TriggerClientEvent("saloni:PitajProdaju", id, ime, cijena, src)
end)

RegisterServerEvent('saloni:PrihvatioProdaju')
AddEventHandler('saloni:PrihvatioProdaju', function(ime, cijena, pid)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local tPlayer = ESX.GetPlayerFromId(pid)
	if xPlayer.getMoney() >= cijena then
		local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(pid).."("..tPlayer.identifier..") je dobio $"..cijena.."(linija 168)"
		TriggerEvent("SpremiLog", por)
		for i=1, #Saloni, 1 do
			if Saloni[i] ~= nil and Saloni[i].ID == ime then
				xPlayer.removeMoney(cijena)
				tPlayer.addMoney(cijena)
				Saloni[i].Vlasnik = xPlayer.getID()
				MySQL.Async.execute('UPDATE saloni SET `Vlasnik` = @ow WHERE ID = @st', {
					['@ow'] = xPlayer.getID(),
					['@st'] = ime
				})
				TriggerClientEvent("saloni:ReloadBlip", src)
				TriggerClientEvent("saloni:ReloadBlip", pid)
				tPlayer.showNotification("Prodali ste salon za $"..cijena.."!")
				xPlayer.showNotification("Kupili ste salon za $"..cijena.."!")
				TriggerEvent("DiscordBot:Prodaja", tPlayer.name.."["..tPlayer.source.."] je prodao salon "..ime.." za $"..cijena.." igracu "..xPlayer.name.."["..xPlayer.source.."]")
				break
			end
		end
	else
		tPlayer.showNotification("Igrac nema dovoljno novca kod sebe!")
		xPlayer.showNotification("Nemate dovoljno novca kod sebe!")
	end
end)

RegisterServerEvent('saloni:OdbioProdaju')
AddEventHandler('saloni:OdbioProdaju', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	xPlayer.showNotification("Igrac je odbio ponudu za prodaju salona!")
end)

RegisterNetEvent('saloni:SpremiCoord')
AddEventHandler('saloni:SpremiCoord', function(maf, coord, br)
	local Postoji = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		if br == 1 then
			MySQL.Async.execute('UPDATE saloni SET `Kupovina` = @kor WHERE ID = @id',{
				['@kor'] = json.encode(coord),
				['@id'] = maf
			})
			for i=1, #Saloni, 1 do
				if Saloni[i] ~= nil then
					if Saloni[i].ID == maf then
						local x,y,z = table.unpack(coord)
						local kor = vector3(x,y,z-1.0)
						Saloni[i].Kupovina = kor
						break
					end
				end
			end
			TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
			TriggerClientEvent('esx:showNotification', source, 'Salonu uspjesno postavljene koordinate kupovine!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Salon s tim ID-om ne postoji!')
	end
end)

RegisterNetEvent('saloni:SpremiVozilo')
AddEventHandler('saloni:SpremiVozilo', function(id, br, koord, head)
	local Postoji = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == id then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE saloni_vozila SET `Lokacija` = @kor, Heading = @head WHERE ID = @id',{
			['@kor'] = json.encode(koord),
			['@head'] = head,
			['@id'] = br
		})
		for i=1, #Vozila, 1 do
			if Vozila[i] ~= nil then
				if Vozila[i].ID == br then
					local x,y,z = table.unpack(koord)
					local kor = vector3(x,y,z)
					Vozila[i].Lokacija = kor
					Vozila[i].Heading = head
					break
				end
			end
		end
		TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
		TriggerClientEvent('esx:showNotification', source, 'Vozilo uspjesno postavljeno na prodaju!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Salon s tim ID-om ne postoji!')
	end
end)

RegisterNetEvent('saloni:PromjeniIme')
AddEventHandler('saloni:PromjeniIme', function(maf, lab)
	local Postoji = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE saloni SET `Ime` = @lab WHERE ID = @id',{
			['@lab'] = lab,
			['@id'] = maf
		})
		for i=1, #Saloni, 1 do
			if Saloni[i] ~= nil then
				if Saloni[i].ID == maf then
					Saloni[i].Ime = lab
					break
				end
			end
		end
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
		TriggerClientEvent('esx:showNotification', source, 'Salonu uspjesno promjenjeno ime!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Salon s tim ID-om ne postoji!')
	end
end)

RegisterServerEvent('saloni:MakniVlasnika')
AddEventHandler('saloni:MakniVlasnika', function(firma)
	local _source = source
	MySQL.Async.execute('UPDATE saloni SET `Vlasnik` = null WHERE ID = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali salon!")
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == firma then
			Saloni[i].Vlasnik = nil
			break
		end
	end
	TriggerClientEvent("saloni:ReloadBlip", -1)
end)

RegisterNetEvent('saloni:PromjeniCijenu')
AddEventHandler('saloni:PromjeniCijenu', function(maf, cij)
	local Postoji = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE saloni SET `Cijena` = @lab WHERE ID = @ime',{
			['@lab'] = cij,
			['@ime'] = maf
		})
		for i=1, #Saloni, 1 do
			if Saloni[i] ~= nil then
				if Saloni[i].ID == maf then
					Saloni[i].Cijena = cij
					break
				end
			end
		end
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
		TriggerClientEvent('esx:showNotification', source, 'Salonu uspjesno promjenjena cijena!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Salon s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('saloni:ObrisiSalon')
AddEventHandler('saloni:ObrisiSalon', function(maf)
	local Postoji = 0
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('DELETE FROM saloni WHERE ID = @ime',{
			['@ime'] = maf
		})
		for i=1, #Saloni, 1 do
			if Saloni[i] ~= nil then
				if Saloni[i].ID == maf then
					table.remove(Saloni, i)
					break
				end
			end
		end
		TriggerClientEvent("saloni:PosaljiSalone", -1, Saloni)
		TriggerClientEvent('esx:showNotification', source, 'Salon uspjesno obrisan!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Salon s tim imenom ne postoji!')
	end
end)

function DeriBrojac(brj)
	local bro = brj
	SetTimeout(300000, function()
		TriggerClientEvent('salon:ObrisiVozilo', -1, VoziloID[bro])
		VoziloID[bro] = nil
    end)
end

RegisterNetEvent('salon:SpawnVozilo')
AddEventHandler('salon:SpawnVozilo', function(vehicle, co, he, plate, mj)
	local _source = source
	local veh = CreateVehicle(vehicle.model, co, he, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	TriggerClientEvent("salon:VratiVozilo", _source, netid, vehicle, plate, mj, co)
end)

RegisterServerEvent('salon:PlatiStetu')
AddEventHandler('salon:PlatiStetu', function (cifra)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(cifra)
end)

RegisterServerEvent('salon:PokreniTimer')
AddEventHandler('salon:PokreniTimer', function (vid)
	local _source = source
	VoziloID[br] = vid
	DeriBrojac(br)
	br = br+1
end)

RegisterServerEvent('ProvjeraObrisanihVozila')
AddEventHandler('ProvjeraObrisanihVozila', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = xPlayer.getID()
	}, function (result)
		for i=1, #result, 1 do
			local v = json.decode(result[i].vehicle)
			for i=1, #vehicles, 1 do
				if GetHashKey(vehicles[i].model) == v.model and vehicles[i].category == "obrisani" then
					resellPrice = ESX.Math.Round(vehicles[i].price)
					xPlayer.addMoney(resellPrice)
					RemoveOwnedVehicle(v.plate)
					TriggerClientEvent('esx:showNotification', _source, "Vozilo "..vehicles[i].name.." je obrisano i dobili ste nazad "..resellPrice.."$")
					ESX.SavePlayer(xPlayer, function() 
					end)
					break
				end
			end
		end		
	end)
end)

function getVehicleLabelFromModel(model)
	for k,v in ipairs(vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

RegisterNetEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps, model, label)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealer' and xTarget then
		MySQL.Async.fetchAll('SELECT id FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = model
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
							['@owner']   = xTarget.getID(),
							['@plate']   = vehicleProps.plate,
							['@vehicle'] = json.encode(vehicleProps)
						}, function(rowsChanged)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_set_owned', vehicleProps.plate, xTarget.getName()))
							TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
						end)

						local dateNow = os.date('%Y-%m-%d %H:%M')

						MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
							['@client'] = xTarget.getName(),
							['@model'] = label,
							['@plate'] = vehicleProps.plate,
							['@soldby'] = xPlayer.getName(),
							['@date'] = dateNow
						})
					end
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT client, model, plate, soldby, date FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function(vehicle, plate, rentPrice, playerId)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealer' and xTarget then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicle
		}, function(result)
			if result[1] then
				local price = result[1].price

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = result[1].id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)', {
							['@vehicle']     = vehicle,
							['@plate']       = plate,
							['@player_name'] = xTarget.getName(),
							['@base_price']  = price,
							['@rent_price']  = rentPrice,
							['@owner']       = xTarget.identifier
						}, function(rowsChanged2)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_set_rented', plate, xTarget.getName()))
						end)
					end
				end)
			end
		end)
	end
end)

RegisterNetEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, item.label))
			else
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)
end)

RegisterNetEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(vehicles)
end)

ESX.RegisterServerCallback('autosalon:sealion', function(source, cb, model, plate, mjenjac, vd)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local modelPrice
	local modelName
	local naso = false
	local idsalona = nil
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].Vlasnik == xPlayer.getID() then
			naso = true
			idsalona = Saloni[i].ID
			break
		end
	end
	if naso then
		for k,v in ipairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				modelName = v.name
				break
			end
		end
		
		vd.plate = plate
		vd.model = GetHashKey(model)
		if mjenjac == 1 then
			if modelPrice and xPlayer.getMoney() >= (modelPrice+5000) then
				xPlayer.removeMoney(modelPrice+5000)
				MySQL.Async.insert('INSERT INTO saloni_vozila (Tablica, SalonID, Cijena, Prop, Model, Mjenjac) VALUES (@plate, @id, @cij, @pr, @mod, @mj)', {
					['@id']   = idsalona,
					['@plate']   = plate,
					['@cij'] = modelPrice,
					['@pr'] = json.encode(vd),
					['@mod'] = GetHashKey(model),
					['@mj'] = mjenjac
				}, function(insertId)
					TriggerClientEvent('esx:showNotification', _source, "Vozilo s tablicama "..plate.." je kupljeno i dostavljeno do vaseg salona!")
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."(automatik)["..plate.."] u salonu za $"..modelPrice+5000)
					table.insert(Vozila, { ID = insertId, Tablica = plate, SalonID = idsalona, Cijena = modelPrice+5000, Prop = vd, Model = GetHashKey(model), Mjenjac = mjenjac, Lokacija = "{}", Heading = nil })
					TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
					cb(true)
				end)
			else
				cb(false)
			end
		elseif mjenjac == 2 then
			if modelPrice and xPlayer.getMoney() >= modelPrice then
				xPlayer.removeMoney(modelPrice)
				MySQL.Async.insert('INSERT INTO saloni_vozila (Tablica, SalonID, Cijena, Prop, Model, Mjenjac) VALUES (@plate, @id, @cij, @pr, @mod, @mj)', {
					['@id']   = idsalona,
					['@plate']   = plate,
					['@cij'] = modelPrice,
					['@pr'] = json.encode(vd),
					['@mod'] = GetHashKey(model),
					['@mj'] = mjenjac
				}, function(insertId)
					TriggerClientEvent('esx:showNotification', _source, "Vozilo s tablicama "..plate.." je kupljeno i dostavljeno do vaseg salona!")
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."(rucni)["..plate.."] u salonu za $"..modelPrice)
					table.insert(Vozila, { ID = insertId, Tablica = plate, SalonID = idsalona, Cijena = modelPrice, Prop = vd, Model = GetHashKey(model), Mjenjac = mjenjac, Lokacija = "{}", Heading = nil })
					TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
					cb(true)
				end)
			else
				cb(false)
			end
		elseif mjenjac == 3 then
			if modelPrice and xPlayer.getMoney() >= modelPrice then
				xPlayer.removeMoney(modelPrice)
				MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, model, mjenjac, brod) VALUES (@owner, @plate, @vehicle, @model, @mj, @br)', {
					['@owner']   = xPlayer.getID(),
					['@plate']   = plate,
					['@vehicle'] = json.encode(vd),
					['@model'] = GetHashKey(model),
					['@mj'] = 1,
					['@br'] = 1
				}, function(rowsChanged)
					TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', plate))
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."(brod)["..plate.."] u salonu za $"..modelPrice)
					TriggerClientEvent("EoTiIzSalona", _source, 1)
					cb(true)
				end)
			else
				cb(false)
			end
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('autosalon:sealion2', function(source, cb, vid, tablica)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil then
			if Vozila[i].ID == vid then
				if xPlayer.getMoney() >= Vozila[i].Cijena then
					local modelName
					for k,v in ipairs(vehicles) do
						if tonumber(Vozila[i].Model) == GetHashKey(v.model) then
							modelName = v.name
							break
						end
					end
					xPlayer.removeMoney(Vozila[i].Cijena)
					for j=1, #Saloni, 1 do
						if Saloni[j] ~= nil and Saloni[j].ID == Vozila[i].SalonID then
							Saloni[j].Sef = Saloni[j].Sef+Vozila[i].Cijena
							MySQL.Async.execute('update saloni set Sef = @sef where ID = @id', {
								['@sef'] = Saloni[j].Sef,
								['@id']   = Saloni[j].ID
							}, function(rowsChanged)
								
							end)
							break
						end
					end
					Vozila[i].Prop.plate = tablica
					MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, model, mjenjac) VALUES (@owner, @plate, @vehicle, @model, @mj)', {
						['@owner']   = xPlayer.getID(),
						['@plate']   = tablica,
						['@vehicle'] = json.encode(Vozila[i].Prop),
						['@model'] = Vozila[i].Model,
						['@mj'] = Vozila[i].Mjenjac
					}, function(rowsChanged)
						TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', tablica))
						if modelName ~= nil then
							--TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."["..tablica.."] u salonu za $"..Vozila[i].Cijena)
						end
						cb(true)
					end)
					MySQL.Async.execute('delete from saloni_vozila where ID = @id', {
						['@id']   = vid
					}, function(rowsChanged)

					end)
					table.remove(Vozila, i)
					TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
				else
					cb(false)
				end
				break
			end
		end
	end
end)

ESX.RegisterServerCallback('saloni:DajSef', function(source, cb, store)
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == store then
			cb(Saloni[i].Sef)
			break
		end
	end
end)

RegisterServerEvent('saloni:PostaviCijenu')
AddEventHandler('saloni:PostaviCijenu', function(id, amount)
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil then
			if Vozila[i].ID == id then
				Vozila[i].Cijena = amount
				break
			end
		end
	end
	MySQL.Async.execute('UPDATE saloni_vozila SET `Cijena` = @ci WHERE ID = @st', {
		['@ci'] = amount,
		['@st'] = id
	})
	TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
end)

RegisterServerEvent('saloni:SpremiUGarazu')
AddEventHandler('saloni:SpremiUGarazu', function(id)
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil then
			if Vozila[i].ID == id then
				Vozila[i].Lokacija = "{}"
				break
			end
		end
	end
	MySQL.Async.execute('UPDATE saloni_vozila SET `Lokacija` = "{}" WHERE ID = @st', {
		['@st'] = id
	})
	TriggerClientEvent("saloni:PosaljiVozila", -1, Vozila)
end)

RegisterServerEvent('saloni:OduzmiSef')
AddEventHandler('saloni:OduzmiSef', function(id, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT Sef FROM saloni WHERE ID = @st', {
		['@st'] = id
	})
	local cij = result[1].Sef-amount
	MySQL.Async.execute('UPDATE saloni SET `Sef` = @se WHERE ID = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Saloni, 1 do
		if Saloni[i] ~= nil and Saloni[i].ID == id then
			Saloni[i].Sef = Saloni[i].Sef-amount
			break
		end
	end
	xPlayer.addMoney(amount)
    local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..amount
	TriggerEvent("SpremiLog", por)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT price, vehicle FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(source, cb, model)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealer' then
		local modelPrice

		for k,v in ipairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				break
			end
		end

		if modelPrice then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				if account.money >= modelPrice then
					account.removeMoney(modelPrice)

					MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
						['@vehicle'] = model,
						['@price'] = modelPrice
					}, function(rowsChanged)
						cb(true)
					end)
				else
					cb(false)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealer' then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicleModel
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
							local price = ESX.Math.Round(result[1].price * 0.75)
							local vehicleLabel = getVehicleLabelFromModel(vehicleModel)

							account.addMoney(price)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_sold_for', vehicleLabel, ESX.Math.GroupDigits(price)))
						end)
					end
				end)
			else
				print(('[esx_vehicleshop] [^3WARNING^7] %s attempted selling an invalid vehicle!'):format(xPlayer.identifier))
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles ORDER BY player_name ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT base_price, vehicle FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(rowsChanged)
				MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
					['@vehicle'] = vehicle,
					['@price']   = basePrice
				})

				RemoveOwnedVehicle(plate)
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, model)
	local xPlayer, resellPrice = ESX.GetPlayerFromId(source)
	local vime = nil

	--if xPlayer.job.name == 'cardealer' then
		-- calculate the resell price
		for i=1, #vehicles, 1 do
			if GetHashKey(vehicles[i].model) == model then
				resellPrice = ESX.Math.Round(vehicles[i].price / 100 * Config.ResellPercentage)
				vime = vehicles[i].name
				break
			end
		end

		if not resellPrice then
			print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an unknown vehicle!'):format(xPlayer.identifier))
			cb(false)
		else
			MySQL.Async.fetchScalar('SELECT base_price FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				if result then -- is it a rented vehicle?
					cb(false) -- it is, don't let the player sell it since he doesn't own it
				else
					MySQL.Async.fetchScalar('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = xPlayer.getID(),
						['@plate'] = plate
					}, function(result)
						if result then -- does the owner match?
							local vehicle = json.decode(result)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									TriggerEvent("DiscordBot:Vozila", GetPlayerName(source).." je prodao "..vime.."["..plate.."] u salonu za $"..resellPrice)
									cb(true)
								else
									print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						end
					end)
				end
			end)
		end
	--end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.getID(),
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_vehicleshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
