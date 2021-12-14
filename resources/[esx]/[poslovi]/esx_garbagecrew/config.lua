Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0     -- old config from orginal script not used in this version.
Config.Locale       = 'hr'
Config.BagPay       = 35     -- Pay per bag pulled from bin.
Config.MulitplyBags = true   -- Multiplies BagPay by number of workers - 4 max.
Config.TruckPlateNumb = 0

Config.Trucks = {
	"trash",
	"trash2",
	--"biff",  --took this vehilce out for aesthetics reasons.  Trying to find animation that works throwing the garbage up into the truck.
	--"scrap"
}

Config.Cloakroom = {
	CloakRoom = {
			Pos   = {x = -321.70, y = -1545.94, z = 30.02},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1
		},
}

Config.ZaposliSe = {
	Pos   = vector3(-317.89321899414, -1542.9896240234, 27.694211959838),
	Size  = {x = 3.0, y = 3.0, z = 3.0},
	Color = {r = 101, g = 65, b = 104},
	Type  = 29,
	Sprite = 318,
	BColor = 5
}

Config.Zones = {
	VehicleSpawner = {
			Pos   = {x = -316.16, y = -1536.08, z = 26.65},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1
		},

	VehicleSpawnPoint = {
			Pos   = {x = -328.50, y = -1520.99, z = 27.53},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Type  = -1
		},
}
Config.DumpstersAvaialbe = {
    "prop_dumpster_01a",
    "prop_dumpster_02a",
	"prop_dumpster_02b",
	"prop_dumpster_3a",
	"prop_dumpster_4a",
	"prop_dumpster_4b",
	"prop_skip_01a",
	"prop_skip_02a",
	"prop_skip_06a",
	"prop_skip_05a",
	"prop_skip_03",
	"prop_skip_10a"
}


Config.Livraison = {
-------------------------------------------Los Santos
	-- fleeca
	Delivery1LS = {
			Pos   = {x = 114.83280181885, y = -1462.3127441406, z = 28.295083999634},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(116.6096, -1462.964, 28.30068),
			kHeading = 69.278335571289,
			Model = -58485588,
			Type  = 1,
			Paye = 200
		},
	-- fleeca2
	Delivery2LS = {
			Pos   = {x = -6.0481648445129, y = -1566.2338867188, z = 28.209197998047},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(-9.527649, -1564.476, 28.33205),
			kHeading = 249.71127319336,
			Model = 218085040,
			Type  = 1,
			Paye = 200
		},
	-- blainecounty
	Delivery3LS = {
			Pos   = {x = -1.8858588933945, y = -1729.5538330078, z = 28.300233840942},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(0.186768, -1733.863, 28.26604),
			kHeading = 320.00003051758,
			Model = 1605769687,
			Type  = 1,
			Paye = 200
		},
	-- PrincipalBank
	Delivery4LS = {
			Pos   = {x = 159.09, y = -1816.69, z = 26.9},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(157.9336, -1819.356, 27.04019),
			kHeading = 142.26383972168,
			Model = 218085040,
			Type  = 1,
			Paye = 200
		},
	-- route68e
	Delivery5LS = {
			Pos   = {x = 358.94696044922, y = -1805.0723876953, z = 27.966590881348},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(359.4466, -1811.219, 27.98064),
			kHeading = 229.33493041992,
			Model = -58485588,
			Type  = 1,
			Paye = 250
		},
	--littleseoul
	Delivery6LS = {
			Pos   = {x = 481.36560058594, y = -1274.8297119141, z = 28.64475440979},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(485.6616, -1274.715, 28.56201),
			kHeading = 91.052421569824,
			Model = 1605769687,
			Type  = 1,
			Paye = 200
		},
	--grovestreetgas
	Delivery7LS = {
			Pos   = {x = 254.70010375977, y = -985.32482910156, z = 28.196590423584},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(256.5287, -986.6701, 28.30756),
			kHeading = 244.85772705078,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	--fleecacarpark
	Delivery8LS = {
			Pos   = {x = 240.08079528809, y = -826.91204833984, z = 29.018426895142},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(242.4825, -823.4188, 29.0009),
			kHeading = 340.75958251953,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	--Mt Haan Dr Radio Tower
	Delivery9LS = {
			Pos   = {x = 342.78308105469, y = -1036.4720458984, z = 28.194206237793},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(342.8775, -1034.313, 28.33402),
			kHeading = 180.91479492188,
			Model = -387405094,
			Type  = 1,
			Paye = 200
		},
	--Senora Way Fuel Depot
	Delivery10LS = {
			Pos   = {x = 462.17517089844, y = -949.51434326172, z = 26.959424972534},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(466.2311, -947.4157, 26.91276),
			kHeading = 348.79708862305,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
------------------------------------------- 2nd Patrol 
	-- Palomino Noose HQ
	Delivery1BC = {
			Pos   = {x = 317.53698730469, y = -737.95416259766, z = 28.278547286987},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(312.7065, -740.0016, 28.31447),
			kHeading = 244.39865112305,
			Model = -58485588,
			Type  = 1,
			Paye = 200
		},
	-- El Burro Oil plain
	Delivery2BC = {
			Pos   = {x = 410.22503662109, y = -795.30517578125, z = 28.20943069458},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(413.2511, -794.3832, 28.31186),
			kHeading = 264.99920654297,
			Model = -58485588,
			Type  = 1,
			Paye = 200
		},
	-- Orchardville ave
	Delivery3BC = {
			Pos   = {x = 398.36038208008, y = -716.35577392578, z = 28.282489776611},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(394.8215, -719.4955, 28.29113),
			kHeading = 90.001449584961,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	-- Elysian Fields
	Delivery4BC = {
			Pos   = {x = 443.96984863281, y = -574.33978271484, z = 27.494501113892},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(449.5941, -572.8932, 27.48618),
			kHeading = 346.00006103516,
			Model = 1511880420,
			Type  = 1,
			Paye = 200
		},

		-- Carson Ave
	Delivery5BC = {
		Pos   = {x = -1332.53, y = -1198.49, z = 3.62},
		Color = {r = 204, g = 204, b = 0},
		Size  = {x = 5.0, y = 5.0, z = 3.0},
		Color = {r = 204, g = 204, b = 0},
		kPos = vector3(-1332.457, -1192.192, 3.876369),
		kHeading = 359.71841430664,
		Model = 1511880420,
		Type  = 1,
		Paye = 200
	},


	-- Carson Ave
	Delivery6BC = {
			Pos   = {x = -45.443946838379, y = -191.32261657715, z = 51.161594390869},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(-42.99072, -189.5367, 51.25354),
			kHeading = 246.8586730957,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	-- Dutch London
	Delivery7BC = {
			Pos   = {x = -31.948055267334, y = -93.437454223633, z = 56.249073028564},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(-28.45595, -96.78911, 56.28397),
			kHeading = 268.33996582031,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	-- Autopia Pkwy
	Delivery8BC = {
			Pos   = {x = 283.10873413086, y = -164.81878662109, z = 59.060565948486},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(276.8572, -168.3225, 59.05014),
			kHeading = 159.99879455566,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
	-- Miriam Turner Overpass
	Delivery9BC = {
			Pos   = {x = 455.46835327148, y = -66.485572814941, z = 73.154975891113},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(456.8922, -70.22571, 72.67454),
			kHeading = 244.34002685547,
			Model = 218085040,
			Type  = 1,
			Paye = 200
		},
	-- Exceptionalist Way
	Delivery10BC = {
			Pos   = {x = 441.89678955078, y = 125.97653198242, z = 98.887702941895},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			kPos = vector3(447.2959, 133.3931, 98.81459),
			kHeading = 343.51263427734,
			Model = 666561306,
			Type  = 1,
			Paye = 200
		},
		
	RetourCamion = {
			Pos   = {x = -335.26095581055, y = -1529.5614013672, z = 26.565467834473},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
	
	AnnulerMission = {
			Pos   = {x = -315.62796020508, y = -1516.5662841797, z = 26.677434921265},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
}
