local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
composer.setVariable("defaultName","Viera")
composer.setVariable("setVariable","adventurer4")
composer.setVariable("backgroundImage","backgrounds/adventurer4.png")
composer.setVariable("nextScreenName","Adventurer4introduction")
composer.setVariable("prompt1EN","Adventurer 4's name is ")
composer.setVariable("prompt2EN",", right?")
composer.setVariable("prompt1JP","冒険者その4の名前は:")
composer.setVariable("prompt2JP","でよろしいですか？")
composer.setVariable("prompt1ES","El nombre de la aventurera 4 es ")
composer.setVariable("prompt2ES"," verdad?")


function clearBuggyObjects()
	print("Number of active display objects: " .. display.getCurrentStage().numChildren)
	for i = 1, display.getCurrentStage().numChildren do
		print("Object " .. i .. ": " .. tostring(display.getCurrentStage()[i]))
		--display.getCurrentStage()[2].isVisible=false--hack to hide hte invisible object that I do't know what it is
		if i==display.getCurrentStage().numChildren then
			local buggyObject=display.getCurrentStage()[i]
			buggyObject.isVisible=false
			--buggyObject:removeSelf()
			--buggyObject=nil
		end
	end
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
composer.gotoScene( "Adventurer4introduction", options )
end
local function alertBoxNoClickedCompleteEN()
promptForNameEN()
end
local function alertBoxNoClickedCompleteJP()
promptForNameJP()
end
local function alertBoxNoClickedCompleteES()
promptForNameES()
end

function askUserIfTheyLikeNameEN(userinput)
composer.setVariable( "adventurer4", userinput)
AlertBox(
"Adventurer4",
"Her name is:"..userinput..", alright?",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteEN
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function askUserIfTheyLikeNameJP(userinput)
composer.setVariable( "adventurer4", userinput)
AlertBox(
"冒険者その4",
"名前は:"..userinput.."でよろしいですか？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteJP
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
composer.setVariable( "adventurer4", userinput)
AlertBox(
"la aventurera 4",
"se llama:"..userinput..", bien？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteES
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function promptForNameJP()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("あなたの名前を入力して下さい：", askUserIfTheyLikeNameJP)
end
function promptForNameEN()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("what is your name?:", askUserIfTheyLikeNameEN)
end

function promptForNameES()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("Como te llamas?:", askUserIfTheyLikeNameES)
end
function welcomeHeroineJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer3").."のストーリー：改")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").."は改子供の頃「エバブルーム。シケット」の荒地に捨てられた。改"..composer.getVariable( "adventurer3").."は改森の精霊に育てられ、野生の魔法を教わった。彼女の魔法の力は強いが、失敗すると何が起こるか分からない不安定なものだった…。")
    SLOWPRINT(100,"",promptForNameEN)
end


function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer3").."'s backstory:")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." Abandoned as a child^")
    QUESLOWPRINT("in the magical wilderness of Everbloom ^")
    QUESLOWPRINT("Thicket, ^")
    QUESLOWPRINT(composer.getVariable( "adventurer3").." was raised by^")
    QUESLOWPRINT("forest spirits who taught her ancient,^")
    QUESLOWPRINT("untamed magic. Her powers are ^")
    QUESLOWPRINT("formidable but unpredictable, often ^")
    QUESLOWPRINT("causing chaos in tense moments....")
    SLOWPRINT(100,"",promptForNameEN)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("la historia de "..composer.getVariable( "adventurer3")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." fue abandonada de niña en el bosque magico llamado Everbloom Thicket, a "..composer.getVariable( "adventurer3").." la cuidaron los espiritus del bosque los cuales le enseñaron magia antigua y sin dominio. Sus poderes son formidables, pero inpredecibles, en moemntos tensos esa magia puede causar caos....")
    SLOWPRINT(100,"",promptForNameEN)
end


-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        --cleanupInvisibleObjects(display.getCurrentStage(),sceneGroup)
        --background
        local background = display.newImageRect( sceneGroup, "backgrounds/adventurer3.png", 1000,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
        -- Code here runs when the scene is entirely on screen
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            initTextScreen(sceneGroup,"EN")
            showTextArea()
            CLS()
            welcomeHeroineEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            welcomeHeroineJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            welcomeHeroineES()
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