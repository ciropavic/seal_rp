Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Cloakroom = {
			CloakRoom = {
					Pos   = vector3(1377.8543701172, -757.53582763672, 66.190284729004),
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.ZaposliSe = {
	Pos   = vector3(1370.2071533204, -759.16857910156, 67.250511169434),
	Size  = {x = 3.0, y = 3.0, z = 3.0},
	Color = {r = 101, g = 65, b = 104},
	Type  = 29,
	Sprite = 566,
	BColor = 5
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = vector3(1384.9125976563, -761.26934814453, 65.82283782959),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos   = vector3(1373.7517089844, -739.28570556641, 67.23291015625),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	
	VehicleDeletePoint = {
				Pos   = vector3(1384.1656494141, -741.45233154297, 66.193939208984),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	}
}

Config.Objekti = {
	vector3(125.8077, -1018.475, 28.05021),
	vector3(130.9007, -1020.201, 28.05021),
	vector3(135.978, -1021.922, 28.05021),
	vector3(141.0414, -1023.638, 28.05021),
	vector3(146.1187, -1025.359, 28.05021),
	vector3(151.2155, -1027.086, 28.05021),
	vector3(156.3008, -1028.809, 28.05021),
	vector3(161.3757, -1030.529, 28.05021),
	vector3(166.4943, -1032.264, 28.05021),
	vector3(171.5589, -1033.98, 28.05021),
	vector3(176.6392, -1035.702, 28.05021),
	vector3(181.715, -1037.422, 28.05021),
	vector3(186.8034, -1039.147, 28.05021),
	vector3(191.9073, -1040.876, 28.05021),
	vector3(197.0137, -1042.607, 28.05021)
}

Config.Uniforms = {
	EUP = false,
	uniforma = { 
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 0,
			['torso_1'] = 89,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes'] = 35,
			['helmet_1'] = 5,  ['helmet_2'] = 0,
			['glasses_1'] = 19,  ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 0,
			['torso_1'] = 0,   ['torso_2'] = 11,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 68,
			['pants_1'] = 30,   ['pants_2'] = 2,
			['shoes'] = 26,
			['helmet_1'] = 19,  ['helmet_2'] = 0,
			['glasses_1'] = 15,  ['glasses_2'] = 0
		}
	},
	EUPuniforma = { 
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 61, 2 },
				{ 1, 16, 10 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 3, 6 },
				{ 3, 64, 1 },
				{ 10, 1, 1 },
				{ 8, 91, 1 },
				{ 4, 50, 4 },
				{ 6, 52, 4 },
				{ 7, 1, 1 },
				{ 9, 4, 3 },
				{ 5, 49, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 61, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 118, 1 },
				{ 3, 82, 1 },
				{ 10, 1, 1 },
				{ 8, 55, 1 },
				{ 4, 5, 2 },
				{ 6, 27, 1 },
				{ 7, 1, 1 },
				{ 9, 6, 3 },
				{ 5, 49, 1 },
			}
		}
	}
}
