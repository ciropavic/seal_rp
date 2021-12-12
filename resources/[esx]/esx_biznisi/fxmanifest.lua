fx_version 'bodacious'
game 'gta5'


description 'ESX Biznisi'

version '1.0.0'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'client/main.lua'
}
