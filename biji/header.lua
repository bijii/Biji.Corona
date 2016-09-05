
local display = require( "display" )
local helper = require( "biji.helper" )
local colors = require( "biji.colors" )
local button = require( "biji.button" )
local logger = require( "biji.logger" )
local theme = require( "theme" )

local H = {
	height = 40,
	width = display.actualContentWidth,
	color = theme.headerColor,

	text = "",
	textSize = 20,
	textColor = theme.headerTextColor,

	menu = nil,

	x = 0, 
	y = 0, 
	top = display.screenOriginY + display.topStatusBarContentHeight, 
	bottom = display.screenOriginY + display.topStatusBarContentHeight + 40, -- + height
	
	isVisible = false,

	onBack = nil,
	onNext = nil,
	onRefresh = nil,
	onInfo = nil,
}

local group

local statusBar
local box
local titleText

local menuButton
local infoButton
local backButton
local nextButton
local refreshButton

function H.update( )
	control:fillWidth( group )
	control:putTop( group )
end


local function onMenuButtonRelease(  )
	if (H.menu) then
		H.menu.toggle( )
		group:toFront( )
	end
end


local function onBackButtonRelease(  )
	if (H.onBack) then
		H.onBack( )
	end
end


local function onNextButtonRelease(  )
	if (H.onNext) then
		H.onNext( )
	end
end


local function onInfoButtonRelease(  )
	if (H.onInfo) then
		H.onInfo( )
	end
end


local function onRefreshButtonRelease(  )
	if (H.onRefresh) then
		H.onRefresh( )
	end
end


local function initButtons( )
	local option = {
		width = H.height,
		height = H.height,
	
		x = H.height / 2 - H.width / 2,

		color = H.color,
	}

	option.iconName = "menu"
	option.onRelease = onMenuButtonRelease
	menuButton = button.newButton( option )

	option.iconName = "left"
	option.onRelease = onBackButtonRelease
	backButton = button.newButton( option )

	option.iconName = "right"
	option.x = H.width / 2 - H.height / 2
	option.onRelease = onNextButtonRelease
	nextButton = button.newButton( option )

	option.iconName = "info"
	option.onRelease = onInfoButtonRelease
	infoButton = button.newButton( option )

	option.iconName = "refresh"
	option.onRelease = onRefreshButtonRelease
	refreshButton = button.newButton( option )

	group:insert( menuButton )
	group:insert( backButton )
	group:insert( nextButton )
	group:insert( infoButton )
	group:insert( refreshButton )

	backButton.isVisible = false
	nextButton.isVisible = false
	infoButton.isVisible = false
	refreshButton.isVisible = false
end


local function initStatusBar( )
	if (not statusBar) then
		local height = display.topStatusBarContentHeight
		
		local x = display.screenOriginX + H.width / 2
		local y = display.screenOriginY + height / 2

		statusBar = display.newRect( x, y, H.width, height )
	end

	statusBar.fill = colors.shade( H.color, 0.1 )
end


local function initHeaderBox( )
	if (not box) then
		box = display.newRect( 0, 0, H.width, H.height )
		group:insert( box )
	end

	if (H.text and not titleText) then
		titleText = display.newText {
			text = H.text,
			align = "center",
			width = H.width,
			font = theme.headerFont,
			fontSize = H.textSize
		}

		group:insert( titleText )
	end

	box.fill = H.color
	titleText:setFillColor( unpack( H.textColor ) )
end


function H.init( option )
	-- init option
	if (option) then
		H.height = option.height or H.height
		H.color = option.color or H.color

		H.text = option.text
		H.textSize = option.textSize or H.textSize
		H.textColor = option.textColor or H.textColor

		H.onBack = option.onBack
		H.onNext = option.onNext

		H.menu = option.menu
	end

	-- init group
	if (not group) then
		group = display.newGroup( )
	end
	-- top status bar
	initStatusBar( )
	-- create box
	initHeaderBox( )
	-- create buttons
	initButtons( )

	helper.fillWidth( group )
	helper.putTop( group )

	H.x = group.x
	H.y = group.y

	H.top = display.screenOriginY
	H.bottom = display.screenOriginY + display.topStatusBarContentHeight + H.height

	H.isVisible = false

	-- hide group
	group.y = H.top - H.width
end


function H.showMenuButton( )
	if ( menuButton ) then
		menuButton.isVisible = true
	end
end


function H.hideMenuButton( )
	if ( menuButton ) then
		menuButton.isVisible = false
	end
end


function H.showNextButton( )
	if ( nextButton ) then
		nextButton.isVisible = true
	end
end


function H.hideNextButton( )
	if ( nextButton ) then
		nextButton.isVisible = false
	end
end


function H.showBackButton( )
	if ( backButton ) then
		backButton.isVisible = true
	end
end


function H.hideBackButton( )
	if ( backButton ) then
		backButton.isVisible = false
	end
end


function H.showRefreshButton( )
	if ( refreshButton ) then
	 	refreshButton.isVisible = true
	end 
end


function H.hideRefreshButton( )
	if ( refreshButton ) then
		refreshButton.isVisible = false
	end
end


function H.destroy(  )
	H.menu:destroySelf( )
	box:destroySelf( )
	group:destroySelf( )
	
	H.menu = nil
	header = nil
	box = nil
	group = nil
end


function H.toFront( )
	if (group) then
		group:toFront( )
	end

	if (statusBar) then
		statusBar:toFront( )
	end
end


function H.show( )
	transition.to( group, { y = H.y, effect = "slideUp" } )
	H.isVisible = true
end


function H.hide( )
	local topy = H.top - H.height / 2

	transition.to( group, { y = topy, effect = "slideUp" } )
	H.isVisible = false
end

initStatusBar( )

return H
