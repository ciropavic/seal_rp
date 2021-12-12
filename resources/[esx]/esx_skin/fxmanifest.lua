fx_version 'cerulean'
game 'gta5'


description 'ESX Skin'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/hr.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/hr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'skinchanger'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/discord.png',
	'ui/logo.png',
	'ui/slike/slika1.png',
	'ui/slike/slika2.jpg',
	'ui/slike/slika3.jpg',
	'ui/slike/slika4.jpg',
	"ui/assets/plugins/bootstrap-3.3.7-dist/css/bootstrap.css",
	"ui/assets/plugins/jquery/jquery-3.2.1.min.js",
	"ui/assets/plugins/bootstrap-3.3.7-dist/js/bootstrap.min.js"
}
