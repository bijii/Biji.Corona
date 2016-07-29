
local widget = require( "widget" )
local flatColors = require( "biji.flatColors" )
local control = require( "biji.control" )
local header = require( "biji.header" )

local notification = { }
local text
local box
local sheet
local spinner

local boxHeight = 36
local boxColor = flatColors.nephritis
local fontSize = 18

local spinnerOption = { 
	width = 16, 
	height = 16, 
	numFrames = 18,
	sheetContentWidth = 288,
	sheetContentHeight = 16,
}

local slideTime = 100
local slideDelay = 2000

local showing
local loading

function notification.update( )
	
	if (not showing) then

		local yPosHidden = -math.abs(display.screenOriginY) * 2 - boxHeight

		if (box ~= nil)	then box.y = yPosHidden end
		if (text ~= nil) then text.y = yPosHidden end
		if (spinner ~= nil) then spinner.y = yPosHidden end

		return

	end

	local centerX, originY = display.contentCenterX, display.screenOriginY
	local contentWidth = display.actualContentWidth
	local yPos = originY + box.height / 2 + display.statusBarHeight 

	if (text ~= nil and box ~= nil) then

		text.x, box.x = centerX, centerX
		text.y, box.y = yPos, yPos
		text.width, box.width = contentWidth, contentWidth
		text.height, box.height = boxHeight, boxHeight

	end

	if (spinner ~= nil and loading) then
		spinner.x = display.screenOriginX + boxHeight * 0.5
		spinner.y = yPos
	end
end


local function init( message )
	local yPosHidden = -math.abs(display.screenOriginY) * 2 - boxHeight

	if (box == nil) then
		box = display.newRect( 0, 0, 0, boxHeight )
	end

	box:setFillColor( unpack( boxColor ) )

	if (text == nil) then
		
		text = display.newText {
			text = message,
			font = "fonts/Roboto-Light",
			fontSize = fontSize,
			align = "center",
			height = boxHeight,
		}

	end

	if (spinner == nil) then

		sheet = graphics.newImageSheet( "assets/spinner.png", system.ResourceDirectory, spinnerOption )

		spinner = widget.newSpinner {
			width = spinnerOption.width,
			height = spinnerOption.height,
			
			sheet = sheet,
			startFrame = 1,
			count = spinnerOption.numFrames,
			time = 800,
			
			isVisible = false
		}

	end

	text.text = message

	notification.update( )

	box.y = yPosHidden
	text.y = yPosHidden
	spinner.y = yPosHidden

end

function notification.showError( message )
	
	boxColor = flatColors.pomegranate
	notification.show( message )
	boxColor = flatColors.nephritis

end

function notification.showInfo( message )

	boxColor = flatColors.belizehole
	notification.show( message )
	boxColor = flatColors.nephritis

end

function notification.show( message )

	showing = true
	loading = false

	init( message )

	box:toFront( )
	text:toFront( )

	local offset = 0

	if (header.isVisible) then
		offset = header.height

		header.toFront( )
	end

	local boxY = display.screenOriginY + boxHeight / 2 + display.statusBarHeight + offset
	local boxYHide = display.screenOriginY - boxHeight

	transition.to( box, { time = slideTime, y = boxY } )
	transition.to( text, { time = slideTime, y = boxY } )

	transition.to( text, { time = slideTime, delay = slideDelay, y = boxYHide, onComplete = function(e) showing = false end } )
	transition.to( box, { time = slideTime, delay = slideDelay, y = boxYHide, onComplete = function(e) showing = false end } )

end

function notification.loading( message )

	showing = true
	loading = true

	init( message )
	
	spinner.isVisible = true
	spinner:start( )

	box:toFront( )
	spinner:toFront( )
	text:toFront( )

	local offset = 0

	if (header.isVisible) then
		offset = header.height

		header.toFront( )
	end

	local boxY = display.screenOriginY + boxHeight * 0.5 + display.statusBarHeight + offset
	local boxYHide = display.screenOriginY - boxHeight

	transition.to( box, { time = slideTime, y = boxY } )
	transition.to( spinner, { time = slideTime, y = boxY } )
	transition.to( text, { time = slideTime, y = boxY } )

end


function notification.hide( )

	local boxYHide = display.screenOriginY - boxHeight

	transition.to( text, { time = slideTime, y = boxYHide } )
	transition.to( box, { time = slideTime, y = boxYHide } )
	transition.to( spinner, { time = slideTime , y = boxYHide } )

	spinner:stop( )
	spinner.isVisible = false

	showing = false

end


function notification.destroy( )
	
	control.destroy( { text, box, sheet, spinner } )

	text = nil
	box = nil
	sheet = nil
	spinner = nil

end


return notification