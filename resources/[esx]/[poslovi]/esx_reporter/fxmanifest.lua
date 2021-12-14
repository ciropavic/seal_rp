fx_version 'bodacious'
game 'gta5'


description 'ESX Mafia Job'

version '1.0.1'

ui_page "index.html"

files {
	"index.html",
	"assets/plugins/bootstrap-3.3.7-dist/css/bootstrap.css",
	"assets/plugins/jquery/jquery-3.2.1.min.js",
	"assets/plugins/bootstrap-3.3.7-dist/js/bootstrap.min.js",
	"s8.png"
}

server_scripts {
  '@es_extended/locale.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/es.lua',
  'locales/hr.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'locales/es.lua',
  'locales/hr.lua',
  'config.lua',
  'client/main.lua'
}
