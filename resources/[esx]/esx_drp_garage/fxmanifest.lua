fx_version 'bodacious'

game 'gta5'

description 'ESX Garage'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'locales/en.lua',
	'locales/hr.lua',
	'config.lua',
	'server.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'locales/en.lua',
	'locales/hr.lua',
	'config.lua',
	'client.lua'
}
