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
        composer.gotoScene( "gotoFiveHeroinsTable", options )
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
	composer.gotoScene( "ourHeroine", options )
end
local function alertBoxNoClickedComplete()
    showInputBox("what is your name?:",callback)
end

function askUserIfTheyLikeNameEN(userinput)
    createCustomAlert(
    "Name",
    "Your name is:"..userinput..", right?",
    alertBoxYesClickedComplete,
    alertBoxNoClickedComplete
    )
end
function promtForNameEN()
    showInputBox("Please enter your name:", askUserIfTheyLikeNameEN)
end
function welcomeHeroineEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." was born under a rare celestial event known as the Veil's Convergence, where the twin moons of Eternia aligned perfectly, casting the land in an eerie silver glow. This alignment was said to herald the arrival of those destined to shape the world's fate—be it for salvation or destruction.")
    SLOWPRINT(100,"",welcomeHeroineEN)
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


function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("La historia de "..composer.getVariable( "MCname")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." Nació bajo un evento raro celestial conocido como la Convergencia del Velo, cuando las dos lunas gemelas de Eternia se alinearon perfectamente, bañando la tierra en un inquietante resplandor plateado. Se decía que esta alineación anunciaba la llegada de aquellos destinados a moldear el destino del mundo, ya fuera para su salvación o su destrucción.")
    SLOWPRINT(100,"",welcomeHeroineEN)
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
            welcomeHeroineEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            ourFiveHeroinesMeetJP()
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