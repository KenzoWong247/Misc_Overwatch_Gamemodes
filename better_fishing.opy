
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
                "bastion"
            ]
        }
    }
}



# Global Variables
globalvar FishingSpot
globalvar StoreSpot
globalvar AutoFisherSpots
globalvar TinyFishNames
globalvar TinyFishPrices
globalvar SmFishNames
globalvar SmFishPrices
globalvar MeFishNames
globalvar MeFishPrices
globalvar LgFishNames
globalvar LgFishPrices
globalvar LegFishNames
globalvar LegFishPrices
globalvar FishLevelColors
globalvar UpgradeCosts
globalvar AutoFisherCosts
globalvar AutoFishPrices

# Player Variables
playervar FishingRod 
playervar Gold
playervar FishingStatus
playervar FishLevel
playervar DifMax
playervar DifMin
playervar Fish
playervar FishValWait
playervar BarIncreasing
playervar BaitVector
playervar BaitStartVector
playervar RodVector
playervar CastPower
playervar BaitEffect
playervar FishLineEffect
playervar HookChance
playervar AutoFisherLevels
playervar AutoFisherStates
playervar AutoFisherGold
playervar AutoFisherStrings
playervar CastPowerHud
playervar AutoFisherI

# FP = Fishing Progress
playervar FPValue
playervar FPModifier

# Ids of HUD items
playervar FishingHudIds

subroutine AutoFisherMechs
subroutine AutoFisherNode
subroutine SetDifficulty
subroutine ComputeFish
subroutine CancelFishing

enum AutoFishingStates:
    NOT_BOUGHT = 1,
    FISHING,
    HOLDING_FISH

enum FishingStates:
    READY_TO_FISH = 1,
    READY_TO_CAST,
    CASTING_ROD,
    WAITING_FOR_FISH,
    FISH_ON_THE_LINE,
    FISH_HOOKED, 
    FISHING_MINIGAME,
    FISHING_WRAPUP

#!extension beamEffects

rule "Var Inits":
    FishingSpot = vect(12, 0, 0)
    StoreSpot = vect(0, 0, 0)
    AutoFisherSpots = [vect(16, 0, -16), vect(16, 0, 16)]
    AutoFisherCosts = [500, 1000, 1500, 2000, 2500]
    
    UpgradeCosts = [200, 500, 1000, 5000, 10000]
    FishLevelColors = [Color.WHITE, Color.GREEN, Color.BLUE, Color.RED, Color.BLACK]
    TinyFishNames = ["Tadpole", "Minnow", "Crawfish", "Shrimp", "Guppy", "Tetra", "Beta"]
    TinyFishPrices = [10, 15, 15, 20, 25, 30, 50]
    SmFishNames = ["Anchovy", "Goldfish", "Platy", "Sunfish", "Blue Tang", "Red Snapper", "Clownfish", "Koi Fish"]
    SmFishPrices = [50, 50, 50, 75, 75, 75, 100, 200]
    MeFishNames = ["Mackrel", "Red Mullet", "Piranha", "Trout", "Cod", "Seabream", "Salmon", "Tuna", "Barracuda", "Mahi-Mahi", "Baby Shark", "Swordfish"]
    MeFishPrices = [125, 125, 150, 150, 175, 200, 250, 250, 300, 400, 450, 500, 750]
    LgFishNames = ["Octopus", "Great White", "Orca", "Blue Whale", "Giant Squid"]
    LgFishPrices = [1000, 1250, 1500, 2000, 3000]
    LegFishNames = ["Kraken", "One-Eye Willie", "Puff the Sea Dragon"]
    LegFishPrices = [5000, 7500, 10000]

    AutoFishPrices = []
    AutoFishPrices.append(TinyFishPrices)
    AutoFishPrices.append(SmFishPrices)
    AutoFishPrices.append(MeFishPrices)


rule "Init":
    setMatchTime(5)
    disableGamemodeCompletion()
    disableMusic()
    disableAnnouncer()
    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, FishingSpot, 8, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, StoreSpot, 3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.ORANGE, AutoFisherSpots[0], 3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.RING, Color.ORANGE, AutoFisherSpots[1], 3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    
rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(3)
    disableScoring()
    wait(7)
    setMatchTime(10000)

rule "Player Init":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.Gold = 0
    eventPlayer.FishingRod = 0
    eventPlayer.FishingStatus = FishingStates.READY_TO_FISH
    eventPlayer.FPValue = 0
    eventPlayer.FPModifier = 1
    eventPlayer.BaitVector = vect(-1, 2, 3)
    eventPlayer.BaitStartVector = eventPlayer.BaitVector
    eventPlayer.RodVector = vect(-1, 2.5, 3)

    eventPlayer.AutoFisherStates = [AutoFishingStates.NOT_BOUGHT, AutoFishingStates.NOT_BOUGHT]
    eventPlayer.AutoFisherStrings = ["Buy Autofisher", "Buy Autofisher"]
    eventPlayer.AutoFisherLevels = [0, 0]
    eventPlayer.AutoFisherGold = [0, 0]

    createInWorldText(eventPlayer, "Press {} to Fish".format(buttonString(Button.INTERACT)), FishingSpot, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.DEFAULT)
    createInWorldText(eventPlayer, "Upgrade Fishing Rod {} Gold".format(UpgradeCosts[eventPlayer.FishingRod]), StoreSpot, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.PURPLE, SpecVisibility.DEFAULT)
    
    createInWorldText(eventPlayer, eventPlayer.AutoFisherStrings[0], AutoFisherSpots[0], 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(eventPlayer, eventPlayer.AutoFisherStrings[1], AutoFisherSpots[1], 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    
    hudHeader(eventPlayer, 'Player Stats', HudPosition.LEFT, 0, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Gold: {}'.format(eventPlayer.Gold), HudPosition.LEFT, 2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fishing Rod Level: {}'.format(eventPlayer.FishingRod + 1), HudPosition.LEFT, 2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    createBeam(getAllPlayers(), Beam.GRAPPLE, worldVector(vect(-1, 1, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(eventPlayer.RodVector, eventPlayer, Transform.ROTATION_AND_TRANSLATION), Color.WHITE, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)    
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, worldVector(eventPlayer.BaitVector, eventPlayer, Transform.ROTATION_AND_TRANSLATION), 0.1, EffectReeval.POSITION_RADIUS_AND_COLOR)
    eventPlayer.BaitEffect = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.MERCY_BOOST, worldVector(eventPlayer.RodVector, eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(eventPlayer.BaitVector, eventPlayer, Transform.ROTATION_AND_TRANSLATION), Color.GRAY, EffectReeval.POSITION_RADIUS_AND_COLOR)
    eventPlayer.FishLineEffect = getLastCreatedEntity()
    

    waitUntil(eventPlayer.hasSpawned(), 5)
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setDamageDealt(0)

rule "Guide Hud":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false

    hudHeader(eventPlayer, 'Color Key Map', HudPosition.RIGHT, 0, Color.YELLOW, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fish Level 1: Basic', HudPosition.RIGHT, 1, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fish Level 2: Common', HudPosition.RIGHT, 1, Color.GREEN, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fish Level 3: Rare', HudPosition.RIGHT, 1, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fish Level 4: Epic', HudPosition.RIGHT, 1, Color.RED, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Fish Level 5: Legendary', HudPosition.RIGHT, 1, Color.BLACK, HudReeval.NONE, SpecVisibility.DEFAULT)

rule "Get Ready to Cast":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.READY_TO_FISH
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(FishingSpot, eventPlayer) < 7

    eventPlayer.setMoveSpeed(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setFacing(vect(1, 0, 0), Relativity.TO_WORLD)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disableGamemodeHud()

    eventPlayer.CastPower = 0
    progressBarHud(eventPlayer, eventPlayer.CastPower, "Hold {} to set power and release to cast".format(buttonString(Button.PRIMARY_FIRE)), HudPosition.TOP, 2, Color.BLUE, Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT)
    eventPlayer.CastPowerHud = getLastCreatedText()

    eventPlayer.FishingStatus = FishingStates.READY_TO_CAST

rule "Player Cast Power":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.READY_TO_CAST
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.CastPower <= 100:
            eventPlayer.CastPower += 1 
        wait(0.001)
    
    destroyProgressBarHud(getLastCreatedText())
    eventPlayer.FishingStatus = FishingStates.CASTING_ROD
    
rule "Player Has Cast":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.CASTING_ROD
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    
    while eventPlayer.CastPower > 0:
        eventPlayer.BaitVector = vect(eventPlayer.BaitVector.x, eventPlayer.BaitVector.y + 0.5, eventPlayer.BaitVector.z + 1)
        eventPlayer.CastPower -= 2
        wait(0.03)
    
    while eventPlayer.BaitVector.y > -27:
        eventPlayer.BaitVector = vect(eventPlayer.BaitVector.x, eventPlayer.BaitVector.y - 1, eventPlayer.BaitVector.z)
        wait(0.03)
    
    eventPlayer.FishingStatus = FishingStates.WAITING_FOR_FISH

rule "Player Waiting for Fish":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.WAITING_FOR_FISH

    eventPlayer.HookChance = 2
    hudSubtext(eventPlayer, 'Click when you see the !', HudPosition.TOP, 2, Color.WHITE, HudReeval.NONE, SpecVisibility.ALWAYS)
    eventPlayer.FishingHudIds[4] = getLastCreatedText()

    while eventPlayer.FishingStatus == FishingStates.WAITING_FOR_FISH:
        waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 1)
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            CancelFishing()
            return
        
        if eventPlayer.HookChance >= 8:
            playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
            smallMessage(eventPlayer, " No bites...")
            CancelFishing()
            return

        if random.randint(0, 10) > eventPlayer.HookChance:
            smallMessage(eventPlayer, ' ...')
            eventPlayer.HookChance += 2
        else:
            smallMessage(eventPlayer, " Fish on the line!")
            playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
            createIcon(eventPlayer, worldVector(vect(0, 1, 5), eventPlayer, Transform.ROTATION_AND_TRANSLATION), Icon.EXCLAMATION_MARK, IconReeval.POSITION, Color.GREEN, false)
            waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 3)
            if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
                waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false, 10)
                eventPlayer.FishingStatus = FishingStates.FISH_ON_THE_LINE
            else:
                playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
                smallMessage(eventPlayer, " Fish got away...")
                CancelFishing()
                return
        wait(1)
        

rule "Player Start Fishing Minigame":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.FISH_ON_THE_LINE
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false

    destroyHudText(eventPlayer.FishingHudIds[4])
    eventPlayer.FPValue = 0
    # Fishing bar
    eventPlayer.BarIncreasing = true
    SetDifficulty()

    hudSubtext(eventPlayer, 'Press {} to stop the bar'.format(buttonString(Button.PRIMARY_FIRE)), HudPosition.TOP, 2, Color.WHITE, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.FishingHudIds[1] = getLastCreatedText()
    hudHeader(eventPlayer, 'Stop Between {} - {}. Value: {}'.format(eventPlayer.DifMin, eventPlayer.DifMax, eventPlayer.FPValue), HudPosition.TOP, 2, FishLevelColors[eventPlayer.FishLevel], HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.FishingHudIds[2] = getLastCreatedText()
    progressBarHud(eventPlayer, eventPlayer.FPValue, null, HudPosition.TOP, 2, Color.GREEN, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.FishingHudIds[3] = getLastCreatedText()

    
    eventPlayer.FishingStatus = FishingStates.FISHING_MINIGAME

rule "Fishing Bar Movement":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.FISHING_MINIGAME
    
    while eventPlayer.FishingStatus == FishingStates.FISHING_MINIGAME:
        if eventPlayer.BarIncreasing and eventPlayer.FPValue >= 100:
            eventPlayer.BarIncreasing = false
            eventPlayer.FPModifier *= -1
        elif eventPlayer.BarIncreasing == false and eventPlayer.FPValue <= 0:
            eventPlayer.BarIncreasing = true
            eventPlayer.FPModifier *= -1

        eventPlayer.FPValue += eventPlayer.FPModifier
        wait(eventPlayer.FishValWait, Wait.ABORT_WHEN_FALSE)
    return
    

rule "Fishing Stop Bar":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.FISHING_MINIGAME
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    wait(0.2)
    destroyHudText(eventPlayer.FishingHudIds[1])
    destroyHudText(eventPlayer.FishingHudIds[2])
    destroyProgressBarHud(eventPlayer.FishingHudIds[3])
    smallMessage(eventPlayer, ' Stopped at {}'.format(eventPlayer.FPValue))

    # Fish caught
    if eventPlayer.FPValue >= eventPlayer.DifMin and eventPlayer.FPValue <= eventPlayer.DifMax:    
        eventPlayer.FishingStatus = FishingStates.FISHING_WRAPUP
    else:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
        smallMessage(eventPlayer, " Oh no fish got away!")
        CancelFishing()
    return

rule "Reel In":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.FISHING_WRAPUP

    createEffect(getAllPlayers(), Effect.BAD_AURA, FishLevelColors[eventPlayer.FishLevel], worldVector(eventPlayer.BaitVector, eventPlayer, Transform.ROTATION_AND_TRANSLATION), eventPlayer.FishLevel + 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    while distance(eventPlayer.BaitVector, eventPlayer.BaitStartVector) > 1:
        eventPlayer.BaitVector += directionTowards(eventPlayer.BaitVector, eventPlayer.RodVector)
        wait(0.02)

    
    wait(1)
    ComputeFish()
    eventPlayer.setScore(eventPlayer.Gold)
    destroyEffect(getLastCreatedEntity())
    CancelFishing()

rule "Upgrade Fishing Rod":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.READY_TO_FISH
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(StoreSpot, eventPlayer) < 3
    
    if eventPlayer.Gold >= UpgradeCosts[eventPlayer.FishingRod]:
        eventPlayer.Gold -= UpgradeCosts[eventPlayer.FishingRod]
        eventPlayer.setScore(eventPlayer.Gold)
        eventPlayer.FishingRod += 1
        smallMessage(eventPlayer, ' You have upgraded your fishing rod to level {}!'.format(eventPlayer.FishingRod + 1))
    else:
        smallMessage(eventPlayer, ' You need {} more gold'.format(UpgradeCosts[eventPlayer.FishingRod] - eventPlayer.Gold))
    
    wait(0.2)

rule "Autofisher Upgrade 1":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.READY_TO_FISH
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(AutoFisherSpots[0], eventPlayer) < 3
    
    eventPlayer.AutoFisherI = 0
    AutoFisherNode()            
    wait(0.2)

rule "Autofisher Upgrade 2":
    @Event eachPlayer
    @Condition eventPlayer.FishingStatus == FishingStates.READY_TO_FISH
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition distance(AutoFisherSpots[1], eventPlayer) < 3

    eventPlayer.AutoFisherI = 1
    AutoFisherNode()
    wait(0.2)

rule "AutoFisher Mechanic 1":
    @Event eachPlayer
    @Condition eventPlayer.AutoFisherStates[0] != AutoFishingStates.NOT_BOUGHT

    wait(60 - eventPlayer.AutoFisherLevels[0] * 5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.AutoFisherGold[0] += random.choice(AutoFishPrices)
    eventPlayer.AutoFisherStates[0] = AutoFishingStates.HOLDING_FISH
    eventPlayer.AutoFisherStrings[0] = 'Holding Fish!'


rule "AutoFisher Mechanic 2":
    @Event eachPlayer
    @Condition eventPlayer.AutoFisherStates[1] != AutoFishingStates.NOT_BOUGHT
    
    wait(60 - eventPlayer.AutoFisherLevels[1] * 5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.AutoFisherGold[1] += random.choice(AutoFishPrices)
    eventPlayer.AutoFisherStates[1] = AutoFishingStates.HOLDING_FISH
    eventPlayer.AutoFisherStrings[1] = 'Holding Fish!'


def AutoFisherNode():
    @Name "Auto Fisher Purchase Mechs"

    if eventPlayer.AutoFisherStates[eventPlayer.AutoFisherI] == AutoFishingStates.HOLDING_FISH:
        smallMessage(eventPlayer, ' Collected {} gold from the autofisher!'.format(eventPlayer.AutoFisherGold[eventPlayer.AutoFisherI]))
        eventPlayer.Gold += eventPlayer.AutoFisherGold[eventPlayer.AutoFisherI]
        wait(0.2)
        eventPlayer.AutoFisherGold[eventPlayer.AutoFisherI] = 0
        eventPlayer.AutoFisherStates[eventPlayer.AutoFisherI] = AutoFishingStates.FISHING
        eventPlayer.AutoFisherStrings[eventPlayer.AutoFisherI] = 'Autofisher level {}. Upgrade cost {}'.format(eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI], AutoFisherCosts[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]])
        
    else:
        if eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI] > 4:
            smallMessage(eventPlayer, ' Autofisher is Max Level')
        else:
            if eventPlayer.Gold >= AutoFisherCosts[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]]:
                if eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI] == 0:
                    createEffect(eventPlayer, Effect.LIGHT_SHAFT, FishLevelColors[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI] - 1], AutoFisherSpots[eventPlayer.AutoFisherI], 3, EffectReeval.VISIBILITY_AND_COLOR)
                eventPlayer.Gold -= AutoFisherCosts[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]]
                eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI] += 1
                eventPlayer.AutoFisherStates[eventPlayer.AutoFisherI] = AutoFishingStates.FISHING
                smallMessage(eventPlayer, ' You have upgraded your autofisher to level {}!'.format(eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]))
                eventPlayer.AutoFisherStrings[eventPlayer.AutoFisherI] = 'Autofisher level {}. Upgrade cost {}'.format(eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI], AutoFisherCosts[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]])
            
            else:
                smallMessage(eventPlayer, ' You need {} more gold'.format(AutoFisherCosts[eventPlayer.AutoFisherLevels[eventPlayer.AutoFisherI]] - eventPlayer.Gold))
    eventPlayer.setScore(eventPlayer.Gold)
    return
    

def ComputeFish():
    @Name "Compute Fish Caught"
    switch eventPlayer.FishLevel:
        case 0:
            smallMessage(eventPlayer, ' Congrats you caught a {} {} gold!'.format(TinyFishNames[eventPlayer.Fish], TinyFishPrices[eventPlayer.Fish]))
            eventPlayer.Gold += TinyFishPrices[eventPlayer.Fish]
            break
        case 1:
            smallMessage(eventPlayer, ' Congrats you caught a {} {} gold!'.format(SmFishNames[eventPlayer.Fish], SmFishPrices[eventPlayer.Fish]))
            eventPlayer.Gold += SmFishPrices[eventPlayer.Fish]
            break
        case 2:
            smallMessage(eventPlayer, ' Congrats you caught a {} {} gold!'.format(MeFishNames[eventPlayer.Fish], MeFishPrices[eventPlayer.Fish]))
            eventPlayer.Gold += MeFishPrices[eventPlayer.Fish]
            break
        case 3:
            smallMessage(eventPlayer, ' Congrats you caught a {} {} gold!'.format(LgFishNames[eventPlayer.Fish], LgFishPrices[eventPlayer.Fish]))
            eventPlayer.Gold += LgFishPrices[eventPlayer.Fish]
            break
        case 4:
            bigMessage(getAllPlayers(), 'Congrats {} caught a {} {} gold!'.format(eventPlayer, LegFishNames[eventPlayer.Fish], LegFishPrices[eventPlayer.Fish]))
            eventPlayer.Gold += LegFishPrices[eventPlayer.Fish]
            break


def SetDifficulty():
    @Name "Set Fishing Difficulty"

    switch eventPlayer.FishingRod:
        case 0:
            eventPlayer.FishLevel = 0
            break
        case 1:
            if random.randint(0, 10) > 3:
                eventPlayer.FishLevel = 1
            else:
                eventPlayer.FishLevel = 0
            break
        case 2:
            if random.randint(0, 10) >= 5:
                if random.randint(0, 10) > 2:
                    eventPlayer.FishLevel = 1
                else:
                    eventPlayer.FishLevel = 0
            else:
                eventPlayer.FishLevel = 2
            break
        case 3:
            if random.randint(0, 10) > 1:
                if random.randint(0, 10) > 3:
                    eventPlayer.FishLevel = 2
                else:
                    eventPlayer.FishLevel = 3
            else:
                eventPlayer.FishLevel = 1
            break
        case 4:
            if random.randint(0, 20) > 1:
                if random.randint(0, 10) > 6:
                    eventPlayer.FishLevel = 3
                else:
                    eventPlayer.FishLevel = 2
            else:
                eventPlayer.FishLevel = 4
            break

    switch eventPlayer.FishLevel:
        case 0:
            eventPlayer.DifMin = random.randint(0, 70)
            eventPlayer.DifMax = eventPlayer.DifMin + 30
            eventPlayer.FishValWait = 0.03
            eventPlayer.Fish = random.randint(0, len(TinyFishNames) - 1)
            eventPlayer.FPModifier = 1
            if eventPlayer.FishingRod >= 1:
                eventPlayer.FishValWait = 0.05
            break
        case 1:
            eventPlayer.DifMin = random.randint(0, 70)
            eventPlayer.DifMax = eventPlayer.DifMin + 30
            eventPlayer.FishValWait = 0.03
            eventPlayer.Fish = random.randint(0, len(SmFishNames) - 1)
            eventPlayer.FPModifier = 1
            if eventPlayer.FishingRod >= 2:
                eventPlayer.FishValWait = 0.05
            break
        case 2:
            eventPlayer.DifMin = random.randint(0, 70)
            eventPlayer.DifMax = eventPlayer.DifMin + 30
            eventPlayer.FishValWait = 0.02
            eventPlayer.Fish = random.randint(0, len(MeFishNames) - 1)
            eventPlayer.FPModifier = 1
            if eventPlayer.FishingRod >= 3:
                eventPlayer.FishValWait = 0.05

            break
        case 3:
            eventPlayer.DifMin = random.randint(0, 80)
            eventPlayer.DifMax = eventPlayer.DifMin + 20
            eventPlayer.FishValWait = 0.02
            eventPlayer.Fish = random.randint(0, len(LgFishNames) - 1)
            eventPlayer.FPModifier = 2
            if eventPlayer.FishingRod > 4:
                eventPlayer.FPModifier = 1
            break
        case 4:
            eventPlayer.DifMin = random.randint(0, 90)
            eventPlayer.DifMax = eventPlayer.DifMin + 10
            eventPlayer.FishValWait = 0.01
            eventPlayer.Fish = random.randint(0, len(LegFishNames) - 1)
            eventPlayer.FPModifier = 2
            break
        
def CancelFishing():
    @Name "End Fishing"

    eventPlayer.BaitVector = eventPlayer.BaitStartVector
    destroyHudText(eventPlayer.FishingHudIds[1])
    destroyHudText(eventPlayer.FishingHudIds[2])
    destroyHudText(eventPlayer.FishingHudIds[4])
    destroyProgressBarHud(eventPlayer.CastPowerHud)
    destroyAllIcons()
    
    eventPlayer.enableGamemodeHud()
    eventPlayer.stopFacing()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.startForcingThrottle(0, 1, 0, 1, 0, 1)
    eventPlayer.FishingStatus = FishingStates.READY_TO_FISH