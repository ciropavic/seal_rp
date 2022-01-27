ESX                             = nil

local Tim = 0
local MinutaKr = -1
local Koord
local T1Spawn = 0
local T2Spawn = 0
local Tim1Score = 0
local Tim2Score = 0
local Odjeca
local Tim1Igr = 0
local Tim2Igr = 0
local MojSpawn = nil
local vani1 = nil
local vani2 = nil
local vani3 = nil
local vani4 = nil
local vani5 = nil
local vani6 = nil
local gol1 = nil
local gol2 = nil

local forceTypes = {
    MinForce = 0,
    MaxForceRot = 1,
    MinForce2 = 2,
    MaxForceRot2 = 3,
    ForceNoRot = 4,
    ForceRotPlusForce = 5
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local Lopta
local NLopta = nil

--[[RegisterCommand("lopta", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			Lopta = CreateObject(GetHashKey("stt_prop_stunt_soccer_ball"), 231.90512084961, -791.50927734375, 29.607139587402,true,false,false)
			ESX.ShowNotification("Spawno sam ti loptu")
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)]]

RegisterCommand("npozovi", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local id = tonumber(args[1])
			local tim = tonumber(args[2])
			if id ~= nil and tim ~= nil then
				if tim > 0 and tim < 3 then
					local brojic = 0
					if tim == 1 then
						brojic = Tim1Igr+1
					else
						brojic = Tim2Igr+1
					end
					if tonumber(brojic) <= 3 then
						TriggerServerEvent("nogomet:pozovi", id, tim)
					else
						ESX.ShowNotification("Vec imate max broj igraca u tome timu!")
					end
				else
					name = "System"..":"
					message = " /npozovi [ID igraca][Tim(1 ili 2)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /npozovi [ID igraca][Tim(1 ili 2)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterNetEvent("nogomet:VrimeKraj")
AddEventHandler('nogomet:VrimeKraj', function(vr)
	if Tim > 0 then
		MinutaKr = vr
		SendNUIMessage({
			vrijeme = true,
			minuta = SecondsToClock(vr)
		})
	end
end)

RegisterNetEvent("nogomet:stop")
AddEventHandler('nogomet:stop', function()
	if Tim > 0 then
		--[[vani1:destroy()
		vani2:destroy()
		vani3:destroy()
		vani4:destroy()
		vani5:destroy()
		vani6:destroy()
		gol1:destroy()
		gol2:destroy()]]
		ESX.Game.DeleteObject(NLopta)
		SendNUIMessage({
			zatvoriscore = true
		})
		PoceoNogomet = 0
		if Tim1Score > Tim2Score then
			ESX.ShowNotification("Tim 1 je pobjedio tim 2 sa "..Tim1Score..":"..Tim2Score)
		elseif Tim2Score > Tim1Score then
			ESX.ShowNotification("Tim 2 je pobjedio tim 1 sa "..Tim2Score..":"..Tim1Score)
		else
			ESX.ShowNotification("Utakmica je zavrsila izjednaceno "..Tim1Score..":"..Tim2Score)
		end
		Tim1Score = 0
		Tim2Score = 0
		T1Spawn = 0
		T2Spawn = 0
		Tim1Igr = 0
		Tim2Igr = 0
		Tim = 0
		MojSpawn = nil
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadClothes', skin, Odjeca)
		end)
		SetEntityCoords(GetPlayerPed(-1), Koord, 1, 0, 0, 1)
	end
end)

function PratiKraj()
	Citizen.CreateThread(function()
		while PoceoNogomet == 1 do
			Citizen.Wait(0)
			if MinutaKr == 0 then
				MinutaKr = -1
				TriggerServerEvent("nogomet:Zaustavi")
			end
		end
	end)
end

RegisterCommand("nzaustavi", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			TriggerServerEvent("nogomet:Zaustavi")
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return mins..":"..secs
  end
end

RegisterCommand("npokreni", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local vrijeme = tonumber(args[1])
			if vrijeme ~= nil then
				if vrijeme > 0 then
					if #(GetEntityCoords(PlayerPedId())-vector3(771.25549316406, -233.44470214844, 65.114479064941)) < 100 then
						local loptee = "p_ld_soc_ball_01"
						ESX.Streaming.RequestModel(loptee)
						NLopta = CreateObject(GetHashKey(loptee), 771.25549316406, -233.44470214844, 65.114479064941,true,true,false)
						while not DoesEntityExist(NLopta) do
							Wait(100)
						end
						local netid = ObjToNet(NLopta)
						TriggerServerEvent("SpawnLoptu", netid)
						SetModelAsNoLongerNeeded(GetHashKey(loptee))
						vani1 = PolyZone:Create({
							vector2(812.66046142578, -233.1636505127),
							vector2(815.43634033203, -228.81861877441),
							vector2(747.61761474609, -194.87043762207),
							vector2(745.51031494141, -199.70210266113)
						}, {
							name="vani1",
							--minZ = 65.975372314453,
							--maxZ = 66.193855285645
						})
						--Name: vani2 | 2022-01-26T21:48:35Z
						vani2 = PolyZone:Create({
							vector2(749.1806640625, -201.51795959473),
							vector2(744.89215087891, -199.52757263184),
							vector2(738.13970947266, -213.43597412109),
							vector2(742.50347900391, -215.25355529785)
						}, {
							name="vani2",
							--minZ = 66.114501953125,
							--maxZ = 66.114501953125
						})
						
						--Name: vani3 | 2022-01-26T21:49:43Z
						vani3 = PolyZone:Create({
							vector2(732.34478759766, -235.93173217773),
							vector2(727.60388183594, -233.55186462402),
							vector2(734.65051269531, -220.43460083008),
							vector2(739.20886230469, -221.98890686035)
						}, {
							name="vani3",
							--minZ = 66.114418029785,
							--maxZ = 66.207328796387
						})
						
						--Name: vani4 | 2022-01-26T21:50:39Z
						vani4 = PolyZone:Create({
							vector2(727.59857177734, -233.55166625977),
							vector2(725.10559082031, -239.1104888916),
							vector2(792.82885742188, -274.17495727539),
							vector2(796.154296875, -268.60934448242)
						}, {
							name="vani4",
							--minZ = 65.96297454834,
							--maxZ = 66.627540588379
						})
						
						--Name: vani5 | 2022-01-26T21:51:34Z
						vani5 = PolyZone:Create({
							vector2(792.51214599609, -266.68005371094),
							vector2(796.0078125, -268.29458618164),
							vector2(804.20465087891, -253.71546936035),
							vector2(800.11260986328, -251.97682189941)
						}, {
							name="vani5",
							--minZ = 65.915916442871,
							--maxZ = 66.096611022949
						})
						
						--Name: vani6 | 2022-01-26T21:52:21Z
						vani6 = PolyZone:Create({
							vector2(810.33905029297, -232.22758483887),
							vector2(814.70727539062, -234.35900878906),
							vector2(807.39721679688, -247.03788757324),
							vector2(803.51525878906, -245.35041809082)
						}, {
							name="vani6",
							--minZ = 65.915901184082,
							--maxZ = 66.114273071289
						})
						
						--Name: gol1 | 2022-01-26T21:53:43Z
						gol1 = PolyZone:Create({
							vector2(807.74987792969, -247.04742431641),
							vector2(805.00341796875, -254.11936950684),
							vector2(800.12377929688, -251.95057678223),
							vector2(803.52575683594, -245.37042236328)
						}, {
							name="gol1",
							--minZ = 65.915885925293,
							--maxZ = 66.094314575195
						})
						
						--Name: gol2 | 2022-01-26T21:54:58Z
						gol2 = PolyZone:Create({
							vector2(734.88439941406, -220.15863037109),
							vector2(738.16870117188, -213.6103515625),
							vector2(742.49066162109, -215.27342224121),
							vector2(739.17004394531, -221.94694519043)
						}, {
							name="gol2",
							--minZ = 66.11449432373,
							--maxZ = 66.114517211914
						})
						TriggerServerEvent("nogomet:pokreni", vrijeme*60, netid, vani1, vani2, vani3, vani4, vani5, vani6, gol1, gol2)
						vani1:destroy()
						vani2:destroy()
						vani3:destroy()
						vani4:destroy()
						vani5:destroy()
						vani6:destroy()
						gol1:destroy()
						gol2:destroy()
					else
						ESX.ShowNotification("Morate biti kod terena kako bih ste startali nogomet!")
					end
				else
					name = "System"..":"
					message = " /npokreni [Vrijeme trajanja(minute)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /npokreni [Vrijeme trajanja]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterNetEvent("nogomet:VratioSpawnove")
AddEventHandler('nogomet:VratioSpawnove', function(tim, br)
    if tim == 1 then
		T1Spawn = br
	elseif tim == 2 then
		T2Spawn = br
	end
end)

RegisterNetEvent("nogomet:pozvao")
AddEventHandler("nogomet:pozvao", function(tim)
	if Tim == 0 then
		Koord = GetEntityCoords(PlayerPedId())
		Tim = tim
		if tim == 1 then
			if T1Spawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 799.01550292969, -239.68855285645, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 61.88)
				MojSpawn = 0
			elseif T1Spawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 793.00500488281, -251.85321044922, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 63.08)
				MojSpawn = 1
			elseif T1Spawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 789.25994873047, -242.23332214355, 65.114265441895, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 62.87)
				MojSpawn = 2
			end
			T1Spawn = T1Spawn+1
			TriggerServerEvent("nogomet:SyncSpawnove", tim, T1Spawn)
			TriggerEvent('skinchanger:getSkin', function(skin)
				Odjeca = skin
				local clothesSkin = {
					['tshirt_1'] = 1, ['tshirt_2'] = 1,
					['torso_1'] = 7, ['torso_2'] = 5
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			Tim1Igr = Tim1Igr+1
		elseif tim == 2 then
			if T2Spawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 743.09509277344, -227.79415893555, 65.121788024902, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 243.74)
				MojSpawn = 0
			elseif T2Spawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 749.19232177734, -215.3184967041, 65.114479064941, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 244.80)
				MojSpawn = 1
			elseif T2Spawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 754.91931152344, -225.63809204102, 65.120269775391, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 241.86)
				MojSpawn = 2
			end
			T2Spawn = T2Spawn+1
			TriggerServerEvent("nogomet:SyncSpawnove", tim, T2Spawn)
			TriggerEvent('skinchanger:getSkin', function(skin)
				Odjeca = skin
				local clothesSkin = {
					['tshirt_1'] = 1, ['tshirt_2'] = 1,
					['torso_1'] = 7, ['torso_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			Tim2Igr = Tim2Igr+1
		end
		TriggerServerEvent("nogomet:SyncTimove", Tim1Igr, Tim2Igr)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		ESX.ShowNotification("Pozvani ste u tim "..tim.." na nogometu!")
		--StartProvjeru()
	end
end)

RegisterNetEvent("nogomet:VratiTimove")
AddEventHandler('nogomet:VratiTimove', function(t1, t2)
    Tim1Igr = t1
	Tim2Igr = t2
end)

RegisterNetEvent("nogomet:start")
AddEventHandler("nogomet:start", function(vr)
	if Tim > 0 then
		MinutaKr = vr
		SendNUIMessage({
			vrijeme = true,
			minuta = SecondsToClock(vr),
			prikaziscore = true,
			team1 = true,
			team2 = true,
			score1 = 0,
			score2 = 0
		})
		PoceoNogomet = 1
		FreezeEntityPosition(GetPlayerPed(-1), false)
		PratiKraj()
		ESX.ShowNotification("Poceo je nogomet!")
		ESX.ShowNotification("Loptu napucavate sa lijevom i desnom tipkom misa!")
		Citizen.CreateThread(function()
			while PoceoNogomet == 1 do
				Citizen.Wait(1)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 22, true)
				DisablePlayerFiring(GetPlayerPed(-1),true)
				SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
				local loptac = GetEntityCoords(NLopta)
				DrawMarker(3, loptac.x, loptac.y, loptac.z+0.7, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 0, 0, 0, 100, false, true, 2, false, false, false, false)
			end
		end)
	end
end)

RegisterNetEvent("EoTiLopta")
AddEventHandler("EoTiLopta", function(net)
	if NetworkDoesNetworkIdExist(net) then
		while not NetworkDoesEntityExistWithNetworkId(net) do
			Wait(100)
		end
		NLopta = NetToObj(net)
	else
		print("Ne postoji lopta!")
	end
end)

RegisterNetEvent("nogomet:PoslaoPoruku")
AddEventHandler("nogomet:PoslaoPoruku", function(poruka)
	if Tim > 0 then
		ESX.ShowNotification(poruka)
	end
end)

RegisterNetEvent("nogomet:VratiScore")
AddEventHandler('nogomet:VratiScore', function(t1, t2)
	if Tim > 0 then
		Tim1Score = t1
		Tim2Score = t2
		SendNUIMessage({
			team1 = true,
			team2 = true,
			score1 = t1,
			score2 = t2,
		})
		if Tim == 1 then
			if MojSpawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 799.01550292969, -239.68855285645, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 61.88)
			elseif MojSpawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 793.00500488281, -251.85321044922, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 63.08)
			elseif MojSpawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 789.25994873047, -242.23332214355, 65.114265441895, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 62.87)
			end
		elseif Tim == 2 then
			if MojSpawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 743.09509277344, -227.79415893555, 65.121788024902, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 243.74)
			elseif MojSpawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 749.19232177734, -215.3184967041, 65.114479064941, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 244.80)
			elseif MojSpawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 754.91931152344, -225.63809204102, 65.120269775391, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 241.86)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Tim > 0 then
			if NLopta ~= nil then
				local cor = GetEntityCoords(NLopta)
				local cora = GetEntityCoords(PlayerPedId())
				if GetDistanceBetweenCoords(cor, cora, false) <= 0.5 then
					while not NetworkHasControlOfEntity(NLopta) do 
						NetworkRequestControlOfEntity(NLopta)
						Citizen.Wait(0)
					end
					local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0 , 0.0)
					local forceType = forceTypes.MaxForceRot2
					local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, 0.0)
					local rotation = vector3(0.0, 0.0, 0.0)
					ApplyForceToEntity(NLopta,forceType,direction,rotation,0,false,true,true,false,true)
				end
			end
			if IsDisabledControlJustPressed(0, 24) then
				if NLopta ~= nil then
					local cor = GetEntityCoords(NLopta)
					local cora = GetEntityCoords(PlayerPedId())
					if GetDistanceBetweenCoords(cor, cora, false) <= 1.0 then
						while not NetworkHasControlOfEntity(NLopta) do 
							NetworkRequestControlOfEntity(NLopta)
							Citizen.Wait(0)
						end
						local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 42.0 , 0.0)
						local forceType = forceTypes.MaxForceRot2
						local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, 0.0)
						local rotation = vector3(0.0, 0.0, 0.0)
						RequestAnimDict("melee@unarmed@streamed_variations")
						while not HasAnimDictLoaded("melee@unarmed@streamed_variations") do
							Citizen.Wait(1)
						end
						TaskPlayAnim(PlayerPedId(),"melee@unarmed@streamed_variations","vehicle_kick_var_a", 8.0, -8, 1300, 2, 0, 0, 0, 0)
						ApplyForceToEntity(NLopta,forceType,direction,rotation,0,false,true,true,false,true)
						RemoveAnimDict("melee@unarmed@streamed_variations")
					end
				end
			end
			if IsDisabledControlJustPressed(0, 25) then
				if NLopta ~= nil then
					local cor = GetEntityCoords(NLopta)
					local cora = GetEntityCoords(PlayerPedId())
					if GetDistanceBetweenCoords(cor, cora, false) <= 1.0 then
						while not NetworkHasControlOfEntity(NLopta) do 
							NetworkRequestControlOfEntity(NLopta)
							Citizen.Wait(0)
						end
						local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 42.0 , 17.0)
						local forceType = forceTypes.MaxForceRot2
						local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, cordsa.z-cor.z)
						local rotation = vector3(0.0, 0.0, 0.0)
						RequestAnimDict("melee@unarmed@streamed_variations")
						while not HasAnimDictLoaded("melee@unarmed@streamed_variations") do
							Citizen.Wait(1)
						end
						TaskPlayAnim(PlayerPedId(),"melee@unarmed@streamed_variations","vehicle_kick_var_a", 8.0, -8, 1300, 2, 0, 0, 0, 0)
						ApplyForceToEntity(NLopta,forceType,direction,rotation,0,false,true,true,false,true)
						RemoveAnimDict("melee@unarmed@streamed_variations")
					end
				end
			end
		end
	end
end)

RegisterNetEvent("nogomet:LoptaVani")
AddEventHandler("nogomet:LoptaVani", function()
	if Tim > 0 then
		ESX.ShowNotification("Lopta je izasla izvan terena! Spawnana je na sredini terena!")
		FreezeEntityPosition(NLopta, true)
		SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
		FreezeEntityPosition(NLopta, false)
	end
end)

RegisterNetEvent("nogomet:Gol")
AddEventHandler("nogomet:Gol", function(br)
	if Tim > 0 then
		if br == 1 then
			FreezeEntityPosition(NLopta, true)
			SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
			FreezeEntityPosition(NLopta, false)
			Tim2Score = Tim2Score+1
			TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
			ESX.ShowNotification("Gooool! Tim 2 je zabio timu 1!")
		else
			FreezeEntityPosition(NLopta, true)
			SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
			FreezeEntityPosition(NLopta, false)
			Tim1Score = Tim1Score+1
			TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
			ESX.ShowNotification("Gooool! Tim 1 je zabio timu 2!")
		end
	end
end)

--local Cekaj = false

--[[function StartProvjeru()
	while Tim > 0 do
		Wait(200)
		if Cekaj == false then
			local retval = NetworkHasControlOfEntity(NLopta)
			local retval2 = IsEntityOnScreen(NLopta)
			if retval and retval2 then
				local koord = GetEntityCoords(NLopta)
				if vani1:isPointInside(koord) or vani2:isPointInside(koord) or vani3:isPointInside(koord) or vani4:isPointInside(koord) or vani5:isPointInside(koord) or vani6:isPointInside(koord) then
					TriggerServerEvent("nogomet:SaljiPoruku", "Lopta je izasla izvan terena! Spawnana je na sredini terena!")
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
				end
				if gol1:isPointInside(koord) then
					Cekaj = true
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
					Tim2Score = Tim2Score+1
					TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
					--TriggerEvent("nogomet:VratiScore", Tim1Score, Tim2Score)
					TriggerServerEvent("nogomet:SaljiPoruku", "Gooool! Tim 2 je zabio timu 1!")
					Wait(100)
					Cekaj = false
				end
				if gol2:isPointInside(koord) then
					Cekaj = true
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
					Tim1Score = Tim1Score+1
					TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
					TriggerServerEvent("nogomet:SaljiPoruku", "Gooool! Tim 1 je zabio timu 2!")
					--TriggerEvent("nogomet:VratiScore", Tim1Score, Tim2Score)
					Wait(100)
					Cekaj = false
				end
			end
		end
	end
end]]