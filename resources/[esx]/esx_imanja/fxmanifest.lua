fx_version 'bodacious'
game 'gta5'


description 'ESX imanja'

version '1.0.1'

server_scripts {
  '@es_extended/locale.lua',
  'locales/hr.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/hr.lua',
  '@PolyZone/client.lua',
  'config.lua',
  'client/main.lua'
}
