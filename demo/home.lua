
-- corona
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene( )

-- biji
local flatColors = require( "biji.flatColors" )
local logger = require( "biji.logger" )
local notif = require( "biji.notification" )
local menu = require( "biji.menu" )
local header = require( "biji.header" )
local control = require( "biji.control" )

-- ui

-- local
local function logout( )
	header.hide( )
	composer.gotoScene( "demo", { effect = "fade", time = 200 } )
end


function scene:create( event )
	header.init {
		color = flatColors.emerald,

		text = "Demo",
		textColor = flatColors.white,
	}

	local myMenu = menu.init {
		color = flatColors.nephritis,
		textColor = flatColors.white,

		items = {
			{
				text = "Home",
				iconName = "home",
				sceneName = "demo.home"
			},
			{
				text = "Logout",
				iconName = "exit",
				onClick = logout
			}
		}
	}

	header.menu = myMenu
end

function scene:show( event )
	header.show( )
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
