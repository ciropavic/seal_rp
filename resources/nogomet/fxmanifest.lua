fx_version 'bodacious'
game 'gta5'


description 'ESX Prodaja oruzja'

version '1.0.0'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  '@PolyZone/client.lua',
  'client/main.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html'
}
