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
composer.setVariable("backgroundImage","backgrounds/unicorn-stable.png")
composer.setVariable("nextScreenName","shopMenu")
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
function gotoShop()
    disableContinueButton()
    composer.gotoScene("buyStoreItemGeneral")
end
-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        --background
        --local background = display.newImageRect( sceneGroup,composer.getVariable("backgroundImage") , 1000,800 )
		--background.x = display.contentCenterX
		--background.y = display.contentCenterY
        -- Code here runs when the scene is entirely on screen
        print("language:"..composer.getVariable( "language" ))
        gotoShop()
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
        gotoShop()
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