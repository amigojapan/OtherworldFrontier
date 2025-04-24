local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

local background=nil
globalSceneGroup=nil
function scene:create(event)
    local sceneGroup = self.view
    --globalSceneGroup=sceneGroup
end

local transitioning = false
local function returnToGame()
    print("returnToGame called")
    if transitioning then
       print("Already transitioning, skipping")
        return
    end
    transitioning = true
    hideTextArea()
    composer.setVariable("landmarksShown", false)
    composer.removeScene(composer.getSceneName("current"))
    composer.gotoScene(composer.getSceneName("previous"))
end

function shopAriveEN()
    RESETQUE()
    QUESLOWPRINT("^You have arrived at Melstorms Peak!^")
    QUESLOWPRINT("^^test line2^")
    QUESLOWPRINT("^^test line3^")
    QUESLOWPRINT("^flush this!^")
    SLOWPRINT(100, "", returnToGame)
end
function warriorAttack()
    local randomNumber=math.random(1,100)
    if randomNumber<15 then
        return true
    else
        return false
    end
end
function priestessAttack()
    local randomNumber=math.random(1,100)
    if randomNumber<27 then
        return true
    else
        return false
    end
end
function priestesstAlgorythm(priesitessGirl,message)
    if composer.getVariable("language") == "English" then
        if priesitessGirl.isAlive then
            if priesitessGirl.MP<30 then
                message=message..priesitessGirl.name .. "does not have 30 MP, so she cannot cast divine light spell, the angry goblin atatcks and you die.^"
                composer.setVariable("completlyFailed", true)
            else
                failed=priestessAttack()
                if failed then
                    message=message..priesitessGirl.name .. "'s divine light spell fails, the angry goblin atatcks and you die.^"
                    composer.setVariable("completlyFailed", true)
                else
                    message=message..priesitessGirl.name.." casts her divine light spell, a bright light shines from above and the golin runs away.^"
                    priesitessGirl.MP=priesitessGirl.MP-30
                end
            end
        else
            message=message..priesitessGirl.name .. "Nobody can deal with this problem, angry goblin atatcks and you die.^"
            composer.setVariable("completlyFailed", true)
        end
    elseif composer.getVariable("language") == "Japanese" then
        if priesitessGirl.isAlive then
            if priesitessGirl.MP<30 then
                message=message..priesitessGirl.name .. "が３０MPを持ってないから、聖なる光のおまじないが出せない。怒ったゴブリンが攻撃して、全チームが死ぬ。^"
                composer.setVariable("completlyFailed", true)
            else
                failed=priestessAttack()
                if failed then
                    message=message..priesitessGirl.name .. "の聖なる光のおまじないは失敗した。怒ったゴブリンが攻撃して、全チームが死ぬ。^"
                    composer.setVariable("completlyFailed", true)
                else
                    message=message..priesitessGirl.name.."が聖なる光のおまじないを唱え、空から眩しい光が照らしてくる、ゴブリンが逃げる。^"
                    priesitessGirl.MP=priesitessGirl.MP-30
                end
            end
        else
            message=message..priesitessGirl.name .. "誰もこの状況に対応できない。怒ったゴブリンが攻撃して全チームが死ぬ。^"
            composer.setVariable("completlyFailed", true)
        end
    elseif composer.getVariable("language") == "Spanish" then
        if priesitessGirl.isAlive then
            if priesitessGirl.MP<30 then
                message=message..priesitessGirl.name .. " no tiene 30 MP, asi que no puede hacer el hechizo de luz Divina. el duende furioso attaca y mueres.^"
                composer.setVariable("completlyFailed", true)
            else
                failed=priestessAttack()
                if failed then
                    message=message..priesitessGirl.name .. " el hechizo de la luz Divina falla, el duende furioso ataca y mueres.^"
                    composer.setVariable("completlyFailed", true)
                else
                    message=message..priesitessGirl.name.." suelta su hechizo de luz Divina, una luz muy brillante sale del ciello, asusta al duende y se escapa.^"
                    priesitessGirl.MP=priesitessGirl.MP-30
                end
            end
        else
            message=message..priesitessGirl.name .. " Nadie puede contender con este problema, el duende furioso te ataca y te mueres.^"
            composer.setVariable("completlyFailed", true)
        end    
    end
    return message
end
function shopAriveJP()
    RESETQUE()
    local textSpeed=100
    if composer.getVariable("backgroundImage") == "backgrounds/crown-of-eternity.png" then
        textSpeed=200
        QUESLOWPRINT("おめでとうございます!^")
        QUESLOWPRINT("心の願いが仲間を息が得る事だった、から、!^")
        QUESLOWPRINT("皆で仲良くハッピーエンド^")
        QUESLOWPRINT("^^ゲームプランナー・プログラマー・著作権：^")
        QUESLOWPRINT("パドウ・ウスマー・エー(amigojapan)^")
        QUESLOWPRINT("^グラフィックス・キャラクターデザイナー：若松 晶^")
        QUESLOWPRINT("^音声・音楽：Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/altEnding.png" then
        textSpeed=200
        QUESLOWPRINT("おめでとうございます!^")
        QUESLOWPRINT("君は固定観念に取ら割らない人です!^")
        QUESLOWPRINT("南西半島でゆっくりな海暮らしにしました。^")
        QUESLOWPRINT("^^ゲームプランナー・プログラマー・著作権：^")
        QUESLOWPRINT("パドウ・ウスマー・エー(amigojapan)^")
        QUESLOWPRINT("^グラフィックス・キャラクターデザイナー・プログラマー：若松 晶^")
        QUESLOWPRINT("^音声・音楽：Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Maelstrom-Peak.png" then
        QUESLOWPRINT("Maelstrom　Peakにようこそ!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Evermist-Hills.png" then
        QUESLOWPRINT("Evermist　Hillsにようこそ!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Enchanted-Spires.png" then
        QUESLOWPRINT("Enchanted Spiresにようこそ!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/frozen-tundra.png" then
        QUESLOWPRINT("旅は14日間以上掛かったから、ツンドラが凍って通れないんだ、^")
        QUESLOWPRINT("目的にたどり着けない。^^^         GAME OVER^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin1.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin2.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin3.png" then
        local characters = composer.getVariable("characters")
		local girlNumber=2
		local warriorGirl = characters[girlNumber]
        girlNumber=4
		local priesitessGirl = characters[girlNumber]	
		local message="怒ったゴブリンを見かっけた。^^"
        local failed=false
        if not priesitessGirl.isAlive and not warriorGirl.isAlive then
            message=message..warriorGirl.name.."と"..priesitessGirl.name.."が死んでる。この状況に誰も対応できない。怒ったゴブリンが攻撃する。チーム全員死んじゃう。^"
            composer.setVariable("completlyFailed", true)
        else
            if warriorGirl.isAlive then
                if warriorGirl.MP<30 then
                    message=message..warriorGirl.name .. "が３０MPがないから、コントールのおまじないが出来ない。^"
                    if priesitessGirl.isAlive then
                        message=priestesstAlgorythm(priesitessGirl,message)
                    end
                else
                    failed=warriorAttack()
                    if failed then
                        message=message..warriorGirl.name.."のおまじないが失敗した。彼女が死んじゃう。^"
                        warriorGirl.isAlive=false
                        if priesitessGirl.isAlive then
                            message=priestesstAlgorythm(priesitessGirl,message)
                        end
                    else
                        message=message..warriorGirl.name.."がソードを振り上げる。コントロールのおまじないを唱え、ゴブリンが歩いて帰る。^"
                        warriorGirl.MP=warriorGirl.MP-30
                    end
                end
            else
                if priesitessGirl.isAlive then
                    message=priestesstAlgorythm(priesitessGirl,message)
                end
            end
	    --composer.setVariable("warriorGirlMPAfterHunting", warriorGirl.MP)
        end
        composer.setVariable("warriodGirlDies", warriorGirl.isAlive)
        composer.setVariable("warriodGirlMP", warriorGirl.MP)
        composer.setVariable("priestGirlMP", priesitessGirl.MP)        
        QUESLOWPRINT(message)
    else
        QUESLOWPRINT("Erorr, landmark not found.^")
    end
    SLOWPRINT(textSpeed, "", returnToGame)
end
function shopAriveEN()
    RESETQUE()
    local textSpeed=100
    if composer.getVariable("backgroundImage") == "backgrounds/crown-of-eternity.png" then
        textSpeed=200
        QUESLOWPRINT("Congratulations!^")
        QUESLOWPRINT("your deepest wish was that your teammates come back from the dead!^")
        QUESLOWPRINT("they ressurect and you have a happy ending!^")
        QUESLOWPRINT("^^Game designer/Porgrammer/Copyrighht:^")
        QUESLOWPRINT("Usmar A. Padow (amigojapan)^")
        QUESLOWPRINT("^Graphics/Character designer：若松 晶^")
        QUESLOWPRINT("^Sound FX/Music:Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/altEnding.png" then
        textSpeed=200
        QUESLOWPRINT("Congratulations!^")
        QUESLOWPRINT("You are a person that thinks outside the box!^")
        QUESLOWPRINT("You live a slow beach life in south-eastern penninsula.^")
        QUESLOWPRINT("^^Game designer/Porgrammer/Copyrighht:^")
        QUESLOWPRINT("Usmar A. Padow (amigojapan)^")
        QUESLOWPRINT("^Graphics/Character designer:Akira Wakamatsu^")
        QUESLOWPRINT("^Sound FX/Music:Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        END.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Maelstrom-Peak.png" then
        QUESLOWPRINT("Welcome to Maelstrom Peak!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Evermist-Hills.png" then
        QUESLOWPRINT("Welcome to Evermist Hills!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Enchanted-Spires.png" then
        QUESLOWPRINT("Welcome to Enchanted Spires!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/frozen-tundra.png" then
        QUESLOWPRINT("The trip took more than 14 days, the Northen Tundra froze over,^")
        QUESLOWPRINT("You can't reach yoru destination^^^         GAME OVER^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin1.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin2.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin3.png" then
        local characters = composer.getVariable("characters")
		local girlNumber=2
		local warriorGirl = characters[girlNumber]
        girlNumber=4
		local priesitessGirl = characters[girlNumber]	
		local message="You spot an angry goblin.^^"
        local failed=false
        if not priesitessGirl.isAlive and not warriorGirl.isAlive then
            message=message..warriorGirl.name.." and "..priesitessGirl.name.."are dead, so nobody can deal with the angry goblin, he attacks you and you die.^"
            composer.setVariable("completlyFailed", true)
        else
            if warriorGirl.isAlive then
                if warriorGirl.MP<30 then
                    message=message..warriorGirl.name .. "does not have 30 MP, so she cannot cast her control spell^"
                    if priesitessGirl.isAlive then
                        message=priestesstAlgorythm(priesitessGirl,message)
                    end
                else
                    failed=warriorAttack()
                    if failed then
                        message=message..warriorGirl.name.."'s spell has failed, and she dies.^"
                        warriorGirl.isAlive=false
                        if priesitessGirl.isAlive then
                            message=priestesstAlgorythm(priesitessGirl,message)
                        end
                    else
                        message=message..warriorGirl.name.." holds her swrods up and casts her control spell and the goblin walks away.^"
                        warriorGirl.MP=warriorGirl.MP-30
                    end
                end
            else
                if priesitessGirl.isAlive then
                    message=priestesstAlgorythm(priesitessGirl,message)
                end
            end
	    --composer.setVariable("warriorGirlMPAfterHunting", warriorGirl.MP)
        end
        composer.setVariable("warriodGirlDies", warriorGirl.isAlive)
        composer.setVariable("warriodGirlMP", warriorGirl.MP)
        composer.setVariable("priestGirlMP", priesitessGirl.MP)        
        QUESLOWPRINT(message)
    else
        QUESLOWPRINT("Erorr, landmark not found.^")
    end
    SLOWPRINT(textSpeed, "", returnToGame)
end

function shopAriveES()
    RESETQUE()
    local textSpeed=100
    if composer.getVariable("backgroundImage") == "backgrounds/crown-of-eternity.png" then
        textSpeed=200
        QUESLOWPRINT("Felicidades!^")
        QUESLOWPRINT("Tu deseo mas intimo fue que tus amigas resusitaran!^")
        QUESLOWPRINT("Ellas vuelven a la vida! y tienes un final feliz!^")
        QUESLOWPRINT("^^Diseño del Juego/Programacion/Derechos reservados:^")
        QUESLOWPRINT("Usmar A. Padow (amigojapan)^")
        QUESLOWPRINT("^Diseñadora grafica y de personajes:Akira Wakamatsu^")
        QUESLOWPRINT("^Effectos de sonido/Musica:Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        FIN.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/altEnding.png" then
        textSpeed=200
        QUESLOWPRINT("Felicidades!^")
        QUESLOWPRINT("Tu eres una persona que puede pensar fuera del rectangulo!^")
        QUESLOWPRINT("Vives una vida lenta por la playa en la península sud-este.^")
        QUESLOWPRINT("^^Diseño del Juego/Programacion/Derechos reservados:^")
        QUESLOWPRINT("Usmar A. Padow (amigojapan)^")
        QUESLOWPRINT("^Diseñadora grafica y de personajes:Akira Wakamatsu^")
        QUESLOWPRINT("^Effectos de sonido/Musica:Albert Korman(Zcom)^")
        QUESLOWPRINT("^^        FIN.^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Maelstrom-Peak.png" then
        QUESLOWPRINT("Bienvenida a Maelstrom Peak!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Evermist-Hills.png" then
        QUESLOWPRINT("Bienvenida a Evermist Hills!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Enchanted-Spires.png" then
        QUESLOWPRINT("Bienvenida a Enchanted Spires!^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/frozen-tundra.png" then
        QUESLOWPRINT("El viaje tardo mas de 14 dias, La Tundra del Norte se congelo,^")
        QUESLOWPRINT("No puedes alcanzar tu destino.^^^         GAME OVER^")
    elseif composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin1.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin2.png" or composer.getVariable("backgroundImage") == "backgrounds/Angry-Goblin3.png" then
        local characters = composer.getVariable("characters")
		local girlNumber=2
		local warriorGirl = characters[girlNumber]
        girlNumber=4
		local priesitessGirl = characters[girlNumber]	
		local message="Te encuentas con un duende furioso.^^"
        local failed=false
        if not priesitessGirl.isAlive and not warriorGirl.isAlive then
            message=message..warriorGirl.name.." y "..priesitessGirl.name.." estan muertas, asi que nadie puede contender con el problema el duende furioso ataca y mueres.^"
            composer.setVariable("completlyFailed", true)
        else
            if warriorGirl.isAlive then
                if warriorGirl.MP<30 then
                    message=message..warriorGirl.name .. " no tiene 30 MP, no puede lanzar su hechizo de control^"
                    if priesitessGirl.isAlive then
                        message=priestesstAlgorythm(priesitessGirl,message)
                    end
                else
                    failed=warriorAttack()
                    if failed then
                        message=message.."El hechizo de " .. warriorGirl.name.." ha fallado, y ella se muere.^"
                        warriorGirl.isAlive=false
                        if priesitessGirl.isAlive then
                            message=priestesstAlgorythm(priesitessGirl,message)
                        end
                    else
                        message=message..warriorGirl.name.." sube su espada al cielo y lanza su hechizo de control, el duende se va caminando.^"
                        warriorGirl.MP=warriorGirl.MP-30
                    end
                end
            else
                if priesitessGirl.isAlive then
                    message=priestesstAlgorythm(priesitessGirl,message)
                end
            end
	    --composer.setVariable("warriorGirlMPAfterHunting", warriorGirl.MP)
        end
        composer.setVariable("warriodGirlDies", warriorGirl.isAlive)
        composer.setVariable("warriodGirlMP", warriorGirl.MP)
        composer.setVariable("priestGirlMP", priesitessGirl.MP)        
        QUESLOWPRINT(message)
    else
        QUESLOWPRINT("Erorr, landmark not found ES.^")
    end
    SLOWPRINT(textSpeed, "", returnToGame)
end

composer.setVariable("landmarksShown", false)
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "will") then
        print("scene:show in showLandmark")
    elseif (phase == "did") then
        if composer.getVariable("landmarksShown")
        then
            composer.setVariable("landmarksShown", true)
            return
        end
        print("background image: " .. composer.getVariable("backgroundImage"))
        
        background=nil
        background = display.newImageRect(composer.getVariable("backgroundImage"), 1000, 800)
        if background then
            background.x = display.contentCenterX
            background.y = display.contentCenterY
            print("background.parent == sceneGroup:", background.parent == sceneGroup)
            sceneGroup:insert( background )
        end
        print("language: " .. composer.getVariable("language"))
        if composer.getVariable("language") == "English" then
            initTextScreen(sceneGroup, "EN")
           --enableContinueButton()
            showTextArea()
            CLS()
            shopAriveEN()--I dont knbow what to rename this to
        elseif composer.getVariable("language") == "Japanese" then
            initTextScreen(sceneGroup, "JP")
            showTextArea()
            CLS()
            shopAriveJP()--I dont knbow what to rename this to
        elseif composer.getVariable("language") == "Spanish" then
            initTextScreen(sceneGroup, "ES")
            showTextArea()
            CLS()
            shopAriveES()--I dont knbow what to rename this to
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
end

function scene:destroy(event)
    local sceneGroup = self.view
    print("Destroying showLandmark scene")
    if background then
        background:removeSelf()
        background = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene