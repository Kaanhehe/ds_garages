Config.GarageSystem.Translation = {
    guis = {
        replaceVehicles = {
            title = "Véhicules disponibles",
            subtitle = "Liste des véhicules"
        },
        availableGarages = {
            title = "Garages disponibles",
            subtitle = "Liste des garages"
        },
        manageGarage = {
            title = "Options disponibles",
            subtitle = "Liste des options",

            buttons = {
                inviteAFriend = {
                    label = "Inviter un ami",
                    description = "En ouvrant ce menu, vous obtiendrez la liste des personnes les plus proches de l'entrée du garage.",

                    subMenu = {
                        title = "Personnes disponibles",
                        subtitle = "Liste des personnes"
                    }
                },
                garageSeller = {
                    label = "Vendre le garage",
                    description = "Fatiguer d'utiliser ce garage ? Vendez le !",

                    subMenu = {
                        title = "Etes-vous sûr ?",
                        subtitle = "Choisissez la réponse avec les boutons.",
                        sell = "Vendre",
                    }
                }
            }
        }
    },
    messages = {
        somethingWentWrong = "Une erreur est survenue.",

        welcomeIntoGarage = "Bienvenue dans le garage de ~y~%s",
        impossibleJoiningFriendGarage = "Il est impossible de le rejoindre...",
        invitationExpired = "L'invitation au garage a ~r~expiré~w~.",
        invitePlayerIntoGarage = "~y~%s ~w~propose de rejoindre son garage, appuyez sur ~g~Y ~w~pour valider (expire dans 2 minutes).",
        notifyPlayerInvitation = "Si vous le choisissez il recevra une notification lui demandant de vous rejoindre.",
        cantGetOutWithVehicle = "Vous ne pouvez pas ~r~sortir~w~ avec un véhicule.",
        invitePlayer = "Vous venez d'inviter ~y~%s~w~.",
        soldGarage = "Vous venez de ~o~vendre le garage pour ~g~%s~w~.",
        garageContainsVehicles = "Vous ~r~ne pouvez pas ~w~vendre le garage si il contient des véhicules.",

        boughtGarage = "Vous venez d'~g~acheter~w~ le garage ~o~%s~w~ pour %s.",
        notEnoughMoney = "Vous ne disposez pas d'assez d'argent pour l'achat de ce garage.",
        alreadyHaveGarage = "Vous disposez déjà de ce garage.",
        descriptionGarage = "Nombre de places : ~y~ %s~n~~s~%s",
        labelPrice = "Prix: ~g~%s",
        labelBought = "~g~ACHETÉ",

        verificationPending = "Vérification en ~g~cours~w~, veuillez patienter...",
        welcomeIntoYourGarage = "Bienvenue dans %s !",
        garageInUse = "Quelqu'un vient d'entrer dans %s, veuillez patienter.",
        notVehicleOwner = "~r~Ce véhicule ne vous appartient pas, vous ne pouvez pas rentrer avec.",
        garageFull = "%s est plein.",
        vehicleBlacklisted = "~r~Ce véhicule est blacklist, vous ne pouvez pas rentrer avec.",
        vehicleNotWhitelisted = "~r~Ce véhicule n'est pas autorisé par le garage, vous ne pouvez pas rentrer avec.",
        beInVehicleToReplace = "~r~Vous devez être dans un véhicule pour effectuer le remplacement.",
        replaceVehicle = "Sélectionner ce véhicule résumera à le remplacer par le véhicule que vous conduisez actuellement.",
        listVehicleButtonTitle = "%s - %s",

        actionLeaveGarage = "Appuyez sur ~INPUT_CONTEXT~ pour ~r~quitter le garage",
        actionManageGarage = "Appuyez sur ~INPUT_CONTEXT~ pour gérer ~b~le garage",
        actionAccessToNpc = "Appuyez sur ~INPUT_CONTEXT~ pour accéder ~b~au catalogue",
        actionAccessToGarage = "Appuyez sur ~INPUT_CONTEXT~ pour accéder ~b~au garage",
        teleportingintoGarage = "Téléportation dans le garage %s ...",
        teleportingoutofGarage = "Téléportation hors du garage %s ...", 

        discordPlayerEnteredGarage = "%s est entré dans l'un de ses garages.",
        discordPlayerInviteSomeone = "%s a invité %s ta rejoindre son garage.",
        discordPlayerJoinedGarage = "%s a rejoins le garage de %s.",
        discordPlayerLeftGarage = "%s a quitté le garage dans lequel il était.",
        discordPlayerBoughtGarage = "**%s** a acheté le garage **%s** [ID: **%s**].",
        discordPlayerAddedVehicle = "**%s** a ajouté le véhicule immatriculé **%s** à son garage ID **%s**.",
        discordPlayerReplaceVehicle = "**%s** a remplacé le véhicule immatriculé **%s** par **%s** dans son garage ID **%s**.",
        discordPlayerLeftWithVehicle = "**%s** a quitté le garage ID **%s** avec le véhicule immatriculé **%s**.",
        discordGarageOverfull = '"%s" (ID: %s) a essayé d\'ajouter le véhicule immatriculé "%s" à son garage ID "%s" (Places: %s) qui était cependant rempli de plus de véhicules que possible! (Véhicules: %s)',
    }
}