fx_version 'bodacious'
game 'gta5'

description 'ESX Weashop'

version '1.0.2'

client_scripts {
  '@es_extended/locale.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/es.lua',
  'locales/hr.lua',
  'config.lua',
  '@es_extended/config.weapons.lua',
  'client/main.lua'
}

server_scripts {
  '@es_extended/locale.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/hr.lua',
  'locales/es.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}
