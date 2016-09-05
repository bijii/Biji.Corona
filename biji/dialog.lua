
local display = require( "display" )
local button = require( "biji.button" )
local logger = require( "biji.logger" )
local natives = require( "biji.native" )
local theme = require( "theme" )


local D = { 
	isVisible = false
}


local shadeBox
local group
local text
local box

local buttonHeight = 35
local buttonWidth = 90

local buttons = { }
local buttonGroup

local onComplete = nil
local result = nil


local function onShadeBoxTouch( event )
	if ( event.phase == "ended" ) then
		D.hide( )
	end

	return true
end


local function initBoxes( opt )
	
	local cX = display.screenOriginX + display.actualContentWidth / 2
	local cY = display.screenOriginY + display.actualContentHeight / 2

	if (not shadeBox) then
		shadeBox = display.newRect( cX, cY, display.actualContentWidth, display.actualContentHeight )

		shadeBox.fill = { 0, 0, 0, 0.7 }
		shadeBox.isVisible = false
		shadeBox:addEventListener( "touch", onShadeBoxTouch )
	end

	if (not group) then
		group = display.newGroup( )

		local width = display.actualContentWidth

		text = display.newText{
			text = "", 
			width = width, 
			font = theme.titleFont, 
			fontSize = 16, 
			align = "center",
		}

		text:setFillColor( unpack( opt.textColor ) )

		box = display.newRect( 0, 0, width, text.height )

		box.fill = opt.color
		box:addEventListener( "touch", function ( event ) return true end )

		group:insert( box )
		group:insert( text )
	end

	group.x = cX
	group.y = display.screenOriginY + display.actualContentHeight + display.actualContentHeight / 2

end


local function onButtonRelease( event )
	result = event.target:getLabel( ):lower( )
	D.hide( )
end


local function initButtons( buttonNames )

	if (not buttonGroup) then
		buttonGroup = display.newGroup( )
		group:insert( buttonGroup )
	end

	local x = 0
	local visibleButtons = 0

	for i=1,#buttonNames do
		local name = buttonNames[i]

		if (not buttons[name]) then

			buttons[name] = button.newButton { 
				text = name:upper( ),
				textSize = 16,
				color = theme.dialogButtonColors[name],
				width = buttonWidth,
				height = buttonHeight,
				onRelease = onButtonRelease
			}

			buttonGroup:insert( buttons[name] )
			
		end

		buttons[name].x = x 

		x = x + buttonWidth + 10
		visibleButtons = visibleButtons + 1
	end

	-- first button become 0,0, only calc the next for reposition
	buttonGroup.x = -((visibleButtons - 1) * (buttonWidth + 10) / 2)
	buttonGroup.y = box.height / 2 - 35 / 2 - 10

end


local function init( opt )
	opt = opt or { }
	opt.text = opt.text or ""
	opt.buttons = opt.buttons or { "ok" }
	opt.color = opt.color or theme.dialogColor
	opt.textColor = opt.textColor or theme.dialogTextColor

	onComplete = opt.onComplete
	result = nil

	initBoxes( opt )

	text.text = opt.text
	box.height = 20 + text.height + 10 + buttonHeight + 20
	text.y = -(box.height / 2 - text.height / 2) + 20

	initButtons( opt.buttons )
end


function D.show( opt )
	init( opt )

	natives.hideAll( )
	shadeBox:toFront( )
	group:toFront( )

	local dialogY = display.screenOriginY + display.actualContentHeight / 2

	shadeBox.isVisible = true
	transition.to( group, { y = dialogY, time = 200 } )

	D.isVisible = true
end


function D.hide( )
	if (not group) then
		return
	end

	local dialogY = display.screenOriginY + display.actualContentHeight + display.actualContentHeight / 2

	shadeBox.isVisible = false
	transition.to( group, { y = dialogY, time = 200 } )

	D.isVisible = false
	
	natives.showAll( )

	if (onComplete) then
		onComplete( { result = result } )
	end
end


return D
