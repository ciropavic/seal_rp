fx_version 'bodacious'
game 'gta5'


description 'Firme'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/hr.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/hr.lua',
	'config.lua',
	'server/main.lua'
}

ui_page "html/index.html"

files {
  "html/index.html",
  -- ICONS
  "html/items/*.png",
}


dependency 'es_extended'
