Config                            = {}
Config.Locale                     = 'hr'

Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.NPCSpawnDistance           = 500.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 150, max = 400 }

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}

Config.Zones = {

	MechanicActions = {
		Pos   = { x = -342.291, y = -133.370, z = 38.009 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	Garage = {
		Pos   = { x = -97.5, y = 6496.1, z = 30.4 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = { x = -366.354, y = -110.766, z = 37.696 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = { x = -386.899, y = -105.675, z = 37.683 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	VehicleDelivery = {
		Pos   = { x = -382.925, y = -133.748, z = 37.685 },
		Size  = { x = 20.0, y = 20.0, z = 3.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
}

Config.Towables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

Config.Uniforms = {
	recrue_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 90,  ['tshirt_2'] = 1,
			['torso_1'] = 66,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 39,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 100,   ['pants_2'] = 3,
			['shoes_1'] = 50,   ['shoes_2'] = 0
		}
	},
	EUPrecrue_wear = {
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
	novice_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 90,  ['tshirt_2'] = 1,
			['torso_1'] = 66,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 39,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 100,   ['pants_2'] = 3,
			['shoes_1'] = 50,   ['shoes_2'] = 0
		}
	},
	EUPnovice_wear = {
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
	experimente_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 90,  ['tshirt_2'] = 1,
			['torso_1'] = 66,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 39,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 100,   ['pants_2'] = 3,
			['shoes_1'] = 50,   ['shoes_2'] = 0
		}
	},
	EUPexperimente_wear = {
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
	chief_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 90,  ['tshirt_2'] = 1,
			['torso_1'] = 66,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 39,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 100,   ['pants_2'] = 3,
			['shoes_1'] = 50,   ['shoes_2'] = 0
		}
	},
	
	EUPchief_wear = {
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
	boss_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 90,  ['tshirt_2'] = 1,
			['torso_1'] = 66,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 39,   ['pants_2'] = 1,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 100,   ['pants_2'] = 3,
			['shoes_1'] = 50,   ['shoes_2'] = 0
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
	}
}

for k,v in ipairs(Config.Towables) do
	Config.Zones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end
