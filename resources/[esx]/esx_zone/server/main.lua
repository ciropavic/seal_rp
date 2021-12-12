ESX = nil

local Zone = {}
local Mafije = {}
local Zauzeta = {}
local BrZone = 1
local Vrijeme = 0
local Min = 0
local Sat = 0
local Zauzimanje = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	UcitajZone()
end)

RegisterServerEvent('zone:DodajZonu')
AddEventHandler('zone:DodajZonu', function(koord, vel, rot)
	local str = "zona"..BrZone
	BrZone = BrZone+1
	table.insert(Zone, {ID = nil, Ime = str, Koord = koord, Velicina = vel, Rotacija = rot, Boja = 0, Vlasnik = nil, Label = nil, Vrijeme = 0, Vrijednost = 30000})
	TriggerClientEvent("zone:SpawnZonu", -1, str, koord, vel, rot)
	MySQL.Async.fetchScalar('SELECT idzone FROM zpostavke', {}, function(result)
		if result == nil then
			MySQL.Async.execute('INSERT INTO zpostavke (idzone, mafije, vrijeme) VALUES (@id, "{}", 1)',{
				['@id'] = BrZone
			})
		else
			MySQL.Async.execute('UPDATE zpostavke SET idzone = @id',{
				['@id'] = BrZone
			})
		end
    end)
	MySQL.Async.execute('INSERT INTO zone (ime, koord, velicina, rotacija) VALUES (@ime, @koord, @vel, @rot)',{
		['@ime'] = str,
		['@koord'] = json.encode(koord),
		['@vel'] = vel,
		['@rot'] = rot
	})
end)

RegisterServerEvent('zone:DodajMafiju')
AddEventHandler('zone:DodajMafiju', function(ime, boja)
	table.insert(Mafije, {Ime = ime, Boja = boja})
	TriggerClientEvent("zone:DodajMafiju", -1, ime, boja)
	MySQL.Async.fetchScalar('SELECT idzone FROM zpostavke', {}, function(result)
		if result == nil then
			MySQL.Async.execute('INSERT INTO zpostavke (idzone, mafije, vrijeme) VALUES (1, @maf, 1)',{
				['@maf'] = json.encode(Mafije)
			})
		else
			MySQL.Async.execute('UPDATE zpostavke SET mafije = @maf',{
				['@maf'] = json.encode(Mafije)
			})
		end
    end)
end)

RegisterServerEvent('zone:UrediVrijeme')
AddEventHandler('zone:UrediVrijeme', function(br)
	MySQL.Async.fetchScalar('SELECT idzone FROM zpostavke', {}, function(result)
		if result == nil then
			MySQL.Async.execute('INSERT INTO zpostavke (idzone, mafije, vrijeme) VALUES (1, "{}", @vr)',{
				['@vr'] = br
			})
		else
			MySQL.Async.execute('UPDATE zpostavke SET vrijeme = @vr',{
				['@vr'] = br
			})
		end
		Vrijeme = br
    end)
end)

RegisterServerEvent('zone:UrediNovacVrijeme')
AddEventHandler('zone:UrediNovacVrijeme', function(sat, minuta)
	MySQL.Async.fetchScalar('SELECT idzone FROM zpostavke', {}, function(result)
		if result == nil then
			MySQL.Async.execute('INSERT INTO zpostavke (idzone, mafije, vrijeme, sat, minuta) VALUES (1, "{}", 1, @sat, @min)',{
				['@sat'] = sat,
				['@min'] = minuta
			})
		else
			MySQL.Async.execute('UPDATE zpostavke SET sat = @sat, minuta = @min',{
				['@sat'] = sat,
				['@min'] = minuta
			})
		end
    end)
end)

RegisterServerEvent('zone:UrediOsvajanje')
AddEventHandler('zone:UrediOsvajanje', function(br)
	MySQL.Async.fetchScalar('SELECT idzone FROM zpostavke', {}, function(result)
		if result == nil then
			MySQL.Async.execute('INSERT INTO zpostavke (idzone, mafije, vrijeme, sat, minuta, zauzimanje) VALUES (1, "{}", 1, 0, 0, @br)',{
				['@br'] = br
			})
		else
			MySQL.Async.execute('UPDATE zpostavke SET zauzimanje = @br',{
				['@br'] = br
			})
		end
    end)
	Zauzimanje = br
	TriggerClientEvent("zone:VratiOsvajanje", -1, br)
end)

RegisterServerEvent('zone:UrediVrijednost')
AddEventHandler('zone:UrediVrijednost', function(ime, br)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Vrijednost = br
				break
			end
		end
	end
	MySQL.Async.execute('UPDATE zone SET vrijednost = @vr WHERE ime = @ime',{
		['@ime'] = ime,
		['@vr'] = br
	})
	TriggerClientEvent("zone:UpdateVrijednost", ime, br)
end)

RegisterServerEvent('zone:SpremiBoju')
AddEventHandler('zone:SpremiBoju', function(ime, br)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Boja = br
				break
			end
		end
	end
	MySQL.Async.execute('UPDATE zone SET boja = @vr WHERE ime = @ime',{
		['@ime'] = ime,
		['@vr'] = br
	})
end)

RegisterServerEvent('zone:ZapocniZauzimanje')
AddEventHandler('zone:ZapocniZauzimanje', function(ime)
	local src = source
	for i=1, #Zone, 1 do
		if Zone[i].Ime == ime then
			table.insert(Zauzeta, {Ime = ime, ID = src})
			TriggerClientEvent("zone:NapadnutaZona", -1, ime, true, 0)
			break
		end
	end
end)

ESX.RegisterServerCallback('zone:JelZauzeta', function(source, cb, ime)
	local naso = false
	for i=1, #Zauzeta, 1 do
		if Zauzeta[i].Ime == ime then
			naso = true
			cb(true)
			break
		end
	end
	if not naso then
		cb(false)
	end
end)

ESX.RegisterServerCallback('zone:DajOsvajanje', function(source, cb)
	cb(Zauzimanje)
end)

RegisterServerEvent('zone:ZavrsiZauzimanje')
AddEventHandler('zone:ZavrsiZauzimanje', function(ime)
	for i=1, #Zauzeta, 1 do
		if Zauzeta[i].Ime == ime then
			table.remove(Zauzeta, i)
			TriggerClientEvent("zone:NapadnutaZona", -1, ime, false, Vrijeme)
			break
		end
	end
	for i=1, #Zone, 1 do
		if Zone[i].Ime == ime then
			Zone[i].Vrijeme = Vrijeme
			break
		end
	end
	MySQL.Async.execute('UPDATE zone SET vrijeme = @vr WHERE ime = @ime',{
		['@ime'] = ime,
		['@vr'] = Vrijeme
	})
end)

AddEventHandler('playerDropped', function()
	for i=1, #Zauzeta, 1 do
		if Zauzeta[i].ID == source then
			TriggerClientEvent("zone:NapadnutaZona", -1, Zauzeta[i].Ime, false, Vrijeme)
			table.remove(Zauzeta, i)
			break
		end
	end
end)

RegisterServerEvent('zone:UpdateBoju')
AddEventHandler('zone:UpdateBoju', function(ime, boja, maf, label)
	for i=1, #Zone, 1 do
		if Zone[i].Ime == ime then
			Zone[i].Boja = boja
			Zone[i].Vlasnik = maf
			Zone[i].Label = label
			break
		end
	end
	TriggerClientEvent("zone:UpdateBoju", -1, ime, boja, maf, label)
	MySQL.Async.execute('UPDATE zone SET boja = @boja, vlasnik = @maf, label = @lab WHERE ime = @ime',{
		['@ime'] = ime,
		['@boja'] = boja,
		['@maf'] = maf,
		['@lab'] = label
	})
end)

RegisterServerEvent('zone:Premjesti')
AddEventHandler('zone:Premjesti', function(ime, koord, rot)
	for i=1, #Zone, 1 do
		if Zone[i].Ime == ime then
			Zone[i].Koord = koord
			Zone[i].Rotacija = rot
			break
		end
	end
	TriggerClientEvent("zone:UpdateZonu", -1, ime, koord, rot)
	MySQL.Async.execute('UPDATE zone SET koord = @koord, rotacija = @rot WHERE ime = @ime',{
		['@ime'] = ime,
		['@koord'] = json.encode(koord),
		['@rot'] = rot
	})
end)

RegisterServerEvent('zone:Obrisi')
AddEventHandler('zone:Obrisi', function(ime)
	for i=1, #Zone, 1 do
		if Zone[i].Ime == ime then
			table.remove(Zone, i)
			break
		end
	end
	TriggerClientEvent("zone:ObrisiZonu", -1, ime)
	MySQL.Async.execute('DELETE FROM zone WHERE ime = @ime',{
		['@ime'] = ime
	})
end)

RegisterServerEvent('zone:ObrisiMafiju')
AddEventHandler('zone:ObrisiMafiju', function(ime)
	for i=1, #Mafije, 1 do
		if Mafije[i].Ime == ime then
			table.remove(Mafije, i)
			break
		end
	end
	TriggerClientEvent("zone:ObrisiMafiju", -1, ime)
	MySQL.Async.execute('UPDATE zpostavke SET mafije = @maf',{
		['@maf'] = json.encode(Mafije)
	})
end)

function UcitajZone()
	Zone = {}
	Mafije = {}
	local postavke = MySQL.Sync.fetchAll('SELECT * FROM zpostavke', {})
    for i=1, #postavke, 1 do
		BrZone = postavke[i].idzone
		Vrijeme = postavke[i].vrijeme
		Sat = postavke[i].sat
		Min = postavke[i].minuta
		Zauzimanje = postavke[i].zauzimanje
		TriggerClientEvent("zone:VratiOsvajanje", -1, Zauzimanje)
		local data = json.decode(postavke[i].mafije)
		if data ~= nil then
			for a=1, #data do
				table.insert(Mafije, {Ime = data[a].Ime, Boja = data[a].Boja})
				TriggerClientEvent("zone:DodajMafiju", -1, data[a].Ime)
			end
		end
    end
	MySQL.Async.fetchAll(
      'SELECT * FROM zone',
      {},
      function(result)
        for i=1, #result, 1 do
			local tabla = json.decode(result[i].koord)
			local a = vector3(tabla.x, tabla.y, tabla.z)
			table.insert(Zone, {ID = nil, Ime = result[i].ime, Koord = a, Velicina = result[i].velicina, Rotacija = result[i].rotacija, Boja = result[i].boja, Vlasnik = result[i].vlasnik, Label = result[i].label, Vrijeme = result[i].vrijeme, Vrijednost = result[i].vrijednost})
			TriggerClientEvent("zone:SpawnZonu", -1, result[i].ime, a, result[i].velicina, result[i].rotacija)
        end
      end
    )
	TriggerEvent('cron:runAt', Sat, Min, DajPare)
end

function DajPare(d, h, m)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil and Zone[i].Vlasnik ~= nil then
			local societyAccount = nil
			local sime = "society_"..Zone[i].Vlasnik
			TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
				societyAccount = account
			end)
			societyAccount.addMoney(Zone[i].Vrijednost)
			societyAccount.save()
		end
	end
end

ESX.RegisterServerCallback('zone:DohvatiZone', function(source, cb)
	local vracaj = {zone = Zone, maf = Mafije}
	cb(vracaj)
end)

local brojcic = 0
function Odbrojavaj()
	brojcic = brojcic+1
	if brojcic == 6 then
		brojcic = 0
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil and Zone[i].Vrijeme > 0 then
				Zone[i].Vrijeme = Zone[i].Vrijeme-1
				MySQL.Async.execute('UPDATE zone SET vrijeme = @vr WHERE ime = @ime',{
					['@ime'] = Zone[i].Ime,
					['@vr'] = Zone[i].Vrijeme
				})
				TriggerClientEvent("zone:SmanjiVrijeme", -1, Zone[i].Ime, Zone[i].Vrijeme)
			end
			Wait(100)
		end
	end
	SetTimeout(600000, Odbrojavaj)
end

SetTimeout(600000, Odbrojavaj)