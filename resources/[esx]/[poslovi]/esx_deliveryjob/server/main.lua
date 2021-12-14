ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_delivererposo:platiljantu')
AddEventHandler('esx_delivererposo:platiljantu', function(dest)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'deliverer' then
		xPlayer.addMoney(tonumber(dest.Paye))
		TriggerEvent("biznis:StaviUSef", "deliverer", math.ceil(tonumber(dest.Paye)*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac dostavljaca, a nije zaposlen kao dostavljac!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
