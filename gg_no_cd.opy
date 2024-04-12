settings {
    "main": {
        "description": "<FG00FF00FF>PHCQ1\r\n\r\n<FG25d4fcFF>Discord: <FGFFFFFFFF>https://tiny.cc/ggnc",
        "modeName": "<FGED6429FF>GUN GAME NO CD"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 0,
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
            "scoreToWin": 50,
            "enableSelfInitiatedRespawn": false,
            "spawnHealthPacks": "enabled"
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "damageDealt%": 250
            },
            "baptiste": {
                "damageDealt%": 300
            },
            "brigitte": {
                "secondaryFireRechargeRate%": 500,
                "shieldBashCooldown%": 20,
                "shieldBashKb%": 300,
                "ability1Kb%": 300
            },
            "mccree": {
                "ability2Cooldown%": 20
            },
            "kiriko": {
                "damageDealt%": 200,
                "projectileSpeed%": 500
            },
            "mei": {
                "damageDealt%": 500,
                "enableSpawningWithUlt": true
            },
            "mercy": {
                "damageDealt%": 500
            },
            "moira": {
                "ability2MaxDamage%": 500,
                "damageDealt%": 300,
                "movementSpeed%": 200
            },
            "orisa": {
                "damageDealt%": 300
            },
            "sigma": {
                "damageDealt%": 300
            },
            "sombra": {
                "damageDealt%": 500
            },
            "symmetra": {
                "damageDealt%": 300
            },
            "hammond": {
                "damageDealt%": 400
            },
            "zarya": {
                "damageDealt%": 200,
                "ability1Cooldown%": 50
            },
            "zenyatta": {
                "damageDealt%": 300
            },
            "general": {
                "abilityCooldown%": 0,
                "enableInfiniteAmmo": true,
                "ultGen%": 500,
                "combatUltGen%": 500,
                "passiveUltGen%": 500
            }
        }
    }
}

#Global variables

globalvar RandomizedHeroes 0


#Player variables

playervar RandomizedHeroes 0
playervar CurrentHero 1
playervar CanSkipHero 2


#Activated extensions

#!extension beamSounds
#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds


rule "Every game list randomizer":
    @Event eachPlayer
    
    RandomizedHeroes = random.shuffle(getAllHeroes())


rule "Longer game time":
    @Condition isGameInProgress() == true
    
    setMatchTime(4500)


rule "Disabler":
    disableScoring()
    disableGamemodeCompletion()


rule "No assemble heroes":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(5)


rule "Player non-game initalizer":
    @Event eachPlayer
    
    eventPlayer.RandomizedHeroes = RandomizedHeroes
    eventPlayer.CurrentHero = eventPlayer.RandomizedHeroes[0]
    eventPlayer.RandomizedHeroes = eventPlayer.RandomizedHeroes.exclude(eventPlayer.CurrentHero)
    eventPlayer.preloadHero(eventPlayer.CurrentHero)
    eventPlayer.CanSkipHero = true
    eventPlayer.setAllowedHeroes(eventPlayer.CurrentHero)
    eventPlayer.startForcingHero(eventPlayer.CurrentHero)
    eventPlayer.CurrentHero = eventPlayer.RandomizedHeroes[0]
    eventPlayer.RandomizedHeroes = eventPlayer.RandomizedHeroes.exclude(eventPlayer.CurrentHero)
    eventPlayer.preloadHero(eventPlayer.CurrentHero)
    eventPlayer.J = 0
    eventPlayer.K = len(getAllHeroes()) - eventPlayer.getScore()


rule "HUD creator":
    @Event eachPlayer
    
    hudSubheader([i for i in [i for i in eventPlayer if i.CanSkipHero == true] if i.CurrentHero != 0], "CROUCH + INTERACT TO SKIP THE CURRENT HERO (ONE TIME USE)", HudPosition.TOP, 1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(eventPlayer, l"{0}: {1}".format("HEROES LEFT", 1 + len(eventPlayer.RandomizedHeroes)), HudPosition.TOP, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(eventPlayer, "ORIGINAL MODE BY TinyMorty", HudPosition.RIGHT, 0, Color.YELLOW, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, " ", HudPosition.LEFT, 0, Color.ORANGE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, " ", HudPosition.LEFT, 0, Color.ORANGE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "   DISCORD: https://tiny.cc/ggnc", HudPosition.LEFT, 0, Color.ORANGE, HudReeval.NONE, SpecVisibility.DEFAULT)


rule "Skip 1 hero":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.CanSkipHero == true
    @Condition eventPlayer.CurrentHero != 0
    
    eventPlayer.D = eventPlayer.getUltCharge()
    eventPlayer.CanSkipHero = false
    eventPlayer.startForcingHero(eventPlayer.CurrentHero)
    wait(0.1)
    eventPlayer.addToScore(1)
    eventPlayer.K = len(getAllHeroes()) - eventPlayer.getScore()
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.setUltCharge(eventPlayer.D)
    eventPlayer.CurrentHero = eventPlayer.RandomizedHeroes[0]
    eventPlayer.RandomizedHeroes = eventPlayer.RandomizedHeroes.exclude(eventPlayer.CurrentHero)
    eventPlayer.preloadHero(eventPlayer.CurrentHero)


rule "Kill -=> Next hero":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress() == true
    @Condition eventPlayer.CurrentHero != 0
    
    wait(0.5)
    eventPlayer.D = eventPlayer.getUltCharge()
    eventPlayer.startForcingHero(eventPlayer.CurrentHero)
    wait(0.1)
    eventPlayer.addToScore(1)
    eventPlayer.K = len(getAllHeroes()) - eventPlayer.getScore()
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.setUltCharge(eventPlayer.D)
    eventPlayer.CurrentHero = eventPlayer.RandomizedHeroes[0]
    eventPlayer.RandomizedHeroes = eventPlayer.RandomizedHeroes.exclude(eventPlayer.CurrentHero)
    eventPlayer.preloadHero(eventPlayer.CurrentHero)


rule "Healing over time":
    @Event eachPlayer
    
    eventPlayer.stopAllHoT()
    wait()
    eventPlayer.startHoT(eventPlayer, 20, 20)
    wait(5)
    goto RULE_START


rule "Game ender":
    @Event playerDealtFinalBlow
    @Condition isGameInProgress() == true
    @Condition eventPlayer.CurrentHero == 0
    
    H = true
    setSlowMotion(20)
    eventPlayer.addToScore(1)
    eventPlayer.K = len(getAllHeroes()) - eventPlayer.getScore()
    wait(0.5)
    declarePlayerVictory(sorted(getAllPlayers(), lambda player: player.K).slice(0, ceil(0.5 * getNumberOfPlayers(Team.ALL))))


