ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Rx
local Ry
local Rz
local Rh

local Rx2
local Ry2
local Rz2
local Rh2
local ZadnjiARace = 0

local Pokreci = 0
local UUtrci = {}


ESX.RegisterServerCallback('trke:nemapara', function(source, cb, money)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        if xPlayer.getMoney() >= money then
            xPlayer.removeMoney(money)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end

end)

ESX.RegisterServerCallback('DajMiPermLevelCall', function(source, cb)
	local id = source
    local xPlayer = ESX.GetPlayerFromId(id)
	MySQL.Async.fetchScalar('SELECT permission_level FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
    end)
end)

RegisterNetEvent("DajMiPermLevel")
AddEventHandler('DajMiPermLevel', function(id)
	if id == 0 then
		TriggerEvent('VratiPermLevel', 69)
	else
		local xPlayer = ESX.GetPlayerFromId(id)
		MySQL.Async.fetchScalar('SELECT permission_level FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			TriggerEvent('VratiPermLevel', result)
		end)
	end
end)

RegisterNetEvent("utrke:BucketajGa")
AddEventHandler('utrke:BucketajGa', function(br)
	local src = source
	if br then
		SetPlayerRoutingBucket(src, 1)
	else
		SetPlayerRoutingBucket(src, 0)
	end
end)

RegisterNetEvent("DajMiPermLevel2")
AddEventHandler('DajMiPermLevel2', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	MySQL.Async.fetchScalar('SELECT permission_level FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		TriggerEvent('VratiPermLevel2', result)
	end)
end)

ESX.RegisterServerCallback('esx-races:DohvatiPermisiju', function(source, cb)
	local id = source
    local xPlayer = ESX.GetPlayerFromId(id)
	local Vrati = 0
	if xPlayer ~= nil then
		MySQL.Async.fetchScalar('SELECT permission_level FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result > 0 then
				Vrati = 1
			else
				Vrati = 0
			end
			cb(Vrati)
		end)
	else
		cb(0)
	end
end)

function PokreniAutoUtrku()
	local brojcic = 0
	for race, val in pairs(Config.RaceInformations) do
		brojcic = brojcic+1
	end
	local RandomUtrka = math.random(1, brojcic)
	while RandomUtrka == ZadnjiARace do
		RandomUtrka = math.random(1, brojcic)
	end
	ZadnjiARace = RandomUtrka
	local br = 1
	for race, val in pairs(Config.RaceInformations) do
		if br == RandomUtrka then
			TriggerClientEvent("PokreniAUtrku", -1, race)
			SynVrijeme(60)
			break
		end
		br = br+1
	end
	SetTimeout(1800000, PokreniAutoUtrku)
end

RegisterNetEvent("SpremiPocela")
AddEventHandler('SpremiPocela', function(br)
	TriggerClientEvent('VratiPocela', -1, br)
end)

RegisterNetEvent("SpremiUtrku")
AddEventHandler('SpremiUtrku', function(utr)
	TriggerClientEvent('VratiUtrku', -1, utr)
end)

RegisterNetEvent("PrekiniUtrku")
AddEventHandler('PrekiniUtrku', function()
	TriggerClientEvent('ZaustaviUtrku', -1)
end)

RegisterNetEvent("utrka:DiSuDajPare")
AddEventHandler('utrka:DiSuDajPare', function(broj)
	local src = source
	if UUtrci[src] == true then
		local xPlayer = ESX.GetPlayerFromId(src)
		local money = 0;
		if broj == 1 then
			money = 5000
		elseif broj == 2 then
			money = 3000
		elseif broj == 3 then
			money = 1000
		end
		if xPlayer ~= nil and money > 0 then
			xPlayer.addMoney(money)
			local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(source).."("..xPlayer.identifier..") je dobio $"..money
			TriggerEvent("SpremiLog", por)
			ESX.SavePlayer(xPlayer, function()
			end)
		end
		UUtrci[src] = false
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za novac od utrka, a nije u utrci!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)

RegisterNetEvent("SpremiPoziciju")
AddEventHandler('SpremiPoziciju', function(broj)
	TriggerClientEvent('VratiPoziciju', -1, broj)
end)

RegisterNetEvent("SpremiPozicijuCP")
AddEventHandler('SpremiPozicijuCP', function(cp, br)
	TriggerClientEvent('VratiPozicijuCP', -1, cp, br)
end)

function SynVrijeme(sec)
	Citizen.CreateThread(function()
		while sec ~= 0 do
			Citizen.Wait(1000)
			sec = sec-1
			TriggerClientEvent('Vrime', -1, sec)
		end
	end)
end

RegisterNetEvent("SyncajVrijeme")
AddEventHandler('SyncajVrijeme', function(sec)
	Citizen.CreateThread(function()
		while sec ~= 0 do
			Citizen.Wait(1000)
			sec = sec-1
			TriggerClientEvent('Vrime', -1, sec)
		end
	end)
end)

RegisterNetEvent("SpremiBroj")
AddEventHandler('SpremiBroj', function(broj)
	local src = source
	UUtrci[src] = true
	TriggerClientEvent('VratiBroj', -1, broj)
end)

RegisterNetEvent("SpremiTada")
AddEventHandler('SpremiTada', function(broj)
	TriggerClientEvent('VratiTada', -1, broj)
end)

RegisterNetEvent("PokreniUtrku")
AddEventHandler('PokreniUtrku', function(utr, minut, sekund)
	local Minute
	local Sekunde
	minut = minut+1
	if minut >= 60 then
		minut = 0
	end
	Pokreci = 1
	Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1000)
	if Pokreci == 1 then
		Minute = os.date("%M")
		Sekunde = os.date("%S")
		if tonumber(Minute) >= minut and tonumber(Sekunde) == sekund then
		Pokreci = 0
		TriggerClientEvent('StartajUtrku', -1, utr)
		end
	end
	end
	end)
end)

RegisterNetEvent("PosaljiPoruku")
AddEventHandler('PosaljiPoruku', function()
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Utrka', 'Zapocelo je popunjavanje utrke, da se pridruzite upisite /join!', 'CHAR_PLANESITE', 1)
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Utrka', 'Utrka ce poceti za 60 sekundi!', 'CHAR_PLANESITE', 1)
end)

RegisterNetEvent("PosaljiPoruku2")
AddEventHandler('PosaljiPoruku2', function()
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Utrka', 'U utrci jos ima mjesta, ukoliko zelite sudjelovati upisite /join!', 'CHAR_PLANESITE', 1)
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Utrka', 'Utrka ce poceti za 30 sekundi!', 'CHAR_PLANESITE', 1)
end)

RegisterNetEvent("SpremiPokret")
AddEventHandler('SpremiPokret', function(Pokr)
	TriggerClientEvent("VratiPokret", -1, Pokr)
end)

RegisterNetEvent("SpremiKoord")
AddEventHandler('SpremiKoord', function(aRx, aRy, aRz, aRh)
    Rx = aRx
	Ry = aRy
	Rz = aRz
	Rh = aRh
	TriggerClientEvent("VratiKoord", -1, Rx, Ry, Rz, Rh)
end)

RegisterNetEvent("SpremiPomocne")
AddEventHandler('SpremiPomocne', function(Lok, uci, pr)
	TriggerClientEvent("VratiPomocne", -1, Lok, uci, pr)
end)

RegisterNetEvent("SpremiKoord2")
AddEventHandler('SpremiKoord2', function(aRx, aRy, aRz, aRh)
    Rx2 = aRx
	Ry2 = aRy
	Rz2 = aRz
	Rh2 = aRh
	TriggerClientEvent("VratiKoord2", -1, Rx2, Ry2, Rz2, Rh2)
end)

RegisterServerEvent('esx-qalle-races:addTime')
AddEventHandler('esx-qalle-races:addTime', function(timea, race)
    local xPlayer = ESX.GetPlayerFromId(source)

    local name = "none"

    local sql = [[
        SELECT
            firstname, lastname
        FROM
            users
        WHERE
            identifier = @identifier
    ]]

    MySQL.Async.fetchAll(sql, { ["@identifier"] = xPlayer["identifier"] }, function(response)
        if response[1] ~= nil then
            name = response[1]["firstname"] .. " " .. response[1]["lastname"]
        end
    end)

    Citizen.Wait(1000)

    MySQL.Async.fetchAll(
        'SELECT name, time FROM user_races WHERE name = @identifier and race = @race', {['@identifier'] = name, ['@race'] = race},
    function(result)
        if result[1] ~= nil then
            MySQL.Async.execute(
                'UPDATE user_races SET time = @time WHERE name = @identifier and race = @race',
                {
					['@time'] = timea,
                    ['@identifier'] = name,
                    ['@race'] = race
                }
            )
        elseif result[1] == nil then
            MySQL.Async.execute('INSERT INTO user_races (name, time, race) VALUES (@name, @time, @race)',
                {
                    ['@name'] = name,
                    ['@time'] = timea,
                    ['@race'] = race
                }
            )
        end
    end)
end)

ESX.RegisterServerCallback('esx-qalle-races:getScoreboard', function(source, cb, race)
    local identifier = ESX.GetPlayerFromId(source).identifier

    MySQL.Async.fetchAll(
        'SELECT * FROM user_races WHERE race = @race ORDER BY time ASC', {['@race'] = race},
    function(result)

        local Races = {}

        for i=1, #result, 1 do
            table.insert(Races, {
                name   = result[i].name,
                time = result[i].time,
            })
        end

        cb(Races)
    end)  
end)

--PokreniAutoUtrku()
