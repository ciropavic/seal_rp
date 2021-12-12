ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Biznisi = {}
local Sati = {}

MySQL.ready(function()
	UcitajBiznise()
end)

function UcitajBiznise()
	Biznisi = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM biznisi',
      {},
      function(result)
        for i=1, #result, 1 do
			local data2 = json.decode(result[i].Koord)
			if result[i].Vlasnik == nil then
				table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Vlasnik = nil, Posao = result[i].Posao, Kupljen = false, Sef = result[i].Sef, VlasnikIme = "Nema", Coord = data2, Tjedan = result[i].Tjedan})
			else
				GetRPName2(result[i].Vlasnik, function(Firstname, Lastname)
					local im = Firstname.." "..Lastname
					table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Vlasnik = tonumber(result[i].Vlasnik), Posao = result[i].Posao, Kupljen = true, Sef = result[i].Sef, VlasnikIme = im, Coord = data2, Tjedan = result[i].Tjedan})
				end)
			end
			local data3 = json.decode(result[i].Sati)
			if data3 ~= nil then
				for b=1, #data3 do
					table.insert(Sati, {Ime = data3[b].Ime, Identifier = data3[b].Identifier, Ture = data3[b].Ture, Posao = data3[b].Posao})
				end
			end
        end
      end
    )
end

function UcitajSate()
	Sati = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM biznisi',
      {},
      function(result)
        for i=1, #result, 1 do
			local data3 = json.decode(result[i].Sati)
			if data3 ~= nil then
				for b=1, #data3 do
					table.insert(Sati, {Ime = data3[b].Ime, Identifier = data3[b].Identifier, Ture = data3[b].Ture, Posao = data3[b].Posao})
				end
			end
        end
      end
    )
end

ESX.RegisterServerCallback('biznis:JelVlasnik', function(source, cb, ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = false
	print(ime)
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime and Biznisi[i].Vlasnik ~= nil then
			if Biznisi[i].Vlasnik == xPlayer.getID() then
				naso = true
				cb(true)
			end
		end
	end
	if not naso then
		cb(false)
	end
end)

ESX.RegisterServerCallback('biznis:DohvatiBiznise', function(source, cb)
	local vracaj = {biz = Biznisi}
	cb(vracaj)
end)

RegisterNetEvent('biznis:NapraviBiznis')
AddEventHandler('biznis:NapraviBiznis', function(ime,label)
	MySQL.Async.execute('INSERT INTO biznisi (Ime, Label) VALUES (@ime, @lab)',{
		['@ime'] = ime,
		['@lab'] = label
	})
	table.insert(Biznisi, {Ime = ime, Label = label, Posao = "Nema", Kupljen = false, Sef = 0, VlasnikIme = "Nema", Tjedan = 0})
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
end)

function GetRPName(ident, data)
	local Identifier = ident

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

function GetRPName2(ident, data)
	local Identifier = ident

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE ID = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

RegisterNetEvent('biznis:PostaviKoord')
AddEventHandler('biznis:PostaviKoord', function(ime, koord)
	local x,y,z = table.unpack(koord)
	z = z-1
	local cordara = {}
	table.insert(cordara, x)
	table.insert(cordara, y)
	table.insert(cordara, z)
	MySQL.Async.execute('UPDATE biznisi SET Koord = @kor WHERE Ime = @im', {
		['@kor'] = json.encode(cordara),
		['@im'] = ime
	})
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			Biznisi[i].Coord = cordara
		end
	end
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
	TriggerClientEvent("biznis:KreirajBlip", -1, cordara, ime)
end)

RegisterNetEvent('biznis:ObrisiBiznis')
AddEventHandler('biznis:ObrisiBiznis', function(ime)
	local src = source
	MySQL.Async.execute('DELETE FROM biznisi WHERE Ime = @ime',{
		['@ime'] = ime
	})
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			table.remove(Biznisi, i)
		end
	end
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
	TriggerClientEvent("biznis:UpdateBlip", -1, ime)
	TriggerClientEvent('esx:showNotification', src, "Obrisali ste biznis "..ime.."!")
end)

RegisterNetEvent('biznis:PostaviVlasnika')
AddEventHandler('biznis:PostaviVlasnika', function(ime, id)
	local src = source
	if tonumber(id) == 0 then
		MySQL.Async.execute('UPDATE biznisi SET Vlasnik = null WHERE Ime = @im', {
			['@im'] = ime
		})
		for i=1, #Biznisi, 1 do
			if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
				Biznisi[i].Kupljen = false
				Biznisi[i].VlasnikIme = "Nema"
				Biznisi[i].Vlasnik = nil
				TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
				TriggerClientEvent("biznis:UpdateBlip", -1, ime)
				break
			end
		end
	else
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer ~= nil then
			MySQL.Async.execute('UPDATE biznisi SET Vlasnik = @vl WHERE Ime = @im', {
				['@vl'] = xPlayer.getID(),
				['@im'] = ime
			})
			for i=1, #Biznisi, 1 do
				if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
					Biznisi[i].Kupljen = true
					Biznisi[i].Vlasnik = xPlayer.getID()
					GetRPName(xPlayer.identifier, function(Firstname, Lastname)
						local im = Firstname.." "..Lastname
						Biznisi[i].VlasnikIme = im
						TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
						TriggerClientEvent("biznis:UpdateBlip", -1, ime)
						TriggerClientEvent('esx:showNotification', src, "Postavili ste vlasnika igracu "..GetPlayerName(id).."["..id.."]!")
					end)
					break
				end
			end
		else
			TriggerClientEvent('esx:showNotification', src, "Igrac nije online!")
		end
	end
end)

RegisterNetEvent('biznis:DodajTuru')
AddEventHandler('biznis:DodajTuru', function(posao)
	local _source = source
	local ime = GetPlayerName(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Sati, 1 do
		if Sati[i] ~= nil and Sati[i].Identifier == xPlayer.identifier and Sati[i].Posao == posao then
			naso = true
			Sati[i].Ture = Sati[i].Ture+1
			break
		end
	end
	if not naso then
		table.insert(Sati, {Ime = ime, Identifier = xPlayer.identifier, Ture = 1, Posao = posao})
	end
	local Temp = {}
	for i=1, #Sati, 1 do
		if Sati[i] ~= nil and Sati[i].Posao == posao then
			table.insert(Temp, {Ime = Sati[i].Ime, Identifier = Sati[i].Identifier, Ture = Sati[i].Ture, Posao = Sati[i].Posao})
		end
	end
	MySQL.Async.execute('UPDATE biznisi SET Sati = @sa WHERE Posao = @im', {
		['@sa'] = json.encode(Temp),
		['@im'] = posao
	})
end)

ESX.RegisterServerCallback('biznis:DohvatiRadnike', function(source, cb)
	cb(Sati)
end)

RegisterNetEvent('biznis:PostaviPosao')
AddEventHandler('biznis:PostaviPosao', function(ime, posao)
	MySQL.Async.execute('UPDATE biznisi SET Posao = @po WHERE Ime = @im', {
		['@po'] = posao,
		['@im'] = ime
	})
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			Biznisi[i].Posao = posao
		end
	end
end)

RegisterNetEvent('biznis:DajStanje')
AddEventHandler('biznis:DajStanje', function(ime)
	local src = source
	MySQL.Async.fetchAll(
      'SELECT Sef, Tjedan FROM biznisi WHERE Ime = @im',
      { ['@im'] = ime },
      function(result)
        for i=1, #result, 1 do
			TriggerClientEvent('esx:showNotification', src, "Stanje na racunu firme je $"..result[i].Sef.."\nOvaj tjedan ste zaradili $"..result[i].Tjedan)
        end
      end
    )
end)

RegisterNetEvent('biznis:UzmiIzSefa')
AddEventHandler('biznis:UzmiIzSefa', function(ime, cifra)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			if Biznisi[i].Sef >= cifra then
				Biznisi[i].Sef = Biznisi[i].Sef-cifra
				MySQL.Async.execute('UPDATE biznisi SET Sef = @se WHERE Ime = @im', {
					['@se'] = Biznisi[i].Sef,
					['@im'] = ime
				})
				xPlayer.addMoney(cifra)
				TriggerClientEvent('esx:showNotification', src, "Podigli ste $"..cifra.." sa racuna firme!")
				break
			end
		end
	end
end)

RegisterNetEvent('biznis:StaviUSef')
AddEventHandler('biznis:StaviUSef', function(posao, cifra)
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Posao == posao then
			Biznisi[i].Sef = Biznisi[i].Sef+cifra
			Biznisi[i].Tjedan = Biznisi[i].Tjedan+cifra
			break
		end
	end
end)

function SpremiPare()
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil then
			MySQL.Async.execute('UPDATE biznisi SET Sef = @se, Tjedan = @tj WHERE Posao = @im', {
				['@se'] = Biznisi[i].Sef,
				['@tj'] = Biznisi[i].Tjedan,
				['@im'] = Biznisi[i].Posao
			})
		end
		Wait(100)
	end
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
	SetTimeout(300000, SpremiPare)
end

function BrisiZaposlenike(d, h, m)
	if d == 2 then
		MySQL.Async.execute('UPDATE biznisi SET Sati = @st, Tjedan = @tj', {
			['@st'] = "{}",
			['@tj'] = 0
		}, function()
			UcitajSate()
			for i=1, #Biznisi, 1 do
				if Biznisi[i] ~= nil then
					Biznisi[i].Tjedan = 0
				end
			end
			TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
		end)
	end
end

SetTimeout(300000, SpremiPare)

TriggerEvent('cron:runAt', 0, 0, BrisiZaposlenike)