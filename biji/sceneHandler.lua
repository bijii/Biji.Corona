
local composer = require( "composer" )
local logger = require( "biji.logger" )
local control = require( "biji.control" )

local S = { 
    
    loadScene = "demo",
    homeScene = "demo.home",

}

local function onKeyEvent( event )

    if ( event.keyName == "back" and event.phase == "up" ) then

        local prevSceneName = composer.getSceneName( "previous" )
        local currentSceneName = composer.getSceneName( "current" )
        local currentScene = composer.getScene( currentSceneName )

        log("prev:", prevSceneName)
        log("current:", currentSceneName)

        if ( currentSceneName == S.loadScene ) then
            native.requestExit( )
        else
            if ( composer.isOverlay ) then
                composer.hideOverlay( "toBottom" )
            else
                local returnScene = currentScene.returnScene

                if (returnScene) then
                    composer.gotoScene( lastScene, { effect = "slideRight" } )
                else
                    composer.gotoScene( S.homeScene, { effect = "flip" } )
                end
            end
            
            return true
        end

    end

    return false
end


local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then
        control.destroyAll( )
    end
end


function S.init(  )
    Runtime:addEventListener( "system", onSystemEvent )
    Runtime:addEventListener( "key", onKeyEvent )
end


return S