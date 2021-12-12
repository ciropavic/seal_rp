ESX = nil

local Koord = {}
local Zemljista = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	UcitajZemljista()
end)

function UcitajZemljista()
	Zemljista = {}
	Koord = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM zemljista',
      {},
      function(result)
        for i=1, #result, 1 do
			local korda = nil
			local x,y,z,h = nil
			if result[i].KKoord ~= "{}" then
				local ete = json.decode(result[i].KKoord)
				x,y,z,h = table.unpack(ete)
				korda = vector3(x,y,z)
			end
			local ete2 = json.decode(result[i].MKoord)
			--x,y,z = table.unpack(ete2)
			local kordici = vector3(ete2.x,ete2.y,ete2.z)
			table.insert(Zemljista, {Ime = result[i].Ime, Cijena = result[i].Cijena, Vlasnik = tonumber(result[i].Vlasnik), KKoord = korda, Heading = h, Kuca = result[i].Kuca, MKoord = kordici, KucaID = result[i].KucaID})
			local data = json.decode(result[i].Koord1)
			local data2 = json.decode(result[i].Koord2)
			table.insert(Koord, {Zemljiste = result[i].Ime, Coord = data, Coord2 = data2})
        end
		TriggerClientEvent("zemljista:UpdateKoord", -1, Koord)
		TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
      end
    )
end

RegisterNetEvent('zemljista:ObrisiZemljiste')
AddEventHandler('zemljista:ObrisiZemljiste', function(ime)
	local src = source
	MySQL.Async.execute('DELETE FROM zemljista WHERE Ime = @im', {
		['@im'] = ime
	})
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = nil
			Zemljista[i].Heading = nil
			Zemljista[i].Kuca = nil
			TriggerClientEvent("zemljista:ObrisiKucu", -1, Zemljista[i].Ime)
			if Zemljista[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Zemljista[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Zemljista[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Zemljista[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Zemljista[i].KucaID)
			end
			Zemljista[i].KucaID = nil
			Zemljista[i].Vlasnik = nil
			table.remove(Zemljista, i)
			break
		end
	end
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Zemljiste == ime then
			Koord[i].Zemljiste = nil
			Koord[i] = nil
			table.remove(Koord, i)
		end
	end
	TriggerClientEvent("zemljista:UpdateKoord", -1, Koord)
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno obrisano zemljiste '..ime..'!')
	TriggerClientEvent("zemljista:ObrisiBlip", -1, ime)
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
end)

RegisterNetEvent('zemljista:PremjestiMarker')
AddEventHandler('zemljista:PremjestiMarker', function(ime, coord)
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].MKoord = coord
		end
	end
	MySQL.Async.execute('UPDATE zemljista SET MKoord=@kord WHERE Ime=@ime',{
		['@ime'] = ime,
		['@kord'] = json.encode(coord)
	})
	TriggerClientEvent("zemljista:ObrisiBlip", -1, ime)
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
	TriggerClientEvent('esx:showNotification', source, 'Uspjesno premjesten marker zemljistu '..ime..'!')
	TriggerClientEvent("zemljista:RefreshBlip", -1, ime)
end)

RegisterNetEvent('zemljista:MakniVlasnika')
AddEventHandler('zemljista:MakniVlasnika', function(ime)
	local src = source
	MySQL.Async.execute('UPDATE zemljista SET Kuca = @ku, KKoord = @kor, Vlasnik = @vl, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@vl'] = nil,
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = nil
			Zemljista[i].Heading = nil
			Zemljista[i].Kuca = nil
			TriggerClientEvent("zemljista:ObrisiKucu", -1, Zemljista[i].Ime)
			if Zemljista[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Zemljista[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Zemljista[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Zemljista[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Zemljista[i].KucaID)
			end
			Zemljista[i].KucaID = nil
			Zemljista[i].Vlasnik = nil
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno maknut vlasnik zemljistu '..ime..'!')
	TriggerClientEvent("zemljista:ObrisiBlip", -1, ime)
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
	TriggerClientEvent("zemljista:RefreshBlip", -1, ime)
end)

RegisterNetEvent('zemljista:ObrisiKucu')
AddEventHandler('zemljista:ObrisiKucu', function(ime)
	local src = source
	MySQL.Async.execute('UPDATE zemljista SET Kuca = @ku, KKoord = @kor, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = nil
			Zemljista[i].Heading = nil
			Zemljista[i].Kuca = nil
			TriggerClientEvent("zemljista:ObrisiKucu", -1, Zemljista[i].Ime)
			if Zemljista[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Zemljista[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Zemljista[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Zemljista[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Zemljista[i].KucaID)
			end
			Zemljista[i].KucaID = nil
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno obrisana kuca zemljistu '..ime..'!')
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
end)

RegisterNetEvent('zemljista:NapraviZemljiste')
AddEventHandler('zemljista:NapraviZemljiste', function(cij, coord)
	local str = "Zemljiste "..#Zemljista+1
	MySQL.Async.execute('INSERT INTO zemljista (Ime, Cijena, MKoord) VALUES (@ime, @cijena, @mk)',{
		['@ime'] = str,
		['@cijena'] = cij,
		['@mk'] = json.encode(coord)
	})
	table.insert(Zemljista, {Ime = str, Cijena = cij, Vlasnik = nil, KKoord = nil, Heading = nil, Kuca = nil, MKoord = coord, KucaID = nil})
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
	TriggerClientEvent('esx:showNotification', source, 'Zemljiste '..str..' uspjesno kreirano za $'..cij..'!')
	Wait(4000)
	TriggerClientEvent("zemljista:RefreshBlip", -1, str)
end)

ESX.RegisterServerCallback('zemljista:DohvatiZemljista', function(source, cb)
	local vracaj = {voc = Zemljista, kor = Koord}
	cb(vracaj)
end)

ESX.RegisterServerCallback('zemljista:ImalPara', function(source, cb, br)
	local xPlayer = ESX.GetPlayerFromId(source)
	if br == 1 then
		if xPlayer.getMoney() >= 100000 then
			cb(true)
		else
			cb(false)
		end
	elseif br == 2 then
		if xPlayer.getMoney() >= 30000 then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('zemljista:JelVlasnik', function(source, cb, ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cijena = 0
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			local kucica = false
			local vrata = false
			cijena = Zemljista[i].Cijena
			if Zemljista[i].Kuca ~= nil then
				kucica = true
			end
			if Zemljista[i].KucaID ~= nil then
				vrata = true
			end
			if Zemljista[i].Vlasnik == xPlayer.getID() then
				cb(true, cijena, true, kucica, vrata)
			elseif Zemljista[i].Vlasnik == nil then
				cb(false, cijena, false, kucica, vrata)
			else
				cb(true, cijena, false, kucica, vrata)
			end
		end
	end
end)

ESX.RegisterServerCallback('zemljista:ImalZemljiste', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local naso = 0
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Vlasnik ~= nil and Zemljista[i].Vlasnik == xPlayer.getID() then
			naso = 1
			cb(true)
			break
		end
	end
	if naso == 0 then
		cb(false)
	end
end)

RegisterNetEvent('zemljista:SpremiCoord')
AddEventHandler('zemljista:SpremiCoord', function(ime, coord, br)
	local x,y,z = table.unpack(coord)
	z = z-1
	coord = table.pack(x,y,z)
	if br == 1 then
		MySQL.Async.execute('UPDATE zemljista SET Koord1 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Zemljiste == ime then
				Koord[i].Coord = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Zemljiste = ime, Coord = coord, Coord2 = nil})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x1,y1 su uspjesno spremljene za zemljiste '..ime..'!')
		TriggerClientEvent("zemljista:UpdateKoord", -1, Koord)
	else
		MySQL.Async.execute('UPDATE zemljista SET Koord2 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Zemljiste == ime then
				Koord[i].Coord2 = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Zemljiste = ime, Coord = nil, Coord2 = coord})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x2,y2 su uspjesno spremljene za zemljiste '..ime..'!')
		TriggerClientEvent("zemljista:UpdateKoord", -1, Koord)
	end
end)

RegisterNetEvent('zemljista:PostaviUlaz')
AddEventHandler('zemljista:PostaviUlaz', function(ime, coord)
	local src = source
	MySQL.Async.insert('insert into kuce(prop, door, price, prodaja) values(@pr, @dr, @pri, @prod)', {
		['@pr'] = "nice",
		['@dr'] = json.encode(coord),
		['@pri'] = 1,
		['@prod'] = 1
	}, function(insertid)
		MySQL.Async.execute('UPDATE zemljista SET KucaID = @ku WHERE Ime = @im', {
			['@ku'] = insertid,
			['@im'] = ime
		})
		TriggerEvent("loaf_housing:DodajKucu", insertid, "nice", coord, 1, 1, src)
		for i=1, #Zemljista, 1 do
			if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
				Zemljista[i].KucaID = insertid
				break
			end
		end
	end)
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno ste si stavili ulaz u kucu!')
end)

RegisterNetEvent('zemljista:UrediUlaz')
AddEventHandler('zemljista:UrediUlaz', function(ime, coord)
	local src = source
	local kid = 0
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			kid = Zemljista[i].KucaID
			break
		end
	end
	MySQL.Async.execute('update kuce set door=@dr where ID=@id', {
		['@dr'] = json.encode(coord),
		['@id'] = kid
	}, function(insertid)
		TriggerEvent("loaf_housing:UrediKucu", kid, coord, src)
	end)
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno ste si uredili ulaz u kucu!')
end)

RegisterNetEvent('zemljista:ProdajZemljiste')
AddEventHandler('zemljista:ProdajZemljiste', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('UPDATE zemljista SET Kuca = @ku, KKoord = @kor, Vlasnik = @vl, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@vl'] = nil,
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = nil
			Zemljista[i].Heading = nil
			Zemljista[i].Kuca = nil
			Zemljista[i].Vlasnik = nil
			TriggerClientEvent("zemljista:ObrisiKucu", -1, Zemljista[i].Ime)
			TriggerClientEvent("zemljista:ObrisiBlip", -1, Zemljista[i].Ime)
			MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
				['@id'] = Zemljista[i].KucaID
			})
			MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
            MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Zemljista[i].KucaID})
			TriggerEvent('loaf_housing:ObrisiKucu', Zemljista[i].KucaID)
			Zemljista[i].KucaID = nil
			xPlayer.addMoney(Zemljista[i].Cijena/2)
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Zemljiste uspjesno prodano!')
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
	TriggerClientEvent("zemljista:RefreshBlip", -1, ime)
end)

RegisterNetEvent('zemljista:SrusiKucu')
AddEventHandler('zemljista:SrusiKucu', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('UPDATE zemljista SET Kuca = @ku, KKoord = @kor, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = nil
			Zemljista[i].Heading = nil
			Zemljista[i].Kuca = nil
			TriggerClientEvent("zemljista:ObrisiKucu", -1, Zemljista[i].Ime)
			if Zemljista[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Zemljista[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Zemljista[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Zemljista[i].KucaID)
			end
			Zemljista[i].KucaID = nil
			break
		end
	end
	xPlayer.removeMoney(30000)
	TriggerClientEvent('esx:showNotification', src, 'Kuca uspjesno srusena!')
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
end)

RegisterNetEvent('zemljista:SpremiKucu')
AddEventHandler('zemljista:SpremiKucu', function(ime, coord, head, kuca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local x,y,z = table.unpack(coord)
	local coorde = table.pack(x,y,z,head)
	MySQL.Async.execute('UPDATE zemljista SET Kuca = @ku, KKoord = @kor WHERE Ime = @im', {
		['@ku'] = kuca,
		['@kor'] = json.encode(coorde),
		['@im'] = ime
	})
	local kordu = vector3(x,y,z)
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = kordu
			Zemljista[i].Heading = head
			Zemljista[i].Kuca = kuca
		end
	end
	xPlayer.removeMoney(100000)
	TriggerClientEvent('esx:showNotification', source, 'Lokacija kuce uspjesno spremljena!')
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
end)

RegisterNetEvent('zemljista:UrediKucu')
AddEventHandler('zemljista:UrediKucu', function(ime, coord, head)
	local x,y,z = table.unpack(coord)
	local coorde = table.pack(x,y,z,head)
	MySQL.Async.execute('UPDATE zemljista SET KKoord = @kor WHERE Ime = @im', {
		['@kor'] = json.encode(coorde),
		['@im'] = ime
	})
	local kordu = vector3(x,y,z)
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			Zemljista[i].KKoord = kordu
			Zemljista[i].Heading = head
		end
	end
	TriggerClientEvent('esx:showNotification', source, 'Lokacija kuce uspjesno promjenjena!')
	TriggerClientEvent("zemljista:NovaLokacija", -1, ime, kordu, head)
	TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
end)

RegisterNetEvent('zemljista:Kupi')
AddEventHandler('zemljista:Kupi', function(ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local kupio = false
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Ime == ime then
			if xPlayer.getMoney() >= tonumber(Zemljista[i].Cijena) then
				xPlayer.removeMoney(Zemljista[i].Cijena)
				Zemljista[i].Vlasnik = xPlayer.identifier
				kupio = true
				MySQL.Async.execute('UPDATE zemljista SET Vlasnik = @vl WHERE Ime = @im', {
					['@vl'] = xPlayer.getID(),
					['@im'] = ime
				})
				xPlayer.showNotification("Uspjesno ste kupili zemljiste za $"..Zemljista[i].Cijena.."!")
				TriggerClientEvent("zemljista:ObrisiBlip", -1, ime)
				TriggerClientEvent("zemljista:UpdateZemljista", -1, Zemljista)
				TriggerClientEvent("zemljista:RefreshBlip", -1, ime)
			end
		end
	end
	if not kupio then
		xPlayer.showNotification("Nemate dovoljno novca za ovo zemljiste!")
	end
end)
