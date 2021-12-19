fx_version 'bodacious'
game 'gta5'


description 'Hugo skriptice'

version '1.0.0'

ui_page "index.html"

files {
	"index.html"
}

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'locales/hr.lua',
  'server/main.lua',
  'config.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/hr.lua',
  'client/main.lua',
  'config.lua'
}
