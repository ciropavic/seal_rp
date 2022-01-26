local Min = 0
local Lopta = nil

RegisterNetEvent("SpawnLoptu")
AddEventHandler("SpawnLoptu", function(net)
	TriggerClientEvent("EoTiLopta", -1, net)
end)

RegisterNetEvent("nogomet:pozovi")
AddEventHandler("nogomet:pozovi", function(id, tim)
	TriggerClientEvent("nogomet:pozvao", id, tim)
end)

RegisterNetEvent("nogomet:SaljiPoruku")
AddEventHandler("nogomet:SaljiPoruku", function(poruka)
	TriggerClientEvent("nogomet:PoslaoPoruku", -1, poruka)
end)

RegisterNetEvent("nogomet:pokreni")
AddEventHandler("nogomet:pokreni", function(vr)
	--[[local loptee = "p_ld_soc_ball_01"
	Lopta = CreateObjectNoOffset(GetHashKey(loptee), 771.25549316406, -233.44470214844, 65.214479064941,true,false)
	while not DoesEntityExist(Lopta) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(Lopta)]]
	TriggerClientEvent("nogomet:start", -1, vr)
	PratiKraj(vr)
end)

RegisterNetEvent("nogomet:Zaustavi")
AddEventHandler("nogomet:Zaustavi", function()
	TriggerClientEvent("nogomet:stop", -1)
	Min = 0
end)

RegisterNetEvent("nogomet:SyncSpawnove")
AddEventHandler('nogomet:SyncSpawnove', function(tim, br)
	TriggerClientEvent("nogomet:VratioSpawnove", -1, tim, br)
end)

RegisterNetEvent("nogomet:SyncajScore")
AddEventHandler('nogomet:SyncajScore', function(tim1, tim2)
	TriggerClientEvent('nogomet:VratiScore', -1, tim1, tim2)
end)

RegisterNetEvent("nogomet:SyncTimove")
AddEventHandler('nogomet:SyncTimove', function(t1, t2)
	TriggerClientEvent('nogomet:VratiTimove', -1, t1, t2)
end)

function PratiKraj(vr)
	Min = vr
	Citizen.CreateThread(function()
		while Min > 0 do
			Citizen.Wait(1000)
			Min = Min-1
			TriggerClientEvent('nogomet:VrimeKraj', -1, Min)
		end
	end)
end