
local display = require( "display" )
local logger = require( "biji.logger" )

local Control = { }

local controls = { }

local nativeControls = { }
local nativeOverBoxes = { }
local nativeOverTexts = { }

local maxInputFields = { }


function Control.setMaxInput( textField, max )
	textField.maxInput = max

	local newFieldIndex = #maxInputFields + 1

	local opt = {
		textField = textField,
		maxInput = function ( event )
			local textField = event.target

			if (event.phase == "editing" and string.len(textField.text) > textField.maxInput) then
				textField.text = event.oldText
			end
		end
	}

	maxInputFields[newFieldIndex] = opt

	textField:addEventListener( "userInput",  opt.maxInput )
end


function Control.registerNative( control )
	local newIndex = #nativeControls + 1

	control.index = newIndex
	nativeControls[newIndex] = control

	if ( not control.overBox ) then
		local index = #nativeOverBoxes + 1

		local box = display.newRect( control.x, control.y, control.width, control.height )
		local text = display.newText( control.text, control.x, control.y, control.width - 20, 0, control.font, control.fontSize )

		text:setFillColor( 0 )

		nativeOverBoxes[index] = box
		nativeOverTexts[index] = text

		control.overBox = box
		control.overText = text
	end

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
	for i=1,#maxInputFields do
		local opt = maxInputFields[i]
		
		opt.textField:removeEventListener( "userInput", opt.maxInput )
		maxInputFields[i] = nil
	end

	for i=1,#nativeControls do
		display.remove( nativeControls[i] )
		nativeControls[i]:removeSelf( )
		nativeControls[i] = nil
	end

	for i=1,#nativeOverBoxes do
		display.remove( nativeOverBoxes[i] )
		nativeOverBoxes[i]:removeSelf( )
		nativeOverBoxes[i] = nil
	end

	for i=1,#nativeOverTexts do
		display.remove( nativeOverTexts[i] )
		nativeOverTexts[i]:removeSelf( )
		nativeOverTexts[i] = nil
	end

	for i=1,#controls do
		display.remove( controls[i] )
		controls[i]:removeSelf( )
		controls[i] = nil
	end

	maxInputFields = nil
	nativeControls = nil
	nativeOverBoxes = nil
	nativeOverTexts = nil
	controls = nil
end


function Control.putBottom( object )
	local halfHeight = object.height / 2
	object.y = display.contentHeight - halfHeight - display.screenOriginY
end


function Control.putTop( object )
	local halfHeight = object.height / 2
	object.y = display.screenOriginY + display.topStatusBarContentHeight + halfHeight
end


function Control.fillWidth( object )
	object.width = display.actualContentWidth
	object.x = display.contentCenterX
end


function Control.hideNatives( )
	for i=1,#nativeControls do
		local control = nativeControls[i]
		Control.hideNative( control )
	end
end


function Control.showNatives( )
	for i=1,#nativeControls do
		local control = nativeControls[i]
		Control.showNative( control )
	end
end


function Control.hideNative( control )
	if ( control.overBox ) then
		control.overText.text = control.text
		control.overText.isVisible = true
		control.overBox.isVisible = true
	end

	control.isVisible = false
end


function Control.showNative( control )
	if ( control.overBox ) then
		control.overBox.isVisible = false
		control.overText.isVisible = false
	end

	control.isVisible = true
end


local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then
        Control.destroyAll( )
    end
end

Runtime:addEventListener( "system", onSystemEvent )

return Control