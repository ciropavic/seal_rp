RegisterNetEvent('upit:OtvoriPitanje')
AddEventHandler('upit:OtvoriPitanje', function(skr, up, pit, arg)
	SendNUIMessage({
		prikazi = true,
		skripta = skr,
		upit = up,
		pitanje = pit,
		args = arg
	})
	SetNuiFocus(true, true)
end)

RegisterNUICallback(
    "zatvoriupit",
    function(data, cb)
		SetNuiFocus(false)
    end
)