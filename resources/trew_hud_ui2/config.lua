Config = {}

Config.Locale = 'en'

Config.serverLogo = 'https://i.imgur.com/AcgDL9f.png'

Config.font = {
	name 	= 'Montserrat',
	url 	= 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700,900&display=swap'
}

Config.date = {
	format	 	= 'withHours',
	AmPm		= false
}

Config.voice = {

	levels = {
		default = 12.0,
		shout = 19.0,
		whisper = 1.0,
		current = 0
	},
	
	keys = {
		distance 	= '~',
	}
}


Config.vehicle = {
	speedUnit = 'KMH',
	maxSpeed = 320,

	keys = {
		seatbelt 	= 'G',
		cruiser		= 'CAPS',
		signalLeft	= 'LEFT',
		signalRight	= 'RIGHT',
		signalBoth	= 'DOWN',
	}
}

Config.ui = {
	showServerLogo		= true,

	showJob		 		= false,

	showWalletMoney 	= false,
	showBankMoney 		= false,
	showBlackMoney 		= false,
	showSocietyMoney	= false,

	showDate 			= false,
	showLocation 		= false,
	showVoice	 		= false,

	showHealth			= false,
	showArmor	 		= false,
	showStamina	 		= false,
	showHunger 			= true,
	showThirst	 		= true,

	showMinimap			= true,

	showWeapons			= true,	
}