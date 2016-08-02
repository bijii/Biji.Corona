
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
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	scene:removeEventListener( "create" )
	scene:removeEventListener( "show" )
	scene:removeEventListener( "hide" )
	scene:removeEventListener( "destroy" )

	Runtime:removeEventListener( "orientation", onOrientationChange )
end

function scene:overlayBegan( event )
	
end

function scene:overlayEnded( event )
	
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )
scene:addEventListener( "overlayBegan" )
scene:addEventListener( "overlayEnded" )

Runtime:addEventListener( "orientation", onOrientationChange )

return scene
