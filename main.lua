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
composer.gotoScene( "title" )


composer.setVariable( "language", "Japanese" )
composer.setVariable( "MCname", "Iris" )
composer.setVariable( "gold", 4000 )
composer.setVariable( "adventurer1", "Rose" )
composer.setVariable( "adventurer2", "Lily" )
composer.setVariable( "adventurer3", "Lilac" )
composer.setVariable( "adventurer4", "Viera" )
--composer.gotoScene( "nightShade" )
--composer.gotoScene( "fiveHeroinesTable" )
--composer.gotoScene( "unicornStable" )
--composer.gotoScene( "buyStoreItemGeneral" )
--composer.gotoScene( "ourHeroine" )
--composer.gotoScene( "nameAdventurer" )
--composer.gotoScene("unicornStableGeneral")


-- Initialize other game variables if needed
if composer.getVariable("HPpotions") == nil then
    composer.setVariable("HPpotions", 0)
end
if composer.getVariable("MPpotions") == nil then
    composer.setVariable("MPpotions", 0)
end
composer.setVariable("NumberOfUnicorns", 20)
composer.setVariable("KGofFood", 0)
--composer.gotoScene("mainGameScreen")

--composer.gotoScene( "trialPeriodOver" )