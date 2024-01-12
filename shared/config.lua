Config = {}


Config.GarageSystem = {
    debugMode = false, -- Create messages on F8 (client-side) and the terminal (server-side) in order to verify the script's logic. Requires for developers.
    SetIntoGarage = false, -- If you want the vehicles to be reset into garage when the server restarts, set to true.
    SetIntoGarageOnReconnect = false, -- If you want the vehicles to be reset into garage when the player reconnects, set to true.
    teleportToGarageExitOnDisconnect = true, -- If someone disconnect from the server in a garage, set to true will teleport him to the nearest garage exit.
    ESXMode = "legacy", -- legacy = ESX Legacy, old = ESX Old
    triggers = { -- Triggers names, check with yours if they are the same. !!!Only needed for Old ESX!!!
        getESX = "esx:getSharedObject"
    },
    UseOxlibLogger = false, -- true = use ox_lib logger feature (datadog) -- false = use discord logger
    discord = {
        enable = true, -- true = enable discord integration, false = disable discord integration
        webhookURL = "https://discord.com/api/webhooks/1133689050700709939/NcMgFInxS_cpeX9i0Yay44sN3oo6dzUG2GAQhX57505TsO7XmEA-8olMqZyo8xaKCDOR",
        username = "ds_garages Logs",
        color = 15844367,
        title = "Player log"
    },
    npcactive = true, -- true = enable NPC, false = disable NPC
    npcs = { -- List of NPCs
        {
            position = vector3(109.24, -636.58, 44.24), -- Position of the NPC
            heading = 71.00, -- Heading of the NPC
            model = "csb_reporter", -- Model of the NPC
            useDistance = 2.0, -- Distance between the Player and the NPC in order to interact with it.

            blipColor = 69, -- Color of the blip (on the map)
            blipSprite = 369, -- Sprite of the blip (on the map), list of all blips : https://docs.fivem.net/docs/game-references/blips/
            blipText = "Garage seller" -- Text of the blip (on the map)
        },
    },
    --[[
        IMPORTANT:
        The [id] = {name, price..} is crucial. The id represent the garage, do not modify it after setting it once because the system uses it to know who owns that garage.
        When you add a garage, add 1 to the id in order to increase it. Look at the examples below.

        To help you create garages, GTA default garages positions are:
        2 places: 179.08 -1001.49 -99.0 -- Added
        6 places: 206.25 -1018.36 -99.0 -- Added
        8 places: 240.55 -1004.81 -98.98 -- Added
        Many places (+10): 1581.1120 -567.2450 85.5
    ]]
    garages = {
    --[[
        [Dummy] = {
            name = The Name you want the garage to have (String)
            price = price of the garage on buy (Integer)
            salePourcentage = the amount of money you get back on sell (0.2 = 20%) so you get 200$ back on a 1000$ garage (Float)
            jobgarage = if you want the garage be a job garage set to true (Boolean)
            job = the job you want to have access to the garage (only if jobgarage is true) (String)

            friendlyfire = false = you will be invincible in the garage, true = the opposite (Boolean)

            blipPosition = vector3(37.13, -907.6, 30.92), -- Blip position of the garage (on the map) (Vector3)
            blipText = "Garage - 2 places", -- Blip text of the garage (on the map) (String)
            blipColor = 5, -- Blip color of the garage (on the map) (Integer)
            blipSprite = 357, -- Blip sprite of the garage (on the map) (Integer)

            markerType = 36, -- Marker type (see https://docs.fivem.net/docs/game-references/markers/ for the list) (Integer)
            markerSize = {1.0, 1.0, 1.0}, -- Size of the marker in X, Y, Z size (Vector3)
            markerColor = {120, 120, 240}, -- Color of the marker in R, G, B (Vector3)
            markerDistance = 10.0, -- Distance between the Player and the marker in order to interact with it. (Float)

            -- IMPORTANT: Always keep the decimal numbers otherwise it won't work so 1.0 instead of 1
            camera = {position = vector3(40.9, -892.58, 33.69), heading = 168.1}, -- Camera position in the menu

            spawnCoords = {position = vector3(179.08, -1001.49, -99.0), heading = 177.15}, -- Spawn position when entering the garage (Vector3)
            leaveSpawnCoords = {position = vector3(41.07, -899.18, 29.98), heading = 353.69}, -- Exit garage position with vehicle and only if you dont use FootleaveSpawnCoords, without vehicle
            FootleaveSpawnCoords = {position = vector3(-2207.2297, 3309.4568, 31.9782), heading = 180.4676}, -- Exit garage position without vehicle if you dont want this just comment it out (--)
            
            FootEnterMarker = { If you wish to have a second enter position for the garage without vehicle, you can set it here if you dont want it just comment it out (--)
                position = vector3(-2207.2297, 3309.4568, 31.9782),  -- Position of the marker (Vector3)
                heading = 180.4676,  -- Heading of the marker (Float)
                markerType = 30,  -- Marker type (see https://docs.fivem.net/docs/game-references/markers/ for the list) (Integer)
                markerSize = {1.0, 1.0, 1.0},  -- Size of the marker in X, Y, Z size (Vector3)
                markerColor = {255, 0, 0},  -- Color of the marker in R, G, B (Vector3)
                markerDistance = 20.0 -- Distance between the Player and the marker in order to interact with it. (Float)
            },

            -- IMPORTANT: be careful with the positions in order to verify that all types of vehicle can spawn !
            vehiclePositions = { -- Number of positions is related to the number of places in the garage
                {position = vector3(174.94, -1004.14, -99.00), heading = 182.46}, -- Position of a vehicle
                {position = vector3(171.71, -1004.23, -99.00), heading = 182.46}, -- Position of a vehicle
            },

            inviteFriends = {
                areaPosition = vector3(38.51, -901.61, 29.99), -- Position where you want the friends to be before you invite them to your garage (Vector3)
                areaDetectPlayers = 30.0, -- Area around the position in order to detect players who wants to got into your garage when they being invited. (Float)
            },

            manageGarage = { -- All information about the marker to manage the garage (sell and invite friends)
                marker = {
                    type = 20, -- Marker type (see https://docs.fivem.net/docs/game-references/markers/ for the list) (Integer)
                    useDistance = 1.5, -- Distance between the Player and the marker in order to interact with it. (Float)
                    size = vector3(1.5, 1.5, 1.0), -- Size of the marker in X, Y, Z size (Vector3)
                    color = vector3(120, 120, 240), -- Color of the marker in R, G, B (Vector3)
                    position = vector3(177.03, -1008.2, -99.0) -- Position of the marker (Vector3)
                }
            },

            whitelistVehicles = { -- Want to just whitelist certain vehicles for a specific garage ? It's here !
                enable = false, -- false = whitelist system disable, true = whitelist system enable (Boolean)
                vehicles = { -- whitelist vehicles list with hash (a hash is the number that represents the vehicle)
                    [5599877] = true, -- Follow this example and replace the 5599877 by your hash (Hash = Boolean)
                }
            },

            blackListVehicles = { -- Hash list of vehicles blacklist from the garage, a hash is the number that represents the vehicle
                [5599877] = true, -- Follow this example and replace the 5599877 by your hash ([Hash] = Boolean)
            }
        },
    ]]
        [1] = {
            name = "47 Grove Polow",
            price = 2500,
            salePourcentage = 0.2,
            jobgarage = false,
            --job = "police",

            friendlyfire = false,

            blipPosition = vector3(37.13, -907.6, 30.92),
            blipText = "Garage - 2 places",
            blipColor = 5,
            blipSprite = 357,

            markerType = 36,
            markerSize = {1.0, 1.0, 1.0},
            markerColor = {120, 120, 240},
            markerDistance = 10.0,

            camera = {position = vector3(40.9, -892.58, 33.69), heading = 168.1},

            spawnCoords = {position = vector3(179.08, -1001.49, -99.0), heading = 177.15},
            leaveSpawnCoords = {position = vector3(41.07, -899.18, 29.98), heading = 353.69},
            --FootleaveSpawnCoords = {position = vector3(-2207.2297, 3309.4568, 31.9782), heading = 180.4676},

            --FootEnterMarker = {position = vector3(-2207.2297, 3309.4568, 31.9782),
            --    heading = 180.4676,
            --    markerType = 30,
            --    markerSize = {1.0, 1.0, 1.0},
            --    markerColor = {255, 0, 0},
            --    markerDistance = 20.0
            --},

            vehiclePositions = {
                {position = vector3(174.94, -1004.14, -99.00), heading = 182.46},
                {position = vector3(171.71, -1004.23, -99.00), heading = 182.46},
            },

            inviteFriends = {
                areaPosition = vector3(38.51, -901.61, 29.99),
                areaDetectPlayers = 30.0,
            },

            manageGarage = {
                marker = {
                    type = 20,
                    useDistance = 1.5,
                    size = vector3(1.5, 1.5, 1.0),
                    color = vector3(120, 120, 240),
                    position = vector3(177.03, -1008.2, -99.0)
                }
            },

            whitelistVehicles = {
                enable = false,
                vehicles = {
                    [5599877] = true,
                }
            },

            blackListVehicles = {
                [5599877] = true,
            }
        },

        [2] = {
            name = "126 Pressing Glow",
            price = 1500,
            salePourcentage = 0.2,
            jobgarage = false,
            --job = "police",

            friendlyfire = false,

            blipPosition = vector3(-70.68, -1822.7, 26.94),
            blipText = "Garage - 6 places",
            blipColor = 5,
            blipSprite = 357,

            markerType = 36,
            markerSize = {1.0, 1.0, 1.0},
            markerColor = {120, 120, 240},
            markerDistance = 10.0,

            camera = {position = vector3(-64.6, -1836.39, 30.85), heading = 27.17},

            spawnCoords = {position = vector3(207.18, -1018.33, -99.0), heading = 100.0},
            leaveSpawnCoords = {position = vector3(-64.68, -1832.71, 26.87), heading = 229.11},
            --FootleaveSpawnCoords = {position = vector3(-2207.2297, 3309.4568, 31.9782), heading = 180.4676},
            
            --FootEnterMarker = {position = vector3(-2207.2297, 3309.4568, 31.9782),
            --    heading = 180.4676,
            --    markerType = 30,
            --    markerSize = {1.0, 1.0, 1.0},
            --    markerColor = {255, 0, 0},
            --    markerDistance = 20.0
            --},
            
            vehiclePositions = {
                {position = vector3(193.09, -1016.6, -99.3), heading = 180.0},
                {position = vector3(193.09, -1023.66, -99.3), heading = 180.0},
                {position = vector3(197.86, -1023.66, -99.3), heading = 180.0},
                {position = vector3(197.86, -1016.6, -99.3), heading = 180.0},
                {position = vector3(203.39, -1016.6, -99.3), heading = 180.0},
                {position = vector3(203.39, -1023.54, -99.3), heading = 180.0},
            },

            inviteFriends = {
                areaPosition = vector3(-70.68, -1822.7, 26.94),
                areaDetectPlayers = 30.0,
            },

            manageGarage = {
                marker = {
                    type = 20,
                    useDistance = 1.5,
                    size = vector3(1.5, 1.5, 1.0),
                    color = vector3(120, 120, 240),
                    position = vector3(200.51, -1013.96, -99.0)
                }
            },

            whitelistVehicles = {
                enable = false,
                vehicles = {
                    [5599877] = true,
                }
            },

            blackListVehicles = {
                [5599877] = true,
            }
        },

        [3] = {
            name = "56 Polovis Street",
            price = 4500, 
            salePourcentage = 0.2,
            jobgarage = false,
            --job = "police",

            friendlyfire = false,

            blipPosition = vector3(-791.63, 335.57, 85.7),
            blipText = "Garage - 12 places",
            blipColor = 5,
            blipSprite = 357,

            markerType = 36,
            markerSize = {1.0, 1.0, 1.0},
            markerColor = {120, 120, 240},
            markerDistance = 10.0,

            camera = {position = vector3(-803.84, 289.15, 90.1), heading = 339.35},

            spawnCoords = {position = vector3(240.32, -1004.86, -99.0), heading = 86.0},
            leaveSpawnCoords = {position = vector3(-800.42, 332.03, 85.7), heading = 178.0},
            --FootleaveSpawnCoords = {position = vector3(-2207.2297, 3309.4568, 31.9782), heading = 180.4676},
            
            --FootEnterMarker = {position = vector3(-2207.2297, 3309.4568, 31.9782),
            --    heading = 180.4676,
            --    markerType = 30,
            --    markerSize = {1.0, 1.0, 1.0},
            --    markerColor = {255, 0, 0},
            --    markerDistance = 20.0
            --},

            vehiclePositions = {
                {position = vector3(233.24, -1000.41, -99.71), heading = 122.3},
                {position = vector3(233.42, -996.62, -99.71), heading = 122.3},
                {position = vector3(233.09, -992.64, -99.71), heading = 122.3},
                {position = vector3(233.57, -988.52, -99.71), heading = 122.3},
                {position = vector3(233.24, -984.41, -99.71), heading = 122.3},
                {position = vector3(224.49, -1000.65, -99.71), heading = 300.14},
                {position = vector3(224.35, -996.83, -99.71), heading = 300.14},
                {position = vector3(223.71, -992.94, -99.71), heading = 300.14},
                {position = vector3(223.94, -988.64, -99.71), heading = 300.14},
                {position = vector3(223.76, -984.97, -99.71), heading = 300.14},
                {position = vector3(223.37, -981.01, -99.71), heading = 300.14},
                {position = vector3(223.37, -977.24, -99.71), heading = 300.14},
            },

            inviteFriends = {
                areaPosition = vector3(-791.63, 335.59, 85.7),
                areaDetectPlayers = 30.0,
            },
            manageGarage = {
                marker = {
                    type = 20,
                    useDistance = 1.5,
                    size = vector3(1.5, 1.5, 1.0),
                    color = vector3(120, 120, 240),
                    position = vector3(235.66, -1006.3, -99.0)
                }
            },

            whitelistVehicles = {
                enable = false,
                vehicles = {
                    [5599877] = true,
                }
            },

            blackListVehicles = {
                [5599877] = true,
            },
        },

        [4] = {
            name = "Hangar-A2",
            price = 4500,
            salePourcentage = 0.2,
            jobgarage = true,
            job = "police",

            friendlyfire = false,

            blipPosition = vector3(-2026.03, 3149.21, 31.81),
            blipText = "Hangar-A2",
            blipColor = 5,
            blipSprite = 569,

            markerType = 33,
            markerSize = {2.0, 2.0, 2.0},
            markerColor = {255, 0, 0},
            markerDistance = 20.0,

            camera = {position = vector3(-2026.03, 3149.21, 31.81), heading = 339.35},

            spawnCoords = {position = vector3(-1268.5000, -2974.2012, -48.4897), heading = 182.2002},
            leaveSpawnCoords = {position = vector3(-2031.9265, 3139.6074, 32.8103), heading = 147.63},


            vehiclePositions = {
                {position = vector3(-1253.7848, -3031.3469, -47.5388), heading = 39.2085},
                {position = vector3(-1253.2759, -3012.9319, -47.5299), heading = 20.9679},
                {position = vector3(-1256.4265, -2991.6956, -47.5295), heading = 37.6115},
                {position = vector3(-1265.7091, -3038.4221, -47.5323), heading = 1.6450},
                {position = vector3(-1266.7091, -3015.9697, -47.5299), heading = 1.6450},
                {position = vector3(-1267.7091, -2992.1550, -47.5291), heading = 1.6450},
                {position = vector3(-1279.4612, -3031.7117, -47.5303), heading = 322.7154},
                {position = vector3(-1279.5177, -3014.5979, -47.5293), heading = 340.5244},
                {position = vector3(-1278.4467, -2991.6908, -47.5293), heading = 323.3578},
            },

            inviteFriends = {
                areaPosition = vector3(-2026.03, 3149.21, 31.81),
                areaDetectPlayers = 30.0,
            },

            manageGarage = {
                marker = {
                    type = 20,
                    useDistance = 1.5,
                    size = vector3(1.5, 1.5, 1.0),
                    color = vector3(120, 120, 240),
                    position = vector3(-1248.6752, -2963.2600, -48.4896)
                }
            },

            whitelistVehicles = {
                enable = false,
                vehicles = {
                    [5599877] = true,
                }
            },

            blackListVehicles = {
                [5599877] = true,
            }
        },

        [5] = {
            name = "Garage-3403",
            price = 4500,
            salePourcentage = 0.2,
            jobgarage = true,
            job = "police",

            friendlyfire = false,

            blipPosition = vector3(-2193.9067, 3305.4749, 31.8137),
            blipText = "Garage-3403",
            blipColor = 5,
            blipSprite = 357,

            markerType = 36,
            markerSize = {1.5, 1.5, 1.5},
            markerColor = {255, 0, 0},
            markerDistance = 20.0,

            camera = {position = vector3(-2193.9067, 3305.4749, 32.8137), heading = 339.35},

            spawnCoords = {position = vector3(1380.1273, 178.2258, -48.9935), heading = 1.1607},
            leaveSpawnCoords = {position = vector3(-2193.0825, 3294.7124, 32.8122), heading = 183.3034},
            FootleaveSpawnCoords = {position = vector3(-2207.2297, 3309.4568, 31.9782), heading = 180.4676},         
                
            FootEnterMarker = {
                position = vector3(-2207.2297, 3309.4568, 31.9782),
                heading = 180.4676,
                markerType = 30,
                markerSize = {1.0, 1.0, 1.0},
                markerColor = {255, 0, 0},
                markerDistance = 20.0
            },


            vehiclePositions = {
                {position = vector3(-1253.7848, -3031.3469, -47.5388), heading = 39.2085},
                {position = vector3(-1253.2759, -3012.9319, -47.5299), heading = 20.9679},
                {position = vector3(-1256.4265, -2991.6956, -47.5295), heading = 37.6115},
                {position = vector3(-1265.7091, -3038.4221, -47.5323), heading = 1.6450},
                {position = vector3(-1266.7091, -3015.9697, -47.5299), heading = 1.6450},
                {position = vector3(-1267.7091, -2992.1550, -47.5291), heading = 1.6450},
                {position = vector3(-1279.4612, -3031.7117, -47.5303), heading = 322.7154},
                {position = vector3(-1279.5177, -3014.5979, -47.5293), heading = 340.5244},
                {position = vector3(-1278.4467, -2991.6908, -47.5293), heading = 324.3578},
            },

            inviteFriends = {
                areaPosition = vector3(-2026.03, 3149.21, 31.81),
                areaDetectPlayers = 30.0,
            },

            manageGarage = {
                marker = {
                    type = 20,
                    useDistance = 1.5,
                    size = vector3(1.5, 1.5, 1.0),
                    color = vector3(120, 120, 240),
                    position = vector3(-1248.6752, -2963.2600, -48.4896)
                }
            },
                
            whitelistVehicles = {
                enable = false,
                vehicles = {
                    [5599877] = true,
                }
            },

            blackListVehicles = {
                [5599877] = true,
            }
        },
    }
}