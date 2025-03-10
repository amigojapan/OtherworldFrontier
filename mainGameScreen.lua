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
    end
    --(partly done)event someoen gets cursed, curses should be healed by either
        --(pending)camping 30 percent chance or 
        --(pending)using an HPpotion 100 percent chance,
        --(pending)or the healer girl can use soem of her MP to heal someone 100 percent uses 30 MP
        --(done)otherwise HP of hte cursed girl will keep on draning until she dies
    --(done)event you get robbed, potions and gold can dissapear
    --(pending)event attacked by angry goblin)change background image maybe? instead of switching to another scene, each adventurer should have a different attack power. like hte girl form ironreach shoudl have most power to easily defeat goblins, or maybe the tamer can tame them or the girl; that can call divine power can scare them away)
        --for this it woudl be easiest to make attack be by ironrech girl, tame by tamer, scare by divine power girl
        --tame and divine power shoudl cost MP of those girls oh yeah and mayeb hte random girl too         
        --when you get attacked by goblins, you will get to choose who y ou wnat to solev the problem, the warrior by attackign hte golin, the tamer by appaeaseing the goblin, or the saiotn by scaring away the goblins with divine light or hte random girl which gives 50 percent success 50 percent failue.... but if one of them dies, you wont be able to use her powers anymroe
    --handle unicorns getting tired, it should be that the more unicorns you have the more they share the workload of  pulling the caravan
        --if the unicorns get too tired they can die, maybe each unicon can have it's own HP
        --healer girl can heal a unicon using MP
        --you can heal all unicon using HPpotions
        --cada unicornio va a tenenr sus propoio "HP"(que son los puntos de vida) entre mas unicornios tengas menos se van a cansar porque comparten jalar a la caravana, y entre mas rapido vayas se cansan mas rapido
        --each unicorn depending on composer.getVariable("NumberOfUnicorns")  will have its own HP the more unicorns you have the less they will get tired because they share to pulling the caravan, and the faster you go the faster they get tired. when one gets too tired he will die.
    --(pending)make a status window(showTextarea()) for you to see how your unicorns are doing, how long before hte turnda freezes too
    --(penging)add obstacles atounf caravan's route so you cant go off the route, maybe even have an accident if you go off it
        --I am lazy but the pbest way to do this would be to have a n event of fallling in a ditch, and time going by to restore getting back on the path
    --(nah)add trading on route?
    --**add camping, add tame  wild unicorn, add paczel
    -- Replace each character using the mapping

    -- Random event triggers
    local randomNumber = math.random(1, 10000)
    if randomNumber < 100 then
        curseEvent()
    elseif randomNumber < 200 then
        robberyEvent()
    end
    -- Handle HP draining for cursed characters
    local characters = composer.getVariable("characters")
    for i = #characters, 1, -1 do
        local char = characters[i]
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

local gameLoopTimer= timer.performWithDelay( caravanMoveInMilliseconds, gameloop, 0 )

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
        {name = composer.getVariable("MCname") or "Default MC", isAlive=true, HP = 100, maxHP = 100, MP = 50, maxMP = 50, isCursed = false},
        {name = composer.getVariable("adventurer1") or "Default Adv1", isAlive=true, HP = 80, maxHP = 80, MP = 70, maxMP = 70, isCursed = false},
        {name = composer.getVariable("adventurer2") or "Default Adv2", isAlive=true, HP = 90, maxHP = 90, MP = 60, maxMP = 60, isCursed = false},
        {name = composer.getVariable("adventurer3") or "Default Adv3", isAlive=true, HP = 70, maxHP = 70, MP = 40, maxMP = 40, isCursed = false},
        {name = composer.getVariable("adventurer4") or "Default Adv4", isAlive=true, HP = 60, maxHP = 60, MP = 30, maxMP = 30, isCursed = false}
    }
    composer.setVariable("characters", characters)
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
            if true then --char.isCursed
                message=message..char.name
                if composer.getVariable( "language" ) == "English" then
                    message=message.." has been healed from the curse!^"
                elseif composer.getVariable( "language" ) == "Japanese" then
                    message=message.."の呪いがとけた！改"
                elseif composer.getVariable( "language" ) == "Spanish" then
                    message=message.." se ha aliviado de la maldicion!^"
                end            
            end
        end
    end
    return message
end
function healCharacterHPByIndex(index)
    local characters = composer.getVariable("characters")
    char=characters[index] 
    if char.isAlive then
        if true then --char.isCursed
            char.HP=100       
        end
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
    local message
    if composer.getVariable( "language" ) == "English" then
        message="A day went by. HP restored^"
    elseif composer.getVariable( "language" ) == "Japanese" then
        message="一日過ぎた。HPが回復した。改"
    elseif composer.getVariable( "language" ) == "Spanish" then
        message="Paso un dia.HP restaurado.^"
    end            
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
local function myCampingTouchListener( event )
    if ( event.phase == "began" ) then
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		--if isWithinBounds(myUpButton, event) == false then
		--end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		hideRestingMenu()
        campOverNighht()
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end

function hideRestingMenu()
    campingButton.isVisible=false
end

function showRestingMenu()
    if not campingButton then
        offsetx=300
        offsety=700
        local paint = {
            type = "image",
            filename = "img/camping.png"
        }
        campingButton = display.newRect( offsetx, offsety, 200, 200 )
        campingButton.fill = paint
        campingButton:addEventListener( "touch", myCampingTouchListener ) 
    else
        campingButton.isVisible=true
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
        message=message.."You have:^Gold:" .. composer.getVariable("gold") .. " grams.^HP pontions:" .. composer.getVariable("HPpotions") .. "^MP potions:" ..  composer.getVariable("MPpotions")
    elseif composer.getVariable( "language" ) == "Japanese" then
        message=message.."所有物:^金：" .. composer.getVariable("gold") .. "グラム。^HPポーション：" .. composer.getVariable("HPpotions") .. "^MPポーション：" ..  composer.getVariable("MPpotions")
    elseif composer.getVariable( "language" ) == "Spanish" then
        message=message.."Tienes:^oro:" .. composer.getVariable("gold") .. " gramos.^pociones de HP:" .. composer.getVariable("HPpotions") .. "^pociones de MP:" ..  composer.getVariable("MPpotions")
    end
    pauseAndShowQuickMessageFast(message)        
    --pauseAndShowQuickMessage(message)
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
arcXPosition=50
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
        myUpButton = display.newRect( 400+offsetx, 200+offsety, 100, 100 )
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
        myDownButton = display.newRect( 400+offsetx, 400+offsety, 100, 100 )
        myDownButton.fill = paint
        myDownButton:addEventListener( "touch", myDownTouchListener )  -- Add a "touch" listener to the obj

        local paint = {
            type = "image",
            filename = "img/fireButton.png"
        }
        myFireButton = display.newRect( offsetx-270, 300+offsety, 100, 100 )
        myFireButton.fill = paint
        myFireButton:addEventListener( "touch", myFireTouchListener )  -- Add a "touch" listener to the obj

        myFireButton.alpha=0.3
        myDownButton.alpha=0.3
        myUpButton.alpha=0.3


        --background
        local background = display.newImageRect( sceneGroup, backgroundImage, 1500,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
         
        background:addEventListener( "tap", tapListener )


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
--first fix this to be all langauges, then fix the same stuff for the parts of the game that are finished