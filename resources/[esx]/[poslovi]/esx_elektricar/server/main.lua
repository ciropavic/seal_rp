ESX = nil
local Kvarovi = {}
local Pokvareni = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elektricar:platituljanu')
AddEventHandler('elektricar:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'elektricar' then
		xPlayer.addMoney(750)
		TriggerEvent("biznis:StaviUSef", "elektricar", math.ceil(750*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac elektricara, a nije zaposlen kao elektricar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

RegisterServerEvent('elektricar:platituljanu2')
AddEventHandler('elektricar:platituljanu2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'elektricar' then
		xPlayer.addMoney(850)
		TriggerEvent("biznis:StaviUSef", "elektricar", math.ceil(850*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac elektricara, a nije zaposlen kao elektricar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

MySQL.ready(function()
	UcitajKvarove()
end)

function UcitajKvarove()
	Kvarovi = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM elektricar',
      {},
      function(result)
		if result ~= nil then
			for i=1, #result, 1 do
				local data2 = json.decode(result[i].lokacija)
				local vecta = vector3(data2.x, data2.y, data2.z)
				table.insert(Kvarovi, {Ime = result[i].ime, Koord = vecta, Radius = result[i].radius})
			end
		end
      end
    )
end

ESX.RegisterServerCallback('kvarovi:DohvatiKvarove', function(source, cb)
	cb(Kvarovi)
end)

RegisterServerEvent('kvarovi:DodajKvar')
AddEventHandler('kvarovi:DodajKvar', function(coords, radius)
	local xPlayer = ESX.GetPlayerFromId(source)
	local str = "Kvar "..#Kvarovi+1
	table.insert(Kvarovi, {Ime = str, Koord = coords, Radius = radius})
	MySQL.Async.execute('INSERT INTO elektricar (ime, lokacija, radius) VALUES (@ime, @lok, @rad)',{
		['@ime'] = str,
		['@lok'] = json.encode(coords),
		['@rad'] = radius
	})
	TriggerClientEvent("kvarovi:SaljiKvarove", -1, Kvarovi)
	xPlayer.showNotification("Uspjesno dodan kvar "..str.."!")
end)

RegisterServerEvent('kvarovi:Premjesti')
AddEventHandler('kvarovi:Premjesti', function(ime, koord)
	local naso = false
	for i=1, #Kvarovi, 1 do
		if Kvarovi[i] ~= nil and Kvarovi[i].Ime == ime then
			Kvarovi[i].Koord = koord
			naso = true
			break
		end
	end
	TriggerClientEvent("kvarovi:SaljiKvarove", -1, Kvarovi)
	if naso then
		MySQL.Async.execute('UPDATE elektricar SET lokacija = @koord WHERE ime = @ime',{
			['@ime'] = ime,
			['@koord'] = json.encode(koord)
		})
	end
end)

RegisterServerEvent('kvarovi:UrediRadius')
AddEventHandler('kvarovi:UrediRadius', function(ime, radius)
	local naso = false
	for i=1, #Kvarovi, 1 do
		if Kvarovi[i] ~= nil and Kvarovi[i].Ime == ime then
			Kvarovi[i].Radius = radius
			naso = true
			break
		end
	end
	TriggerClientEvent("kvarovi:SaljiKvarove", -1, Kvarovi)
	if naso then
		MySQL.Async.execute('UPDATE elektricar SET radius = @rad WHERE ime = @ime',{
			['@ime'] = ime,
			['@rad'] = radius
		})
	end
end)

RegisterServerEvent('kvarovi:Obrisi')
AddEventHandler('kvarovi:Obrisi', function(ime)
	for i=1, #Kvarovi, 1 do
		if Kvarovi[i].Ime == ime then
			table.remove(Kvarovi, i)
			break
		end
	end
	TriggerClientEvent("kvarovi:SaljiKvarove", -1, Kvarovi)
	MySQL.Async.execute('DELETE FROM elektricar WHERE ime = @ime',{
		['@ime'] = ime
	})
end)

RegisterServerEvent('kvarovi:MakniKvar')
AddEventHandler('kvarovi:MakniKvar', function(ime)
	for i=1, #Pokvareni, 1 do
		if Pokvareni[i].Ime == ime then
			table.remove(Pokvareni, i)
			break
		end
	end
	TriggerClientEvent("kvarovi:SaljiPokvarene", -1, Pokvareni)
end)

function StvoriKvar()
	if #Kvarovi > 0 then
		local rnd = math.random(1, #Kvarovi)
		local naso = false
		for i=1, #Pokvareni, 1 do
			if Pokvareni[i].Ime == Kvarovi[rnd].Ime then
				naso = true
			end
		end
		if not naso then
			table.insert(Pokvareni, {Ime = Kvarovi[rnd].Ime, Koord = Kvarovi[rnd].Koord, Radius = Kvarovi[rnd].Radius})
			TriggerClientEvent("kvarovi:SaljiPokvarene", -1, Pokvareni)
		end
	end
	SetTimeout(3600000, StvoriKvar)
end

SetTimeout(3600000, StvoriKvar)