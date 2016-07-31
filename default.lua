
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
function onOrientationChange( event )
end

function scene:create( event )
	local sceneGroup = self.view
	
	-- sceneGroup:insert( )
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

Runtime:addEventListener( "orientation", onOrientationChange )

return scene
