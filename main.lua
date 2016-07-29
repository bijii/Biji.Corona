
local display = require( "display" )
local widget = require( "widget" )
local flatColors = require( "biji.flatColors" )

display.setDefault( "background", unpack(flatColors.wetasphalt) )
display.setStatusBar( display.DefaultStatusBar )

widget.setTheme( "widget_theme_android_holo_light" )

require( "test" )
runTest( )
