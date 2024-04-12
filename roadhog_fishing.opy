
settings {
    "main": {
        "description": "Made By Kayst",
        "modeName": "Overwatch Fishing"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "ffaSlots": 10
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
            "enableKillCam": false
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "roadhog"
            ]
        }
    }
}


# Globar Vars

# Player Vars
playervar HookBaseVect
playervar HookProjectile
playervar HookEndVect
playervar Dummy
playervar Healed
playervar DummyIsHooking
playervar PlayerPos
playervar Parent

#!extension beamEffects

rule "Init":
    setMatchTime(5)
    disableGamemodeCompletion()
    disableMusic()
    disableAnnouncer()

rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(3)
    wait(7)
    setMatchTime(10000)


rule "Player Joined":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    wait(0.2)
    createDummy(Hero.ROADHOG, Team.ALL, -1, vect(0, 0, 0), vect(0, 0, 0))
    eventPlayer.Dummy = getLastCreatedEntity()
    eventPlayer.Dummy.attachTo(eventPlayer, vect(0, 0, 25))
    eventPlayer.Dummy.Parent = eventPlayer
    eventPlayer.setHealingReceived(50)


rule "Player has healed":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.Dummy.Healed = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 6)
    
rule "Dummy Spawn":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.hasSpawned()

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setInvisibility(Invis.ALL)

rule "Dummy Hook":
    @Event eachPlayer
    @Condition eventPlayer.Healed == true
    @Condition eventPlayer.DummyIsHooking == false
    @Condition eventPlayer.isDummy() == true

    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), eventPlayer.Parent.getPosition()), Relativity.TO_WORLD)
    eventPlayer.DummyIsHooking = true
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1() == false, 3)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.DummyIsHooking = false
    eventPlayer.Healed = false

    