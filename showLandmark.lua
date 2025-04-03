local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


composer.setVariable("setVariable","NumberOfUnicorns")
composer.setVariable("nextScreenName","levelEditor")
composer.setVariable("itemPrice",100)--100 grams of gold per unicorn
composer.setVariable("itemSoldEN","unicorn")
composer.setVariable("itemCounterVariableEN","unicorn")
composer.setVariable("itemSoldJP","ユニコーン")
composer.setVariable("itemCounterVariableJP","「ユニコーン一頭」")
composer.setVariable("itemSoldES","unicornios")
composer.setVariable("itemCounterVariableES","\"unicornios\"")


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end

-- Handler that gets notified when the alert closes
function returnToGame()
    --**change once done with level editor to main game screen
    composer.gotoScene("levelEditor")
end
function shopAriveEN()
    SLOWPRINT(100,"",returnToGame)
end

function shopAriveJP()
    SLOWPRINT(100,"",returnToGame)
end

function shopAriveES()
    SLOWPRINT(100,"",returnToGame)
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
        print("backround image:"..composer.getVariable("backgroundImage"))
        local background = display.newImageRect( sceneGroup, composer.getVariable("backgroundImage"), 1000,800 )
        if background then
            background.x = display.contentCenterX
            background.y = display.contentCenterY
        end
        --cleanupInvisibleObjects(display.getCurrentStage(),sceneGroup)
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            initTextScreen(sceneGroup,"EN")
            enableContinueButton()
            showTextArea()
            CLS()
            shopAriveEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            shopAriveJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            shopAriveES()
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