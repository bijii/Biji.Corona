
local display = require( "display" )
local widget = require( "widget" )
local composer = require( "composer" )

display.setStatusBar( display.DefaultStatusBar )
widget.setTheme( "widget_theme_android_holo_light" )
composer.gotoScene( "demo", { effect = "slideUp" } )

-- require( "test" )
-- runTest( )
