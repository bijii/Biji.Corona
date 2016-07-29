
local display = require( "display" )

local control = { }


function control.setMaxInput( textField, max )
	textField:addEventListener( "userInput", function ( event )
		if (event.phase == "editing" and string.len(event.text) > 4) then
			textField.text = event.oldText
		end
	end )
end

-- function controls.unsetMax( textField )
-- 	textField:removeEventListener( "userInput", listener )

-- end

function control.destroy( object )

	if (type(object) == "table") then
		for k,v in pairs(object) do
			display.remove( v )
			v:removeSelf( )
		end
	else
		display.remove( object )
		object:removeSelf( )
	end

end

function control.putBottom( object )
	
	local halfHeight = object.height / 2
	
	object.y = display.contentHeight - halfHeight - display.screenOriginY

end

function control.putTop( object )

	local halfHeight = object.height / 2
	
	object.y = display.screenOriginY + display.statusBarHeight + halfHeight
	
end

function control.fillWidth( object )
	
	object.width = display.actualContentWidth
	object.x = display.contentCenterX

end

return control