
local display = require( "display" )
local widget = require( "widget" )
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
		no = { 
			title = "NO", 
			width = 50,
			align = "center",
		},
		name = { 
			title = "NAME", 
			width = 200,
		},
		salary = { 
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
		{ no = 1, name = "M. Dedi Rudianto", salary = 9000 },
		{ no = 2, name = "XXXXX XXXXXX XXX", salary = 10000 },
		{ no = 3, name = "KJKI DFJKD F", salary = 100 },
	}

	gridview.deleteAllRows( )
	gridview.insertRows( rows )

end

function postTest( )
	
	local function networkListener( event )
	    if ( event.isError ) then
	        print( "Network error: ", event.response )
	    else
	        print ( "RESPONSE: " .. event.response )
	    end
	end

	local headers = {}

	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"

	local body = "telp=12345678&pin=&"--"telp=red&pin=small"

	local params = {}
	params.headers = headers
	params.body = body

	network.request( "http://118.98.64.210/jtccmbe/?c=account&a=login", "POST", networkListener, params )
end
