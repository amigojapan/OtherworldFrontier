local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end

--local MCname=nil
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
    composer.setVariable( "MCname", userinput)
    AlertBox(
    "Name",
    "Your Name is:"..userinput..", right?",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteEN
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

function askUserIfTheyLikeNameJP(userinput)
    composer.setVariable( "MCname", userinput)
    AlertBox(
    "名前",
    "あなたの名前は:"..userinput.."でよろしいですか？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteJP
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
    composer.setVariable( "MCname", userinput)
    AlertBox(
    "Tu nombre",
    "Te llamas:"..userinput..", verdad？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteES
    )
    removerInputBox()
    disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end

composer.setVariable("setVariable","MCname")
composer.setVariable("backgroundImage","backgrounds/you.png")
composer.setVariable("nextScreenName","ourHeroine")
composer.setVariable("prompt1EN","Your name is ")
composer.setVariable("prompt2EN",", right?")
composer.setVariable("prompt1JP","あなたの名前は:")
composer.setVariable("prompt2JP","でよろしいですか？")
composer.setVariable("prompt1ES","Tu nombre es ")
composer.setVariable("prompt2ES",", verdad?")


function promtForNameJP()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("あなたの名前を入力して下さい：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("what is your name?:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
    composer.gotoScene( "nameAdventurer" )
    --showInputBox("Como te llamas?:", askUserIfTheyLikeNameES)
end

function prologueEN()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("Prologue^")
    QUESLOWPRINT("The tale begins in the bustling tavern ^")
    QUESLOWPRINT("known as the 'Tavern of a Thousand ^")
    QUESLOWPRINT("Tales', nestled on the southernmost ^")
    QUESLOWPRINT("edge of the continent in the city of ^")
    QUESLOWPRINT("Mistral's End. Adventurers, traders, ^")
    QUESLOWPRINT("and wanderers gather here to share ^")
    QUESLOWPRINT("tales of treasure and glory.  ^")
    QUESLOWPRINT("The town doesn't have an adventurer's^")
    QUESLOWPRINT("guild, but this tavern serves a ^")
    QUESLOWPRINT("similar role... A whispered legend ^")
    QUESLOWPRINT("emerges once again:^^")
    SLOWPRINT(50,"",monogatari1EN)
end

function monogatari2EN()
    print("monogatari3 called")
    --           "1234567890123456789012345678901234567890"
    RESETQUE()
    QUESLOWPRINT("^^Many have tried to claim the ^")
    QUESLOWPRINT("artifact, but the journey north is ^")
    QUESLOWPRINT("perilous. Ancient forests, deadly ^")
    QUESLOWPRINT("mountains, cursed wastelands, and ^")
    QUESLOWPRINT("frozen tundras and evil monsters ^")
    QUESLOWPRINT("stand between the brave and their ^")
    QUESLOWPRINT("goal. Most of them could not survive ^")
    QUESLOWPRINT("the journey.^")
    QUESLOWPRINT("^^Despite the odds, your party has ^")
    QUESLOWPRINT("decided to embark on this epic ^")
    QUESLOWPRINT("journey. Whether for riches, ^")
    QUESLOWPRINT("redemption, or renown, the stakes are^")
    QUESLOWPRINT("high, and the path ahead is fraught ^")
    QUESLOWPRINT("with danger..")
    SLOWPRINT(50,"",promtForNameEN)
end

function monogatari1EN()
    print("monogatari1 called")
    --           "1234567890123456789012345678901234567890"
    RESETQUE()
    QUESLOWPRINT("^^'Beyond the Northern Tundra lies the ^")
    QUESLOWPRINT("Crown of Eternity, a mythical artifact ^")
    QUESLOWPRINT("created by God himself. It is said to ^")
    QUESLOWPRINT("grant unparalleled power or fulfill ^")
    QUESLOWPRINT("the deepest desire of whoever ^")
    QUESLOWPRINT("possesses it.'")
    SLOWPRINT(50,"",monogatari2EN)
end

function prologueJP()
    QUESLOWPRINT("プロローグ改")
    QUESLOWPRINT("物語は「千の物語の酒場」として知られる賑やかな酒場から始まる。この酒場は大陸の南端、ミストラルズ・エンドの街に位置し、冒険者、商人、そして旅人が宝と栄光の物語を共有するために集う場所だ。この町には冒険者用ギルドがない、だがこの酒場がそのような役割を果たしていた。^^そこでは代々伝説が語り継がれていた。改")
    SLOWPRINT(50,"",monogatari1JP)
end

function monogatari2JP()
    print("monogatari2 called")
    RESETQUE()
    QUESLOWPRINT("改改多くの者がその宝を手に入れようと挑んだが、北への旅路は非常に危険だ。古代の森、険しい山々、呪われた荒地、改そして凍てついたツンドラが勇者たちの前に立ちはだかる。それでもなお、主人公は秘めた思いのために、危険に満ちた旅に出た。改")
    SLOWPRINT(50,"",promtForNameJP)
end

function monogatari1JP()
    print("monogatari1 called")
    RESETQUE()
    QUESLOWPRINT("改改「北のツンドラを越えた先に『古の王冠』がある。それは神様自身が作り出したとされる神秘的な宝だ。これを手にする者には、どんな願いも叶えられると言い伝えられている。」改")
    SLOWPRINT(50,"",monogatari2JP)
end

function prologueES()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("Prologo^")
    QUESLOWPRINT("El relato comienza en una taverna^")
    QUESLOWPRINT("llena de gente conocida como la ^")
    QUESLOWPRINT("'Taberna de los Mil Relatos', ^")
    QUESLOWPRINT("situada en el extremo más al sur^")
    QUESLOWPRINT("del continente, en la ciudad de^")
    QUESLOWPRINT("Mistral's end. Aventureros, ^")
    QUESLOWPRINT("comerciantes y viajeros se reúnen^")
    QUESLOWPRINT("aquí para compartir historias de ^")
    QUESLOWPRINT("tesoros y gloria. Este pueblo no ^")
    QUESLOWPRINT("tiene un gremio de aventureros ^")
    QUESLOWPRINT("pero esta taverna hace una funcion^")
    QUESLOWPRINT("simillar...^")
    QUESLOWPRINT("^^La leyenda susurrada vuelve ^")
    QUESLOWPRINT("a surgir.:")
    SLOWPRINT(50,"",monogatari1ES)
end

function monogatari2ES()
    print("monogatari3 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^Muchos han intentado reclamar el^")
    QUESLOWPRINT("artefacto, pero el viaje hacia el^")
    QUESLOWPRINT("norte es peligroso. Bosques ^")
    QUESLOWPRINT("ancestrales, montañas mortales,^")
    QUESLOWPRINT("montes malditos, tundras heladas y^")
    QUESLOWPRINT("monstruos malvados se interponen^")
    QUESLOWPRINT("entre los valientes y su objetivo.^")
    QUESLOWPRINT("La mayoría han sobrevivido el^")
    QUESLOWPRINT("trayecto. A pesar de las^")
    QUESLOWPRINT("probabilidades, tu grupo ha^")
    QUESLOWPRINT("decidido embarcarse en esta épica^")
    QUESLOWPRINT("travesía. Ya sea por riquezas,^")
    QUESLOWPRINT("redención o renombre, el riesgo es^")
    QUESLOWPRINT("alto, y el camino por delante está^")
    QUESLOWPRINT("plagado con peligros..")
    SLOWPRINT(50,"",promtForNameES)
end

function monogatari1ES()
    print("monogatari1 called")
    RESETQUE()
    --           "123456780123456780123456780123456780"
    QUESLOWPRINT("^^'Más allá de la Tundra del Norte^")
    QUESLOWPRINT("esta la ''Corona de la eternidad'',^")
    QUESLOWPRINT("un artefacto mítico creado por Dios^")
    QUESLOWPRINT("mismo. Se dice que otorga un poder^")
    QUESLOWPRINT("sin igual o cumple el deseo más^")
    QUESLOWPRINT("profundo de quien la posea.'")
    SLOWPRINT(50,"",monogatari2ES)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        --background
        local background = display.newImageRect( sceneGroup, "backgrounds/Tavern-of-a-Thousand-Tales.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
        -- Code here runs when the scene is entirely on screen
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            initTextScreen(sceneGroup,"EN")
            showTextArea()
            CLS()
            prologueEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            prologueJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            prologueES()    
        end
		--PRINT("こんにちは世界！")

        --(workaround)bug makes one slowprint wait for the one in back to finish
        --maybe just append the string to the outpusiting if there is already one SLOWPRINT working
        --idea, for the continue button, just set the timer to a shorter period, that way it will appear quickly but nto completly instantaneously  and be less work
        --SLOWPRINT(50,"こんにちは世界！日本語の文章を試します、昔々あるところでおじいちゃんとばあちゃんがいました、おじいちゃんが芝刈りに、おばあちゃんが川で洗濯してました")
        
        --LOCATE(24,10)
		--PRINT("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		--PRINT("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB")
		--PRINT("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        --hideTextArea()
        
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