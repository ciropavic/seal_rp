ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vodaa:platituljanu')
AddEventHandler('vodaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.posao.name == 'vodoinstalater' then
		xPlayer.addMoney(850)
		TriggerEvent("biznis:StaviUSef", "vodoinstalater", math.ceil(850*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac vodoinstalatera, a nije zaposlen kao vodoinstalater!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
