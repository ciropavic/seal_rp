Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true  -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'hr'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29,
			Naziv = "Policijska Stanica"
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6),
			vector3(1662.814, -25.306, 172.551)
		},

		Armories = {
			vector3(451.7, -980.1, 30.6),
			vector3(1663.998, -49.942, 168.552)
		},

		Vehicles = {
			{
				Spawner = vector3(454.6, -1017.4, 28.4), vector3(1670.185, -59.915, 173.533),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
					{ coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0 },
					{ coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0 },
					{ coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0 },
				}
			},

			{
				Spawner = vector3(473.3, -1018.8, 28.0),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(475.9, -1021.6, 28.0), heading = 276.1, radius = 6.0 },
					{ coords = vector3(484.1, -1023.1, 27.5), heading = 302.5, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}

	},
	Sheriff = {

		Blip = {
			Coords  = vector3(-434.03021240234, 6004.7690429688, 31.716245651245),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 28,
			Naziv = "Serif"
		},

		Cloakrooms = {
			vector3(-434.03021240234, 6004.7690429688, 31.716245651245)
		},

		Armories = {
			vector3(-437.51455688477, 5988.5581054688, 31.716186523438)
		},

		Vehicles = {
			{
				Spawner = vector3(-446.79956054688, 5994.3051757813, 31.340545654297),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-466.48382568359, 6016.40234375, 30.776239395142), heading = 316.10, radius = 6.0 },
				}
			},
		},

		BossActions = {
			vector3(-440.98263549805, 6001.3413085938, 31.716176986694)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	officer = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	sergeant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	
	interventna = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	
	granicna = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	chef = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'police3', label = 'Novi Auto', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
		{ model = 'g63amg6x6cop', label = 'Mercedes 6x6', price = 0}
	},

	recruit = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0}
	},

	officer = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'polgt500', label = 'Ford Mustang GT500', price = 0},
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0}
	},

	sergeant = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'polgt500', label = 'Ford Mustang GT500', price = 0},
		{ model = 'pol718', label = 'Porsche Cayman 718', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0}
	},

	intendent = {
		{ model = 'pranger', label = 'Ranger', price = 0},
		{ model = 'sheriff', label = 'Sheriff', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0}
	},
	
	lieutenant = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'umkscout', label = 'Jeep', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0}
	},
	
	interventna = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'umkscout', label = 'Jeep', price = 0}
	},
	
	granicna = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'umkscout', label = 'Jeep', price = 0}
	},

	chef = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'umkscout', label = 'Jeep', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0}
	},

	boss = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'polgt500', label = 'Ford Mustang GT500', price = 0},
		{ model = 'riot', label = 'Oklopno vozilo Interventna', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'fbi2', label = 'VW Touareg', price = 0},
		{ model = 'umkscout', label = 'Jeep', price = 0},
		{ model = 'policeb', label = 'Motor', price = 0},
		{ model = '2015polstang', label = 'Novi Mustang', price = 0}
	}
}

Config.AuthorizedHelicopters = {
	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {},

	lieutenant = {},
	
	interventna = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	},
	
	granicna = {},

	chef = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	},

	boss = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {  -- Pocetnici
		EUP = false,
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPrecruit_wear = {  -- Pocetnici
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 194, 5 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 54, 1 },
				{ 4, 26, 2 },
				{ 6, 16, 1 },
				{ 7, 9, 1 },
				{ 9, 15, 1 },
				{ 5, 56, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 196, 5 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 28, 2 },
				{ 4, 42, 3 },
				{ 6, 53, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 56, 1 },
			}
		}
	},
	officer_wear = {  -- Saobracajci
		EUP = false,
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 2,
			['pants_1'] = 28,   ['pants_2'] = 15,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 113,  ['helmet_2'] = 5,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPofficer_wear = {  -- Saobracajci
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 45, 8 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 194, 9 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 89, 1 },
				{ 4, 88, 13 },
				{ 6, 25, 1 },
				{ 7, 2, 1 },
				{ 9, 26, 2 },
				{ 5, 33, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 44, 8 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 196, 9 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 66, 1 },
				{ 4, 91, 13 },
				{ 6, 26, 1 },
				{ 7, 2, 1 },
				{ 9, 28, 2 },
				{ 5, 33, 1 },
			}
		}
	},
	sergeant_wear = {  -- Od policajca do visi narednik
		EUP = false,
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 15,
			['helmet_1'] = 113,  ['helmet_2'] = 1,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPsergeant_wear = {  -- chame je paksu
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 102, 1 },
				{ 3, 5, 1 },
				{ 10, 13, 1 },
				{ 8, 38, 1 },
				{ 4, 88, 3 },
				{ 6, 25, 1 },
				{ 7, 2, 1 },
				{ 9, 15, 1 },
				{ 5, 75, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 93, 1 },
				{ 3, 4, 1 },
				{ 10, 12, 1 },
				{ 8, 3, 1 },
				{ 4, 91, 3 },
				{ 6, 26, 1 },
				{ 7, 2, 1 },
				{ 9, 1, 1 },
				{ 5, 75, 1 },
			}
		}
	},
	intendent_wear = {  -- i opet je paksu
		EUP = false,
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 15,
			['helmet_1'] = 113,  ['helmet_2'] = 14,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,		['mask_2'] = 0
		}
	},
	
	EUPintendent_wear = {  -- neko
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 14, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 201, 3 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 39, 2 },
				{ 4, 26, 1 },
				{ 6, 52, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 54, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 14, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 203, 3 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 52, 2 },
				{ 4, 42, 2 },
				{ 6, 53, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 54, 1 },
			}
		}
	},
	lieutenant_wear = { -- hehe, mali easter egg
		EUP = false,
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 139,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 59,   ['pants_2'] = 9,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 106,  ['helmet_2'] = 20,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6,
			['mask_1'] = 35,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPlieutenant_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 37, 2 },
				{ 3, 13, 1 },
				{ 10, 1, 1 },
				{ 8, 12, 1 },
				{ 4, 11, 5 },
				{ 6, 11, 1 },
				{ 7, 7, 1 },
				{ 9, 25, 1 },
				{ 5, 49, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 169, 2 },
				{ 3, 8, 1 },
				{ 10, 1, 1 },
				{ 8, 40, 4 },
				{ 4, 4, 4 },
				{ 6, 30, 1 },
				{ 7, 7, 1 },
				{ 9, 10, 1 },
				{ 5, 60, 1 },
			}
		}
	},
	interventna_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 31,   ['pants_2'] = 2,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 88,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['glasses_1'] = 0,     ['glasses_2'] = 0,
			['mask_1'] = 0,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPinterventna_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 126, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 33, 1 },
				{ 3, 32, 1 },
				{ 10, 1, 1 },
				{ 8, 54, 1 },
				{ 4, 87, 13 },
				{ 6, 55, 1 },
				{ 7, 9, 1 },
				{ 9, 13, 1 },
				{ 5, 49, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 169, 2 },
				{ 3, 8, 1 },
				{ 10, 1, 1 },
				{ 8, 40, 4 },
				{ 4, 4, 4 },
				{ 6, 30, 1 },
				{ 7, 7, 1 },
				{ 9, 10, 1 },
				{ 5, 60, 1 },
			}
		}
	},
	granicna_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 42,  ['tshirt_2'] = 0,
			['torso_1'] = 98,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 49,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6,
			['mask_1'] = 0,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPgranicna_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 201, 8 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 57, 1 },
				{ 4, 36, 1 },
				{ 6, 52, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 32, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 193, 10 },
				{ 3, 15, 1 },
				{ 10, 1, 1 },
				{ 8, 52, 2 },
				{ 4, 90, 11 },
				{ 6, 53, 1 },
				{ 7, 1, 1 },
				{ 9, 1, 1 },
				{ 5, 34, 1 },
			}
		}
	},
	chef_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 221,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 87,   ['pants_2'] = 6,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 106,  ['helmet_2'] = 20,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6,
			['mask_1'] = 0,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPchef_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
			{ 0, 29, 3 },
			{ 1, 0, 0 },
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
			components = {
			{ 1, 1, 1 },
			{ 11, 64, 1 },
			{ 3, 1, 1 },
			{ 10, 24, 1 },
			{ 8, 3, 2 },
			{ 4, 88, 2 },
			{ 6, 36, 1 },
			{ 7, 1, 1 },
			{ 9, 1, 1 },
			{ 5, 1, 1 },
		}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
			{ 0, 29, 3 },
			{ 1, 0, 0 },
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
			components = {
			{ 1, 1, 1 },
			{ 11, 57, 1 },
			{ 3, 15, 1 },
			{ 10, 23, 1 },
			{ 8, 15, 1 },
			{ 4, 91, 2 },
			{ 6, 37, 1 },
			{ 7, 1, 1 },
			{ 9, 1, 1 },
			{ 5, 1, 1 },
		}
		}
	},
	boss_wear = { -- ISMIR
		EUP = false,
		male = {
			['tshirt_1'] = 21,  ['tshirt_2'] = 4,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 12,  ['helmet_2'] = 0,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 4,     ['glasses_2'] = 2
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPboss_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 5, 2 },
				{ 3, 13, 1 },
				{ 10, 1, 1 },
				{ 8, 12, 1 },
				{ 4, 11, 4 },
				{ 6, 11, 1 },
				{ 7, 13, 9 },
				{ 9, 24, 1 },
				{ 5, 67, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 25, 3 },
				{ 3, 8, 1 },
				{ 10, 1, 1 },
				{ 8, 65, 2 },
				{ 4, 4, 9 },
				{ 6, 30, 1 },
				{ 7, 1, 1 },
				{ 9, 26, 1 },
				{ 5, 1, 1 },
			}
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 18,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	gilet_wear = {
		male = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}
}
