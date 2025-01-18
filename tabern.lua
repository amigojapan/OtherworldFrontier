local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

require("slowprint")

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
end
function prologueEN()
    QUESLOWPRINT("Prologue^")
    --           "123456780123456780123456780123456780123456780123456780123456780123456780"
    QUESLOWPRINT("The tale begins in the bustling tavern known as the 'Tavern of a ^")
    QUESLOWPRINT("Thousand Tales', nestled on　the southernmost edge of the continent in^")
    QUESLOWPRINT("the city of Mistral's End. Adventurers, traders, and wanderers gather^") 
    QUESLOWPRINT("here to share tales of treasure and glory.  The tabernand it also^")
    QUESLOWPRINT("works like an unofficial guild. A whispered legend emerges once again:^^")
    SLOWPRINT(100,"",monogatari1EN)
end

function monogatari2EN()
    print("monogatari3 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^^Many have tried to claim the artifact, but the journey north is perilous. Ancient forests, deadly mountains, cursed wastelands, and frozen tundras and evil monsters stand between the brave and their goal. Most of them could not survive the journey.Despite the odds, your party has decided to embark on this epic journey. Whether for riches, redemption, or renown, the stakes are high, and the path ahead is fraught with danger.")
    SLOWPRINT(100,"",prologueEN)
end

function monogatari1EN()
    print("monogatari1 called")
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("'Beyond the Northern Tundra lies the Crown of Eternity, a mythical artifact created by the God himself. It is said to grant unparalleled power or fulfill the deepest desire of whoever possesses it.'")
    SLOWPRINT(100,"",monogatari2EN)
end

function prologue()
    QUESLOWPRINT("プロローグ改")
    QUESLOWPRINT("物語は「千の物語の酒場」して知られる賑やかな酒場から始まる。この酒場は大陸の南端、ミストラルの終わりの街に位置し、冒険者、商人、そして旅人が宝と栄光の物語を共有するために集う場所だ。そこで再びささやかれる伝説がある。改")
    SLOWPRINT(100,"",monogatari1)
end

function monogatari2()
    print("monogatari2 called")
    RESETQUE()
    QUESLOWPRINT("多くの者がその遺物を手に入れようと挑んだが、北への旅路は非常に危険だ。古代の森、険しい山々、呪われた荒地、改そして凍てついたツンドラが勇者たちの前に立ちはだかる。それでもなお、君たちの仲間はこの壮大な旅に出ることを決意した。富のためか、贖罪のためか、それとも名声のためか、いずれにせよ賭け金は高く、前途は危険に満ちている。改")
    SLOWPRINT(100,"",prologue)
end

function monogatari1()
    print("monogatari1 called")
    RESETQUE()
    QUESLOWPRINT("「北のツンドラを越えた先に『永遠の冠』がある。それは神様自身が作り出したとされる神秘的な遺物だ。これを手にする者には無比の力が与えられるか、最も深い願いが叶えられるという。」改")
    SLOWPRINT(100,"",monogatari2)
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
            prologue()
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