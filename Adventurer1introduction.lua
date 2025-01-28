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
"名前は:"..userinput.."でいいですね？",
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

function promtForNameJP()
showInputBox("冒険者その１に名前を付けて：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
showInputBox("please name adventurer2:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
showInputBox("dale nombre a la aventurera 2:", askUserIfTheyLikeNameES)
end

function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer1").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1")..". Born under a comet's light in the tranquil village of Silverglade, "..composer.getVariable( "adventurer1").." was raised by a family of traveling performers. Her melodious voice and harp-playing were said to charm even the stars. One fateful night, a celestial spirit appeared in her dreams, granting her the power to weave magic into her songs....")
    SLOWPRINT(100,"",promtForNameEN)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("la historia de "..composer.getVariable( "adventurer1")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1")..". Nacida bajo la luz de un cometa en el tranquilo pueblo de Silverglade, "..composer.getVariable( "adventurer1").." fue creada por un grupo de musicos ambulantes. Su voz melodica y su abilidad para tocar la harpa fue renombrada, se dice que hasta podria pacificar a las estrellas. Una noche especial, un espiritu celestial aparecio en sus sueños, dandole el poder de integrar la magia a su musica....")
    SLOWPRINT(100,"",promtForNameES)
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
    QUESLOWPRINT("^^ahora dales nombre a las 4 chicas....")
    SLOWPRINT(100,"", ourFiveHeroinesMeetES)
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