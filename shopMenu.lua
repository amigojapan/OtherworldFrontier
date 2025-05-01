require("i18n_dict")
require("trial")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local btnVisitChurch

local function visitChurch()
    language=composer.getVariable( "language" )
    if language=="English" then
	    btnVisitChurch.text="All curses have been lifted"
    elseif language=="Japanese" then
        btnVisitChurch.text="全人の呪いが解けた"
    elseif language=="Japanese" then
        btnVisitChurch.text="Todas las maldiciones se han curado"
    end
    btnVisitChurch:setFillColor( 0, 1, 0 )
    local characters = composer.getVariable("characters") 
    for girlNumber=1,5,1 do--init,maxval,step
        char=characters[girlNumber]
        if char.isAlive then
            if char.isCursed then
                char.isCursed=false
            end
        end
    end
    composer.setVariable("characters", characters)
end


function returnToMainGameScreen()
	composer.gotoScene("mainGameScreen")
end

function gotoPurchaseFood()
    composer.gotoScene("FoodSuppliesShopGeneral")
end

function gotoUnicornStableGeneral()
    composer.gotoScene("unicornStableGeneral")
end

function gotoPurchaseHPPotions()
    composer.gotoScene("HPPotionsShopGeneral")
end

function gotoPurchaseMPPotions()
    composer.gotoScene("MPPotionsShopGeneral")
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

audio.reserveChannels( 1 )
	--stop music
	audio.stop( 1 )
	-- Reduce the overall volume of the channel
	audio.setVolume( 0.3, { channel=1 } )


	-- Load audio
	--musicTrack = audio.loadStream( "audio/Base-Game-Loop.mp3",system.ResourceDirectory)


	-- Play the background music on channel 1, loop infinitely 
	--audio.play( musicTrack, { channel=1, loops=-1 } )


	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		print("Removed scene menu")
		--composer.removeScene( "game" )
		local background = display.newImageRect( sceneGroup, "backgrounds/human-shop.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )
		
		offsetY=175
        language=composer.getVariable( "language" )
		translate=i18n_setlang(language)
		local lblTitle = display.newText( sceneGroup, translate["Shop"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 1, 1, 1 )
 
		offsetY=offsetY+100
        local lblGold = display.newText( sceneGroup, translate["Gold"].." "..composer.getVariable("gold")..translate["grams"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblGold:setFillColor( 1, 1, 1 )

        offsetY=offsetY+100
        btnVisitChurch = display.newText( sceneGroup, translate["Visit church"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnVisitChurch:setFillColor( 0.82, 0.86, 1 )
        btnVisitChurch:addEventListener( "tap", visitChurch )
	

		offsetY=offsetY+75
        local btnPurchaseFood = display.newText( sceneGroup, translate["Purchase Food"].." "..translate["Item count"].." "..composer.getVariable("KGofFood").." KG,"..translate["Price"]..":10g", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnPurchaseFood:setFillColor( 0.82, 0.86, 1 )
        btnPurchaseFood:addEventListener( "tap", gotoPurchaseFood )

		offsetY=offsetY+75
        local btnPurchaseMPPotions = display.newText( sceneGroup, translate["Purchase MP Potions"].." "..translate["Item count"].." "..composer.getVariable("MPpotions")..","..translate["Price"]..":30g", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
        btnPurchaseMPPotions:setFillColor( 0.82, 0.86, 1 )
	    btnPurchaseMPPotions:addEventListener( "tap", gotoPurchaseMPPotions )


        offsetY=offsetY+75
        local btnPurchaseHPPotions = display.newText( sceneGroup, translate["Purchase HP Potions"].." "..translate["Item count"].." "..composer.getVariable("HPpotions")..","..translate["Price"]..":50g", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnPurchaseHPPotions:setFillColor( 0.82, 0.86, 1 )
	    btnPurchaseHPPotions:addEventListener( "tap", gotoPurchaseHPPotions )


        offsetY=offsetY+75
        local btnPurchaseUnicorns = display.newText( sceneGroup, translate["Purchase Unicorns"].." "..translate["Item count"].." "..composer.getVariable("NumberOfUnicorns")..","..translate["Price"]..":100g", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnPurchaseUnicorns:setFillColor( 0.82, 0.86, 1 )
	    btnPurchaseUnicorns:addEventListener( "tap", gotoUnicornStableGeneral )
	
        offsetY=offsetY+100
        local btnRetunToGame = display.newText( sceneGroup, translate["Leave Town"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnRetunToGame:setFillColor( 0.82, 0.86, 1 )
	    btnRetunToGame:addEventListener( "tap", returnToMainGameScreen )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
