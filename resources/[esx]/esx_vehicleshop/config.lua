Config                            = {}
Config.DrawDistance               = 100
Config.MarkerColor                = {r = 120, g = 120, b = 240}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 50

Config.Locale                     = 'fr'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {

	ShopEntering = {
		Pos   = vector3(-33.777, -1102.021, 25.422),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(-47.570, -1097.221, 25.422),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 136.59,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-28.637, -1085.691, 25.565),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = vector3(-32.065, -1114.2, 25.4),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = vector3(-18.2, -1078.5, 25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	ResellVehicle = {
		Pos   = vector3(-44.569271087646, -1081.7122802734, 25.685205459595),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	},
	--brodovi
	ShopEntering2 = {
		Pos   = vector3(-711.55859375, -1299.2833251953, 4.3998832702637),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside2 = {
		Pos     = vector3(-726.96313476563, -1326.7943115234, -0.4),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 229.85,
		Type    = -1
	},

	ShopOutside2 = {
		Pos     = vector3(-718.740234375, -1348.1173095703, 0.34054732322693),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 138.93,
		Type    = -1
	},

	ResellVehicle2 = {
		Pos   = vector3(-731.54217529297, -1334.6604003906, 0.28573158383369),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}

}
