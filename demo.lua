
-- corona
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene( )

-- biji
local logger = require( "biji.logger" )
local flatColors = require( "biji.flatColors" )
local notif = require( "biji.notification" )
local menu = require( "biji.menu" )
local header = require( "biji.header" )
local flatButton = require( "biji.flatButton" )
local control = require( "biji.control" )

-- ui

-- local
local function onLogin( event )
	notif.loading( "Logging in..." )
	
	timer.performWithDelay( 2000, function ( event )
		notif.info( "Logged in!" )

		timer.performWithDelay( 1800, function ( event )
			composer.gotoScene( "demo.home", { effect = "slideDown" } )	
		end)
	end)
end


function scene:create( event )

	local loginButton = flatButton.newButton {
		color = flatColors.nephritis,
		iconName = "enter",
		iconAlign = "left",

		textColor = flatColors.white,
		text = "LOGIN",
		textSize = 24,

		width = display.actualContentWidth,
		height = 40,

		onRelease = onLogin,
	}

	control.fillWidth( loginButton )
	control.putBottom( loginButton )

	self.view:insert( loginButton )
end

function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
	scene:removeEventListener( "create" )
	scene:removeEventListener( "show" )
	scene:removeEventListener( "hide" )
	scene:removeEventListener( "destroy" )

	Runtime:removeEventListener( "orientation", onOrientationChange )
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

local function onOrientationChange( event )

end

Runtime:addEventListener( "orientation", onOrientationChange )

return scene
