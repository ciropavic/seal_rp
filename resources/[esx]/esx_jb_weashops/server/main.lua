ESX               = nil
local ItemsLabels = {}
local GunShopPrice = Config.EnableClip.GunShop.Price
local GunShopLabel = Config.EnableClip.GunShop.Label

local Shopovi = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function LoadLicenses (source)
  TriggerEvent('esx_license:getLicenses', source, function (licenses)
    TriggerClientEvent('esx_weashop:loadLicenses', source, licenses)
  end)
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT name, owner, sef FROM weashops2', {}, function(result)
		for i=1, #result, 1 do
			table.insert(Shopovi, { store = result[i].name, owner = result[i].owner, sef = result[i].sef })
		end
	end)
end)

if Config.EnableLicense == true then
  AddEventHandler('esx:playerLoaded', function (source)
    LoadLicenses(source)
  end)
end

RegisterServerEvent('oruzje:dajgalicenca')
AddEventHandler('oruzje:dajgalicenca', function (zona)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.LicensePrice then
    xPlayer.removeMoney(Config.LicensePrice)

    TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
      LoadLicenses(_source)
	  TriggerClientEvent("oruzje:OtvoriMenu", _source, zona)
    end)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
end)

RegisterServerEvent('oruzarnica:ProdajIgracu')
AddEventHandler('oruzarnica:ProdajIgracu', function(ime, id, cijena)
	local src = source
	TriggerClientEvent("oruzarnica:PitajProdaju", id, ime, cijena, src)
end)

RegisterServerEvent('oruzarnica:PrihvatioProdaju')
AddEventHandler('oruzarnica:PrihvatioProdaju', function(ime, cijena, pid)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local tPlayer = ESX.GetPlayerFromId(pid)
	if xPlayer.getMoney() >= cijena then
		local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(pid).."("..tPlayer.identifier..") je dobio $"..cijena.."(linija 59)"
		TriggerEvent("SpremiLog", por)
		for i=1, #Shopovi, 1 do
			if Shopovi[i] ~= nil and Shopovi[i].store == ime then
				xPlayer.removeMoney(cijena)
				tPlayer.addMoney(cijena)
				Shopovi[i].owner = xPlayer.identifier
				MySQL.Async.execute('UPDATE weashops2 SET `owner` = @identifier WHERE name = @store', {
					['@identifier'] = xPlayer.identifier,
					['@store'] = ime
				})
				TriggerClientEvent("esx_gun:ReloadBlip", src)
				TriggerClientEvent("esx_gun:ReloadBlip", pid)
				tPlayer.showNotification("Prodali ste oruzarnicu za $"..cijena.."!")
				xPlayer.showNotification("Kupili ste oruzarnicu za $"..cijena.."!")
				TriggerEvent("DiscordBot:Prodaja", tPlayer.name.."["..tPlayer.source.."] je prodao oruzarnicu "..ime.." za $"..cijena.." igracu "..xPlayer.name.."["..xPlayer.source.."]")
				break
			end
		end
	else
		tPlayer.showNotification("Igrac nema dovoljno novca kod sebe!")
		xPlayer.showNotification("Nemate dovoljno novca kod sebe!")
	end
end)

RegisterServerEvent('oruzarnica:OdbioProdaju')
AddEventHandler('oruzarnica:OdbioProdaju', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	xPlayer.showNotification("Igrac je odbio ponudu za prodaju oruzarnice!")
end)

ESX.RegisterServerCallback('esx_gun:DajDostupnost', function(source, cb, store)
	local naso = false
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == store then
			if Shopovi[i].owner == nil then
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

ESX.RegisterServerCallback('esx_gun:DajSef', function(source, cb, store)
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == store then
			cb(Shopovi[i].sef)
			break
		end
	end
end)

ESX.RegisterServerCallback('esx_gun:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == zona and Shopovi[i].owner == xPlayer.identifier then
			cb(1)
			naso = true
			break
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_gun:DajBrojTrgovina', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local br = 0
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].owner == xPlayer.identifier then
			br = br+1
		end
	end
	cb(br)
end)

RegisterServerEvent('weapon:piku2')
AddEventHandler('weapon:piku2', function(zona, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	-- can the player afford this item?
	if xPlayer.getMoney() >= 5000000 then
		xPlayer.removeMoney(5000000)
		local store = zona..id
		MySQL.Async.execute('UPDATE weashops2 SET `owner` = @identifier WHERE name = @store', {
			['@identifier'] = xPlayer.identifier,
			['@store'] = store
		})
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste GunShop za $5000000")
		TriggerClientEvent("esx_gun:ReloadBlip", _source)
		for i=1, #Shopovi, 1 do
			if Shopovi[i] ~= nil and Shopovi[i].store == store then
				Shopovi[i].owner = xPlayer.identifier
				break
			end
		end
	else
		local missingMoney = 5000000 - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

function DajFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM weashops2 WHERE name = @st', {
		['@st'] = id
	})
	local cij = result[1].sef+price
	MySQL.Async.execute('UPDATE weashops2 SET `sef` = @se WHERE name = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == id then
			Shopovi[i].sef = Shopovi[i].sef+price
			break
		end
	end
end

function OduzmiFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM weashops2 WHERE name = @st', {
		['@st'] = id
	})
	local cij = result[1].sef-price
	MySQL.Async.execute('UPDATE weashops2 SET `sef` = @se WHERE name = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == id then
			Shopovi[i].sef = Shopovi[i].sef-price
			break
		end
	end
end

RegisterServerEvent('esx_gun:ProdajFirmu')
AddEventHandler('esx_gun:ProdajFirmu', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(2500000)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $2500000"
	TriggerEvent("SpremiLog", por)
	MySQL.Async.execute('UPDATE weashops2 SET `owner` = null WHERE name = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali GunShop!")
	TriggerClientEvent("esx_gun:ReloadBlip", _source)
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == firma then
			Shopovi[i].owner = nil
			break
		end
	end
end)

RegisterServerEvent('esx_gun:OduzmiFirmi')
AddEventHandler('esx_gun:OduzmiFirmi', function(firma, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	OduzmiFirmi(firma, amount)
	xPlayer.addMoney(amount)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..amount
	TriggerEvent("SpremiLog", por)
end)


ESX.RegisterServerCallback('esx_weashop:requestDBItems', function(source, cb)

  MySQL.Async.fetchAll(
    'SELECT name, item, price FROM weashops',
    {},
    function(result)

      local shopItems  = {}

      for i=1, #result, 1 do

        if shopItems[result[i].name] == nil then
          shopItems[result[i].name] = {}
        end

        table.insert(shopItems[result[i].name], {
          name  = result[i].item,
          price = result[i].price,
          label = ESX.GetWeaponLabel(result[i].item)
        })
      end
	  
	  if Config.EnableClipGunShop == true then
		table.insert(shopItems["GunShop"], {
          name  = "clip",
          price = GunShopPrice,--Config.EnableClip.GunShop.Price,
          label = GunShopLabel--Config.EnableClip.GunShop.label
        })
		end
      cb(shopItems)

    end
  )
  LoadLicenses(source)
end)

RegisterServerEvent('wesh:KuPi2')
AddEventHandler('wesh:KuPi2', function(oruzje, comp, label, zone, ide)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 700 then
		print(oruzje)
		print(comp)
		print(label)
		xPlayer.addWeaponComponent(oruzje, comp)
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste "..label.." za 700$!")
		xPlayer.removeMoney(700)
		DajFirmi(zone..ide, 350)
	else
		TriggerClientEvent('esx:showNotification', _source, "Nemate dovoljno novca!")
	end
end)

RegisterServerEvent('wesh:KuPi')
AddEventHandler('wesh:KuPi', function(itemName, price, zone, id, torba)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if zone=="BlackWeashop" then
    if account.money >= price then
		if itemName == "clip" then
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. "sarzer")
			local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x 1"
			TriggerEvent("SpremiLog", por)
		else
			xPlayer.addWeapon(itemName, 42)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		end
		xPlayer.removeAccountMoney('black_money', price)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
	end

  else if xPlayer.get('money') >= price then
		if itemName == "clip" then
			if torba then
				if xPlayer.getInventoryItem('clip').count < 15*2 then
					xPlayer.addInventoryItem(itemName, 1)
					TriggerClientEvent('esx:showNotification', _source, _U('buy') .. "sarzer")
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x 1"
					TriggerEvent("SpremiLog", por)
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Ne stane vam vise sarzera!')
				end
			else
				if xPlayer.getInventoryItem('clip').count < 15 then
					xPlayer.addInventoryItem(itemName, 1)
					TriggerClientEvent('esx:showNotification', _source, _U('buy') .. "sarzer")
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x 1"
					TriggerEvent("SpremiLog", por)
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Ne stane vam vise sarzera!')
				end
			end
		else
			xPlayer.addWeapon(itemName, 42)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		end
		xPlayer.removeMoney(price)
		DajFirmi(zone..id, price/2)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
  end

end)

-- thx to Pandorina for script
RegisterServerEvent('esx_weashop:remove')
AddEventHandler('esx_weashop:remove', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('esx_weashop:clipcli', source)
end)
