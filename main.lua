
local display = require( "display" )
local widget = require( "widget" )
local composer = require( "composer" )

local flatColors = require( "biji.flatColors" )

display.setDefault( "background", unpack( flatColors.clouds ) )
display.setStatusBar( display.DefaultStatusBar )

widget.setTheme( "widget_theme_android_holo_light" )
composer.gotoScene( "demo", { effect = "slideUp" } )

-- require( "test" )
-- runTest( )
