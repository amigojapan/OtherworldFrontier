local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

local background

function scene:create(event)
    local sceneGroup = self.view
end

local transitioning = false
local function returnToGame()
    print("returnToGame called")
    if transitioning then
        print("Already transitioning, skipping")
        return
    end
    transitioning = true
    hideTextArea()
    composer.removeScene(composer.getSceneName("current"))
    composer.gotoScene(composer.getSceneName("previous"))
end

function shopAriveEN()
    RESETQUE()
    QUESLOWPRINT("^You have arrived at Melstorms Peak!^")
    QUESLOWPRINT("^^test line2^")
    QUESLOWPRINT("^^test line3^")
    QUESLOWPRINT("^flush this!^")
    SLOWPRINT(100, "", returnToGame)
end

function shopAriveJP()
    RESETQUE()
    QUESLOWPRINT("^Melstorms Peakにようこそ!^")
    QUESLOWPRINT("^^test line2^")
    QUESLOWPRINT("^^test line3^")
    SLOWPRINT(100, "", returnToGame)
end

function shopAriveES()
    RESETQUE()
    QUESLOWPRINT("^Bienvenida a Melstorms Peak!^")
    QUESLOWPRINT("^^test line2^")
    QUESLOWPRINT("^^test line3^")
    SLOWPRINT(100, "", returnToGame)
end

local landmarksShown = false
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        print("scene:show in showLandmark")
    elseif (phase == "did") then
        if landmarksShown then
            return
        end
        landmarksShown = true
        print("background image: " .. composer.getVariable("backgroundImage"))
        background = display.newImageRect(sceneGroup, composer.getVariable("backgroundImage"), 1000, 800)
        if background then
            background.x = display.contentCenterX
            background.y = display.contentCenterY
            print("background.parent == sceneGroup:", background.parent == sceneGroup)
        end
        print("language: " .. composer.getVariable("language"))
        if composer.getVariable("language") == "English" then
            initTextScreen(sceneGroup, "EN")
            enableContinueButton()
            showTextArea()
            CLS()
            shopAriveEN()
        elseif composer.getVariable("language") == "Japanese" then
            initTextScreen(sceneGroup, "JP")
            showTextArea()
            CLS()
            shopAriveJP()
        elseif composer.getVariable("language") == "Spanish" then
            initTextScreen(sceneGroup, "ES")
            showTextArea()
            CLS()
            shopAriveES()
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
end

function scene:destroy(event)
    local sceneGroup = self.view
    print("Destroying showLandmark scene")
    if background then
        background:removeSelf()
        background = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene