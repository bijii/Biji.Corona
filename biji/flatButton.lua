
local display = require( "display" )
local widget = require( "widget" )

local logger = require( "biji.logger" )
local flatColors = require( "biji.flatColors" )

local flatButton = { }


local function onButtonEvent( event )

	if (event.phase == "began" and event.target.icon) then
		
		if (event.target.onButtonPress) then
			event.target.onButtonPress( event )
		end

		if (event.target.icon) then
			event.target.icon:setFillColor( 0.7 )
		end

	elseif (event.phase == "ended" and event.target.icon) then

		if (event.target.onButtonRelease) then
			event.target.onButtonRelease ( event )
		end

		if (event.target.icon) then
			event.target.icon:setFillColor( 1 )
		end

	end

end


function flatButton.newButton( opt )
	
	local group = display.newGroup( )
	group.width = opt.width
	group.height = opt.height
	group.x = opt.x or 0
	group.y = opt.y or 0

	-- default
	local fillColor = opt.color
	local borderColor = opt.borderColor
	local labelColor = opt.labelColor

	-- update if color name used
	if (opt.colorName) then fillColor = flatColors[opt.colorName] end
	if (opt.borderColorName) then borderColor = flatColors[opt.borderColorName] end
	if (opt.textColorName) then labelColor = flatColors[opt.textColorName] end

	-- update if nil
	if (not borderColor) then borderColor = { 0, 0, 0, 0 } end
	if (not labelColor) then labelColor = flatColors.clouds end

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
		labelColor = { default = labelColor, over = flatColors.shade( labelColor ) },
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

	if (opt.iconName) then

		if (not opt.iconOffset) then
			opt.iconOffset = 15
		end

		local fileName = "/assets/" .. opt.iconName .. ".png"
		local baseDir = system.ResourceDirectory
		
		local icon = display.newImageRect( fileName, baseDir, 24, 24 )
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

		group:insert( icon )
	end

	return group
end

return flatButton