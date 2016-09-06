
local display = require( "display" )
local theme = require( "theme" )


local T = { }


function T.newTextBox( opt )
	
	opt.width = opt.width or 100
	opt.height = opt.height or 32
	opt.color = opt.color or theme.headerColor
	opt.text = opt.text or ""
	opt.textColor = opt.textColor or theme.contentColor
	opt.align = opt.align or "center"
	opt.font = opt.font or theme.titleFont
	opt.fontSize = opt.fontSize or 20
	opt.x = opt.x or 0
	opt.y = opt.y or 0

	local background = display.newRect( 0, 0, opt.width, opt.height )
	background.fill = opt.color

	local contentText = display.newText { 
		text = opt.text, 
		align = opt.align,
		x = 0,
		y = 0,
		width = opt.width, 
		height = 0, 
		font = opt.font, 
		fontSize = opt.fontSize,
	}
	
	contentText:setFillColor( unpack( opt.textColor ) )

	local group = display.newGroup( )
	group:insert( background )
	group:insert( contentText )

	group.x = opt.x
	group.y = opt.y

	return group

end


return T
