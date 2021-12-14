Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'hr'

Config.ReporterStations = {

  Reporter = {

    Blip = {
      Pos     = { x = -118.21, y = -607.14, z = 35.28 },
      Sprite  = 184,
      Display = 4,
      Scale   = 1.2,
      Colour  = 1,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_ASSAULTSMG',       price = 9200 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 5000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2500 },
      { name = 'WEAPON_FIREWORK',         price = 1000 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }
	  
    },
	
	Ulaz = {
      { x = -142.79786682129, y = -572.75537109375, z = 31.424476623535 },
    },
	
	Ormar = {
      { x = -131.94067382813, y = -635.64239501953, z = 167.82054138184 },
    },

	AuthorizedVehicles = {
		{ name = 'rumpo',  label = 'Kombi' }
	},

    Armories = {
      { x = -132.65347290039, y = -632.99127197266, z = 167.8204498291 },
    },

    Vehicles = {
      {
        Spawner    = { x = -141.41, y = -620.80, z = 167.82 },
        SpawnPoint = { x = -149.32, y = -592.17, z = 31.42 },
        Heading    = 200.1,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = 20.312, y = 535.667, z = 173.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 177.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = -144.22, y = -577.02, z = 31.42 }
    },

    BossActions = {
      { x = -125.96224975586, y = -641.57940673828, z = 167.83534240723 }
    },

  },

}

Config.Uniforms = {
	mafia_wear = { 
		EUP = false,
		male = {
			['tshirt_1'] = 0,  ['tshirt_2'] = 0,
			['torso_1'] = 122,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 49,   ['pants_2'] = 0,
			['shoes_1'] = 1,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 5
		},
		female = {
			['tshirt_1'] = 0,  ['tshirt_2'] = 0,
			['torso_1'] = 122,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 49,   ['pants_2'] = 0,
			['shoes_1'] = 1,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 5
		}
	}
}
