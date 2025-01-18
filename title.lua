require("i18n_dict")
require("trial")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
characterTimer=nil
function gotoMenu()
	timer.cancel(characterTimer)
	local options =
	{
		effect = "fade",
		time = 400,
		params = {
		}
	}
	composer.gotoScene( "menu", options )
end


print( "ORIENTATION: "..system.orientation )
function sendToDIfferentTrialStates()
	local trialState=trialAlgorythm()
	if trialState == "Free version" or trialState == "Trial period valid" then
		composer.gotoScene( "chooseStudyLanguage" )
	elseif trialState == "Trial period over" then
		composer.gotoScene( "trialPeriodOver" )
	elseif trialState == "Trial period start" then
		composer.gotoScene( "trialPeriodStart" )
	end
end

local function gotoSettingsMenu()
	composer.gotoScene( "SettingsMenu" )
end

local function setDefaultSpeed()
	speed = composer.getVariable( "speed" )
	if not speed then
		speed="1"
	end
	print("speed:"..speed)
	composer.setVariable( "speed", speed )
end


function gotoStudyLanguageRomajiInRomaji()
	composer.setVariable( "language", "Romaji" )
	sendToDIfferentTrialStates()
end

local function gotoGameEnglish()
	composer.setVariable( "language", "English" )
	sendToDIfferentTrialStates()
end

local function gotoGameJapanese()
	composer.setVariable( "language", "Japanese" )
	sendToDIfferentTrialStates()
end

local function gotoGameSpanish()
	composer.setVariable( "language", "Spanish" )
	sendToDIfferentTrialStates()
end

local function gotoHighScores()
	composer.gotoScene( "scoresScreen" )
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
	musicTrack = audio.loadStream( "audio/Base-Game-Loop.mp3",system.ResourceDirectory)


	-- Play the background music on channel 1, loop infinitely 
	audio.play( musicTrack, { channel=1, loops=-1 } )


	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		print("Removed scene")
		--composer.removeScene( "game" )
		local background = display.newImageRect( sceneGroup, "backgrounds/Otherword-Frontier-Intro-screen.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		local lblTitle = display.newText( sceneGroup, "Otherworld Frontier", display.contentCenterX, display.contentCenterY, "fonts/ume-tgc5.ttf", 130 )
		lblTitle:setFillColor( 0, 0,0 )
		characterTimer=timer.performWithDelay( 5000, gotoMenu, 0  )
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
