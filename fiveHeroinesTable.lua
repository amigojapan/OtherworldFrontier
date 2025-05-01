local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

composer.setVariable("defaultName","Rose")
composer.setVariable("setVariable","adventurer1")
composer.setVariable("backgroundImage","backgrounds/adventurer1.png")
composer.setVariable("nextScreenName","Adventurer1introduction")
composer.setVariable("prompt1EN","Adventurer 1's name is ")
composer.setVariable("prompt2EN",", right?")
composer.setVariable("prompt1JP","冒険者その１の名前は:")
composer.setVariable("prompt2JP","でよろしいですか？")
composer.setVariable("prompt1ES","El nombre de la aventurera 1 es ")
composer.setVariable("prompt2ES"," verdad?")


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
function letsNameOur4HeroinesJP()
    RESETQUE()
    QUESLOWPRINT("改改地図をもらってから、少し酒場を回ってから、４人の女の人が座ってるテーブルを見かける。そこに座ることにする…")
    SLOWPRINT(50,"",spotsTableWithFourHeroinesJP)
end
function introductionsJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."がテーブルに座ると皆が自公紹介する。。")    
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
    SLOWPRINT(50,"", promptForNameJP)
end


function ourFiveHeroinesMeetES()
    RESETQUE()
    QUESLOWPRINT("te sientas en la mesa con las otras 4 chicas y comienzan a presentarse....")
    SLOWPRINT(50,"",introductionsES)
end
function introductionsES()
    RESETQUE()
    QUESLOWPRINT("^^ahora dales nombre a las 4 chicas....")
    SLOWPRINT(50,"", promptForNameES)
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
    SLOWPRINT(50,"",promptForNameEN)
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