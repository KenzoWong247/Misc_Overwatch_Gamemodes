settings {
    "main": {
        "description": "Made by Kayst",
        "modeName": "Ball With Your Friends"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "hollywoodHalloween",
                "hollywood",
                "eichenwaldeHalloween",
                "eichenwalde",
                "havana",
                "hanamura"
            ]
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true,
            "scoreToWin": 30,
            "respawnTime%": 0,
            "enableSelfInitiatedRespawn": true,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "hammond": {
                "enableAbility2": false,
                "damageReceived%": 10,
                "enableSecondaryFire": false,
                "enableUlt": false,
                "enableRollOnly": true
            },
            "enabledHeroes": [
                "hammond"
            ],
            "general": {
                "movementGravity%": 75
            }
        }
    }
}
globalvar AllPlayers
globalvar CurrentHole
globalvar HoleIndex
globalvar HolePars
globalvar CourseArray # Array Of Hole Params [0: Start Vect, 1: Hole Vect]
globalvar CourseHollywood # Array of Holes
globalvar HoleEntity
globalvar TeeOffEntity
globalvar FlagEntity
globalvar FinishedPlayers
globalvar NextHole
globalvar ParString 
globalvar I
globalvar MaxStrokes
globalvar EndGame
globalvar Winner
globalvar ParTotal
globalvar DebugMode

playervar Power
playervar PowerHud
playervar ShotTaken
playervar CurrentStrokes
playervar TotalStrokes
playervar Scorecard
playervar ScoreString
playervar FinishedHole
playervar HoleText
playervar PowerUp
playervar FinishString
playervar I
playervar ScoreboardText
playervar ScoreboardString
playervar ResetTimer
playervar LastShotLoc

subroutine _SpawnHole
subroutine _ScoreBoard
subroutine _DestroyScoreBoard

rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(6)
    wait(7)
    pauseMatchTime()
    setMatchTime(10000)

rule "Init":
    disableAnnouncer()
    disableMusic()
    disableGamemodeCompletion()
    disableScoring()

    # DEBUG
    DebugMode = false

    # Var Inits
    CurrentHole = 0
    HoleIndex = 0
    EndGame = false
    MaxStrokes = 10
    ParTotal = 0
    if DebugMode:
        MaxStrokes = 9999

    # Indent Every 4 Holes
    switch getCurrentMap():
        case Map.EICHENWALDE_HALLOWEEN:
        case Map.EICHENWALDE:
            CourseArray = [
                vect(33.09, 4.81, -62.74), vect(-28.19, -1.97, -11.96), vect(20.46, 9, -25.67), vect(-5.30, 3.55, -85.37), vect(8.54, 11.01, -85.72), vect(2.8, 0, -15.54), vect(4.19, 5.83, -66.90), vect(99.31, 12.66, -72.28), 
                vect(38.26, 10.75,-98.56), vect(56.7, 21, -67.78), vect(30.41, 14, -81.9), vect(60.94, 6.72, -106.79), vect(86.66, 12.90, -100.67), vect(44.95, 5.24, -50.20), vect(60.33, 18.72, -91.97), vect(62.54, 4.72, -82.73), 
                vect(90.30, 12.72, -57.51), vect(126.7, 14.76, -14.95)]
            HolePars = [3, 3, 5, 5, 4, 3, 3, 5, 5]
            break
        case Map.HOLLYWOOD_HALLOWEEN:
        case Map.HOLLYWOOD:
            CourseArray = [
                vect(-43.25, -0.15, 56.61), vect(12.72, 0, 41.33), vect(20.92, 6, 59.61), vect(-51.74, -0.25, 13.14), vect(-51.53, -0.25, -13.79), vect(12.93, 0, 70.81), vect(-14.09, 1.01, 69.92), vect(-20.13, 1.60, 1.18), 
                vect(-25.26, 7.75, 10.49), vect(0.53, 2, -59.44), vect(28.91, 6.80, -77.9), vect(-16.45, 1.75, -13.07), vect(-10.08, 1.60, -20.69), vect(0.17, 1.89, -116.48), vect(-3.12, 1.52, -103.99), vect(-15.5, 1.75, -133.70), 
                vect(-35.13, 1.75, -135.18), vect(12.82, 3.75, -96.26), vect(1.37, 11.01, -59.99), vect(-46.14, -0.4, 4.88), vect(-29.37, 13.86, -12.98), vect(-20.19, 1, 68.16), vect(-14.69, 5.01, 40.24), vect(-36.50, 1.75, -16.50), 
                vect(-20.85, 5.75, -14.38), vect(5.41, 11.01, -63.72), vect(27.27, 2.78, -53.58), vect(7.90, 1.75, -5.77),  vect(-17.9, 9.75, -100.5), vect(-17.46, 3.75, -146.54), vect(-28.70, 6.82, -137.92), vect(-42.12, 1.75, -92.12), 
                vect(-47.11, 9.75, -111.57), vect(15.53, 1.60, -82.46), vect(8.54, 12.84, -38.38), vect(9.37, 6, 47.22)]
            HolePars = [3, 3, 5, 4, 4, 3, 5, 3, 3, 5, 4, 4, 5, 3, 4, 3, 4, 5]
            break
        case Map.HAVANA:
            CourseArray = [
                vect(-106.77, 4.00, -59.39), vect(-15.38, 6, -43), vect(-34.15, 5.84, -28.88), vect(-7.90, 6.03, -59.23), vect(-15.82, 11, -50.44), vect(-24.46, 14.44, -85.38), vect(-33.32, 10, -98.31), vect(27, 6, -82.49),
                vect(11.91, 12, -79.09), vect(76.98, 6.99, -73.25), vect(70.44, 5.99, -92.35), vect(105.51, -0.29, -48.48), vect(84.83, 11.96, -46.97), vect(129.96, 9.93, -30.88), vect(140.60, 6.06, -46.10), vect(96.58, 2, -72.62),
                vect(64.06, 12, -83.19), vect(9.67, 6, -93.64), vect(9.68, 12, -79.95), vect(40.24, 6, -51.06), vect(34.15, 12, -56.75), vect(-24.80, 6, -89.78), vect(-32.77, 10, -94.38), vect(-84.61, 8.22, -50.48),
                vect(-97.32, 3.85, -37.21), vect(-46.81, 6, -71.99), vect(-70.78, 3.85, -51.12), vect(-0.94, 12, -79.78), vect(61.28, 11, -67.98), vect(83.59, 9, -33.47), vect(69.72, 6.04, -82.98), vect(124.81, 6, -57.72),
                vect(106.03, 7.03, -45.91), vect(56.70, 5.81, -83.20), vect(65.23, 10, -101.16), vect(0.75, 6, -79.27)
                ]
            HolePars = [4, 3, 5, 3, 5, 4, 3, 4, 4, 4, 3, 4, 3, 4, 4, 3, 4, 4]
            break
        case Map.HANAMURA:
        case Map.HANAMURA_WINTER:
            CourseArray = [
                vect(63.4, -2, 30.34), vect(39.25, 0.04, -26.45), vect(48.08, 2, -26.74), vect(41, 0.31, 34.68), vect(48.15, 6, 13.13), vect(6.34, 0, 8.34), vect(12.45, -1.22, 35.80), vect(32.29, 2, -29.18),
                vect(-19.11, -1.25, -14.62), vect(-23.27, -1, -54.32), vect(-35.17, 1, -62.01), vect(-0.46, -5.1, -74.33), vect(38.44, 3, -75.51), vect(13.2, 7.07, -48.93), vect(-0.88, 5, -44.79), vect(12.13, 11.22, 21.09), 
                vect(14.24, 4.11, 9.48), vect(-16.34, -0.75, -90.24)
            ]
            HolePars = [5, 4, 3, 3, 4, 4, 5, 5, 4]
            break
        default:
            CourseArray = [vect(0, 0, 0), vect(0, -999, 0)]
            HolePars = [0]

    _SpawnHole()

    ParString = "     Par: "
    for I in range(len(HolePars)):
        ParString = "{}   {}".format(ParString, HolePars[I])
        ParTotal += HolePars[I]
    
rule "Player Joined":
    @Event playerJoined
    
    AllPlayers = getAllPlayers()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)

    # Var Inits
    eventPlayer.ShotTaken = false
    eventPlayer.CurrentStrokes = 0
    eventPlayer.FinishedHole = 0
    eventPlayer.ScoreString = ""
    eventPlayer.TotalStrokes = 0

    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()

    # Hud
    hudSubheader(eventPlayer, "\n\n\n", HudPosition.LEFT, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "Hole: {} Par: {}".format(CurrentHole + 1, HolePars[CurrentHole]), HudPosition.LEFT, 1, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "Strokes: {}".format(eventPlayer.CurrentStrokes), HudPosition.LEFT, 2, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    
    if DebugMode:
        hudSubheader(eventPlayer, "{}, {}, {}".format(eventPlayer.getPosition().x, eventPlayer.getPosition().y, eventPlayer.getPosition().z), HudPosition.LEFT, 0, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
        hudSubheader(eventPlayer, "HSpeed: {}, VSpeed: {}, Velocity: {}".format(eventPlayer.getHorizontalSpeed(), eventPlayer.getVerticalSpeed(), eventPlayer.getVelocity()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
        hudSubheader(eventPlayer, "Shot Taken: {}".format(eventPlayer.ShotTaken), HudPosition.LEFT, 0, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
        hudSubheader(eventPlayer, "ParString: {}, ScoreString: {}, FinishedPlayers: {}".format(strLen(ParString), strLen(eventPlayer.ScoreString), FinishedPlayers), HudPosition.LEFT, 0, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)

    if not DebugMode:
        eventPlayer.teleport(CourseArray[HoleIndex])
    
    eventPlayer.LastShotLoc = eventPlayer.getPosition()

    createInWorldText(eventPlayer, "Hole {}\nDist to Hole: {}m".format(CurrentHole + 1, distance(eventPlayer.getPosition(), CourseArray[HoleIndex + 1])), CourseArray[HoleIndex + 1], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    eventPlayer.HoleText = getLastCreatedText()
    
    wait(1)
    eventPlayer.setFacing(vectorTowards(CourseArray[HoleIndex], CourseArray[HoleIndex + 1]), Relativity.TO_WORLD)

rule "Player Left":
    @Event playerLeft
    AllPlayers = getAllPlayers()

rule "Charge Shot":
    @Event eachPlayer
    @Condition eventPlayer.FinishedHole == 0
    @Condition eventPlayer.ShotTaken == false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    if eventPlayer.Power == 0 and not eventPlayer.PowerHud:
        progressBarHud(eventPlayer, eventPlayer.Power, "Power", HudPosition.TOP, 3, Color.RED, Color.BLACK, ProgressHudReeval.VALUES_AND_COLOR, SpecVisibility.DEFAULT)
        eventPlayer.PowerHud = getLastCreatedText()    
        eventPlayer.PowerUp = true

    if eventPlayer.PowerUp:
        eventPlayer.Power += 1
    else:
        eventPlayer.Power -= 1
    
    if eventPlayer.Power >= 100:
        eventPlayer.PowerUp = false
    
    if eventPlayer.Power <= 0:
        eventPlayer.PowerUp = true
    
    wait(0.01)
    if RULE_CONDITION:
        goto RULE_START

rule "Shoot Ball":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.ShotTaken == false
    @Condition eventPlayer.Power > 0

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.LastShotLoc = eventPlayer.getPosition()
    wait()
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), floor(eventPlayer.Power / 2), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if not DebugMode:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.CurrentStrokes += 1

    destroyProgressBarHud(eventPlayer.PowerHud)
    wait()
    eventPlayer.PowerHud = null
    eventPlayer.Power = 0
    wait(1)
    eventPlayer.ShotTaken = true

rule "Phase Through at Tee Off":
    @Event eachPlayer
    @Condition distance(eventPlayer, CourseArray[HoleIndex]) < 2

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)

rule "Remove Phase Out":
    @Event eachPlayer
    @Condition distance(eventPlayer, CourseArray[HoleIndex]) > 2

    eventPlayer.clearStatusEffect(Status.PHASED_OUT)

rule "Player Is Not Moving":
    @Event eachPlayer
    @Condition eventPlayer.ShotTaken == true
    @Condition eventPlayer.getHorizontalSpeed() <= 0.11 and eventPlayer.getHorizontalSpeed() >= -0.11
    @Condition eventPlayer.getVerticalSpeed() == 0

    smallMessage(eventPlayer, " Stopped Moving")
    eventPlayer.ShotTaken = false

    if eventPlayer.FinishedHole == false:
        if eventPlayer.CurrentStrokes >= MaxStrokes:
            bigMessage(AllPlayers, "{} has run out of strokes".format(eventPlayer))
            eventPlayer.CurrentStrokes = 14
            eventPlayer.FinishedHole = 1
            eventPlayer.TotalStrokes += eventPlayer.CurrentStrokes
            eventPlayer.ScoreString = "{} {}".format(eventPlayer.ScoreString, eventPlayer.CurrentStrokes)
            FinishedPlayers += 1


rule "Player Died":
    @Event playerDied
    @Condition eventPlayer.FinishedHole == 0

    eventPlayer.CurrentStrokes += 1
    wait(2)
    bigMessage(eventPlayer, "+1 Strokes for going out of bounds")

rule "Player Respawned":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()

    if len(CourseArray) < 1 and DebugMode:
        return
    if eventPlayer.LastShotLoc:
        eventPlayer.teleport(eventPlayer.LastShotLoc)
    else:   
        eventPlayer.teleport(CourseArray[HoleIndex])
    wait()
    eventPlayer.setFacing(vectorTowards(CourseArray[HoleIndex], CourseArray[HoleIndex + 1]), Relativity.TO_WORLD)

rule "Player In Hole":
    @Event eachPlayer
    @Condition eventPlayer.FinishedHole == 0
    @Condition distance(eventPlayer, CourseArray[HoleIndex + 1]) < 2

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.FinishedHole = 1

    switch eventPlayer.CurrentStrokes - HolePars[CurrentHole]:
        case -3:
            eventPlayer.FinishString = "Albatross"
            break
        case -2:
            eventPlayer.FinishString = "Eagle"
            break
        case -1:
            eventPlayer.FinishString = "Birdie"
            break
        case 0:
            eventPlayer.FinishString = "Par"
            break
        case 1:
            eventPlayer.FinishString = "Bogey"
            break
        case 2:
            eventPlayer.FinishString = "Double Bogey"
            break
        case 3:
            eventPlayer.FinishString = "Triple Bogey"
            break
        default:
            eventPlayer.FinishString = "+{}".format(eventPlayer.CurrentStrokes - HolePars[CurrentHole])
            break

    if eventPlayer.CurrentStrokes == 1:
        eventPlayer.FinishString = "Hole in One"
        bigMessage(AllPlayers, "{} got a hole in 1!".format(eventPlayer))

    bigMessage(eventPlayer, "{}! Strokes {}".format(eventPlayer.FinishString, eventPlayer.CurrentStrokes))
    eventPlayer.setMoveSpeed(0)

    if eventPlayer.CurrentStrokes < 10:
        if eventPlayer.CurrentStrokes == 1:
            eventPlayer.ScoreString = "{}    {}".format(eventPlayer.ScoreString, eventPlayer.CurrentStrokes)
        else:
            eventPlayer.ScoreString = "{}   {}".format(eventPlayer.ScoreString, eventPlayer.CurrentStrokes)
    else:
        eventPlayer.ScoreString = "{} {}".format(eventPlayer.ScoreString, eventPlayer.CurrentStrokes)
    eventPlayer.TotalStrokes += eventPlayer.CurrentStrokes

    wait(1)
    eventPlayer.setMoveSpeed(100)
    FinishedPlayers += 1
    bigMessage(AllPlayers, "{} has finished the hole!".format(eventPlayer))

    if not DebugMode:
        eventPlayer.disableRespawn()
        kill(eventPlayer, null)

rule "Hole Complete":   
    @Event global
    @Condition isGameInProgress()
    @Condition len(AllPlayers) > 0
    @Condition FinishedPlayers == len(AllPlayers)

    CurrentHole += 1
    HoleIndex = CurrentHole * 2 

    if CurrentHole >= len(HolePars):
        EndGame = true
        return

    NextHole = true
    _SpawnHole()
    FinishedPlayers = 0
    wait()
    NextHole = false

rule "Hole Complete Player":
    @Event eachPlayer
    @Condition NextHole == true and eventPlayer.FinishedHole == 1

    eventPlayer.FinishedHole = 0
    eventPlayer.CurrentStrokes = 0
    eventPlayer.enableRespawn()
    eventPlayer.respawn()
    wait()
    eventPlayer.teleport(CourseArray[HoleIndex])

    if eventPlayer.HoleText:
        destroyInWorldText(eventPlayer.HoleText)
    
    wait()
    
    createInWorldText(eventPlayer, "Hole {}\nDist to Hole: {}".format(CurrentHole + 1, distance(eventPlayer.getPosition(), CourseArray[HoleIndex + 1])), CourseArray[HoleIndex + 1], 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
    eventPlayer.HoleText = getLastCreatedText()

    eventPlayer.setFacing(vectorTowards(CourseArray[HoleIndex], CourseArray[HoleIndex + 1]), Relativity.TO_WORLD)

rule "Reset":
    @Event eachPlayer
    @Condition eventPlayer.FinishedHole == 0
    @Condition EndGame == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    if eventPlayer.ResetTimer >= 5:
        eventPlayer.teleport(CourseArray[HoleIndex])
        eventPlayer.CurrentStrokes += 1
        bigMessage(eventPlayer, "Reset to Start +1 Strokes")
        wait(1)
        eventPlayer.ResetTimer = 0
        eventPlayer.stopForcingButton(Button.RELOAD)
    else:
        eventPlayer.ResetTimer += 1

    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START

rule "Let Go of Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false

    eventPlayer.ResetTimer = 0

rule "Show Scoreboard":
    @Event eachPlayer
    @Condition EndGame == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    _ScoreBoard()
    wait(1)

rule "Remove Scoreboard":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false

    _DestroyScoreBoard()

rule "End Game":
    @Event global
    @Condition EndGame == true

    Winner = sorted(AllPlayers, lambda elem: elem.TotalStrokes)[0]
    bigMessage(AllPlayers, "{} Wins!".format(Winner))
    wait(15)
    restartMatch()

rule "Player End Game":
    @Event eachPlayer
    @Condition EndGame == true

    eventPlayer.teleport(CourseArray[0])
    eventPlayer.stopForcingButton(Button.ULTIMATE)
    wait()
    _ScoreBoard()

rule "Hostplayer Skip":
    @Event eachPlayer
    @Condition DebugMode
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT)

    CurrentHole += 1
    wait(1)


def _SpawnHole():
    @Name "Spawn Golf Hole"

    if TeeOffEntity:
        destroyEffect(TeeOffEntity)
    if HoleEntity:
        destroyEffect(HoleEntity)
    if FlagEntity:
        destroyEffect(FlagEntity)

    wait()

    createEffect(AllPlayers, Effect.RING, Color.GREEN, CourseArray[HoleIndex], 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    TeeOffEntity = getLastCreatedEntity()

    createEffect(AllPlayers, Effect.RING, Color.BLUE, CourseArray[HoleIndex + 1], 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    HoleEntity = getLastCreatedEntity()

    createEffect(AllPlayers, Effect.LIGHT_SHAFT, Color.BLUE, CourseArray[HoleIndex + 1] + vect(0, 1, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    FlagEntity = getLastCreatedEntity()

def _ScoreBoard():
    @Name "Show Scoreboard"

    hudSubtext(eventPlayer, "\n\n\n\n", HudPosition.TOP, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ScoreboardText.append(getLastCreatedText())

    eventPlayer.ScoreboardString = "{} | {}\n".format(ParString, ParTotal)
    for eventPlayer.I in range(0, len(AllPlayers)):
        eventPlayer.ScoreboardString = "{}{}: {}\nScore: {}\n".format(eventPlayer.ScoreboardString, AllPlayers[eventPlayer.I], AllPlayers[eventPlayer.I].TotalStrokes, AllPlayers[eventPlayer.I].ScoreString)

    
    hudHeader(eventPlayer, eventPlayer.ScoreboardString, HudPosition.TOP, 1, Color.GREEN, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.ScoreboardText.append(getLastCreatedText())


def _DestroyScoreBoard():
    @Name "Delete Scoreboard"

    for eventPlayer.I in range(0, eventPlayer.ScoreboardText):
        destroyHudText(eventPlayer.ScoreboardText[eventPlayer.I])

    wait()
    eventPlayer.ScoreboardText = []