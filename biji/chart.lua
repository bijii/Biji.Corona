
local display = require( "display" )
local colors = require( "biji.colors" )
local theme = require( "theme" )


local C = { }


function C.newSummaryBox( opt )
	
	opt.width = opt.width or 100
	opt.height = opt.height or 50
	opt.font = opt.font or theme.titleFont
	opt.titleFont = opt.titleFont or theme.titleFont
	opt.textSize = opt.textSize or 36
	opt.textAlign = opt.textAlign or "right"
	opt.titleSize = opt.titleSize or 16
	opt.titleAlign = opt.titleAlign or "right"
	opt.iconAlign = opt.iconAlign or "left"
	opt.iconSize = opt.iconSize or 24

	local group = display.newGroup( )

	local box = display.newRect( 0, 0, opt.width, opt.height )
	box.fill = opt.color

	local contentText = display.newText {
		text = opt.text,
		align = opt.textAlign,
		x = 0,
		y = 0, 
		width = opt.width * 0.9,
		height = 0,
		font = opt.font,
		fontSize = opt.textSize
	}

	contentText.y = -box.height / 4 + box.height * 0.1

	local titleText = display.newText {
		text = opt.title,
		align = opt.titleAlign,
		x = 0,
		y = 0, 
		width = opt.width * 0.9, 
		height = 0,
		font = opt.titleFont,
		fontSize = opt.titleSize
	}

	titleText.y = box.height / 2 - box.height * 0.05 - titleText.height / 2

	local titleHeight = titleText.height + box.height * 0.1
	local titleY = box.height / 2 - titleHeight / 2
	
	local titleBox = display.newRect( 0, titleY, opt.width, titleHeight )
	titleBox.fill = colors.shade( opt.color )

	group:insert( box )
	group:insert( titleBox )
	group:insert( contentText )
	group:insert( titleText )

	group.contentText = contentText
	group.titleText = titleText
	group.box = box
	group.titleBox = titleBox

	group.setText = function ( text )
		if (group.contentText.text == text) then
			return
		end

		transition.blink( group.contentText, { time = 500, onRepeat = function ( event )
			group.contentText.text = text
			transition.cancel( group.contentText )
			group.contentText.alpha = 1
		end })
	end

	group.setTitle = function ( text )
		group.titleText.text = text
	end

	group.getText = function ( )
		return group.contentText.text
	end

	group.setColor = function ( color )
		group.box.fill = color
		group.titleBox.fill = color
	end

	group.setIcon = function ( iconName )
		if ( group.icon ) then
			group.icon:removeSelf( )
			group:remove( group.icon )
		end

		local fileName = "icons/" .. opt.iconName

		if (opt.iconSize > 48) then
			fileName = fileName .. "@3x"
		elseif (opt.iconSize > 24) then
			fileName = fileName .. "@2x" 	
		end

		fileName = fileName .. ".png"

		local icon = display.newImageRect( fileName, system.ResourceDirectory, opt.iconSize, opt.iconSize )

		if ( opt.iconAlign == "left" ) then
			icon.x = -(box.width / 2) + icon.width / 2 + box.height * 0.1
		else
			icon.x = (box.width / 2) - icon.width / 2 - box.height * 0.1
		end

		icon.y = contentText.y

		group.icon = icon

		group:insert( icon )		
	end

	if ( opt.iconName ) then
		group.setIcon( opt.iconName )
	end

	return group

end


return C
