local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
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

function gotoFiveHeroinesConversation()
    local options =
    {
        effect = "fade",
        time = 400,
        params = {
        }
    }
    composer.gotoScene( "fiveHeroinesConversation", options )
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
    composer.gotoScene( "fiveHeroinesConversation", options )
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
"冒険者その１",
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
"adventurer4",
"se llama:"..userinput..", bien？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteES
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function promtForNameJP()
showInputBox("冒険者その１に名前を付けましょう：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
showInputBox("please name adventurer4:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
showInputBox("dale nombre a la aventurera1:", askUserIfTheyLikeNameES)
end
function welcomeHeroineJP()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer4").."のストーリー：改")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").."は改静かな浜辺の村の「ソルライズ」で育てられ改そこで、ヒーラーのシスターの弟子として活躍した。改ある日、 山賊に村を襲われそうになった時、改"..composer.getVariable( "adventurer4").."は改神様に祈って聖なる光を放ち、山賊はその光に恐れおののき逃げ出した。その経験から、聖なる力の強大さに責任を感じるようになった…。")
    SLOWPRINT(100,"", gotoFiveHeroinesConversation)
end



function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer4").."'s backstory:")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." grew up in the^")
    QUESLOWPRINT("serene coastal village of Solrise, ^")
    QUESLOWPRINT("where she served as an apprentice to^")
    QUESLOWPRINT("the village healer and priestess. When^")
    QUESLOWPRINT("her home was raided by a band of^")
    QUESLOWPRINT("marauders, ^")
    QUESLOWPRINT(composer.getVariable( "adventurer4").." invoked the^")
    QUESLOWPRINT("protection of God, unleashing a burst^")
    QUESLOWPRINT("of divine light that drove the ^")
    QUESLOWPRINT("attackers away. The experience left ^")
    QUESLOWPRINT("her both awed and burdened by the ^")
    QUESLOWPRINT("responsibility of wielding divine^")
    QUESLOWPRINT("power....")
    SLOWPRINT(100,"", gotoFiveHeroinesConversation)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("la historia de "..composer.getVariable( "adventurer4")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." crecio en el pueblo costal llamado Solrise, alli sirvio como amprendiz de la sacerdotisa y curadora de el pueblo. un dia su pueblo fue asaltado por una banda de merodeadores, "..composer.getVariable( "adventurer4").." invoco la proteccion de Dios, soltando una luz divina que asusto a los merodeadores, y se fueron. Tal experiencia le dio temor y la dejo con la tremenda responsabilida de manejar poder divino....")
    SLOWPRINT(100,"", gotoFiveHeroinesConversation)
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
        local background = display.newImageRect( sceneGroup, "backgrounds/adventurer4.png", 1000,800 )
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