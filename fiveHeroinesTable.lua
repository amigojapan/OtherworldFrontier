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
    "la aventurera 1",
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
    showInputBox("please name adventurer1:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
    showInputBox("dale nombre a la aventurera1:", askUserIfTheyLikeNameES)
end
function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." was born under a rare celestial event known as the Veil's Convergence, where the twin moons of Eternia aligned perfectly, casting the land in an eerie silver glow. This alignment was said to herald the arrival of those destined to shape the world's fate—be it for salvation or destruction.")
    SLOWPRINT(50,"",welcomeHeroineEN)
end

function letsNameOur4HeroinesJP()
    RESETQUE()
    QUESLOWPRINT("改改地図をもらってから、少し酒場を回ってから、４人の女の人が座ってるテーブルを見かける。そこに座ることにする…")
    SLOWPRINT(50,"",spotsTableWithFourHeroinesJP)
end
function introductionsJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."がテーブルに座ると皆が自公紹介する。")    
    SLOWPRINT(50,"", letsNameOur4HeroinesJP)
end

function ourFiveHeroinesMeetJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."がそのテーブルに座って、改皆と自己紹介を始める。。")
    SLOWPRINT(50,"",introductionsJP)
end
function introductionsJP()
    RESETQUE()
    QUESLOWPRINT("改改ここで４人の仲間の名前を決めましょう…。")
    SLOWPRINT(50,"", promtForNameJP)
end


function ourFiveHeroinesMeetES()
    RESETQUE()
    QUESLOWPRINT("te sientas en la mesa con las otras 4 chicas y comienzan a presentarse....")
    SLOWPRINT(50,"",introductionsES)
end
function introductionsES()
    RESETQUE()
    QUESLOWPRINT("^^ahora dales nombre a las 4 chicas....")
    SLOWPRINT(50,"", promtForNameES)
end
function ourFiveHeroinesMeetEN()
    RESETQUE()
    QUESLOWPRINT("You sit down at the table with the other girls and introductions start....")
    SLOWPRINT(50,"",iEN)
end
function iEN()
    print("introductionsEN called")
    RESETQUE()
    QUESLOWPRINT("^^here is where you get to name the other 4 girls....")
    SLOWPRINT(50,"",promtForNameEN)
end



function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("ahora ponle nombre a las otras 4 heroinas...")
    SLOWPRINT(50,"",welcomeHeroineEN)
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
            ourFiveHeroinesMeetEN()
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