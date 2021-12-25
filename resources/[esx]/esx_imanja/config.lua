Config                            = {}
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.Locale                     = 'hr'
Config.Blipovi					  = false

Config.Kuce = {
	"lf_house_04_",
	"lf_house_05_",
	"lf_house_07_",
	"lf_house_08_",
	"lf_house_09_",
	"lf_house_10_",
	"lf_house_11_",
	"lf_house_13_",
	"lf_house_14_",
	"lf_house_15_",
	"lf_house_16_",
	"lf_house_17_",
	"lf_house_18_",
	"lf_house_19_",
	"lf_house_20_"
}

Config.Controls = {
      ["direction"] = {
        codes = {35,34,33,32},
        text = "Smjer",
      },
      ["heading"] = {
        codes = {51,52},
        text = "Rotacija",
      },
      ["height"] = {
        codes = {172,173},
        text = "Visina",
      },
	  ["kuce"] = {
        codes = {190,189},
        text = "Izbor kuce",
      },
	  ["camera"] = {
        codes = {191},
        text = "Postavi",
      },
      ["zoom"] = {
        codes = {73},
        text = "Odustani",
      },
}

mLibs = exports["meta_libs"]