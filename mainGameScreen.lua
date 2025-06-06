local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
require("helperFunctions")
local json = require("json")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--items to customize purchase
local backgroundImage="backgrounds/newMapCropped.png"
speed=0
local granualrMovement=0.5
local caravanMoveInMilliseconds=1000
local caravanMovePixels=1
local caravan=nil
local caravanCollider
local caravanGroup
-- Constants
local INITIAL_HP = 100        -- starting HP for each unicorn
local BASE_FATIGUE_RATE = 10  -- base rate at which unicorns get tired (HP lost per unit speed per second)
gamePaused=true
-- Global unicorn table
local unicorns = {}
gameover=false
gameLoopTimer=nil

if composer.getVariable( "speed" )==nil then
    composer.setVariable( "speed", 1)
end
composer.setVariable( "skipFrame", false)


local saveButton = display.newText("Save", 300, 50, native.systemFont, 20)


local loadButton = display.newText("Load", 400, 50, native.systemFont, 20)


local pauseButton = display.newText("[Unpause]", 500, 50, native.systemFont, 20)

function playTown()

    audio.stop( 1 )

    audio.reserveChannels( 1 )
    -- Reduce the overall volume of the channel
    audio.setVolume( 1, { channel=1 } )


    -- Load audio
    musicTrack = audio.loadStream( "audio/town.mp3",system.ResourceDirectory)


    -- Play the background music on channel 1, loop infinitely 
    audio.play( musicTrack, { channel=1, loops=-1 } )    
end


function saveCaravan()
    composer.setVariable("caravan", {x = caravanGroup.x, y = caravanGroup.y, rotation = caravan.rotation})    --**setGamePausedState(false)
    print("saved caravan at x:"..caravanGroup.x.." y:"..caravanGroup.y)
end

------------------------------------------------------------
-- Function: createUnicorns
-- Description:
--   Initializes the unicorns table based on the value of
--   composer.getVariable("NumberOfUnicorns").
------------------------------------------------------------
local lblLabel = display.newText("unset", 600, 50, native.systemFont, 20)
lblLabel.isVisible=false
local function createUnicorns()
    local numUnicorns = composer.getVariable("NumberOfUnicorns") or 1
    unicorns = {}  -- reset table

    for i = 1, numUnicorns do
        local unicorn = {
            id = i,
            hp = INITIAL_HP,
            alive = true
            -- You can add additional properties (like display objects) here.
        }
        table.insert(unicorns, unicorn)
    end
end

------------------------------------------------------------
-- Function: calculateFatigueRate
-- Description:
--   Dentermines how fast each unicorn gets tired based on the
--   current speed of the caravan and the number of unicorns.
--
-- Paramenters:
--   speed - the current speed of the caravan (e.g., pixels per second)
--
-- Returns:
--   fatigueRate - HP lost per second by each unicorn.
------------------------------------------------------------
local function calculateFatigueRate(speedL)--sppedL I am ignoring, I know why it starts out with a value like 200
    -- Get the number of unicorns. We assume the variable is kept updated.
    local numUnicorns = composer.getVariable("NumberOfUnicorns") or #unicorns
    -- More unicorns share the load, so each one gets tired less.
    local fatigueRate = (speed * BASE_FATIGUE_RATE) / numUnicorns
    --print("speed:"..speed.." fatigueRate:"..fatigueRate)
    return fatigueRate
end


------------------------------------------------------------
-- Function: killUnicorn
-- Description:
--   Called when a unicorn’s HP reaches 0. Handles cleanup such
--   as removing the unicorn from the display and updating the
--   total unicorn count.
--
-- Paramenters:
--   unicorn - the unicorn that has died.
------------------------------------------------------------
local function killUnicorn(unicorn)
    if composer.getVariable( "language" ) == "English" then
        message="your unicorns have died!"--.. composer.getVariable("NumberOfUnicorns") .. " remaining."zzz
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="ユニコーンが死んだ！"--.. composer.getVariable("NumberOfUnicorns") .. " remaining."zzz
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="tus unicornios han muerto!"--.. composer.getVariable("NumberOfUnicorns") .. " remaining."zzz
    end
    pauseAndShowQuickMessage(message)

    
    -- Optionally, remove the unicorn’s display object here.
    -- e.g., if unicorn.displayObject then unicorn.displayObject:removeSelf() end

    -- Update the total number of unicorns.
    local currentCount = composer.getVariable("NumberOfUnicorns") or #unicorns
    composer.setVariable("NumberOfUnicorns", currentCount - 1)
end

------------------------------------------------------------
-- Function: updateUnicornHP
-- Description:
--   Updates the HP for a single unicorn based on the elapsed
--   time (dt) and the current speed.
--
-- Paramenters:
--   unicorn - the unicorn table entry.
--   dt      - delta time (in seconds) since the last update.
--   speed   - the current speed of the caravan.
------------------------------------------------------------
local restRestoreRate= 0.1
local function updateUnicornHP(unicorn, dt, speedL)
    if unicorn.alive then
        local fatigueRate = calculateFatigueRate(speed)
        unicorn.hp = unicorn.hp - fatigueRate * dt
        --print("unicorn:" .. unicorn.id.." HP:".. unicorn.hp)
        if unicorn.hp <= 0 then
            unicorn.hp = 0
            unicorn.alive = false
            killUnicorn(unicorn)
        end
        if speed == 0 and unicorn.hp <= INITIAL_HP then
            unicorn.hp=unicorn.hp+restRestoreRate
        end
    end
end

------------------------------------------------------------
-- Function: updateAllUnicorns
-- Description:
--   Should be called every frame (or at fixed intervals) to
--   update each unicorn's HP.
--
-- Paramenters:
--   dt    - delta time (in seconds) since the last update.
--   speed - the current speed of the caravan.
------------------------------------------------------------
local function updateAllUnicorns(dt, speed)
    for i, unicorn in ipairs(unicorns) do
        updateUnicornHP(unicorn, dt, speed)
    end
end

------------------------------------------------------------
-- Example usage in your game loop:
------------------------------------------------------------


-- Function to handle the curse event
function curseEvent()
    local message
    girlNumber=math.random(1,5)
    local characters = composer.getVariable("characters")
    local char = characters[girlNumber]
    if char.isCursed then
        --already cursed
        return
    end
    char.isCursed=true
    if composer.getVariable( "language" ) == "English" then
        message = char.name .. " has been cursed!"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = char.name .. "が呪われた！"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = char.name .. " ha sido maldicha!"
    end
    pauseAndShowQuickMessage(message)
end

function  unPauseGame()
    disableContinueButton()
    hideTextArea()
    setGamePausedState(false)
    if speed==0 then
        showRestingMenu()
    end
end
function pauseAndShowQuickMessage(message)
    RESETQUE()
    setGamePausedState(true)
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    SLOWPRINT(50,message,unPauseGame)--emptyFunction does not fix the problem
    --enableContinueButton()
end
function pauseAndShowQuickMessageThenCallFunction(message,functionL)
    RESETQUE()
    setGamePausedState(true)
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    --SLOWPRINT(50,message,functionL)
    
    SLOWPRINT(50,message,functionL)
    --enableContinueButton()
end
function pauseAndShowQuickMessageFast(message)
    RESETQUE()
    setGamePausedState(true)
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    PRINTFAST(message,100,100)
end

-- Function to handle the robbery event
function robberyEvent()
    local items = {"gold", "HPpotions", "MPpotions", "food"}
    local itemToSteal = items[math.random(1, #items)]
    if itemToSteal == "gold" then
        local gold = composer.getVariable("gold")
        if gold > 0 then
            local amount = math.random(1, math.round(gold/4))
            composer.setVariable("gold", gold - amount)
            local message 
            if composer.getVariable( "language" ) == "English" then
                message= "You have been robbed of " .. amount .. " grams gold!"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message= amount .. "グラムの金が盗まれた！"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message= "Te han robado " .. amount .. " gramos de oro!"
            end            
            pauseAndShowQuickMessage(message)
        end
    elseif itemToSteal == "HPpotions" then
        local HPpotions = composer.getVariable("HPpotions")
        if HPpotions > 0 then
            local amount = math.random(1, math.round(HPpotions/4))
            composer.setVariable("HPpotions", HPpotions - amount)
            local message
            if composer.getVariable( "language" ) == "English" then
                message = "You have been robbed of " .. amount .. " HP potions!"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = amount .. "個のHPポーションが盗まれた！"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = "Te han robado " .. amount .. " pociones de HP!"
            end            
            pauseAndShowQuickMessage(message)
        end
    elseif itemToSteal == "MPpotions" then
        local MPpotions = composer.getVariable("MPpotions")
        if MPpotions > 0 then
            local amount = math.random(1, math.round(MPpotions/4))
            composer.setVariable("MPpotions", MPpotions - amount)
            local message
            if composer.getVariable( "language" ) == "English" then
                message = "You have been robbed of " .. amount .. " MP potions!"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = amount .. "個のMPポーションが盗まれた！"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = "Te han robado " .. amount .. " pociones de MP!"
            end
            pauseAndShowQuickMessage(message)
        end
    elseif itemToSteal == "food" then
        local KGofFood = composer.getVariable("KGofFood")
        if KGofFood > 0 then
            local amount = math.random(1, math.round(KGofFood/4))
            composer.setVariable("KGofFood", KGofFood - amount)
            local message
            if composer.getVariable( "language" ) == "English" then
                message = "You have been robbed of " .. amount .. " KG of food!"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = amount .. "キロの食料が盗まれた！"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = "Te han robado " .. amount .. " KG de comida!"
            end
            pauseAndShowQuickMessage(message)
        end
    end
    -- Optionally, display a message to the player using showTextArea()
end

function testEvent()
    --print("test event called")
    --gamePaused=true
end

function detectCollision3(movingObject, sprite)
    -- Get absolute center positions in content coordinates
    local x1, y1 = movingObject:localToContent(0, 0)
    local x2, y2 = sprite:localToContent(0, 0)
    
    -- Calculate bounding box edges
    local left1 = x1 - movingObject.width / 2
    local right1 = x1 + movingObject.width / 2
    local top1 = y1 - movingObject.height / 2
    local bottom1 = y1 + movingObject.height / 2
    
    local left2 = x2 - sprite.width / 2
    local right2 = x2 + sprite.width / 2
    local top2 = y2 - sprite.height / 2
    local bottom2 = y2 + sprite.height / 2
    
    -- Check for overlap
    if right1 > left2 and left1 < right2 and bottom1 > top2 and top1 < bottom2 then
        return true
    else
        return false
    end
end

function detectCollision4(movingObject,collider, sprite)
    -- Get absolute center positions in content coordinates
    local x1, y1 = movingObject:localToContent(0, 0)
    local x2, y2 = sprite:localToContent(0, 0)
    
    -- Calculate bounding box edges
    local left1 = x1 - collider.width / 2
    local right1 = x1 + collider.width / 2
    local top1 = y1 - collider.height / 2
    local bottom1 = y1 + collider.height / 2
    
    local left2 = x2 - sprite.width / 2
    local right2 = x2 + sprite.width / 2
    local top2 = y2 - sprite.height / 2
    local bottom2 = y2 + sprite.height / 2
    
    -- Check for overlap
    if right1 > left2 and left1 < right2 and bottom1 > top2 and top1 < bottom2 then
        return true
    else
        return false
    end
end

local onRoad=false
local onRoadSatusChanged="onRoad"
local tblBoxes = {}

-- Function to extract serializable data from tblBoxes
local function getSerializableBoxes()
    local serializableBoxes = {}
    for _, box in ipairs(tblBoxes) do
        table.insert(serializableBoxes, {color=box.color, x = box.x, y = box.y, size = box.size, label = box.label})
    end
    return serializableBoxes
end
local daysPassed=0
local townEntered=false
function enterTown(returnMessage)
    if townEntered then
        return
    end
    playTown()
    townEntered=true
    setGamePausedState(true)
    --composer.setVariable("gamePaused", true)
    hideEverything()
    hideTextArea()
    disableContinueButton()
    composer.setVariable(returnMessage, true)
    composer.setVariable("daysPassed", daysPassed)
    composer.setVariable("arc.x", arc.x)
    composer.setVariable("unicorns", unicorns)
    composer.setVariable("caravan", {x = caravanGroup.x, y = caravanGroup.y, rotation = caravan.rotation})
    composer.setVariable("tblBoxesData", getSerializableBoxes())  -- Store data, not objects
    composer.removeScene(composer.getSceneName("current"))
    --composer.gotoScene("unicornStableGeneral")
    composer.gotoScene("shopMenu")
end
local landmarkShown=false
function enterLandmark(returnMessage)
    if landmarkShown then
       return 
    end
    landmarkShown=true
    setGamePausedState(true)
    hideEverything()
    hideTextArea()
    composer.setVariable(returnMessage, true)
    composer.setVariable("daysPassed", daysPassed)
    composer.setVariable("arc.x", arc.x)
    composer.setVariable("unicorns", unicorns)
    
    composer.setVariable("caravan", {x = caravanGroup.x, y = caravanGroup.y, rotation = caravan.rotation})
    print("stored caravan coordinates caravanGroup.x"..caravanGroup.x)

    composer.setVariable("tblBoxesData", getSerializableBoxes())  -- Store data, not objects
    composer.removeScene(composer.getSceneName("current"))
    composer.gotoScene("showLandmark")
end

function fallFromCliffGameOver()
    --composer.removeScene(composer.getSceneName("current"))
    local message
    if composer.getVariable( "language" ) == "English" then
        message="Your caravan fell from a cliff and you died.^^^        GAME OVER"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="崖から落ちて死んだ。^^^        GAME OVER"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="te has caido en un precipicio y has muero.^^^        GAME OVER"
    end
    pauseAndShowQuickMessageThenCallFunction(message, gameOver)
    return
end

function gotoMainGameEnding()
    composer.setVariable("backgroundImage","backgrounds/crown-of-eternity.png")
    enterLandmark("enteredMainGameEnding")
end

function gotoAlternateGameEnding()
    composer.setVariable("backgroundImage","backgrounds/altEnding.png")
    enterLandmark("enteredAlternateGameEnding")
end

function gotoMoutein1()
    composer.setVariable("backgroundImage","backgrounds/Maelstrom-Peak.png")
    enterLandmark("enteredMountain1")
end

function gotoMoutein2()
    composer.setVariable("backgroundImage","backgrounds/Evermist-Hills.png")
    enterLandmark("enteredMountain2")
end

function gotoMoutein3()
    composer.setVariable("backgroundImage","backgrounds/Enchanted-Spires.png")
    enterLandmark("enteredMountain3")
end

function gotoFrozenTundraGameOver()
    composer.setVariable("backgroundImage","backgrounds/frozen-tundra.png")
    enterLandmark("enteredFrozenTundra")
end

function attackedByAngryGoblynEvent()
    print("angry goblin attack event")
    print("attackedByAngryGoblynEvent called, gamePaused is " .. tostring(gamePaused))
    randomNumber= math.random(1,3)
    if randomNumber==1 then
        composer.setVariable("backgroundImage","backgrounds/Angry-Goblin1.png")
    elseif randomNumber==2 then
        composer.setVariable("backgroundImage","backgrounds/Angry-Goblin2.png")
    elseif randomNumber==3 then
        composer.setVariable("backgroundImage","backgrounds/Angry-Goblin3.png")
    end
    enterLandmark("enteredattackedByAngryGoblynEvent")
end
function gotoMistralsEnd()
    enterTown("enteredMistalsEnd")
end


function gotoElvenTown1()
    enterTown("enteredElvenTown1")
end

function gotoElvenTown2()
    enterTown("enteredElvenTown2")
end


function gotoGoblinTown()
    enterTown("enteredGoblinTown")
end

function gotoElvenTown3()
    enterTown("enteredElvenTown3")
end



local lblDaysPassed = display.newText( tostring(daysPassed)..translate["Days Passed"], 200, 50, "fonts/ume-tgc5.ttf", 50 )

function dayPassed()
    if gamePaused then
        return
    end
    daysPassed=daysPassed+1
    composer.setVariable("KGofFood", composer.getVariable("KGofFood")-3)
    if composer.getVariable("KGofFood")<=2 then
        local message
        if composer.getVariable( "language" ) == "English" then
            message="You have starved to death.^^^        GAME OVER"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message="餓死した。^^^        GAME OVER"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message="Has muerto de hambre.^^^        GAME OVER"
        end
        hideTextArea()
        hideEverything()
        pauseAndShowQuickMessageThenCallFunction(message,gameOver)
        return true
    end
    lblDaysPassed.text=tostring(daysPassed)..translate["Days Passed"]
end

-- Helper function to get the next step
function transitionCompleted()
    if composer.getVariable("gameStarted") then
        setGamePausedState(false)
        saveCaravan()
    end
end
function emptyFunction()

end
function updateCaravanCoordinates(obj)
    caravanGroup.x=obj.x
    caravanGroup.x=obj.x
end
function teleportSuccess(exitBoxName)
    local box = findBox(exitBoxName)
    if box == nil then
        print("box is nill")
        -- Optionally set a default safe position or show an error
        caravanGroup.x = 580 -- Example default within 1500x800
        caravanGroup.y = 400
        pauseAndShowQuickMessage("Teleport failed: destination not found!")
    else
        setGamePausedState(true)
        transition.to( caravanGroup, { time=1500*composer.getVariable( "speed" ), x=box.x, y=box.y, onComplete=transitionCompleted } )
        print("Teleported to box.x:" .. box.x .. ", box.y:" .. box.y)
        --this was causing the persistent continue button, I would like to have this message, but I dont know how to do it safely
        --this did not work either pauseAndShowQuickMessageThenCallFunction("You teleported to the other side of the river and entered an Elven village",emptyFunctionForWaiting)
        --bug no continuebutton after going across hte river
        if exitBoxName=="river2_exit" then --(quick hack worked)trying quick fix to fix it for river2
            hideTextArea()
        end
        if exitBoxName=="elf_t1" then --(quick hack worked)trying quick fix to fix it for river2
            --hideTextArea()
            --setGamePausedState(true)
        end

    end
end
function teleportTo(teleportExit)
    local box = findBox(teleportExit)
    if box == nil then
        print("box is nill")
        -- Optionally set a default safe position or show an error
        caravanGroup.x = 580 -- Example default within 1500x800
        caravanGroup.y = 400
        pauseAndShowQuickMessage("Teleport failed: destination not found!")
    else
        setGamePausedState(true)
        transition.to( caravanGroup, { time=1500*composer.getVariable( "speed" ), x=box.x, y=box.y, onComplete=transitionCompleted } )
        updateCaravanCoordinates(box)
        print("Teleported to box.x:" .. box.x .. ", box.y:" .. box.y)
        --this was causing the persistent continue button, I would like to have this message, but I dont know how to do it safely
        --this did not work either pauseAndShowQuickMessageThenCallFunction("You teleported to the other side of the river and entered an Elven village",emptyFunctionForWaiting)
    end
    
end


local function teleportFail(char)
    char.isAlive = false
    local message
    if composer.getVariable("language") == "English" then
        message = char.name .. " has died in the attempt to cast the spell"
    elseif composer.getVariable("language") == "Japanese" then
        message = char.name .. "の魔法が失敗して、彼女が死んだ！"
    elseif composer.getVariable("language") == "Spanish" then
        message = "La magia de " ..char.name .. " fallo, y ella murio!"
    end
    pauseAndShowQuickMessage(message)
end

local function bruteForceSuccess(exitBoxName)
    local message
    if composer.getVariable("language") == "English" then
        message = "You successfully went thru the river."
    elseif composer.getVariable("language") == "Japanese" then
        message = "川を渡るの成功した。"
    elseif composer.getVariable("language") == "Spanish" then
        message = "cruzaron el rio."
    end
    pauseAndShowQuickMessage(message)
    local box=findBox(exitBoxName)
    caravanGroup.x=box.x
    caravanGroup.y=box.y
end

local function bruteForceFail(char)
    char.isAlive = false
    pauseAndShowQuickMessage("The magical spell backfires and " .. char.name .. " dies!")
end

local function drownGameOver()
    local message
    if composer.getVariable("language") == "English" then
        message = "You drowned in the attempt.^^^        GAME OVER"
    elseif composer.getVariable("language") == "Japanese" then
        message = "溺れて死んだ。^^^        GAME OVER"
    elseif composer.getVariable("language") == "Spanish" then
        message = "Te has ahogado tratando de crusar el rio .^^^        GAME OVER"
    end
    hideTextArea()
    hideEverything()
    pauseAndShowQuickMessageThenCallFunction(message, gameOver)
end
local function drownInTheOcean()--seems not using char in this fucntion,m maybe clean up later
    local message
    if composer.getVariable("language") == "English" then
        message = "You have drowned in hte ocean.^^^        GAME OVER"
    elseif composer.getVariable("language") == "Japanese" then
        message = "海で溺れた。^^^        GAME OVER"
    elseif composer.getVariable("language") == "Spanish" then
        message = "Te haz ahogado en el mar.^^^        GAME OVER"
    end
    pauseAndShowQuickMessageThenCallFunction(message,gameOver)
end

local function tryBruteForce(char)--seems not using char in this fucntion,m maybe clean up later
    local message
    if composer.getVariable("language") == "English" then
        message = "Attempting to brute force your way thru the river."
    elseif composer.getVariable("language") == "Japanese" then
        message = "無理やり川を渡ろうとしてる。"
    elseif composer.getVariable("language") == "Spanish" then
        message = "Tratando de cruzar el rio a la fuerza."
    end
    pauseAndShowQuickMessageThenCallFunction(
        message,
        function()
            local dice = math.random(1, 100)
            if dice < 50 then
                bruteForceSuccess()
            else
                drownGameOver()
            end
        end
    )
end

local function tryBruteForceLowMP(char)
    pauseAndShowQuickMessageThenCallFunction(
        char.name .. " doesn't have enough MP to cast the spell. Attempting to cross using brute force...",
        function()
            local dice = math.random(1, 100)
            if dice < 20 then
                bruteForceSuccess()
            else
                bruteForceFail(char)
            end
        end
    )
end

local function tryTeleport(char,exitBoxName)
    local message
    if composer.getVariable( "language" ) == "English" then
        message = "Trying to cross the river, " .. char.name .. " casts her teleport spell! it costs her 50MP"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = "川を渡ろうとしてる、" .. char.name .. "が瞬間移動の呪文を唱える！彼女の５０MPが掛かる。"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = "Tratando de cruzar el rio, " .. char.name .. " lanza un hechizo de teletransporte! le cuesta 50MP"
    end
   pauseAndShowQuickMessageThenCallFunction(
        message,
        function()
            char.MP = char.MP - 50
            local magic = math.random(1, 100)
            if magic < 100 then--chnage back to 50 later
                teleportSuccess(exitBoxName)
            else
                teleportFail(char)
            end
        end
    )
end

function crossRiverAlgorythm(exitBoxName)
    local characters = composer.getVariable("characters")
    local randomMagicChar = characters[3]

    if randomMagicChar.isAlive then
        if randomMagicChar.MP >= 50 then
            tryTeleport(randomMagicChar,exitBoxName)
        else
            tryBruteForceLowMP(randomMagicChar,exitBoxName)
        end
    else
        tryBruteForce(randomMagicChar,exitBoxName)
    end
end

function getStuckInRut()
    dayPassed()
    local message
    if composer.getVariable( "language" ) == "English" then
        message = "The caravan got stuck in a rut, it took a day to take it out!"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = "穴に馬車がハマった、出すの一日掛かった！"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = "La caravana se atoro en un hoyo, tardaste un dia en sacarla!"
    end
    pauseAndShowQuickMessage(message)
end
function afterTreasuChest1()
    composer.setVariable( "gold", composer.getVariable( "gold" ) + 100000 )
    teleportTo("tele1_exit")
    speed=0
    hideTextArea()--this hideds the text rom before the teleport
end
local dayLimit=15--one more than the limit, on the 15th day the tunra will be frozen
local landmarkShown = false
function randomEvents()
    local randomNumber = math.random(1, 10000)
    if randomNumber < 50 then
        setGamePausedState(true)
        curseEvent()
    elseif randomNumber < 100 then
        setGamePausedState(true)
        robberyEvent()
    elseif randomNumber < 200 then
        if not onRoad then
            setGamePausedState(true)
            getStuckInRut() 
        end
    elseif randomNumber < 210  then
        setGamePausedState(true)
        attackedByAngryGoblynEvent()
    end
end
function gameloop()
	if gamePaused or gameover then
		return
	end
    if not caravan then -- start doing this once hte caravan appears on screen
        print("caravan does not extist")
    else
        if gamePaused==nil then
            setGamePausedState(true)
            return
        end
        print("gamePaused"..tostring(gamePaused))
        -- Random event triggers
        if composer.getVariable("lblContinue").isVisible==false then --this should prevent the bug where events happen when another screen has a continue button
            randomEvents()
        end

        --the following is true when comming back from another scene it seems -the return solves it
        if caravan.rotation==nil then
            caravan.rotation=90
            setRotationOfCaravan(caravan.rotation)
            return
        end
        --restore saved caravan
        local savedCaravan = composer.getVariable("caravan")
        if savedCaravan then
            print("loading savedCaravan.x"..savedCaravan.x)
            caravanGroup.x = savedCaravan.x
            caravanGroup.y = savedCaravan.y
            caravan.rotation = savedCaravan.rotation
            setRotationOfCaravan(caravan.rotation)
        end
        --move caravan
        print("caravan.rotation:"..caravan.rotation)
        local angle=caravan.rotation
        local angle_radians=math.rad(angle + 90 + 180)--(bugfix:I added 180 degrees cause the caravan was going backwords)converts degrees to radians
        local distance=caravanMovePixels*speed
        print("caravan exists and caravanMovePixels:"..caravanMovePixels.." speed:"..speed)
        local newx=caravanGroup.x+distance*math.cos(angle_radians)
        local newy=caravanGroup.y+distance*math.sin(angle_radians)
        caravanGroup.x=newx;
        caravanGroup.y=newy;
        --save new caravan position
        composer.setVariable("caravan", {x = caravanGroup.x, y = caravanGroup.y, rotation = caravan.rotation})    --**setGamePausedState(false)
        onRoad=false
        for index, box in ipairs(tblBoxes) do
            --detect collision with map objects
            if box.color=="colorWhite" then
                if box.label=="mist_end" then
                    if detectCollision3(caravanCollider, box) then
                        pauseAndShowQuickMessageThenCallFunction("Mistrals End",gotoMistralsEnd)
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="elf_t1" then
                    if detectCollision4(caravanGroup,caravanCollider, box) then
                        print("Collision with elf_t1 detected!")
                        print("Caravan position: x=", caravanGroup.x, "y=", caravanGroup.y)
                        print("elf_t1 position: x=", box.x, "y=", box.y)                        pauseAndShowQuickMessageThenCallFunction("Elven Town.^",gotoElvenTown1)
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="northern_tundra" then
                    if detectCollision4(caravanGroup,caravanCollider, box) then
                        onRoad = true
                        if daysPassed>=dayLimit then
                            gotoFrozenTundraGameOver()
                            return  -- No need to check further if we found a collision
                        end
                        return
                    end
                elseif box.label=="elf_t2" then
                    if detectCollision4(caravanGroup,caravanCollider, box) then
                        pauseAndShowQuickMessageThenCallFunction("Elven Town.^",gotoElvenTown2)
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="gob_t" then
                    if detectCollision4(caravanGroup,caravanCollider, box) then
                        pauseAndShowQuickMessageThenCallFunction("Goblin Town.^",gotoGoblinTown)
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="elf_t3" then
                    if detectCollision4(caravanGroup,caravanCollider, box) then
                        pauseAndShowQuickMessageThenCallFunction("Elven Town.^",gotoElvenTown3)
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="v_of_e" then
                    if detectCollision4(caravanGroup,caravanCollider, box) and not landmarkShown then
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "Reached main game ending!^"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "メーンエンディングに着いた！^"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Alcanzaron el final principal del juego!^"
                        end
                        pauseAndShowQuickMessageThenCallFunction(message,gotoMainGameEnding)
                        landmarkShown = true
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="alt_end" then
                    if detectCollision4(caravanGroup,caravanCollider, box) and not landmarkShown then
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "Reached alternate game ending!^"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "第二目のエンディングに着いた！^"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Alcanzaron el final alternativo del juego!^"
                        end
                        pauseAndShowQuickMessageThenCallFunction(message,gotoAlternateGameEnding)
                        landmarkShown = true
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="mountain1" then
                    if detectCollision4(caravanGroup,caravanCollider, box) and not landmarkShown then
                        speed=0
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "Landmark Reached!^"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "ランドマークに着いた！^"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Alcanzaron un lugar de importancia!^"
                        end
                        pauseAndShowQuickMessageThenCallFunction(message,gotoMoutein1)
                        landmarkShown = true
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="mountain2" then
                    if detectCollision4(caravanGroup,caravanCollider, box) and not landmarkShown then
                        speed=0
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "Landmark Reached!^"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "ランドマークに着いた！^"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Alcanzaron un lugar de importancia!^"
                        end
                        pauseAndShowQuickMessageThenCallFunction(message,gotoMoutein2)
                        landmarkShown = true
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="mountain3" then
                    if detectCollision4(caravanGroup,caravanCollider, box) and not landmarkShown then
                        speed=0
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "Landmark Reached!^"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "ランドマークに着いた！^"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Alcanzaron un lugar de importancia!^"
                        end
                        pauseAndShowQuickMessageThenCallFunction(message,gotoMoutein3)
                        landmarkShown = true
                        return  -- No need to check further if we found a collision
                    end
                elseif box.label=="tele1" then
                    if detectCollision3(caravanCollider, box) then
                        speed=0
                        teleportTo("tele1_exit")
                        return
                    end
                elseif box.label=="treasure1" then
                    if detectCollision3(caravanCollider, box) then
                        local message
                        if composer.getVariable( "language" ) == "English" then
                            message = "You found a tresure chest with 100000 grams of gold!"
                        elseif composer.getVariable( "language" ) == "Japanese" then
                            message = "宝物を見つけた！金100000グラムが手に入った！"
                        elseif composer.getVariable( "language" ) == "Spanish" then
                            message = "Haz encontrado un tesoro con 100000 gramos de oro!"
                        end        
                        pauseAndShowQuickMessageThenCallFunction(message, afterTreasuChest1)
                        return
                    end
                end
            elseif box.color=="colorGreen" then
                if detectCollision3(caravanCollider, box) then
                    fallFromCliffGameOver()
                    return
                end
            elseif box.color=="colorRed" or box.color=="colorYellow" then
                if detectCollision3(caravanCollider, box) then
                    onRoad = true
                    return  -- No need to check further if we found a collision
                end
            elseif box.color=="colorBlue" then
                if box.label=="river1" then
                    if detectCollision3(caravanCollider, box) then
                        speed=0
                        crossRiverAlgorythm("elf_t1")
                        return
                    end
                elseif box.label=="river2" then
                    if detectCollision3(caravanCollider, box) then
                        speed=0
                        crossRiverAlgorythm("river2_exit")
                        return
                    end    
                elseif box.label=="sea" then
                    if detectCollision3(caravanCollider, box) then
                        speed=0
                        drownInTheOcean()
                        return
                    end
                end
            end
        end
        if not onRoad and onRoadSatusChanged=="onRoad" then
            print("offroad now")
            if composer.getVariable( "language" ) == "English" then
                message = "Caravan is off-road now!"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = "馬車が道を外れた！"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = "La caravana se ha salido del camino!"
            end
            --this was a nuisense　pauseAndShowQuickMessage(message)   
            onRoadSatusChanged="offRoad"
            onRoad=false
            --**add event for unicorns dying faster from being offroad
        elseif onRoad and onRoadSatusChanged=="offRoad" then
            print("onroad now")
            local message
            if composer.getVariable( "language" ) == "English" then
                message = "Caravan is on-road now."
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = "馬車が道に戻った."
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = "La caravana ha regrresado al camino."
            end
            --this was a nuisense　pauseAndShowQuickMessage(message)
            onRoadSatusChanged="onRoad"
            onRoad=true
        end
    end
    -- Handle HP draining for cursed characters
    local characters = composer.getVariable("characters")
    for i = #characters, 1, -1 do
        local char = characters[i]
        if char.isAlive then
            if char.isCursed then
                char.HP = char.HP - 1 -- Drain 1 HP per second
                if char.HP <= 0 then
                    local message
                    if composer.getVariable( "language" ) == "English" then
                        message = char.name .. " has died from the curse!"
                    elseif composer.getVariable( "language" ) == "Japanese" then
                        message = char.name .. "が呪いによって死んだ！"
                    elseif composer.getVariable( "language" ) == "Spanish" then
                        message = char.name .. " ha muerto de la maldición!"
                    end
                    pauseAndShowQuickMessage(message)        
                    --table.remove(characters, i)
                    char.isAlive=false
                    -- Optionally, handle game over if MC dies
                end
            end
        end
    end
end



language=composer.getVariable( "language" )
translate=i18n_setlang(language)
--translate["Choose Category"]

function gameOver()
    RESETQUE()
    setGamePausedState(true)
    gameover=true
    hideEverything()
    hideRestingMenu()
    hideTextArea()
    	--stop music
	audio.stop( 1 )

	--audio.reserveChannels( 1 )
	-- Reduce the overall volume of the channel
	--audio.setVolume( 1, { channel=1 } )


	-- Load audio
	--musicTrack = audio.loadStream( "audio/OtherworldFrontierOpening.mp3",system.ResourceDirectory)


	-- Play the background music on channel 1, loop infinitely 
	--audio.play( musicTrack, { channel=1, loops=-1 } )

    composer.removeScene( composer.getSceneName("current") )
    composer.gotoScene("GameOver")
end

local dayTimer= timer.performWithDelay( 60000*composer.getVariable( "speed" ), dayPassed, 0 ) -- day takes one minute

local lastTime = system.getTimer() -- Get the current time in milliseconds

-- In your game loop or an "enterFrame" listener:
local function updateFrame(event)
    --skip a frame every other frame in slow mode
    if composer.getVariable( "speed" ) == 2 then
        if composer.getVariable( "skipFrame")==false then
            composer.setVariable( "skipFrame", true)
            return
        else
            composer.setVariable( "skipFrame", false)
        end
    end
    if gamePaused then
		return
	end
    if composer.getVariable("NumberOfUnicorns") <= 0 then
        speed=0
    end
    local currentTime = system.getTimer() -- Current time
    local dt = (currentTime - lastTime) / 1000 -- Convert to seconds
    lastTime = currentTime -- Update lastTime for the next frame

    --ah, this was the spped chatgpt set...local currentSpeed = 200 -- Replace with your caravan's actual speed logic
    updateAllUnicorns(dt, currentSpeed)
end

-- Start the game loop listener.
Runtime:addEventListener("enterFrame", updateFrame)
--Runtime:removeEventListener( "enterFrame" )	

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    if composer.getVariable("inputBuffer") ==nil then
        composer.setVariable("inputBuffer", "input unset")
    end
    -- Initialize the characters table using names from Composer variables, and default HP, MP
    local characters = {
        {name = composer.getVariable("MCname") or "Default MC", isAlive=true, HP = 100, maxHP = 100, MP = 100, maxMP = 100, isCursed = false},
        {name = composer.getVariable("adventurer1") or "Default Adv1", isAlive=true, HP = 100, maxHP = 100, MP = 100, maxMP = 100, isCursed = false},
        {name = composer.getVariable("adventurer2") or "Default Adv2", isAlive=true, HP = 100, maxHP = 100, MP = 100, maxMP = 100, isCursed = false},
        {name = composer.getVariable("adventurer3") or "Default Adv3", isAlive=true, HP = 100, maxHP = 100, MP = 100, maxMP = 100, isCursed = false},
        {name = composer.getVariable("adventurer4") or "Default Adv4", isAlive=true, HP = 100, maxHP = 100, MP = 100, maxMP = 100, isCursed = false}
    }
    --change the following to a game init variable later since this is nessesary for comming back from another scene
    if not composer.getVariable("wentHunting") then
        composer.setVariable("characters", characters)
    end
end

-- Handler that gets notified when the alert closes
local function alertBoxYesClickedComplete()
    --continue on journey
    composer.setVariable("inputBuffer", "input unset")
    local options =
    {
        effect = "fade",
        time = 400,
        params = {
        }
    }
    --composer.setVariable( composerVariable, numberOfItemsPurchased)
    composer.setVariable( "gold", composer.getVariable("gold")-GoldUsed)
    composer.removeScene( composer.getSceneName("current") )
    print("going to scene:"..nextScreenName)
    composer.gotoScene( nextScreenName, options )
end
local function alertBoxNoClickedCompleteEN()
    --enableContinueButton()
    gameStartEN()
end
local function alertBoxNoClickedCompleteJP()
    --enableContinueButton()
    gameStartJP()
end
local function alertBoxNoClickedCompleteES()
    --enableContinueButton()
    gameStartES()
end
function togglePause()
    oppositeValue=not composer.getVariable("gamePaused")
    setGamePausedState(oppositeValue)
end
pauseButton:addEventListener("tap", togglePause)

function setGamePausedState(value)
    gamePaused = value
    composer.setVariable("gamePaused", value)
    if composer.getVariable("gamePaused") then
        pauseButton.text="[Unpause]"
    else
        pauseButton.text="[Pause]"
    end
    --print("gamePaused set to " .. tostring(value) .. " at " .. debug.traceback())
end
setGamePausedState(true)

function showControls()
    hideTextArea()
    disableContinueButton()
    setGamePausedState(false)
    composer.setVariable("gameStarted",true)
end
gameLoopTimer = timer.performWithDelay( caravanMoveInMilliseconds*composer.getVariable( "speed" ), gameloop, 0 )
function gameStartEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^Stear the caravan carefully, ^")
    QUESLOWPRINT("Follow the red line.^")
    QUESLOWPRINT("Set the unicorn running speed.^")
    QUESLOWPRINT("Come to a complete stop ^to restore HP of the unicorns.^")
    QUESLOWPRINT("If you run out of food, go hunting^")
    QUESLOWPRINT("If you run out of unicorns, you can ^")
    QUESLOWPRINT("tame a wild unicorn.^")
    QUESLOWPRINT("Use potions wisely.^")
    QUESLOWPRINT("You must reach \"The valley of ^")
    QUESLOWPRINT("enternity\" before the \"Northern ^")
    QUESLOWPRINT("Tundra\" freezes over....")
    SLOWPRINT(50,"",showControls)
end

function gameStartJP()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^気をつけて馬車をひいて、 ^")
    QUESLOWPRINT("赤い線に添って移動して。^")
    QUESLOWPRINT("ユニコーンの走る速度をセットして。^")
    QUESLOWPRINT("ユニコーンのHPを回復するため、^")
    QUESLOWPRINT("こまめに馬車を完全に止めて。^")
    QUESLOWPRINT("食べ物が切れたら、狩猟して。^")
    QUESLOWPRINT("ユニコーンが死んだら、^")
    QUESLOWPRINT("野生のユニコーンを飼いならして。^")
    QUESLOWPRINT("ポーションを上手く使って。^")
    QUESLOWPRINT("「北のツンドラ」が凍る前に、^")
    QUESLOWPRINT("\"The valley of enternity\"に^")
    QUESLOWPRINT("着かなきゃいけない。。。。")
    SLOWPRINT(50,"",showControls)
end

function gameStartES()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^Maneja el timon de la caravans con^")
    QUESLOWPRINT("cuidado, Sigue la linea roja.^")
    QUESLOWPRINT("Tu decides la ^velocidad de los unicornios^")
    QUESLOWPRINT("Descansa para reponer ^el HP de los unicornios.^")
    QUESLOWPRINT("Si se te acaba la comida, ve de caseria.^")
    QUESLOWPRINT("Si se te acaban los unicornios, ^")
    QUESLOWPRINT("puedes domar unicornios salvajes.^")
    QUESLOWPRINT("Usa tus pociones sabiamente.^")
    QUESLOWPRINT("Tienes que llegar a \"The valley of ^")
    QUESLOWPRINT("enternity\" de que la \"Northern ^")
    QUESLOWPRINT("Tundra\" antes de que se conjele....")
    SLOWPRINT(50,"",showControls)
end
local campingButton
local tameUnicornButton
function unicornsFaster()
    speed=speed+granualrMovement
    print("speed:"..speed)
    if campingButton then
        if campingButton.isVisible then
            hideRestingMenu()
        end
    end
    animateUnicorns()
end

function healCusedCharacterByIndex(index,message)
    dice=math.random(1,100)
    if dice<=30 then
        local characters = composer.getVariable("characters")
        char=characters[index] 
        if char.isAlive then
            if char.isCursed then
                message=message..char.name
                if composer.getVariable( "language" ) == "English" then
                    message=message.." has been healed from the curse!^"
                elseif composer.getVariable( "language" ) == "Japanese" then
                    message=message.."の呪いが解けた！^"
                elseif composer.getVariable( "language" ) == "Spanish" then
                    message=message.." se ha aliviado de la maldicion!^"
                end
                char.isCursed=false            
            end
        end
    end
    return message
end

function healCharacterHPByIndex(index)
    local characters = composer.getVariable("characters")
    char=characters[index] 
    if char.isAlive then
        char.HP=100
    end
end

function restoreCharacterMPByIndex(index)
    local characters = composer.getVariable("characters")
    char=characters[index] 
    if char.isAlive then
        char.MP=100
    end
end


local function healAllUnicornsHP()
    for i, unicorn in ipairs(unicorns) do
        if unicorn.alive then
            unicorn.hp = 100
        end
    end
end

function campOverNighht()
    setGamePausedState(false)--this is cause the following function chechs for if game is paused, quickhack
    if not onRoad then
        local message
        if composer.getVariable( "language" ) == "English" then
            message="you can't camp while off the trail.^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message="道に沿ってない時はキャンプ出来ない。^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message="No puedes hacer campamento cuando no estas en la liena roja.^"
        end                
        pauseAndShowQuickMessage(message)
        return
    end
    GO=dayPassed()
    if GO then
        return
    end
    lblDaysPassed.text=tostring(daysPassed)..translate["Days Passed"]
    local message=""
    if composer.getVariable( "language" ) == "English" then
        message="A day went by. HP restored^"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="一日過ぎた。HPが回復した。^"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="Paso un dia. HP restaurado.^"
    end            
    --**add time going by when camping when time system is done
    message=healCusedCharacterByIndex(1,message)
    message=healCusedCharacterByIndex(2,message)
    message=healCusedCharacterByIndex(3,message)
    message=healCusedCharacterByIndex(4,message)
    message=healCusedCharacterByIndex(5,message)
    healCharacterHPByIndex(1)
    healCharacterHPByIndex(2)
    healCharacterHPByIndex(3)
    healCharacterHPByIndex(4)
    healCharacterHPByIndex(5)
    healAllUnicornsHP()
    pauseAndShowQuickMessage(message)
end
function tameAUnicorn()
    local message
    local characters = composer.getVariable("characters")
    tamerChar=characters[2]--tamer 
    if tamerChar.MP<30 then
        if composer.getVariable( "language" ) == "English" then
            message=tamerChar.name .. " needs 30 MP to cast this spell."
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=tamerChar.name .. "がその呪文を唱えるには３０MPが必要。"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=tamerChar.name .. " necesita 30 MP para usar esa magia."
        end
        pauseAndShowQuickMessage(message)
        return
    end
    if tamerChar.isAlive==false then
        if composer.getVariable( "language" ) == "English" then
            message=tamerChar.name.." is dead, only she has the magic to tame a wild unicorn.^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=tamerChar.name.."が死んでる、彼女にしか野生のユニコーン飼いならす魔法がない。^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=tamerChar.name.." ha muerto, solo ella tiene la magia para rominar a un unicornio salvaje.^"
        end
        pauseAndShowQuickMessage(message)
        return 
    end
    dice=math.random(1,100)
    local numberOfTamedUnicorns=0
    if dice < 80 then
        numberOfTamedUnicorns=math.random(1,15)
        if composer.getVariable( "language" ) == "English" then
            message=tamerChar.name.." plays her harp and it tamed a unicorn and tamed " .. numberOfTamedUnicorns.." unicorns."
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=tamerChar.name.."がハープを弾いて、ユニコーン" .. numberOfTamedUnicorns.."頭を飼いならしました。"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=tamerChar.name.." toca su harpa y domistoca a " .. numberOfTamedUnicorns.." unicornios."
        end
        composer.setVariable("NumberOfUnicorns",composer.getVariable("NumberOfUnicorns")+numberOfTamedUnicorns)
    else
        if composer.getVariable( "language" ) == "English" then
            message="The magic failed.^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message="魔法が失敗した。^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message="La magia fallo.^"
        end
        dice=math.random(1,100)
        if dice < 10 then
            if composer.getVariable( "language" ) == "English" then
                message=message.." and " .. tamerChar.name.." died!^"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message=message.."そして" .. tamerChar.name.."が死んだ！^"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message=message.." y " .. tamerChar.name.." murio.^"
            end    
            tamerChar.isAlive=false
        end
    end
    if tamerChar.isAlive then
        tamerChar.MP=tamerChar.MP-30
        if composer.getVariable( "language" ) == "English" then
            message=message..tamerChar.name.." used 30 MP."
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=message..tamerChar.name.."が３０MPを使った。"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=message..tamerChar.name.." uso 30 MP."
        end    
    end
    pauseAndShowQuickMessage(message)
end
function unCurseTeam()
    local characters = composer.getVariable("characters") 
    local message=""
    healerChar=characters[5]
    if healerChar.isAlive==false then
        if composer.getVariable( "language" ) == "English" then
            message=healerChar.name.." is dead, only she can cast the uncurse spell.^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=healerChar.name.."が死んだ。彼女しか呪いを解ける魔法が使えない。^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=healerChar.name.." ha muerto, sole ella puede usar la magia para quitar las maldiciones.^"
        end
        pauseAndShowQuickMessage(message)
        return
    end
    if healerChar.MP<30 then
        if composer.getVariable( "language" ) == "English" then
            message=healerChar.name.." must have 30MP to cast the uncurse spell.^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message=healerChar.name.."が３０MPがないと呪いを解ける呪文が唱えない。^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message=healerChar.name.." tiene que tener 30 MP pare poder hacer el invocar de quitar las maldiciones.^"
        end
        pauseAndShowQuickMessage(message)
        return
    end
    healerChar.MP=healerChar.MP-30
    if composer.getVariable( "language" ) == "English" then
        message=healerChar.name.." casts an uncurseing spell on the group!^this spell drained 30 MP."
    elseif composer.getVariable( "language" ) == "Japanese" then
        message=healerChar.name.."が呪いを解ける呪文を皆に唱える！^この呪文が３０MPが掛かった。^"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message=healerChar.name.." invoca el hechizo de quitar maldiciones al grupo!^ este hechizo le costo 30 MP."
    end            
    for girlNumber=1,5,1 do--init,maxval,step
        char=characters[girlNumber]
        if char.isAlive then
            if char.isCursed then
                message=message..char.name
                if composer.getVariable( "language" ) == "English" then
                    message=message.." has been healed from the curse!^"
                elseif composer.getVariable( "language" ) == "Japanese" then
                    message=message.."の呪いが解けた！^"
                elseif composer.getVariable( "language" ) == "Spanish" then
                    message=message.." se ha aliviado de la maldicion!^"
                end
                char.isCursed=false            
            end
        end
    end
    pauseAndShowQuickMessage(message)
end

function useHPpotionOnAll()
    local message=""
    if composer.getVariable("HPpotions")<=1 then
        if composer.getVariable( "language" ) == "English" then
            message = "You don't have any HP potions left...^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message = "HPポーションが残されていな…^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message = "Ya no tienes pociones HP^"
        end
        pauseAndShowQuickMessage(message)
    end
    composer.setVariable("HPpotions",composer.getVariable("HPpotions")-1)
    healCharacterHPByIndex(1)
    healCharacterHPByIndex(2)
    healCharacterHPByIndex(3)
    healCharacterHPByIndex(4)
    healCharacterHPByIndex(5)
    healAllUnicornsHP()
    if composer.getVariable( "language" ) == "English" then
        message = "You used an HP Potion,^complete health restoration achieved!^"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = "HPポーションを使った、HPが完全に回復した！^"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = "Usaste una pocion HP,^la salud de todos ha sido aliviada!^"
    end
    pauseAndShowQuickMessage(message)
end

function useMPpotionOnAll()
    local message=""
    if composer.getVariable("MPpotions")<=1 then
        if composer.getVariable( "language" ) == "English" then
            message = "You don't have any MP potions left...^"
        elseif composer.getVariable( "language" ) == "Japanese" then
            message = "MPポーションが残されていな…^"
        elseif composer.getVariable( "language" ) == "Spanish" then
            message = "Ya no tienes pociones MP^"
        end
        pauseAndShowQuickMessage(message)
    end
    composer.setVariable("MPpotions",composer.getVariable("MPpotions")-1)
    restoreCharacterMPByIndex(1)
    restoreCharacterMPByIndex(2)
    restoreCharacterMPByIndex(3)
    restoreCharacterMPByIndex(4)
    restoreCharacterMPByIndex(5)
    if composer.getVariable( "language" ) == "English" then
        message = "You used an MP Potion,^complete magic restoration achieved!^"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = "MPポーションを使った、MPが完全に回復した！^"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = "Usaste una pocion MP,^la magia de todos ha sido aliviada!^"
    end
    pauseAndShowQuickMessage(message)
end
function hideEverything()

    --if caravanGroup then
    --    if caravanGroup.removeSelf then 
    --        caravanGroup:removeSelf()
    --    end
    --end
    if caravanGroup then --hack to fix bug after winning in paczel where caravanGroup is nil, dunno  why
        caravanGroup.isVisible=false
        myUpButton.isVisible=false
        myDownButton.isVisible=false
        myFireButton.isVisible=false
        arc.isVisible=false
        lblDaysPassed.isVisible=false
        lblLabel.isVisible=false
        saveButton.isVisible=false
        loadButton.isVisible=false
        pauseButton.isVisible=false
        for index, box in ipairs(tblBoxes) do
            box.isVisible=false
        end
    end
    hideRestingMenu()
end
function goHuntingPaczel()
    saveCaravan()
    composer.setVariable( "gameMode", "Paczel" )
    gameMode = composer.getVariable( "gameMode" )
    print("gameMode:"..gameMode)
    composer.setVariable("numberOfPowerUps",5)
    composer.setVariable("numberOfMonsters",5)
    hideEverything()
    composer.setVariable("wentHunting", true)
    --composer.setVariable("caravan",caravan)    
    composer.setVariable("unicorns",unicorns)
    hideTextArea()
    composer.removeScene(composer.getSceneName( "current" ))
    composer.gotoScene( "paczel" )
end

local function menuButtonTouchListener( event )
    if ( event.phase == "began" ) then
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		--if isWithinBounds(myUpButton, event) == false then
		--end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
        print("event.target.myName:"..event.target.myName)
        if event.target.myName=="campingButton" then
            hideRestingMenu()
            campOverNighht()
        end
        if event.target.myName=="tameUnicornButton" then
            hideRestingMenu()
            tameAUnicorn()
        end
        if event.target.myName=="unCurseButton" then
            hideRestingMenu()
            unCurseTeam()
        end
        if event.target.myName=="useHPpotionButton" then
            hideRestingMenu()
            useHPpotionOnAll()
        end
        if event.target.myName=="useMPpotionButton" then
            hideRestingMenu()
            unCurseTeam()
            useMPpotionOnAll()
        end
        if event.target.myName=="goHuntingButton" then
            hideRestingMenu()
            goHuntingPaczel()
        end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end

function hideRestingMenu()
    if not campingButton then
        return
    end
    campingButton.isVisible=false
    tameUnicornButton.isVisible=false
    unCurseButton.isVisible=false
    useHPpotionButton.isVisible=false
    useMPpotionButton.isVisible=false
    goHuntingButton.isVisible=false
    lblCampingButton.isVisible=false
    lblTameButton.isVisible=false
    lblUnCurseButton.isVisible=false
    lblMPpotionButton.isVisible=false
    lblHPpotionButton.isVisible=false
    lblHuntingButton.isVisible=false
end

function showRestingMenu()
    if not campingButton then
        offsetx=235
        offsety=700
        local menuItem
        if composer.getVariable( "language" ) == "English" then
            menuItem="Camping"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="キャンプ"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="Campamento"
        end
        local paint = {
            type = "image",
            filename = "img/camping.png"
        }
        campingButton = display.newRect( offsetx, offsety, 200, 200 )
        lblCampingButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblCampingButton:setFillColor(1,1,0)
        campingButton.fill = paint
        campingButton.myName="campingButton"
        campingButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/taming-wild-unicorn.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        if composer.getVariable( "language" ) == "English" then
            menuItem="Tame"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="飼育"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="Domar"
        end
        tameUnicornButton = display.newRect( offsetx, offsety, 200, 200 )
        lblTameButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblTameButton:setFillColor(1,1,0)
        tameUnicornButton.fill = paint
        tameUnicornButton.myName="tameUnicornButton"
        tameUnicornButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/unCurse.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        if composer.getVariable( "language" ) == "English" then
            menuItem="uncurse"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="解呪"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="desmaldecir"
        end
        unCurseButton = display.newRect( offsetx, offsety, 200, 200 )
        lblUnCurseButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblUnCurseButton:setFillColor(1,1,0)
        unCurseButton.fill = paint
        unCurseButton.myName="unCurseButton"
        unCurseButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/useHPpotion.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        if composer.getVariable( "language" ) == "English" then
            menuItem="HP potion"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="回復薬"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="pocion HP"
        end
        useHPpotionButton = display.newRect( offsetx, offsety, 200, 200 )
        lblHPpotionButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblHPpotionButton:setFillColor(1,1,0)
        useHPpotionButton.fill = paint
        useHPpotionButton.myName="useHPpotionButton"
        useHPpotionButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/useMPpotion.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        if composer.getVariable( "language" ) == "English" then
            menuItem="MP potion"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="魔回復薬"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="pocion MP"
        end
        useMPpotionButton = display.newRect( offsetx, offsety, 200, 200 )
        lblMPpotionButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblMPpotionButton:setFillColor(1,1,0)
        useMPpotionButton.fill = paint
        useMPpotionButton.myName="useMPpotionButton"
        useMPpotionButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/goHunting.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        if composer.getVariable( "language" ) == "English" then
            menuItem="Hunt"
        elseif composer.getVariable( "language" ) == "Japanese" then
            menuItem="狩猟"
        elseif composer.getVariable( "language" ) == "Spanish" then
            menuItem="Caseria"
        end
        goHuntingButton = display.newRect( offsetx, offsety, 200, 200 )
        lblHuntingButton = display.newText({ text = menuItem, x = offsetx, y = offsety-60, font = "fonts/ume-tgc5.ttf",background = {r=1, g=1, b=1 } }) 
        lblHuntingButton:setFillColor(1,1,0)
        goHuntingButton.fill = paint
        goHuntingButton.myName="goHuntingButton"
        goHuntingButton:addEventListener( "touch", menuButtonTouchListener ) 
    else
        campingButton.isVisible=true
        tameUnicornButton.isVisible=true
        unCurseButton.isVisible=true
        useHPpotionButton.isVisible=true
        useMPpotionButton.isVisible=true
        goHuntingButton.isVisible=true
        lblCampingButton.isVisible=true
        lblTameButton.isVisible=true
        lblUnCurseButton.isVisible=true
        lblMPpotionButton.isVisible=true
        lblHPpotionButton.isVisible=true
        lblHuntingButton.isVisible=true
    end 
end


function unicornsSlower()
    print("speed:"..speed)
    if speed > 0 then
        speed=speed-granualrMovement
    end
    if speed <= 0 then
        showRestingMenu()
    end
    animateUnicorns()
end

local function myUpTouchListener( event )
    if ( event.phase == "began" ) then
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		--if isWithinBounds(myUpButton, event) == false then
		--end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		print("Unicorns faster!")
        unicornsFaster()
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local function myDownTouchListener( event )
    if ( event.phase == "began" ) then
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
        unicornsSlower()
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local function showStatus()
    local unicornHP
    if not unicorns then
        unicorns=composer.getVariable("unicorns")
    end
    for i, unicorn in ipairs(unicorns) do
        unicornHP=unicorn.hp
    end
    
    local message
    if composer.getVariable( "language" ) == "English" then
        message = "#unicorns:".. composer.getVariable("NumberOfUnicorns").. " speed:" .. speed .. " unicorn HP:" .. math.floor(unicornHP).."^"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message = "ユニコーンの数は".. composer.getVariable("NumberOfUnicorns").. " 速さは" .. speed .. " ユニコーンのHP:" .. math.floor(unicornHP).."^"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message = "# de unicornios:".. composer.getVariable("NumberOfUnicorns").. " velocidad:" .. speed .. " HP de los unicornios:" .. math.floor(unicornHP).."^"
    end

    local characters = composer.getVariable("characters")
    --name = composer.getVariable("MCname") or "Default MC", HP = 100, maxHP = 100, MP = 50, maxMP = 50, isCursed = false
    for i, char in ipairs(characters) do
        message=message..char.name 
        if char.isAlive==false then
            if composer.getVariable( "language" ) == "English" then
                message = message.." is dead.^"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message = message.."が死んだ。^"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message = message.." ha muerto.^"
            end        
        else
            if char.isCursed then
                if composer.getVariable( "language" ) == "English" then
                    message=message.." is cursed."
                elseif composer.getVariable( "language" ) == "Japanese" then
                    message=message.."が呪われてる。"
                elseif composer.getVariable( "language" ) == "Spanish" then
                    message=message.." esta maldecida."
                end            
            end
            if composer.getVariable( "language" ) == "English" then
                message=message .. " HP:".. char.HP .. " MP:" .. char.MP .. "^"
            elseif composer.getVariable( "language" ) == "Japanese" then
                message=message .. " HP:".. char.HP .. " MP:" .. char.MP .. "^"
            elseif composer.getVariable( "language" ) == "Spanish" then
                message=message .. " HP:".. char.HP .. " MP:" .. char.MP .. "^"
            end    
        end
    end
    if composer.getVariable( "language" ) == "English" then
        message=message.."Gold:" .. composer.getVariable("gold") .. " grams.^HP potions:" .. composer.getVariable("HPpotions") .. "MP potions:" ..  composer.getVariable("MPpotions").."^Food:"..composer.getVariable("KGofFood").."KG."
    elseif composer.getVariable( "language" ) == "Japanese" then
        message=message.."金：" .. composer.getVariable("gold") .. "グラム。^HPポーション：" .. composer.getVariable("HPpotions") .. "MPポーション：" ..  composer.getVariable("MPpotions").."^食料："..composer.getVariable("KGofFood").."KG."
    elseif composer.getVariable( "language" ) == "Spanish" then
        message=message.."oro:" .. composer.getVariable("gold") .. " gramos.^pociones de HP:" .. composer.getVariable("HPpotions") .. "pociones de MP:" ..  composer.getVariable("MPpotions").."^Comida:"..composer.getVariable("KGofFood").."KG."
    end
    pauseAndShowQuickMessageFast(message)
end

local function myFireTouchListener( event )
    if ( event.phase == "began" ) then
	elseif ( event.phase == "moved" ) then
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
            showStatus()
            hideRestingMenu()
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
--if system.getInfo("environment") == "device" then
--    arcYPosition=50
--    arcXPosition=850
--else
--    arcYPosition=50
 --   arcXPosition=50
--end

arcYPosition=50
arcXPosition=750
arc = display.newImage( "img/arc.png", arcXPosition, arcYPosition )
--physics.addBody( arc, "static", { density=1, friction=2, bounce=0 } )
--arc.angularDamping = 3
arc.myName="arcTool"

local function dragObject( event, params )
	local body = event.target
	local phase = event.phase

	if "began" == phase then
		selectedItem=event.target
		if selectedItem.myName~="arc" then
			--arc.x=arcXPosition
			--arc.y=arcYPosition
		end
	elseif "moved" == phase then
		if selectedItem.myName=="arcTool" then
			body.x=event.x
			body.y=arcYPosition
			caravan.rotation=event.x
            setRotationOfCaravan(caravan.rotation)
            saveCaravan()
        end
		return true	
	elseif "ended" == phase or "cancelled" == phase then
	end
	return true
end
arc:addEventListener( "touch", dragObject )

local function isPointInRect(px, py, centerX, centerY, size)
    local halfSize = size / 2
    return px >= centerX - halfSize and px <= centerX + halfSize and 
           py >= centerY - halfSize and py <= centerY + halfSize
end



-- Simplified boxListener to delete the tapped box and consume the event
local function boxListener(event)
    -- Remove the box from tblBoxes
    for i, box in ipairs(tblBoxes) do
        if box == event.target then
            table.remove(tblBoxes, i)
            break
        end
    end
    -- Remove the box from the display
    event.target.isVisible = false
    event.target:removeSelf()
    return true  -- Consume the event to prevent tapListener from creating a new box
end
local colorSelected="noColorSelected"
local function tapListener(event)
    -- Check if the tap is on an existing box
    for i, box in ipairs(tblBoxes) do
        if isPointInRect(event.x, event.y, box.x, box.y, box.size, box.label) then
            -- If the tap is on an existing box, do not create a new box
            return false
        end
    end

    -- Otherwise, create a new box
    local message = "x: " .. tostring(event.x) .. " y: " .. tostring(event.y)
    local box
    if colorSelected=="colorWhite" then
        box = display.newImageRect("img/block-white.png", 32, 32)    
    elseif colorSelected=="colorRed" then
        box = display.newImageRect("img/block-red.png", 32, 32)    
    elseif colorSelected=="colorGreen" then
        box = display.newImageRect("img/block-green.png", 32, 32)    
    elseif colorSelected=="colorBlue" then
        box = display.newImageRect("img/block-blue.png", 32, 32)    
    elseif colorSelected=="colorYellow" then
        box = display.newImageRect("img/block.png", 32, 32)    
    else
        return
    end
    box.label=lblLabel.text
    box.color=colorSelected
    box.x = event.x
    box.y = event.y
    box.size = 32  -- Setting size for hit-test check
    box.alpha = 0
    box:addEventListener("tap", boxListener)
    table.insert(tblBoxes, box)
    
    print(message)
    return true
end

local mistralsEndStartPoint={}
--x: 923.40899658203 y: 714.58447265625
if system.getInfo("environment") == "device" then
    mistralsEndStartPoint.x=923.4089965820
    mistralsEndStartPoint.y=714.58447265625
else
    mistralsEndStartPoint.x=923.4089965820
    mistralsEndStartPoint.y=714.58447265625
end


function initTextScreenByCorrectLanguage(sceneGroup)
    if composer.getVariable( "language" ) == "English" then
        initTextScreen(sceneGroup,"EN")
        return
    elseif composer.getVariable( "language" ) == "Japanese" then
        initTextScreen(sceneGroup,"JP")
        return
    elseif composer.getVariable( "language" ) == "Spanish" then
        initTextScreen(sceneGroup,"ES")
        return
   end
end

local btnWhite
local btnRed
local btnGreen
local btnBlue
local btnYellow

local function toolbarTapListener( event )
 
    -- Code executed when the button is tapped
    local message=event.target.myName.." clicked!".." x: " .. tostring(event.x) .. "y: " .. tostring(event.y)
    colorSelected=event.target.myName--this contails a string with the color clicked
    --pauseAndShowQuickMessage(message)
    print(message)  -- "event.target" is the tapped object
    --pauseAndShowQuickMessageFast(message)
    return true
end
local json = require("json")


-- Function to save tblBoxes to level.json
local function saveLevel()
    local serializableBoxes = getSerializableBoxes()
    local jsonString = json.encode(serializableBoxes)
    
    --local path = system.pathForFile("level.json", system.DocumentsDirectory)--this is the sandbox directory
    local path = system.pathForFile("level.json", system.ResourceDirectory)--this is the main directory
    local file, errorString = io.open(path, "w")
    
    if file then
        file:write(jsonString)
        io.close(file)
        print("Level saved successfully.")
    else
        print("Error saving level: " .. errorString)
    end
end
function saveProgress()

end
-- Save button listener
local function onSaveButtonTap(event)
    --saveLevel()
    saveProgress()
    return true
end
saveButton:addEventListener("tap", onSaveButtonTap)
local function alertBoxNoClickedComplete()
    showInputBox("what is your name?:",callback)
end

function saveData(data,filename)
    local jsonString = json.encode(data)
    local path = system.pathForFile(filename, system.DocumentsDirectory)--this is the sandbox directory
    local file, errorString = io.open(path, "w")   
    if file then
        file:write(jsonString)
        io.close(file)
        return "success"
    else
        return "failed"
    end
end

function saveAffirmative()
    --local serializableBoxes = getSerializableBoxes()
    saveCaravan()
    if saveData(composer.getVariable("caravan"),"saveCaravanFile.json") == "failed" then
        pauseAndShowQuickMessageFast("Error saving game.")
        return
    end
    saveData(composer.getVariable("characters"),"saveChacartersFile.json")
    --saveData(composer.getVariable( "MCname"),"saveChacartersFile.json")
    saveData(composer.getVariable( "gold"),"saveGoldFile.json")
    --saveData(composer.getVariable( "adventurer1"),"saveChacartersFile.json")
    --saveData(composer.getVariable( "adventurer2"),"saveChacartersFile.json")
    --saveData(composer.getVariable( "adventurer3"),"saveChacartersFile.json")
    --saveData(composer.getVariable( "adventurer4"),"saveChacartersFile.json")
    saveData(composer.getVariable("HPpotions"),"saveHPpotionsFile.json")
    saveData(composer.getVariable("MPpotions"),"saveMPpotionsFile.json")
    saveData(composer.getVariable("unicorns"),"saveUnicornsFile.json")
    if saveData(composer.getVariable("KGofFood"),"saveKGofFoodFile.json")  == "success" then
        pauseAndShowQuickMessageFast("Save succesful!")
    end 
end

function saveProgress()
    setGamePausedState(true)
    local message="unknown langauge"
    if composer.getVariable( "language" ) == "English" then
        message="Save Game?"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="ゲーム保存しますか？"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="Guarder Juego?"
   end
    AlertBox(
    "",
    message,
    saveAffirmative,
    unPauseGame
    )
end
function loadData(variableNameString,filename)
    local path = system.pathForFile(filename, system.DocumentsDirectory)--this is the sandbox directory
    local file, errorString = io.open(path, "r")
    local successFailure
    if file then
        successFailure="success"
    else
        successFailure="failed"
    end
    local jsonString = file:read("*a")
    io.close(file)
    local data = json.decode(jsonString)
    composer.setVariable(variableNameString, data)
    return successFailure
end


function loadAffirmative()
    local path = system.pathForFile("saveCaravanFile.json", system.DocumentsDirectory)--this is the sandbox directory
    local file, errorString = io.open(path, "r")
    if loadData("caravan","saveCaravanFile.json") == "failed" then
        pauseAndShowQuickMessageFast("Error loading game.")
        return
    end
    loadData("characters","saveChacartersFile.json")
    --loadData(composer.getVariable( "MCname"),"saveChacartersFile.json")
    loadData("gold","saveGoldFile.json")
    --loadData(composer.getVariable( "adventurer1"),"saveChacartersFile.json")
    --loadData(composer.getVariable( "adventurer2"),"saveChacartersFile.json")
    --loadData(composer.getVariable( "adventurer3"),"saveChacartersFile.json")
    --loadData(composer.getVariable( "adventurer4"),"saveChacartersFile.json")
    loadData("HPpotions","saveHPpotionsFile.json")
    loadData("MPpotions","saveMPpotionsFile.json")
    loadData("unicorns","saveUnicornsFile.json")
    loadData("KGofFood","saveKGofFoodFile.json")
    
    --relocate caravan to saved position
    local obj={}
    obj.rotation=composer.getVariable("caravan").rotation
    obj.x=composer.getVariable("caravan").x
    obj.y=composer.getVariable("caravan").y
    setGamePausedState(true)
    transition.to( caravanGroup, { time=0, x=obj.x, y=obj.y, onComplete=transitionCompleted } )
    updateCaravanCoordinates(obj)
    caravan.rotation=obj.rotation
    print("Teleported to box.x:" .. box.x .. ", box.y:" .. box.y)
    pauseAndShowQuickMessageFast("Load succesful!")
end


function loadProgrress()
    setGamePausedState(true)
    local message="unknown langauge"
    if composer.getVariable( "language" ) == "English" then
        message="Load Game?"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="ゲームロードしますか？"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="Cargar Juego?"
   end
    AlertBox(
    "",
    message,
    loadAffirmative,
    unPauseGame
    )
end
function loadFromJson()
    local path = system.pathForFile("level.json", system.ResourceDirectory)--this is the main directory
    local file, errorString = io.open(path, "r")
    if file then
        local jsonString = file:read("*a")
        io.close(file)
        --print("json sting:"..jsonString)
        local serializableBoxes = json.decode(jsonString)
        
        -- Clear existing boxes
        for i = #tblBoxes, 1, -1 do
            local box = tblBoxes[i]
            box:removeSelf() -- Remove from display
            table.remove(tblBoxes, i) -- Remove from table
        end
        --diagnostic
        print("Number of items: " .. #serializableBoxes) -- Should match JSON array length
        for i, data in ipairs(serializableBoxes) do
            print("Item " .. i .. " type: " .. type(data)) -- Should be "table"
            if type(data) == "table" then
                print("Item " .. i .. " label: " .. tostring(data.label)) -- Should show label or "nil"
            end
            if data.label==nil then
                print("nil label found in data, skipping")
            else
                -- Box creation code
            end
        end
        local mistranlsEndInData=false
        -- Recreate boxes from loaded data
        for _, data in ipairs(serializableBoxes) do
                if data.label==nil then
                    print("nil label found in data, skipping")
                else
                --local box = display.newImageRect("img/block-white.png", data.size, data.size)
                if data.color=="colorWhite" then
                    box = display.newImageRect("img/block-white.png", 32, 32)    
                elseif data.color=="colorRed" then
                    box = display.newImageRect("img/block-red.png", 32, 32)    
                elseif data.color=="colorGreen" then
                    box = display.newImageRect("img/block-green.png", 32, 32)    
                elseif data.color=="colorBlue" then
                    box = display.newImageRect("img/block-blue.png", 32, 32)    
                elseif data.color=="colorYellow" then
                    box = display.newImageRect("img/block.png", 32, 32)    
                end
                print("label:"..data.label)
                if data.label=="mist_end_exit" then
                    mistranlsEndInData=true
                end
                box.label = data.label
                box.color = data.color
                box.x = data.x
                box.y = data.y
                box.size = data.size
                box.alpha = 0
                box:addEventListener("tap", boxListener) -- Add your tap listener if needed
                table.insert(tblBoxes, box)
            end
        end
        print("Level loaded successfully.")
    else
        print("Error loading level: " .. errorString)
    end
    if mistranlsEndInData then
        print("mistrals end in data")
    else
        print("warning:mistrals end NOT in data")
    end
end

-- Function to load level.json and reconstruct tblBoxes
local function loadLevel()
    
    loadFromJson()
    --[[
    --local path = system.pathForFile("level.json", system.DocumentsDirectory)
    local path = system.pathForFile("level.json", system.ResourceDirectory)--this is the main directory
    local file, errorString = io.open(path, "r")
    if file then
        local jsonString = file:read("*a")
        io.close(file)
        --print("json sting:"..jsonString)
        local serializableBoxes = json.decode(jsonString)
        
        -- Clear existing boxes
        for i = #tblBoxes, 1, -1 do
            local box = tblBoxes[i]
            box:removeSelf() -- Remove from display
            table.remove(tblBoxes, i) -- Remove from table
        end
        --diagnostic
        print("Number of items: " .. #serializableBoxes) -- Should match JSON array length
        for i, data in ipairs(serializableBoxes) do
            print("Item " .. i .. " type: " .. type(data)) -- Should be "table"
            if type(data) == "table" then
                print("Item " .. i .. " label: " .. tostring(data.label)) -- Should show label or "nil"
            end
            if data.label==nil then
                print("nil label found in data, skipping")
            else
                -- Box creation code
            end
        end
        local mistranlsEndInData=false
        -- Recreate boxes from loaded data
        for _, data in ipairs(serializableBoxes) do
                if data.label==nil then
                    print("nil label found in data, skipping")
                else
                --local box = display.newImageRect("img/block-white.png", data.size, data.size)
                if data.color=="colorWhite" then
                    box = display.newImageRect("img/block-white.png", 32, 32)    
                elseif data.color=="colorRed" then
                    box = display.newImageRect("img/block-red.png", 32, 32)    
                elseif data.color=="colorGreen" then
                    box = display.newImageRect("img/block-green.png", 32, 32)    
                elseif data.color=="colorBlue" then
                    box = display.newImageRect("img/block-blue.png", 32, 32)    
                elseif data.color=="colorYellow" then
                    box = display.newImageRect("img/block.png", 32, 32)    
                end
                print("label:"..data.label)
                if data.label=="mist_end_exit" then
                    mistranlsEndInData=true
                end
                box.label = data.label
                box.color = data.color
                box.x = data.x
                box.y = data.y
                box.size = data.size
                box.alpha = 0
                box:addEventListener("tap", boxListener) -- Add your tap listener if needed
                table.insert(tblBoxes, box)
            end
        end
        print("Level loaded successfully.")
    else
        print("Error loading level: " .. errorString)
    end
    if mistranlsEndInData then
        print("mistrals end in data")
    else
        print("warning:mistrals end NOT in data")
    end
    ]]
end


-- Load button listener
local function onLoadButtonTap(event)
    loadProgrress()
    return true
end
loadButton:addEventListener("tap", onLoadButtonTap)
local function onsetLabelButtonTap(event)
    composer.setVariable("setVariable","Label")
    composer.setVariable("backgroundImage","backgrounds/adventurer3.png")
    composer.setVariable("nextScreenName",composer.getSceneName( "current" )) -- come back here afer input
    composer.setVariable("prompt1EN","Label is:")
    composer.setVariable("prompt2EN",",right?")
    composer.setVariable("prompt1JP","ラベルは:")
    composer.setVariable("prompt2JP","でよろしいですか？")
    composer.setVariable("prompt1ES","El Label es:")
    composer.setVariable("prompt2ES",",verdad?")

    hideEverything()
    composer.removeScene(composer.getSceneName( "current" ))
    composer.setVariable("gettingInput", true)
    composer.setVariable("caravan",caravanGroup)    
    composer.setVariable("unicorns",unicorns)
    --composer.setVariable("tblBoxes",tblBoxes)
    hideTextArea()
    composer.setVariable("tblBoxesData", getSerializableBoxes())
    composer.gotoScene( "InputScene" )
    return true
end




function quitAffirmative()
    --this seemed to have frozen my linux system, try calling gamepaus() tomorrow
    --and add option to resequence the text in thatos.exit()
    gameOver()
end

function onquitButtonTap()
    setGamePausedState(true)
    local message="unknown langauge"
    if composer.getVariable( "language" ) == "English" then
        message="Quit Game?"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="ゲーム終了しますか？"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="Dejar el juego?"
   end
    AlertBox(
    "",
    message,
    quitAffirmative,
    unPauseGame
    )
end

local quitButton = display.newText("Quit", 600, 50, native.systemFont, 20)
quitButton:addEventListener("tap", onquitButtonTap)


local setLabelButton = display.newText("[Set Label]", 500, 50, native.systemFont, 20)
setLabelButton:addEventListener("tap", onsetLabelButtonTap)
setLabelButton.isVisible=false
--local lblLabel = native.newTextField( 550, 50, width, height )

function restoreBoxesFromTable(sceneGroup)
    -- Restore boxes from saved data
    local tblBoxesData = composer.getVariable("tblBoxesData")
    tblBoxes = {}
    for _, data in ipairs(tblBoxesData) do
        local box
        if data.color == "colorWhite" then
            box = display.newImageRect(sceneGroup, "img/block-white.png", 32, 32)
        elseif data.color == "colorRed" then
            box = display.newImageRect(sceneGroup, "img/block-red.png", 32, 32)
        elseif data.color == "colorGreen" then
            box = display.newImageRect(sceneGroup, "img/block-green.png", 32, 32)
        elseif data.color == "colorBlue" then
            box = display.newImageRect(sceneGroup, "img/block-blue.png", 32, 32)
        elseif data.color == "colorYellow" then
            box = display.newImageRect(sceneGroup, "img/block.png", 32, 32)
        end
        if box then
            box.label = data.label
            box.color = data.color
            box.x = data.x
            box.y = data.y
            box.size = 32
            box.alpha = 0
            box:addEventListener("tap", boxListener)
            table.insert(tblBoxes, box)
            print("added box.label:"..box.label)
        end
    end
end


function restoreSceneAfterExist(sceneGroup,savedCaravan)
    initTextScreenByCorrectLanguage(sceneGroup)
    CLS()
    hideTextArea()
    --local savedCaravan=composer.getVariable("caravan")
    --local savedCaravan=composer.getVariable("caravan")
    caravanGroup.x=savedCaravan.x
    caravanGroup.y=savedCaravan.y
    caravan.rotation=savedCaravan.rotation
    setRotationOfCaravan(caravan.rotation)
    unicorns=composer.getVariable("unicorns")
    tblBoxes=composer.getVariable("tblBoxesData")
    restoreBoxesFromTable(sceneGroup)
end

function findBox(name)
    local returnObj = {}
    for index, box in ipairs(tblBoxes) do
        if box.label == name then  -- Fixed typo from 'lable' to 'label'
            returnObj.x = box.x
            returnObj.y = box.y
            return returnObj      -- Return immediately when found
        end
    end
    -- Return nil if no match is found (better than empty table)
    return nil
end



local function repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,exitPoint)
    --**set speed back to 0, the caravan keeps on moving after reaching melstroms peak
    composer.setVariable("justLeftTown",true)
    timer.performWithDelay(20000*composer.getVariable( "speed" ), function() composer.setVariable("justLeftTown",false) end)
    initTextScreenByCorrectLanguage(sceneGroup)
    CLS()
    hideTextArea()
    -- Restore caravan
    local savedCaravan = composer.getVariable("caravan")
    print("loading savedCaravan.x"..savedCaravan.x)
    caravanGroup.x = savedCaravan.x
    caravanGroup.y = savedCaravan.y
    caravan.rotation = savedCaravan.rotation
    setRotationOfCaravan(caravan.rotation)

    print("exit point:"..exitPoint)
    if exitPoint ~= "savedPoint" then
        local newCaravanPosition = findBox(exitPoint)
        if newCaravanPosition then
            print("Teleporting to x:", newCaravanPosition.x, "y:", newCaravanPosition.y)
        else
            print("Error: 'test' box not found!")
        end
        if newCaravanPosition then
            caravanGroup.x = newCaravanPosition.x
            caravanGroup.y = newCaravanPosition.y
            print("After setting: x:", caravanGroup.x, "y:", caravanGroup.y)
        end

        -- Move caravan to exit
        setGamePausedState(true)
        transition.to(caravanGroup, { time=0, x=newCaravanPosition.x, y=newCaravanPosition.y, onComplete=transitionCompleted })
        caravanGroup.x = newCaravanPosition.x
        caravanGroup.y = newCaravanPosition.y
        print("2After setting: x:", caravanGroup.x, "y:", caravanGroup.y)
    else
        setGamePausedState(true)
        transition.to(caravanGroup, { time=0, x=savedCaravan.x, y=savedCaravan.y, onComplete=transitionCompleted })
        updateCaravanCoordinates(savedCaravan)
    end
    daysPassed=composer.getVariable("daysPassed")
    arc.x=composer.getVariable("arc.x")
    lblDaysPassed.text=tostring(daysPassed)..translate["Days Passed"]
    unicorns = composer.getVariable("unicorns")
    print("3After setting: x:", caravanGroup.x, "y:", caravanGroup.y)
   
    composer.setVariable("caravan", {x = caravanGroup.x, y = caravanGroup.y, rotation = caravan.rotation})    --**setGamePausedState(false)
    disableContinueButton()
end
local uniconAnimationTimer
local caravanIMG1
local caravanIMG2
local caravanIMG3
local caravanIMG4
local caravanIMG5
local caravanIMG6
local caravanIMG7
local caravanIMG8
local frame=1

function hideCaravanSprites()
    caravanIMG1.isVisible=false
    caravanIMG2.isVisible=false
    caravanIMG3.isVisible=false
    caravanIMG4.isVisible=false
    caravanIMG5.isVisible=false
    caravanIMG6.isVisible=false
    caravanIMG7.isVisible=false
    caravanIMG8.isVisible=false
end
function unicornAnimationLoop()
    hideCaravanSprites()
    if frame==1 then
        caravanIMG2.isVisible=true
    elseif frame==2 then
        caravanIMG3.isVisible=true
    elseif frame==3 then
        caravanIMG4.isVisible=true
    elseif frame==4 then
        caravanIMG5.isVisible=true
    elseif frame==5 then
        caravanIMG6.isVisible=true
    elseif frame==6 then
        caravanIMG7.isVisible=true
    elseif frame==7 then
        caravanIMG8.isVisible=true
    elseif frame==8 then
        caravanIMG1.isVisible=true    
    end
    frame=frame+1
    if frame==9 then
        frame=1
    end
end
function animateUnicorns()
    --detach timer
    if uniconAnimationTimer then
        timer.cancel( uniconAnimationTimer )
    end
    if speed==0 then
        return
    else
        --sert timer at 1000/speed
        uniconAnimationTimer=timer.performWithDelay(1000/speed*composer.getVariable( "speed" ), unicornAnimationLoop)
    end
end

function setRotationOfCaravan(degrees)
    caravanIMG1.rotation = degrees
    caravanIMG2.rotation = degrees
    caravanIMG3.rotation = degrees
    caravanIMG4.rotation = degrees
    caravanIMG5.rotation = degrees
    caravanIMG6.rotation = degrees
    caravanIMG7.rotation = degrees
    caravanIMG8.rotation = degrees
end
local showCalledAlreadyHack=false--this did not fix it
function scene:show(event)
    audio.stop( 1 )

	audio.reserveChannels( 1 )
	-- Reduce the overall volume of the channel
	audio.setVolume( 1, { channel=1 } )


	-- Load audio
	musicTrack = audio.loadStream( "audio/into-the-battle.mp3",system.ResourceDirectory)


	-- Play the background music on channel 1, loop infinitely 
	audio.play( musicTrack, { channel=1, loops=-1 } )

    if showCalledAlreadyHack then
        showCalledAlreadyHack=true
        return
    end
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        setGamePausedState(true)
        gamePaused = composer.getVariable("gamePaused")
        if gamePaused==nil then
            print("gamePaused is nil changing to true")
            gamePaused=true
        else
            print("gamePaused:"..tostring(gamePaused))
        end
    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        -- Call this once when starting the scene or when unicorn count changes.
        loadLevel()
        createUnicorns()

        --buttons
        offsetx=450
        offsety=300
        local paint = {
            type = "image",
            filename = "img/arrowUp.png"
        }
        myUpButton = display.newRect( 1300, 50, 100, 100 )
        myUpButton.fill = paint
        myUpButton:addEventListener( "touch", myUpTouchListener )  -- Add a "touch" listener to the obj
        --change this to carravan animation later
        caravanGroup=display.newGroup()
        local found=false
        for index, box in ipairs(tblBoxes) do
            if box.label=="mist_end_exit" then
                mistralsEndStartPoint.x=box.x
                mistralsEndStartPoint.y=box.y
                found=true
                break
            end 
        end
        if found then
            print("mistrals end exit found in jason file")
        else
            print("mistrals end exit not found!")            
        end
        caravan = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravan.fill = paint
        caravan:rotate( 45 )
        caravan.alpha=0.2
        local paint = {
            type = "image",
            filename = "img/block-green.png"
        }
        caravanCollider = display.newRect( caravanGroup, 0, 0, 10, 10 )
        caravanCollider.fill = paint
        local paint = {
            type = "image",
            filename = "animations/caravan/caravan1.png"
        }
        caravanIMG1 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG1.fill = paint
        paint.filename = "animations/caravan/caravan2.png"
        caravanIMG2 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG2.fill = paint
        caravanIMG2.isVisible=false
        paint.filename = "animations/caravan/caravan3.png"
        caravanIMG3 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG3.fill = paint
        caravanIMG3.isVisible=false
        paint.filename = "animations/caravan/caravan4.png"
        caravanIMG4 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG4.fill = paint
        caravanIMG4.isVisible=false
        paint.filename = "animations/caravan/caravan5.png"
        caravanIMG5 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG5.fill = paint
        caravanIMG5.isVisible=false
        paint.filename = "animations/caravan/caravan6.png"
        caravanIMG6 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG6.fill = paint
        caravanIMG6.isVisible=false
        paint.filename = "animations/caravan/caravan7.png"
        caravanIMG7 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG7.fill = paint
        caravanIMG7.isVisible=false
        paint.filename = "animations/caravan/caravan8.png"
        caravanIMG8 = display.newRect( caravanGroup, 0 , 0, 100, 100 )
        caravanIMG8.fill = paint
        caravanIMG8.isVisible=false
        --moving caravan to center of screen
        --remmeber that groups move reative to teh placement of the objects in their original position, so always set the objects to 0,0 first
        local mistralsEndStartPoint=findBox("mist_end_exit")
        if mistralsEndStartPoint==nil then
            pauseAndShowQuickMessage("error;mistrals end not found in jason file, putting on center of screen")
            mistralsEndStartPoint={}
            mistralsEndStartPoint.x=display.contentCenterX
            mistralsEndStartPoint.y=display.contentCenterY
        end
        --**fix new bug when it clears the map after making a new box
        setGamePausedState(true)
        transition.to( caravanGroup, { time=0, x=mistralsEndStartPoint.x, y=mistralsEndStartPoint.y, onComplete=transitionCompleted } )
        updateCaravanCoordinates(mistralsEndStartPoint)
        local paint = {
            type = "image",
            filename = "img/arrowDown.png"
        }
        myDownButton = display.newRect( 1300+150, 50, 100, 100 )
        myDownButton.fill = paint
        myDownButton:addEventListener( "touch", myDownTouchListener )  -- Add a "touch" listener to the obj

        local paint = {
            type = "image",
            filename = "img/statusButton.png"
        }
        myFireButton = display.newRect( 1300+150+150, 50, 100, 100 )
        myFireButton.fill = paint
        myFireButton:addEventListener( "touch", myFireTouchListener )  -- Add a "touch" listener to the obj

        --myFireButton.alpha=0.3
        --myDownButton.alpha=0.3
        --myUpButton.alpha=0.3



        --background

        if composer.getVariable("wentHunting") then
            local bg = display.newImageRect( sceneGroup, backgroundImage, 1500,800 )
            if bg then 
                bg.x = display.contentCenterX
                bg.y = display.contentCenterY
            end
            composer.setVariable("wentHunting",false)
            initTextScreenByCorrectLanguage(sceneGroup)
            CLS()
            hideTextArea()
            local savedCaravan=composer.getVariable("caravan")
            transition.to( caravanGroup, { time=0, x=savedCaravan.x, y=savedCaravan.y, onComplete=transitionCompleted } )
            caravanGroup.x=savedCaravan.x
            caravanGroup.y=savedCaravan.y
            caravan.rotation=savedCaravan.rotation
            setRotationOfCaravan(caravan.rotation)
            unicorns=composer.getVariable("unicorns")
            lblDaysPassed.isVisible=true
            --local MPAfterHunting=composer.getVariable("mainCharMPAfterHunting")
            --local girlNumber = 1
            --local characters = composer.getVariable("characters")
            --local mainChar = characters[girlNumber]

            --mainChar.MP = MPAfterHunting
            
             
            --bg:addEventListener( "tap", tapListener )
    
            return
        end
        local background = display.newImageRect( sceneGroup, backgroundImage, 1500,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
         
        background:addEventListener( "tap", tapListener )

        --level editor toolbar
        toolbarOffsetX=100
        toolbarOffsetY=100
        btnWhite = display.newImageRect( sceneGroup, "img/block-white.png", 32,32 )
        btnWhite:addEventListener( "tap", toolbarTapListener )
        toolbarOffsetX=toolbarOffsetX+32
        btnWhite.x = toolbarOffsetX
        btnWhite.y = toolbarOffsetY
        btnWhite.myName="colorWhite"
        btnRed = display.newImageRect( sceneGroup, "img/block-red.png", 32,32 )
        btnRed:addEventListener( "tap", toolbarTapListener )
        toolbarOffsetX=toolbarOffsetX+32
        btnRed.x = toolbarOffsetX
        btnRed.y = toolbarOffsetY
        btnRed.myName="colorRed"
        btnGreen = display.newImageRect( sceneGroup, "img/block-green.png", 32,32 )
        btnGreen:addEventListener( "tap", toolbarTapListener )
        toolbarOffsetX=toolbarOffsetX+32
        btnGreen.x = toolbarOffsetX
        btnGreen.y = toolbarOffsetY
        btnGreen.myName="colorGreen"
        btnBlue = display.newImageRect( sceneGroup, "img/block-blue.png", 32,32 )
        btnBlue:addEventListener( "tap", toolbarTapListener )
        toolbarOffsetX=toolbarOffsetX+32
        btnBlue.x = toolbarOffsetX
        btnBlue.y = toolbarOffsetY
        btnBlue.myName="colorBlue"
        btnYellow = display.newImageRect( sceneGroup, "img/block.png", 32,32 )
        btnYellow:addEventListener( "tap", toolbarTapListener )
        toolbarOffsetX=toolbarOffsetX+32
        btnYellow.x = toolbarOffsetX
        btnYellow.y = toolbarOffsetY
        btnYellow.myName="colorYellow"
    


        
        if composer.getVariable( "gettingInput" ) then--change name of this variabel if gettig more inputs in both here and where called
            --initTextScreen(sceneGroup,"JP")
            --showTextArea()
            --CLS()
            lblLabel.text=composer.getVariable("inputBuffer")
            composer.setVariable( "gettingInput", false )
            local savedCaravan=composer.getVariable("caravan")
            restoreSceneAfterExist(sceneGroup,savedCaravan)
            disableContinueButton()
            return
        end

        if composer.getVariable("enteredFrozenTundra") then
            composer.setVariable("enteredFrozenTundra", false)
            gameOver()
            return
        end

        if composer.getVariable("enteredattackedByAngryGoblynEvent") then
            composer.setVariable("enteredattackedByAngryGoblynEvent", false)
            girlNumber=2
            local characters = composer.getVariable("characters")
            local warriorGirl = characters[girlNumber]
            girlNumber=4
            local characters = composer.getVariable("characters")
            local priesitessGirl = characters[girlNumber]
            warriorGirl.isAlive=composer.getVariable("warriodGirlDies")
            warriorGirl.MP=composer.getVariable("warriodGirlMP", warriorGirl.MP)
            priesitessGirl.MP=composer.getVariable("priestGirlMP", priesitessGirl.MP)
            if composer.getVariable("completlyFailed") then
                setGamePausedState(true)
                gameOver() 
            else
                repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"savedPoint")
            end
            return
        end

        if composer.getVariable("enteredMainGameEnding") then
            composer.setVariable("enteredMainGameEnding", false)
            hideEverything()
            composer.gotoScene("menu")
            return
        end
        
        if composer.getVariable("enteredAlternateGameEnding") then
            composer.setVariable("enteredMountain1", false)
            hideEverything()
            composer.gotoScene("menu")
            return
        end

        if composer.getVariable("enteredMountain1") then
            composer.setVariable("enteredMountain1", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"mountain1_exit")
            return
        end

        if composer.getVariable("enteredMountain2") then
            composer.setVariable("enteredMountain2", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"mountain2_exit")
            return
        end

        if composer.getVariable("enteredMountain3") then
            composer.setVariable("enteredMountain3", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"mountain3_exit")
            return
        end


        if composer.getVariable("enteredElvenTown1") then
            composer.setVariable("enteredElvenTown1", false)
            print("here7")
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"elf_t1_exit")
            return
        end
        
        if composer.getVariable("enteredElvenTown2") then
            composer.setVariable("enteredElvenTown2", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"elf_t2_exit")
            return
        end

        if composer.getVariable("enteredElvenTown3") then
            composer.setVariable("enteredElvenTown3", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"elf_t3_exit")
            return
        end
        if composer.getVariable("enteredGoblinTown") then
            composer.setVariable("enteredGoblinTown", false)
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"gob_t_exit")
            return
        end

        if composer.getVariable( "enteredMistalsEnd") then--change name of this variabel if gettig more inputs in both here and where called
            composer.setVariable( "enteredMistalsEnd", false )
            repeatedStuffDoneWhenLeavingTownsAndLandmarks(sceneGroup,"mist_end_exit")
            return
        end

        if composer.getVariable("inputBuffer") ~= "input unset" then           
            if composer.getVariable( "language" ) == "English" then
                initTextScreen(sceneGroup,"EN")
                showTextArea()
                CLS()
                SLOWPRINT(composer.getVariable("inputBuffer"))
                verifyPurchaseEN(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Japanese" then
                initTextScreen(sceneGroup,"JP")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyPurchaseJP(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Spanish" then
                initTextScreen(sceneGroup,"ES")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyPurchaseES(composer.getVariable("inputBuffer"))
                return
           end
        end
        --cleanupInvisibleObjects(display.getCurrentStage(),sceneGroup)
        
        --clear this when the main game screen enters so that the name does nto apepar in teh store
        composer.setVariable("defaultName","")

        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            setGamePausedState(true)
            initTextScreen(sceneGroup,"EN")
            showTextArea()
            CLS()
            gameStartEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            setGamePausedState(true)
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            gameStartJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            setGamePausedState(true)
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            gameStartES()
        end
	end
    --disableContinueButton()
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
--(done)event someoen gets cursed, curses should be healed by either
    --(done)camping 30 percent chance or 
    --(done)or the healer girl can use some of her MP to uncurse someone 100 percent uses 30 MP
    --(done)otherwise HP of the cursed girl will keep on draning until she dies
--(done)event you get robbed, potions and gold can dissapear
--(done)make a status window(showTextarea()) for you to see how your unicorns are doing, how long before hte turnda freezes too
--(done)add obstacles on caravan's route so you cant go off the route, maybe even have an accident if you go off it
    --I am lazy but the best way to do this would be to have a n event of fallling in a ditch, and time going by to restore getting back on the path
    --make a level editor to design the map collision sprites
--(nah)add trading on route?
--(done)add camping, add tame  wild unicorn
    --(done)add paczel for hunting, maybe make slimes food and ghosts jot eddible
    --(done)really integrate paczel into the game, includeieng HP for health in paczel and MP for magic in paczel
    --(done)implement getting hungry, food
--(done)add use of potions to menu

--(done)add cant camp when offtrail.
--(done)fall off cliffs if you go thru mountains
--(done)easy to get stuck in a rut and lose time
--(nah, too much effort and I already ahve tresures and secrets to incetivise going off road)pending)I guess land slides can force you to go  off route


--(done)voy a hacer mas facil domesticar muchos unicornios de una vez... porque esta dificil asi como esta

--(done)implement day counting, maybe a day per minute
--(done)take make a day go by when you camp
--(done made it 3KG a day,1 kilogram per meal, but only check it once per day)implement eating, maybe once or 3 times a day? once is easier

--(done)add speedofgame , and regualte gameloop so that it works every other frame if speed is 2
--(I think I fixed it) fix problem of negative potions (probably affects both MP and HP potions) https://x0.at/7bRR.png
--(done) put some secret tresurechests on the map that can teleport you or give you lots of stuff,make it worth while to go off trail, 
    --maybe add some easter egg on these
--(nah, too much bother)pending,maybe add options to select who you want to use MP or HP potions on, this will make the game harder but more like an RPG
--(donne)bring new map in, crop it to fit the same size as current one, adjust map objects
--(this is more of a feature than a bug I think)the caravan only warns once when going off road, and also it does not mention whne you go back on road
--(pending,do thtis??? maybe not, effort)add moster or meat count at top of paczel screen
--(fix, making unicorns get more tired if they are going faster, it seems to be the same regardless of speed.done)handle unicorns getting tired, it should be that the more unicorns you have the more they share the workload of  pulling the caravan
    --if the unicorns get too tired they can die, maybe each unicon can have it's own HP
    --healer girl can heal a unicon using MP
    --you can heal all unicon using HPpotions
    --each unicorn depending on composer.getVariable("NumberOfUnicorns")  will have its own HP the more unicorns you have the less they will get tired because they share to pulling the caravan, and the faster you go the faster they get tired. when one gets too tired he will die.
--(fixed)bug day gets set back to 1 after going into a town, probably needs to be changed ot a composer variable
--(fixed)(this is hte most buging bug)bug with status button, leaveing a continue button I think
    --sometimes it goes back purchase menu when clicking the continue button on screen
        --this seems to happen only after teleporting or levaing towns
    --trying to fix the levelEditor part made it so that the into part broke too
--(fixed)bug the arc tool gets reset after going to towns or landmarks I think.
--bug(I am not sure what caused this, it should not have happened) also this hunting but https://x0.at/FiY7.png
--(I think I fixed it, but have not tested it yet)bug you go off road when on the northern tundra
--add functions to save/load game
    --implement warning too
--add quit game button, takes you back to menu screen
    --implement warning too
--(pending)(temporarily set this to 14 days)figuure out how many days should go by until tundra freezes, maybe this can vary by difficulty
--(confirmed)there seems to be too much food in easy mode, you dont need to buy any food or go hunting and you can finish the game
--(done)event attacked by angry goblin)change background image maybe? instead of switching to another scene, each adventurer should have a different attack power. like hte girl form ironreach shoudl have most power to easily defeat goblins, or maybe the tamer can tame them or the girl; that can call divine power can scare them away)
    --for this it woudl be easiest to make attack be by ironrech girl, tame by tamer, scare by divine power girl
    --tame and divine power shoudl cost MP of those girls oh yeah and mayeb hte random girl too         
    --when you get attacked by goblins, you will get to choose who y ou wnat to solev the problem, the warrior by attackign hte golin, the tamer by appaeaseing the goblin, or the saiotn by scaring away the goblins with divine light or hte random girl which gives 50 percent success 50 percent failue.... but if one of them dies, you wont be able to use her powers anymroe
--add labels to the menu buttons
--(fixed,seems I needed to do translate.to instead of just setting hte x and y of caracan group...)bug the caravan position no longer persists between scene changes for some reason...
--(fixed, Ichanged not keyword to ~= for some reason they seem to work differently)new bug, now after teletrasporting to the even town, it reenters the elven town for some reason, instead of going to the exit point
--(this is fixed when eliminating the set game paused to false in transitioncomplete function, but it is still a problem if I dont wnat it to trigger when text is on screen, may need to make seperat pause variable juts for that.bug the angry troll event interrupts the intro screen
--(fixed in last minutes of today)bug still trigering elf t1 eventho I caravangroup is at elf t1 exit... why? I had already fixed this, but it is happening again, and i　did nto document what I did to fix it I think...
--(fixed, needed to make the speed variable global)bug the caravan seems to still be moving a bit after reaching a landmark,the speed indicates 0 0 0.5 in terminal
--(fixed, it got fixed together with the new bug I fixed with the story mode)bug the store gives a bug when buying too much , more than your budget, somehting in slowprint
--(fixed after adding several disableokbutton intot he code)...ignore this:maybe still slightly buggy.I think I fixed it by setting the visible button stuff in slowprint)bug after clickign info button after teleporting  into elevn town the continue button takes me back to the purchase unicorns window...maybe need to eliminate enableokbutton from the uniconstable I think
--(fixed I think, by adding composer.setVariable("gameStarted",true))bug, events happen eventho the game should be paused in the initial titles
--(fixed by adding functionality to handle fastprint in slowprint.lua)bug, info screen is lacking a continue button.
--(done)remove unneeded labels and color boxes
    --label for level editor too
--(done)repurpose save , load labels to save and load games
    --(done)also add quit option
    --(done)add warnings
--(done)add default names to story mode
--(I think it is fixed, untested yet), there is an overlap in the end of trial period screen and purchase button
--(done)add a menu to go to each kind of store
--(done in town, I dont think it is nesseary in the store now)add the ammount of the item we have inside hte store and in the menu
--(fixed)new bug, name of character appears in shopping screen, I think I can fix it by changing the value of hte defaultname thing right when the game starts
--(done)try iuncreasing the speed of the fireball in paczel, see if it still can get the monsters
--(done)makes ure the fireball goes off screen after fireing it in paczel
--(done)dont allow events to happen if continue button is visible, this should prevent the bus of hte troll attackign and hte continue button nto dismissing the scrren(I think)
    --(done)also pause game when event occurs for the same reason, we dont want tow things happening at once
--(done)move paczel controls to adjust for resolution
--(fixed)bug,after winning in paczel, the caravan is returning to mistralsEndStartPoint

--(done)add speed settings

--(done), autocapicalize first letter of names
--(done,decided on making it the maximum/4, maybe do maybe not)set maximum stolen ammount
    --both for money and potions
--(I cant find hte cuase of this in the code)bug, it seems it did not display when amigojapan was uncursed but he got uncursed anyway
--(fixed)in spanish, it does not update the lable when going to church
--increase random game eventrs by about double of now mayve even more
--remove left and right shift form input keys so that people stop complaining
--[[
月みたいなので、馬車をかいてんする
5:24 PM <amigojapan> hiro_at_work: 上矢印でスピードをます
5:25 PM <hiro_at_work> なるほど
5:25 PM <amigojapan> hiro_at_work: 下矢印でスピードを落とす、完全に止まると魔法のメニューが現れます
5:25 PM <amigojapan> hiro_at_work: 赤いボタンでステータス見れます
5:26 PM <amigojapan> hiro_at_work: キャンプをよくしないとユニコーンが死にます
5:27 PM <amigojapan> hiro_at_work: 赤い線に沿ってゴールに進む
5:30 PM → PJBoy joined (~PJBoy@user/pjboy)
5:31 PM <amigojapan> hiro_at_work: 魔法は野生のユニコーンを飼いならす魔法と呪いを解かす魔法。緑のはHPを回復するポーション紫のはMPを回復するポーション、あとは狩猟で食べ物をかるのが完成は明日でしょう…
]]

