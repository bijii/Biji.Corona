
local widget = require( "widget" )
local composer = require( "composer" )
local logger = require( "biji.logger" )
local dialog = require( "biji.dialog" )
local menu = require( "biji.menu" )
local header = require( "biji.header" )
local theme = require( "theme" )


local C = { 

    startScene = "demo",
    homeScene = "demo.home",

    startEffect = "fade",

    title = "Title"

}


local function onKeyEvent( event )
    if ( event.keyName == "back" and event.phase == "up" ) then

        local currentSceneName = composer.getSceneName( "current" )
        local currentScene = composer.getScene( currentSceneName )

        if (dialog.isVisible) then
            dialog.hide( )
            return true
        elseif ( currentSceneName == C.startScene ) then
            native.requestExit( )
        elseif ( currentScene ) then

            local returnSceneName = currentScene.returnSceneName

            if ( returnSceneName ) then
                composer.gotoScene( returnSceneName, { effect = "slideRight", time = 250 } )
            elseif ( currentSceneName ~= C.homeScene ) then
                composer.gotoScene( C.homeScene, { effect = "slideRight", time = 250 } )
            end

            return true
        end
    end

    return false
end


local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then
        -- hmmm...        
    end
end


function C.gotoNextScene( nextSceneName )
    local prevSceneName = composer.getSceneName( "current" )

    composer.gotoScene( nextSceneName, { effect = "slideLeft", time = 250 } )
    
    timer.performWithDelay( 1000, function ( event )
        local nextScene = composer.getScene( nextSceneName )

        nextScene.returnSceneName = prevSceneName
    end )
end


function C.init( opt )
    if (opt) then
        C.startScene = opt.startScene or C.startScene
        C.homeScene = opt.homeScene or C.homeScene
        C.startEffect = opt.startEffect or C.startEffect
        C.title = opt.title or C.title
    end

    display.setStatusBar( display.DefaultStatusBar )
    display.setDefault( "background", unpack( theme.backgroundColor ) )
    widget.setTheme( "widget_theme_android_holo_light" )

    Runtime:addEventListener( "system", onSystemEvent )
    Runtime:addEventListener( "key", onKeyEvent )

    local slideMenu

    if (opt.menu) then
        slideMenu = menu.init( opt.menu ) 
    end

    header.init {
        text = opt.title,
        menu = slideMenu
    }

    composer.gotoScene( opt.startScene, { effect = C.startEffect } )
end


return C
