local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
composer.setVariable("setVariable","adventurer2")
composer.setVariable("backgroundImage","backgrounds/adventurer2.png")
composer.setVariable("nextScreenName","Adventurer2introduction")
composer.setVariable("prompt1EN","Adventurer 2's name is ")
composer.setVariable("prompt2EN"," right?")
composer.setVariable("prompt1JP","冒険者その2の名前は:")
composer.setVariable("prompt2JP","でよろしいですか？")
composer.setVariable("prompt1ES","El nombre de la aventurera 2 es ")
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

function gotoFiveHeroinsTable()
    --continue on journey
    local options =
    {
        effect = "fade",
        time = 400,
        params = {
        }
    }
    composer.gotoScene( "Adventurer2introduction", options )
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
    composer.gotoScene( "Adventurer2introduction", options )
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
composer.setVariable( "adventurer2", userinput)
AlertBox(
"Adventurer2",
"Her name is:"..userinput..", alright?",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteEN
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function askUserIfTheyLikeNameJP(userinput)
composer.setVariable( "adventurer2", userinput)
AlertBox(
"冒険者その2",
"名前は:"..userinput.."でよろしいですか？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteJP
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
composer.setVariable( "adventurer2", userinput)
AlertBox(
"la adventurera 2",
"se llama:"..userinput..", bien？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteES
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end


function welcomeHeroineJP()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer1").."のストーリー：改")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1").."は改流星の時に、Silvergladeという改静かな村に生まれた。改"..composer.getVariable( "adventurer1").."は改旅をする楽団の家族を持ち、彼女の朗らかな声とハープの響きは「星を落ち着かせる力を持つ」と言わていた。改ある日、天の精霊が夢の中に現れ、彼女の歌に魔法を唱える力を与えてくれた…。")
    SLOWPRINT(100,"",promptForNameJP)
end

function welcomeHeroineEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT(composer.getVariable( "adventurer1").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1")..". Born under a^")
    QUESLOWPRINT("comet's light in the tranquil village^")
    QUESLOWPRINT("of Silverglade, "..composer.getVariable( "adventurer1").." was ^")
    QUESLOWPRINT("raised by a family of traveling ^")
    QUESLOWPRINT("performers. Her melodious voice and ^")
    QUESLOWPRINT("harp-playing were said to charm even ^")
    QUESLOWPRINT("the stars. One fateful night,^")
    QUESLOWPRINT("a celestial spirit appeared in her ^")
    QUESLOWPRINT("dreams, granting her the power to ^")
    QUESLOWPRINT("weave magic into her songs....")
    SLOWPRINT(100,"",promptForNameEN)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("la historia de "..composer.getVariable( "adventurer1")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1")..". Nacida bajo la luz de un cometa en el tranquilo pueblo de Silverglade, "..composer.getVariable( "adventurer1").." fue creada por un grupo de musicos ambulantes. Su voz melodica y su abilidad para tocar la harpa fue renombrada, se dice que hasta podria pacificar a las estrellas. Una noche especial, un espiritu celestial aparecio en sus sueños, dandole el poder de integrar la magia a su musica....")
    SLOWPRINT(100,"",promptForNameES)
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
        local background = display.newImageRect( sceneGroup, "backgrounds/adventurer1.png", 1000,800 )
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