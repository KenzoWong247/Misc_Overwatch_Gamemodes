settings {
    "main": {
        "description": "Made By Kayst",
        "modeName": "Wild West"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "ffaSlots": 10
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "hollywood"
            ],
            "heroLimit": "off"
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": true
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "mccree"
            ]
        }
    }
}

# Globar Vars
globalvar BCount
globalvar StorePrices
globalvar BankSpawnDetection
globalvar BankExit
globalvar MoneyBags
globalvar MoneyBagPos
globalvar MoneyBagValue
globalvar SaloonPos
globalvar BankDepositPos
globalvar BankWithdrawPos
globalvar BankTellerPos
globalvar StorePos
globalvar BankPos
globalvar JailPos
globalvar VaultPos
globalvar SafeZones
globalvar SafeZoneRadius
globalvar BartenderPos
globalvar GamblingPos
globalvar MinesPos
globalvar ShopSpots
globalvar ShopStrings
globalvar I
globalvar RobberySpots
globalvar VaultDoorsPos
globalvar UnbreakableDoorsPos
globalvar VaultDoorsEffect
globalvar ImpassableDoors
globalvar UnlockPoints
globalvar NumUnlockedDoors
globalvar SafeZoneLocations
globalvar TotalBankGold
globalvar JailCell
globalvar BailSpot
globalvar BailPercent
globalvar DonationBoxPos
globalvar SafeZoneHelp
globalvar HighLowPos
globalvar GambleSpots
globalvar DonorString
globalvar DonorTempArr
globalvar MayorTimer
globalvar Mayor

# Player Vars
playervar Location
playervar MoneyBag
playervar Gold
playervar MoneyBagI
playervar SafeZone
playervar Grenades
playervar QuickFire
playervar Armor
playervar StoredMoney
playervar WithdrawAmount
playervar DepositAmount
playervar Bet
playervar GambleState
playervar PlayerGuess
playervar ActualNumber
playervar VisualNumber
playervar GameEntities
playervar Payout
playervar GuessDelta
playervar LockPickSets
playervar I
playervar MineProgress
# Used for multiple progress bars
playervar ProgressBarUI
# Ussed for multiple gold accumulators
playervar EarnedGold
playervar AsheUnlocked
playervar AsheShopString
playervar PickaxeLevel
playervar TempArr
playervar TempNum
playervar RobberyProgress
playervar InCombat
playervar JailTimer
playervar BailCost
playervar MenuState
playervar MoneyArr # [Current, Min, Max, Increment]
playervar Game

playervar TownDonation
# Subroutines
subroutine EnteringSafeZone
subroutine ExitingSafeZone
subroutine CalcPayout
subroutine EndGamble
subroutine CalcMiningGold
subroutine CalcRobbery
subroutine VaultDoorUnlocked
subroutine ReLockVault
subroutine SetPayment
subroutine SetSafeZoneHelp
subroutine UpdateDonationString

# Enum
enum MenuStates:
    NONE = 0,
    SET_MONEY
enum GamblingStates:
    BETTING = 0,
    PRE_GAME, 
    GAME_IN_PROGRESS,
    PAYOUT

enum Locations:
    OUTSIDE = 0,
    SHOP,
    SALOON,
    BANK,
    MINES,
    ROBBERY_SPOT,
    VAULT_UNLOCK_SPOT,
    JAIL, 
    BANK_VAULT,
    DONATION_BOX

enum Games:
    NONE = 0,
    ROULETTE,
    HIGH_LOW
    

# Saloon 2.8 0 -61
# Bank Teller 33.5 1.15 -55
# Store -29 5.75 -42
# Jail 30, 1.86 -77
# Vault 48.8 2.75 -55.8
# VaultSafe 42.3 2.75 -54.5
# Shop -28.43, 5.75, -42.67
# -26.15, 5.75 -47.36
# -24.11 5.75 -50.40
# Rob Munitions -11 1.85 -36.39
# Rob Bank 8.29 1.75 -35.53

rule "Init":
    disableGamemodeCompletion()
    disableMusic()
    disableAnnouncer()

    MoneyBags = []
    MoneyBagPos = []
    MoneyBagValue = []

    DonorString = ''
    MayorTimer = 600

    TotalBankGold = 0
    BankSpawnDetection = vect(47.03, 2.75, -55.72)
    BankExit = vect(-6.30, 1.61, -8.86)
    
    # Safe Zones 
    SaloonPos = vect(1.75, 1.15, -61)
    BankPos = vect(36.50, 2.75, -55)
    StorePos = vect(-21.5, 5.75, -47.5)
    JailPos = vect(28.5, 1.86, -77.26)
    BailSpot = vect(30.35, 1.86, -75.34)

    HighLowPos = vect(0.91, 2, -60.45)
    JailCell = vect(30.49, 1.86, -77.37)
    BankDepositPos = vect(33.25, 2.75, -54.8)
    BankWithdrawPos = vect(33.88, 2.75, -52.33)
    BankTellerPos = vect(36.31, 2.75, -55.63)
    VaultPos = vect(48.69, 2.75, -56.42)
    MinesPos = vect(7.22, 1.75, -4.37)

    RobberySpots = [vect(-11, 1.85, -36.39), vect(8.29, 1.75, -35.53)]

    BartenderPos = vect(6.09, 2, -62.50)
    GamblingPos = vect(6.94, 2, -59.76)
    DonationBoxPos = vect(-0.83, 1.60, -81.85)

    ShopSpots = [vect(-28.94, 5.75, -41.99)]
    ShopStrings = ['Grenades 500 Gold', 'Quickdraw 200 Gold', 'Armor 700 Gold', 'Lockpick Kit 1500 Gold', 'Upgrade Pickaxe 500 Gold', 'Purchase Ashe 5000 Gold']
    StorePrices = [500, 200, 700, 1500, 500, 5000]

    VaultDoorsEffect = []
    VaultDoorsPos = [vect(31.67, 1.75, -30.63), vect(37.80, 2.75, -31.11), vect(38.39, 2.75, -38.81)]
    UnbreakableDoorsPos = [vect(36.32, 2.75, -61.89), vect(35.94, 2.75, -46.79)]
    UnlockPoints = [vect(30.54, 1.75, -34.65), vect(33.18, 1.75, -30.33), vect(39.10, 2.75, -34.79), vect(0, 0, 0)]
    NumUnlockedDoors = 0


    ImpassableDoors = []
    ImpassableDoors.append(UnbreakableDoorsPos)
    # Reverse array since we deleted from the back when unlocking
    ImpassableDoors.append(sorted(VaultDoorsPos, lambda _, i: -i))

    for I in range(1, len(ShopStrings)):
        ShopSpots.append(ShopSpots[0] + vect(1.5 * I, 0, -2.3 * I))

    BailPercent = 0.25
    GambleSpots = [GamblingPos, HighLowPos]
    
    SafeZones = [SaloonPos, StorePos, JailPos, BankPos, DonationBoxPos]
    SafeZoneRadius = [7.75, 11, 6.5, 8, 1.5]
    SafeZoneLocations = [Locations.SALOON, Locations.SHOP, Locations.JAIL, Locations.BANK, Locations.DONATION_BOX]



rule "Shorten Hero Selection":
    @Condition (isAssemblingHeroes() or isInSetup()) == true
    
    setMatchTime(5)
    disableScoring()
    wait(7)
    setMatchTime(10000)
    pauseMatchTime()

rule "World Effect Init":
    @Condition isGameInProgress()
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.ORANGE, SaloonPos - vect(0, 22, 0), 7.75, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, BankPos - vect(0, 22, 0), 8, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLUE, StorePos, 11, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, JailPos, 6.5, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, VaultPos, 3, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, BankDepositPos, 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, BankWithdrawPos, 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, GamblingPos, 1.5, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, HighLowPos, 1.5, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, MinesPos, 5, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.WHITE, JailCell - vect(0, 22, 0), 3, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, BailSpot, 1, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.SKY_BLUE, DonationBoxPos, 1.5, EffectReeval.NONE)
    createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, DonationBoxPos, 1.5, EffectReeval.NONE)

    wait()

    for I in range(len(RobberySpots)):
        createEffect(getAllPlayers(), Effect.RING, Color.BLACK, RobberySpots[I], 1, EffectReeval.NONE)

    createDummy(Hero.ZENYATTA, Team.ALL, -1, BankTellerPos, directionTowards(BankTellerPos, BankDepositPos))
    getLastCreatedEntity().startForcingName('Bank Teller')
    getLastCreatedEntity().setStatusEffect(null, Status.INVINCIBLE, 9999)

    createDummy(Hero.DOOMFIST, Team.ALL, -1, BartenderPos, directionTowards(BartenderPos, GamblingPos))
    getLastCreatedEntity().startForcingName('Saloon Owner')
    getLastCreatedEntity().setStatusEffect(null, Status.INVINCIBLE, 9999)

    wait()
    
    createInWorldText(getAllPlayers(), 'Roulette', GamblingPos + vect(0, 3, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'High-Low', HighLowPos + vect(0, 3, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT) 
    
    createInWorldText(getAllPlayers(), 'Saloon', SaloonPos + vect(0, 5, 0), 2, Clip.NONE, WorldTextReeval.NONE, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Bank (Town Total Stored: {} Gold)'.format(TotalBankGold), BankPos + vect(0, 5, 0), 2, Clip.NONE, WorldTextReeval.STRING, Color.GREEN, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Jail', JailPos + vect(0, 5, 0), 2, Clip.NONE, WorldTextReeval.NONE, Color.PURPLE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Store', StorePos + vect(0, 5, 0), 2, Clip.NONE, WorldTextReeval.NONE, Color.BLUE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Mines', MinesPos + vect(0, 5, 0), 2, Clip.NONE, WorldTextReeval.NONE, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Vault', VaultPos + vect(0, 1.5, 0), 2, Clip.SURFACES, WorldTextReeval.NONE, Color.YELLOW, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), 'Town Donations', DonationBoxPos + vect(0, 5, 0), 2, Clip.SURFACES, WorldTextReeval.NONE, Color.WHITE, SpecVisibility.DEFAULT)
    

    for I in range(len(UnbreakableDoorsPos)):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, UnbreakableDoorsPos[I], 3, EffectReeval.NONE)
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, UnbreakableDoorsPos[I] + vect(0, -22, 0), 3, EffectReeval.NONE)
    
    for I in range(len(VaultDoorsPos)):
        createEffect(getAllPlayers(), Effect.RING, Color.PURPLE, VaultDoorsPos[I], 3, EffectReeval.NONE)
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.PURPLE, VaultDoorsPos[I] + vect(0, -22, 0), 3, EffectReeval.NONE)
        VaultDoorsEffect.append(getLastCreatedEntity())

    for I in range(len(ShopSpots)):
        createEffect(getAllPlayers(), Effect.RING, Color.SKY_BLUE, ShopSpots[I], 1, EffectReeval.NONE)
        if I < len(ShopSpots) - 2:
            createInWorldText(getAllPlayers(), ShopStrings[I], ShopSpots[I] + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.NONE, Color.WHITE, SpecVisibility.DEFAULT)

    createEffect(getAllPlayers(), Effect.RING, Color.BLACK, UnlockPoints[NumUnlockedDoors], 1, EffectReeval.POSITION_AND_RADIUS)
    wait()

    createInWorldText(getAllPlayers(), 'Donors:\n{}'.format(DonorString), DonationBoxPos + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.DEFAULT)

rule "Player Joined":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false

    eventPlayer.Location = Locations.OUTSIDE
    eventPlayer.Gold = 200
    eventPlayer.StoredMoney = 0
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.SafeZone = false
    eventPlayer.Grenades = 0
    eventPlayer.QuickFire = 0
    eventPlayer.WithdrawAmount = 0
    eventPlayer.DepositAmount = 0
    eventPlayer.Bet = 50
    eventPlayer.Payout = 0
    eventPlayer.GambleState = GamblingStates.BETTING
    eventPlayer.MineProgress = 0
    eventPlayer.AsheUnlocked = false
    eventPlayer.AsheShopString = 'Unlock Ashe {} Gold'.format(StorePrices[5])
    eventPlayer.PickaxeLevel = 1
    eventPlayer.RobberyProgress = 0
    eventPlayer.LockPickSets = 0
    eventPlayer.Armor = 0
    eventPlayer.InCombat = false
    eventPlayer.JailTimer = 0
    eventPlayer.MenuState = MenuStates.NONE
    eventPlayer.Game = Games.NONE
    eventPlayer.TownDonation = 0

    eventPlayer.TempArr = []
    eventPlayer.GameEntities = []
    # MoneyArr = [0: Current, 1: Increment, 2: Min, 3: Max]
    eventPlayer.MoneyArr = [50, 0, 0, 0]


    hudHeader(eventPlayer, 'Player Stats', HudPosition.LEFT, 0, Color.WHITE, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Gold: {}'.format(eventPlayer.Gold), HudPosition.LEFT, 1, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Pickaxe Level: {}'.format(eventPlayer.PickaxeLevel), HudPosition.LEFT, 1, Color.ROSE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Grenades: {}'.format(eventPlayer.Grenades), HudPosition.LEFT, 1, Color.RED, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Quickfires: {}'.format(eventPlayer.QuickFire), HudPosition.LEFT, 1, Color.GREEN, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, 'Lockpick Kits: {}'.format(eventPlayer.LockPickSets), HudPosition.LEFT, 1, Color.BLACK, HudReeval.STRING, SpecVisibility.DEFAULT)
    

    createInWorldText(eventPlayer, '{} to Deposit: {}\n{} to increase/{} to decrease'.format(buttonString(Button.INTERACT), eventPlayer.DepositAmount, buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)), BankDepositPos + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    createInWorldText(eventPlayer, 'Bank Total: {}  2% Interest\nPress {} to Withdraw: {}\n{} to increase/{} to decrease'.format(eventPlayer.StoredMoney, buttonString(Button.INTERACT), eventPlayer.WithdrawAmount, buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)), BankWithdrawPos + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    
    
    createInWorldText(eventPlayer, eventPlayer.AsheShopString, ShopSpots[len(ShopSpots) - 1] + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(eventPlayer, 'Upgrade Pickaxe {} gold'.format(eventPlayer.PickaxeLevel * 500) if eventPlayer.PickaxeLevel < 4 else 'Pickaxe fully upgraded', ShopSpots[len(ShopSpots) - 2] + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(eventPlayer, 'Bail taken out of Bank\nBail Cost: {}. Bank Total: {}\n {} to Pay Amount: {} to Reduce Sentence by {}s\n{} to increase/{} to decrease payment'.format(eventPlayer.JailTimer, eventPlayer.StoredMoney, buttonString(Button.INTERACT), eventPlayer.Bet, eventPlayer.Bet, buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)), BailSpot + vect(0, 1.5, 0), 1, Clip.SURFACES, WorldTextReeval.STRING, Color.WHITE, SpecVisibility.DEFAULT)



rule "Host Joined":
    @Event playerJoined
    @Condition eventPlayer == hostPlayer
    hudSubtext(hostPlayer, 'X: {}, Y: {}, Z: {}'.format(eventPlayer.getPosition().x, eventPlayer.getPosition().y, eventPlayer.getPosition().z), HudPosition.LEFT, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(hostPlayer, 'Load: {}, Avg: {}, High: {}'.format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudSubtext(hostPlayer, 'Location: {}'.format(eventPlayer.Location), HudPosition.LEFT, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    
rule "Player First Spawn":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setScore(eventPlayer.Gold)

rule "Player Respawn":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isAlive() == true

    if distance(eventPlayer, BankSpawnDetection) < 9 and NumUnlockedDoors < 3:
        eventPlayer.teleport(BankExit)
    if eventPlayer.JailTimer > 0:
        eventPlayer.teleport(JailCell)
    wait(0.02)
    eventPlayer.setScore(eventPlayer.Gold)
    

rule "Player Died":
    @Event playerDied
    
    # Earned Gold is the amount you will drop
    eventPlayer.EarnedGold = floor(eventPlayer.Gold / 2)
    if eventPlayer.EarnedGold > 0:
        createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, eventPlayer.getPosition() + vect(0, 0.5, 0), 0.5, EffectReeval.VISIBILITY_AND_COLOR)
        MoneyBagPos.append(eventPlayer.getPosition())
        MoneyBags.append(getLastCreatedEntity())

        MoneyBagValue.append(eventPlayer.EarnedGold)
        smallMessage(eventPlayer, 'You lost {} gold!'.format(eventPlayer.EarnedGold))
        eventPlayer.Gold -= eventPlayer.EarnedGold
        wait(0.02)
    eventPlayer.setScore(eventPlayer.Gold)

    if eventPlayer.EarnedGold < 100:
        eventPlayer.Bet = 50
        eventPlayer.JailTimer = floor(eventPlayer.StoredMoney * BailPercent)
        if eventPlayer.JailTimer < 50:
            eventPlayer.JailTimer = 30
        bigMessage(eventPlayer, 'You went to jail since you were carrying less than 100 Gold')
    eventPlayer.InCombat = false
    wait(0.02)

rule "Jail Timer":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.JAIL
    @Condition eventPlayer.JailTimer > 0

    hudHeader(eventPlayer, 'You are in jail for {} seconds'.format(eventPlayer.JailTimer), HudPosition.TOP, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    while eventPlayer.JailTimer > 0:
        wait(1)
        eventPlayer.JailTimer -= 1
    destroyHudText(getLastCreatedText())

rule "Pay Bail":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.JailTimer > 0
    @Condition eventPlayer.Location == Locations.JAIL
    @Condition distance(eventPlayer, BailSpot) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    # Bet = Bail Amount
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if (eventPlayer.StoredMoney >= eventPlayer.Bet + 50) and (eventPlayer.JailTimer >= eventPlayer.Bet + 50):
            eventPlayer.Bet += 50
        return

    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.Bet > 100:
            eventPlayer.Bet -= 50
        else:
            eventPlayer.Bet = 50
        return
    elif eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.StoredMoney >= eventPlayer.Bet:
            waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 3)

            if eventPlayer.Bet > eventPlayer.JailTimer:
                eventPlayer.Bet = eventPlayer.JailTimer
            eventPlayer.JailTimer -= eventPlayer.Bet
            eventPlayer.StoredMoney -= eventPlayer.Bet
            eventPlayer.Bet = 50
        else:
            smallMessage(eventPlayer, 'You do not have enough money in the bank to pay bail')
        return



rule "Player Leaving Jail":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.JAIL
    @Condition eventPlayer.JailTimer > 0
    @Condition distance(eventPlayer, JailCell) >= 3
    
    eventPlayer.setMoveSpeed(0)
    eventPlayer.stopAcceleration()
    eventPlayer.applyImpulse(directionTowards(eventPlayer, JailCell), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, 'You are in jail for {}s'.format(eventPlayer.JailTimer))
    wait(0.02)
    eventPlayer.setMoveSpeed(100)



# TOWN DONATION
rule "Donation Box Location":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.DONATION_BOX
    
    eventPlayer.MenuState = MenuStates.SET_MONEY
    eventPlayer.MoneyArr = [100, 100, 100, floor(eventPlayer.Gold / 100) * 100]
    createInWorldText(eventPlayer, '{} to Donate. Donation: {}'.format(buttonString(Button.INTERACT), eventPlayer.MoneyArr[0]), worldVector(vect(0, 1.5, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())

rule "Left Donation Location":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition distance(eventPlayer, DonationBoxPos) > 1.5

    destroyInWorldText(eventPlayer.GameEntities[len(eventPlayer.GameEntities) - 1])
    eventPlayer.GameEntities = eventPlayer.GameEntities.exclude(eventPlayer.GameEntities[len(eventPlayer.GameEntities) - 1])
    eventPlayer.MenuState = MenuStates.NONE


rule "Donate to Town":
    @Event eachPlayer
    @Condition eventPlayer.Location == Locations.DONATION_BOX
    @Condition eventPlayer.MenuState == MenuStates.SET_MONEY
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)


    eventPlayer.Bet = eventPlayer.MoneyArr[0]

    if eventPlayer.Bet <= eventPlayer.Gold:
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), 3)
        eventPlayer.Gold -= eventPlayer.Bet

        bigMessage(getAllPlayers(), '{} Donated {} Gold to the Town!'.format(eventPlayer, eventPlayer.Bet))

        wait(0.5)

        eventPlayer.TownDonation += eventPlayer.Bet
        eventPlayer.Bet = 0
        eventPlayer.setScore(eventPlayer.Gold)
        UpdateDonationString()
        
        eventPlayer.MoneyArr = [100, 100, 100, floor(eventPlayer.Gold / 100) * 100]
        eventPlayer.MenuState = MenuStates.SET_MONEY
    else:
        smallMessage(eventPlayer, 'You do not have enough money')

rule "Town Election":
    @Event global
    @Condition isGameInProgress()
    @Condition MayorTimer > 0

    while MayorTimer >= 0:
        wait(30)
        MayorTimer -= 30
        
        if MayorTimer == 120:
            bigMessage(getAllPlayers(), 'Two Minutes until Mayor is Elected')
        elif MayorTimer == 60:
            bigMessage(getAllPlayers(), 'One Minute until Mayor is Elected')
            
        Mayor = sorted(getAllPlayers(), lambda _, i: i.TownDonation)[0]
        if Mayor.TownDonation > 0:
            bigMessage(getAllPlayers(), '{} is now the new mayor!'.format(Mayor))

    MayorTimer = 600


# BANK VAULT HEIST

rule "Enter Bank Vault":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition distance(eventPlayer, VaultPos) <= 3

    progressBarHud(eventPlayer, eventPlayer.RobberyProgress, 'Hold {} to open the vault. Progress: {}%'.format(Button.INTERACT, eventPlayer.RobberyProgress), HudPosition.TOP, 1, Color.RED, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.ProgressBarUI = getLastCreatedText()
    eventPlayer.Location = Locations.BANK_VAULT

rule "In Bank Vault":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.BANK_VAULT
    @Condition NumUnlockedDoors == 3
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    while eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.RobberyProgress += 1
        wait(0.002)
        if eventPlayer.RobberyProgress >= 100:
            destroyProgressBarHud(eventPlayer.ProgressBarUI)
            eventPlayer.RobberyProgress = 0
            playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer, 500)
            TotalBankGold = 0
            for eventPlayer.I in range(getNumberOfPlayers(Team.ALL)):
                TotalBankGold += getAllPlayers()[eventPlayer.I].StoredMoney
                eventPlayer.Gold += TotalBankGold
                eventPlayer.setScore(eventPlayer.Gold)
                getAllPlayers()[eventPlayer.I].StoredMoney = 0
                getAllPlayers()[eventPlayer.I].WithdrawAmount = 0
            wait(0.02)
            bigMessage(getAllPlayers(), '{} has just stolen all the money from the bank!'.format(eventPlayer))
            bigMessage(getAllPlayers(), 'Players lost a total of {} gold!'.format(TotalBankGold))
            ReLockVault()
            bigMessage(getAllPlayers(), '{} was teleported to the edge of town catch them before they escape!'.format(eventPlayer))
            wait(0.02)
            eventPlayer.teleport(BankExit)
            eventPlayer.Location = Locations.OUTSIDE
            return

rule "Enter Vault When Locked":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition NumUnlockedDoors < 3
    @Condition distance(eventPlayer, BankSpawnDetection) < 9

    eventPlayer.teleport(BankExit)
    wait(0.02)

rule "Exit Bank Vault":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.BANK_VAULT
    @Condition eventPlayer.isAlive()
    @Condition distance(eventPlayer, VaultPos) > 3

    destroyProgressBarHud(eventPlayer.ProgressBarUI)
    eventPlayer.Location = Locations.OUTSIDE


rule "Enter Vault Unlock Point":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition distance(eventPlayer, UnlockPoints[NumUnlockedDoors]) <= 1

    eventPlayer.Location = Locations.VAULT_UNLOCK_SPOT
    progressBarHud(eventPlayer, eventPlayer.RobberyProgress, 'Hold {} to start break in. Progress: {}%\nGet a lockpick set to speed up'.format(Button.INTERACT, eventPlayer.RobberyProgress), HudPosition.TOP, 1, Color.RED, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.ProgressBarUI = getLastCreatedText()

rule "Player Lockpicking":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.VAULT_UNLOCK_SPOT
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    while eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.LockPickSets > 0:
            wait(0.3, Wait.RESTART_WHEN_TRUE)
        else:
            wait(0.7, Wait.RESTART_WHEN_TRUE)
        eventPlayer.RobberyProgress += 1
        if eventPlayer.RobberyProgress % 15 == 0:
            playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer.getPosition(), 300)
        if eventPlayer.RobberyProgress >= 100:
            if eventPlayer.LockPickSets > 0:
                eventPlayer.LockPickSets -= 1
                smallMessage(eventPlayer, 'Lockpick kit was used up')
            eventPlayer.RobberyProgress = 0
            NumUnlockedDoors += 1
            wait(0.02)
            VaultDoorUnlocked()
            return


rule "Player Leaves Vault Unlock Spot":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.VAULT_UNLOCK_SPOT
    @Condition distance(eventPlayer, UnlockPoints[NumUnlockedDoors]) > 1

    eventPlayer.Location = Locations.OUTSIDE
    destroyProgressBarHud(eventPlayer.ProgressBarUI)
    eventPlayer.RobberyProgress = 0


rule "Cannot Pass Through":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition any([distance(eventPlayer, i) <= 3 for i in ImpassableDoors])

    eventPlayer.I = ImpassableDoors.index([i for i in ImpassableDoors if distance(eventPlayer, i) < 3][0])
    eventPlayer.setMoveSpeed(0)
    eventPlayer.stopAcceleration()
    eventPlayer.applyImpulse(directionTowards(ImpassableDoors[eventPlayer.I], eventPlayer), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, 'This area is locked')
    wait(0.02)
    eventPlayer.setMoveSpeed(100)

rule "Player Enters Robbery Spot":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition any([distance(eventPlayer, i) < 1 for i in RobberySpots])

    progressBarHud(eventPlayer, eventPlayer.RobberyProgress, 'Hold {} to start robbing. Progress: {}%\nGet a lockpick set to speed up'.format(Button.INTERACT, eventPlayer.RobberyProgress), HudPosition.TOP, 1, Color.RED, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.ProgressBarUI = getLastCreatedText()
    eventPlayer.Location = Locations.ROBBERY_SPOT

rule "Player Lockpicking":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.ROBBERY_SPOT
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    while eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.LockPickSets > 0:
            wait(0.2, Wait.RESTART_WHEN_TRUE)
        else:
            wait(0.5, Wait.RESTART_WHEN_TRUE)
        eventPlayer.RobberyProgress += 1
        if eventPlayer.RobberyProgress % 15 == 0:
            playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer.getPosition(), 200)
        if eventPlayer.RobberyProgress >= 100:
            if eventPlayer.LockPickSets > 0:
                eventPlayer.LockPickSets -= 1
                smallMessage(eventPlayer, 'Lockpick kit was used up')
            CalcRobbery()
            eventPlayer.RobberyProgress = 0


rule "Player Leaves Robbery Spot":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.ROBBERY_SPOT
    @Condition all([distance(eventPlayer, i) > 1 for i in RobberySpots])

    eventPlayer.Location = Locations.OUTSIDE
    destroyProgressBarHud(eventPlayer.ProgressBarUI)
    eventPlayer.RobberyProgress = 0


rule "Remove Armor On Damage":
    @Event playerTookDamage
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Armor > 0
    
    eventPlayer.Armor = eventPlayer.getHealthOfType(Health.ARMOR) 

rule "In Combat On Damage":
    @Event playerTookDamage
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.InCombat = true
    wait(10, Wait.RESTART_WHEN_TRUE)
    eventPlayer.InCombat = false

rule "In Combat Dealing Damage":
    @Event playerDealtDamage
    @Condition eventPlayer.isDummy() == false

    eventPlayer.InCombat = true
    wait(10, Wait.RESTART_WHEN_TRUE)
    eventPlayer.InCombat = false

rule "In Combat Safe Zone":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition eventPlayer.InCombat == true
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.SafeZone == false
    @Condition any([distance(eventPlayer, i) < SafeZoneRadius[SafeZones.index(i)] for i in SafeZones])

    bigMessage(eventPlayer, 'WARNING: You are in combat safe zone actions disabled.')
    wait(10, Wait.ABORT_WHEN_FALSE)
    

rule "Entered Bank":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.BANK
    @Condition eventPlayer.InCombat == false
    @Condition eventPlayer.SafeZone == true

    eventPlayer.DepositAmount = eventPlayer.Gold
    eventPlayer.WithdrawAmount = eventPlayer.StoredMoney

rule "Entering Safe Zone":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition eventPlayer.InCombat == false
    @Condition eventPlayer.SafeZone == false
    @Condition any([distance(eventPlayer, i) < SafeZoneRadius[SafeZones.index(i)] for i in SafeZones])
    
    EnteringSafeZone()

rule "Exiting Safe Zone":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.SafeZone == true
    @Condition all([distance(eventPlayer, i) > SafeZoneRadius[SafeZones.index(i)] for i in SafeZones])

    ExitingSafeZone()


rule "Player Pickup Gold":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isAlive()
    @Condition len(MoneyBagPos) > 0
    @Condition any([distance(eventPlayer.getPosition(), i) < 1 for i in MoneyBagPos])

    eventPlayer.MoneyBagI = MoneyBagPos.index([i for i in MoneyBagPos if distance(eventPlayer, i) < 1][0])

    eventPlayer.Gold += MoneyBagValue[eventPlayer.MoneyBagI]
    eventPlayer.setScore(eventPlayer.Gold)
    destroyEffect(MoneyBags[eventPlayer.MoneyBagI])
    smallMessage(eventPlayer, ' Picked up {} gold!'.format(MoneyBagValue[eventPlayer.MoneyBagI]))
    wait(0.1)
    MoneyBags = MoneyBags.exclude(MoneyBags[eventPlayer.MoneyBagI])
    MoneyBagPos = MoneyBagPos.exclude(MoneyBagPos[eventPlayer.MoneyBagI])
    MoneyBagValue = MoneyBagValue.exclude(MoneyBagValue[eventPlayer.MoneyBagI])

rule "Bank Interest":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.StoredMoney > 0

    while eventPlayer.StoredMoney > 0:
        wait(60, Wait.ABORT_WHEN_FALSE)
        TotalBankGold -= eventPlayer.StoredMoney
        eventPlayer.StoredMoney += floor(eventPlayer.StoredMoney * 0.02)
        TotalBankGold += eventPlayer.StoredMoney
        eventPlayer.WithdrawAmount = eventPlayer.StoredMoney

rule "Deposit Money":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.BANK
    @Condition eventPlayer.Gold > 0
    @Condition distance(eventPlayer, BankDepositPos) <= 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.Gold >= eventPlayer.DepositAmount + 100:
            eventPlayer.DepositAmount += 100
        else:
            eventPlayer.DepositAmount = eventPlayer.Gold
        
        waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false, 1)
        return

    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.DepositAmount >= 100:
            eventPlayer.DepositAmount -= 100
        else:
            eventPlayer.DepositAmount = 0
        waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, 1)
        return
    elif eventPlayer.isHoldingButton(Button.INTERACT):
        wait(0.02)
        eventPlayer.StoredMoney += eventPlayer.DepositAmount
        TotalBankGold += eventPlayer.DepositAmount
        smallMessage(eventPlayer, 'Deposited {} gold'.format(eventPlayer.DepositAmount))
        eventPlayer.Gold -= eventPlayer.DepositAmount
        eventPlayer.setScore(eventPlayer.Gold)
        wait(0.02)
        eventPlayer.DepositAmount = eventPlayer.Gold
        eventPlayer.WithdrawAmount = eventPlayer.StoredMoney
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 1)
        return
    else:
        return

rule "Withdraw Money":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.BANK
    @Condition eventPlayer.StoredMoney > 0
    @Condition distance(eventPlayer, BankWithdrawPos) < 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.StoredMoney >= eventPlayer.WithdrawAmount + 100:
            eventPlayer.WithdrawAmount += 100
        else:
            eventPlayer.WithdrawAmount = eventPlayer.StoredMoney
        
        return

    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.WithdrawAmount >= 100:
            eventPlayer.WithdrawAmount -= 100
        else:
            eventPlayer.WithdrawAmount = 0
        return
    elif eventPlayer.isHoldingButton(Button.INTERACT):
        wait(0.02)
        eventPlayer.Gold += eventPlayer.WithdrawAmount
        eventPlayer.setScore(eventPlayer.Gold)
        smallMessage(eventPlayer, 'Withdrew {} gold'.format(eventPlayer.WithdrawAmount))
        wait(0.02)
        eventPlayer.StoredMoney -= eventPlayer.WithdrawAmount
        TotalBankGold -= eventPlayer.WithdrawAmount
        eventPlayer.WithdrawAmount = eventPlayer.StoredMoney
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 1)
        return
    else:
        return

rule "Enter Roulette Circle":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition distance(eventPlayer, GamblingPos) <= 1.5
    
    wait(0.02)
    hudHeader(eventPlayer, 'Roulette (Kinda)', HudPosition.RIGHT, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Minimum Bet: 50', HudPosition.RIGHT, 1, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Guess what number the bar will land on', HudPosition.RIGHT, 2, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Payouts: ', HudPosition.RIGHT, 3, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, '+/- 0: x 10\n+/- 5: x 4\n+/- 15: x 2\n+/- 20: x 1', HudPosition.RIGHT, 4, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    eventPlayer.MoneyArr = [50, 50, 50, floor(eventPlayer.Gold / 50) * 50]
    createInWorldText(eventPlayer, '{} to start game. Bet: {}'.format(buttonString(Button.INTERACT), eventPlayer.MoneyArr[0]), worldVector(vect(0, 1.5, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    eventPlayer.MenuState = MenuStates.SET_MONEY
    eventPlayer.Game = Games.ROULETTE

rule "Enter High Low Circle":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition distance(eventPlayer, HighLowPos) <= 1.5
    
    wait(0.02)
    hudHeader(eventPlayer, 'High Low', HudPosition.RIGHT, 0, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Minimum Bet: 50', HudPosition.RIGHT, 1, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Guess Higher or Lower\nPayout after a streak of 5', HudPosition.RIGHT, 2, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, 'Payouts: ', HudPosition.RIGHT, 3, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    hudSubtext(eventPlayer, '5 Streak: x 2\n10 Streak: x4\n15 Streak x10\n20 Streak x20', HudPosition.RIGHT, 4, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    eventPlayer.MoneyArr = [50, 50, 50, floor(eventPlayer.Gold / 50) * 50]
    createInWorldText(eventPlayer, '{} to start game. Bet: {}'.format(buttonString(Button.INTERACT), eventPlayer.MoneyArr[0]), worldVector(vect(0, 1.5, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    eventPlayer.MenuState = MenuStates.SET_MONEY
    eventPlayer.Game = Games.HIGH_LOW
    eventPlayer.GuessDelta = 0
    eventPlayer.TempNum = random.randint(0, 100)

rule "Exit Gamble Spot":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition all([distance(eventPlayer, i) > 1.5 for i in GambleSpots])
    # Might need to change later potential bugs if theres multiple games
    @Condition len(eventPlayer.GameEntities) > 0

    wait(0.02)
    for eventPlayer.I in range(len(eventPlayer.GameEntities)):
        destroyHudText(eventPlayer.GameEntities[eventPlayer.I])
        destroyInWorldText(eventPlayer.GameEntities[eventPlayer.I])
    eventPlayer.GameEntities = eventPlayer.GameEntities.exclude(eventPlayer.GameEntities[eventPlayer.I])
    eventPlayer.TempArr = []
    eventPlayer.GameEntities = []
    eventPlayer.Game = Games.NONE

rule "High Low Betting":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.HIGH_LOW
    @Condition eventPlayer.GambleState == GamblingStates.BETTING
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.Bet = eventPlayer.MoneyArr[0]
    if eventPlayer.Gold >= eventPlayer.Bet:
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 3)
        eventPlayer.setMoveSpeed(0)
        destroyInWorldText(eventPlayer.GameEntities[len(eventPlayer.GameEntities) - 1])
        eventPlayer.PlayerGuess = 0
        eventPlayer.Gold -= eventPlayer.Bet
        eventPlayer.GambleState = GamblingStates.PRE_GAME
        eventPlayer.MenuState = MenuStates.SET_MONEY
        eventPlayer.MoneyArr = [0, 1, 0, 1]
        hudSubtext(eventPlayer, 'Higher/Lower than: {}. Streak: {}'.format(eventPlayer.TempNum, eventPlayer.GuessDelta), HudPosition.TOP, 3, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
        eventPlayer.GameEntities.append(getLastCreatedText())

        hudSubtext(eventPlayer, 'Your Guess: {}'.format('Higher' if eventPlayer.MoneyArr[0] >= 1 else 'Lower'), HudPosition.TOP, 4, Color.BLUE, HudReeval.STRING, SpecVisibility.DEFAULT)
        eventPlayer.GameEntities.append(getLastCreatedText())
        
        hudSubtext(eventPlayer, '{} to Play. {} to Cancel/Cash Out'.format(buttonString(Button.INTERACT), buttonString(Button.CROUCH)), HudPosition.TOP, 5, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
        eventPlayer.GameEntities.append(getLastCreatedText())
        
        hudSubtext(eventPlayer, 'If you cancel before a streak of 5 you lose', HudPosition.TOP, 7, Color.RED, HudReeval.NONE, SpecVisibility.DEFAULT)
        eventPlayer.GameEntities.append(getLastCreatedText())
        eventPlayer.TempNum = random.randint(0, 100)
    else:
        smallMessage(eventPlayer, 'You do not have enough money to gamble')

rule "High-Low Game Controls":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.HIGH_LOW
    @Condition eventPlayer.GambleState == GamblingStates.PRE_GAME
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.CROUCH)


    if eventPlayer.isHoldingButton(Button.INTERACT):
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 3)
        eventPlayer.GambleState = GamblingStates.GAME_IN_PROGRESS
        eventPlayer.MenuState = MenuStates.NONE
        return
    elif eventPlayer.isHoldingButton(Button.CROUCH):
        waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, 3)
        eventPlayer.GambleState = GamblingStates.PAYOUT
        return


rule "High-Low Gameplay":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.HIGH_LOW
    @Condition eventPlayer.GambleState == GamblingStates.GAME_IN_PROGRESS

    eventPlayer.PlayerGuess = eventPlayer.MoneyArr[0]
    hudSubtext(eventPlayer, 'Number: {}'.format(eventPlayer.ActualNumber), HudPosition.TOP, 9, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    for eventPlayer.I in range(10):
        eventPlayer.ActualNumber = random.randint(0, 100)
        wait(0.1)
    wait(1)
    if eventPlayer.ActualNumber == eventPlayer.TempNum:
        bigMessage(eventPlayer, 'Its a tie! Free win!')
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer, 200)
        eventPlayer.GuessDelta += 1
    elif eventPlayer.PlayerGuess >= 1:
        if eventPlayer.ActualNumber > eventPlayer.TempNum:
            # Guess Delta = Win Streak
            playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer, 200)
            bigMessage(eventPlayer, 'Higher! Streak + 1')
            eventPlayer.GuessDelta += 1
        else:
            eventPlayer.GuessDelta = 0
            eventPlayer.GambleState = GamblingStates.PAYOUT
            return
    elif eventPlayer.PlayerGuess <= 0:
        if eventPlayer.ActualNumber < eventPlayer.TempNum:
            playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer, 200)
            bigMessage(eventPlayer, 'Lower! Streak + 1')
            eventPlayer.GuessDelta += 1
        else:
            eventPlayer.GuessDelta = 0
            eventPlayer.GambleState = GamblingStates.PAYOUT
            playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, null, eventPlayer, 200)
            return
    destroyHudText(getLastCreatedText())

    if eventPlayer.GuessDelta >= 20:
        eventPlayer.GambleState = GamblingStates.PAYOUT
        return

    eventPlayer.GambleState = GamblingStates.PRE_GAME
    eventPlayer.MenuState = MenuStates.SET_MONEY
    eventPlayer.TempNum = eventPlayer.ActualNumber

rule "Roulette Betting":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.ROULETTE
    @Condition eventPlayer.GambleState == GamblingStates.BETTING
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.Bet = eventPlayer.MoneyArr[0]
    if eventPlayer.Gold >= eventPlayer.Bet:
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 3)
        eventPlayer.setMoveSpeed(0)
        eventPlayer.startFacing(directionTowards(eventPlayer, BartenderPos), 360, Relativity.TO_WORLD, FacingReeval.NONE)
        destroyInWorldText(eventPlayer.GameEntities[len(eventPlayer.GameEntities) - 1])
        eventPlayer.PlayerGuess = 0
        eventPlayer.Gold -= eventPlayer.Bet
        eventPlayer.GambleState = GamblingStates.PRE_GAME
        eventPlayer.MenuState = MenuStates.SET_MONEY
        eventPlayer.MoneyArr = [0, 1, 0, 100]
        progressBarHud(eventPlayer, eventPlayer.MoneyArr[0], 'Bet: {} Gold. Guess: {}. Press {} to start.\n{} to increase guess/{} to decrease guess\n{} to cancel'.format(eventPlayer.Bet, eventPlayer.MoneyArr[0], buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH)),HudPosition.TOP, 3, Color.GREEN, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
        eventPlayer.GameEntities.append(getLastCreatedText())
    else:
        smallMessage(eventPlayer, 'You do not have enough money to gamble')
          
rule "Roulette Game UI":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.ROULETTE
    @Condition eventPlayer.GambleState == GamblingStates.PRE_GAME
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.CROUCH)
            
    wait(0.02)
    eventPlayer.PlayerGuess = eventPlayer.MoneyArr[0]
    if eventPlayer.isHoldingButton(Button.CROUCH):
        waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, 1)
        smallMessage(eventPlayer, 'Game canceled')
        eventPlayer.Gold += eventPlayer.Bet
        EndGamble()
        wait(0.02)
        return
    elif eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.MenuState = MenuStates.NONE
        waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 3)
        eventPlayer.GambleState = GamblingStates.GAME_IN_PROGRESS

rule "Roulette Game Play":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SALOON
    @Condition eventPlayer.Game == Games.ROULETTE
    @Condition eventPlayer.GambleState == GamblingStates.GAME_IN_PROGRESS

    eventPlayer.ActualNumber = random.randint(0, 100)
    eventPlayer.VisualNumber = 0

    progressBarHud(eventPlayer, eventPlayer.VisualNumber, 'Actual Number is {}'.format(eventPlayer.VisualNumber), HudPosition.TOP, 4, Color.PURPLE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    while eventPlayer.VisualNumber < eventPlayer.ActualNumber:
        eventPlayer.VisualNumber += 1
        wait(0.05)

    bigMessage(eventPlayer, 'Actual number was {} !'.format(eventPlayer.ActualNumber))
    eventPlayer.GambleState = GamblingStates.PAYOUT
    

rule "Payout":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.GambleState == GamblingStates.PAYOUT

    CalcPayout()
    if eventPlayer.Payout > 0:
        bigMessage(eventPlayer, 'You got {} gold!'.format(eventPlayer.Payout))
    elif eventPlayer.Payout == eventPlayer.Bet:
        bigMessage(eventPlayer, 'You kept your bet {} gold'.format(eventPlayer.Payout))
    else:
        bigMessage(eventPlayer, 'Too bad you lost {} gold. Try again!'.format(eventPlayer.Bet))
    eventPlayer.Gold += eventPlayer.Payout
    eventPlayer.setScore(eventPlayer.Gold)
    wait(1)
    EndGamble()

rule "Player is Mining":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.MINES
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false

    while eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            wait(1)
        wait(0.1 - (eventPlayer.PickaxeLevel * 0.02), Wait.RESTART_WHEN_TRUE)
        eventPlayer.MineProgress += 1
        if eventPlayer.MineProgress % 20 == 0:
            playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, null, eventPlayer, 100)
        if eventPlayer.MineProgress == 100:
            CalcMiningGold()
            eventPlayer.MineProgress = 0
            smallMessage(eventPlayer, 'Gained {} gold from mining!'.format(eventPlayer.EarnedGold))
            eventPlayer.Gold += eventPlayer.EarnedGold
            eventPlayer.setScore(eventPlayer.Gold)
        if not RULE_CONDITION:
            return

rule "Player Enters Mines":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.OUTSIDE
    @Condition distance(eventPlayer, MinesPos) < 5

    progressBarHud(eventPlayer, eventPlayer.MineProgress, 'Hold {} to mine. Progress {}%'.format(buttonString(Button.INTERACT), eventPlayer.MineProgress), HudPosition.TOP, 3, Color.ROSE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.ProgressBarUI = getLastCreatedText()
    eventPlayer.setDamageReceived(25)
    eventPlayer.setDamageDealt(25)
    eventPlayer.Location = Locations.MINES
    
rule "Player Exits Mines":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.MINES
    @Condition distance(eventPlayer, MinesPos) > 5

    eventPlayer.Location = Locations.OUTSIDE
    destroyProgressBarHud(eventPlayer.ProgressBarUI)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setDamageDealt(100)
    

rule "Bought Abilities":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isUsingAbility2() or eventPlayer.isFiringSecondaryFire()

    if eventPlayer.isUsingAbility2():
        waitUntil(eventPlayer.isUsingAbility2() == false, 2)
        eventPlayer.Grenades -= 1
        if eventPlayer.Grenades < 1:
            eventPlayer.setAbility2Enabled(false)
    else:
        if eventPlayer.getCurrentHero() == Hero.MCCREE:
            waitUntil(eventPlayer.isFiringSecondaryFire() == false, 3)
            eventPlayer.QuickFire -= 1
            if eventPlayer.QuickFire < 1:
                eventPlayer.setSecondaryFireEnabled(false)
    wait(0.02)

rule "Purchase From Store":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.Location == Locations.SHOP
    @Condition any([distance(eventPlayer, i) < 1 for i in ShopSpots])
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.I = ShopSpots.index([i for i in ShopSpots if distance(eventPlayer, i) < 1][0])
    switch eventPlayer.I:
        case 0:
            if eventPlayer.Gold >= StorePrices[0]:
                eventPlayer.Gold -= StorePrices[0]
                eventPlayer.Grenades += 1
                smallMessage(eventPlayer, 'You bought a grenade!')    
            else:
                smallMessage(eventPlayer, 'You need {} more gold'.format(StorePrices[0] - eventPlayer.Gold))
            wait(0.02)
            break
        case 1:
            if eventPlayer.Gold >= StorePrices[1]:
                eventPlayer.Gold -= StorePrices[1]
                eventPlayer.QuickFire += 1
                smallMessage(eventPlayer, 'You bought a quickfire!')
            else:
                smallMessage(eventPlayer, 'You need {} more gold'.format(StorePrices[1] - eventPlayer.Gold))
            wait(0.02)
            break
        case 2:
            if eventPlayer.Armor < 200:
                if eventPlayer.Gold >= StorePrices[2]:
                    eventPlayer.Gold -= StorePrices[2]
                    eventPlayer.removeAllHealthPools()
                    eventPlayer.addHealthPool(Health.ARMOR, 200, false, true)
                    eventPlayer.Armor = 200
                    smallMessage(eventPlayer, 'You bought some armor!')
                else:
                    smallMessage(eventPlayer, 'You need {} more gold'.format(StorePrices[2] - eventPlayer.Gold))
            else:
                smallMessage(eventPlayer, 'You already have armor on')
            wait(0.02)
            break
        case 3:
            if eventPlayer.Gold >= StorePrices[3]:
                eventPlayer.Gold -= StorePrices[3]
                eventPlayer.setScore(eventPlayer.Gold)
                eventPlayer.LockPickSets += 1
                smallMessage(eventPlayer, 'You bought a lockpick set!')
            else:
                smallMessage(eventPlayer, 'You need {} more gold'.format(StorePrices[3] - eventPlayer.Gold))
            wait(0.02)
            break
        case 4:
            if eventPlayer.PickaxeLevel < 4:
                if eventPlayer.Gold >= eventPlayer.PickaxeLevel * StorePrices[4]:
                    eventPlayer.Gold -= eventPlayer.PickaxeLevel * StorePrices[4]
                    wait(0.02)
                    eventPlayer.PickaxeLevel += 1
                    wait(0.02)
                    smallMessage(eventPlayer, 'You have upgraded you pickaxe to level {}'.format(eventPlayer.PickaxeLevel))
                else:
                    smallMessage(eventPlayer, 'You need {} more gold'.format(eventPlayer.PickaxeLevel * StorePrices[4]))
            else:
                smallMessage(eventPlayer, 'Pickaxe is already fully upgraded')
            wait(0.02)
            break
        case 5:
            if eventPlayer.AsheUnlocked:
                if eventPlayer.getCurrentHero() == Hero.ASHE:
                    eventPlayer.startForcingHero(Hero.MCCREE)
                    eventPlayer.Armor = eventPlayer.getHealthOfType(Health.ARMOR)
                    eventPlayer.removeAllHealthPools()
                    eventPlayer.AsheShopString = 'Swap to Ashe'
                    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.Armor, false, true)
                else:
                    eventPlayer.startForcingHero(Hero.ASHE)
                    eventPlayer.Armor = eventPlayer.getHealthOfType(Health.ARMOR)
                    eventPlayer.removeAllHealthPools()
                    eventPlayer.AsheShopString = 'Swap to Cassidy'
                    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.Armor, false, true)
            else:
                if eventPlayer.Gold >= StorePrices[5]:
                    eventPlayer.Gold -= StorePrices[5]
                    eventPlayer.AsheUnlocked = true
                    smallMessage(eventPlayer, 'Congratulations you have unlocked Ashe! Interact again to switch heros.')
                    eventPlayer.AsheShopString = 'Swap to Ashe'
                else:
                    smallMessage(eventPlayer, 'You need {} more gold'.format(StorePrices[5] - eventPlayer.Gold))
            wait(0.02)
            break
    eventPlayer.setScore(eventPlayer.Gold)
    eventPlayer.DepositAmount = eventPlayer.Gold
    wait(0.02)

rule "Money Menu Controls":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.SafeZone == true
    @Condition eventPlayer.MenuState == MenuStates.SET_MONEY
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_1)

    # Primary = Up, Secondary = Down, Interact = Done, Ability1 = Max
    # MoneyArr = [0: Current, 1: Increment, 2: Min, 3: Max]
    if eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.MenuState = MenuStates.NONE
        return
    elif eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.MoneyArr[0] = eventPlayer.MoneyArr[3]
        return

    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.MoneyArr[0] + eventPlayer.MoneyArr[1] >= eventPlayer.MoneyArr[3]:
            eventPlayer.MoneyArr[0] = eventPlayer.MoneyArr[3]
            return
        else:
            eventPlayer.MoneyArr[0] += eventPlayer.MoneyArr[1]
            wait(0.3, Wait.ABORT_WHEN_FALSE)
    
    while eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.MoneyArr[0] - eventPlayer.MoneyArr[1] <= eventPlayer.MoneyArr[2]:
            eventPlayer.MoneyArr[0] = eventPlayer.MoneyArr[2]
            return
        else:
            eventPlayer.MoneyArr[0] -= eventPlayer.MoneyArr[1]
            wait(0.3, Wait.ABORT_WHEN_FALSE)
    return

rule "Safe Zone Help":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.SafeZone == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    switch(eventPlayer.Location):
        case Locations.BANK:
            createInWorldText(eventPlayer, 'Step on each circle to Deposit/Withdraw\nPress {} to increase/{} to decrease\n {} to set max Deposit/Withdraw amount\n{} to Deposit/Withdraw based on which circle you are on'.format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1), buttonString(Button.INTERACT)), worldVector(vect(0, 1.4, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
            waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2) == false, 9999)
            destroyInWorldText(getLastCreatedText())
            break
        case Locations.JAIL:
            createInWorldText(eventPlayer, 'Step on the circle to pay bail\nPress {} to increase/{} to decrease payment\n{} to max payment\n{} to reduce your sentence by 1s per gold you paid'.format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1), buttonString(Button.INTERACT)), worldVector(vect(0, 1.4, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
            waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2) == false, 9999)
            destroyInWorldText(getLastCreatedText())
            break
        case Locations.SALOON:
            createInWorldText(eventPlayer, 'Step on each circle to start betting\nPress {} to increase/{} to decrease bet\n {} set max bet\n {} to set your bet for the game'.format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1), buttonString(Button.INTERACT)), worldVector(vect(0, 1.4, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
            waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2) == false, 9999)
            destroyInWorldText(getLastCreatedText())
            break


def CalcPayout():
    eventPlayer.Payout = 0
    if eventPlayer.Game == Games.ROULETTE:
        eventPlayer.GuessDelta = abs(eventPlayer.ActualNumber - eventPlayer.PlayerGuess)
        if eventPlayer.GuessDelta == 0:
            bigMessage(getAllPlayers(), '{} was spot on in roulette! x 10 payout!'.format(eventPlayer))
            eventPlayer.Payout = eventPlayer.Bet * 11
        elif eventPlayer.GuessDelta <= 5:
            bigMessage(eventPlayer, 'You were {} off! x 4 payout!'.format(eventPlayer.GuessDelta))
            eventPlayer.Payout = eventPlayer.Bet * 5
        elif eventPlayer.GuessDelta <= 15:
            bigMessage(eventPlayer, 'You were {} off! x 2 payout!'.format(eventPlayer.GuessDelta))
            eventPlayer.Payout = eventPlayer.Bet * 3
        elif eventPlayer.GuessDelta <= 20:
            bigMessage(eventPlayer, 'You were {} off x 1 payout'.format(eventPlayer.GuessDelta))
            eventPlayer.Payout = eventPlayer.Bet 
        else:
            bigMessage(eventPlayer, 'You were {} off'.format(eventPlayer.GuessDelta))
            eventPlayer.Payout = 0
        return

    elif eventPlayer.Game == Games.HIGH_LOW:
        # Guess Delta = Game Streak
        switch floor(eventPlayer.GuessDelta/5):
            case 1:
                eventPlayer.Payout = eventPlayer.Bet * 3
                break
            case 2:
                eventPlayer.Payout = eventPlayer.Bet * 5
                break
            case 3:
                eventPlayer.Payout = eventPlayer.Bet * 11
                break
            case 4:
                eventPlayer.Payout = eventPlayer.Bet * 21
                break
            default:
                eventPlayer.Payout = 0
                break
        if eventPlayer.GuessDelta > 1:
            if eventPlayer.GuessDelta >= 20:
                bigMessage(getAllPlayers(), '{} had a crazy streak of {} in High-Low!'.format(eventPlayer, eventPlayer.GuessDelta))
                return
            else:
                bigMessage(eventPlayer, 'Congrats you had a streak of {}'.format(eventPlayer.GuessDelta))
        
        wait(0.02)
        eventPlayer.GuessDelta = 0
        return
    

def EndGamble():
    eventPlayer.Bet = 50
    eventPlayer.GambleState = GamblingStates.BETTING
    for eventPlayer.I in range(0, len(eventPlayer.GameEntities)):
        destroyProgressBarHud(eventPlayer.GameEntities[eventPlayer.I])
        destroyHudText(eventPlayer.GameEntities[eventPlayer.I])
        eventPlayer.TempArr.append(eventPlayer.I)
        
    eventPlayer.GameEntities = eventPlayer.GameEntities.exclude(eventPlayer.GameEntities[eventPlayer.I])
    eventPlayer.TempArr = []
    eventPlayer.setMoveSpeed(100)
    eventPlayer.stopFacing()
    eventPlayer.startForcingThrottle(0, 1, 0, 1, 0, 1)

    eventPlayer.MoneyArr = [50, 50, 50, floor(eventPlayer.Gold / 50) * 50]
    createInWorldText(eventPlayer, '{} to start game. Bet: {}'.format(buttonString(Button.INTERACT), eventPlayer.MoneyArr[0]), worldVector(vect(0, 1.5, 2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.GREEN, SpecVisibility.DEFAULT)
    eventPlayer.GameEntities.append(getLastCreatedText())
    eventPlayer.MenuState = MenuStates.SET_MONEY


def EnteringSafeZone():
    eventPlayer.I = SafeZones.index([i for i in SafeZones if distance(eventPlayer, i) < SafeZoneRadius[SafeZones.index(i)]])
    eventPlayer.Location = SafeZoneLocations[eventPlayer.I]
    smallMessage(eventPlayer, 'Entered a safe zone combat is disabled')
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 9999)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.SafeZone = true

def ExitingSafeZone():
    smallMessage(eventPlayer, 'Leaving safe zone combat reenabled')
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setUltEnabled(true)
    if eventPlayer.QuickFire > 0 or eventPlayer.getCurrentHero() == Hero.ASHE:
        eventPlayer.setSecondaryFireEnabled(true)
    if eventPlayer.Grenades > 0: 
        eventPlayer.setAbility2Enabled(true)
    eventPlayer.SafeZone = false
    eventPlayer.Location = Locations.OUTSIDE

def CalcMiningGold():

    switch(eventPlayer.PickaxeLevel):
        case 1:
            if random.randint(0, 10) == 10:
                eventPlayer.EarnedGold = random.randint(90, 100)
                smallMessage(eventPlayer, 'You found a ruby!')
            else:
                eventPlayer.EarnedGold = random.randint(10, 75)
            break
        case 2:
            if random.randint(0, 10) > 8:
                eventPlayer.EarnedGold = random.randint(120, 150)
                smallMessage(eventPlayer, 'You found a sapphire!')
            else:
                eventPlayer.EarnedGold = random.randint(20, 100)
            break
        case 3:
            if random.randint(0, 10) > 8:
                eventPlayer.EarnedGold = random.randint(175, 200)
                smallMessage(eventPlayer, 'You found an emerald!')
            else:
                eventPlayer.EarnedGold = random.randint(25, 150)
            break
        case 4: 
            if random.randint(0, 10) == 10:
                eventPlayer.EarnedGold = 1000
                smallMessage(eventPlayer, 'You found a diamond!')
            else:
                if random.randint(0, 10) > 8:
                    eventPlayer.EarnedGold = random.randint(300, 500)
                    smallMessage(eventPlayer, 'You found a {}'.format(random.choice(['ruby', 'sapphire', 'emerald'])))
                else:
                    eventPlayer.EarnedGold = random.randint(30, 250)
            break
    wait(0.02)


def CalcRobbery():
    if random.randint(0, 20) > 17 :
        smallMessage(eventPlayer, 'You found a grenade!')
        eventPlayer.Grenades += 1
        eventPlayer.setAbility2Enabled(true)

    eventPlayer.EarnedGold = random.randint(1000, 5000)
    wait(0.02)
    smallMessage(eventPlayer, 'You stole {} gold!'.format(eventPlayer.EarnedGold))
    eventPlayer.Gold += eventPlayer.EarnedGold
    eventPlayer.setScore(eventPlayer.Gold)
    wait(0.02)

def VaultDoorUnlocked():
    ImpassableDoors = ImpassableDoors.exclude(ImpassableDoors.last())
    destroyEffect(VaultDoorsEffect[NumUnlockedDoors - 1])
    if NumUnlockedDoors == 3:
        bigMessage(getAllPlayers(), 'All bank vault doors have been unlocked!')
    else:
        bigMessage(getAllPlayers(), 'Someone has unlocked bank vault door {}/3'.format(NumUnlockedDoors))
    
def ReLockVault():
    for I in range(len(VaultDoorsPos)):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.PURPLE, VaultDoorsPos[I] + vect(0, -22, 0), 3, EffectReeval.NONE)
        VaultDoorsEffect.append(getLastCreatedEntity())

    ImpassableDoors.append(sorted(VaultDoorsPos, lambda _, i: -i))
    NumUnlockedDoors = 0
    bigMessage(getAllPlayers(), 'Bank vault has been locked down.')

    
def UpdateDonationString():
    DonorTempArr = sorted(getAllPlayers(), lambda _, i: i.TownDonation).slice(0, 3)

    DonorString = ''
    for I in range(len(DonorTempArr) - 1, 0, -1):
        DonorString = '{}{}: {}\n'.format(DonorString, DonorTempArr[I], DonorTempArr[I].TownDonation)