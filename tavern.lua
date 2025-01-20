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
    createCustomAlert(
    "Name",
    "Your Name is"..userinput..", right?",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteEN
    )
end

function askUserIfTheyLikeNameJP(userinput)
    composer.setVariable( "MCname", userinput)
    createCustomAlert(
    "名前",
    "あなたの名前は:"..userinput.."ですか？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteJP
    )
end
function askUserIfTheyLikeNameES(userinput)
    composer.setVariable( "MCname", userinput)
    createCustomAlert(
    "Tu nombre",
    "Te llamas:"..userinput..", verdad？",
    alertBoxYesClickedComplete,
    alertBoxNoClickedCompleteES
    )
end

function promtForNameJP()
    showInputBox("あなたの名前を入力して下さい：", askUserIfTheyLikeNameJP)
end
function promtForNameEN()
    showInputBox("what is your name?:", askUserIfTheyLikeNameEN)
end

function promtForNameES()
    showInputBox("Como te llamas?:", askUserIfTheyLikeNameES)
end

function prologueEN()
    QUESLOWPRINT("Prologue^")
    --           "123456780123456780123456780123456780123456780123456780123456780123456780"
    --Nanobot> amigojapan: I know you were talking about this earlier, but "The tavern also works like an unofficial guild" sounds weird to me. First of all, I think you're talking about an "adventurer's guild" specifically. Second, I feel like it would make more sense if you were to say something like "The town doesn't have an adventurer's guild, but this tavern serves a similar role" or something along those lines. When I think of a "guild", I think of a much more 
    --reduce wait time form 100MS to 50MS
    --also add 病死 to the list of calamities
    QUESLOWPRINT("The tale begins in the bustling tavern known as the 'Tavern of a ^")
    QUESLOWPRINT("Thousand Tales', nestled on　the southernmost edge of the continent in^")
    QUESLOWPRINT("the city of Mistral's End. Adventurers, traders, and wanderers gather^") 
    QUESLOWPRINT("here to share tales of treasure and glory.  The town doesn't have an^")
    QUESLOWPRINT("adventurer's guild, but this tavern serves a similar role...^")
    QUESLOWPRINT("^A whispered legend emerges once again:^^")
    SLOWPRINT(100,"",monogatari1EN)
end

function monogatari2EN()
    print("monogatari3 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^^Many have tried to claim the artifact, but the journey north is perilous. Ancient forests, deadly mountains, cursed wastelands, and frozen tundras and evil monsters stand between the brave and their goal. Most of them could not survive the journey.Despite the odds, your party has decided to embark on this epic journey. Whether for riches, redemption, or renown, the stakes are high, and the path ahead is fraught with danger.")
    SLOWPRINT(100,"",promtForNameEN)
end

function monogatari1EN()
    print("monogatari1 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^^'Beyond the Northern Tundra lies the Crown of Eternity, a mythical artifact created by the God himself. It is said to grant unparalleled power or fulfill the deepest desire of whoever possesses it.'")
    SLOWPRINT(100,"",monogatari2EN)
end

function prologueJP()
    QUESLOWPRINT("プロローグ改")
    QUESLOWPRINT("物語は「千の物語の酒場」して知られる賑やかな酒場から始まる。この酒場は大陸の南端、ミストラルズ・エンドの街に位置し、冒険者、商人、そして旅人が宝と栄光の物語を共有するために集う場所だ。この町に冒険者用ギルドがないですが、この酒場がそのような役割を果たしてます。^^そこで再びあ伝説がるささやかれる。改")
    SLOWPRINT(100,"",monogatari1JP)
end

function monogatari2JP()
    print("monogatari2 called")
    RESETQUE()
    QUESLOWPRINT("改改多くの者がその遺物を手に入れようと挑んだが、北への旅路は非常に危険だ。古代の森、険しい山々、呪われた荒地、改そして凍てついたツンドラが勇者たちの前に立ちはだかる。それでもなお、君たちの仲間はこの壮大な旅に出ることを決意した。富のためか、贖罪のためか、それとも名声のためか、いずれにせよリスクは高く、前途は危険に満ちている。改")
    SLOWPRINT(100,"",promtForNameJP)
end

function monogatari1JP()
    print("monogatari1 called")
    RESETQUE()
    QUESLOWPRINT("改改「北のツンドラを越えた先に『永遠の冠』がある。それは神様自身が作り出したとされる神秘的な遺物だ。これを手にする者には無比の力が与えられるか、最も深い願いが叶えられるという。」改")
    SLOWPRINT(100,"",monogatari2JP)
end

function prologueES()
    QUESLOWPRINT("Prologo^")
    --           "123456780123456780123456780123456780123456780123456780123456780123456780"
    QUESLOWPRINT("El relato comienza en una taverna llena de gente conocida como la 'Taberna de los Mil Relatos', situada en el extremo más al sur del continente, en la ciudad de Mistral's end. ^Aventureros, comerciantes y viajeros se reúnen aquí para compartir historias de tesoros y gloria. Este pueblo no tiene un gremio de aventureros pero esta taverna hace una funcion simillar...^^La leyenda susurrada vuelve a surgir.:")
    SLOWPRINT(100,"",monogatari1ES)
end

function monogatari2ES()
    print("monogatari3 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^^^Muchos han intentado reclamar el artefacto, pero el viaje hacia el norte es peligroso. Bosques ancestrales, montañas mortales, montes malditos, tundras heladas y monstruos malvados se interponen entre los valientes y su objetivo. La mayoría no sobrevive al trayecto. A pesar de las probabilidades, tu grupo ha decidido embarcarse en esta épica travesía. Ya sea por riquezas, redención o renombre, el riesgo es alto, y el camino por delante está plagado con peligros.")
    SLOWPRINT(100,"",promtForNameES)
end

function monogatari1ES()
    print("monogatari1 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^^^'Más allá de la Tundra del Norte esta la Crown of eternity, un artefacto mítico creado por el Dios mismo. Se dice que otorga un poder sin igual o cumple el deseo más profundo de quien la posea.'")
    SLOWPRINT(100,"",monogatari2ES)
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
        --SLOWPRINT(100,"こんにちは世界！日本語の文章を試します、昔々あるところでおじいちゃんとばあちゃんがいました、おじいちゃんが芝刈りに、おばあちゃんが川で洗濯してました")
        
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