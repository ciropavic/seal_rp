fx_version 'bodacious'
game 'gta5'

server_scripts {
    '@es_extended/locale.lua',
	'locales/en.lua',
	'locales/hr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/hr.lua',
	'config.lua',
	'client/main.lua'
}

files {
	'html/audio/*.mp3',
	'html/items/*.png',
	'html/index.html'
}

ui_page('html/index.html')