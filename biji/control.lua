
local display = require( "display" )
local logger = require( "biji.logger" )

local Control = { }

local controls = { }
local textFields = { }


function Control.setMaxInput( textField, max )

	textField.maxInput = max

	local newFieldIndex = #textFields + 1

	local opt = {
		textField = textField,
		maxInput = function ( event )
			local textField = event.target

			if (event.phase == "editing" and string.len(textField.text) > textField.maxInput) then
				textField.text = event.oldText
			end
		end
	}

	textFields[newFieldIndex] = opt

	textField:addEventListener( "userInput",  opt.maxInput )

end


function Control.register( control )

	local newIndex = #controls + 1

	control.index = newIndex
	controls[newIndex] = control

end


function Control.destroy( object )

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


function Control.destroyAll( )

	-- remove max input listener	
	for i=1,#textFields do
		local opt = textFields[i]
		
		opt.textField:removeEventListener( "userInput", opt.maxInput )
		log("tf:", i)
		textFields[i] = nil
	end

	for i=1,#controls do
		display.remove( controls[i] )
		controls[i]:removeSelf( )
		controls[i] = nil
		log("ctrl:", i)
	end

	textFields = nil
	controls = nil

end


function Control.putBottom( object )
	
	local halfHeight = object.height / 2
	
	object.y = display.contentHeight - halfHeight - display.screenOriginY

end


function Control.putTop( object )

	local halfHeight = object.height / 2
	
	object.y = display.screenOriginY + display.statusBarHeight + halfHeight
	
end


function Control.fillWidth( object )
	
	object.width = display.actualContentWidth
	object.x = display.contentCenterX

end


local function onSystemEvent( event )

    local eventType = event.type

    if ( event.type == "applicationExit" ) then
        Control.destroyAll( )
    end

end


Runtime:addEventListener( "system", onSystemEvent )


return Control