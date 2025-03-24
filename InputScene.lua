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
local setVariable=composer.getVariable("setVariable")
local backgroundImage=composer.getVariable("backgroundImage")
local nextScreenName=composer.getVariable("nextScreenName")
local prompt1EN=composer.getVariable("prompt1EN")
local prompt2EN=composer.getVariable("prompt2EN")
local prompt1JP=composer.getVariable("prompt1JP")
local prompt2JP=composer.getVariable("prompt2JP")
local prompt1ES=composer.getVariable("prompt1ES")
local prompt2ES=composer.getVariable("prompt2ES")

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
local function alertBoxYesClickedComplete( )
    --continue on journey
    composer.setVariable( setVariable, composer.getVariable("inputBuffer"))
    --composer.setVariable("inputBuffer", "input unset")
    local options =
    {
        effect = "fade",
        time = 400,
        params = {
        }
    }
    composer.removeScene( "current", options )
    composer.gotoScene( nextScreenName, options )
end
local function alertBoxNoClickedCompleteEN()
    enableContinueButton()
    promptsetVariableEN()
end
local function alertBoxNoClickedCompleteJP()
    enableContinueButton()
    promptsetVariableJP()
end
local function alertBoxNoClickedCompleteES()
    enableContinueButton()
    promptsetVariableES()
end


function verifyNameEN(userinput)
    print("userinput:"..userinput)
    AlertBox(
    "",--no title
    prompt1EN..userinput..prompt2EN,
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteEN
    )
end

function verifyNameJP(userinput)
    AlertBox(
    "",--no title
    prompt1JP..userinput..prompt2JP,
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteJP
    )
end

function verifyNameES(userinput)
    AlertBox(
    "",--no title
    prompt1ES..userinput..prompt2ES,
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteES
    )
end

function promptsetVariableJP()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt",prompt1JP..":")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
end
function promptsetVariableEN()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt",prompt1EN..":")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
end

function promptsetVariableES()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt",prompt1ES..":")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
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
        local background = display.newImageRect( sceneGroup, backgroundImage, 1000,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
        if composer.getVariable("inputBuffer") ~= "input unset" then           
            if composer.getVariable( "language" ) == "English" then
                initTextScreen(sceneGroup,"EN")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyNameEN(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Japanese" then
                initTextScreen(sceneGroup,"JP")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyNameJP(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Spanish" then
                initTextScreen(sceneGroup,"ES")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyNameES(composer.getVariable("inputBuffer"))
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
            promptsetVariableEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            promptsetVariableJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            promptsetVariableES()
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