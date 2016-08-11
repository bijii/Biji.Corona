
local widget = require( "widget" )
local composer = require( "composer" )
local logger = require( "biji.logger" )
local control = require( "biji.control" )
local dialog = require( "biji.dialog" )
local theme = require( "theme" )

local S = { 
    
    startScene = "demo",
    homeScene = "demo.home",

    startEffect = "fade",

}


local function onKeyEvent( event )

    if ( event.keyName == "back" and event.phase == "up" ) then

        local currentSceneName = composer.getSceneName( "current" )
        local currentScene = composer.getScene( currentSceneName )

        if (dialog.isVisible) then
            dialog.hide( )
            return true
        elseif ( currentSceneName == S.startScene ) then
            native.requestExit( )
        elseif ( currentScene ) then

            local returnSceneName = currentScene.returnSceneName

            if ( returnSceneName ) then
                composer.gotoScene( returnSceneName, { effect = "slideRight", time = 250 } )
            elseif ( currentSceneName ~= S.homeScene ) then
                composer.gotoScene( S.homeScene, { effect = "slideRight", time = 250 } )
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


function S.gotoNextScene( nextSceneName )
    local prevSceneName = composer.getSceneName( "current" )

    composer.gotoScene( nextSceneName, { effect = "slideLeft", time = 250 } )
    
    timer.performWithDelay( 1000, function ( event )
        local nextScene = composer.getScene( nextSceneName )

        nextScene.returnScene = prevSceneName
    end )
end


function S.init( opt )

    if (opt) then
        S.startScene = opt.startScene or S.startScene
        S.homeScene = opt.homeScene or S.homeScene
        S.startEffect = opt.startEffect or S.startEffect
    end

    display.setStatusBar( display.DefaultStatusBar )
    widget.setTheme( "widget_theme_android_holo_light" )
    display.setDefault( "background", unpack( theme.backgroundColor ) )

    Runtime:addEventListener( "system", onSystemEvent )
    Runtime:addEventListener( "key", onKeyEvent )

    composer.gotoScene( opt.startScene, { effect = S.startEffect } )

end


return S