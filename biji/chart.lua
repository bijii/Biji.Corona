
local display = require( "display" )
local theme = require( "theme" )

local flatColors = require( "biji.flatColors" )

local C = { }

function C.newStatBox( opt )
	
	opt.width = opt.width or 100
	opt.height = opt.height or 50
	opt.font = opt.font or theme.titleFont
	opt.titleFont = opt.titleFont or theme.titleFont
	opt.textSize = opt.textSize or 36
	opt.titleSize = opt.titleSize or 16

	local group = display.newGroup( )

	local box = display.newRect( 0, 0, opt.width, opt.height )
	box.fill = opt.color

	local contentText = display.newText {
		text = opt.text,
		align = "right",
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
		align = "right",
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
	titleBox.fill = flatColors.shade( opt.color )



	group:insert( box )
	group:insert( titleBox )
	group:insert( contentText )
	group:insert( titleText )

	if ( opt.iconName ) then
		local fileName = "icons/" .. opt.iconName .. "@3x.png"
		local icon = display.newImageRect( fileName, system.ResourceDirectory, 48, 48 )

		icon.x = -(box.width / 2) + icon.width / 2 + box.height * 0.1
		icon.y = contentText.y

		group:insert( icon )
	end

	group.contentText = contentText
	group.titleText = titleText

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

	return group

end


return C