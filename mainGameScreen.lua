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

-- Function to handle the curse event
function curseEvent()
    local characters = composer.getVariable("characters")
    local eligibleCharacters = {}
    for i, char in ipairs(characters) do
        if not char.isCursed then
            table.insert(eligibleCharacters, i)
        end
    end
    if #eligibleCharacters > 0 then
        local index = eligibleCharacters[math.random(1, #eligibleCharacters)]
        characters[index].isCursed = true
        local message = characters[index].name .. " has been cursed!"
        pauseAndShowQuickMessage(message)
        -- Optionally, display a message to the player using showTextArea()
    end
end

function  unPauseGame()
    disableContinueButton()
    hideTextArea()
    gamePaused=false
end

function pauseAndShowQuickMessage(message)
    RESETQUE()
    gamePaused=true
    showTextArea()
    CLS()
    SLOWPRINT(50,message,unPauseGame)
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
            local message = "You have been robbed of " .. amount .. " gold!"
            pauseAndShowQuickMessage(message)
        end
    elseif itemToSteal == "HPpotions" then
        local HPpotions = composer.getVariable("HPpotions")
        if HPpotions > 0 then
            local amount = math.random(1, HPpotions)
            composer.setVariable("HPpotions", HPpotions - amount)
            local message = "You have been robbed of " .. amount .. " HP potions!"
            pauseAndShowQuickMessage(message)
        end
    elseif itemToSteal == "MPpotions" then
        local MPpotions = composer.getVariable("MPpotions")
        if MPpotions > 0 then
            local amount = math.random(1, MPpotions)
            composer.setVariable("MPpotions", MPpotions - amount)
            local message = "You have been robbed of " .. amount .. " MP potions!"
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
    --event someoen gets cursed, curses should be healed by either resting or using an HPpotion,
        --or the healer girl can use soem of her MP to heal someone
        --otherwise HP of hte cursed girl will keep on draning until she dies
    --event you get robbed, potions and gold can dissapear
    --event attacked by angry goblin)change background image maybe? instead of switching to another scene, each adventurer should have a different attack power. like hte girl form ironreach shoudl have most power to easily defeat goblins, or maybe the tamer can tame them or the girl; that can call divine power can scare them away)
        --for this it woudl be easiest to make attack be by ironrech girl, tame by tamer, scare by divine power girl
        --tame and divine power shoudl cost MP of those girls oh yeah and mayeb hte random girl too         
        --when you get attacked by goblins, you will get to choose who y ou wnat to solev the problem, the warrior by attackign hte golin, the tamer by appaeaseing the goblin, or the saiotn by scaring away the goblins with divine light or hte random girl which gives 50 percent success 50 percent failue.... but if one of them dies, you wont be able to use her powers anymroe
    --handle unicorns getting tired, it should be that the more unicorns you have the more they share the workload of  pulling the caravan
        --if the unicorns get too tired they can die, maybe each unicon can have it's own HP
        --healer girl can heal a unicon using MP
        --you can heal all unicon using HPpotions
        --cada unicornio va a tenenr sus propoio "HP"(que son los puntos de vida) entre mas unicornios tengas menos se van a cansar porque comparten jalar a la caravana, y entre mas rapido vayas se cansan mas rapido
        --each unicorn will have its own HP the more unicorns you have the less they will get tired because they share to pulling the caravan, and the faster you go the faster they get tired. when one gets too tired he will die.
    --make a status window(showTextarea()) for you to see how your unicorns are doing, how long before hte turnda freezes too
    --add obstacles atounf caravan's route so you cant go off the route, maybe even have an accident if you go off it
        --I am lazy but the pbest way to do this would be to have a n event of fallling in a ditch, and time going by to restore getting back on the path
    --add trading on route?
    -- Random event triggers
    local randomNumber = math.random(1, 10000)
    if randomNumber < 500 then
        curseEvent()
    elseif randomNumber < 1000 then
        robberyEvent()
    end
    -- Handle HP draining for cursed characters
    local characters = composer.getVariable("characters")
    for i = #characters, 1, -1 do
        local char = characters[i]
        if char.isCursed then
            char.HP = char.HP - 1 -- Drain 1 HP per second
            if char.HP <= 0 then
                local message = char.name .. " has died from the curse!"
                pauseAndShowQuickMessage(message)        
                table.remove(characters, i)
                -- Optionally, handle game over if all characters die
            end
        end
    end
end

local gameLoopTimer= timer.performWithDelay( caravanMoveInMilliseconds, gameloop, 0 )

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
        {name = composer.getVariable("MCname") or "Default MC", HP = 100, maxHP = 100, MP = 50, maxMP = 50, isCursed = false},
        {name = composer.getVariable("adventurer1") or "Default Adv1", HP = 80, maxHP = 80, MP = 70, maxMP = 70, isCursed = false},
        {name = composer.getVariable("adventurer2") or "Default Adv2", HP = 90, maxHP = 90, MP = 60, maxMP = 60, isCursed = false},
        {name = composer.getVariable("adventurer3") or "Default Adv3", HP = 70, maxHP = 70, MP = 40, maxMP = 40, isCursed = false},
        {name = composer.getVariable("adventurer4") or "Default Adv4", HP = 60, maxHP = 60, MP = 30, maxMP = 30, isCursed = false}
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
    composer.setVariable( composerVariable, numberOfItemsPurchased)
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
    QUESLOWPRINT("Take resrts to restore HP.^")
    QUESLOWPRINT("If you run out of food, go hunting^")
    QUESLOWPRINT("If you run out of unicorns, you can ^")
    QUESLOWPRINT("tame a wild unicorn.^")
    QUESLOWPRINT("If you run out of food, go hunting.^")
    QUESLOWPRINT("Use potions wisely.^")
    QUESLOWPRINT("You must reach \"The valley of ^")
    QUESLOWPRINT("eternity\" before the \"Northern ^")
    QUESLOWPRINT("Tundra\" freezes over....")
    SLOWPRINT(100,"",showControls)
end

function gameStartJP()
    RESETQUE()
    QUESLOWPRINT("^金"..composer.getVariable( "gold").."グラムを持っている：^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^「"..itemSoldJP.."」と言うアイテムが^")
    QUESLOWPRINT(itemCounterVariableJP.."が金".. itemPrice .."グラムする。^")
    QUESLOWPRINT(itemCounterVariableJP.."何個買いたいのか？^")
    SLOWPRINT(100,"",promptItemCountdJP)
end

function gameStartES()
    RESETQUE()
    QUESLOWPRINT("^Tienes:"..composer.getVariable( "gold").." gramos de oro:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^El artículo llamado \""..itemSoldES.."\"^")
    QUESLOWPRINT("cuesta ".. itemPrice .." gramos de oro ^")
    QUESLOWPRINT("por cada "..itemCounterVariableES..", cuantos ^")
    QUESLOWPRINT(itemCounterVariableES.." quieres comprar?^")
    SLOWPRINT(100,"",promptItemCountdES)
end
function unicornsFaster()
    speed=speed+granualrMovement
end
function unicornsSlower()
    speed=speed-granualrMovement
end

local function myUpTouchListener( event )
    if ( event.phase == "began" ) then
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		--if isWithinBounds(myUpButton, event) == false then
		--end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
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
local function myFireTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerMagic then
			timer.cancel( fireTimerMagic )
		end
		fireball()
		currentButton=myFireButton
		fireTimerMagic = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, fireball, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myFireButton, event) == false then
			if fireTimerMagic then
				timer.cancel( fireTimerMagic )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerMagic then
			timer.cancel( fireTimerMagic )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
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
    print( "x: " .. tostring(event.x) .. "y: " .. tostring(event.y) )  -- "event.target" is the tapped object
    return true
end
local mistralsEnd={}
mistralsEnd.x=411.92584228516
mistralsEnd.y=765.43487548828

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
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
            --enableContinueButton()
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