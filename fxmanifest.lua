fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author 'Kaanhehe'
version '1.0.1'
description 'A realistic garage script using walk in garages instead of menus and GUIs'

--shared_script "fixDeleteVehicle.lua" -- Uncomment if you use Kiminaze's AdvancedParking script -> https://kiminazes-script-gems.tebex.io/package/4287488

shared_script '@ox_lib/init.lua'

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"@pmc-instance/instance.lua",

	"shared/utils.lua",
	"shared/config.lua",
	"languages/german.lua",

	"server/api.lua",
    "server/server.lua",
	"server/networking.lua"
}

client_scripts {
    '@menuv/menuv.lua',

	"shared/utils.lua",
	"shared/config.lua",
	"languages/german.lua",

	"client/utils.lua",
	"client/client.lua",
}

dependencies {
    '/onesync',
	'oxmysql',
	'menuv',
	'ox_lib',
	'pmc-instance'
}

escrow_ignore {
 'client/utils.lua',
 'languages/*.*',
 'shared/*.*',
 'server/api.lua',
 'server/exports.lua',
 'fixDeleteVehicle.lua'
}

dependency '/assetpacks'