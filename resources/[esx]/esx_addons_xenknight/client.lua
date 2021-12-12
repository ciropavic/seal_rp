ESX	= nil
local PlayerData                = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx_addons_xenknight:call')
AddEventHandler('esx_addons_xenknight:call', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  if message == nil then
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
  end
  if message ~= nil and message ~= "" then
    TriggerServerEvent('esx_addons_gcphone:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })
  end
end)

local Prikazi = false

RegisterNetEvent('mobitel:Testiraj')
AddEventHandler('mobitel:Testiraj', function(num, poruka, coords)
	SendNUIMessage({
		salji = true,
		broj = num,
		tekst = poruka,
		koord = coords
	})
	if Prikazi then
		ESX.ShowNotification("[CENTRALA] Dosla je nova prijava!")
	end
end)

local pozicija = vector3(439.44024658203, -991.91552734375, 30.689340591431)

RegisterCommand("centrala", function(source, args, rawCommandString)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if #(GetEntityCoords(PlayerPedId())-pozicija) <= 3.0 then
			ESX.TriggerServerCallback('murja:JelSlobodnaCentrala', function(br)
				if not br then
					SendNUIMessage({
						prikazi = true 
					})
					if Prikazi == false then
						SetNuiFocus(true, true)
						Prikazi = true
						TriggerServerEvent("murja:UCentrali", true)
					else
						SetNuiFocus(false)
						Prikazi = false
						TriggerServerEvent("murja:UCentrali", false)
					end
				else
					ESX.ShowNotification("Vec je netko u centrali!")
				end
			end)
		end
	end
end, false)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNUICallback(
    "salji",
    function(data, cb)
		local broj = data.broj;
		local tekst = string.gsub(data.tekst, '"', "&quot;")
		local koord = vector3(tonumber(data.x), tonumber(data.y), tonumber(data.z))
		tekst = string.gsub(tekst, '<', "&lt;")
		tekst = string.gsub(tekst, '>', "&gt;")
		TriggerServerEvent("murja:SaljiGa", broj, tekst, koord)
		cb("ok")
    end
)

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		Prikazi = false
		TriggerServerEvent("murja:UCentrali", false)
    end
)
