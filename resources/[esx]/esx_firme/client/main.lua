local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local CurrentID 			  = nil
local CurrentTip 		      = nil
local CurrentCpID			  = nil
local CurrentTrgID  		  = nil
local blip = {}
local NoveCijene = {}
local PrviSpawn = false
local NemaStruje = false
local Firme = {}
local Bucket = 0

local Cpovi = {}
local Vozilo = nil
local Blipara = nil

local HasPaid                 = false
local GUI                     = {}
GUI.Time                      = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_firme:requestDBItems', function(ShopItems, kjurac, firme)
		for k,v in pairs(ShopItems) do
			--if k ~= "Bar" then
				Config.Zones[k].Items = v
			--end
		end
		NoveCijene = kjurac
		Firme = firme
	end)
	Citizen.Wait(1000)
	ReloadBlip()
	SpawnCpove()
end)

RegisterCommand("uredifirmu", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			local elements = {}
			
			for i=1, #Firme, 1 do
				if Firme[i] ~= nil then
					table.insert(elements, {label = Firme[i].Label, value = Firme[i].Ime})
				end
			end
			
			table.insert(elements, {label = "Kreiraj firmu", value = "novafirma"})

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'umafiju',
				{
					title    = "Izaberite firmu",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "novafirma" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
							title = "Upisite ime firme",
						}, function (datari, menuri)
							local mIme = datari.value						
							if mIme == nil then
								ESX.ShowNotification('Greska.')
							else
								menuri.close()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime2', {
									title = "Upisite cijenu firme",
								}, function (datari2, menuri2)
									local mCijena = datari2.value						
									if mCijena == nil then
										ESX.ShowNotification('Greska.')
									else
										menuri2.close()
										menu.close()
										TriggerServerEvent("firme:NapraviFirmu", mIme, mCijena)
										ExecuteCommand("uredifirmu")
									end
								end, function (datari2, menuri2)
									menuri2.close()
								end)
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					else
						local ImeFirme = data.current.value
						elements = {}
						table.insert(elements, {label = "Koordinate", value = "koord"})
						table.insert(elements, {label = "Promjeni tip firme", value = "tip"})
						table.insert(elements, {label = "Promjeni ime", value = "ime"})
						table.insert(elements, {label = "Promjeni cijenu", value = "cijena"})
						table.insert(elements, {label = "Makni vlasnika", value = "vlasnik"})
						table.insert(elements, {label = "Zakljucaj/otkljucaj tip firme", value = "kljucaj"})
						table.insert(elements, {label = "Obrisi firmu", value = "obrisi"})
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'umafiju2',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								if data2.current.value == "koord" then
									elements = {}
									
									table.insert(elements, {label = "Postavi koordinate kupovine", value = "1"})
									table.insert(elements, {label = "Postavi koordinate ulaza", value = "2"})
									table.insert(elements, {label = "Postavi koordinate izlaza", value = "3"})
									table.insert(elements, {label = "Postavi koordinate kupovine firme", value = "4"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local mid = datalr.current.value
										local coord = GetEntityCoords(PlayerPedId())
										TriggerServerEvent("firme:SpremiCoord", ImeFirme, coord, tonumber(mid))
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "tip" then
									elements = {}
									
									table.insert(elements, {label = "Postavi trgovinu", value = "1"})
									table.insert(elements, {label = "Postavi frizerski", value = "2"})
									table.insert(elements, {label = "Postavi odjecu", value = "3"})
									table.insert(elements, {label = "Postavi tuning shop", value = "4"})
									table.insert(elements, {label = "Postavi rudarsku firmu", value = "5"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local br = datalr.current.value
										TriggerServerEvent("firme:PostaviTip", ImeFirme, br, false)
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "ime" then
									local mafIme
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mafime', {
										title = "Upisite novo ime firme",
									}, function (datar, menur)
										mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											TriggerServerEvent("firme:PromjeniIme", ImeFirme, mafIme)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "vlasnik" then
									TriggerServerEvent("firme:MakniVlasnika", ImeFirme)
								elseif data2.current.value == "kljucaj" then
									elements = {}
									
									table.insert(elements, {label = "Zakljucaj", value = "1"})
									table.insert(elements, {label = "Otkljucaj", value = "0"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										menulr.close()
										TriggerServerEvent("firme:ZakljucajFirmu", ImeFirme, datalr.current.value)
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "cijena" then
									local mafIme
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mafime', {
										title = "Upisite novu cijenu firme",
									}, function (datar, menur)
										mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											TriggerServerEvent("firme:PromjeniCijenu", ImeFirme, mafIme)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "obrisi" then
									elements = {}
									
									table.insert(elements, {label = "Da", value = "da"})
									table.insert(elements, {label = "Ne", value = "ne"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Zelite li obrisati firmu?",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "da" then
											menulr.close()
											menu2.close()
											menu.close()
											TriggerServerEvent("firme:ObrisiFirmu", ImeFirme)
										else
											menulr.close()
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								end
							end,
							function(data2, menu2)
								
								menu2.close()
							end
						)
					end
				end,
				function(data, menu)

					menu.close()
				end
			)
		end
	end)
end, false)

function OpenCijeneMenu(zone, st, tip)
	local elements2 = {}
	if tip == 1 then
		for i=1, #Config.Zones[zone].Items, 1 do
			local item = Config.Zones[zone].Items[i]
			
			if #NoveCijene > 0 then
				local naso = false
				for j=1, #NoveCijene, 1 do
					if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
						naso = true
						table.insert(elements2, {
							label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
							item       = item.item,
							price      = NoveCijene[j].cijena,
						})
					end
				end
				if not naso then
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
						item       = item.item,
						price      = item.price,
					})
				end
			else
				table.insert(elements2, {
					label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
					item       = item.item,
					price      = item.price,
				})
			end
		end
	elseif tip == 2 then
		local item = "sisanje"
		if #NoveCijene > 0 then
			local naso = false
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item then
					naso = true
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format("Sisanje", _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
						item       = item,
						price      = NoveCijene[j].cijena,
					})
				end
			end
			if not naso then
				table.insert(elements2, {
					label      = ('%s - <span style="color:green;">%s</span>'):format("Sisanje", _U('shop_item', ESX.Math.GroupDigits(50))),
					item       = item,
					price      = 50,
				})
			end
		else
			table.insert(elements2, {
				label      = ('%s - <span style="color:green;">%s</span>'):format("Sisanje", _U('shop_item', ESX.Math.GroupDigits(50))),
				item       = item,
				price      = 50,
			})
		end
	elseif tip == 3 then
		local item = "odjeca"
		if #NoveCijene > 0 then
			local naso = false
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item then
					naso = true
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format("Odjeca", _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
						item       = item,
						price      = NoveCijene[j].cijena,
					})
				end
			end
			if not naso then
				table.insert(elements2, {
					label      = ('%s - <span style="color:green;">%s</span>'):format("Odjeca", _U('shop_item', ESX.Math.GroupDigits(50))),
					item       = item,
					price      = 50,
				})
			end
		else
			table.insert(elements2, {
				label      = ('%s - <span style="color:green;">%s</span>'):format("Odjeca", _U('shop_item', ESX.Math.GroupDigits(50))),
				item       = item,
				price      = 50,
			})
		end
	elseif tip == 4 then
		zone = "TuningShop"
		for i=1, #Config.Zones[zone].Items, 1 do
			local item = Config.Zones[zone].Items[i]
			
			if #NoveCijene > 0 then
				local naso = false
				for j=1, #NoveCijene, 1 do
					if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
						naso = true
						table.insert(elements2, {
							label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
							item       = item.item,
							price      = NoveCijene[j].cijena,
						})
					end
				end
				if not naso then
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
						item       = item.item,
						price      = item.price,
					})
				end
			else
				table.insert(elements2, {
					label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
					item       = item.item,
					price      = item.price,
				})
			end
		end
	elseif tip == 5 then
		local item = "zeljezo"
		if #NoveCijene > 0 then
			local naso = false
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item then
					naso = true
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format("1g zeljeza", _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
						item       = item,
						price      = NoveCijene[j].cijena,
					})
				end
			end
			if not naso then
				table.insert(elements2, {
					label      = ('%s - <span style="color:green;">%s</span>'):format("1g zeljeza", _U('shop_item', ESX.Math.GroupDigits(50))),
					item       = item,
					price      = 50,
				})
			end
		else
			table.insert(elements2, {
				label      = ('%s - <span style="color:green;">%s</span>'):format("1g zeljeza", _U('shop_item', ESX.Math.GroupDigits(50))),
				item       = item,
				price      = 50,
			})
		end
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shopc', {
		title    = "Izaberite proizvod",
		align    = 'bottom-right',
		elements = elements2
	}, function(data5, menu5)
		ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'shops_pr_cijenu',
			{
			title = "Unesite novu cijenu proizvoda"
			},
			function(data6, menu6)
			menu5.close()
			local count = tonumber(data6.value)

			if count == nil then
				ESX.ShowNotification("Kriva vrijednost!")
			else
				menu6.close()
				TriggerServerEvent("esx_firme:PromjeniCijenu", zone, st, data5.current.item, count)
				Wait(1000)
				OpenCijeneMenu(zone, st, tip)
			end
			end,
			function(data6, menu6)
			menu6.close()
			end
		)
	end, function(data5, menu5)
		menu5.close()
		HasAlreadyEnteredMarker = false
	end)
end

RegisterNetEvent('firme:PosaljiFirme')
AddEventHandler('firme:PosaljiFirme', function(fir)
	Firme = fir
	SpawnCpove()
	ReloadBlip()
end)

RegisterNetEvent('trgovine:PitajProdaju')
AddEventHandler('trgovine:PitajProdaju', function(ime, cijena, pid)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'trgovara',
		{
				title    = "Zelite li kupiti trgovinu "..ime.." za $"..cijena.."?",
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
		},
		function(data69, menu69)
			menu69.close()
			if data69.current.value == 'da' then
				TriggerServerEvent("trgovine:PrihvatioProdaju", ime, cijena, pid)
			end

			if data69.current.value == 'ne' then
				ESX.ShowNotification("Odbili ste ponudu za kupnju trgovine!")
				TriggerServerEvent("trgovine:OdbioProdaju", pid)
				menu69.close()
			end
		end,
		function(data69, menu69)
			 menu69.close()
		end
	)
end)

function OpenShopMenu3()
	HasPaid = false
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		local lova = 50
		if #NoveCijene > 0 then
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == CurrentID and NoveCijene[j].item == "odjeca" then
					lova = NoveCijene[j].cijena
				end
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = _U('valid_this_purchase').." odjecu za "..lova.."$?",
			align = 'top-left',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('roba:KaeTuljani', function(bought)
					if bought then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						HasPaid = true

						ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
							if foundStore then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
								{
									title = _U('save_in_dressing'),
									align = 'top-left',
									elements = {
										{label = _U('no'),  value = 'no'},
										{label = _U('yes'), value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = _U('name_outfit')
										}, function(data3, menu3)
											menu3.close()

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
											end)

											ESX.ShowNotification(_U('saved_outfit'))
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								end)
							end
						end)

					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)

						ESX.ShowNotification(_U('not_enough_money'))
					end
				end, CurrentID)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			HasAlreadyEnteredMarker = false
		end, function(data, menu)
			menu.close()

			HasAlreadyEnteredMarker = false
		end)

	end, function(data, menu)
		menu.close()

		HasAlreadyEnteredMarker = false
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'helmet_1',
		'helmet_2',
		'bags_1',
		'glasses_1',
		'glasses_2'
	})

end

function OpenShopMenu2()

	HasPaid = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()
		local lova = 50
		if #NoveCijene > 0 then
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == CurrentID and NoveCijene[j].item == "sisanje" then
					lova = NoveCijene[j].cijena
				end
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase').. " odjecu za "..lova.."$?",
				align = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			},
			function(data, menu)
				menu.close()

				if data.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
						if hasEnoughMoney then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							TriggerServerEvent('sisanje:tuljanizacija', CurrentID)

							HasPaid = true
						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin) 
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						end
					end, CurrentID)

				elseif data.current.value == 'no' then

					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin) 
					end)

				end

				HasAlreadyEnteredMarker = false
			end, function(data, menu)
				menu.close()

				HasAlreadyEnteredMarker = false
			end)

	end, function(data, menu)
			menu.close()

			HasAlreadyEnteredMarker = false
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'ears_1',
		'ears_2',
	})

end

function OpenShopMenu4(tip)
	local elements = {}
	local st = CurrentID
	local lova = 0
	local zone = "TwentyFourSeven"
	ESX.TriggerServerCallback('esx_firme:DajSef', function(lov)
		lova = lov
	end, st)
	Wait(400)
	local cij = 0
	local tip = 0
	local kljuc = 0
	local posao = 0
	for i=1, #Firme, 1 do
		if Firme[i] ~= nil and Firme[i].Ime == st then
			cij = Firme[i].Cijena
			tip = Firme[i].Tip
			kljuc = Firme[i].Zakljucana
			posao = Firme[i].Posao
		end
	end
	ESX.TriggerServerCallback('esx_firme:DajDostupnost', function(jelje)
		if jelje == 1 then
			table.insert(elements, {
				label      = "Kupite firmu ($"..cij..")",
				label_real = "kupi",
				item       = "kupit",
				price      = cij,
			})
		else
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
					if jelje2 == 1 then
						if tip ~= 69 then
							table.insert(elements, {
								label      = "Podignite novac $"..lova,
								label_real = "podigni",
								item       = "podignin",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Promjenite cijene proizvoda",
								label_real = "prcijene",
								item       = "prc",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Prodaj igracu",
								label_real = "prodaj2",
								item       = "prodajt2",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Prodaj ($"..math.floor(cij/2)..")",
								label_real = "prodaj",
								item       = "prodajt",
								price      = 0,
							})
						end
						--[[if kljuc == 0 then
							table.insert(elements, {
								label      = "Izaberite tip firme",
								label_real = "tipfirme",
								item       = "tip",
								price      = 0,
							})
						end]]
						if tip == 1 then
							table.insert(elements, {
								label      = "Naruci proizvode",
								label_real = "narpr2",
								item       = "naruci2",
								price      = 0,
							})
						end
						if tip == 4 then
							table.insert(elements, {
								label      = "Naruci proizvode",
								label_real = "narpr",
								item       = "naruci",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Napravi proizvode",
								label_real = "narpra",
								item       = "napravipr",
								price      = 0,
							})
						end
						if tip == 5 then
							table.insert(elements, {
								label      = "Pregledaj narudzbe",
								label_real = "narpra",
								item       = "pnar",
								price      = 0,
							})
						end
						if posao == 1 then
							table.insert(elements, {
								label      = "Upravljanje radnicima",
								label_real = "popradnika",
								item       = "radnici",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Upravljanje skladistem",
								label_real = "stskladiste",
								item       = "skladiste",
								price      = 0,
							})
						end
						if #elements == 0 then
							table.insert(elements, {
								label      = "GRESKA! Pozovite admina",
								label_real = "greska",
								item       = "gr",
								price      = 0,
							})
						end
					else
						table.insert(elements, {
							label      = "Pregledaj narudzbe",
							label_real = "narpra",
							item       = "pnar",
							price      = 0,
						})
					end
			end, st)
		end
	end, st)
	Wait(1000)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.item == 'kupit' then
			TriggerServerEvent('ducan:piku2', zone, CurrentID)
			menu.close()
			HasAlreadyEnteredMarker = false
		elseif data.current.item == 'podignin' then
			ESX.UI.Menu.Open(
			  'dialog', GetCurrentResourceName(), 'shops_daj_lovu',
			  {
				title = "Unesite koliko novca zelite podici"
			  },
			  function(data3, menu3)

				local count = tonumber(data3.value)

				if count == nil then
					ESX.ShowNotification("Kriva vrijednost!")
				elseif lova < count then
					ESX.ShowNotification("Nemate toliko u sefu!")
				else
					menu3.close()
					menu.close()
					TriggerServerEvent("esx_firme:OduzmiFirmi", st, count)
					HasAlreadyEnteredMarker = false
				end

			  end,
			  function(data3, menu3)
				menu3.close()
			  end
			)
		elseif data.current.item == 'prodajt' then
			menu.close()
			TriggerServerEvent("esx_firme:ProdajFirmu", st)
		elseif data.current.item == "tip" then
			local elements2 = {}
			
			table.insert(elements2, {label = "Otvori trgovinu", value = "1"})
			table.insert(elements2, {label = "Otvori frizerski", value = "2"})
			table.insert(elements2, {label = "Otvori salon odjece", value = "3"})
			table.insert(elements2, {label = "Otvori tuning shop", value = "4"})
			table.insert(elements2, {label = "Otvori rudarsku firmu", value = "5"})

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'listarankova',
			  {
				title    = "Izaberite opciju",
				align    = 'bottom-right',
				elements = elements2,
			  },
			  function(datalr, menulr)
				local br = datalr.current.value
				TriggerServerEvent("firme:PostaviTip", CurrentID, br, true)
			  end,
			  function(datalr, menulr)
				menulr.close()
			  end
			)
		elseif data.current.item == "napravipr" then
			local elements2 = {}
			table.insert(elements2, {label = "Napravi filter -> 100 zeljeza", value = "filter"})
			table.insert(elements2, {label = "Napravi auspuh -> 200 zeljeza", value = "auspuh"})
			table.insert(elements2, {label = "Napravi elektroniku -> 120 zeljeza", value = "elektronika"})
			table.insert(elements2, {label = "Napravi turbo -> 300 zeljeza", value = "turbo"})
			table.insert(elements2, {label = "Napravi intercooler -> 400 zeljeza", value = "intercooler"})
			table.insert(elements2, {label = "Napravi fuel injectore -> 220 zeljeza", value = "finjectori"})
			table.insert(elements2, {label = "Napravi fuel injectore -> 320 zeljeza", value = "kvacilo"})
			table.insert(elements2, {label = "Napravi kovani motor -> 1000 zeljeza", value = "kmotor"})

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'listarankovafds',
			  {
				title    = "Izaberite proizvod",
				align    = 'bottom-right',
				elements = elements2,
			  },
			  function(datalr, menulr)
				local br = datalr.current.value
				TriggerServerEvent("firme:Kraftaj", CurrentTrgID, br)
			  end,
			  function(datalr, menulr)
				menulr.close()
			  end
			)
		elseif data.current.item == "naruci" then
			ESX.TriggerServerCallback('esx_firme:DajDobavljace', function(dob)
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'gdhfrgb',
					{
						title    = "Popis dobavljaca",
						align    = 'bottom-right',
						elements = dob,
					},
					function(datalr2, menulr2)
						ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'shops_daj_lovuahfd',
						{
							title = "Unesite kolicinu koju zelite naruciti"
						},
						function(data9, menu9)

							local counte = tonumber(data9.value)

							if counte == nil then
								ESX.ShowNotification("Kriva vrijednost!")
							else
								TriggerServerEvent("esx_firme:NaruciRobu", CurrentTrgID, counte, datalr2.current.value, datalr2.current.cijena)
								menu9.close()
								menulr2.close()
							end
						end,
						function(data9, menu9)
							menu9.close()
						end
						)
					end,
					function(datalr2, menulr2)
						menulr2.close()
					end
				  )
			end, tip)
		elseif data.current.item == "naruci2" then
			ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'shops_daj_lovuahfdaa',
			{
				title = "Unesite kolicinu koju zelite naruciti"
			},
			function(data9, menu9)

				local counte = tonumber(data9.value)

				if counte == nil then
					ESX.ShowNotification("Kriva vrijednost!")
				else
					TriggerServerEvent("esx_firme:NaruciRobu2", CurrentTrgID, counte, 100)
					menu9.close()
				end
			end,
			function(data9, menu9)
				menu9.close()
			end
			)
		elseif data.current.item == "radnici" then
			local elements2 = {}
			
			table.insert(elements2, {label = "Popis radnika", value = "1"})
			table.insert(elements2, {label = "Zaposli radnika", value = "2"})
			table.insert(elements2, {label = "Otpusti radnika", value = "3"})

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'listarankova',
			  {
				title    = "Izaberite opciju",
				align    = 'bottom-right',
				elements = elements2,
			  },
			  function(datalr, menulr)
				local br = datalr.current.value
				if br == "1" then
					ESX.TriggerServerCallback('esx_firme:DajRadnike', function(rad)
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'adfdf',
							{
								title    = "Popis radnika",
								align    = 'bottom-right',
								elements = rad,
							},
							function(datalr2, menulr2)
								menulr2.close()
							end,
							function(datalr2, menulr2)
								menulr2.close()
							end
					  	)
					end, CurrentTrgID)
				elseif br == "2" then
					ESX.TriggerServerCallback('esx_firme:getOnlinePlayers', function(rad)
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'fdsf',
							{
								title    = "Popis radnika",
								align    = 'bottom-right',
								elements = rad,
							},
							function(datalr2, menulr2)
								TriggerServerEvent("esx_firme:Zaposli", CurrentTrgID, datalr2.current.value)
								menulr2.close()
							end,
							function(datalr2, menulr2)
								menulr2.close()
							end
					  	)
					end, CurrentTrgID)
				elseif br == "3" then
					ESX.TriggerServerCallback('esx_firme:DajRadnike', function(rad)
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'gfdgfd',
							{
								title    = "Popis radnika",
								align    = 'bottom-right',
								elements = rad,
							},
							function(datalr2, menulr2)
								TriggerServerEvent("esx_firme:Otpusti", datalr2.current.value)
								menulr2.close()
							end,
							function(datalr2, menulr2)
							menulr2.close()
							end
					  	)
					end, CurrentTrgID)
				end
			  end,
			  function(datalr, menulr)
				menulr.close()
			  end
			)
		elseif data.current.item == "pnar" then
			ESX.TriggerServerCallback('esx_firme:DajNarudzbe', function(nar)
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'adfdfaa',
					{
						title    = "Popis narudzbi",
						align    = 'bottom-right',
						elements = nar,
					},
					function(datalr2, menulr2)
						TriggerServerEvent("esx_firme:ZapocniNarudzbu", datalr2.current.value, CurrentTrgID, datalr2.current.kolicina, datalr2.current.firma)
						menulr2.close()
					end,
					function(datalr2, menulr2)
						menulr2.close()
					end
				)
			end, CurrentTrgID)
		elseif data.current.item == "skladiste" then
			local elements2 = {}
			
			table.insert(elements2, {label = "Stanje skladista", value = "1"})
			table.insert(elements2, {label = "Uzmi iz skladista", value = "2"})
			table.insert(elements2, {label = "Spremi u skladiste", value = "3"})

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'sdgfsdfg',
			  {
				title    = "Izaberite opciju",
				align    = 'bottom-right',
				elements = elements2,
			  },
			  function(datalr, menulr)
				local br = datalr.current.value
				if br == "1" then
					ESX.TriggerServerCallback('esx_firme:DajSkladiste', function(stanje)
						ESX.ShowNotification("Stanje skladista: "..stanje)
					end, CurrentTrgID)
				elseif br == "2" then
					ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'shops_daj_lovua',
					{
						title = "Unesite koliku kolicinu zelite podici"
					},
					function(data3, menu3)

						local count = tonumber(data3.value)

						if count == nil then
							ESX.ShowNotification("Kriva vrijednost!")
						else
							menu3.close()
							TriggerServerEvent("esx_firme:OduzmiSkladiste", CurrentTrgID, count, CurrentTip)
						end
					end,
					function(data3, menu3)
						menu3.close()
					end
					)
				elseif br == "3" then
					ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'shops_daj_lovuaa',
					{
						title = "Unesite koliku kolicinu zelite ostaviti"
					},
					function(data3, menu3)

						local count = tonumber(data3.value)

						if count == nil then
							ESX.ShowNotification("Kriva vrijednost!")
						else
							menu3.close()
							TriggerServerEvent("esx_firme:DajSkladistu", CurrentTrgID, count, CurrentTip)
						end
					end,
					function(data3, menu3)
						menu3.close()
					end
					)
				end
			  end,
			  function(datalr, menulr)
				menulr.close()
			  end
			)
		elseif data.current.item == 'prodajt2' then
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'trg_prodaj_igr',
					{
						title = "Unesite cijenu za koju zelite prodati trgovinu"
					},
					function(data3, menu3)

					local count = tonumber(data3.value)

					if count == nil then
						ESX.ShowNotification("Kriva vrijednost!")
					else
						menu3.close()
						menu.close()
						TriggerServerEvent("trgovine:ProdajIgracu", st, GetPlayerServerId(player), count)
					end
					end,
					function(data3, menu3)
						menu3.close()
						menu.close()
					end
				)
			else
				ESX.ShowNotification('Nema igraca u blizini!')
			end
		elseif data.current.item == 'prc' then
			menu.close()
			OpenCijeneMenu(zone, st, tip)
		end
	end, function(data, menu)
		menu.close()
		HasAlreadyEnteredMarker = false
	end)
end

RegisterNetEvent('firme:UpdateTekst')
AddEventHandler('firme:UpdateTekst', function(br, item, st)
	local br2 = 0
	for j = 1, #Firme, 1 do
		if Firme[j].Ime == st then
			for k = 1, #Firme[j].Proizvodi, 1 do
				if Firme[j].Proizvodi[k].Item == item.name then
					br2 = Firme[j].Proizvodi[k].Stanje
				end
			end
		end
	end
	local label = "["..br2.."] "..item.label
	SendNUIMessage({
		updateitem = true,
		br = br,
		label = label
	})
end)

RegisterNetEvent('firme:UpdateTekst2')
AddEventHandler('firme:UpdateTekst2', function(br, item, st)
	local br2 = 0
	for j = 1, #Firme, 1 do
		if Firme[j].Ime == st then
			br2 = Firme[j].Skladiste
			break
		end
	end
	local label = "["..br2.."] "..item.label
	SendNUIMessage({
		updateitem = true,
		br = br,
		label = label
	})
end)

RegisterNUICallback(
    "kupi",
    function(data, cb)
		if data.ime ~= nil then
			if data.stanje > 0 then
				local torba = 0
				TriggerEvent('skinchanger:getSkin', function(skin)
					torba = skin['bags_1']
				end)
				if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
					TriggerServerEvent('ducan:piku', data.ime, 1, data.zone, data.trg, true, data.br)
				else
					TriggerServerEvent('ducan:piku', data.ime, 1, data.zone, data.trg, false, data.br)
				end
			else
				ESX.ShowNotification("Nemamo tog proizvoda na stanju!")
			end
		end
    end
)

RegisterNUICallback(
    "zatvori",
    function(data, cb)
		SetNuiFocus(false)
    end
)

function OpenShopMenu()
	local elements = {}
	local zone = "TwentyFourSeven"
	local st = CurrentID
	SendNUIMessage({
		ocisti = true
	})
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]
		local br = 0
		for j = 1, #Firme, 1 do
			if Firme[j].Ime == st then
				br = Firme[j].Skladiste
				break
			end
		end
		local label = "["..br.."] "..item.label
		if #NoveCijene > 0 then
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
					item.price = NoveCijene[j].cijena
				end
			end
		end
		SendNUIMessage({
			dodajitem = true,
			naziv = label,
			cijena = item.price,
			ime = item.item,
			trg = st,
			zone = zone,
			stanje = br
		})
	end
	Wait(500)

	ESX.UI.Menu.CloseAll()
	SendNUIMessage({
		prikazi = true
	})
	SetNuiFocus(true, true)
	--[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local torba = 0
				TriggerEvent('skinchanger:getSkin', function(skin)
					torba = skin['bags_1']
				end)
				if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
					TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, true)
				else
					TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, false)
				end
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		HasAlreadyEnteredMarker = false
	end)]]
end

function OpenShopMenu5()
	local elements = {}
	local zone = "TuningShop"
	local st = CurrentID
	SendNUIMessage({
		ocisti = true
	})
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]
		local br = 0
		for j = 1, #Firme, 1 do
			if Firme[j].Ime == st then
				for k = 1, #Firme[j].Proizvodi, 1 do
					if Firme[j].Proizvodi[k].Item == item.item then
						br = Firme[j].Proizvodi[k].Stanje
					end
				end
			end
		end
		local label = "["..br.."] "..item.label
		if #NoveCijene > 0 then
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
					item.price = NoveCijene[j].cijena
				end
			end
		end
		SendNUIMessage({
			dodajitem = true,
			naziv = label,
			cijena = item.price,
			ime = item.item,
			trg = st,
			zone = zone,
			stanje = br
		})
	end
	Wait(500)

	ESX.UI.Menu.CloseAll()
	SendNUIMessage({
		prikazi = true
	})
	SetNuiFocus(true, true)
	--[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local torba = 0
				TriggerEvent('skinchanger:getSkin', function(skin)
					torba = skin['bags_1']
				end)
				if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
					TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, true)
				else
					TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, false)
				end
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		HasAlreadyEnteredMarker = false
	end)]]
end

AddEventHandler('esx_firme:hasEnteredMarker', function(zone, id, tip, cpid, trgid)
	CurrentAction     = zone
	if zone == "vlasnik_menu" then
		CurrentActionMsg  = "pritisnite ~INPUT_CONTEXT~ da otvorite izbornik ~y~vlasnika~s~."
	elseif zone == "ulaz_menu" then
		CurrentActionMsg  = "pritisnite ~INPUT_CONTEXT~ da udjete u trgovinu"
	elseif zone == "izlaz_menu" then
		CurrentActionMsg  = "pritisnite ~INPUT_CONTEXT~ da izadjete iz trgovine"
	else
		CurrentActionMsg  = _U('press_menu')
	end
	CurrentActionData = {zone = zone}
	CurrentID = id
	CurrentTip = tip
	CurrentCpID = cpid
	CurrentTrgID = trgid
end)

AddEventHandler('esx_firme:hasExitedMarker', function(zone)
	CurrentAction = nil
	CurrentTip = nil
	ESX.UI.Menu.CloseAll()
	if not HasPaid then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin) 
		end)
	end
end)

function ReloadBlip()
	while ESX == nil do
		Wait(0)
	end
	for i = 1, #Firme, 1 do
		local st = Firme[i].Ime
		local koord = Firme[i].VlasnikKoord
		if Firme[i].Kupovina then
			koord = Firme[i].Kupovina
		end
		if Firme[i].Ulaz then
			koord = Firme[i].Ulaz
		end
		if Firme[i].Tip == 1 then
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					RemoveBlip(blip[st])
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 52)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('shops'))
					EndTextCommandSetBlipName(blip[st])
				else
					RemoveBlip(blip[st])
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 52)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 2)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('shops'))
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		elseif Firme[i].Tip == 2 then
			RemoveBlip(blip[st])
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 71)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('barber_blip'))
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 71)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 51)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('barber_blip'))
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		elseif Firme[i].Tip == 3 then
			RemoveBlip(blip[st])
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 73)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('clothes'))
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 73)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 47)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('clothes'))
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		elseif Firme[i].Tip == 4 then
			RemoveBlip(blip[st])
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 779)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Tuning shop")
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 779)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 47)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Tuning shop")
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		elseif Firme[i].Tip == 5 then
			RemoveBlip(blip[st])
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 762)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Rudarska firma")
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 762)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 47)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Rudarska firma")
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		elseif Firme[i].Tip == 69 then
			RemoveBlip(blip[st])
			ESX.TriggerServerCallback('esx_firme:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 374)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Firma "..i)
					EndTextCommandSetBlipName(blip[st])
				else
					blip[st] = AddBlipForCoord(koord)
					SetBlipSprite (blip[st], 374)
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 2)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Firma na prodaju")
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		end
	end
end

RegisterNetEvent('esx_firme:DostaviRobu')
AddEventHandler('esx_firme:DostaviRobu', function(id, br, firma, dost)
	local coordsa = GetEntityCoords(PlayerPedId())
	local found, coords, heading = GetClosestVehicleNodeWithHeading(coordsa.x, coordsa.y, coordsa.z, 4, 10.0, 0)
	if found then
		SetEntityCoords(PlayerPedId(), coords)
		SetEntityHeading(PlayerPedId(), heading)
		ESX.Game.SpawnVehicle("mule", {
			x = coords.x,
			y = coords.y,
			z = coords.z
		}, heading, function(callback_vehicle)
			Vozilo = callback_vehicle
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		end)
		local koord
		local Dostavlja = true
		local Vraca = false
		for i = 1, #Firme, 1 do
			if Firme[i].TrgID == firma then
				koord = Firme[i].Kupovina
				if Firme[i].Ulaz then
					koord = Firme[i].Ulaz
				end
				break
			end
		end
		local found2, coords2, heading2 = GetClosestVehicleNodeWithHeading(koord.x, koord.y, koord.z, 4, 10.0, 0)
		if found2 then
			Blipara = AddBlipForCoord(coords2.x, coords2.y, coords2.z)
			SetBlipSprite(Blipara, 1)
			SetBlipColour (Blipara, 5)
			SetBlipAlpha(Blipara, 255)
			SetBlipRoute(Blipara,  true)
			Citizen.CreateThread(function()
				while Dostavlja do
					Citizen.Wait(1)
					local coordse = GetEntityCoords(GetPlayerPed(-1))
					if Vraca == false then
						if #(coordse-coords2) < 100 then
							DrawMarker(1, coords2.x, coords2.y, coords2.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
						end
						if #(coordse-coords2) < 3 then
							ESX.ShowNotification("Dostavili ste robu, vratite kamion do firme")
							RemoveBlip(Blipara)
							Blipara = nil
							Vraca = true
							TriggerServerEvent("esx_firme:ZavrsiDostavu", id, firma, dost)
						end
					else
						if Blipara == nil then
							Blipara = AddBlipForCoord(coords.x, coords.y, coords.z)
							SetBlipSprite(Blipara, 1)
							SetBlipColour (Blipara, 5)
							SetBlipAlpha(Blipara, 255)
							SetBlipRoute(Blipara,  true)
						end
						if #(coordse-coords) < 100 then
							DrawMarker(1, coords.x, coords.y, coords.z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
						end
						if #(coordse-coords) < 3 then
							ESX.ShowNotification("Vratili ste kamion u firmu.")
							RemoveBlip(Blipara)
							ESX.Game.DeleteVehicle(Vozilo)
							Vozilo = nil
							Blipara = nil
							Dostavlja = false
						end
					end
				end
			end)
		end
	end
end)

RegisterNetEvent('firme:PortGa')
AddEventHandler('firme:PortGa', function(coord)
	SetEntityCoords(PlayerPedId(), coord)
end)

RegisterNetEvent('elektricar:NemaStruje')
AddEventHandler('elektricar:NemaStruje', function(br)
	NemaStruje = br
end)

RegisterNetEvent('esx_firme:ReloadBlip')
AddEventHandler('esx_firme:ReloadBlip', function()
	ReloadBlip()
end)

RegisterNetEvent('esx_firme:UpdateCijene')
AddEventHandler('esx_firme:UpdateCijene', function(cij)
	NoveCijene = cij
end)

function SpawnCpove()
	if #Cpovi > 0 then
		for i=1, #Cpovi, 1 do
		  	if Cpovi[i] ~= nil then
			  	if Cpovi[i].Spawnan then
					DeleteCheckpoint(Cpovi[i].ID)
					Cpovi[i].Spawnan = false
			  	end
		  	end
		end
	end
	Cpovi = {}
	for i=1, #Firme, 1 do
		local lab = "kurac"
		local tp = 69
		if Firme[i].Tip == 1 then
			lab = "shop_menu"
			tp = 1
		elseif Firme[i].Tip == 2 then
			lab = "frizerski_menu"
			tp = 2
		elseif Firme[i].Tip == 3 then
			lab = "odjeca_menu"
			tp = 3
		elseif Firme[i].Tip == 4 then
			lab = "tuning_menu"
			tp = 4
		end
		local svijet = 0
		if Firme[i].Ulaz then
			svijet = Firme[i].TrgID
		end
		if Firme[i].Kupovina then
			table.insert(Cpovi, {fID = Firme[i].TrgID, Ime = lab, ImeF = Firme[i].Label, Trgovina = Firme[i].Ime, ID = check, Koord = Firme[i].Kupovina, Spawnan = false, r = Config.Color.r, g = Config.Color.g, b = Config.Color.b, Tip = tp, Svijet = svijet})
		end
		if Firme[i].Ulaz then
			table.insert(Cpovi, {fID = Firme[i].TrgID, Ime = "ulaz", ImeF = Firme[i].Label, Trgovina = Firme[i].Ime, ID = check, Koord = Firme[i].Ulaz, Spawnan = false, r = Config.Color.r, g = Config.Color.g, b = Config.Color.b, Tip = 68, Izlaz = Firme[i].Izlaz, Svijet = svijet})
		end
		if Firme[i].Izlaz then
			table.insert(Cpovi, {fID = Firme[i].TrgID, Ime = "izlaz", ImeF = Firme[i].Label, Trgovina = Firme[i].Ime, ID = check, Koord = Firme[i].Izlaz, Spawnan = false, r = Config.Color.r, g = Config.Color.g, b = Config.Color.b, Tip = 68, Ulaz = Firme[i].Ulaz, Svijet = svijet})
		end
		if Firme[i].VlasnikKoord then
			table.insert(Cpovi, {fID = Firme[i].TrgID, Ime = "vlasnik", ImeF = Firme[i].Label, Trgovina = Firme[i].Ime, ID = check, Koord = Firme[i].VlasnikKoord, Spawnan = false, r = Config.Color.r, g = Config.Color.g, b = Config.Color.b, Tip = tp, Svijet = svijet})
		end
	end
end

-- Enter / Exit marker events
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local nasosta = 0
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		local ID = nil
		local Tip = nil
		local cpid = nil
		local TrgID = nil

		if #Cpovi > 0 then
			for i=1, #Cpovi, 1 do
			  if Cpovi[i] ~= nil then
				if #(coords-Cpovi[i].Koord) > 100 then
				  if Cpovi[i].Spawnan then
					DeleteCheckpoint(Cpovi[i].ID)
					Cpovi[i].Spawnan = false
				  end
				else
				  if Cpovi[i].Spawnan == false and (Cpovi[i].Ime == "ulaz" or Cpovi[i].Svijet == Bucket) then
					if Cpovi[i].Ime ~= "kurac" then
						local kord = Cpovi[i].Koord
						local range = 2.0
						if Cpovi[i].Ime == "ulaz" or Cpovi[i].Ime == "izlaz" then
							range = 1.0
						end
						local check = CreateCheckpoint(47, kord.x, kord.y, kord.z, 0, 0, 0, range, Cpovi[i].r, Cpovi[i].g, Cpovi[i].b, 100)
						SetCheckpointCylinderHeight(check, range, range, range)
						Cpovi[i].ID = check
						Cpovi[i].Spawnan = true
					end
				  end
				end
			  end
			end
			for i=1, #Cpovi, 1 do
			  if Cpovi[i] ~= nil and Cpovi[i].Spawnan then
				if #(coords-Cpovi[i].Koord) < 1.5 then
					if Cpovi[i].Ime == "shop_menu" then
						isInMarker  = true
						ShopItems   = Cpovi[i].Trgovina.Items
						currentZone = "shop_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Tip
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						break
					elseif Cpovi[i].Ime == "frizerski_menu" then
						isInMarker  = true
						currentZone = "frizerski_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Tip
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						TriggerEvent("dpc:EquipLast")
						break
					elseif Cpovi[i].Ime == "odjeca_menu" then
						isInMarker  = true
						currentZone = "odjeca_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Tip
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						TriggerEvent("dpc:EquipLast")
						break
					elseif Cpovi[i].Ime == "tuning_menu" then
						isInMarker  = true
						currentZone = "tuning_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Tip
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						break
					elseif Cpovi[i].Ime == "vlasnik" then
						isInMarker  = true
						currentZone = "vlasnik_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Tip
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						break
					elseif Cpovi[i].Ime == "ulaz" then
						isInMarker  = true
						currentZone = "ulaz_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Izlaz
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						break
					elseif Cpovi[i].Ime == "izlaz" then
						isInMarker  = true
						currentZone = "izlaz_menu"
						LastZone    = i
						ID = Cpovi[i].Trgovina
						Tip = Cpovi[i].Ulaz
						cpid = Cpovi[i].Svijet
						TrgID = Cpovi[i].fID
						break
					end
				end
			  end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_firme:hasEnteredMarker', currentZone, ID, Tip, cpid, TrgID)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_firme:hasExitedMarker', LastZone)
		end
		
		if nasosta == 0 then
			waitara = 500
		end
	end
end)

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		ReloadBlip()
		PrviSpawn = true
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					if not NemaStruje then
						OpenShopMenu()
					else
						ESX.ShowNotification("Ne mozemo vam naplatiti trenutno posto nema struje.")
					end
				end
				if CurrentAction == 'frizerski_menu' then
					if not NemaStruje then
						OpenShopMenu2()
					else
						ESX.ShowNotification("Ne mozemo vam naplatiti trenutno posto nema struje.")
					end
				end
				if CurrentAction == 'odjeca_menu' then
					if not NemaStruje then
						OpenShopMenu3()
					else
						ESX.ShowNotification("Ne mozemo vam naplatiti trenutno posto nema struje.")
					end
				end
				if CurrentAction == 'tuning_menu' then
					if not NemaStruje then
						OpenShopMenu5()
					else
						ESX.ShowNotification("Ne mozemo vam naplatiti trenutno posto nema struje.")
					end
				end
				if CurrentAction == 'vlasnik_menu' then
					if not NemaStruje then
						OpenShopMenu4(CurrentTip)
					else
						ESX.ShowNotification("Ne mozemo vam naplatiti trenutno posto nema struje.")
					end
				end
				if CurrentAction == 'ulaz_menu' then
					if CurrentTip ~= nil then
						TriggerServerEvent("firme:PostaviBucket", CurrentCpID)
						Bucket = CurrentCpID
						SetEntityCoords(PlayerPedId(), CurrentTip)
					else
						ESX.ShowNotification("Firmi nije postavljen ulaz, zovi admina!")
					end
				end
				if CurrentAction == 'izlaz_menu' then
					TriggerServerEvent("firme:PostaviBucket", 0)
					Bucket = 0
					SetEntityCoords(PlayerPedId(), CurrentTip)
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
