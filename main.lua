
local display = require( "display" )
local widget = require( "widget" )
local composer = require( "composer" )

local sceneHandler = require("biji.sceneHandler")

display.setStatusBar( display.DefaultStatusBar )
widget.setTheme( "widget_theme_android_holo_light" )
composer.gotoScene( "demo", { effect = "slideUp" } )

sceneHandler.init( )

-- require( "test" )
-- runTest( )
