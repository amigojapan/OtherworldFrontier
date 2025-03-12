require("i18n_dict")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

print( "ORIENTATION: "..system.orientation )
local function gotoSotryOrSkipStory()
	composer.gotoScene( "sotryOrSkipStory" )
end

local function easyMode()
	composer.setVariable( "difficulty", "easy" )
	composer.setVariable( "gold", 16000 )
	composer.setVariable("HPpotions", 50)
	composer.setVariable("MPpotions", 50)
	composer.setVariable("NumberOfUnicorns", 40)
	composer.setVariable("KGofFood", 100)
	gotoSotryOrSkipStory()
end


local function normalMode()
	composer.setVariable( "difficulty", "normal" )
	composer.setVariable( "gold", 4000 )
	composer.setVariable("HPpotions", 5)
	composer.setVariable("MPpotions", 5)
	composer.setVariable("NumberOfUnicorns", 20)
	composer.setVariable("KGofFood", 50)
	gotoSotryOrSkipStory()
end

local function difficultMode()
	composer.setVariable( "difficulty", "hard" )
	composer.setVariable( "gold", 400 )
	composer.setVariable("HPpotions", 0)
	composer.setVariable("MPpotions", 0)
	composer.setVariable("NumberOfUnicorns", 2)
	composer.setVariable("KGofFood", 0)
	gotoSotryOrSkipStory()
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
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )
		
		offsetY=300
		local lblTitle = display.newText( sceneGroup, "Difficulty、難易度, Difficultad", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		
		offsetY=offsetY+300
		local btnEasy = display.newText( sceneGroup, "Easy、簡単, Facil", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnEasy:setFillColor( 0.82, 0.86, 1 )
		btnEasy:addEventListener( "tap", easyMode )
		offsetY=offsetY+50
		local btnNormal = display.newText( sceneGroup, "Normal、普通, Normal", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnNormal:setFillColor( 0.82, 0.86, 1 )
		btnNormal:addEventListener( "tap", normalMode )
		offsetY=offsetY+50
		local btnHard = display.newText( sceneGroup, "Hard、難しい, Difficil", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnHard:setFillColor( 0.82, 0.86, 1 )
		btnHard:addEventListener( "tap", difficultMode )
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
