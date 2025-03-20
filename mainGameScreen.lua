local composer = require("composer")
--require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
require("helperFunctions")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--items to customize purchase
local backgroundImage="backgrounds/map-of-eternia.png"
local speed=0
local granualrMovement=0.5
local caravanMoveInMilliseconds=1000
local caravanMovePixels=1
local caravan=nil
-- Constants
local INITIAL_HP = 100        -- starting HP for each unicorn
local BASE_FATIGUE_RATE = 10  -- base rate at which unicorns get tired (HP lost per unit speed per second)

-- Global unicorn table
local unicorns = {}
local gameover=false
------------------------------------------------------------
-- Function: createUnicorns
-- Description:
--   Initializes the unicorns table based on the value of
--   composer.getVariable("NumberOfUnicorns").
------------------------------------------------------------
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
--   Determines how fast each unicorn gets tired based on the
--   current speed of the caravan and the number of unicorns.
--
-- Parameters:
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
-- Parameters:
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
-- Parameters:
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
-- Parameters:
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
    gamePaused=false
    if speed==0 then
        showRestingMenu()
    end
end

function pauseAndShowQuickMessage(message)
    RESETQUE()
    gamePaused=true
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    SLOWPRINT(50,message,unPauseGame)
    enableContinueButton()
end
function pauseAndShowQuickMessageThenCallFunction(message,functionL)
    RESETQUE()
    gamePaused=true
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    SLOWPRINT(50,message,functionL)
    enableContinueButton()
end
function pauseAndShowQuickMessageFast(message)
    RESETQUE()
    gamePaused=true
    showTextArea()
    CLS()
    message=message.."."--just a quick hack to handle the need to have an extra character or some reaosn in the SLOWPRINT
    PRINTFAST(message,100,100)
    enableContinueButton()
end

-- Function to handle the robbery event
function robberyEvent()
    local items = {"gold", "HPpotions", "MPpotions"}
    local itemToSteal = items[math.random(1, #items)]
    if itemToSteal == "gold" then
        local gold = composer.getVariable("gold")
        if gold > 0 then
            local amount = math.random(1, gold)
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
            local amount = math.random(1, HPpotions)
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
            local amount = math.random(1, MPpotions)
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
    end
    -- Optionally, display a message to the player using showTextArea()
end

function testEvent()
    --print("test event called")
    --gamePaused=true
end
function detectCollision2(movingObject,sprite)
	x1=movingObject.x - (movingObject.width / 2)
	y1=movingObject.y - (movingObject.height / 2)
	width1=movingObject.width
	height1=movingObject.height
	x2=sprite.x - (sprite.width / 2)
	y2=sprite.y - (sprite.height / 2)
	width2=sprite.width 
	height2=sprite.height
	if x1 + width1 > x2 and x1 < x2 + width2 and y1 + height1 > y2 and y1 < y2 + height2 then 
        return true
    else
        return false
    end
end
local offRoad=true

function gameloop()
	if gamePaused then
		return
	end
    if caravan then -- start doing this once hte caravan appears on screen
        local angle=caravan.rotation
        local angle_radians=math.rad(angle + 90 + 180)--(bugfix:I added 180 degrees cause the caravan was going backwords)converts degrees to radians
        local distance=caravanMovePixels*speed
        local newx=caravan.x+distance*math.cos(angle_radians)
        local newy=caravan.y+distance*math.sin(angle_radians)
        caravan.x=newx;
        caravan.y=newy;
        --for index, value in ipairs(boxes) do
            
        --end
        --detectCollision2(caravan,)
    end

    -- Random event triggers
    local randomNumber = math.random(1, 10000)
    if randomNumber < 50 then
        curseEvent()
    elseif randomNumber < 100 then
        robberyEvent()
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

local gameLoopTimer= timer.performWithDelay( caravanMoveInMilliseconds, gameloop, 0 )

local daysPassed=0
language=composer.getVariable( "language" )
translate=i18n_setlang(language)
--translate["Choose Category"]
local lblDaysPassed = display.newText( tostring(daysPassed)..translate["Days Passed"], 200, 50, "fonts/ume-tgc5.ttf", 50 )

function gameOver()
    hideEverything()
    hideRestingMenu()
    hideTextArea()
    composer.removeScene( composer.getSceneName("current") )
    composer.gotoScene("GameOver")
end

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
local dayTimer= timer.performWithDelay( 60000, dayPassed, 0 ) -- day takes one minute

local lastTime = system.getTimer() -- Get the current time in milliseconds

-- In your game loop or an "enterFrame" listener:
local function updateFrame(event)
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
    -- Initialize the characters table using names from Composer variables
    local characters = {
        {name = composer.getVariable("MCname") or "Default MC", isAlive=true, HP = 50, maxHP = 100, MP = 100, maxMP = 100, isCursed = false},
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

function showControls()
    hideTextArea()
    disableContinueButton()
    gamePaused=false
end
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
    QUESLOWPRINT("eternity\" before the \"Northern ^")
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
    QUESLOWPRINT("\"The valley of Eternity\"に^")
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
    QUESLOWPRINT("eternity\" de que la \"Northern ^")
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
    gamePaused=false--this is cause the following function chechs for if game is paused, quickhack
    GO=dayPassed()
    if GO then
        return
    end
    lblDaysPassed.text=tostring(daysPassed)..translate["Days Passed"]
    local message
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
    caravan.isVisible=false
    myUpButton.isVisible=false
    myDownButton.isVisible=false
    myFireButton.isVisible=false
    arc.isVisible=false
    lblDaysPassed.isVisible=false
    hideRestingMenu()
end
function goHuntingPaczel()
    composer.setVariable( "gameMode", "Paczel" )
    gameMode = composer.getVariable( "gameMode" )
    print("gameMode:"..gameMode)
    composer.setVariable("numberOfPowerUps",5)
    composer.setVariable("numberOfMonsters",5)
    hideEverything()
    composer.removeScene(composer.getSceneName( "current" ))
    composer.setVariable("wentHunting", true)
    composer.setVariable("caravan",caravan)    
    composer.setVariable("unicorns",unicorns)
    hideTextArea()
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
end

function showRestingMenu()
    if not campingButton then
        offsetx=235
        offsety=700
        local paint = {
            type = "image",
            filename = "img/camping.png"
        }
        campingButton = display.newRect( offsetx, offsety, 200, 200 )
        campingButton.fill = paint
        campingButton.myName="campingButton"
        campingButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/taming-wild-unicorn.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        tameUnicornButton = display.newRect( offsetx, offsety, 200, 200 )
        tameUnicornButton.fill = paint
        tameUnicornButton.myName="tameUnicornButton"
        tameUnicornButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/unCurse.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        unCurseButton = display.newRect( offsetx, offsety, 200, 200 )
        unCurseButton.fill = paint
        unCurseButton.myName="unCurseButton"
        unCurseButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/useHPpotion.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        useHPpotionButton = display.newRect( offsetx, offsety, 200, 200 )
        useHPpotionButton.fill = paint
        useHPpotionButton.myName="useHPpotionButton"
        useHPpotionButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/useMPpotion.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        useMPpotionButton = display.newRect( offsetx, offsety, 200, 200 )
        useMPpotionButton.fill = paint
        useMPpotionButton.myName="useMPpotionButton"
        useMPpotionButton:addEventListener( "touch", menuButtonTouchListener ) 
        local paint = {
            type = "image",
            filename = "img/goHunting.png"
        }
        offsetx=offsetx+250--50 is space between buttons
        goHuntingButton = display.newRect( offsetx, offsety, 200, 200 )
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
if system.getInfo("environment") == "device" then
    arcYPosition=50
    arcXPosition=850
else
    arcYPosition=50
    arcXPosition=50
end

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
		end
		return true	
	elseif "ended" == phase or "cancelled" == phase then
	end
	return true
end
arc:addEventListener( "touch", dragObject )

local function tapListener( event )
 
    -- Code executed when the button is tapped
    local message="x: " .. tostring(event.x) .. "y: " .. tostring(event.y)
    --pauseAndShowQuickMessage(message)
    print(message)  -- "event.target" is the tapped object
    return true
end
local mistralsEnd={}
if system.getInfo("environment") == "device" then
    mistralsEnd.x=897.89
    mistralsEnd.y=773.03
else
    mistralsEnd.x=897.89
    mistralsEnd.y=773.03
    --mistralsEnd.x=411.92584228516
    --mistralsEnd.y=765.43487548828    
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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        -- Call this once when starting the scene or when unicorn count changes.
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
        caravan = display.newRect( mistralsEnd.x, mistralsEnd.y, 100, 100 )
        caravan.fill = paint
        caravan:rotate( 45 )

        
        local paint = {
            type = "image",
            filename = "img/arrowDown.png"
        }
        myDownButton = display.newRect( 1300+150, 50, 100, 100 )
        myDownButton.fill = paint
        myDownButton:addEventListener( "touch", myDownTouchListener )  -- Add a "touch" listener to the obj

        local paint = {
            type = "image",
            filename = "img/fireButton.png"
        }
        myFireButton = display.newRect( 1300+150+150, 50, 100, 100 )
        myFireButton.fill = paint
        myFireButton:addEventListener( "touch", myFireTouchListener )  -- Add a "touch" listener to the obj

        --myFireButton.alpha=0.3
        --myDownButton.alpha=0.3
        --myUpButton.alpha=0.3


        --background
        local background = display.newImageRect( sceneGroup, backgroundImage, 1500,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
         
        background:addEventListener( "tap", tapListener )
        if composer.getVariable("wentHunting") then
            composer.setVariable("wentHunting",false)
            initTextScreenByCorrectLanguage(sceneGroup)
            CLS()
            hideTextArea()
            local savedCaravan=composer.getVariable("caravan")
            caravan.x=savedCaravan.x
            caravan.y=savedCaravan.y
            caravan.rotation=savedCaravan.rotation
            unicorns=composer.getVariable("unicorns")
            lblDaysPassed.isVisible=true
            --local MPAfterHunting=composer.getVariable("mainCharMPAfterHunting")
            --local girlNumber = 1
            --local characters = composer.getVariable("characters")
            --local mainChar = characters[girlNumber]

            --mainChar.MP = MPAfterHunting
            return
        end

        if composer.getVariable("inputBuffer") ~= "input unset" then           
            if composer.getVariable( "language" ) == "English" then
                initTextScreen(sceneGroup,"EN")
                showTextArea()
                CLS()
                disableContinueButton()
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
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            gamePaused=true
            initTextScreen(sceneGroup,"EN")
            showTextArea()
            CLS()
            gameStartEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            gamePaused=true
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            gameStartJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            gamePaused=true
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            gameStartES()
        end
	end
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
--(partly done)event someoen gets cursed, curses should be healed by either
    --(done)camping 30 percent chance or 
    --(done)or the healer girl can use soem of her MP to uncurse someone 100 percent uses 30 MP
    --(done)otherwise HP of hte cursed girl will keep on draning until she dies
--(done)event you get robbed, potions and gold can dissapear
--(pending)event attacked by angry goblin)change background image maybe? instead of switching to another scene, each adventurer should have a different attack power. like hte girl form ironreach shoudl have most power to easily defeat goblins, or maybe the tamer can tame them or the girl; that can call divine power can scare them away)
    --for this it woudl be easiest to make attack be by ironrech girl, tame by tamer, scare by divine power girl
    --tame and divine power shoudl cost MP of those girls oh yeah and mayeb hte random girl too         
    --when you get attacked by goblins, you will get to choose who y ou wnat to solev the problem, the warrior by attackign hte golin, the tamer by appaeaseing the goblin, or the saiotn by scaring away the goblins with divine light or hte random girl which gives 50 percent success 50 percent failue.... but if one of them dies, you wont be able to use her powers anymroe
--(fix, making unicorns get more tired if they are going faster, it seems to be the same regardless of speed.done)handle unicorns getting tired, it should be that the more unicorns you have the more they share the workload of  pulling the caravan
    --if the unicorns get too tired they can die, maybe each unicon can have it's own HP
    --healer girl can heal a unicon using MP
    --you can heal all unicon using HPpotions
    --each unicorn depending on composer.getVariable("NumberOfUnicorns")  will have its own HP the more unicorns you have the less they will get tired because they share to pulling the caravan, and the faster you go the faster they get tired. when one gets too tired he will die.
--(done)make a status window(showTextarea()) for you to see how your unicorns are doing, how long before hte turnda freezes too
--(penging)add obstacles on caravan's route so you cant go off the route, maybe even have an accident if you go off it
    --I am lazy but the best way to do this would be to have a n event of fallling in a ditch, and time going by to restore getting back on the path
    --make a level editor to design the map collision sprites
--(nah)add trading on route?
--(partly done)add camping, add tame  wild unicorn
    --(done)add paczel for hunting, maybe make slimes food and ghosts jot eddible
    --(done)really integrate paczel into the game, includeieng HP for health in paczel and MP for magic in paczel
    --(done)implement getting hungry, food
    --(pending)add moster or meat count at top of paczel screen
--(done)add use of potions to menu

--**add cant camp when offtrail.
--fall off cliffs if you go thru mountains
--easy to get stuck in a pit and lose time
--I guess land slides can force you to go  off route

--add quit game button, takes you back to menu screen
    --implement warning too

--(done)voy a hacer mas facil domesticar muchos unicornios de una vez... porque esta dificil asi como esta

--(done)implement day counting, maybe a day per minute
--(pending)figuure out how many days should go by until tundra freezes, maybe this can vary by difficulty
--(done)take make a day go by when you camp
--(done made it 3KG a day)implement eating, maybe once or 3 times a day? once is easier

--(pending)add speedofgame , and regualte gameloop so that it works every other frame if speed is 2
--(I think I fixed it) fix problem of negative potions (probably affects both MP and HP potions) https://x0.at/7bRR.png
--(I am not sure what caused this, it should nto have happened) also this hunting but https://x0.at/FiY7.png

--[[
月みたいなので、馬車をかいてんする
5:24 PM <amigojapan> hiro_at_work: 上矢印でスピードをます
5:25 PM <hiro_at_work> なるほど
5:25 PM <amigojapan> hiro_at_work: 下矢印でスピードを止める、完全に止まると魔法のメニューが現れます
5:25 PM <amigojapan> hiro_at_work: 赤いボタンでステータス見れます
5:26 PM <amigojapan> hiro_at_work: キャンプをよくしないとユニコーンが死にます
5:27 PM <amigojapan> hiro_at_work: 赤い線に沿ってゴールに進む
5:30 PM → PJBoy joined (~PJBoy@user/pjboy)
5:31 PM <amigojapan> hiro_at_work: 魔法は野生のユニコーンを飼いならす魔法と呪いを解かす魔法。緑のはHPを回復するポーション紫のはMPを回復するポーション、あとは狩猟で食べ物をかるのが完成は明日でしょう…
]]