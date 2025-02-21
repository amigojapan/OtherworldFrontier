-- Copyright (c) 2017 Corona Labs Inc.
-- Code is MIT licensed and can be re-used; see https://www.coronalabs.com/links/code/license
-- Other assets are licensed by their creators:
--    Art assets by Kenney: http://kenney.nl/assets
--    Music and sound effect assets by Eric Matyas: http://www.soundimage.org

local composer = require( "composer" )

composer.recycleOnSceneChange = true -- force scene recycle

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to the menu screen
--composer.gotoScene( "title" )
composer.setVariable( "language", "English" )
composer.setVariable( "MCname", "amigojapan" )
composer.setVariable( "gold", 1000 )
composer.setVariable( "adventurer1", "tomako" )
composer.setVariable( "adventurer2", "chihiro" )
composer.setVariable( "adventurer3", "akira" )
composer.setVariable( "adventurer4", "toma" )
--composer.gotoScene( "nightShade" )
--composer.gotoScene( "fiveHeroinesTable" )
--composer.gotoScene( "unicornStable" )
--composer.gotoScene( "buyStoreItemGeneral" )
--composer.gotoScene( "ourHeroine" )
--composer.gotoScene( "nameAdventurer" )
--composer.gotoScene("unicornStableGeneral")
composer.gotoScene("mainGameScreen")