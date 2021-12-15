ESX = nil
local TrajeLive = 0
local BrojLjudi = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'reporter', Config.MaxInService)
end

-- TriggerEvent('esx_phone:registerNumber', 'mafia', _U('alert_mafia'), true, true)
TriggerEvent('esx_society:registerSociety', 'reporter', 'Reporter', 'society_reporter', 'society_reporter', 'society_reporter', {type = 'public'})

RegisterServerEvent('esx_reporter:giveWeapon')
AddEventHandler('esx_reporter:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('reporter:Zaposli')
AddEventHandler('reporter:Zaposli', function(posao, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		TriggerClientEvent("upit:OtvoriPitanje", id, "esx_reporter", "Upit za posao", "Pozvani ste da se zaposlite kao reporter. Prihvacate?", {posao = posao, id = id})
	end
end)

RegisterServerEvent('reporter:Zaposli2')
AddEventHandler('reporter:Zaposli2', function(posao, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		xPlayer.setJob(posao, 0)
		xPlayer.showNotification("Zaposleni ste u reportere!")
		MySQL.Async.execute('UPDATE users SET `job` = @job, `job_grade` = 0 WHERE ID = @id', {
			['@id'] = xPlayer.getID(),
			['@job'] = tonumber(posao)
		})
	end
end)

RegisterServerEvent('reporter:DajImPare')
AddEventHandler('reporter:DajImPare', function(br)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.job.name == "reporter" then
		local societyAccount = nil
		local pare = br*200
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_reporter", function(account)
			societyAccount = account
			societyAccount.addMoney(pare)
		end)
		local pare2 = br*100
		xPlayer.addMoney(pare2)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vi ste dobili $"..pare2.." dok je vasa firma dobila $"..pare.."!")
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za novac reportera, a nije zaposlen kao reporter!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)

RegisterNetEvent("weazel:DodajClanak")
AddEventHandler("weazel:DodajClanak", function(ime, naziv, clanak)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.job.name == "reporter" then
		MySQL.Async.execute('INSERT INTO vijesti (Naziv, Clanak, Autor) VALUES (@naz, @cl, @au)',
		{
			['@naz'] = naziv,
			['@cl']  = clanak,
			['@au']  = ime
		})
		TriggerClientEvent("weazel:SaljiClanak", -1, Sanitize(ime), naziv, clanak)
	end
end)

RegisterNetEvent("weazel:DohvatiVijesti")
AddEventHandler("weazel:DohvatiVijesti", function()
	local _source = source
	MySQL.Async.fetchAll('SELECT * FROM vijesti', {}, function(result)
		for i=1, #result, 1 do
			local rez = result[i]
			TriggerClientEvent("weazel:SaljiClanak", _source, rez.Autor, rez.Naziv, rez.Clanak, 1)
		end
	end)
end)

RegisterServerEvent('PovecajLjude')
AddEventHandler('PovecajLjude', function()
	BrojLjudi = BrojLjudi+1
	TriggerClientEvent("EoTiLjudi", -1, BrojLjudi)
end)

RegisterServerEvent('SmanjiLjude')
AddEventHandler('SmanjiLjude', function()
	BrojLjudi = BrojLjudi-1
	TriggerClientEvent("EoTiLjudi", -1, BrojLjudi)
end)

function CountReportere()
	TrajeLive = 0
	TriggerClientEvent("JelKoLive", -1)
	SetTimeout(1000, function()
		TriggerClientEvent("TrajeLiveSine", -1, TrajeLive)
    end)
	SetTimeout(60000, CountReportere)
end

CountReportere()

RegisterNetEvent("PrebaciIDKamere")
AddEventHandler("PrebaciIDKamere", function(id)
	BrojLjudi = 0
    TriggerClientEvent("EoTiIDKamere", -1, id)
end)

RegisterNetEvent("ProvjeriLive")
AddEventHandler("ProvjeriLive", function()
	TrajeLive = false
    TriggerClientEvent("JelKoLive", -1)
end)

RegisterNetEvent("JaSamLive")
AddEventHandler("JaSamLive", function()
	TrajeLive = TrajeLive+1
end)

RegisterNetEvent("PosaljiZoom")
AddEventHandler("PosaljiZoom", function(nest, id)
    TriggerClientEvent("VratiZoom", -1, nest, id)
end)

RegisterNetEvent("SaljiRotaciju")
AddEventHandler("SaljiRotaciju", function(x,z,id)
    TriggerClientEvent("VratiRotaciju", -1, x, z, id)
end)

RegisterServerEvent('esx_reporter:getStockItem')
AddEventHandler('esx_reporter:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_reporter', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
	  TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

  end)

end)

RegisterServerEvent('esx_reporter:putStockItems')
AddEventHandler('esx_reporter:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_reporter', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

ESX.RegisterServerCallback('esx_reporter:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = Sanitize(GetPlayerName(target)),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = Sanitize(GetPlayerName(target)),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_reporter:DajMiKoord', function(source, cb, idigr)
	print(idigr)
	local koord = GetEntityCoords(GetPlayerPed(idigr))
	print(koord)
	cb(koord)
end)

ESX.RegisterServerCallback('esx_reporter:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_mafia WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_reporter:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_reporter:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_reporter', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_reporter:addArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_reporter', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
		weapons[i].ammo = weapons[i].ammo+am
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1,
		ammo = am
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_reporter:removeArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, am)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_reporter', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
		weapons[i].ammo = (weapons[i].ammo > 0 and weapons[i].ammo - am or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0,
		ammo = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_reporter:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_reporter', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_reporter:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
