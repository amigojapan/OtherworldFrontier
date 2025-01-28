local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function gotoFiveHeroinsTable()
        --continue on journey
        local options =
        {
            effect = "fade",
            time = 400,
            params = {
            }
        }
        composer.gotoScene( "Adventurer1introduction", options )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end

-- Handler that gets notified when the alert closes
local function alertBoxYesClickedComplete( )
    --continue on journey
    local options =
	{
		effect = "fade",
		time = 400,
		params = {
		}
	}
	composer.gotoScene( "Adventurer1introduction", options )
end
local function alertBoxNoClickedCompleteEN()
    promtForNameEN()
end
local function alertBoxNoClickedCompleteJP()
    promtForNameJP()
end
local function alertBoxNoClickedCompleteES()
    promtForNameES()
end

function askUserIfTheyLikeNameEN(userinput)
    composer.setVariable( "adventurer1", userinput)
    AlertBox(
    "Adventurer1",
    "Her name is:"..userinput..", alright?",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteEN
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function askUserIfTheyLikeNameJP(userinput)
    composer.setVariable( "adventurer1", userinput)
    AlertBox(
    "冒険者その１",
    "名前は:"..userinput.."でいいですね？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteJP
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
    composer.setVariable( "adventurer1", userinput)
    AlertBox(
    "adventurer1",
    "se llama:"..userinput..", bien？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteES
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function promtForNameJP()
    showInputBox("冒険者その１に名前を付けて：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
    showInputBox("please name adventurer1:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
    showInputBox("dale nombre a la aventurera1:", askUserIfTheyLikeNameES)
end

function youSayEN()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").." says 'join me in a quest to find the Crown of Eternity, I have purchased a map to get it. I have an old caravan we can use....'")
    SLOWPRINT(50,"",adventurer1saysEN)
end
function adventurer1saysEN()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1").." says 'we will need to go to the stable to get unicorns to pull it'.")
    SLOWPRINT(50,"",adventurer2saysEN)
end

function adventurer2saysEN()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").." says 'we will need to head to the shop to buy supplies'.")
    SLOWPRINT(50,"",adventurer3saysEN)
end

function adventurer3saysEN()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." says 'lets do it!'.")
    SLOWPRINT(50,"",adventurer4saysEN)
end

function adventurer4saysEN()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." silently nods.")
    SLOWPRINT(50,"",adventureBeginsEN)
end

function adventureBeginsEN()
    RESETQUE()
    QUESLOWPRINT("^^and so the adventure begins....")
    SLOWPRINT(50,"",adventureBeginsEN)
end
-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        --background
        local background = display.newImageRect( sceneGroup, "backgrounds/fiveHeroinesAtTable.png", 1000,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
        -- Code here runs when the scene is entirely on screen
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            initTextScreen(sceneGroup,"EN")
            showTextArea()
            CLS()
            youSayEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            ourFiveHeroinesMeetJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            ourFiveHeroinesMeetES()
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