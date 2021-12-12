fx_version 'bodacious'
game 'gta5'

ui_page "index.html"

files {
	"index.html",
	"assets/plugins/bootstrap-3.3.7-dist/css/bootstrap.css",
	"assets/plugins/jquery/jquery-3.2.1.min.js",
	"assets/plugins/bootstrap-3.3.7-dist/js/bootstrap.min.js"
}

client_script {
	"client.lua"
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	"server.lua"
}
