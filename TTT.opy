settings {
    "main": {
        "description": "Made by Kayst",
        "modeName": "TTT"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "returnToLobby": "never"
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "blackForest",
                "blackForestWinter",
                "blizzWorldWinter",
                "castillo",
                "dorado",
                "eichenwalde",
                "hanamura",
                "hanamuraWinter",
                "hollywood",
                "hollywoodHalloween",
                "necropolis",
                "paris",
                "route66",
                "iliosRuins",
                "chateauGuillard",
                "kingsRow",
                "kingsRowWinter",
                "kanezaka",
                "workshopIsland"
            ]
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true,
            "scoreToWin": 30,
            "enableSelfInitiatedRespawn": true,
            "spawnHealthPacks": "enabled"
        }
    },
    "heroes": {
        "allTeams": {
            "reinhardt": {
                "ability1Cooldown%": 20
            },
            "brigitte": {
                "healingReceived%": 50
            },
            "widowmaker": {
                "ultDuration%": 500
            },
            "genji": {
                "ultDuration%": 500
            },
            "torbjorn": {
                "ultDuration%": 500
            },
            "enabledHeroes": [
                "brigitte"
            ]
        }
    }
}

#Global variables

globalvar GameState 0
globalvar RaycastPos 1
globalvar WeaponPos 2
globalvar AllPlayers 3
globalvar Innocents 4
globalvar Jokers 5
globalvar Traitors 7
globalvar Detectives 6
globalvar TraitorPerc 8
globalvar DeadPlayers
globalvar Iter 10
globalvar IterWep
globalvar IterPlayer 12
globalvar NumWeapons 13
globalvar Weapons
globalvar WeaponTypes
globalvar WeaponEntities
globalvar WeaponText
globalvar PostGameString
globalvar Winners
globalvar WinnersColor
globalvar DebugString
globalvar DebugIter
globalvar MapCenter
globalvar WeaponLocs
globalvar DeathInfo
globalvar DeathLocs
globalvar Found
globalvar FoundString
globalvar RadarActive
globalvar TraitorShopOptions
globalvar DetectiveShopOptions
globalvar TraitorShopCost
globalvar DetectiveShopCost
globalvar CreditPrinter
globalvar PrinterCredits

#Player variables

playervar Role 0
playervar RoleColor 1
playervar PickupIndex
playervar Dead
playervar PreviousHero
playervar PickupHero # For detecting weapon swaps
playervar Weapon
playervar HealthPerc # Percentage of Max Health
playervar FoundIndex
playervar ReviveCharges
playervar AbilitiesString
playervar MenuTextIDs
playervar AnaCharges
playervar HudString
playervar Credits
playervar MenuIter
playervar MenuOptions
playervar MenuString
playervar InMenu
playervar MenuIndex
playervar MenuCosts
playervar AbilityArr
playervar AbilityTrigger
playervar DecoyReady
playervar DecoyEntity

enum Roles:
    Innocent = "Innocent",
    Traitor = "Traitor",
    Detective = "Detective",
    Joker = "Joker"

enum GameStates:
    Waiting = 0,
    PreMatch,
    InProgress,
    PostGame

#Subroutine names

subroutine _Spawn_Weapons 0
subroutine _MenuHUD
subroutine _DestroyMenu
subroutine _SetHeroAbilities
subroutine _TriggerAbility


# Init
rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(6)
    wait(7)
    setMatchTime(10000)

rule "Game Init":
    disableAnnouncer()
    disableMusic()
    disableGamemodeCompletion()
    disableScoring()
    wait(10)
    pauseMatchTime()


rule "Var Init":
    TraitorPerc = 0.5
    Traitors = []
    Jokers = []
    Detectives = []
    NumWeapons = 20
    Weapons = []
    WeaponLocs = []
    WeaponText = []
    WeaponTypes = [Hero.SOLDIER, Hero.SOJOURN, Hero.ASHE, Hero.GENJI, Hero.MCCREE, Hero.WIDOWMAKER, Hero.REAPER, Hero.TORBJORN, Hero.BAPTISTE]
    TraitorShopOptions = ["Decoy", "Pharah Weapon", "Bob", "Genji Sword", "Yum", "Credit Printer"]
    TraitorShopCost = [3, 2, 3, 3, 2, 3]
    
    DetectiveShopOptions = ["Defibulator", "Ana Weapon", "Widow Radar", "Rein Weapon", "Ball"]
    DetectiveShopCost = [3, 2, 2, 3, 3]

    RadarActive = false

    GameState = GameStates.Waiting

    switch getCurrentMap():
        case Map.HANAMURA:
            MapCenter = vect(12.6, 0, -23.73)
            break
        case Map.HANAMURA_WINTER:
            MapCenter = vect(12.6, 0, -23.73)
            break
        case Map.DORADO:
            MapCenter = vect(105, 11, 6.90)
            break
        case Map.EICHENWALDE:
            MapCenter = vect(58, 10, -88)
            break
        case Map.NECROPOLIS:
            MapCenter = vect(-8, 1, 0)
            break
        case Map.BLACK_FOREST:
            MapCenter = vect(1.75, 12.5, 4)
            break
        case Map.BLACK_FOREST_WINTER:
            MapCenter = vect(1.75, 12.5, 4)
            break
        case Map.PARIS:
            MapCenter = vect(-90, 12, -71)
            break
        case Map.HOLLYWOOD:
            MapCenter = vect(11.30, 1.6, -50)
            break
        case Map.HOLLYWOOD_HALLOWEEN:
            MapCenter = vect(11.30, 1.6, -50)
            break
        case Map.ROUTE66:
            MapCenter = vect(-28.2, 3.43, -24)
            break
        case Map.ILIOS_RUINS:
            MapCenter = vect(28.5, 57.4, -160)
            break
        case Map.CHATEAU_GUILLARD:
            MapCenter = vect(206, 9, 83)
            break
        case Map.KINGS_ROW:
            MapCenter = vect(-69, 0, -22.5)
            break
        case Map.KINGS_ROW_WINTER:
            MapCenter = vect(-69, 0, -22.5)
            break
        case Map.MALEVENTO:
            MapCenter = vect(0, 2, 15)
            break
        case Map.CASTILLO:
            MapCenter = vect(-105.5, 33.29, 58.88)
            break
        case Map.KANEZAKA:
            MapCenter = vect(-30.65, 6.55, -8.5)
            break
        case Map.BLIZZ_WORLD_WINTER:
            MapCenter = vect(-54, 0, 94)
            break
        default:
            MapCenter = vect(0, 0, 0)
            break

rule "Spawn Dummies for Debug":
    wait(1)

    createDummy(Hero.TRACER, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))
    createDummy(Hero.HANZO, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))
    wait()

    createDummy(Hero.ILLARI, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))
    createDummy(Hero.BAPTISTE, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))
    wait()

    createDummy(Hero.BAPTISTE, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))
    createDummy(Hero.BAPTISTE, Team.ALL, -1, MapCenter + vect(random.randint(-20, 20), 0, random.randint(-20, 20)), vect(0, 0, 0))


rule "Player Joined":
    @Event playerJoined
    
    eventPlayer.Role = Roles.Innocent
    eventPlayer.RoleColor = Color.GREEN
    AllPlayers = getAllPlayers()
    eventPlayer.disableGamemodeHud()

    eventPlayer.MenuTextIDs = []

    eventPlayer.PickupHero = Hero.BRIGITTE

    if GameState == GameStates.InProgress:
        eventPlayer.Dead = true
    else:
        eventPlayer.Dead = false



rule "Player Left":
    @Event playerLeft
    
    switch eventPlayer.Role:
        case Roles.Innocent:
            Innocents.remove(eventPlayer)
            break
        case Roles.Detective:
            Innocents.remove(eventPlayer)
            break
        case Roles.Joker:
            Jokers.remove(eventPlayer)
            break
        case Roles.Traitor:
            Traitors.remove(eventPlayer)
            break

    AllPlayers = getAllPlayers()

# Reset/Waiting
rule "Round Restart Global":
    @Event global
    @Condition GameState == GameStates.Waiting

    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllInWorldTexts()
    wait(1)

    DeadPlayers = []
    Weapons = []
    WeaponLocs = []
    WeaponText = []
    Traitors = []
    Jokers = []
    Detectives = []
    Innocents = AllPlayers

    DeathInfo = []
    DeathLocs = []
    Found = []
    FoundString = ""

    wait(3)
    GameState = GameStates.PreMatch

rule "Round Restart Player":
    @Event eachPlayer
    @Condition GameState == GameStates.Waiting

    eventPlayer.enableKillFeed()
    eventPlayer.enableRespawn()
    eventPlayer.enableScoreboard()
    eventPlayer.Role = Roles.Innocent
    eventPlayer.RoleColor = Color.GREEN
    eventPlayer.InMenu = false
    eventPlayer.DecoyReady = false
    eventPlayer.AbilityArr = []
    _DestroyMenu()

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.BRIGITTE
    eventPlayer.setDamageDealt(100)
    if eventPlayer == hostPlayer:
        hudSubtext(eventPlayer, "Game State: {0}\nPlayers: {1}\nTraitors: {2}\nTraitor Num: {3}".format(GameState, len(AllPlayers), len(Traitors), floor(len(AllPlayers)* TraitorPerc)), HudPosition.LEFT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudSubtext(eventPlayer, "{} {} {}".format(eventPlayer.getPosition().x, eventPlayer.getPosition().y, eventPlayer.getPosition().z), HudPosition.LEFT, 0, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    # hudSubtext(eventPlayer, "{}".format(DebugString), HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Dead = false
    wait()

    eventPlayer.respawn()

# PreMatch
rule "Spawn Weapons":
    @Condition GameState == GameStates.PreMatch
    
    wait()
    async(_Spawn_Weapons, AsyncBehavior.NOOP)

rule "Distribute Roles":
    @Condition GameState == GameStates.PreMatch
    
    Innocents = AllPlayers
    # Detective for 5+ Players
    if len(Innocents) > 4:
        # Detectives = [hostPlayer]
        Detectives[0] = random.choice(Innocents)
        Detectives[0].Role = Roles.Detective
    # Traitor Count
    Traitors.append(hostPlayer)
    hostPlayer.Role = Roles.Traitor
    Innocents.remove(hostPlayer)
    for Iter in range(0, floor(len(AllPlayers) * TraitorPerc)):
        if len(Traitors) > floor(len(AllPlayers) * TraitorPerc):
            break
        IterPlayer = random.choice(Innocents)
        if IterPlayer.Role == Roles.Innocent:
            IterPlayer.Role = Roles.Traitor
            Traitors.append(IterPlayer)
            Innocents.remove(IterPlayer)
            wait(0.2)
        else:
            Iter -= 1
        wait()

    if len(Traitors) > 2:
        Jokers.append(random.choice(Traitors))
        # Jokers.append(hostPlayer)
        Jokers[0].Role = Roles.Joker
        Traitors.remove(Jokers)

    wait(5)
    GameState = GameStates.InProgress


rule "Player Died During Match":
    @Event playerDied
    @Condition GameState == GameStates.InProgress

    # Death Loc Logic
    DeathLocs.append(eventPlayer.getPosition())
    createEffect(AllPlayers, Effect.GOOD_AURA, Color.VIOLET, evalOnce(DeathLocs.last()), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    DeathInfo.append("You found the body of {}\nThey were killed by a {} using {}".format(eventPlayer, attacker.getCurrentHero(), eventAbility))
    
    if eventPlayer.Role != Roles.Traitor and attacker.Role == Roles.Traitor:
        attacker.Credits += 2
        smallMessage(attacker, "You got 2 credits for killing an innocent")
    DeadPlayers.append(eventPlayer)

    _DestroyMenu()
    wait(1)

rule "Game In Progess Player Init":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    eventPlayer.HudString = ""
    eventPlayer.disableKillFeed()
    eventPlayer.disableRespawn()
    eventPlayer.disableScoreboard()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.respawn()
    eventPlayer.Dead = false
    wait(0.2)
    bigMessage(eventPlayer, "Your role is: {0}!".format(eventPlayer.Role))
    
    switch eventPlayer.Role:
        case Roles.Detective:
            eventPlayer.RoleColor = Color.SKY_BLUE
            eventPlayer.Credits = 3
            eventPlayer.MenuOptions = DetectiveShopOptions
            eventPlayer.MenuCosts = DetectiveShopCost
            eventPlayer.setSecondaryFireEnabled(true)
            # Move this if there are other roles with abilities
            hudHeader(eventPlayer, "Abilities | Credits: {}".format(eventPlayer.Credits), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            hudHeader(eventPlayer, "{} Menu\n(Hold {} + {})".format(eventPlayer.Role, buttonString(Button.CROUCH), buttonString(Button.ULTIMATE)), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.INTERACT), eventPlayer.MenuOptions[eventPlayer.AbilityArr[0]] if len(eventPlayer.AbilityArr) >= 1 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1), eventPlayer.MenuOptions[eventPlayer.AbilityArr[1]] if len(eventPlayer.AbilityArr) >= 2 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), eventPlayer.MenuOptions[eventPlayer.AbilityArr[2]] if len(eventPlayer.AbilityArr) >= 3 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            createInWorldText(AllPlayers, 'Detective', eventPlayer.getPosition() + vect(0, 2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, eventPlayer.RoleColor, SpecVisibility.DEFAULT)
            break

        case Roles.Traitor:
            eventPlayer.RoleColor = Color.RED
            eventPlayer.Credits = 2
            eventPlayer.MenuOptions = TraitorShopOptions
            eventPlayer.MenuCosts = TraitorShopCost
            hudHeader(eventPlayer, "Abilities | Credits: {}".format(eventPlayer.Credits), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            hudHeader(eventPlayer, "{} Menu\n(Hold {} + {})".format(eventPlayer.Role, buttonString(Button.CROUCH), buttonString(Button.ULTIMATE)), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.INTERACT), eventPlayer.MenuOptions[eventPlayer.AbilityArr[0]] if len(eventPlayer.AbilityArr) >= 1 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_1), eventPlayer.MenuOptions[eventPlayer.AbilityArr[1]] if len(eventPlayer.AbilityArr) >= 2 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            hudHeader(eventPlayer, "({} + {}): {}".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), eventPlayer.MenuOptions[eventPlayer.AbilityArr[2]] if len(eventPlayer.AbilityArr) >= 3 else ""), HudPosition.LEFT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            createInWorldText(Traitors, 'Traitor', eventPlayer.getPosition() + vect(0, 2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, eventPlayer.RoleColor, SpecVisibility.DEFAULT)
            
            for IterPlayer in range(len(Traitors)):
                eventPlayer.HudString = "{} {}".format(eventPlayer.HudString, Traitors[IterPlayer])
            hudHeader(eventPlayer, "{}".format(eventPlayer.HudString), HudPosition.RIGHT, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    
            if len(Jokers) > 0:
                hudHeader(eventPlayer, "Joker: {}".format(Jokers[0]), HudPosition.RIGHT, 1, Color.ROSE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    
            break

        case Roles.Joker:
            eventPlayer.RoleColor = Color.ROSE
            eventPlayer.setDamageDealt(0)
            createInWorldText(Traitors, 'Joker', eventPlayer.getPosition() + vect(0, 2, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, eventPlayer.RoleColor, SpecVisibility.DEFAULT)
            break

    hudSubheader(eventPlayer, "\n\n\n", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.NONE)
    hudHeader(eventPlayer, "Your Role: {0}".format(eventPlayer.Role), HudPosition.RIGHT, 0, eventPlayer.RoleColor, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    if len(Detectives) > 0:
        hudHeader(eventPlayer, "Detective: {}".format(Detectives[0]), HudPosition.RIGHT, 1, Color.SKY_BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubheader(eventPlayer, "\n\n\n", HudPosition.RIGHT, 1, Color.WHITE, HudReeval.NONE)
    hudHeader(eventPlayer, "Found: {}".format(FoundString), HudPosition.RIGHT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Traitor or Detective Access Menu":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.Role == Roles.Detective or eventPlayer.Role == Roles.Traitor
    @Condition eventPlayer.InMenu == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.MenuIndex = 0
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    _MenuHUD()
    wait(1)
    eventPlayer.InMenu = true

rule "Traitor or Detective Menu Controls":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.Role == Roles.Detective or eventPlayer.Role == Roles.Traitor
    @Condition eventPlayer.InMenu == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.INTERACT)

    # Ability 1 = Left Shift
    # Ability 2 = E
    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.InMenu = false
        _DestroyMenu()
        wait()
        _SetHeroAbilities()
        return

    elif eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.MenuIndex < len(eventPlayer.MenuOptions) - 1:
        eventPlayer.MenuIndex += 1

    elif eventPlayer.isHoldingButton(Button.ABILITY_1) and eventPlayer.MenuIndex > 0:
        eventPlayer.MenuIndex -= 1

    elif eventPlayer.isHoldingButton(Button.INTERACT):
        if len(eventPlayer.AbilityArr) > 2:
            smallMessage(eventPlayer, "You can only have 3 abilities at a time")
            wait(0.2)
            return 

        if eventPlayer.Credits >= eventPlayer.MenuCosts[eventPlayer.MenuIndex]:
            eventPlayer.Credits -= eventPlayer.MenuCosts[eventPlayer.MenuIndex]
            # eventPlayer.AbilitiesString = "{} {}\n".format(eventPlayer.AbilitiesString, eventPlayer.MenuOptions[eventPlayer.MenuIndex])
            eventPlayer.AbilityArr.append(eventPlayer.MenuIndex)
            bigMessage(eventPlayer, "You bought {}".format(eventPlayer.MenuOptions[eventPlayer.MenuIndex]))
        else:
            smallMessage(eventPlayer, "You do not have enough credits")
    wait(0.2)

rule "Check Body":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and  not eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition any([distance(eventPlayer.getPosition(), elem) < 2 for elem in DeathLocs])

    eventPlayer.FoundIndex = DeathLocs.index([elem for elem in DeathLocs if distance(eventPlayer.getPosition(), elem) < 2].last())
    bigMessage(eventPlayer, "{}".format(DeathInfo[eventPlayer.FoundIndex]))
    
    if not (DeadPlayers[eventPlayer.FoundIndex] in Found):
        if not DeadPlayers[eventPlayer.FoundIndex] in AllPlayers:
            return
        bigMessage(AllPlayers, "{} has found the body of {} they were {}".format(eventPlayer, DeadPlayers[eventPlayer.FoundIndex], DeadPlayers[eventPlayer.FoundIndex].Role))
        if DeadPlayers[eventPlayer.FoundIndex].Role == Roles.Traitor:
            Detectives[0].Credits += 2
            smallMessage(Detectives[0], "Traitor body found you got 2 credits!")
        wait(0.2)
        Found.append(DeadPlayers[eventPlayer.FoundIndex])
        FoundString = "{}\n{}: {}".format(FoundString, DeadPlayers[eventPlayer.FoundIndex], DeadPlayers[eventPlayer.FoundIndex].Role)
    wait(1)

rule "Check Winner":
    @Event playerDied
    @Condition GameState == GameStates.InProgress

    switch eventPlayer.Role:
        case Roles.Detective:
            if all([elem in DeadPlayers for elem in Innocents]):
                bigMessage(AllPlayers, "All Innocents are dead Traitors Win!")
                Winners = Roles.Traitor
                GameState = GameStates.PostGame
                break
        case Roles.Innocent:
            if all([elem in DeadPlayers for elem in Innocents]):
                bigMessage(AllPlayers, "All Innocents are dead Traitors Win!")
                Winners = Roles.Traitor
                GameState = GameStates.PostGame
            break
        case Roles.Traitor:
            if all([elem in DeadPlayers for elem in Traitors]):
                bigMessage(AllPlayers, "All Traitors are dead Innocents Win!")
                Winners = Roles.Innocent
                GameState = GameStates.PostGame
            break
        case Roles.Joker:
            if eventWasEnvironment:
                return
            bigMessage(AllPlayers, "Joker has died Joker Wins!")
            Winners = Roles.Joker
            GameState = GameStates.PostGame
            break
        default:
            return

# ABILITIES
rule "Traitor Or Detective Ability Activated":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.Role == Roles.Detective or eventPlayer.Role == Roles.Traitor
    @Condition eventPlayer.InMenu == false
    @Condition len(eventPlayer.AbilityArr) >= 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) and (eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.INTERACT))

    # Get the index of the ability
    if eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.AbilityTrigger = eventPlayer.MenuOptions[eventPlayer.AbilityArr[0]]
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.AbilityTrigger = eventPlayer.MenuOptions[eventPlayer.AbilityArr[1]]
    elif eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.AbilityTrigger = eventPlayer.MenuOptions[eventPlayer.AbilityArr[2]]
    else:
        return
    wait()
    eventPlayer.AbilityTrigger = null

# Detective Abilities
rule "Swap Ana":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Ana Weapon"
    @Condition eventPlayer.Role == Roles.Detective

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.ANA
    eventPlayer.AbilityArr.remove(1)
    

rule "Defibulator Attempt":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Defibulator"
    @Condition any([distance(eventPlayer.getPosition(), elem) < 2 for elem in DeathLocs])

    if random.randint(0, 100) < 50:
        eventPlayer.AbilityArr.remove(0)
        eventPlayer.FoundIndex = DeathLocs.index([elem for elem in DeathLocs if distance(eventPlayer.getPosition(), elem) < 2].last())
        DeadPlayers[eventPlayer.FoundIndex].respawn()
        wait(0.2)
        DeadPlayers[eventPlayer.FoundIndex].teleport(DeathLocs[eventPlayer.FoundIndex])
        wait()
        DeadPlayers[eventPlayer.FoundIndex].Dead = false
        DeathLocs[eventPlayer.FoundIndex] = vect(0, -999, 0)
        DeadPlayers.remove(DeadPlayers[eventPlayer.FoundIndex])
        wait(2)
    else:
        smallMessage(eventPlayer, " Revive failed try again")
        wait(2)

rule "Widow Radar":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Widow Radar"
    @Condition eventPlayer.Role == Roles.Detective

    eventPlayer.PickupHero = Hero.WIDOWMAKER
    eventPlayer.AbilityArr.remove(2)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)

rule "Rein Weapon":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Rein Weapon"
    @Condition eventPlayer.Role == Roles.Detective

    eventPlayer.PickupHero = Hero.REINHARDT
    eventPlayer.AbilityArr.remove(3)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)

rule "Ball Weapon":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Ball"
    @Condition eventPlayer.Role == Roles.Detective

    eventPlayer.PickupHero = Hero.HAMMOND
    eventPlayer.AbilityArr.remove(4)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)

# Traitor Abilities
rule "Decoy":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Decoy"
    @Condition eventPlayer.Role == Roles.Traitor

    eventPlayer.DecoyReady = true
    smallMessage(eventPlayer, "Decoy will trigger when you take damage")
    eventPlayer.AbilityArr.remove(0)

rule "Decoy Trigger":
    @Event playerTookDamage
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.DecoyReady

    eventPlayer.DecoyReady = false
    eventPlayer.setInvisibility(Invis.ALL)
    wait()
    createDummy(eventPlayer.getCurrentHero(), Team.ALL, -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    eventPlayer.DecoyEntity = getLastCreatedEntity()
    eventPlayer.DecoyEntity.startForcingName(eventPlayer)
    wait(4)
    destroyDummy(Team.ALL, eventPlayer.DecoyEntity.getSlot())
    wait(8)
    eventPlayer.setInvisibility(Invis.NONE)

rule "Swap Pharah":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Pharah Weapon"
    @Condition eventPlayer.Role == Roles.Traitor

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.PHARAH
    eventPlayer.AbilityArr.remove(1)

rule "Bob Ready":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Bob"
    @Condition eventPlayer.Role == Roles.Traitor

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.ASHE
    eventPlayer.AbilityArr.remove(2)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)

rule "Genji Weapon":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Genji Sword"
    @Condition eventPlayer.Role == Roles.Traitor

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.GENJI
    eventPlayer.AbilityArr.remove(3)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)

rule "Yum":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Yum"
    @Condition eventPlayer.Role == Roles.Traitor

    # Triggers Hero Pickup Rule
    eventPlayer.PickupHero = Hero.TORBJORN
    eventPlayer.AbilityArr.remove(4)
    wait(1)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    eventPlayer.forceButtonPress(Button.ULTIMATE)

rule "Credit Printer":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.AbilityTrigger == "Credit Printer"
    @Condition eventPlayer.Role == Roles.Traitor

    if not CreditPrinter:
        PrinterCredits = 0 
        CreditPrinter = evalOnce(eventPlayer.getPosition()) + vect(0, 1, 0)
        createEffect(AllPlayers, Effect.GOOD_AURA, Color.ROSE, CreditPrinter, 1, EffectReeval.VISIBILITY_AND_COLOR)
        createInWorldText(AllPlayers, "Credit Printer: {} Credits".format(PrinterCredits), CreditPrinter, 1, Clip.NONE, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.AbilityArr.remove(5)
    else:
        smallMessage(eventPlayer, "There can only be 1 credit printer in use at a time")

rule "Credit Printer Active":
    @Event global
    @Condition GameState == GameStates.InProgress
    @Condition CreditPrinter != null

    wait(30)
    PrinterCredits += 1
    if RULE_CONDITION:
        goto RULE_START

rule "Take Printer Credits":
    @Event eachPlayer
    @Condition GameState == GameStates.InProgress
    @Condition eventPlayer.isAlive()
    @Condition distance(eventPlayer.getPosition(), CreditPrinter) < 2
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.Credits += PrinterCredits
    PrinterCredits = 0
    wait(1)



# PostGame
rule "PostGame":
    @Event global
    @Condition GameState == GameStates.PostGame
    DeadPlayers = []


    hudSubheader(AllPlayers, "\n\n\n\n\n\n".format(PostGameString), HudPosition.TOP, 0, Color.RED, HudReeval.VISIBILITY)
    switch Winners:
        case Roles.Innocent:
            WinnersColor = Color.GREEN
            break
        case Roles.Traitor:
            WinnersColor = Color.RED
            break
        case Roles.Joker:
            WinnersColor = Color.ROSE
            break

    hudHeader(AllPlayers, "Winners: {}".format(Winners), HudPosition.TOP, 0, WinnersColor, HudReeval.VISIBILITY)
    
    PostGameString = ""
    for Iter in range(0, len(Traitors)):
        PostGameString = "{} {}".format(Traitors[Iter], PostGameString)
    hudHeader(AllPlayers, "Traitors: {}".format(PostGameString), HudPosition.TOP, 5, Color.RED, HudReeval.VISIBILITY)
    wait()

    
    PostGameString = ""
    for Iter in range(0, len(Innocents)):
        PostGameString = "{} {}".format(Innocents[Iter], PostGameString)
    wait()
    hudHeader(AllPlayers, "Innocents: {}".format(PostGameString), HudPosition.TOP, 5, Color.GREEN, HudReeval.VISIBILITY)
    if len(Detectives) > 0:
        hudHeader(AllPlayers, "Detective: {}".format(Detectives[0]), HudPosition.TOP, 5, Color.SKY_BLUE, HudReeval.VISIBILITY)
    if len(Jokers) > 0:
        hudHeader(AllPlayers, "Joker: {}".format(Jokers[0]), HudPosition.TOP, 5, Color.ROSE, HudReeval.VISIBILITY)


    wait(5)
    bigMessage(AllPlayers, "Round Over Restarting...")
    restartMatch()
    GameState = GameStates.Waiting

rule "Player Postgame":
    @Event eachPlayer
    @Condition GameState == GameStates.PostGame

    eventPlayer.InMenu = false

    if eventPlayer.Role == Roles.Detective:
        eventPlayer.Role = Roles.Innocent
        wait()

    if eventPlayer.Role == Winners:
        eventPlayer.addToScore(1)


# Always Running

rule "Pickup Weapon":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.Dead == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and not eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition any([distance(eventPlayer.getPosition(), elem) < 2 for elem in WeaponLocs])

    eventPlayer.PickupIndex = WeaponLocs.index([elem for elem in WeaponLocs if distance(eventPlayer.getPosition(), elem) < 2][0])
    eventPlayer.Weapon = Weapons[eventPlayer.PickupIndex]
    eventPlayer.PreviousHero = eventPlayer.getCurrentHero()
    smallMessage(hostPlayer, "Attempted to pickup weapon {} @ Index {}".format(Weapons[eventPlayer.PickupIndex], eventPlayer.PickupIndex))
    
    if eventPlayer.getCurrentHero() == eventPlayer.Weapon:
        smallMessage(eventPlayer, "You already have this weapon")
        wait()
        return

    # Triggers Hero Swap Rule
    eventPlayer.PickupHero = eventPlayer.Weapon

    # Maintain Outlines
    if eventPlayer.Role == Roles.Detective:
        eventPlayer.RoleColor = Color.SKY_BLUE
        eventPlayer.startForcingOutlineFor(AllPlayers, true, Color.SKY_BLUE, OutlineVisibility.DEFAULT)
    if eventPlayer.Role == Roles.Traitor:
        eventPlayer.RoleColor = Color.RED
        eventPlayer.startForcingOutlineFor(Traitors, true, Color.RED, OutlineVisibility.DEFAULT)
    if eventPlayer.Role == Roles.Joker:
        eventPlayer.RoleColor = Color.ROSE
        eventPlayer.startForcingOutlineFor(Traitors, true, Color.ROSE, OutlineVisibility.DEFAULT)
        eventPlayer.setDamageDealt(0)
    wait()

    
    # Destroy World Text
    destroyInWorldText(WeaponText[eventPlayer.PickupIndex])
    wait()

    # If dropping a weapon
    if eventPlayer.PreviousHero != Hero.BRIGITTE:
        # Weapon Loc is the same 
        # Swap Names
        Weapons[eventPlayer.PickupIndex] = eventPlayer.PreviousHero
        # Swap Weapon Texts
        createInWorldText(AllPlayers, "{}".format(Weapons[eventPlayer.PickupIndex]), WeaponLocs[eventPlayer.PickupIndex] + vect(0, 0.5, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
        wait()
        WeaponText[eventPlayer.PickupIndex] = getLastCreatedText()
    else:
        destroyEffect(WeaponEntities[eventPlayer.PickupIndex])
        # Give massive distance
        Weapons[eventPlayer.PickupIndex] = 0
        WeaponLocs[eventPlayer.PickupIndex] = vect(0, -999, 0)
        WeaponEntities[eventPlayer.PickupIndex] = 0
        WeaponText[eventPlayer.PickupIndex] = 0
    wait(2)

rule "F to Cycle Game States":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.ABILITY_1)
    
    GameState += 1
    if GameState > 4:
        GameState = 0
    wait()
    bigMessage(eventPlayer, "GameState: {0}".format(GameState))
    wait(1)


rule "Weapon Swap":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.PickupHero
    @Condition eventPlayer.PickupHero != eventPlayer.getCurrentHero()
    
    eventPlayer.HealthPerc = eventPlayer.getHealth() / eventPlayer.getMaxHealth()
    eventPlayer.startForcingHero(eventPlayer.PickupHero)
    wait()

    _SetHeroAbilities()
        
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * eventPlayer.HealthPerc)

    wait(1)
    # Attempt to maintain outlines
    switch eventPlayer.Role:
        case Roles.Detective:
            eventPlayer.stopForcingOutlineFor(AllPlayers)
            wait()
            eventPlayer.startForcingOutlineFor(AllPlayers, true, Color.SKY_BLUE, OutlineVisibility.DEFAULT)
            break
        case Roles.Traitor:
            eventPlayer.stopForcingOutlineFor(Traitors)
            wait()
            eventPlayer.startForcingOutlineFor(Traitors, true, Color.RED, OutlineVisibility.DEFAULT)
            break
        case Roles.Joker:
            eventPlayer.stopForcingOutlineFor(Traitors)
            wait()
            eventPlayer.startForcingOutlineFor(Traitors, true, Color.ROSE, OutlineVisibility.DEFAULT)
            break


# Subroutines
def _Spawn_Weapons():
    @Name "Spawn Weapons"
    
    for IterWep in range(0, NumWeapons):
        if GameState == GameStates.PostGame:
            return
        WeaponPos = MapCenter + vect(random.uniform(-50, 50), -5, random.uniform(-50, 50))
        RaycastPos = raycast(WeaponPos + vect(0, 10, 0), WeaponPos, null, null, false).getHitPosition()
        wait()
        if WeaponPos != RaycastPos and all([distance(RaycastPos, elem) > 3 for elem in WeaponLocs]):
            createEffect(AllPlayers, Effect.RING, Color.BLUE, RaycastPos, 1, EffectReeval.VISIBILITY)
            WeaponEntities[IterWep] = getLastCreatedEntity()
            WeaponLocs[IterWep] = RaycastPos
            Weapons[IterWep] = random.choice(WeaponTypes)
            smallMessage(hostPlayer, "Weapon Spawned at {0} {1}".format(RaycastPos, Weapons[IterWep]))
            wait(0.2)
            createInWorldText(AllPlayers, "{}".format(Weapons[IterWep]), RaycastPos + vect(0, 0.5, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT)
            WeaponText[IterWep] = getLastCreatedText()
        else:
            smallMessage(hostPlayer, "Could not spawn at {0}".format(RaycastPos))
            IterWep -= 1
        wait(0.2)

def _MenuHUD():
    @Name "Special Class Menu HUD"

    switch eventPlayer.Role:
        case Roles.Detective:
            eventPlayer.MenuOptions = DetectiveShopOptions
            eventPlayer.MenuCosts = DetectiveShopCost
            break
        case Roles.Traitor:
            eventPlayer.MenuOptions = TraitorShopOptions
            eventPlayer.MenuCosts = TraitorShopCost
            break
        default:
            return

    wait()
    hudSubheader(eventPlayer, "\n\n\n\n", HudPosition.TOP, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.MenuTextIDs.append(getLastCreatedText())
    hudHeader(eventPlayer, "{} Menu".format(eventPlayer.Role), HudPosition.TOP, 1, eventPlayer.RoleColor, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.MenuTextIDs.append(getLastCreatedText())
    hudHeader(eventPlayer, "{} to Exit | {} to Confirm\n{} Cursor Down | {} Cursor Up".format(buttonString(Button.ULTIMATE), buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.ABILITY_1)), HudPosition.TOP, 2, eventPlayer.RoleColor, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MenuTextIDs.append(getLastCreatedText())
    

    # eventPlayer.MenuString = ""
    for eventPlayer.MenuIter in range(0, len(eventPlayer.MenuOptions)):
        hudHeader(eventPlayer, "{} {} {}pts".format(iconString(Icon.ASTERISK) if eventPlayer.MenuIndex == evalOnce(eventPlayer.MenuIter) else iconString(Icon.RING_THIN), evalOnce(eventPlayer.MenuOptions[eventPlayer.MenuIter]), evalOnce(eventPlayer.MenuCosts[eventPlayer.MenuIter])), HudPosition.TOP, 3, eventPlayer.RoleColor, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
        # eventPlayer.MenuString = "{}{} {}pts\n".format(eventPlayer.MenuString, eventPlayer.MenuOptions[eventPlayer.MenuIter], eventPlayer.MenuCosts[eventPlayer.MenuIter])
        eventPlayer.MenuTextIDs.append(getLastCreatedText())
        wait()
    # hudSubheader(eventPlayer, "{}".format(eventPlayer.MenuString), HudPosition.TOP, 2, eventPlayer.RoleColor, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    

def _DestroyMenu():
    @Name "Destroy Menu Hud"

    if len(eventPlayer.MenuTextIDs) <= 0:
        return

    for eventPlayer.MenuIter in range(0, len(eventPlayer.MenuTextIDs)):
        destroyHudText(eventPlayer.MenuTextIDs[eventPlayer.MenuIter])
    waitUntil(eventPlayer.MenuIter >= len(eventPlayer.MenuTextIDs) - 1, 1)
    eventPlayer.MenuTextIDs = []


def _SetHeroAbilities():
    @Name "Set Hero Abilities"

    # Force Hero Based on Index
    # Ability 1 = Left Shift
    # Ability 2 = E
    # Weird bug with PickupHero not being initialized triggers default
    switch eventPlayer.PickupHero:
        case Hero.BRIGITTE:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(false)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setAbility2Enabled(false)
            eventPlayer.setUltEnabled(false)
            if eventPlayer.Role == Roles.Detective:
                eventPlayer.setSecondaryFireEnabled(true)
            break
        case Hero.SOLDIER:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(false)
            eventPlayer.setAbility1Enabled(true)
            if eventPlayer.Role == Roles.Detective:
                eventPlayer.setAbility2Enabled(true)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Joker:
                eventPlayer.setSecondaryFireEnabled(true)
            break
        case Hero.MCCREE:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(false)
            eventPlayer.setSecondaryFireEnabled(true)
            break
        case Hero.WIDOWMAKER:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            break
        case Hero.REAPER:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setAbility2Enabled(true)
            eventPlayer.setSecondaryFireEnabled(false)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Joker:
                eventPlayer.setAbility1Enabled(true)
            break
        case Hero.GENJI:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(false)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Joker:
                eventPlayer.setAbility2Enabled(true)
            break
        case Hero.SOJOURN:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(false)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(false)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Detective:
                eventPlayer.setSecondaryFireEnabled(true)
                eventPlayer.setAbility2Enabled(true)
            break
        case Hero.ASHE:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(false)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Joker:
                eventPlayer.setAbility2Enabled(true)
            break
        case Hero.TORBJORN:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setAbility2Enabled(true)
            if eventPlayer.Role == Roles.Traitor or eventPlayer.Role == Roles.Joker:
                eventPlayer.setAbility1Enabled(true)
            break
        case Hero.BAPTISTE:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(false)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(false)
            if eventPlayer.Role == Roles.Detective:
                eventPlayer.setAbility2Enabled(true)
            break
        case Hero.ANA:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            break
        case Hero.REINHARDT:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            break
        case Hero.PHARAH:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            break
        case Hero.HAMMOND:
            eventPlayer.setPrimaryFireEnabled(true)
            eventPlayer.setSecondaryFireEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
            break
        default:
            eventPlayer.setPrimaryFireEnabled(false)
            eventPlayer.setSecondaryFireEnabled(false)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setAbility2Enabled(false)
            eventPlayer.setUltEnabled(false)
            break
