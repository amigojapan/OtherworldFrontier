local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function gotoMistralsEnd()       --continue on journey
        local options =
        {
            effect = "fade",
            time = 400,
            params = {
            }
        }

        --clear this when the main game screen enters so that the name does nto apepar in teh store
        composer.setVariable("defaultName","")

        composer.gotoScene( "shopMenu", options )
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
    "adventurer1",
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



function youSayJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").."が改「一緒に『古の王冠』を探す旅改に出ない？王冠の場所を記す地図を買ったし、馬車も持ってるから」と言った。。")
    SLOWPRINT(50,"",adventurer1saysJP)
end
function adventurer1saysJP()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1").."が改「牧場に行って、馬車を引くユニコーンを買わなきゃいけないね」と言った。。")
    SLOWPRINT(50,"",adventurer2saysJP)
end

function adventurer2saysJP()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").."も改「店で必要なものをそろえなきゃ」と言った。。")
    SLOWPRINT(50,"",adventurer3saysJP)
end

function adventurer3saysJP()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").."が、改「よし、行こう！」と言った。")
    SLOWPRINT(50,"",adventurer4saysJP)
end

function adventurer4saysJP()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").."が改静かに頷いた。。")
    SLOWPRINT(50,"",adventureBeginsJP)
end

function adventureBeginsJP()
    RESETQUE()
    QUESLOWPRINT("^^そして、ここから冒険が始まる…。")
    SLOWPRINT(50,"",gotoMistralsEnd)
end




function youSayEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT(composer.getVariable( "MCname").." said ^")
    QUESLOWPRINT("'join me in a quest to find the Crown of^")
    QUESLOWPRINT("Eternity, I have purchased a map to get^")
    QUESLOWPRINT("it. I have an old caravan we ^")
    QUESLOWPRINT("can use....'")
    SLOWPRINT(50,"",adventurer1saysEN)
end
function adventurer1saysEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1").." said ^")
    QUESLOWPRINT("'we will need to go to the stable to^")
    QUESLOWPRINT("get unicorns to pull it'.")
    SLOWPRINT(50,"",adventurer2saysEN)
end

function adventurer2saysEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").." said^")
    QUESLOWPRINT("'we will need to head to the shop to ^")
    QUESLOWPRINT("buy supplies'.")
    SLOWPRINT(50,"",adventurer3saysEN)
end

function adventurer3saysEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." said^")
    QUESLOWPRINT("'lets do it!'.")
    SLOWPRINT(50,"",adventurer4saysEN)
end

function adventurer4saysEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." silently nodded.")
    SLOWPRINT(50,"",adventureBeginsEN)--(done)make it go to the unicorn stable
end

function adventureBeginsEN()
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^and so the adventure began....")
    SLOWPRINT(50,"",gotoMistralsEnd)
end

function youSayES()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "MCname").." dijo 'vengan con migo en una busqueda para encontrar la 'Crown of Eternity', He obtenido un mapa que guia a su locacion. Tengo una caravana vieja que podemos utilizar....'")
    SLOWPRINT(50,"",adventurer1saysES)
end
function adventurer1saysES()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer1").." dijo 'necesitaremos ir al establo para conseguir unicornios para jalar la caravana'.")
    SLOWPRINT(50,"",adventurer2saysES)
end

function adventurer2saysES()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer2").." dijo 'nesesitaremos ir a la tienda para conseguir suministros'.")
    SLOWPRINT(50,"",adventurer3saysES)
end

function adventurer3saysES()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." dijo 'Pues vamos ya!'.")
    SLOWPRINT(50,"",adventurer4saysES)
end

function adventurer4saysES()
    RESETQUE()
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer4").." solo hizo el gesto que si con su cabez.")
    SLOWPRINT(50,"",adventureBeginsES)
end

function adventureBeginsES()
    RESETQUE()
    QUESLOWPRINT("^^y asi comienza la aventura....")
    SLOWPRINT(50,"",gotoMistralsEnd)
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
            youSayEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            youSayJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            youSayES()
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