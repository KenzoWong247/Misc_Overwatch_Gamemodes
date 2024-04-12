settings {
    "main": {
        "description": "Gun Game Modified by Kayst",
        "modeName": "Gun Game"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIsland"
            ]
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "respawnTime%": 0,
            "scoreToWin": 35
        }
    },
    "heroes": {
        "allTeams": {
            "baptiste": {
                "ability2Cooldown%": 200,
                "ability1Cooldown%": 200
            },
            "bastion": {
                "enableAbility1": false
            },
            "brigitte": {
                "healingReceived%": 50,
                "health%": 120,
                "movementSpeed%": 130,
                "enableAbility2": false,
                "shieldBashCooldown%": 50,
                "enableUlt": false
            },
            "mccree": {
                "ammoClipSize%": 30,
                "ability1Cooldown%": 150,
                "damageDealt%": 110,
                "damageReceived%": 120,
                "enableAbility2": false,
                "enableMelee": false,
                "enableSecondaryFire": false,
                "enableUlt": false
            },
            "dva": {
                "health%": 70,
                "ability2Cooldown%": 150
            },
            "doomfist": {
                "damageDealt%": 110,
                "health%": 50,
                "ultKb%": 150,
                "ability1ChargeRate%": 150,
                "ability1Cooldown%": 120,
                "secondaryFireCooldown%": 80,
                "secondaryFireKb%": 110,
                "ability2Cooldown%": 80
            },
            "genji": {
                "damageDealt%": 110
            },
            "junkerQueen": {
                "damageReceived%": 90,
                "health%": 50
            },
            "kiriko": {
                "damageDealt%": 120,
                "damageReceived%": 90,
                "projectileSpeed%": 150,
                "ability2Cooldown%": 80
            },
            "lucio": {
                "ammoClipSize%": 400,
                "damageDealt%": 100,
                "healingReceived%": 70,
                "projectileSpeed%": 150,
                "secondaryFireCooldown%": 130,
                "secondaryFireKb%": 150
            },
            "mei": {
                "ability1Cooldown%": 250,
                "movementSpeed%": 120
            },
            "mercy": {
                "damageReceived%": 90,
                "enableAbility1": false,
                "healingReceived%": 70,
                "health%": 120,
                "projectileSpeed%": 150,
                "enablePassive": false,
                "combatUltGen%": 200,
                "weaponsEnabled": "blaster"
            },
            "moira": {
                "ability2Cooldown%": 120,
                "ability2MaxDamage%": 150,
                "ability2MaxHealing%": 150,
                "damageDealt%": 110,
                "damageReceived%": 110,
                "healingReceived%": 90,
                "enablePrimaryFire": false
            },
            "orisa": {
                "health%": 50
            },
            "reaper": {
                "movementSpeed%": 150
            },
            "reinhardt": {
                "ability2Cooldown%": 30,
                "health%": 40,
                "movementSpeed%": 170
            },
            "roadhog": {
                "healingReceived%": 50,
                "health%": 50,
                "ability2Cooldown%": 300
            },
            "sigma": {
                "health%": 50
            },
            "soldier": {
                "ability2Cooldown%": 200,
                "healingReceived%": 120
            },
            "symmetra": {
                "enableUlt": false
            },
            "torbjorn": {
                "enableAbility1": false,
                "enableAbility2": false,
                "ability2Duration%": 150,
                "weaponsEnabled": "rivetGun"
            },
            "tracer": {
                "ammoClipSize%": 200
            },
            "winston": {
                "ability2Cooldown%": 50,
                "damageDealt%": 110,
                "health%": 60,
                "ability1Cooldown%": 50
            },
            "hammond": {
                "ability2Cooldown%": 70,
                "damageDealt%": 135,
                "damageReceived%": 90,
                "enableSecondaryFire": false,
                "health%": 50,
                "enableAbility3": false,
                "enableUlt": false
            },
            "zarya": {
                "damageDealt%": 110,
                "health%": 50,
                "enableAbility2": false
            },
            "zenyatta": {
                "damageReceived%": 90,
                "movementSpeed%": 150,
                "enableAbility1": false
            },
            "general": {
                "ultGen%": 200
            }
        }
    }
}

#Global variables

globalvar HeroSet 0
globalvar FinalHeros 1


#Player variables

playervar CurrentHeroProgress 26
playervar ProgressBarTarget 27
playervar ProgressBarShownPercent 28
playervar IncrementRef 29


rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(6)
    wait(7)
    setMatchTime(10000)


rule "Initialize Heros":
    HeroSet = [Hero.BAPTISTE, Hero.SOLDIER, Hero.ROADHOG, Hero.SOJOURN, Hero.ECHO, Hero.PHARAH, Hero.WIDOWMAKER, Hero.BASTION, Hero.ASHE, Hero.HANZO, Hero.TRACER, Hero.GENJI, Hero.DVA, Hero.JUNKRAT, Hero.HAMMOND, Hero.MEI, Hero.ZARYA, Hero.SIGMA, Hero.MOIRA, Hero.ANA, Hero.SYMMETRA, Hero.REAPER, Hero.JUNKER_QUEEN, Hero.ORISA, Hero.ZENYATTA, Hero.WINSTON, Hero.DOOMFIST, Hero.REINHARDT, Hero.MERCY, Hero.BRIGITTE, Hero.RAMATTRA]
    FinalHeros = [Hero.LUCIO, Hero.KIRIKO, Hero.TORBJORN, Hero.MCCREE]


rule "Build hero list (L) and disable built-in scoring":
    L = random.shuffle(HeroSet)
    L = L.concat(FinalHeros)
    disableScoring()


rule "Initialize HUD for each player":
    @Event eachPlayer
    
    hudText(eventPlayer, heroIcon(L[eventPlayer.D + 1]), l"Next Hero", L[eventPlayer.D + 1], HudPosition.LEFT, 0, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Initialize Animated Progress HUD for each player":
    @Event eachPlayer
    
    #//User Facing
    progressBarHud(eventPlayer, eventPlayer.ProgressBarShownPercent, "PROGRESS: {0}% ({1} / {2})".format(ceil(eventPlayer.CurrentHeroProgress), eventPlayer.D + 1, 33), HudPosition.TOP, 0, Color.WHITE, Color.WHITE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)


rule "Update Progress Animation Vars":
    @Event eachPlayer
    @Condition eventPlayer.ProgressBarShownPercent < eventPlayer.ProgressBarTarget
    
    if eventPlayer.ProgressBarShownPercent < eventPlayer.ProgressBarTarget:
        if eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent > 1.5:
            eventPlayer.ProgressBarShownPercent += 0.3
            eventPlayer.IncrementRef = 0.3
            wait(0.03)
        elif eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent <= 1.5 and eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent >= 0.4:
            eventPlayer.ProgressBarShownPercent += 0.08
            eventPlayer.IncrementRef = 0.08
            wait(0.025)
        elif eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent <= 0.4 and eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent >= 0.2:
            eventPlayer.ProgressBarShownPercent += 0.05
            eventPlayer.IncrementRef = 0.05
            wait(0.015)
        elif eventPlayer.ProgressBarTarget - eventPlayer.ProgressBarShownPercent < 0.2:
            eventPlayer.ProgressBarShownPercent += 0.025
            eventPlayer.IncrementRef = 0.025
            wait(0.002)
    if RULE_CONDITION:
        goto RULE_START


rule "Update Hero Progress Vars On Kill":
    @Event playerEarnedElimination
    
    eventPlayer.CurrentHeroProgress = ((eventPlayer.D + 1) / 33) * 100
    eventPlayer.ProgressBarTarget = eventPlayer.CurrentHeroProgress
    eventPlayer.IncrementRef = 1


rule "Lose Progress on SD":
    @Event playerDied
    @Condition isGameInProgress() == true
    
    if attacker == eventPlayer:
        wait(0.25)
        eventPlayer.addToScore(-1)
        eventPlayer.D -= 1
        wait(0.25)
        if eventPlayer.getScore() <= 0:
            eventPlayer.setScore(0)
            eventPlayer.D = 0


rule "If on the last hero, clean up the HUD":
    @Event eachPlayer
    @Condition eventPlayer.D >= len(L) - 1
    
    destroyHudText(getLastCreatedText())


rule "Gain score and advance desired hero (D) when earning a kill":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress() == true
    
    wait(0.25)
    attacker.addToScore(1)
    attacker.D += 1
    wait(0.25)


rule "If a player's actual hero differs from the player's desired hero (D), force the hero":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != L[eventPlayer.D]
    
    eventPlayer.startForcingHero(L[eventPlayer.D])
    wait(0.25)
    eventPlayer.preloadHero(L.slice(eventPlayer.D + 1, 12))
    if RULE_CONDITION:
        goto RULE_START


rule "Info":
    hudSubtext(getAllPlayers(), "Kayst's Modified Gun Game", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


