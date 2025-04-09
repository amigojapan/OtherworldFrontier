local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

background=nil

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
    local textSpeed=100
    if composer.getVariable("backgroundImage") == "backgrounds/crown-of-eternity.png" then
        textSpeed=300
        QUESLOWPRINT("おめでとうございます!^")
        QUESLOWPRINT("心の願いが仲間を息が得る事だった、から、!^")
        QUESLOWPRINT("皆で仲良くハッピーエンド^")
        QUESLOWPRINT("^^ゲームプランナー・プログラマー・著作権：^")
        QUESLOWPRINT("パドウ・ウスマー・エー(amigojapan)^")
        QUESLOWPRINT("^グラフィックス・キャラクターデザイナー・プログラマー：若松 晶^")
        QUESLOWPRINT("^音声・音楽：Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END")
    elseif composer.getVariable("backgroundImage") == "backgrounds/altEnding.png" then
        textSpeed=300
        QUESLOWPRINT("おめでとうございます!^")
        QUESLOWPRINT("君は固定観念に取ら割らない人です!^")
        QUESLOWPRINT("南西半島でゆっくりな海暮らしにしました。^")
        QUESLOWPRINT("^^ゲームプランナー・プログラマー・著作権：^")
        QUESLOWPRINT("パドウ・ウスマー・エー(amigojapan)^")
        QUESLOWPRINT("^グラフィックス・キャラクターデザイナー・プログラマー：若松 晶^")
        QUESLOWPRINT("^音声・音楽：Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Maelstrom-Peak.png" then
        QUESLOWPRINT("Maelstrom　Peakにようこそ!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Evermist-Hills.png" then
        QUESLOWPRINT("Evermist　Hillsにようこそ!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Enchanted-Spires.png" then
        QUESLOWPRINT("Evermist　Hillsにようこそ!^")
    else
        QUESLOWPRINT("Erorr, landmark not found.^")
    end
    SLOWPRINT(textSpeed, "", returnToGame)
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
        background=nil
        background = display.newImageRect( composer.getVariable("backgroundImage"), 1000, 800)
        if background then
            background.x = display.contentCenterX
            background.y = display.contentCenterY
            print("background.parent == sceneGroup:", background.parent == sceneGroup)
            sceneGroup:insert( background )
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