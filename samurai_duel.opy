settings {
    "main": {
        "description": "Made by Kayst",
        "modeName": "Samurai Duel"
    },
    "lobby": {
        "allowPlayersInQueue": true,
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
            "enableRandomHeroes": true,
            "respawnTime%": 0,
            "scoreToWin": 30,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "genji": {
                "ammoClipSize%": 25,
                "damageDealt%": 200,
                "ability2Cooldown%": 0,
                "enableInfiniteUlt": true,
                "enableSecondaryFire": false,
                "enableSpawningWithUlt": true,
                "ability1Cooldown%": 100,
                "ultDuration%": 500,
                "passiveUltGen%": 10,
                "ultGen%": 100
            },
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

#Global variables

globalvar KillStreakLimit 0
globalvar MaxBlocks


#Player variables

playervar KillStreak 0
playervar Blocks 1


rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(6)
    wait(7)
    setMatchTime(10000)


rule "Init":
    KillStreakLimit = 5
    MaxBlocks = 3
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    wait(8)
    pauseMatchTime()
    setMatchTime(60)

rule "Player Joined":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.KillStreak = 0
    eventPlayer.Blocks = MaxBlocks
    wait(5.5)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    hudSubtext(eventPlayer, "\n\n\nBlock Charges: {0}".format(eventPlayer.Blocks), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.WHITE, OutlineVisibility.ALWAYS)

rule "Use Ult":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 2)
    wait(1)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isInAlternateForm(), 2)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)


rule "Dash No Damage":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setDamageDealt(0)
    waitUntil(eventPlayer.isUsingAbility1() == false, 1)
    eventPlayer.setDamageDealt(100)
    wait()



rule "Block Rule":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2()
    
    eventPlayer.Blocks -= 1
    wait(0.4)
    eventPlayer.cancelPrimaryAction()
    if eventPlayer.Blocks < 1:
        bigMessage(eventPlayer, "You ran out of blocks")
        eventPlayer.setAbility2Enabled(false)
        wait(5)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.Blocks = MaxBlocks
    wait()


rule "Player Died":
    @Event playerDied
    
    eventPlayer.KillStreak = 0
    eventPlayer.Blocks = MaxBlocks
    wait()


rule "Get a Kill":
    @Event playerDealtFinalBlow
    @Condition eventPlayer.isAlive() == true
    
    heal(eventPlayer, null, 150)
    eventPlayer.KillStreak += 1
    if eventPlayer.Blocks < MaxBlocks:
        eventPlayer.Blocks += 1
    wait(0.2)

rule "Recharge Blocks":
    @Event eachPlayer
    @Condition eventPlayer.Blocks < MaxBlocks and eventPlayer.Blocks > 0
    
    eventPlayer.Blocks += 1
    wait(3)
    if RULE_CONDITION:
        goto RULE_START

rule "Someone Won":
    @Event eachPlayer
    @Condition eventPlayer.getScore() >= 30

    declarePlayerVictory(eventPlayer)