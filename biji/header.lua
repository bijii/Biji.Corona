
local display = require( "display" )
local control = require( "biji.control" )
local flatColors = require( "biji.flatColors" )
local flatButton = require( "biji.flatButton" )
local logger = require( "biji.logger" )
local theme = require( "theme" )

local header = {
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
}

local group

local statusBar
local box
local titleText

local menuButton
local infoButton
local backButton
local nextButton

function header.update( )
	control:fillWidth( group )
	control:putTop( group )
end


local function onMenuButtonRelease(  )
	if (header.menu) then
		header.menu:toggle( )
		group:toFront( )
	end
end


local function onBackButtonRelease(  )
	if (header.onBack) then
		header.onBack( )
	end
end


local function onNextButtonRelease(  )
	if (header.onNext) then
		header.onNext( )
	end
end


local function initButtons( )
	local option = {
		width = header.height,
		height = header.height,
	
		x = header.height / 2 - header.width / 2,

		color = header.color,
	}

	option.iconName = "menu"
	option.onRelease = onMenuButtonRelease
	menuButton = flatButton.newButton( option )

	option.iconName = "left"
	option.onRelease = onBackButtonRelease
	backButton = flatButton.newButton( option )

	option.iconName = "right"
	option.x = header.width / 2 - header.height / 2
	option.onRelease = onNextButtonRelease
	nextButton = flatButton.newButton( option )

	group:insert( menuButton ) 
	group:insert( backButton )
	group:insert( nextButton )

	backButton.isVisible = false
	nextButton.isVisible = false
end


local function initStatusBar( )
	if (not statusBar) then
		local height = display.topStatusBarContentHeight
		
		local x = display.screenOriginX + header.width / 2
		local y = display.screenOriginY + height / 2

		statusBar = display.newRect( x, y, header.width, height )
	end

	statusBar.fill = flatColors.shade( header.color, 0.1 )
end


local function initHeaderBox( )
	if (not box) then
		box = display.newRect( 0, 0, header.width, header.height )
		group:insert( box )
	end

	if (header.text and not titleText) then
		titleText = display.newText {
			text = header.text,
			align = "center",
			width = header.width,
			font = "fonts/Fabrica",
			fontSize = header.textSize
		}

		group:insert( titleText )
	end

	box.fill = header.color
	titleText:setFillColor( unpack( header.textColor ) )
end


function header.init( option )
	-- init option
	if (option) then
		header.height = option.height or header.height
		header.color = option.color or header.color

		header.text = option.text
		header.textSize = option.textSize or header.textSize
		header.textColor = option.textColor or header.textColor

		header.onBack = option.onBack or nil
		header.onNext = option.onNext or nil
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

	control.fillWidth( group )
	control.putTop( group )

	header.x = group.x
	header.y = group.y

	header.top = display.screenOriginY
	header.bottom = display.screenOriginY + display.topStatusBarContentHeight + header.height

	header.isVisible = false
	
	-- hide group
	group.y = header.top - header.y
end


function header.showMenuButton( )
	menuButton.isVisible = true
end

function header.hideMenuButton( )
	menuButton.isVisible = false
end

function header.showNextButton( )
	nextButton.isVisible = true
end

function header.hideNextButton( )
	nextButton.isVisible = false
end

function header.showBackButton( )
	backButton.isVisible = true
end

function header.hideBackButton( )
	backButton.isVisible = false
end


function header.destroy(  )
	control.destroy( header.menu )
	control.destroy( box )
	control.destroy( group )
	
	header.menu = nil
	header = nil
	box = nil
	group = nil
end


function header:toFront( )
	if (group) then
		group:toFront( )
	end

	if (statusBar) then
		statusBar:toFront( )
	end
end

function header.show( )
	transition.to( group, { y = header.y, effect = "slideUp" } )
	header.isVisible = true
end

function header.hide( )
	local topy = header.top - header.height / 2

	transition.to( group, { y = topy, effect = "slideUp" } )
	header.isVisible = false
end

initStatusBar( )

return header