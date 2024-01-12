Config.GarageSystem.Translation = {
    guis = {
        replaceVehicles = {
            title = "Verfügbare Fahrzeuge",
            subtitle = "Fahrzeugliste"
        },
        availableGarages = {
            title = "Verfügbare Garagen",
            subtitle = "Liste der Garagen"
        },
        manageGarage = {
            title = "Verfügbare Optionen",
            subtitle = "Liste der Optionen",

            buttons = {
                inviteAFriend = {
                    label = "Einen Freund einladen",
                    description = "Wenn Sie dieses Menü öffnen, werden die Personen aufgelistet, die der Garageneinfahrt am nächsten sind.",

                    subMenu = {
                        title = "Verfügbare Personen",
                        subtitle = "Liste der Personen"
                    }
                },
                garageSeller = {
                    label = "Verkaufe die Garage",
                    description = "Sind Sie es leid, diese Garage zu benutzen? Verkaufen Sie sie!",

                    subMenu = {
                        title = "Sind Sie sicher?",
                        subtitle = "Wählen Sie Ihre Antwort mit den Schaltflächen.",
                        sell = "Verkaufen",
                    }
                }
            }
        },
    },
    messages = {
        somethingWentWrong = "Etwas ist schief gelaufen.",

        welcomeIntoGarage = "Willkommen in der Garage von ~y~%s",
        impossibleJoiningFriendGarage = "Es ist unmöglich, sich ihm anzuschließen....",
        invitationExpired = "Die Einladung in die Garage ist ~r~abgelaufen~w~.",
        invitePlayerIntoGarage = "~y~%s ~w~schlägt vor, seiner Werkstatt beizutreten, drücken Sie ~g~Y ~w~zur Bestätigung (läuft in 2 Minuten ab).",
        notifyPlayerInvitation = "Wenn Sie ihn auswählen, erhält er eine Benachrichtigung, in der er aufgefordert wird, sich Ihnen anzuschließen.",
        cantGetOutWithVehicle = "Sie können nicht ~r~leave~w~ mit einem Fahrzeug.",
        invitePlayer = "Du hast gerade ~y~%s~w~ eingeladen.",
        soldGarage = "Sie haben gerade Ihre Garage für %s verkauft.",
        garageContainsVehicles = "Sie können die Garage mit den Fahrzeugen darin nicht verkaufen.",

        boughtGarage = "Sie haben gerade ~g~bought~w~ die Garage ~o~%s~w~ für %s.",
        notEnoughMoney = "Sie haben nicht genug Geld, um diese Garage zu kaufen.",
        alreadyHaveGarage = "Sie haben diese Garage bereits.",
        descriptionGarage = "Anzahl der Stellplätze : ~y~ %s~n~~s~%s",
        labelPrice = "Preis: ~g~%s",
        labelBought = "~g~GEKAUFT",

        verificationPending = "Verifizierung in ~g~Bearbeitung~w~, bitte warten...",
        welcomeIntoYourGarage = "Willkommen in %s!",
        garageInUse = "Jemand betritt gerade %s, bitte warten Sie.",
        notVehicleOwner = "Dieses Fahrzeug ~r~gehört Ihnen nicht~w~, Sie können es nicht mitnehmen.",
        garageFull = "%s ist voll.",
        vehicleBlacklisted = "Dieses Fahrzeug ist  ~r~auf der schwarzen Liste~w~, Sie können es nicht mitnehmen.",
        vehicleNotWhitelisted = "~r~Dieses Fahrzeug ist nicht von der Whitelist der Werkstatt zugelassen, Sie können es nicht mitnehmen.",
        beInVehicleToReplace = "Sie müssen ~r~ in einem Fahrzeug ~w~sein, um den Austausch durchzuführen.",
        replaceVehicle = "Wenn Sie sich für dieses Fahrzeug entscheiden, ersetzen Sie es durch das Fahrzeug, das Sie derzeit fahren.",
        listVehicleButtonTitle = "%s - %s",

        actionLeaveGarage = "Drücken Sie [E], um ~r~die Garage zu verlassen",
        actionManageGarage = "Drücken Sie [E], um die ~b~Garage zu verwalten",
        actionAccessToNpc = "Drücken Sie [E], um ~b~den Katalog aufzurufen",
        actionAccessToGarage = "Drücken Sie [E], um ~b~um die Garage aufzurufen",
        teleportingintoGarage = "Betrete %s...",
        teleportingoutofGarage = "Verlasse %s...",

        discordPlayerEnteredGarage = '"%s" (ID: %s) ist in seine Garage (ID: %s) gegangen.',
        discordPlayerInviteSomeone = '"%s" (ID: %s) hat "%s" (ID: %s) eingeladen, in seine Garage (ID: %s) zu kommen.',
        discordPlayerJoinedGarage = '"*%s" (ID: %s) ist der Garage (ID: %s) von "%s" (ID: %s) beigetreten.',
        discordPlayerLeftGarage = '"%s" (ID: %s) verließ die Garage, in der er war.',
        discordPlayerBoughtGarage = '"%s" (ID: %s) hat die Garage gekauft %s (ID: %s).',
        discordPlayerAddedVehicle = '"%s" (ID: %s) hat das Fahrzeug mit dem Kennzeichen "%s" zu seiner Garagen (ID: %s) hinzugefügt.',
        discordPlayerReplaceVehicle = '"%s" (ID: %s) ersetzte das Fahrzeug mit dem Kennzeichen "%s" durch "%s" in seiner Garage (ID: %s).',
        discordPlayerLeftWithVehicle = '"%s" (ID: %s) verließ die Garage (ID: %s) mit dem Fahrzeugkennzeichen "%s".',
        discordGarageOverfull = '"%s" (ID: %s) hat versucht das Fahrzeug mit dem Kennzeichen "%s" zu seiner Garagen (ID: %s) (Plätze: %s) hinzugefügt diese war jedoch mit mehr Fahrzeugen als möglich gefüllt! (Fahrzeuge: %s)',
    }
}