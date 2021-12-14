Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 1500  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'hr'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 5 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 10 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(341.0, -1397.3, 32.5), heading = 48.5 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(325.1170349121, -582.67010498046, 43.317405700684),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(325.1170349121, -582.67010498046, 42.317405700684)
		},

		Pharmacies = {
			vector3(342.3344116211, -586.10363769532, 42.315021514892)
		},

		Vehicles = {
			{
				Spawner = vector3(289.30432128906, -592.83288574219, 43.180400848389),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(360.87341308594, -591.44073486328, 27.427598953248), heading = 161.27934265136, radius = 4.0 }				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(352.82318115234, -577.66217041016, 74.165649414063),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.26110839844, -589.34356689453, 73.551666259766), heading = 20.24, radius = 10.0 },
					{ coords = vector3(352.26110839844, -589.34356689453, 73.551666259766), heading = 20.24, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(298.7158203125, -599.35424804688, 42.292125701904),
				To = { coords = vector3(342.96936035156, -585.08563232422, 74.165649414063), heading = 249.54 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(338.51913452148, -583.78894042969, 73.165649414063),
				To = { coords = vector3(299.57104492188, -596.73956298828, 43.291889190674), heading = 339.91 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = { coords = vector3(251.9, -1363.3, 38.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = { coords = vector3(235.4, -1372.8, 26.3), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5000},
		{ model = 'tahoe', label = 'Tahoe', price = 5000},
		{ model = 'emsnspeedo', label = 'Novi Kombi', price = 5000},
		{ model = 'audiq8', label = 'Audi Q8', price = 5000}
	},

	doctor = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 4500},
		{ model = 'tahoe', label = 'Tahoe', price = 5000},
		{ model = 'emsnspeedo', label = 'Novi Kombi', price = 5000},
		{ model = 'audiq8', label = 'Audi Q8', price = 5000}
	},

	chief_doctor = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 3000},
		{ model = 'tahoe', label = 'Tahoe', price = 5000},
		{ model = 'emsnspeedo', label = 'Novi Kombi', price = 5000},
		{ model = 'audiq8', label = 'Audi Q8', price = 5000}
	},

	boss = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 2000},
		{ model = 'tahoe', label = 'Tahoe', price = 5000},
		{ model = 'emsnspeedo', label = 'Novi Kombi', price = 5000},
		{ model = 'audiq8', label = 'Audi Q8', price = 5000}
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {},

	chief_doctor = {},

	boss = {
		{ model = 'polmav', label = 'Maverick', price = 0 }
	}
}



Config.Uniforms = {
	ambulance_wear = { 
		EUP = true,
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		}
	},
	EUPambulance_wear = { 
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
				{ 11, 75, 7 },
				{ 3, 86, 1 },
				{ 10, 1, 1 },
				{ 8, 55, 1 },
				{ 4, 87, 13 },
				{ 6, 52, 1 },
				{ 7, 31, 1 },
				{ 9, 30, 1 },
				{ 5, 39, 1 },
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
				{ 11, 26, 7 },
				{ 3, 110, 1 },
				{ 10, 1, 1 },
				{ 8, 7, 1 },
				{ 4, 90, 13 },
				{ 6, 53, 1 },
				{ 7, 15, 2 },
				{ 9, 34, 1 },
				{ 5, 39, 1 },
			}
		}
	},
	
	doctor_wear = {
		EUP = true,
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		}
	},
	
	EUPdoctor_wear = {
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
				{ 11, 76, 7 },
				{ 3, 87, 1 },
				{ 10, 1, 1 },
				{ 8, 55, 1 },
				{ 4, 87, 13 },
				{ 6, 52, 1 },
				{ 7, 31, 1 },
				{ 9, 15, 1 },
				{ 5, 39, 1 },
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
				{ 11, 27, 7 },
				{ 3, 102, 1 },
				{ 10, 1, 1 },
				{ 8, 7, 1 },
				{ 4, 90, 13 },
				{ 6, 53, 1 },
				{ 7, 15, 2 },
				{ 9, 17, 1 },
				{ 5, 39, 1 },
			}
		}
	},
	
	chief_doctor_wear = {
		EUP = true,
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		}
	},
	
	EUPchief_doctor_wear = {
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
				{ 11, 152, 6 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 66, 8 },
				{ 4, 87, 13 },
				{ 6, 52, 1 },
				{ 7, 1, 1 },
				{ 9, 2, 1 },
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
				{ 11, 149, 6 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 46, 8 },
				{ 4, 90, 13 },
				{ 6, 53, 1 },
				{ 7, 1, 1 },
				{ 9, 2, 1 },
				{ 5, 49, 1 },
			}
		}
	},
	
	boss_wear = {
		EUP = true,
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 3,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 9,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
		},
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
				{ 11, 119, 7 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 89, 1 },
				{ 4, 36, 1 },
				{ 6, 52, 1 },
				{ 7, 128, 1 },
				{ 9, 1, 1 },
				{ 5, 39, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 19, 7 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 7, 1 },
				{ 4, 35, 1 },
				{ 6, 53, 1 },
				{ 7, 98, 1 },
				{ 9, 1, 1 },
				{ 5, 39, 1 },
			}
		},
	}
}