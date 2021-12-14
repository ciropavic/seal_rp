Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Trucks = {
	"utillitruck3"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = vector3(1008.0390014648, -1855.2967529297, 30.039733886719),
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.ZaposliSe = {
	Pos   = vector3(1005.711364746, -1868.3677978516, 30.889833450318),
	Size  = {x = 3.0, y = 3.0, z = 3.0},
	Color = {r = 101, g = 65, b = 104},
	Type  = 29,
	Sprite = 402,
	BColor = 38
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

Config.Zones = {
	VehicleSpawner = {
				Pos   = vector3(1002.3576660156, -1855.791015625, 30.039825439453),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos   = vector3(992.37109375, -1868.9339599609, 29.173282623291),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	
	VehicleDeletePoint = {
				Pos   = vector3(995.49542236328, -1858.1055908203, 29.897397994995),
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 255, g = 0, b = 0},
				Type  = 1
	}
}