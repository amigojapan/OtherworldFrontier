local composer = require("composer")
--require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
require("helperFunctions")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--items to customize purchase
local composerVariable=composer.getVariable("setVariable")
local backgroundImage=composer.getVariable("backgroundImage")
local nextScreenName=composer.getVariable("nextScreenName")
local itemPrice=composer.getVariable("itemPrice")--10 grams of gold per kilogram of food
local itemSoldEN=composer.getVariable("itemSoldEN")
local itemCounterVariableEN=composer.getVariable("itemCounterVariableEN")
local itemSoldJP=composer.getVariable("itemSoldJP")
local itemCounterVariableJP=composer.getVariable("itemCounterVariableJP")
local itemSoldES=composer.getVariable("itemSoldES")
local itemCounterVariableES=composer.getVariable("itemCounterVariableES")

local numberOfItemsPurchased
local goldUsed
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    if composer.getVariable("inputBuffer") ==nil then
        composer.setVariable("inputBuffer", "input unset")
    end
end

-- Handler that gets notified when the alert closes
local function alertBoxYesClickedComplete()
    --continue on journey
    composer.setVariable("inputBuffer", "input unset")
    local options =
    {
        effect = "fade",
        time = 400,
        params = {
        }
    }
    composer.setVariable( composerVariable, numberOfItemsPurchased)
    composer.setVariable( "gold", composer.getVariable("gold")-GoldUsed)
    composer.removeScene( "current", options )
    print("going to scene:"..nextScreenName)
    composer.gotoScene( "unicornStableGeneral", options )
end
local function alertBoxNoClickedCompleteEN()
    enableContinueButton()
    shopAriveEN()
end
local function alertBoxNoClickedCompleteJP()
    enableContinueButton()
    shopAriveJP()
end
local function alertBoxNoClickedCompleteES()
    enableContinueButton()
    shopAriveES()
end


function verifyPurchaseEN(userinput)
    print("userinput:"..userinput)
    if not isInteger(userinput) then
        print("is not integer")
        RESETQUE()
        QUESLOWPRINT("^^Sorry, the number of "..itemCounterVariableEN.." must be a numeric value...^")                    
        SLOWPRINT(100,"",shopAriveEN)
        enableContinueButton()
    else
        local price=tonumber(userinput)*itemPrice--100 is price per item
        if price>composer.getVariable( "gold") then
            RESETQUE()
            QUESLOWPRINT("^^Sorry, you don't have enough gold ^")
            QUESLOWPRINT("for that purchase...^")                
            SLOWPRINT(100,"",shopAriveEN)    
            enableContinueButton()
        else
            GoldUsed=price
            numberOfItemsPurchased=tonumber(userinput)
            AlertBox(
            "",--no title
            "You want to buy:"..userinput..", "..itemCounterVariableEN.." right?",
            alertBoxYesClickedComplete,
            alertBoxNoClickedCompleteEN
            )
        end
    end
end


function verifyPurchaseJP(userinput)
    print("userinput:"..userinput)
    if not isInteger(userinput) then
        print("is not integer")
        RESETQUE()
        QUESLOWPRINT("^^すみません、"..itemCounterVariableJP.."の個数は数字じゃないといけないです…^")
        SLOWPRINT(100,"",shopAriveJP)
        enableContinueButton()                    
    else
        local price=tonumber(userinput)*itemPrice--100 is price per item
        if price>composer.getVariable( "gold") then
            RESETQUE()
            QUESLOWPRINT("^^すみません、金がたりないです…^")
            SLOWPRINT(100,"",shopAriveJP)
            enableContinueButton()                    
        else
            GoldUsed=price
            numberOfItemsPurchased=tonumber(userinput)
            AlertBox(
            "",--no title
            "「"..itemCounterVariableJP.."]"..userinput.."個でいいですね？",
            alertBoxYesClickedComplete,
            alertBoxNoClickedCompleteJP
            )
        end
    end
end



function verifyPurchaseES(userinput)
    print("userinput:"..userinput)
    if not isInteger(userinput) then
        print("is not integer")
        RESETQUE()
        QUESLOWPRINT("^^Perdon, el numero de "..itemCounterVariableES.." tiene que ser un valor numerico...^")
        SLOWPRINT(100,"",shopAriveES)
        enableContinueButton()                    
    else
        local price=tonumber(userinput)*itemPrice--100 is price per item
        if price>composer.getVariable( "gold") then
            RESETQUE()
            QUESLOWPRINT("^^Perdon, no tienes suficiente oro ^")
            QUESLOWPRINT("para hacer esa compra...^")
            SLOWPRINT(100,"",shopAriveES)                    
            enableContinueButton()                    
        else
            GoldUsed=price
            numberOfItemsPurchased=tonumber(userinput)
            AlertBox(
            "",--no title
            "Quieres comprar:"..userinput..", "..itemCounterVariableES.." verdad?",
            alertBoxYesClickedComplete,
            alertBoxNoClickedCompleteES
            )
        end
    end
end

function promptItemCountdJP()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt","How many "..itemCounterVariableEN.." do you want to buy?:")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
end
function promptItemCountdEN()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt","How many "..itemCounterVariableEN.." do you want to buy?:")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
end

function promptItemCountdES()
    composer.setVariable("inputBuffer","input unset")
    composer.setVariable("inputBoxPrompt","How many "..itemCounterVariableEN.." do you want to buy?:")
    composer.gotoScene("LinuxScreenKeyboardScene")
    disableContinueButton()
end

function shopAriveEN()
    RESETQUE()
    QUESLOWPRINT("^You have:"..composer.getVariable( "gold").." grams of gold:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^Shop Item called \""..itemSoldEN.."\"^")
    QUESLOWPRINT("costs ".. itemPrice .." grams of gold ^")
    QUESLOWPRINT("per "..itemCounterVariableEN..", how many ^")
    QUESLOWPRINT(itemCounterVariableEN.." do you want to buy?^")
    SLOWPRINT(100,"",promptItemCountdEN)
end

function shopAriveJP()
    RESETQUE()
    QUESLOWPRINT("^金"..composer.getVariable( "gold").."グラムを持っている：^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^「"..itemSoldJP.."」と言うアイテムが^")
    QUESLOWPRINT(itemCounterVariableJP.."が金".. itemPrice .."グラムする。^")
    QUESLOWPRINT(itemCounterVariableJP.."何個買いたいのか？^")
    SLOWPRINT(100,"",promptItemCountdJP)
end

function shopAriveES()
    RESETQUE()
    QUESLOWPRINT("^Tienes:"..composer.getVariable( "gold").." gramos de oro:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^El artículo llamado \""..itemSoldES.."\"^")
    QUESLOWPRINT("cuesta ".. itemPrice .." gramos de oro ^")
    QUESLOWPRINT("por cada "..itemCounterVariableES..", cuantos ^")
    QUESLOWPRINT(itemCounterVariableES.." quieres comprar?^")
    SLOWPRINT(100,"",promptItemCountdES)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        --background
        local background = display.newImageRect( sceneGroup, backgroundImage, 1000,800 )
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        
        if composer.getVariable("inputBuffer") ~= "input unset" then           
            if composer.getVariable( "language" ) == "English" then
                initTextScreen(sceneGroup,"EN")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyPurchaseEN(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Japanese" then
                initTextScreen(sceneGroup,"JP")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyPurchaseJP(composer.getVariable("inputBuffer"))
                return
            elseif composer.getVariable( "language" ) == "Spanish" then
                initTextScreen(sceneGroup,"ES")
                showTextArea()
                CLS()
                disableContinueButton()
                verifyPurchaseES(composer.getVariable("inputBuffer"))
                return
           end
        end
        --cleanupInvisibleObjects(display.getCurrentStage(),sceneGroup)
        print("language:"..composer.getVariable( "language" ))
        if composer.getVariable( "language" ) == "English" then
            --clearBuggyObjects()
            initTextScreen(sceneGroup,"EN")
            enableContinueButton()
            showTextArea()
            CLS()
            shopAriveEN()
        elseif composer.getVariable( "language" ) == "Japanese" then
            initTextScreen(sceneGroup,"JP")
            showTextArea()
            CLS()
            shopAriveJP()
        elseif composer.getVariable( "language" ) == "Spanish" then
            initTextScreen(sceneGroup,"ES")
            showTextArea()
            CLS()
            shopAriveES()
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
--first fix this to be all langauges, then fix the same stuff for the parts of the game that are finished