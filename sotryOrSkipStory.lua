require("i18n_dict")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

print( "ORIENTATION: "..system.orientation )
local function gotoStory()
	composer.gotoScene( "tavern" )
end

local function gotoSkipStory()
	composer.gotoScene( "mainGameScreen" )
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
		local background = display.newImageRect( sceneGroup, "backgrounds/Otherword-Frontier-Intro-screen.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1500-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )
		
		offsetY=300
		local lblTitle = display.newText( sceneGroup, "choose,選択して下さい、escoje", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		
		offsetY=offsetY+300
		local btnStory = display.newText( sceneGroup, "Story Mode、ストリーモード, Modo de historia", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnStory:setFillColor( 0.82, 0.86, 1 )
		btnStory:addEventListener( "tap", gotoStory )
		offsetY=offsetY+50
		local btnSkipSotry = display.newText( sceneGroup, "Skip Story、ストリーを飛ばす, No ver historia", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnSkipSotry:setFillColor( 0.82, 0.86, 1 )
		btnSkipSotry:addEventListener( "tap", gotoSkipStory )
		offsetY=offsetY+100
		local lblHope = display.newText( sceneGroup, "We would like you to see the story at least once.", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblHope:setFillColor( 1, 1, 0 )
		offsetY=offsetY+50
		local lblHope = display.newText( sceneGroup, "一回はストリーを見て欲しいです。", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblHope:setFillColor( 1, 1, 0 )
		offsetY=offsetY+50
		local lblHope = display.newText( sceneGroup, "Nos gustaria que lean la historia por lo menos una vez.", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblHope:setFillColor( 1, 1, 0 )
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
