
local display = require( "display" )


function screenCheck( )
	
	print( "Content/actual width  : ", display.contentWidth, display.actualContentWidth )
	print( "Content/actual height : ", display.contentHeight, display.actualContentHeight )
	print( "" )
	print( "Origin X, Y : ", display.screenOriginX, display.screenOriginY )
	print( "Scale  X, Y : ", display.contentScaleX, display.contentScaleY )
	print( "Center X, Y :", display.contentCenterX, display.contentCenterY )
	print( "" )
	print( "Status bar height : ", display.statusBarHeight)

end