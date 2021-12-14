ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Vozila = {}

RegisterServerEvent('gradjevinar:tuljaniplivaju')
AddEventHandler('gradjevinar:tuljaniplivaju', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'gradjevinar' then
		xPlayer.addMoney(60)
		TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(60*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac gradjevinara, a nije zaposlen kao gradjevinar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

RegisterServerEvent('gradjevinar:tuljaniplivaju2')
AddEventHandler('gradjevinar:tuljaniplivaju2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'gradjevinar' then
		xPlayer.addMoney(50)
		TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(50*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac gradjevinara, a nije zaposlen kao gradjevinar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

RegisterServerEvent('gradjevinar:Penali')
AddEventHandler('gradjevinar:Penali', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'gradjevinar' then
		xPlayer.removeMoney(1000)
		TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(1000*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac gradjevinara, a nije zaposlen kao gradjevinar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

AddEventHandler('playerDropped', function()
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil and Vozila[i].Vlasnik == source then
			DeleteEntity(NetworkGetEntityFromNetworkId(Vozila[i].Nid))
			DeleteEntity(NetworkGetEntityFromNetworkId(Vozila[i].Nid2))
			table.remove(Vozila, i)
			break
		end
	end
end)

RegisterServerEvent('gradjevinar:SpremiNetID')
AddEventHandler('gradjevinar:SpremiNetID', function(nid, nid2)
	local _source = source
	local naso = 0
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil and Vozila[i].Vlasnik == _source then
			Vozila[i].Nid = nid
			Vozila[i].Nid2 = nid2
			naso = 1
			break
		end
	end
	if naso == 0 then
		table.insert(Vozila, {Vlasnik = _source, Nid = nid, Nid2 = nid2})
	end
end)

RegisterServerEvent('gradjevinar:ObrisiVozila')
AddEventHandler('gradjevinar:ObrisiVozila', function()
	local _source = source
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil and Vozila[i].Vlasnik == _source then
			DeleteEntity(NetworkGetEntityFromNetworkId(Vozila[i].Nid))
			DeleteEntity(NetworkGetEntityFromNetworkId(Vozila[i].Nid2))
			table.remove(Vozila, i)
			break
		end
	end
end)
