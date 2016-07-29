
local display = require( "display" )
local control = require( "biji.control" )
local flatColors = require( "biji.flatColors" )
local flatButton = require( "biji.flatButton" )
local logger = require( "biji.logger" )


local headerColor = flatColors.shade( flatColors.midnightblue, 0.3 )

local header = {
	height = 40,
	width = display.actualContentWidth,
	color = headerColor,

	text = nil,
	textSize = 20,
	textColor = flatColors.clouds,

	menu = nil,

	x, y, top, bottom,
	isVisible = false,

	onBack = nil,
	onNext = nil,
}

local group

local notifBar
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

	local x, y = display.screenOriginX + header.width / 2, display.screenOriginY + header.height / 2

	-- init group
	if (not group) then
		group = display.newGroup( )
	end

	-- notifBar
	if (not notifBar) then
		local height = display.statusBarHeight
		local y = display.screenOriginY + height / 2
		local color = flatColors.shade( header.color, 0.1 )

		notifBar = display.newRect( x, y, header.width, height )
		notifBar.fill = color
	end

	-- create box
	if (not box) then
		box = display.newRect( 0, 0, header.width, header.height )
		box.fill = header.color

		group:insert( box )
	end

	-- init title
	if (header.text) then
		
		titleText = display.newText {
			text = header.text,
			align = "center",
			width = header.width,
			font = "fonts/Fabrica",
			fontSize = header.textSize
		}

		titleText:setFillColor( unpack( header.textColor ) )

		group:insert( titleText )

	end

	initButtons( )

	control.fillWidth( group )
	control.putTop( group )

	header.x, header.y = group.x, group.y
	header.top, header.bottom = display.statusBarHeight, display.statusBarHeight + header.height

	header.isVisible = true

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

	if (notifBar) then
		notifBar:toFront( )
	end

end


return header