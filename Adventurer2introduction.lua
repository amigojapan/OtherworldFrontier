local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
composer.setVariable("defaultName","Lilac")
composer.setVariable("setVariable","adventurer3")
composer.setVariable("backgroundImage","backgrounds/adventurer3.png")
composer.setVariable("nextScreenName","Adventurer3introduction")
composer.setVariable("prompt1EN","Adventurer 3's name is ")
composer.setVariable("prompt2EN"," right?")
composer.setVariable("prompt1JP","冒険者その3の名前は:")
composer.setVariable("prompt2JP","でよろしいですか？")
composer.setVariable("prompt1ES","El nombre de la aventurera 3 es ")
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
composer.gotoScene( "Adventurer3introduction", options )
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
composer.setVariable( "adventurer3", userinput)
AlertBox(
"Adventurer3",
"Her name is:"..userinput..", alright?",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteEN
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function askUserIfTheyLikeNameJP(userinput)
composer.setVariable( "adventurer3", userinput)
AlertBox(
"冒険者その3",
"名前は:"..userinput.."でよろしいですか？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteJP
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
composer.setVariable( "adventurer3", userinput)
AlertBox(
"la adventurera 3",
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
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer2").."のストーリー：改")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").."は改軍事の街の「アイロンリーチ」で改育てられた。エリートの騎士になるように改幼い頃から洗脳されていたが、ある日、彼女は自分の軍隊が魔王と手を組むことを企んでいたことを知って、魔法の剣「アストラルブレード」を持ち出し、街を逃げ出した…。")
    SLOWPRINT(100,"",promptForNameJP)
end

function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT(composer.getVariable( "adventurer2").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").." was raised^")
    QUESLOWPRINT("in the militant city of Ironreach, ^")
    QUESLOWPRINT("groomed from a young age to become an ^")
    QUESLOWPRINT("elite knight. However, when she ^")
    QUESLOWPRINT("uncovered her order's secret dealings ^")
    QUESLOWPRINT("with dark forces, she fled, taking ^")
    QUESLOWPRINT("with her the enchanted sword called^")  
    QUESLOWPRINT("\"The Astral Blade\"....")
    SLOWPRINT(100,"",promptForNameEN)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("La historia de ".. composer.getVariable( "adventurer2")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").." crecio en la cuidad militaristica llamada Ironreach, trataron de forzarla a ser una soldado caballera. pero, cuando se dio cuenta de los planes malevolos de su orden de unirse con las fuerzas de las tinieblas , se escapo, y se llevo la espada encandada llamada \"Astral Blade\"")
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
        local background = display.newImageRect( sceneGroup, "backgrounds/adventurer2.png", 1000,800 )
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