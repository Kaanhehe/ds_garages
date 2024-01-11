 Config.GarageSystem.Translation = {
    guis = {
        replaceVehicles = {
            title = "Available cars",
            subtitle = "Vehicle list"
        },
        availableGarages = {
            title = "Available garages",
            subtitle = "Garages list"
        },
        manageGarage = {
            title = "Available options",
            subtitle = "Options list",

            buttons = {
                inviteAFriend = {
                    label = "Invite a friend",
                    description = "Opening this menu will list the closest people to the garage entrance.",

                    subMenu = {
                        title = "Available people",
                        subtitle = "People list"
                    }
                },
                garageSeller = {
                    label = "Sell the garage",
                    description = "Tired to use this garage ? Sell it !",

                    subMenu = {
                        title = "Are you sure?",
                        subtitle = "Choose your answer with the buttons."
                    }
                }
            }
        },
    },
    messages = {
        somethingWentWrong = "Something went wrong.",

        welcomeIntoGarage = "Welcome in the garage of ~y~%s",
        impossibleJoiningFriendGarage = "It's impossible to join him...",
        invitationExpired = "The invitation to the garage has ~r~expired~w~.",
        invitePlayerIntoGarage = "~y~%s ~w~proposes to join his garage, press ~g~Y ~w~to validate (expires in 2 minutes).",
        notifyPlayerInvitation = "If you choose him he will receive a notification asking him to join you.",
        cantGetOutWithVehicle = "You can't ~r~leave~w~ with a vehicle.",
        invitePlayer = "You just invited ~y~%s~w~.",
        soldGarage = "You just ~g~sold your garage for ~g~%s~w~.",
        garageContainsVehicles = "You ~r~can't ~w~sell the garage with vehicles in it.",

        boughtGarage = "You've just ~g~bought~w~ the garage ~o~%s~w~ for %s.",
        notEnoughMoney = "You don't have enough money to buy this garage.",
        alreadyHaveGarage = "You already have this garage.",
        descriptionGarage = "Number of places : ~y~ %s~n~~s~%s",
        labelPrice = "Price: ~g~%s",
        labelBought = "~g~BOUGHT",

        verificationPending = "Verification in ~g~process~w~, please wait...",
        welcomeIntoYourGarage = "Welcome into ~o~your ~w~garage !",
        garageInUse = "Someone just entered into %s, please wait.",
        notVehicleOwner = "This vehicle ~r~doesn't belong to you~w~, you can't enter with it.",
        garageFull = "%s is full.",
        vehicleBlacklisted = "This vehicle is ~r~blacklisted~w~, you can't enter with it.",
        vehicleNotWhitelisted = "~r~This vehicle isn't authorized by the garage whitelist, you can't enter with it.",
        beInVehicleToReplace = "You must ~r~be in a vehicle ~w~to perform the replacement.",
        replaceVehicle = "Selecting this vehicle will mean replacing it with the vehicle you currently drive.",
        listVehicleButtonTitle = "%s - %s",

        actionLeaveGarage = "Press ~INPUT_CONTEXT~ to ~r~leave the garage",
        actionManageGarage = "Press ~INPUT_CONTEXT~ to manage the ~b~garage",
        actionAccessToNpc = "Press ~INPUT_CONTEXT~ to access ~b~the catalog",
        actionAccessToGarage = "Press ~INPUT_CONTEXT~ to access ~b~the garage",
        teleportingintoGarage = "Entering %s...",
        teleportingoutofGarage = "Leaving %s...",

        discordPlayerEnteredGarage = "**%s** entered into one of his garages.",
        discordPlayerInviteSomeone = "**%s** invited **%s** to join his garage.",
        discordPlayerJoinedGarage = "**%s** joined the garage of **%s**.",
        discordPlayerLeftGarage = "**%s** left the garage he was in.",
        discordPlayerBoughtGarage = "**%s** bought the garage **%s** [ID: **%s**].",
        discordPlayerAddedVehicle = "**%s** added the vehicle with plate **%s** to his garage ID **%s**.",
        discordPlayerReplaceVehicle = "**%s** replaced the vehicle with plate **%s** to **%s** in his garage ID **%s**.",
        discordPlayerLeftWithVehicle = "**%s** left the garage ID **%s** with vehicle plate **%s**.",
        discordGarageOverfull = '"%s" (ID: %s) tried to add the vehicle with plate "%s" to his garage (ID: %s) (Places: %s) but it was filled with more vehicles than possible! (Vehicles: %s)',
    }
}