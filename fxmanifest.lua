fx_version 'cerulean'
game       'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name        'lxr-lockpick'
author      'iBoss21 / The Lux Empire | wolves.land'
description '🐺 LXR Lockpick — Advanced skill-based lockpicking mini-game for RedM | wolves.land'
version     '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

server_script 'server/main.lua'

client_script 'client/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}
