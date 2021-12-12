Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
	["steam:11000010b025e18"] = 100,  -- RazZ
	["steam:11000010a1d1042"] = 100,  -- Chame
	["steam:11000010441bee9"] = 100,  -- Sikora
	["steam:11000013c23448d"] = 100,  -- Hilmac
	["steam:110000109a7cf11"] = 11,  -- Zika
	["steam:110000134f0c302"] = 11,  -- Mancha
	["steam:1100001129f02f2"] = 11,  -- TSM
	["steam:1100001128aaf43"] = 10,  -- Edin
	["steam:11000011bd28423"] = 10,  -- Ado - Who Shot Ya?
	["steam:11000010e645157"] = 10,  -- MoonArt
	["steam:1100001096e21ac"] = 10,  -- Puja
	["steam:11000013eeecd14"] = 10,  -- Niksa
	["steam:11000010dd77bca"] = 10,  -- Duraps
	["steam:110000119ad61cd"] = 10,  -- Rhino Prime
	["steam:110000133b7c5b1"] = 10,  -- Lex.zg
	["steam:11000013f0c6e7e"] = 10,  -- Hektor
	["steam:1100001367d533e"] = 10,  -- Markovicc
	["steam:110000115667f3f"] = 10,  -- Optima
	["steam:11000011abb0fdc"] = 10,  -- Karol
	["steam:11000013bffdb11"] = 10,  -- Vato Gonzales
	["steam:11000010d6a903f"] = 10,  -- Doca Penetrator
	["steam:110000131d4fea5"] = 10,  -- Puhii
	["steam:110000141025d82"] = 10,  -- Makrone
	["steam:11000014109b197"] = 10,  -- Lora
	["steam:110000115cdc41a"] = 10,  -- Sokol
	["steam:11000013e5de083"] = 10,  -- Montes
	["steam:11000013571438e"] = 10,  -- Muki
	["steam:11000011b11ae33"] = 10,  -- alem
	["steam:11000010284b610"] = 10,  -- ajokoricCRO
	["steam:1100001430f89da"] = 10,  -- mumijacvijetic(GW)
	["steam:110000115bcc6d5"] = 10,  -- Snac
	["steam:11000011d19987d"] = 10,  -- Heisenberg
	["steam:11000014078ce58"] = 10,  -- rndm
	["steam:11000013e348af7"] = 10,  -- Hari
	["steam:1100001346db3f9"] = 10,  -- axerioo
	["steam:110000115d7423f"] = 10,  -- Emii
 	
    ["ip:0.0.0.0"] = 85
	
}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 120

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Povezivanje...",
    connecting = "\xE2\x8F\xB3Povezivanje...",
    idrr = "\xE2\x9D\x97[Queue] Pogreska: Pogreska pri pronalazenju tvojeg id-a, restartaj steam.",
    err = "\xE2\x9D\x97[Queue] Greska pri povezivanju",
    pos = "\xF0\x9F\x90\x8CTi si %d/%d u redu cekanja \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Pogreska: Pogreska kod dodavanja na listu",
    timedout = "\xE2\x9D\x97[Queue] Pogreska: Time out?",
    wlonly = "\xE2\x9D\x97[Queue] Niste whitelistani",
    steam = "\xE2\x9D\x97 [Queue] Pogreska: Steam mora biti pokrenut"
}