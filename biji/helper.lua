
local display = require( "display" )


local C = { }

function C.putBottom( object )
    local halfHeight = object.height / 2
    object.y = display.contentHeight - halfHeight - display.screenOriginY
end


function C.putTop( object )
    local halfHeight = object.height / 2
    object.y = display.screenOriginY + display.topStatusBarContentHeight + halfHeight
end


function C.fillWidth( object )
    object.width = display.actualContentWidth
    object.x = display.screenOriginX + display.actualContentWidth / 2
end

local function getUnderlinePos( object )
	local x1 = object.x - object.width / 2
	local x2 = object.x + object.width / 2
	local y2 = object.y + object.height / 2

	return { x1, y2, x2, y2 }
end


function C.setUnderline( text, color )
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


return C