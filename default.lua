
-- corona
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene( )

-- biji
local logger = require( "biji.logger" )
local notif = require( "biji.notification" )

-- ui

-- local

function scene:create( event )
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
