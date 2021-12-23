
Config = {

	DrawDistance = 100,
	
	Locale = "hr",

	Price = 1500,

	-- This is the multiplier of price to pay when the car is damaged
	-- 100% damaged means 1000 * Multiplier
	-- 50% damaged means 500 * Multiplier
	-- Etc.
	RepairMultiplier = 1, 
	
	BlipInfos = {
		Sprite = 290,
		Color = 38 
	},
	
	BlipPound = {
		Sprite = 67,
		Color = 64 
	}
}

Config.Garages = {

	Garage_Centre = {	
		Pos = vector3(215.800, -810.057, 29.727),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Centar",
		SpawnPoint = {
			Pos = vector3(239.700, -772.1149, 29.5722),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Heading=157.84,
			Marker = 1		
		},
		DeletePoint = {
			Pos = vector3(236.424, -739.377, 29.646),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,

		},
		MunicipalPoundPoint = {
			Pos = vector3(482.896, -1316.557, 28.301),
			Color = {r=25,g=25,b=112},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnMunicipalPoundPoint = {
			Pos = vector3(490.942, -1313.067, 27.964),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			Heading=299.42
		},
	},
	
	Garage_Paleto = {	
		Pos = vector3(105.359, 6613.586, 31.3973),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Paleto",
		SpawnPoint = {
			Pos = vector3(128.7822, 6622.9965, 30.7828),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(126.3572, 6608.4150, 30.8565),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
	Garage_SandyShore = {	
		Pos = vector3(1501.2, 3762.19, 33.0 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Sandy Shore",
		SpawnPoint = {
			Pos = vector3(1497.15, 3761.37, 32.8 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(1504.1, 3765.55, 32.8 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
		Garage_Aeroport = {	
		Pos = vector3(-977.21661376953, -2710.3798828125, 12.853487014771),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Aerodrom",
		SpawnPoint = {
			Pos = vector3(-977.21661376953,-2710.3798828125,12.853487014771 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(-966.88208007813,-2709.9028320313,12.83367729187 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Gabo = {	
		Pos = vector3(-1095.0084228516, 358.60308837891, 68.070678710938 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		Ime = "Gabina garaza",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(-1095.0084228516, 358.60308837891, 67.070678710938 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(-1100.23, 358.14, 68.00 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 0
		}
	},

	Garage_DodatniMarkeri = {	
		Pos = vector3(245.23, -743.14, 31.90),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(251.5884228516, -760.33308837891, 33.570678710938),
			Color = {r=0,g=255,b=0},
			Heading = 345.00,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(245.23, -742.14, 29.70),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri2 = {	
		Pos = vector3(245.23, -743.14, 31.90),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(242.6184228516, -779.94308837891, 29.55678710938),
			Color = {r=0,g=255,b=0},
			Heading = 160.07,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(252.23, -744.44, 29.70),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri3 = {	
		Pos = vector3(245.23, -743.14, 31.90),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(232.0084228516, -775.86308837891, 29.55678710938),
			Color = {r=0,g=255,b=0},
			Heading = 160.07,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(258.83, -746.44, 29.70),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Marina = {	
		Pos = vector3(-857.86236572266, -1328.017578125, 0.30489677190781),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Brod = true,
		Ime = "Marina",
		SpawnMarker = {
			Pos = vector3(-860.48217773438, -1323.0462646484, 0.6051669120789),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnPoint = {
			Pos = vector3(-857.86236572266, -1328.017578125, 0.31225422024727),
			Color = {r=0,g=255,b=0},
			Heading = 109.53,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(-854.32318115234, -1336.2690429688,0.31225422024727),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		Vracanje = vector3(-855.33941650391, -1331.8586425781, 1.5952188968658)
	},
}