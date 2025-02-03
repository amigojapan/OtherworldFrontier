local composer = require("composer")
require("LinuxInputBox")
require("LinuxAlertBox")
require("slowprint")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
buggyObjNum=0
--[[
function clearBuggyObjects()
	print("Number of active display objects: " .. display.getCurrentStage().numChildren)
	for i = 1, display.getCurrentStage().numChildren do
		print("Object " .. i .. ": " .. tostring(display.getCurrentStage()[i]))
		--display.getCurrentStage()[2].isVisible=false--hack to hide hte invisible object that I do't know what it is
        -- this works three times
        if i==display.getCurrentStage().numChildren then
			if buggyObjNum==0 then  
                buggyObject=display.getCurrentStage()[i]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==1 then
                buggyObject=display.getCurrentStage()[i-1]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==2 then
                buggyObject=display.getCurrentStage()[i-2]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==3 then
                print("buggyObjNum==3")
                buggyObject=display.getCurrentStage()[7]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==4 then
                print("buggyObjNum==4")
                buggyObject=display.getCurrentStage()[i-buggyObject]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==5 then
                print("buggyObjNum==5")
                buggyObject=display.getCurrentStage()[i-5]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==6 then
                print("buggyObjNum==6")
                buggyObject=display.getCurrentStage()[i-6]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==7 then
                print("buggyObjNum==7")
                buggyObject=display.getCurrentStage()[i-buggyObject]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1

            end
			--buggyObject:removeSelf()
			--buggyObject=nil
		end
              
        
        if i==display.getCurrentStage().numChildren then
			if buggyObjNum==0 then  
                buggyObject=display.getCurrentStage()[i]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            elseif buggyObjNum==1 then
                buggyObject=display.getCurrentStage()[i-buggyObjNum]
                buggyObject.isVisible=false
                buggyObjNum=buggyObjNum+1
            end
			--buggyObject:removeSelf()
			--buggyObject=nil
		end
        
	end
end
]]
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
composer.gotoScene( "Adventurer4introduction", options )
end
local function alertBoxNoClickedCompleteEN()
    stableAriveEN()
end
local function alertBoxNoClickedCompleteJP()
    promtForNameJP()
end
local function alertBoxNoClickedCompleteES()
    promtForNameES()
end

function isInteger(str)

    return not (str == "" or str:find("%D"))  -- str:match("%D") also works
  
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
        QUESLOWPRINT("^^Sorry, the number of unicorns must be a number...^")
        SLOWPRINT(100,"",stableAriveEN)
    elseif tonumber(userinput)<1 then
        RESETQUE()
        QUESLOWPRINT("^^Sorry, you must buy at least one unicorn...^")
        SLOWPRINT(100,"",stableAriveEN)    
    else    
        composer.setVariable( "unicorncount", userinput)
        AlertBox(
        "",--no title
        "You want to buy:"..userinput..", unicorns right?",
        alertBoxYesClickedComplete,
        alertBoxNoClickedCompleteEN
        )
        --removerInputBox()
        --disableContinueButton()--this automatically gets enabled on the next screem so no need to enable it again
    end
end

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

function promptForNnumerOfUnicornsJP()
showInputBox("冒険者その１に名前を付けましょう：", askUserIfTheyLikeNameJP)
end
function promptForNnumerOfUnicornsEN()
showInputBox("how many unicorns do you want to buy?:", verifyPurchaseEN)
end

function promptForNnumerOfUnicornsES()
showInputBox("dale nombre a la aventurera 4:", askUserIfTheyLikeNameES)
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
    QUESLOWPRINT("^You have:"..composer.getVariable( "gold").."grams of gold:^")
    --           "1234567890123456789012345678901234567890"
    QUESLOWPRINT("^^each unicorn costs 100 grams of gold, how many unicorns do you want to buy?^")
    SLOWPRINT(100,"",promptForNnumerOfUnicornsEN)
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
            enableContinueButton()
            showTextArea()
            CLS()
            stableAriveEN()
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