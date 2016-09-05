
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


return C