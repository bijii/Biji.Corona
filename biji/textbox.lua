
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


local function getUnderlinePos( object )
	local x1 = object.x - object.width / 2
	local x2 = object.x + object.width / 2
	local y2 = object.y + object.height / 2

	return { x1, y2, x2, y2 }
end


function T.setUnderline( text, color )
	local pos = getUnderlinePos( text )
	local line = display.newLine( unpack( pos ) )

	line.fill = color
	line.isVisible = text.isVisible

	if ( text.underline ) then
		display.remove( text.underline )
		text.underline:removeSelf( )
	end

	text.underline = line
end


return T
