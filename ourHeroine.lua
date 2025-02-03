local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function gotoNightshadeScreen()
        --continue on journey
        local options =
        {
            effect = "fade",
            time = 400,
            params = {
            }
        }
        composer.gotoScene( "nightShade", options )
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
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT(composer.getVariable( "MCname").."'s backstory:")
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." was born under a ^")
    QUESLOWPRINT("rare celestial event known as the ^")
    QUESLOWPRINT("Veil's Convergence, where the twin ^")
    QUESLOWPRINT("moons of Eternia aligned perfectly, ^")
    QUESLOWPRINT("casting the land in an eerie silver ^")
    QUESLOWPRINT("glow. This alignment was said to ^")
    QUESLOWPRINT("herald the arrival of those destined ^")
    QUESLOWPRINT("to shape the world's fate—be it for ^")
    QUESLOWPRINT("salvation or destruction....")
    SLOWPRINT(100,"", storyContinuesEN)
end
function storyContinuesEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." enters the Tavern of^")
    QUESLOWPRINT("a Thousand Tales at Mistral’s End, a^")
    QUESLOWPRINT(" suspicious character aproches you....")
    print("goto nightshadescreen")
    SLOWPRINT(100,"", gotoNightshadeScreen )
end

function welcomeHeroineJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."のストーリー:")
    QUESLOWPRINT("改改"..composer.getVariable( "MCname").."が、改「ブエルズ・コンバージェンス」改（エターニアの二つの月が完全に重なる時に大地が銀色に染まる）という、一万年に一度の天体現象の時に生まれた。その現象で生まれた子はエターニアの救世主になるか、破滅に導くと言われている。。")
    SLOWPRINT(100,"",storyContinuesJP)
end
function storyContinuesJP()
    RESETQUE()
    QUESLOWPRINT("改改"..composer.getVariable( "MCname").."が改ミストラルズエンドの千の物語の酒場に入り、怪しい人に声掛けられた…。")
    print("goto nightshadescreen")
    SLOWPRINT(100,"", gotoNightshadeScreen )
end


function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("La historia de "..composer.getVariable( "MCname")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." Nació bajo un evento raro celestial conocido como la Convergencia del Velo, cuando las dos lunas gemelas de Eternia se alinearon perfectamente, tiñendo la tierra en un inquietante resplandor plateado. Se díce que esta alineación anunciaba la llegada de aquellos destinados a moldear el destino del mundo, ya fuera para su salvación o su destrucción.")
    SLOWPRINT(100,"",storyContinuesES)
end
function storyContinuesES()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "MCname").." entra en la Taberna de las Mil Historias en Mistral's End....")
    print("goto nightshadescreen")
    SLOWPRINT(100,"", gotoNightshadeScreen )
end


-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        --background
        local background = display.newImageRect( sceneGroup, "backgrounds/you.png", 1000,800 )
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