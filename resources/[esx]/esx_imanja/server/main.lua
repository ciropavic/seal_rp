ESX = nil

local Koord = {}
local Imanja = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	UcitajImanja()
end)

function UcitajImanja()
	Imanja = {}
	Koord = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM imanja',
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
			table.insert(Imanja, {Ime = result[i].Ime, Cijena = result[i].Cijena, Vlasnik = tonumber(result[i].Vlasnik), KKoord = korda, Heading = h, Kuca = result[i].Kuca, MKoord = kordici, KucaID = result[i].KucaID})
			local data = json.decode(result[i].Koord)
			local tabl = {}
			for i=1, #data, 1 do
				table.insert(tabl, vector2(data[i].x, data[i].y))
			end
			--local data2 = json.decode(result[i].Koord2)
			table.insert(Koord, {Imanje = result[i].Ime, Coord = tabl})
        end
		TriggerClientEvent("imanja:UpdateKoord", -1, Koord)
		TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
      end
    )
end

RegisterNetEvent('imanja:ObrisiImanje')
AddEventHandler('imanja:ObrisiImanje', function(ime)
	local src = source
	MySQL.Async.execute('DELETE FROM imanja WHERE Ime = @im', {
		['@im'] = ime
	})
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = nil
			Imanja[i].Heading = nil
			Imanja[i].Kuca = nil
			TriggerClientEvent("imanja:ObrisiKucu", -1, Imanja[i].Ime)
			if Imanja[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Imanja[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Imanja[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Imanja[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Imanja[i].KucaID)
			end
			Imanja[i].KucaID = nil
			Imanja[i].Vlasnik = nil
			table.remove(Imanja, i)
			break
		end
	end
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Imanje == ime then
			Koord[i].Imanje = nil
			Koord[i] = nil
			table.remove(Koord, i)
		end
	end
	TriggerClientEvent("imanja:UpdateKoord", -1, Koord)
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno obrisano imanje '..ime..'!')
	TriggerClientEvent("imanja:ObrisiBlip", -1, ime)
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
end)

RegisterNetEvent('imanja:PremjestiMarker')
AddEventHandler('imanja:PremjestiMarker', function(ime, coord)
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].MKoord = coord
		end
	end
	MySQL.Async.execute('UPDATE imanja SET MKoord=@kord WHERE Ime=@ime',{
		['@ime'] = ime,
		['@kord'] = json.encode(coord)
	})
	TriggerClientEvent("imanja:ObrisiBlip", -1, ime)
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
	TriggerClientEvent('esx:showNotification', source, 'Uspjesno premjesten marker zemljistu '..ime..'!')
	TriggerClientEvent("imanja:RefreshBlip", -1, ime)
end)

RegisterNetEvent('imanja:MakniVlasnika')
AddEventHandler('imanja:MakniVlasnika', function(ime)
	local src = source
	MySQL.Async.execute('UPDATE imanja SET Kuca = @ku, KKoord = @kor, Vlasnik = @vl, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@vl'] = nil,
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = nil
			Imanja[i].Heading = nil
			Imanja[i].Kuca = nil
			TriggerClientEvent("imanja:ObrisiKucu", -1, Imanja[i].Ime)
			if Imanja[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Imanja[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Imanja[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Imanja[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Imanja[i].KucaID)
			end
			Imanja[i].KucaID = nil
			Imanja[i].Vlasnik = nil
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno maknut vlasnik zemljistu '..ime..'!')
	TriggerClientEvent("imanja:ObrisiBlip", -1, ime)
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
	TriggerClientEvent("imanja:RefreshBlip", -1, ime)
end)

RegisterNetEvent('imanja:ObrisiKucu')
AddEventHandler('imanja:ObrisiKucu', function(ime)
	local src = source
	MySQL.Async.execute('UPDATE imanja SET Kuca = @ku, KKoord = @kor, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = nil
			Imanja[i].Heading = nil
			Imanja[i].Kuca = nil
			TriggerClientEvent("imanja:ObrisiKucu", -1, Imanja[i].Ime)
			if Imanja[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Imanja[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE ID=@identifier", {['@identifier'] = Imanja[i].Vlasnik, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Imanja[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Imanja[i].KucaID)
			end
			Imanja[i].KucaID = nil
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno obrisana kuca zemljistu '..ime..'!')
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
end)

RegisterNetEvent('imanja:NapraviImanje')
AddEventHandler('imanja:NapraviImanje', function(cij, coord)
	local str = "Imanje "..#Imanja+1
	MySQL.Async.execute('INSERT INTO imanja (Ime, Cijena, MKoord) VALUES (@ime, @cijena, @mk)',{
		['@ime'] = str,
		['@cijena'] = cij,
		['@mk'] = json.encode(coord)
	})
	table.insert(Imanja, {Ime = str, Cijena = cij, Vlasnik = nil, KKoord = nil, Heading = nil, Kuca = nil, MKoord = coord, KucaID = nil})
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
	TriggerClientEvent('esx:showNotification', source, 'Imanje '..str..' uspjesno kreirano za $'..cij..'!')
	Wait(4000)
	TriggerClientEvent("imanja:RefreshBlip", -1, str)
end)

ESX.RegisterServerCallback('imanja:DohvatiImanja', function(source, cb)
	local vracaj = {voc = Imanja, kor = Koord}
	cb(vracaj)
end)

ESX.RegisterServerCallback('imanja:ImalPara', function(source, cb, br)
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

ESX.RegisterServerCallback('imanja:JelVlasnik', function(source, cb, ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cijena = 0
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			local kucica = false
			local vrata = false
			cijena = Imanja[i].Cijena
			if Imanja[i].Kuca ~= nil then
				kucica = true
			end
			if Imanja[i].KucaID ~= nil then
				vrata = true
			end
			if Imanja[i].Vlasnik == xPlayer.getID() then
				cb(true, cijena, true, kucica, vrata)
			elseif Imanja[i].Vlasnik == nil then
				cb(false, cijena, false, kucica, vrata)
			else
				cb(true, cijena, false, kucica, vrata)
			end
		end
	end
end)

ESX.RegisterServerCallback('imanja:ImalImanje', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local naso = 0
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Vlasnik ~= nil and Imanja[i].Vlasnik == xPlayer.getID() then
			naso = 1
			cb(true)
			break
		end
	end
	if naso == 0 then
		cb(false)
	end
end)

RegisterNetEvent('imanja:SpremiCoord')
AddEventHandler('imanja:SpremiCoord', function(ime, coord, br)
	if br == 1 then
		MySQL.Async.execute('UPDATE imanja SET Koord = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Imanje == ime then
				Koord[i].Coord = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Imanje = ime, Coord = coord})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate su uspjesno spremljene za imanje '..ime..'!')
		TriggerClientEvent("imanja:UpdateKoord", -1, Koord)
	else
		MySQL.Async.execute('UPDATE imanja SET Koord2 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Imanje == ime then
				Koord[i].Coord2 = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Imanje = ime, Coord = nil, Coord2 = coord})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x2,y2 su uspjesno spremljene za imanje '..ime..'!')
		TriggerClientEvent("imanja:UpdateKoord", -1, Koord)
	end
end)

RegisterNetEvent('imanja:PostaviUlaz')
AddEventHandler('imanja:PostaviUlaz', function(ime, coord)
	local src = source
	MySQL.Async.insert('insert into kuce(prop, door, price, prodaja) values(@pr, @dr, @pri, @prod)', {
		['@pr'] = "nice",
		['@dr'] = json.encode(coord),
		['@pri'] = 1,
		['@prod'] = 1
	}, function(insertid)
		MySQL.Async.execute('UPDATE imanja SET KucaID = @ku WHERE Ime = @im', {
			['@ku'] = insertid,
			['@im'] = ime
		})
		TriggerEvent("loaf_housing:DodajKucu", insertid, "nice", coord, 1, 1, src)
		for i=1, #Imanja, 1 do
			if Imanja[i] ~= nil and Imanja[i].Ime == ime then
				Imanja[i].KucaID = insertid
				break
			end
		end
	end)
	TriggerClientEvent('esx:showNotification', src, 'Uspjesno ste si stavili ulaz u kucu!')
end)

RegisterNetEvent('imanja:UrediUlaz')
AddEventHandler('imanja:UrediUlaz', function(ime, coord)
	local src = source
	local kid = 0
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			kid = Imanja[i].KucaID
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

RegisterNetEvent('imanja:ProdajImanje')
AddEventHandler('imanja:ProdajImanje', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('UPDATE imanja SET Kuca = @ku, KKoord = @kor, Vlasnik = @vl, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@vl'] = nil,
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = nil
			Imanja[i].Heading = nil
			Imanja[i].Kuca = nil
			Imanja[i].Vlasnik = nil
			TriggerClientEvent("imanja:ObrisiKucu", -1, Imanja[i].Ime)
			TriggerClientEvent("imanja:ObrisiBlip", -1, Imanja[i].Ime)
			MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
				['@id'] = Imanja[i].KucaID
			})
			MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
            MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Imanja[i].KucaID})
			TriggerEvent('loaf_housing:ObrisiKucu', Imanja[i].KucaID)
			Imanja[i].KucaID = nil
			xPlayer.addMoney(Imanja[i].Cijena/2)
			break
		end
	end
	TriggerClientEvent('esx:showNotification', src, 'Imanje uspjesno prodano!')
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
	TriggerClientEvent("imanja:RefreshBlip", -1, ime)
end)

RegisterNetEvent('imanja:SrusiKucu')
AddEventHandler('imanja:SrusiKucu', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('UPDATE imanja SET Kuca = @ku, KKoord = @kor, KucaID = @ku WHERE Ime = @im', {
		['@ku'] = nil,
		['@kor'] = "{}",
		['@ku'] = nil,
		['@im'] = ime
	})
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = nil
			Imanja[i].Heading = nil
			Imanja[i].Kuca = nil
			TriggerClientEvent("imanja:ObrisiKucu", -1, Imanja[i].Ime)
			if Imanja[i].KucaID ~= nil then
				MySQL.Async.execute('DELETE FROM kuce WHERE ID = @id', {
					['@id'] = Imanja[i].KucaID
				})
				MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
				MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = Imanja[i].KucaID})
				TriggerEvent('loaf_housing:ObrisiKucu', Imanja[i].KucaID)
			end
			Imanja[i].KucaID = nil
			break
		end
	end
	xPlayer.removeMoney(30000)
	TriggerClientEvent('esx:showNotification', src, 'Kuca uspjesno srusena!')
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
end)

RegisterNetEvent('imanja:SpremiKucu')
AddEventHandler('imanja:SpremiKucu', function(ime, coord, head, kuca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local x,y,z = table.unpack(coord)
	local coorde = table.pack(x,y,z,head)
	MySQL.Async.execute('UPDATE imanja SET Kuca = @ku, KKoord = @kor WHERE Ime = @im', {
		['@ku'] = kuca,
		['@kor'] = json.encode(coorde),
		['@im'] = ime
	})
	local kordu = vector3(x,y,z)
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = kordu
			Imanja[i].Heading = head
			Imanja[i].Kuca = kuca
		end
	end
	xPlayer.removeMoney(100000)
	TriggerClientEvent('esx:showNotification', source, 'Lokacija kuce uspjesno spremljena!')
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
end)

RegisterNetEvent('imanja:UrediKucu')
AddEventHandler('imanja:UrediKucu', function(ime, coord, head)
	local x,y,z = table.unpack(coord)
	local coorde = table.pack(x,y,z,head)
	MySQL.Async.execute('UPDATE imanja SET KKoord = @kor WHERE Ime = @im', {
		['@kor'] = json.encode(coorde),
		['@im'] = ime
	})
	local kordu = vector3(x,y,z)
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			Imanja[i].KKoord = kordu
			Imanja[i].Heading = head
		end
	end
	TriggerClientEvent('esx:showNotification', source, 'Lokacija kuce uspjesno promjenjena!')
	TriggerClientEvent("imanja:NovaLokacija", -1, ime, kordu, head)
	TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
end)

RegisterNetEvent('imanja:Kupi')
AddEventHandler('imanja:Kupi', function(ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local kupio = false
	for i=1, #Imanja, 1 do
		if Imanja[i] ~= nil and Imanja[i].Ime == ime then
			if xPlayer.getMoney() >= tonumber(Imanja[i].Cijena) then
				xPlayer.removeMoney(Imanja[i].Cijena)
				Imanja[i].Vlasnik = xPlayer.getID()
				kupio = true
				MySQL.Async.execute('UPDATE imanja SET Vlasnik = @vl WHERE Ime = @im', {
					['@vl'] = xPlayer.getID(),
					['@im'] = ime
				})
				xPlayer.showNotification("Uspjesno ste kupili imanje za $"..Imanja[i].Cijena.."!")
				TriggerClientEvent("imanja:ObrisiBlip", -1, ime)
				TriggerClientEvent("imanja:UpdateImanja", -1, Imanja)
				TriggerClientEvent("imanja:RefreshBlip", -1, ime)
			end
		end
	end
	if not kupio then
		xPlayer.showNotification("Nemate dovoljno novca za ovo imanje!")
	end
end)
