
local display = require( "display" )
local widget = require( "widget" )

local control = require( "biji.control" )
local logger = require( "biji.logger" )
local flatColors = require( "biji.flatColors" )
local theme = require( "theme" )

local FlatButton = { }


local function onButtonEvent( event )

	if (event.phase == "began") then
		
		if (event.target.onButtonPress) then
			event.target.onButtonPress( event )
		end

		if (event.target.icon) then
			event.target.icon:setFillColor( 0.7 )
		end

	elseif (event.phase == "ended") then

		if (event.target.onButtonRelease) then
			event.target.onButtonRelease ( event )
		end

		if (event.target.icon) then
			event.target.icon:setFillColor( 1 )
		end

	end

end


function FlatButton.newButton( opt )
	
	local group = display.newGroup( )
	group.width = opt.width
	group.height = opt.height
	group.x = opt.x or 0
	group.y = opt.y or 0

	-- default
	local fillColor = opt.color or theme.buttonColor
	local borderColor = opt.borderColor or { 0, 0, 0, 0 }
	local textColor = opt.textColor or theme.buttonTextColor

	local textOffset = 0

	if (opt.textAlign == "left" and opt.iconAlign == "left") then
		textOffset = 24 + 10
	elseif (opt.textAlign == "right" and opt.iconAlign == "right") then
		textOffset = - 24 - 10
	end

	local button = widget.newButton { 
		shape = "rect",
		width = opt.width,
		height = opt.height,

		fillColor = { default = fillColor, over = flatColors.shade( fillColor ) },
		strokeColor = { default = borderColor, over = flatColors.shade( borderColor ) },
		strokeWidth = opt.borderWidth or 0,

		label = opt.text,
		labelColor = { default = textColor, over = flatColors.shade( textColor ) },
		labelAlign = opt.textAlign,
		labelXOffset = textOffset,
		
		font = opt.textFont or "fonts/Roboto-Light.ttf",
		fontSize = opt.textSize or 14,

		-- onPress = opt.onPress,
		-- onRelease = opt.onRelease,
		onEvent = onButtonEvent,

		x = 0,
		y = 0,
	}

	button.onButtonPress = opt.onPress
	button.onButtonRelease = opt.onRelease

	group:insert( button )
	control.register( button )

	if (opt.iconName) then

		if (not opt.iconOffset) then
			opt.iconOffset = 15
		end

		local fileName = "icons/" .. opt.iconName .. ".png"
		local icon = display.newImageRect( fileName, system.ResourceDirectory, 24, 24 )

		icon.y = 0

		if (opt.iconAlign == "left") then 
			icon.x = -(opt.width / 2 - 24)
		elseif (opt.iconAlign == "right") then
			icon.x = opt.width / 2 - 24
		else -- center
			icon.x = 0
		end

		button.icon = icon
		button.text = opt.text
		button.sceneName = opt.sceneName
		button.onClick = opt.onClick

		group:insert( icon )
		control.register( button )
	end

	control.register( group )

	return group

end

return FlatButton