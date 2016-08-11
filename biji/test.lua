
local display = require( "display" )


function screenTest( )
	
	print( "Content/actual width  : ", display.contentWidth, display.actualContentWidth )
	print( "Content/actual height : ", display.contentHeight, display.actualContentHeight )
	print( "" )
	print( "Origin X, Y : ", display.screenOriginX, display.screenOriginY )
	print( "Scale  X, Y : ", display.contentScaleX, display.contentScaleY )
	print( "Center X, Y :", display.contentCenterX, display.contentCenterY )
	print( "" )
	print( "Status bar height : ", display.statusBarHeight)

end

function networkTest( onComplete )
	
	local url = "http://118.98.64.210/jtccmbe"

	network.request( url, "GET", function ( event )
		if (event.isError) then
			print( "Network error: " .. event.response )
		else
			print( "RESPONSE: " .. event.response )
		end

		onComplete( event )
	end )

end
