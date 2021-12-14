ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vatraaa:platituljanu')
AddEventHandler('vatraaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'vatrogasac' then
		xPlayer.addMoney(220)
		TriggerEvent("biznis:StaviUSef", "vatrogasac", math.ceil(220*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac vatrogasaca, a nije zaposlen kao vatrogasac!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
