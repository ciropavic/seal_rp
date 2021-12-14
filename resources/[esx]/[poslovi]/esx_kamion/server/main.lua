ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Objekti = {}

RegisterServerEvent('kamiooon:platituljanu')
AddEventHandler('kamiooon:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == "kamion" then
		xPlayer.addMoney(1450)
		TriggerEvent("biznis:StaviUSef", "kamion", math.ceil(1450*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac kamiondzije, a nije zaposlen kao kamiondzija!")
	    TriggerEvent("AntiCheat:Citer", _source)
	end
end)

RegisterServerEvent('kamiooon:platituljanu2')
AddEventHandler('kamiooon:platituljanu2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == "kamion" then
		xPlayer.addMoney(2000)
		TriggerEvent("biznis:StaviUSef", "kamion", math.ceil(2000*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac kamiondzije, a nije zaposlen kao kamiondzija!")
	    TriggerEvent("AntiCheat:Citer", _source)
	end
end)

RegisterServerEvent('kamion:PosaljiObjekte')
AddEventHandler('kamion:PosaljiObjekte', function(obj)
	for i=1, #obj, 1 do
		if obj[i] ~= nil then
			table.insert(Objekti, {ID = obj[i].ID, Obj1 = obj[i].Obj1})
		end
	end
end)

RegisterServerEvent('kamion:MaknutObjekt')
AddEventHandler('kamion:MaknutObjekt', function(id)
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == id then
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i] = nil
			break
		end
	end
end)

AddEventHandler('playerDropped', function()
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == source then
			TriggerClientEvent("kamion:ObrisiObjekte", -1, Objekti[i].Obj1)
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i] = nil
			break
		end
	end
end)
