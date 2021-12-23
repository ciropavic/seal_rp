ESX             = nil
local ShopItems = {}
local NoveCijene = {}
local Firme = {}
local Narudzbe = {}
local Kraftanje = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item', {}, function(shopResult)
		for i=1, #shopResult, 1 do
			if shopResult[i].name then
				if ShopItems[shopResult[i].store] == nil then
					ShopItems[shopResult[i].store] = {}
				end

				if shopResult[i].limit == -1 then
					shopResult[i].limit = 30
				end

				table.insert(ShopItems[shopResult[i].store], {
					label = shopResult[i].label,
					item  = shopResult[i].item,
					price = shopResult[i].price,
					limit = shopResult[i].limit
				})
			else
				print(('esx_firme: invalid item "%s" found!'):format(shopResult[i].item))
			end
		end
	end)
	MySQL.Async.fetchAll('SELECT trgovina, item, cijena FROM shops_itemi', {}, function(result)
		for i=1, #result, 1 do
			table.insert(NoveCijene, { store = result[i].trgovina, item = result[i].item, cijena = result[i].cijena })
		end
	end)
	MySQL.Async.fetchAll('SELECT ID, Firma, Item, Vrijeme FROM firme_kraft', {}, function(result)
		for i=1, #result, 1 do
			table.insert(Kraftanje, {ID = result[i].ID, Firma = result[i].Firma, Item = result[i].Item, Vrijeme = result[i].Vrijeme })
		end
	end)
	MySQL.Async.fetchAll('SELECT ID, Ime, Label, Tip, Kupovina, Ulaz, Izlaz, VlasnikKoord, Vlasnik, Sef, Cijena, Zakljucana, Posao, Skladiste, Proizvodi FROM firme', {}, function(result)
		Firme = {}
		for i=1, #result, 1 do
			local proiz = json.decode(result[i].Proizvodi)
			local kup = json.decode(result[i].Kupovina)
			local ul = json.decode(result[i].Ulaz)
			local iz = json.decode(result[i].Izlaz)
			local vl = json.decode(result[i].VlasnikKoord)
			if kup ~= "{}" and kup.x ~= nil then
				kup = vector3(kup.x, kup.y, kup.z-1.0)
			else
				kup = nil
			end
			if ul ~= "{}" and ul.x ~= nil then
				ul = vector3(ul.x, ul.y, ul.z-1.0)
			else
				ul = nil
			end
			if iz ~= "{}" and iz.x ~= nil then
				iz = vector3(iz.x, iz.y, iz.z-1.0)
			else
				iz = nil
			end
			if vl ~= "{}" and vl.x ~= nil then
				vl = vector3(vl.x, vl.y, vl.z-1.0)
			else
				vl = nil
			end
			table.insert(Firme, { TrgID = result[i].ID, Ime = result[i].Ime, Label = result[i].Label, Tip = result[i].Tip, Kupovina = kup, Ulaz = ul, Izlaz = iz, VlasnikKoord = vl, Vlasnik = tonumber(result[i].Vlasnik), Sef = result[i].Sef, Cijena = result[i].Cijena, Zakljucana = result[i].Zakljucana, Posao = result[i].Posao, Skladiste = result[i].Skladiste, Proizvodi = proiz })
		end
		TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
	end)
end)

ESX.RegisterServerCallback('esx_firme:getOnlinePlayers', function(source, cb, job)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.getFirma() ~= job then
			table.insert(players, {
				value     = xPlayer.source,
				identifier = xPlayer.identifier,
				label       = xPlayer.getRPName()
			})
		end
		Wait(100)
	end
	cb(players)
end)

RegisterNetEvent('firme:NapraviFirmu')
AddEventHandler('firme:NapraviFirmu', function(maf, cij)
	local src = source
	local Postoji = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
		end
	end
	if Postoji == 0 then
		MySQL.Async.insert('INSERT INTO firme (Ime, Label, Cijena, Tip) VALUES (@ime, @lab, @cij, @tip)',{
			['@ime'] = maf,
			['@lab'] = "Firma "..#Firme,
			['@cij'] = cij,
			['@tip'] = 69
		}, function(insertId)
			table.insert(Firme, {TrgID = insertId, Ime = maf, Label = "Firma "..#Firme, Tip = 69, Vlasnik = nil, Sef = 0, Cijena = cij, Zakljucana = 0, Posao = 0, Skladiste = 0, Stanje = {}})
			TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
			
			TriggerClientEvent('esx:showNotification', src, 'Firma '..maf..' uspjesno kreirana!')
		end)
	else
		TriggerClientEvent('esx:showNotification', src, 'Firma s tim imenom vec postoji!')
	end
end)

RegisterNetEvent('firme:PostaviBucket')
AddEventHandler('firme:PostaviBucket', function(br)
	local src = source
	SetPlayerRoutingBucket(src, br)
end)

RegisterNetEvent('firme:PostaviTip')
AddEventHandler('firme:PostaviTip', function(maf, br, igrac)
	local src = source
	local Postoji = 0
	local Moze = false
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
			if Firme[i].Ulaz then
				Moze = true
			end
		end
	end
	local Tip = tonumber(br)
	if Postoji == 1 then
		local izlaz = nil
		local kupovina = nil
		local vlasnik = nil
		local store = nil
		if Moze then
			if Tip == 1 then
				izlaz = vector3(1964.6744384765626, 3741.2900390625, 32.34373092651367)
				kupovina = vector3(1961.502197265625, 3741.43359375, 32.34373474121094)
				vlasnik = vector3(1961.768310546875, 3749.293212890625, 32.34378814697265)
				store = "TwentyFourSeven"
			elseif Tip == 2 then
				izlaz = vector3(1933.33203125, 3725.94970703125, 32.84440994262695)
				kupovina = vector3(1933.718505859375, 3730.608154296875, 32.85441589355469)
				vlasnik = vector3(1928.720458984375, 3733.138427734375, 32.84447479248047)
			elseif Tip == 3 then
				izlaz = vector3(1687.9052734375, 4820.68896484375, 42.07000732421875)
				kupovina = vector3(1695.588134765625, 4829.23974609375, 42.06312942504883)
				vlasnik = vector3(1695.344482421875, 4823.55419921875, 42.06312942504883)
			elseif Tip == 4 then
				izlaz = vector3(1199.8079833984, 2654.869140625, 37.806686401368)
				kupovina = vector3(1203.4727783204, 2648.8413085938, 37.806632995606)
				vlasnik = vector3(1199.7360839844, 2644.1850585938, 37.806636810302)
				store = "TuningShop"
			end
		end
		local stanje = {}
		if store ~= nil then
			for i=1, #ShopItems[store], 1 do
				table.insert(stanje, {Item = ShopItems[store][i].item, Stanje = 0})
			end
		end
		if izlaz ~= nil then
			MySQL.Async.execute('UPDATE firme SET `Tip` = @tip, `Izlaz` = @izlaz, `Kupovina` = @kup, `VlasnikKoord` = @vl, `Proizvodi` = @pr WHERE Ime = @ime',{
				['@tip'] = br,
				['@izlaz'] = json.encode(izlaz),
				['@kup'] = json.encode(kupovina),
				['@vl'] = json.encode(vlasnik),
				['@pr'] = json.encode(stanje),
				['@ime'] = maf
			})
		else
			if Tip == 5 then
				MySQL.Async.execute('UPDATE firme SET `Tip` = @tip, `Posao` = 1 WHERE Ime = @ime',{
					['@tip'] = br,
					['@ime'] = maf
				})
			else
				MySQL.Async.execute('UPDATE firme SET `Tip` = @tip, `Proizvodi` = @pr WHERE Ime = @ime',{
					['@tip'] = br,
					['@pr'] = json.encode(stanje),
					['@ime'] = maf
				})
			end
		end
		if Moze and izlaz ~= nil then
			local x,y,z = table.unpack(izlaz)
			izlaz = vector3(x,y,z-1.0)
			x,y,z = table.unpack(kupovina)
			kupovina = vector3(x,y,z-1.0)
			x,y,z = table.unpack(vlasnik)
			vlasnik = vector3(x,y,z-1.0)
		end
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil then
				if Firme[i].Ime == maf then
					Firme[i].Tip = tonumber(br)
					Firme[i].Proizvodi = stanje
					if Tip == 5 then
						Firme[i].Posao = 1
					end
					if izlaz ~= nil then
						Firme[i].Izlaz = izlaz
						Firme[i].Kupovina = kupovina
						Firme[i].VlasnikKoord = vlasnik
					end
					break
				end
			end
		end
		TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
		if izlaz ~= nil and igrac then
			TriggerClientEvent("firme:PortGa", src, vlasnik)
		end
		TriggerClientEvent('esx:showNotification', src, 'Firmi '..maf..' uspjesno zamijenjen tip!')
	else
		TriggerClientEvent('esx:showNotification', src, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('firme:ZakljucajFirmu')
AddEventHandler('firme:ZakljucajFirmu', function(maf, br)
	local Postoji = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE firme SET `Zakljucana` = @tip WHERE Ime = @ime',{
			['@tip'] = br,
			['@ime'] = maf
		})
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil then
				if Firme[i].Ime == maf then
					Firme[i].Zakljucana = tonumber(br)
					break
				end
			end
		end
		TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
		local str = "otkljucana"
		if tonumber(br) == 1 then
			str = "zakljucana"
		end
		TriggerClientEvent('esx:showNotification', source, 'Firma '..maf..' uspjesno '..str)
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('firme:Kraftaj')
AddEventHandler('firme:Kraftaj', function(id, br)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local Postoji = 0
	local zelj = 0
	if br == "filter" then
		zelj = 100
	elseif br == "auspuh" then
		zelj = 200
	elseif br == "elektronika" then
		zelj = 120
	elseif br == "turbo" then
		zelj = 300
	elseif br == "intercooler" then
		zelj = 400
	elseif br == "finjectori" then
		zelj = 220
	elseif br == "kvacilo" then
		zelj = 320
	elseif br == "kmotor" then
		zelj = 1000
	end
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].TrgID == id then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = id}, function(result)
			local skl = result[1].Skladiste
			if skl >= zelj then
				MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
					['@skl'] = skl-zelj,
					['@st'] = id
				})
				MySQL.Async.insert('insert into firme_kraft(Firma, Item, Vrijeme) values (@fir, @it, @vr)',{
					['@fir'] = tonumber(id),
					['@it'] = br,
					['@vr'] = 5
				}, function(insertId)
					table.insert(Kraftanje, {ID = insertId, Firma = id, Item = br, Vrijeme = 5})
					xPlayer.showNotification("Zapoceli ste proizvodnju.")
				end)
			else
				xPlayer.showNotification("Nemate toliko zeljeza u skladistu.")
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterServerEvent('sisanje:tuljanizacija')
AddEventHandler('sisanje:tuljanizacija', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lova = Config.Price
	if #NoveCijene > 0 then
		for j=1, #NoveCijene, 1 do
			if NoveCijene[j].store == id and NoveCijene[j].item == "sisanje" then
				lova = NoveCijene[j].cijena
				break
			end
		end
	end
	xPlayer.removeMoney(lova)
	DajFirmi(id, lova/2)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', lova))
end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lova = Config.Price
	if #NoveCijene > 0 then
		for j=1, #NoveCijene, 1 do
			if NoveCijene[j].store == id and NoveCijene[j].item == "sisanje" then
				lova = NoveCijene[j].cijena
				break
			end
		end
	end
	cb(xPlayer.get('money') >= lova)
end)

RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skin)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
	end)
end)

ESX.RegisterServerCallback('roba:KaeTuljani', function(source, cb, id)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local lova = Config.Price
	if #NoveCijene > 0 then
		for j=1, #NoveCijene, 1 do
			if NoveCijene[j].store == id and NoveCijene[j].item == "odjeca" then
				lova = NoveCijene[j].cijena
				break
			end
		end
	end
	if xPlayer.getMoney() >= lova then
		xPlayer.removeMoney(lova)
		DajFirmi(id, lova/2)
		TriggerClientEvent('esx:showNotification', src, _U('you_paid', lova))
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)

RegisterNetEvent('firme:PromjeniIme')
AddEventHandler('firme:PromjeniIme', function(maf, lab)
	local Postoji = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE firme SET `Label` = @lab WHERE Ime = @ime',{
			['@lab'] = lab,
			['@ime'] = maf
		})
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil then
				if Firme[i].Ime == maf then
					Firme[i].Label = lab
					break
				end
			end
		end
		TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
		TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno promjenjeno ime!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('firme:PromjeniCijenu')
AddEventHandler('firme:PromjeniCijenu', function(maf, cij)
	local Postoji = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('UPDATE firme SET `Cijena` = @lab WHERE Ime = @ime',{
			['@lab'] = cij,
			['@ime'] = maf
		})
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil then
				if Firme[i].Ime == maf then
					Firme[i].Cijena = cij
					break
				end
			end
		end
		TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
		TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno promjenjena cijena!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('firme:ObrisiFirmu')
AddEventHandler('firme:ObrisiFirmu', function(maf)
	local Postoji = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
		end
	end
	if Postoji == 1 then
		MySQL.Async.execute('DELETE FROM firme WHERE Ime = @ime',{
			['@ime'] = maf
		})
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil then
				if Firme[i].Ime == maf then
					table.remove(Firme, i)
					break
				end
			end
		end
		TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
		TriggerClientEvent('esx:showNotification', source, 'Firma '..maf..' uspjesno obrisana!')
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

RegisterNetEvent('firme:SpremiCoord')
AddEventHandler('firme:SpremiCoord', function(maf, coord, br)
	local Postoji = 0
	local Tip = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == maf then
			Postoji = 1
			Tip = Firme[i].Tip
		end
	end
	if Postoji == 1 then
		if br == 1 then
			MySQL.Async.execute('UPDATE firme SET `Kupovina` = @kor WHERE Ime = @ime',{
				['@kor'] = json.encode(coord),
				['@ime'] = maf
			})
			for i=1, #Firme, 1 do
				if Firme[i] ~= nil then
					if Firme[i].Ime == maf then
						local x,y,z = table.unpack(coord)
						local kor = vector3(x,y,z-1.0)
						Firme[i].Kupovina = kor
						break
					end
				end
			end
			TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
			TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno postavljene koordinate kupovine!')
		elseif br == 2 then
			local izlaz = nil
			local kupovina = nil
			local vlasnik = nil
			if Tip == 1 or Tip == 69 then
				izlaz = vector3(1964.6744384765626, 3741.2900390625, 32.34373092651367)
				kupovina = vector3(1961.502197265625, 3741.43359375, 32.34373474121094)
				vlasnik = vector3(1961.768310546875, 3749.293212890625, 32.34378814697265)
			elseif Tip == 2 then
				izlaz = vector3(1933.33203125, 3725.94970703125, 32.84440994262695)
				kupovina = vector3(1933.718505859375, 3730.608154296875, 32.85441589355469)
				vlasnik = vector3(1928.720458984375, 3733.138427734375, 32.84447479248047)
			elseif Tip == 3 then
				izlaz = vector3(1687.9052734375, 4820.68896484375, 42.07000732421875)
				kupovina = vector3(1695.588134765625, 4829.23974609375, 42.06312942504883)
				vlasnik = vector3(1695.344482421875, 4823.55419921875, 42.06312942504883)
			end
			if izlaz ~= nil then
				MySQL.Async.execute('UPDATE firme SET `Ulaz` = @kor, `Izlaz` = @izl, `Kupovina` = @kup, `VlasnikKoord` = @vl WHERE Ime = @ime',{
					['@kor'] = json.encode(coord),
					['@izl'] = json.encode(izlaz),
					['@kup'] = json.encode(kupovina),
					['@vl'] = json.encode(vlasnik),
					['@ime'] = maf
				})
			else
				MySQL.Async.execute('UPDATE firme SET `Ulaz` = @kor WHERE Ime = @ime',{
					['@kor'] = json.encode(coord),
					['@ime'] = maf
				})
			end
			local x,y,z = table.unpack(izlaz)
			izlaz = vector3(x,y,z-1.0)
			x,y,z = table.unpack(kupovina)
			kupovina = vector3(x,y,z-1.0)
			x,y,z = table.unpack(vlasnik)
			vlasnik = vector3(x,y,z-1.0)
			for i=1, #Firme, 1 do
				if Firme[i] ~= nil then
					if Firme[i].Ime == maf then
						x,y,z = table.unpack(coord)
						local kor = vector3(x,y,z-1.0)
						Firme[i].Ulaz = kor
						if izlaz ~= nil then
							Firme[i].Izlaz = izlaz
							Firme[i].Kupovina = kupovina
							Firme[i].VlasnikKoord = vlasnik
						end
						break
					end
				end
			end
			TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
			TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno postavljene koordinate ulaza!')
		elseif br == 3 then
			MySQL.Async.execute('UPDATE firme SET `Izlaz` = @kor WHERE Ime = @ime',{
				['@kor'] = json.encode(coord),
				['@ime'] = maf
			})
			for i=1, #Firme, 1 do
				if Firme[i] ~= nil then
					if Firme[i].Ime == maf then
						x,y,z = table.unpack(coord)
						local kor = vector3(x,y,z-1.0)
						Firme[i].Izlaz = kor
						break
					end
				end
			end
			TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
			TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno postavljene koordinate izlaza!')
		elseif br == 4 then
			MySQL.Async.execute('UPDATE firme SET `VlasnikKoord` = @kor WHERE Ime = @ime',{
				['@kor'] = json.encode(coord),
				['@ime'] = maf
			})
			for i=1, #Firme, 1 do
				if Firme[i] ~= nil then
					if Firme[i].Ime == maf then
						x,y,z = table.unpack(coord)
						local kor = vector3(x,y,z-1.0)
						Firme[i].VlasnikKoord = kor
						break
					end
				end
			end
			TriggerClientEvent("firme:PosaljiFirme", -1, Firme)
			TriggerClientEvent('esx:showNotification', source, 'Firmi '..maf..' uspjesno postavljene koordinate kupovine!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Firma s tim imenom ne postoji!')
	end
end)

ESX.RegisterServerCallback('esx_firme:requestDBItems', function(source, cb)
	cb(ShopItems, NoveCijene, Firme)
end)

RegisterServerEvent('trgovine:ProdajIgracu')
AddEventHandler('trgovine:ProdajIgracu', function(ime, id, cijena)
	local src = source
	TriggerClientEvent("trgovine:PitajProdaju", id, ime, cijena, src)
end)

RegisterServerEvent('trgovine:PrihvatioProdaju')
AddEventHandler('trgovine:PrihvatioProdaju', function(ime, cijena, pid)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local tPlayer = ESX.GetPlayerFromId(pid)
	if xPlayer.getMoney() >= cijena then
		local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(pid).."("..tPlayer.identifier..") je dobio $"..cijena.."(linija 532)"
		TriggerEvent("SpremiLog", por)
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil and Firme[i].Ime == ime then
				xPlayer.removeMoney(cijena)
				tPlayer.addMoney(cijena)
				Firme[i].Vlasnik = xPlayer.getID()
				MySQL.Async.execute('UPDATE firme SET `Vlasnik` = @ow WHERE Ime = @st', {
					['@ow'] = xPlayer.getID(),
					['@st'] = ime
				})
				TriggerClientEvent("esx_firme:ReloadBlip", src)
				TriggerClientEvent("esx_firme:ReloadBlip", pid)
				tPlayer.showNotification("Prodali ste firmu za $"..cijena.."!")
				xPlayer.showNotification("Kupili ste firmu za $"..cijena.."!")
				TriggerEvent("DiscordBot:Prodaja", tPlayer.name.."["..tPlayer.source.."] je prodao firmu "..ime.." za $"..cijena.." igracu "..xPlayer.name.."["..xPlayer.source.."]")
				break
			end
		end
	else
		tPlayer.showNotification("Igrac nema dovoljno novca kod sebe!")
		xPlayer.showNotification("Nemate dovoljno novca kod sebe!")
	end
end)

RegisterServerEvent('trgovine:OdbioProdaju')
AddEventHandler('trgovine:OdbioProdaju', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	xPlayer.showNotification("Igrac je odbio ponudu za prodaju firme!")
end)

RegisterServerEvent('esx_firme:Zaposli')
AddEventHandler('esx_firme:Zaposli', function(firma, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		xPlayer.setFirma(firma)
		xPlayer.showNotification("Zaposleni ste u firmu!")
		MySQL.Async.execute('UPDATE users SET `firma` = @firm WHERE ID = @id', {
			['@id'] = xPlayer.getID(),
			['@firm'] = tonumber(firma)
		})
	end
end)

RegisterServerEvent('esx_firme:Otpusti')
AddEventHandler('esx_firme:Otpusti', function(id)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.getID() == id then
			xPlayer.setFirma(0)
			xPlayer.showNotification("Otpusteni ste iz firme!")
			break
		end
	end
	MySQL.Async.execute('UPDATE users SET `firma` = 0 WHERE ID = @id', {
		['@id'] = id
	})
end)

ESX.RegisterServerCallback('esx_firme:DajDostupnost', function(source, cb, store)
	local naso = false
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == store then
			if Firme[i].Vlasnik == nil then
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

ESX.RegisterServerCallback('esx_firme:DajTipFirme', function(source, cb, st)
	local naso = false
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].TrgID == st then
			naso = true
			cb(Firme[i].Tip)
			break
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_firme:DajRadnike', function(source, cb, st)
	local elem = {}
	MySQL.Async.fetchAll('SELECT ID, firstname, lastname FROM users where firma = @firm', {['@firm'] = st}, function(result)
		for i=1, #result, 1 do
			table.insert(elem, { label = result[i].firstname.." "..result[i].lastname, value = result[i].ID })
		end
		cb(elem)
	end)
end)

ESX.RegisterServerCallback('esx_firme:DajDobavljace', function(source, cb, tip)
	local elem = {}
	local tipic = 0
	local item = "kurac"
	if tip == 4 then
		tipic = 5
		item = "zeljezo"
	end
	local cijena = 50
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Tip == tipic then
			if #NoveCijene > 0 then
				for j=1, #NoveCijene, 1 do
					if NoveCijene[j].store == Firme[i].Ime and NoveCijene[j].item == item then
						cijena = NoveCijene[j].cijena
					end
				end
			end
			table.insert(elem, { label = Firme[i].Label.." | <font style='color:green;'>1g -> "..cijena.."$</font>", value = Firme[i].TrgID, cijena = cijena })
		end
	end
	if #elem == 0 then
		cb(0)
	else
		cb(elem)
	end
end)

ESX.RegisterServerCallback('esx_firme:DajSkladiste', function(source, cb, st)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = st}, function(result)
		cb(result[1].Skladiste)
	end)
end)

RegisterServerEvent('esx_firme:NaruciRobu')
AddEventHandler('esx_firme:NaruciRobu', function(firmaid, br, dob, cij)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = dob}, function(result)
		local skl = result[1].Skladiste
		if skl >= br then
			MySQL.Async.execute('INSERT INTO narudzbe(Firma, Dobavljac, Kolicina, Cijena) values(@firm, @dob, @kol, @cijena)', {
				['@firm'] = firmaid,
				['@dob'] = dob,
				['@kol'] = br,
				['@cijena'] = cij
			})
			xPlayer.showNotification("Narucili ste "..br.."g zeljeza!")
		else
			xPlayer.showNotification("Dobavljac nema toliko u skladistu, preostalo im je "..skl.."g")
		end
	end)
end)

RegisterServerEvent('esx_firme:NaruciRobu2')
AddEventHandler('esx_firme:NaruciRobu2', function(firmaid, br, cij)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('INSERT INTO narudzbe(Firma, Dobavljac, Kolicina, Cijena) values(@firm, @dob, @kol, @cijena)', {
		['@firm'] = firmaid,
		['@dob'] = 69,
		['@kol'] = br,
		['@cijena'] = cij
	})
	xPlayer.showNotification("Narucili ste "..br.." proizvoda!")
end)

ESX.RegisterServerCallback('esx_firme:DajNarudzbe', function(source, cb, st)
	local elem = {}
	local kol = "g"
	MySQL.Async.fetchAll('SELECT ID, Firma, Kolicina FROM narudzbe where Dobavljac = @firm and Rezervirano = 0', {['@firm'] = st}, function(result)
		for i=1, #result, 1 do
			for a=1, #Firme, 1 do
				if Firme[a] ~= nil and Firme[a].TrgID == result[i].Firma then
					if Firme[a].Tip == 1 then
						kol = " proizvoda"
					end
					table.insert(elem, { label = Firme[a].Label.." | "..result[i].Kolicina..kol, value = result[i].ID, kolicina = result[i].Kolicina, firma = result[i].Firma })
					break
				end
			end
		end
		if #elem == 0 then
			cb(0)
		else
			cb(elem)
		end
	end)
end)

RegisterServerEvent('esx_firme:ZapocniNarudzbu')
AddEventHandler('esx_firme:ZapocniNarudzbu', function(id, st, br, firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = st}, function(result)
		local skl = result[1].Skladiste
		if skl >= br then
			MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
				['@skl'] = skl-br,
				['@st'] = st
			})
			MySQL.Async.execute('UPDATE narudzbe SET `Rezervirano` = 1 WHERE ID = @st', {
				['@st'] = id
			})
			TriggerClientEvent("esx_firme:DostaviRobu", _source, id, br, firma, st)
			table.insert(Narudzbe, {NarID = id, Igrac = _source})
		else
			xPlayer.showNotification("Nemate toliko u skladistu")
		end
	end)
end)

RegisterServerEvent('esx_firme:ZapocniNarudzbu2')
AddEventHandler('esx_firme:ZapocniNarudzbu2', function(id, st, br, firma)
	local _source = source
	MySQL.Async.execute('UPDATE narudzbe SET `Rezervirano` = 1 WHERE ID = @st', {
		['@st'] = id
	})
	local koord
	for i = 1, #Firme, 1 do
		if Firme[i].TrgID == firma then
			koord = Firme[i].Kupovina
			if Firme[i].Ulaz then
				koord = Firme[i].Ulaz
			end
			break
		end
	end
	TriggerClientEvent("esx_dostavljac:DostaviRobu", _source, id, br, firma, st, koord)
	table.insert(Narudzbe, {NarID = id, Igrac = _source})
end)

RegisterServerEvent('esx_firme:ZavrsiDostavu')
AddEventHandler('esx_firme:ZavrsiDostavu', function(id, firma, dost)
	MySQL.Async.fetchAll('SELECT Kolicina, Cijena FROM narudzbe where ID = @id', {['@id'] = id}, function(result)
		MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = firma}, function(result2)
			local kol = result[1].Kolicina
			local cij = result[1].Cijena
			local skl = result2[1].Skladiste
			MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
				['@skl'] = skl+kol,
				['@st'] = firma
			})
			DajFirmi2(dost, kol*cij)
			OduzmiFirmi2(firma, kol*cij)
			MySQL.Async.execute('delete from narudzbe where ID = @id', {
				['@id'] = id
			})
			for i=1, #Narudzbe, 1 do
				if Narudzbe[i].NarID == id then
					table.remove(Narudzbe, i)
				end
			end
		end)
	end)
end)

RegisterServerEvent('esx_firme:ZavrsiDostavu2')
AddEventHandler('esx_firme:ZavrsiDostavu2', function(id, firma)
	MySQL.Async.fetchAll('SELECT Kolicina, Cijena FROM narudzbe where ID = @id', {['@id'] = id}, function(result)
		MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = firma}, function(result2)
			local kol = result[1].Kolicina
			local cij = result[1].Cijena
			local skl = result2[1].Skladiste
			MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
				['@skl'] = skl+kol,
				['@st'] = firma
			})
			--DajFirmi2(dost, kol*cij)
			OduzmiFirmi2(firma, kol*cij)
			MySQL.Async.execute('delete from narudzbe where ID = @id', {
				['@id'] = id
			})
			for i=1, #Narudzbe, 1 do
				if Narudzbe[i].NarID == id then
					table.remove(Narudzbe, i)
				end
			end
		end)
	end)
end)

AddEventHandler('playerDropped', function()
	for i=1, #Narudzbe, 1 do
		if Narudzbe[i].Igrac == source then
			MySQL.Async.execute('UPDATE narudzbe SET `Rezervirano` = 0 WHERE ID = @st', {
				['@st'] = Narudzbe[i].NarID
			})
			table.remove(Narudzbe, i)
		end
	end
end)

RegisterServerEvent('esx_firme:OduzmiSkladiste')
AddEventHandler('esx_firme:OduzmiSkladiste', function(st, br, tip)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = st}, function(result)
		local skl = result[1].Skladiste
		if skl >= br then
			MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
				['@skl'] = skl-br,
				['@st'] = st
			})
			xPlayer.addInventoryItem("iron", br)
			xPlayer.showNotification("Uzeli ste "..br.." iz skladista, na stanju jos imate "..skl-br)
		else
			xPlayer.showNotification("Nemate toliko u skladistu")
		end
	end)
end)

RegisterServerEvent('esx_firme:DajSkladistu')
AddEventHandler('esx_firme:DajSkladistu', function(st, br, tip)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = st}, function(result)
		local skl = result[1].Skladiste
		if xPlayer.getInventoryItem('iron').count >= br then
			MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
				['@skl'] = skl+br,
				['@st'] = st
			})
			xPlayer.removeInventoryItem("iron", br)
			xPlayer.showNotification("Ostavili ste "..br.." u skladiste")
		else
			xPlayer.showNotification("Nemate toliko kod sebe!")
		end
	end)
end)

RegisterServerEvent('esx_firme:DajSkladistu2')
AddEventHandler('esx_firme:DajSkladistu2', function(st, br, tip)
	MySQL.Async.fetchAll('SELECT Skladiste FROM firme where ID = @firm', {['@firm'] = st}, function(result)
		local skl = result[1].Skladiste
		MySQL.Async.execute('UPDATE firme SET `Skladiste` = @skl WHERE ID = @st', {
			['@skl'] = skl+br,
			['@st'] = st
		})
	end)
end)

ESX.RegisterServerCallback('esx_firme:DajSef', function(source, cb, store)
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == store then
			cb(Firme[i].Sef)
			break
		end
	end
end)

ESX.RegisterServerCallback('esx_firme:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == zona and Firme[i].Vlasnik == xPlayer.getID() then
			cb(1)
			naso = true
			break
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_firme:DajBrojTrgovina', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local br = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Vlasnik == xPlayer.getID() then
			br = br+1
		end
	end
	cb(br)
end)

RegisterServerEvent('esx_firme:PromjeniCijenu')
AddEventHandler('esx_firme:PromjeniCijenu', function(store, ime, item, cijena)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local mere = false
	local ciji = 0
	
	if item == "sisanje" then
		if cijena >= 50 then
			mere = true
		else
			ciji = 50
		end
	elseif item == "odjeca" then
		if cijena >= 50 then
			mere = true
		else
			ciji = 50
		end
	elseif item == "zeljezo" then
		if cijena >= 50 then
			mere = true
		else
			ciji = 50
		end
	else
		for i=1, #ShopItems[store], 1 do
			if ShopItems[store][i].item == item then
				ciji = ShopItems[store][i].price
				if cijena >= ShopItems[store][i].price then
					mere = true
				end
				break
			end
		end
	end
	if mere then
		local pronaso = false
		for i=1, #NoveCijene, 1 do
			if NoveCijene[i] ~= nil then
				if NoveCijene[i].item == item and NoveCijene[i].store == ime then
					pronaso = true
					NoveCijene[i].cijena = cijena
					break
				end
			end
		end
		if not pronaso then
			table.insert(NoveCijene, { store = ime, item = item, cijena = cijena })
		end
		
		TriggerClientEvent("esx_firme:UpdateCijene", -1, NoveCijene)
		
		MySQL.Async.fetchScalar('SELECT item FROM shops_itemi WHERE trgovina = @trg AND item = @item', {
			['@trg'] = ime,
			['@item'] = item
		}, function(result)
			if result == nil then
				MySQL.Async.execute('INSERT INTO shops_itemi (trgovina, item, cijena) VALUES (@trg, @it, @cij)',{
					['@trg'] = ime,
					['@it'] = item,
					['@cij'] = cijena
				})
			else
				MySQL.Async.execute('UPDATE shops_itemi SET `cijena` = @cij WHERE trgovina = @store AND item = @item', {
					['@cij'] = cijena,
					['@store'] = ime,
					['@item'] = item
				})
			end
		end)
		
		xPlayer.showNotification("Uspjesno ste promjenili cijenu proizvoda na $"..cijena)
	else
		xPlayer.showNotification("Greska! Cijena mora biti veca ili jednaka $"..ciji)
	end
end)

RegisterServerEvent('ducan:piku2')
AddEventHandler('ducan:piku2', function(zona, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lova = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == id then
			lova = tonumber(Firme[i].Cijena)
		end
	end
	-- can the player afford this item?
	if xPlayer.getMoney() >= lova then
		xPlayer.removeMoney(lova)
		local store = id
		MySQL.Async.execute('UPDATE firme SET `Vlasnik` = @identifier WHERE Ime = @store', {
			['@identifier'] = xPlayer.getID(),
			['@store'] = store
		})
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste trgovinu za $"..lova)
		TriggerClientEvent("esx_firme:ReloadBlip", _source)
		for i=1, #Firme, 1 do
			if Firme[i] ~= nil and Firme[i].Ime == store then
				Firme[i].Vlasnik = xPlayer.getID()
				break
			end
		end
	else
		local missingMoney = lova - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

function DajFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT Sef FROM firme WHERE Ime = @st', {
		['@st'] = id
	})
	local cij = result[1].Sef+price
	MySQL.Async.execute('UPDATE firme SET `Sef` = @se WHERE Ime = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == id then
			Firme[i].Sef = Firme[i].Sef+price
			break
		end
	end
end

function OduzmiFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT Sef FROM firme WHERE Ime = @st', {
		['@st'] = id
	})
	local cij = result[1].Sef-price
	MySQL.Async.execute('UPDATE firme SET `Sef` = @se WHERE Ime = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == id then
			Firme[i].Sef = Firme[i].Sef-price
			break
		end
	end
end

function DajFirmi2(id, price)
	local result = MySQL.Sync.fetchAll('SELECT Sef FROM firme WHERE ID = @st', {
		['@st'] = id
	})
	local cij = result[1].Sef+price
	MySQL.Async.execute('UPDATE firme SET `Sef` = @se WHERE ID = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].TrgID == id then
			Firme[i].Sef = Firme[i].Sef+price
			break
		end
	end
end

function OduzmiFirmi2(id, price)
	local result = MySQL.Sync.fetchAll('SELECT Sef FROM firme WHERE ID = @st', {
		['@st'] = id
	})
	local cij = result[1].Sef-price
	MySQL.Async.execute('UPDATE firme SET `Sef` = @se WHERE ID = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].TrgID == id then
			Firme[i].Sef = Firme[i].Sef-price
			break
		end
	end
end

RegisterServerEvent('esx_firme:ProdajFirmu')
AddEventHandler('esx_firme:ProdajFirmu', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lova = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == firma then
			lova = Firme[i].Cijena
		end
	end
	xPlayer.addMoney(lova/2)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..lova
	TriggerEvent("SpremiLog", por)
	MySQL.Async.execute('UPDATE firme SET `Vlasnik` = null WHERE Ime = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali trgovinu!")
	TriggerClientEvent("esx_firme:ReloadBlip", _source)
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == firma then
			Firme[i].Vlasnik = nil
			break
		end
	end
end)

RegisterServerEvent('firme:MakniVlasnika')
AddEventHandler('firme:MakniVlasnika', function(firma)
	local _source = source
	MySQL.Async.execute('UPDATE firme SET `Vlasnik` = null WHERE Ime = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali firmu!")
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == firma then
			Firme[i].Vlasnik = nil
			break
		end
	end
	TriggerClientEvent("esx_firme:ReloadBlip", -1)
end)

RegisterServerEvent('esx_firme:OduzmiFirmi')
AddEventHandler('esx_firme:OduzmiFirmi', function(firma, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	OduzmiFirmi(firma, amount)
	xPlayer.addMoney(amount)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..amount
	TriggerEvent("SpremiLog", por)
end)

RegisterServerEvent('ducan:piku')
AddEventHandler('ducan:piku', function(itemName, amount, zone, id, torba, did)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	amount = ESX.Math.Round(amount)

	-- is the player trying to exploit?
	if amount < 0 then
		print('esx_firme: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''
	
	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			if #NoveCijene > 0 then
				local naso = false
				for j=1, #NoveCijene, 1 do
					if NoveCijene[j].store == id and NoveCijene[j].item == itemName then
						naso = true
						price = NoveCijene[j].cijena
						itemLabel = ShopItems[zone][i].label
						break
					end
				end
				if not naso then
					price = ShopItems[zone][i].price
					itemLabel = ShopItems[zone][i].label
				end
				break
			else
				price = ShopItems[zone][i].price
				itemLabel = ShopItems[zone][i].label
				break
			end
		end
	end

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if torba then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit*2 then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				local moze = true
				if zone == "TuningShop" then
					for j = 1, #Firme, 1 do
						if Firme[j].Ime == id then
							for k = 1, #Firme[j].Proizvodi, 1 do
								if Firme[j].Proizvodi[k].Item == itemName then
									if Firme[j].Proizvodi[k].Stanje >= amount then
										Firme[j].Proizvodi[k].Stanje = Firme[j].Proizvodi[k].Stanje-1
										MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE Ime = @st', {
											['@pr'] = json.encode(Firme[j].Proizvodi),
											['@st'] = id
										})
										TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
									else
										moze = false
									end
									break
								end
							end
						end
					end
				else
					for j = 1, #Firme, 1 do
						if Firme[j].Ime == id then
							if Firme[j].Skladiste >= amount then
								Firme[j].Skladiste = Firme[j].Skladiste-amount
								TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
								MySQL.Async.execute('UPDATE firme SET `Skladiste` = @pr WHERE Ime = @st', {
									['@pr'] = Firme[j].Skladiste,
									['@st'] = id
								})
							else
								moze = false
							end
							break
						end
					end
				end
				if moze then
					xPlayer.removeMoney(price)
					DajFirmi(id, price/2)
					xPlayer.addInventoryItem(itemName, amount)
					TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x "..amount
					TriggerEvent("SpremiLog", por)
					if zone == "TuningShop" then
						TriggerClientEvent("firme:UpdateTekst", _source, did, sourceItem, id)
					else
						TriggerClientEvent("firme:UpdateTekst2", _source, did, sourceItem, id)
					end
				else
					TriggerClientEvent('esx:showNotification', _source, "Tog proizvoda nemamo na stanju!")
				end
			end
		else
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				local moze = true
				if zone == "TuningShop" then
					for j = 1, #Firme, 1 do
						if Firme[j].Ime == id then
							for k = 1, #Firme[j].Proizvodi, 1 do
								if Firme[j].Proizvodi[k].Item == itemName then
									if Firme[j].Proizvodi[k].Stanje >= amount then
										Firme[j].Proizvodi[k].Stanje = Firme[j].Proizvodi[k].Stanje-1
										MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE Ime = @st', {
											['@pr'] = json.encode(Firme[j].Proizvodi),
											['@st'] = id
										})
										TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
									else
										moze = false
									end
									break
								end
							end
						end
					end
				else
					for j = 1, #Firme, 1 do
						if Firme[j].Ime == id then
							if Firme[j].Skladiste >= amount then
								Firme[j].Skladiste = Firme[j].Skladiste-amount
								TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
								MySQL.Async.execute('UPDATE firme SET `Skladiste` = @pr WHERE Ime = @st', {
									['@pr'] = Firme[j].Skladiste,
									['@st'] = id
								})
							else
								moze = false
							end
							break
						end
					end
				end
				if moze then
					xPlayer.removeMoney(price)
					DajFirmi(id, price/2)
					xPlayer.addInventoryItem(itemName, amount)
					TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x "..amount
					TriggerEvent("SpremiLog", por)
					if zone == "TuningShop" then
						TriggerClientEvent("firme:UpdateTekst", _source, did, sourceItem, id)
					else
						TriggerClientEvent("firme:UpdateTekst2", _source, did, sourceItem, id)
					end
				else
					TriggerClientEvent('esx:showNotification', _source, "Tog proizvoda nemamo na stanju!")
				end
			end
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

function Kraft()
	for i=1, #Kraftanje, 1 do
		if Kraftanje[i] == nil then
			table.remove(Kraftanje, i)
		end
	end
	for i=1, #Kraftanje, 1 do
		if Kraftanje[i] ~= nil then
			if Kraftanje[i].Vrijeme > 0 then
				Kraftanje[i].Vrijeme = Kraftanje[i].Vrijeme-5
				if Kraftanje[i].Vrijeme == 0 then
					MySQL.Async.execute('delete from firme_kraft where ID = @id',{
						['@id'] = Kraftanje[i].ID
					})
					local nasoga = false
					for j = 1, #Firme, 1 do
						if Firme[j].TrgID == Kraftanje[i].Firma then
							for k = 1, #Firme[j].Proizvodi, 1 do
								if Firme[j].Proizvodi[k].Item == Kraftanje[i].Item then
									nasoga = true
									Firme[j].Proizvodi[k].Stanje = Firme[j].Proizvodi[k].Stanje+1
									MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE ID = @st', {
										['@pr'] = json.encode(Firme[j].Proizvodi),
										['@st'] = Kraftanje[i].Firma
									})
									TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
									break
								end
							end
							if not nasoga then
								table.insert(Firme[j].Proizvodi, {Stanje = 1, Item = Kraftanje[i].Item})
								MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE ID = @st', {
									['@pr'] = json.encode(Firme[j].Proizvodi),
									['@st'] = Kraftanje[i].Firma
								})
								TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
							end
						end
					end
					Kraftanje[i] = nil
					--table.remove(Kraftanje, i)
				end
			else
				MySQL.Async.execute('delete from firme_kraft where ID = @id',{
					['@id'] = Kraftanje[i].ID
				})
				local nasoga = false
				for j = 1, #Firme, 1 do
					if Firme[j].TrgID == Kraftanje[i].Firma then
						for k = 1, #Firme[j].Proizvodi, 1 do
							if Firme[j].Proizvodi[k].Item == Kraftanje[i].Item then
								nasoga = true
								Firme[j].Proizvodi[k].Stanje = Firme[j].Proizvodi[k].Stanje+1
								MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE ID = @st', {
									['@pr'] = json.encode(Firme[j].Proizvodi),
									['@st'] = Kraftanje[i].Firma
								})
								TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
								break
							end
						end
						if not nasoga then
							table.insert(Firme[j].Proizvodi, {Stanje = 1, Item = Kraftanje[i].Item})
							MySQL.Async.execute('UPDATE firme SET `Proizvodi` = @pr WHERE ID = @st', {
								['@pr'] = json.encode(Firme[j].Proizvodi),
								['@st'] = Kraftanje[i].Firma
							})
							TriggerClientEvent("firme:PosaljiFirme", -1,  Firme)
						end
					end
				end
				Kraftanje[i] = nil
				--table.remove(Kraftanje, i)
			end
		end
	end
	SetTimeout(60000, Kraft)
end

SetTimeout(60000, Kraft)