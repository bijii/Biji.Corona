
local widget = require( "widget" )
local theme = require( "theme" )

local natives = require( "biji.native" )
local header = require( "biji.header" )


local N = { }

local text
local box
local sheet
local spinner
local shadeBox

local boxHeight = 38
local boxColor = theme.notifInfoColor
local fontSize = 18

local spinnerOption = { 
	width = 16, 
	height = 16, 
	numFrames = 18,
	sheetContentWidth = 288,
	sheetContentHeight = 16,
}


local slideTime = 100
local slideDelay = 1500

local showing
local loading


local function onShadeBoxTouch( event )
	return true
end


function N.update( )
	if (not showing) then
		local yPosHidden = -math.abs(display.screenOriginY) * 2 - boxHeight

		if (box ~= nil)	then box.y = yPosHidden end
		if (text ~= nil) then text.y = yPosHidden end
		if (spinner ~= nil) then spinner.y = yPosHidden end

		return
	end

	local centerX, originY = display.contentCenterX, display.screenOriginY
	local contentWidth = display.actualContentWidth
	local yPos = originY + box.height / 2 + display.topStatusBarContentHeight 

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
			font = theme.titleFont,
			fontSize = fontSize,
			align = "center",
			height = boxHeight,
		}

	end

	if (spinner == nil) then

		sheet = graphics.newImageSheet( "icons/spinner.png", system.ResourceDirectory, spinnerOption )

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

	if (not shadeBox) then

		local height = display.actualContentHeight -- - header.bottom
		local x = display.contentCenterX
		local y = display.screenOriginY + height / 2 -- + header.bottom 

		shadeBox = display.newRect( x, y, display.actualContentWidth, height )
		shadeBox.fill = { 0, 0, 0, 0.7 }
		shadeBox.isVisible = false
		shadeBox:addEventListener( "touch", onShadeBoxTouch )

	end

	text.text = message

	N.update( )

	box.y = yPosHidden
	text.y = yPosHidden
	spinner.y = yPosHidden

end


local function show( message )
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

	local boxY = display.screenOriginY + boxHeight / 2 + display.topStatusBarContentHeight + offset
	local boxYHide = display.screenOriginY - boxHeight

	transition.to( box, { time = slideTime, y = boxY } )
	transition.to( text, { time = slideTime, y = boxY } )

	transition.to( text, { time = slideTime, delay = slideDelay, y = boxYHide, onComplete = function(e) showing = false end } )
	transition.to( box, { time = slideTime, delay = slideDelay, y = boxYHide, onComplete = function(e) showing = false end } )
end


function N.error( message )
	boxColor = theme.notifErrorColor
	show( message )
end


function N.info( message )
	boxColor = theme.notifInfoColor
	show( message )
end


function N.warning( message )
	boxColor = theme.notifWarningColor
	show( message )
end


function N.loading( message )

	natives.hideAll( )

	showing = true
	loading = true

	boxColor = theme.notifLoadingColor
	init( message )
	
	shadeBox.isVisible = true
	spinner.isVisible = true
	spinner:start( )

	shadeBox:toFront( )
	box:toFront( )
	spinner:toFront( )
	text:toFront( )

	local offset = 0

	if (header.isVisible) then
		offset = header.height
		header.toFront( )
	end

	local boxY = display.screenOriginY + boxHeight * 0.5 + display.topStatusBarContentHeight + offset
	local boxYHide = display.screenOriginY - boxHeight

	transition.to( box, { time = slideTime, y = boxY } )
	transition.to( spinner, { time = slideTime, y = boxY } )
	transition.to( text, { time = slideTime, y = boxY } )

end


function N.hide( )
	local boxYHide = display.screenOriginY - boxHeight

	transition.to( text, { time = slideTime, y = boxYHide } )
	transition.to( box, { time = slideTime, y = boxYHide } )
	transition.to( spinner, { time = slideTime , y = boxYHide } )

	spinner:stop( )
	spinner.isVisible = false

	showing = false
	shadeBox.isVisible = false

 	natives.showAll( )
end


function N.destroy( )
	text:removeSelf( )
	box:removeSelf( )
	sheet:removeSelf( )
	spinner:removeSelf( )
	shadeBox:removeSelf( )

	text = nil
	box = nil
	sheet = nil
	spinner = nil
	shadeBox = nil
end


return N