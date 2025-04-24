local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
require("helperFunctions")
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
			if buggyObject then
                buggyObject.isVisible=false
            end
			--buggyObject:removeSelf()
			--buggyObject=nil
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
local sceneGroup = self.view
-- Code here runs when the scene is first created but has not yet appeared on screen
end

local UnicornsPurchased
local GoldUsed
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
    composer.setVariable( "unicorncount", UnicornsPurchased)
    composer.setVariable( "gold", composer.getVariable("gold")-GoldUsed)
    composer.gotoScene( "humanStoreFood", options )
end
local function alertBoxNoClickedCompleteEN()
    stableAriveEN()
end
local function alertBoxNoClickedCompleteJP()
    stableAriveJP()
end
local function alertBoxNoClickedCompleteES()
    stableAriveES()
end

  
function verifyPurchaseEN(userinput)
    print ("display.getCurrentStage().numChildren"..display.getCurrentStage().numChildren)
    local buggyObject=display.getCurrentStage()[display.getCurrentStage().numChildren-1]--hack to hide hte invisible object that I do't know what it is    
    setAllObjectsHitTestable(display.getCurrentStage(), true) 
    buggyObject.isVisible=false
    LinuxInputBoxElements.isVisible=false
    print("userinput:"..userinput)
    if not isInteger(userinput) then
        RESETQUE()
        QUESLOWPRINT("^^Sorry, the number of unicorns must be a numeric value...^")
        SLOWPRINT(100,"",stableAriveEN)
    elseif tonumber(userinput)<1 then
        RESETQUE()
        QUESLOWPRINT("^^Sorry, you must buy at least one unicorn...^")
        SLOWPRINT(100,"",stableAriveEN)    
    elseif tonumber(userinput)>=1 then
        local price=tonumber(userinput)*100--100 is price per item
        if price>composer.getVariable( "gold") then
            RESETQUE()
            QUESLOWPRINT("^^Sorry, don't have enough gold for that purchase...^")
            SLOWPRINT(100,"",stableAriveEN)                    
        else
            GoldUsed=price
            UnicornsPurchased=tonumber(userinput)
            --LinuxAlertBoxElements.isVisible=false
            AlertBox(
            "",--no title
            "You want to buy:"..userinput..", unicorns right?",
            alertBoxYesClickedComplete,
            alertBoxNoClickedCompleteEN
            )
            --LinuxAlertBoxElements.isVisible=false
            --removerInputBox()
            --disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again    
        end
    end
end


function verifyPurchaseES(userinput)
    print ("display.getCurrentStage().numChildren"..display.getCurrentStage().numChildren)
    local buggyObject=display.getCurrentStage()[display.getCurrentStage().numChildren-1]--hack to hide hte invisible object that I do't know what it is    
    setAllObjectsHitTestable(display.getCurrentStage(), true) 
    buggyObject.isVisible=false
    LinuxInputBoxElements.isVisible=false
    print("userinput:"..userinput)
    if not isInteger(userinput) then
        RESETQUE()
        QUESLOWPRINT("^^Perdon, el numero de unicornios tiene que ser un valor numerico...^")
        SLOWPRINT(100,"",stableAriveES)
    elseif tonumber(userinput)<1 then
        RESETQUE()
        QUESLOWPRINT("^^Perdon, tienes que comprar por lo menos un unicorno...^")
        SLOWPRINT(100,"",stableAriveES)    
    elseif tonumber(userinput)>=1 then
        local price=tonumber(userinput)*100--100 is price per item
        if price>composer.getVariable( "gold") then
            RESETQUE()
            QUESLOWPRINT("^^Perdon, no tienes suficiente oro para hacer esa compra...^")
            SLOWPRINT(100,"",stableAriveEN)                    
        else
            GoldUsed=price
            UnicornsPurchased=tonumber(userinput)
            --LinuxAlertBoxElements.isVisible=false
            AlertBox(
            "",--no title
            "Quieres comprar:"..userinput..", unicornios verdad?",
            alertBoxYesClickedComplete,
            alertBoxNoClickedCompleteES
            )
            --LinuxAlertBoxElements.isVisible=false
            --removerInputBox()
            --disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again    
        end
    end
end

--[[
function askUserIfTheyLikeNameJP(userinput)
composer.setVariable( "adventurer4", userinput)
AlertBox(
"冒険者その4",
"名前は:"..userinput.."でよろしいですか？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteJP
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
function askUserIfTheyLikeNameES(userinput)
composer.setVariable( "adventurer4", userinput)
AlertBox(
"la aventurera 4",
"se llama:"..userinput..", bien？",
alertBoxYesClickedComplete,
alertBoxNoClickedCompleteES
)
removerInputBox()
disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
end
]]
function promptForNnumerOfUnicornsJP()
    disableContinueButton()
    showInputBox("ユニコーン何頭買いたいですか？：", verifyPurchaseJP)
end
function promptForNnumerOfUnicornsEN()
    disableContinueButton()
    showInputBox("how many unicorns do you want to buy?:", verifyPurchaseEN)
end

function promptForNnumerOfUnicornsES()
    disableContinueButton()
    showInputBox("cuantos unicornios quieres comprar?:", verifyPurchaseES)
end

function welcomeHeroineJP()
    RESETQUE()
    QUESLOWPRINT(composer.getVariable( "adventurer3").."のストーリー：改")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").."は改子供の頃「エバブルーム。シケット」の荒地に捨てられた。改"..composer.getVariable( "adventurer3").."は改森の精霊に育てられ、野生の魔法を教わった。彼女の魔法の力は強いが、失敗すると何が起こるか分からない不安定なものだった…。")
    SLOWPRINT(100,"",promtForNameEN)
end


function stableAriveEN()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^You have:"..composer.getVariable( "gold").." grams of gold:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^each unicorn costs 100 grams of gold,^")
    QUESLOWPRINT("how many unicorns do you want to buy?^")
    SLOWPRINT(100,"",promptForNnumerOfUnicornsEN)
end


function stableAriveES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("^Tienes:"..composer.getVariable( "gold").." gramos de oro:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^cada unicornio cuesta 100 gramos de oro, cuantos unicornios quieres comprar?^")
    SLOWPRINT(100,"",promptForNnumerOfUnicornsES)
end

function welcomeHeroineES()
    --CLS()
    --LOCATE(1,1)
    RESETQUE()
    QUESLOWPRINT("la historia de "..composer.getVariable( "adventurer3")..":")
    QUESLOWPRINT("^^"..composer.getVariable( "adventurer3").." fue abandonada de niña en el bosque magico llamado Everbloom Thicket, a "..composer.getVariable( "adventurer3").." la cuidaron los espiritus del bosque los cuales le enseñaron magia antigua y sin dominio. Sus poderes son formidables, pero inpredecibles, en moemntos tensos esa magia puede causar caos....")
    SLOWPRINT(100,"",promtForNameEN)
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
        local background = display.newImageRect( sceneGroup, "backgrounds/unicorn-stable.png", 1000,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
        -- Code here runs when the scene is entirely on screen
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            initTextScreen(sceneGroup,"EN")
            --enableContinueButton()
            showTextArea()
            CLS()
            stableAriveEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            stableAriveJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            stableAriveES()
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