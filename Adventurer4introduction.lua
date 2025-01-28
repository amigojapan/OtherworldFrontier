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
"名前は:"..userinput.."でいいですね？",
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
showInputBox("冒険者その１に名前を付けて：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
showInputBox("please name adventurer4:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
showInputBox("dale nombre a la aventurera1:", askUserIfTheyLikeNameES)
end

function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer4").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." grew up in the serene coastal village of Solrise, where she served as an apprentice to the village healer and priestess. When her home was raided by a band of marauders, "..composer.getVariable( "adventurer4").." invoked the protection of God, unleashing a burst of divine light that drove the attackers away. The experience left her both awed and burdened by the responsibility of wielding divine power....")
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

function letsNameOur4HeroinesJP()
    RESETQUE()
    QUESLOWPRINT("改改地図をもらってから、少し酒場を回ってから、４人の女の人が座ってるテーブルを見かける。そこに座ることにする…")
    SLOWPRINT(100,"",spotsTableWithFourHeroinesJP)
end
function introductionsJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."がテーブルに座ると皆が自公紹介する。")    
    SLOWPRINT(100,"", letsNameOur4HeroinesJP)
end

function ourFiveHeroinesMeetJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."がそのテーブルに座って、皆と自公紹介を始めます。。")
    SLOWPRINT(100,"",introductionsJP)
end
function introductionsJP()
    RESETQUE()
    QUESLOWPRINT("改改ここで４人の仲間の名前を決めましょう…。")
    SLOWPRINT(100,"", introductionsJP)
end


function ourFiveHeroinesMeetES()
    RESETQUE()
    QUESLOWPRINT("te sientas en la mesa con las otras 4 chicas y comienzan a presentarse...")
    SLOWPRINT(100,"",introductionsES)
end
function introductionsES()
    RESETQUE()
    QUESLOWPRINT("^^ahora dales nombre a las 4 chicas......")
    SLOWPRINT(100,"", ourFiveHeroinesMeetES)
end
function ourFiveHeroinesMeetEN()
    RESETQUE()
    QUESLOWPRINT("You sit down at the table with the other girls and introductions start...")
    SLOWPRINT(100,"",introductionsEN)
end
function introductionsEN()
    RESETQUE()
    QUESLOWPRINT("^^here is where you get to name the other 4 girls.....")
    SLOWPRINT(100,"", promtForNameEN)
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