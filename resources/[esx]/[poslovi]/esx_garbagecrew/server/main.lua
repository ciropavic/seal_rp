ESX = nil
passanger1 = nil
passanger2 = nil
passanger3 = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('smetlar:platimtikurac')
AddEventHandler('smetlar:platimtikurac', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.posao.name == 'garbage' then
	    local payamount = math.ceil(amount)
	    xPlayer.addMoney(tonumber(payamount))
        TriggerEvent("biznis:StaviUSef", "garbage", math.ceil(tonumber(payamount)*0.30))
	    TriggerClientEvent('esx:showNotification', source, '~s~Dobili ste~g~ '..payamount..' ~s~od praznjenja ovog kontenjera~s~!')
    else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac smetlara, a nije zaposlen kao smetlar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

RegisterServerEvent('esx_garbagejob:binselect')
AddEventHandler('esx_garbagejob:binselect', function(binpos, platenumber, bagnumb)
	TriggerClientEvent('esx_garbagejob:setbin', -1, binpos, platenumber,  bagnumb)
end)

RegisterServerEvent('smetlar:dajpare')
AddEventHandler('smetlar:dajpare', function(platenumber, amount)
	TriggerClientEvent('smetlar:startajga', -1, platenumber, amount)
end)

RegisterServerEvent('esx_garbagejob:bagremoval')
AddEventHandler('esx_garbagejob:bagremoval', function(platenumber)
	TriggerClientEvent('esx_garbagejob:removedbag', -1, platenumber)

end)

RegisterServerEvent('esx_garbagejob:endcollection')
AddEventHandler('esx_garbagejob:endcollection', function(platenumber)
	TriggerClientEvent('esx_garbagejob:clearjob', -1, platenumber)
end)

RegisterServerEvent('esx_garbagejob:reportbags')
AddEventHandler('esx_garbagejob:reportbags', function(platenumber)
	TriggerClientEvent('esx_garbagejob:countbagtotal', -1, platenumber)
end)

RegisterServerEvent('esx_garbagejob:bagsdone')
AddEventHandler('esx_garbagejob:bagsdone', function(platenumber, bagstopay)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_garbagejob:addbags', -1, platenumber, bagstopay, xPlayer )
end)

RegisterServerEvent('esx_garbagejob:setconfig')
AddEventHandler('esx_garbagejob:setconfig', function()
	_source = source
	local currenttruckcount = Config.TruckPlateNumb
	TriggerClientEvent('esxgarbagejob:configset', _source,  currenttruckcount)
end)

RegisterServerEvent('esxgarbagejob:movetruckcount')
AddEventHandler('esxgarbagejob:movetruckcount', function()
	local currenttruckcount = Config.TruckPlateNumb + 1
	if currenttruckcount == 999 then currenttruckcount = 1 end
	Config.TruckPlateNumb = currenttruckcount
	TriggerClientEvent('esxgarbagejob:configset', -1,  Config.TruckPlateNumb)
end)
		