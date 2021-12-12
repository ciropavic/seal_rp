fx_version 'bodacious'
game 'gta5'


client_scripts {
	'config.lua',
    'client.lua',
    'functions.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/kosilica.mp3'
}