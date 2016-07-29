
local flatColors = require( "biji.flatColors" )
local flatButton = require( "biji.flatButton" )
local notif = require( "biji.notification" )
local header = require( "biji.header" )
local menu = require( "biji.menu" )

local function onButtonRelease( event )

	notif.loading( "Memulai proses..." )

	timer.performWithDelay( 2000, function( event )
		notif.showInfo( "Selesai" )		
		-- notif.showError( "Error" )		
	end )

end

local function buttonTest(  )

	local x = display.contentCenterX
	local y = display.contentCenterY

	local text = display.newText {
		text = "Biji", 
		align = "center", 
		x = x, 
		y = y - 30, 
		width = display.contentWidth,
		font = "fonts/Fabrica", 
		fontSize = 30 
	}

	text:setFillColor( unpack(flatColors.concrete) )

	local button = flatButton.newButton { 
		width = display.actualContentWidth,
		height = 40,
		color = flatColors.greensea,
		text = "LOGIN",
		textSize = 24,
		-- textAlign = "right",
		x = display.contentCenterX,
		y = display.contentHeight - 20 - display.screenOriginY,

		iconName = "home",
		iconAlign = "right",

		onRelease = onButtonRelease,
	}

	-- print( "button width, height : ", button.width, button.height )
	-- print( "button x, y : ", button.x, button.y )

end

local function testSpinner(  )

	local sheetOpt = { width = 16, height = 16, numFrames = 18 }

	local seqData = {
		name = "run",
		start = 1,
		count = 18,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	}

	local sheet = graphics.newImageSheet( "assets/spinner_segments.png", system.ResourceDirectory, sheetOpt )

	local spinner = display.newSprite (sheet, seqData)
	spinner.x = 100
	spinner.y = 50
	spinner:play( )

end

local function headerTest(  )

	local opt = {
		text = "APP",
	}

	header.init( opt )
	-- header.hideMenuButton(  )
	-- header.showNextButton( )
	-- header.showBackButton( )

end

local function menuTest(  )

	header.init {
		text = "BIJI",
	}

	local items = {
		{  
			text = "HOME",
			iconName = "home",
			sceneName = "home",
		},
		{  
			text = "SETTINGS",
			iconName = "settings",
			sceneName = "settings",
			color = flatColors.pumpkin,
		}
	}

	local myMenu = menu.init {
 		color = flatColors.wisteria,
 		items = items
	}

	header.menu = myMenu

end

function runTest(  )

	buttonTest( )
	-- headerTest( )
	menuTest( )
	
end
