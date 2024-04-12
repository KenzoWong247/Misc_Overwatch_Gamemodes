settings {
    "main": {
        "description": "Made by Kayst",
        "modeName": "Pinball"
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
            "scoreToWin": 100,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "lucio": {
                "secondaryFireCooldown%": 20,
                "secondaryFireKb%": 300
            },
            "hammond": {
                "enableAbility2": false,
                "damageReceived%": 10,
                "enableSecondaryFire": false,
                "movementSpeed%": 180,
                "enableAbility3": false,
                "enableRollOnly": true
            },
            "enabledHeroes": [
                "hammond"
            ],
            "general": {
                "movementGravity%": 400
            }
        }
    }
}

#Global variables

globalvar BallSpawn 0
globalvar BallEntity 1
globalvar LucioLeftPos 2
globalvar LucioRightPos 3
globalvar LucioLeft 4
globalvar LucioRight 5
globalvar PlayerPos 6
globalvar CurrentPlayer 7
globalvar DeadBall 8
globalvar Teleporters 9
globalvar Bumpers 10
globalvar Score 11
globalvar Launching 12
globalvar GameOver 13
globalvar LaunchPower 14
globalvar LaunchPos
globalvar LaunchHud
globalvar Lives
globalvar NextPlayer
globalvar Hold
globalvar HoldPos
globalvar Bonus
globalvar BonusPos
globalvar BonusFlags
globalvar BonusEntities
globalvar BonusTimer
globalvar SaveBallChance
globalvar SaveBallPos
globalvar Playing
globalvar BonusAttackPos
globalvar AttackerEntity
globalvar BossEntity
globalvar SpawnBossPos
globalvar BossPos
globalvar AttackerPos
globalvar BossFlagMarkers
globalvar BossFlags
globalvar TeleportDests
globalvar BossHPBar
globalvar Players
globalvar PlayerInd

playervar SkipCount



rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(6)
    wait(7)
    setMatchTime(10000)

rule "Init":
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()
    
    Playing = false
    DeadBall = false
    BonusFlags = [false, false, false]
    BossFlags = [false, false]
    SaveBallChance = 50
    BonusTimer = 0
    Bonus = 1
    Lives = 4
    Score = 0
    LaunchPower = 0
    Launching = true
    GameOver = false
    Hold = false
    BossEntity = null
    Players = []
    PlayerInd = 0

    BallSpawn = vect(19, 0, -19)
    LucioLeftPos = vect(17.95, 1, 4.15)
    LucioRightPos = vect(17.95, 1, -4.15)
    PlayerPos = vect(30, 10, 0)
    LaunchPos = vect(-2, 0, -16)
    HoldPos = vect(-3, 0, -5)
    TeleportDests = [vect(5, 1, 0), vect(-10, 1, 0)]

    Teleporters = [vect(14, 0, 10), vect(14, 0, -10)]
    Bumpers = [vect(-2, 0, 12), vect(-3, 0, 5), vect(-1, 0, 0), vect(7, 0, 7), vect(0, 0, -9), vect(-9, 0, -5)]
    BonusPos = [vect(-10, 0, -1), vect(7, 0, 12), vect(7, 0, -9)]
    SaveBallPos = [vect(18.5, 0, 6.5), vect(18.5, 0, -6.5)]
    BonusAttackPos = vect(-12, 0, 4)
    SpawnBossPos = [vect(3, 0, 16), vect(3, 0, -16)]

    AttackerPos = vect(-22, 0, 5)
    BossPos = vect(-22, 0, -5)

    wait(0.2)

    #Main Ring
    createEffect(getAllPlayers(), Effect.RING, Color.BLUE, vect(0, 1, 0), 20, EffectReeval.VISIBILITY)

    #SaveBall Zones
    createEffect(getAllPlayers(), Effect.RING, Color.RED, SaveBallPos[0], 1.75, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, SaveBallPos[1], 1.75, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "{}%".format(SaveBallChance), SaveBallPos[0], 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "{}%".format(SaveBallChance), SaveBallPos[1], 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    
    #Bumpers
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[0], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[1], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[2], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[3], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[4], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, Bumpers[5], 2, EffectReeval.VISIBILITY)

    # Teleporters
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, Teleporters[0], 1.5, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, Teleporters[1], 1.5, EffectReeval.VISIBILITY)

    # Hole Launch
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, HoldPos, 2, EffectReeval.VISIBILITY) 
    createInWorldText(getAllPlayers(), "Launcher", HoldPos, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    
    # Bonus Attack Ring
    createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, BonusAttackPos, 2, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "Attack", BonusAttackPos, 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    
    # Spawn Boss Rings
    createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, SpawnBossPos[0], 2, EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, SpawnBossPos[1], 2, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "Spawn Boss", SpawnBossPos[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Spawn Boss", SpawnBossPos[1], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    

    # Bonus Rings
    createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, BonusPos[0], 2, EffectReeval.VISIBILITY) 
    createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, BonusPos[1], 2, EffectReeval.VISIBILITY) 
    createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, BonusPos[2], 2, EffectReeval.VISIBILITY) 
    createInWorldText(getAllPlayers(), "Bonus", BonusPos[0], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Bonus", BonusPos[1], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Bonus", BonusPos[2], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    
    # Score Backdrop
    createInWorldText(getAllPlayers(), "Score: {}".format(Score), vect(-20, 8, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Bonus Timer: {}".format(BonusTimer), vect(-20, 12, 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "{} Lives: {}  Bonus: x{}".format(heroIcon(Hero.HAMMOND), Lives, Bonus), vect(-20, 14, 0), 3, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, Color.ORANGE, SpecVisibility.DEFAULT)
    
    wait(2)
    createDummy(Hero.HAMMOND, Team.ALL, -1, BallSpawn, vect(1, 0, 0))
    BallEntity = getLastCreatedEntity()
    createDummy(Hero.LUCIO, Team.ALL, -1, LucioLeftPos, directionTowards(LucioLeftPos, vect(0, 0, 0)))
    LucioLeft = getLastCreatedEntity()
    createDummy(Hero.LUCIO, Team.ALL, -1, LucioRightPos, directionTowards(LucioRightPos, vect(0, 0, 0)))
    LucioRight = getLastCreatedEntity()

    wait(0.2)
    hudSubheader(getAllPlayers(), "\n\n\n", HudPosition.LEFT, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), "Current Player: {}\nNext Player: {}".format(CurrentPlayer, NextPlayer), HudPosition.LEFT, 0, Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

    # createInWorldText(getAllPlayers(), "(20, 20)", vect(20, 0, 20), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    # createInWorldText(getAllPlayers(), "(-20, 20)", vect(-20, 0, 20), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    # createInWorldText(getAllPlayers(), "(20, -20)", vect(20, 0, -20), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    # createInWorldText(getAllPlayers(), "(-20, -20)", vect(-20, 0, -20), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
    # createInWorldText(getAllPlayers(), "(0, 0)", vect(0, 0, 0), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)

    wait(8)
    pauseMatchTime()
    setMatchTime(60)

    Playing = true


rule "Player Join":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    waitUntil(eventPlayer.hasSpawned(), 2)
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableKillFeed()
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.startForcingPosition(PlayerPos, false)
    wait(0.2)
    eventPlayer.setFacing(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.2)
    eventPlayer.disableHeroHud()
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    wait(0.2)
    eventPlayer.SkipCount = 0
    
    Players.append(eventPlayer)
    if not CurrentPlayer:
        CurrentPlayer = Players[PlayerInd]
        PlayerInd = 0
        NextPlayer = CurrentPlayer

    if len(Players) == 2:
        PlayerInd = 1
        NextPlayer = Players[PlayerInd]
    
rule "Player Left":
    @Event playerLeft
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == CurrentPlayer

    Lives = 0
    Players.remove(eventPlayer)


rule "Launch Pinball":
    @Event global
    @Condition Playing
    @Condition GameOver == false
    @Condition Launching == true

    progressBarHud(getAllPlayers(), LaunchPower, "         Launch Power: {0}\n{1}: {2}".format(LaunchPower, iconString(Icon.ARROW_UP), "{0}  {1}: {2}".format(buttonString(Button.ABILITY_1), iconString(Icon.ARROW_DOWN), "{}  {}: {}".format(buttonString(Button.CROUCH), iconString(Icon.FIRE), buttonString(Button.INTERACT)))), HudPosition.TOP, 3, Color.GREEN, Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT)
    LaunchHud = getLastCreatedText()


rule "Launch Power":
    @Event eachPlayer
    @Condition Playing
    @Condition Launching == true
    @Condition GameOver == false
    @Condition eventPlayer == CurrentPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.INTERACT)

    wait(0.1)
    if eventPlayer.isHoldingButton(Button.ABILITY_1) and LaunchPower < 100:
        LaunchPower += 10
    elif eventPlayer.isHoldingButton(Button.CROUCH) and LaunchPower > 0:
        LaunchPower -= 10
    elif eventPlayer.isHoldingButton(Button.INTERACT):
        Launching = false

    if RULE_CONDITION:
        goto RULE_START

rule "Pinball Launched":
    @Event global
    @Condition Playing
    @Condition Launching == false
    @Condition GameOver == false

    BallEntity.teleport(LaunchPos)
    wait(0.2)
    DeadBall = false
    destroyProgressBarHud(LaunchHud)

    BallEntity.applyImpulse(directionTowards(LaunchPos, vect(-20, 0, -9)), LaunchPower * 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.5)
    BallEntity.applyImpulse(directionTowards(LaunchPos, vect(-20, 0, -9)), LaunchPower * 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    
    
    wait(0.2)
    LaunchPower = 0


rule "Game Over":
    @Event global
    @Condition Playing
    @Condition Lives <= 0

    GameOver = true
    CurrentPlayer.SkipCount = 0
    hostPlayer.SkipCount = 0
    destroyAllProgressBarHuds()
    bigMessage(getAllPlayers(), "Game Over! {} ended with a score of {}!".format(CurrentPlayer, Score))
    if Score > CurrentPlayer.getScore():
        CurrentPlayer.setScore(Score)
        bigMessage(getAllPlayers(), "New High Score!")
    wait(0.2)
    destroyEffect(BonusEntities[0])
    destroyEffect(BonusEntities[1])
    destroyEffect(BonusEntities[2])
    destroyEffect(BossFlagMarkers[0])
    destroyEffect(BossFlagMarkers[1])
    wait(2)
    BonusEntities = []
    BonusFlags = [false, false, false]
    BossFlagMarkers = []
    BossFlags = [false, false]
    wait(2)
    destroyDummy(Team.ALL, AttackerEntity.getSlot())
    destroyDummy(Team.ALL, BossEntity.getSlot())
    destroyInWorldText(BossHPBar)

    PlayerInd += 1
    if PlayerInd >= len(Players):
        PlayerInd = 0

    CurrentPlayer = NextPlayer
    NextPlayer = Players[PlayerInd]

    bigMessage(getAllPlayers(), "{} is now playing".format(CurrentPlayer))
    wait(3)
    Lives = 3
    Score = 0
    Bonus = 1
    BonusTimer = 0
    GameOver = false

rule "Kill Ball Faster":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition eventPlayer.getPosition().y < -1

    kill(eventPlayer, null)

rule "Ball Always Moves Down":
    @Event eachPlayer
    @Condition Playing
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition eventPlayer.getPosition().y <= 0
    @Condition Launching == false
    @Condition Hold == false
    
    #eventPlayer.startThrottleInDirection(vect(1, 0, 0), 10, Relativity.TO_WORLD, Throttle.ADD_TO_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
    eventPlayer.startAcceleration(vectorTowards(vect(0,0,0), vect(5, 0, 0)), 40, 20, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)

rule "Ball Respawned":
    @Event eachPlayer
    @Condition Playing
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    
    Lives -= 1
    eventPlayer.teleport(BallSpawn)
    eventPlayer.setFacing(vect(1, 0, 0), Relativity.TO_WORLD)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.stopAcceleration()
    Launching = true
    DeadBall = false
    SaveBallChance = 50
    Bonus = 1
    BonusTimer = 0


rule "Player Left Bumper":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == CurrentPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    LucioLeft.startForcingButton(Button.SECONDARY_FIRE)
    wait(1)
    LucioLeft.stopForcingButton(Button.SECONDARY_FIRE)
    wait(0.2)


rule "Player Right Bumper":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == CurrentPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    LucioRight.startForcingButton(Button.SECONDARY_FIRE)
    wait(1)
    LucioRight.stopForcingButton(Button.SECONDARY_FIRE)
    wait(0.2)


rule "Ball Knocked Back":
    @Event playerReceivedKnockback
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition attacker.getCurrentHero() == Hero.LUCIO
    @Condition Launching == false
    
    eventPlayer.applyImpulse(eventDirection, 100, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Dead Ball":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition DeadBall == false
    @Condition eventPlayer.getPosition().x >= 18.5   
    DeadBall = true


rule "Keep Ball In Bounds":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition Launching == false
    @Condition DeadBall == false
    @Condition distance(eventPlayer.getPosition(), vect(0, 0, 0)) > 19
    
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), vect(0, 0, 0)), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "Teleporters":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition DeadBall == false
    @Condition any([distance(eventPlayer.getPosition(), player) <= 2 for player in Teleporters]) == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.BLUE, eventPlayer.getPosition(), 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, PlayerPos, 30)
    if random.randint(0, 100) < 75:
        eventPlayer.teleport(TeleportDests[0])
    else:
        eventPlayer.teleport(TeleportDests[1])
        eventPlayer.applyImpulse(vect(random.randint(-20, 20), 0, random.randint(-20, 20)), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    DeadBall = false


rule "Hit Bumper":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition Launching == false
    @Condition DeadBall == false
    @Condition any([distance(eventPlayer.getPosition(), player) <= 2.25 for player in Bumpers]) == true

    
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), ([player for player in Bumpers if distance(eventPlayer.getPosition(), player) <= 2.25]).last()), -200, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), 3)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, PlayerPos, 30)
    Score += 50 * Bonus


rule "Hit Holder":
    @Event eachPlayer
    @Condition GameOver == false
    @Condition Launching == false
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition distance(eventPlayer.getPosition(), HoldPos) <= 2

    Hold = true
    
    eventPlayer.stopTransformingThrottle()
    eventPlayer.stopAcceleration()
    eventPlayer.startForcingPosition(HoldPos, false)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, HoldPos, 3)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, PlayerPos, 30)

    wait(2)

    eventPlayer.stopForcingPosition()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, HoldPos, 3)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, null, PlayerPos, 30)
    eventPlayer.applyImpulse(directionTowards(HoldPos, vect(random.randint(-20, 20), random.randint(0, 5), random.randint(-20, 20))), random.randint(10, 50), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    Hold = false


rule "Hit Bonus 0":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition Launching == false
    @Condition DeadBall == false
    @Condition BonusFlags[0] == false
    @Condition distance(BonusPos[0], eventPlayer.getPosition()) < 2.25


    BonusFlags[0] = true
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GREEN, BonusPos[0], 2, EffectReeval.VISIBILITY)
    BonusEntities[0] = getLastCreatedEntity()
    wait(0.2)

rule "Hit Bonus 1":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition Launching == false
    @Condition DeadBall == false
    @Condition BonusFlags[1] == false
    @Condition distance(BonusPos[1], eventPlayer.getPosition()) < 2.25


    BonusFlags[1] = true
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GREEN, BonusPos[1], 2, EffectReeval.VISIBILITY)
    BonusEntities[1] = getLastCreatedEntity()
    wait(0.2)

rule "Hit Bonus 2":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition Launching == false
    @Condition DeadBall == false
    @Condition BonusFlags[2] == false
    @Condition distance(BonusPos[2], eventPlayer.getPosition()) < 2.25


    BonusFlags[2] = true
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GREEN, BonusPos[2], 2, EffectReeval.VISIBILITY)
    BonusEntities[2] = getLastCreatedEntity()
    wait(0.2)


rule "All Bonus Flags Hit":
    @Event global
    @Condition Playing
    @Condition BonusFlags[0] and BonusFlags[1] and BonusFlags[2]

    bigMessage(getAllPlayers(), "All Bonus Spots Hit!")

    Bonus += random.randint(1, 4)
    BonusTimer = 60

    wait()
    bigMessage(getAllPlayers(), "Bonus x{} Points Activated!".format(Bonus))


    wait(2)
    destroyEffect(BonusEntities[0])
    destroyEffect(BonusEntities[1])
    destroyEffect(BonusEntities[2])

    wait(2)
    BonusFlags = [false, false, false]
    BonusEntities = []
    
rule "Deadball Fix":
    @Event eachPlayer
    @Condition DeadBall == true
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition eventPlayer.getPosition().x < 16
    DeadBall = false

rule "Bonus Active":
    @Event global
    @Condition Playing
    @Condition BonusTimer > 1
    @Condition Bonus > 1

    wait(1)
    if BonusTimer >= 1:
        BonusTimer -= 1
    
    if BonusTimer <= 0:
        Bonus = 1
        bigMessage(getAllPlayers(), "Bonus has expired")

    if RULE_CONDITION:
        goto RULE_START

rule "Extra Life":
    @Event global
    @Condition Playing
    @Condition GameOver == false
    @Condition Score > 0 and Score % 1000 == 0

    Lives += 1
    bigMessage(getAllPlayers(), "Bonus Life!")

rule "Ball Recover Spot":
    @Event eachPlayer
    @Condition Playing
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition distance(eventPlayer.getPosition(), SaveBallPos[0]) < 1.5 or distance(eventPlayer.getPosition(), SaveBallPos[1]) < 1.5

    DeadBall = true
    if random.randint(0, 100) < SaveBallChance:
        eventPlayer.stopAcceleration()
        eventPlayer.startForcingPosition(LaunchPos, false)
        SaveBallChance = floor(SaveBallChance/2)
        bigMessage(getAllPlayers(), "Ball Saved!")
        wait(2)
        Launching = true
        wait(0.2)
        LaunchPower = 100
        DeadBall = false
        eventPlayer.stopForcingPosition()
        wait(0.2)
        Launching = false


rule "Boss Flag 0":
    @Event eachPlayer
    @Condition Playing
    @Condition BossFlags[0] == false
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition distance(eventPlayer.getPosition(), SpawnBossPos[0]) < 2

    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.GREEN, SpawnBossPos[0], 2, EffectReeval.VISIBILITY)
    BossFlagMarkers[0] = getLastCreatedEntity()
    BossFlags[0] = true

rule "Boss Flag 1":
    @Event eachPlayer
    @Condition Playing
    @Condition BossFlags[1] == false
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition distance(eventPlayer.getPosition(), SpawnBossPos[1]) < 2

    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.GREEN, SpawnBossPos[1], 2, EffectReeval.VISIBILITY)
    BossFlagMarkers[1] = getLastCreatedEntity()  
    BossFlags[1] = true

rule "All Bonus Flags Hit":
    @Event global
    @Condition Playing
    @Condition BossFlags[0] and BossFlags[1]

    bigMessage(getAllPlayers(), "A boss has spawned!")
    createDummy(Hero.MCCREE, Team.ALL, -1, AttackerPos, directionTowards(vect(0, 0, 0), vect(0, 0, -5)))
    AttackerEntity = getLastCreatedEntity()
    AttackerEntity.startForcingPosition(AttackerPos, false)
    createDummy(Hero.REINHARDT, Team.ALL, -1, BossPos, directionTowards(vect(0, 0, 0), vect(0, 0, 5)))
    BossEntity = getLastCreatedEntity()
    BossEntity.startForcingPosition(BossPos, false)
    AttackerEntity.startScalingSize(2, false)
    BossEntity.startScalingSize(2, false)
    createInWorldText(getAllPlayers(), "Boss HP: {}/{}".format(BossEntity.getHealth(), BossEntity.getMaxHealth()), BossPos + vect(0, 6, 0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    BossHPBar = getLastCreatedText()


rule "Bonus Character Attack":
    @Event eachPlayer
    @Condition Playing
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND
    @Condition distance(eventPlayer.getPosition(), BonusAttackPos) < 2

    AttackerEntity.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.2)


rule "Boss Died":
    @Event playerDied
    @Condition Playing
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer == BossEntity

    wait(0.2)
    bigMessage(getAllPlayers(), "You killed the boss!")
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, BossPos, 9)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, null, PlayerPos, 30)
    wait(1)

    Score += 2000
    Lives += 1
    destroyDummy(Team.ALL, BossEntity.getSlot())
    destroyDummy(Team.ALL, AttackerEntity.getSlot())
    destroyInWorldText(BossHPBar)

    destroyEffect(BossFlagMarkers[0])
    destroyEffect(BossFlagMarkers[1])
    
    wait(2)
    BossFlagMarkers = []
    BossFlags = [false, false]

rule "Skip Player":
    @Event eachPlayer
    @Condition GameOver == false
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == hostPlayer or eventPlayer == CurrentPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    if eventPlayer.SkipCount >= 10:
        Lives = 0
        eventPlayer.SkipCount = 0
        wait(5)
    else:
        eventPlayer.SkipCount += 1
        smallMessage(eventPlayer, " Forcing game end {}/10".format(eventPlayer.SkipCount))
        wait(1)

        if RULE_CONDITION:
            goto RULE_START
        

    