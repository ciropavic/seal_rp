fx_version 'bodacious'
game 'gta5'


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	"config.lua"
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/ikona.png',
	'ui/pozicija.png',
	'ui/cp.png',
	'ui/vrijeme.png'
}