description 'SA-Scoreboard'

-- temporary!
ui_page 'html/index.html'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'html/index.html',
    'html/stylesheet.css',
    'html/reset.css',
    'config.css',
    'config.js',
    'html/listener.js',
}

fx_version 'adamant'
game 'gta5'