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
    enableContinueButton()
    gameStartEN()
end
local function alertBoxNoClickedCompleteJP()
    enableContinueButton()
    gameStartJP()
end
local function alertBoxNoClickedCompleteES()
    enableContinueButton()
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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        --background
        local background = display.newImageRect( sceneGroup, backgroundImage, 1500,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
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
            enableContinueButton()
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