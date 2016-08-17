
local display = require( "display" )

local grid = require( "biji.gridView" )

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

function gridTest(  )
	
	local columns = {
		{ 
			title = "NO", 
			width = 50,
			align = "center",
		},
		{ 
			title = "NAME", 
			width = 200,
		},
		{ 
			title = "SALARY", 
			width = 100,
			align = "right",
			isNumber = true,
		},
	}

	local gridview = grid.newGridView {
		x = 160,
		y = 130,
		width = 200,
		height = 300,
		columns = columns,
	}

	local rows = {
		{ 1, "M. Dedi Rudianto", 9000 },
		{ 2, "XXXXX XXXXXX XXX", 10000 },
		{ 3, "KJKI DFJKD F", 100 },
	}

	gridview.insertRows( rows )

end
