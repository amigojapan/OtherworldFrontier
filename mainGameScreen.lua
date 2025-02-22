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

function testEvent()
    print("test event called")
    gamePaused=true
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
    local randomNumber=math.random(1,10000)
    if randomNumber<5 then -- this should happen 5 percent of tiem time?
        testEvent()
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
end
function gameStartEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^Stear the caravan carefullu, ^")
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
            initTextScreen(sceneGroup,"EN")
            --enableContinueButton()
            showTextArea()
            CLS()
            gameStartEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            gameStartJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
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