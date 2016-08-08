
local display = require( "display" )
local logger = require( "biji.logger" )

local Control = { }


local controls = { }

local nativeControls = { }
local nativeOverBoxes = { }
local nativeOverTexts = { }

local maxInputFields = { }

function Control.setMaxInput( textField, max )

	textField.max = max
	textField.maxInput = function ( event )
		local textField = event.target

		if (event.phase == "editing" and string.len(textField.text) > textField.max) then
			textField.text = event.oldText
		end
	end

	maxInputFields[#maxInputFields + 1] = textField

	textField:addEventListener( "userInput",  textField.maxInput )
end


function Control.registerNative( control )
	local newIndex = #nativeControls + 1

	control.index = newIndex
	nativeControls[newIndex] = control

	if ( not control.overBox ) then
		local index = #nativeOverBoxes + 1

		local box = display.newRect( control.x, control.y, control.width, control.height )
		local text = display.newText{ 
			text = control.text, 
			x = control.x, 
			y = control.y, 
			width = control.width - 20, 
			height = 0, 
			font = control.font, 
			fontSize = control.fontSize,
			align = control.align
		}

		text:setFillColor( 0 )

		if ( control.isSecure ) then
			text.text = ""			
		end

		box.isVisible = false
		text.isVisible = false

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
	if ( type(object) == "table" ) then
		for k,v in pairs( object ) do
			if ( v ) then
				display.remove( v )
			end

			if ( v.removeSelf ) then
				v:removeSelf( )
			end
		end
	else
		display.remove( object )
		if ( object.removeSelf ) then
			object:removeSelf( )			
		end
	end
end


function Control.destroyAll( )
	-- remove max input listener	
	for i=1,#maxInputFields do
		local textField = maxInputFields[i]
		
		textField:removeEventListener( "userInput", textField.maxInput )
		maxInputFields[i] = nil
	end

	for i=1,#nativeControls do
		display.remove( nativeControls[i] )
		if (nativeControls[i].removeSelf) then
			nativeControls[i]:removeSelf( )			
		end
		nativeControls[i] = nil
	end

	for i=1,#nativeOverBoxes do
		display.remove( nativeOverBoxes[i] )
		if (nativeOverBoxes[i].removeSelf) then
			nativeOverBoxes[i]:removeSelf( )
		end
		nativeOverBoxes[i] = nil
	end

	for i=1,#nativeOverTexts do
		display.remove( nativeOverTexts[i] )
		if (nativeOverTexts[i].removeSelf) then
			nativeOverTexts[i]:removeSelf( )
		end
		nativeOverTexts[i] = nil
	end

	for i=1,#controls do
		display.remove( controls[i] )
		if (controls[i].removeSelf) then
			controls[i]:removeSelf( )			
		end
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
	object.x = display.screenOriginX + display.actualContentWidth / 2
end


function Control.getUnderlinePos( object )
	local x1 = object.x - object.width / 2
	local x2 = object.x + object.width / 2
	local y2 = object.y + object.height / 2

	return { x1, y2, x2, y2 }
end

function Control.setUnderline ( text, color )
	local pos = Control.getUnderlinePos( text )
	local line = display.newLine( unpack( pos ) )
	line.fill = color
	line.isVisible = text.isVisible

	if ( text.underline ) then
		display.remove( text.underline )
		text.underline:removeSelf( )
	end

	text.underline = line
end

local hiddenNatives = { }

function Control.hideNatives( )
	for i=1,#nativeControls do
		local control = nativeControls[i]

		if ( not control.isVisible ) then
			hiddenNatives[ #hiddenNatives + 1 ] = control
		end

		Control.hideNative( control )
	end
end


function Control.showNatives( )
	
	for i=1,#nativeControls do
		local control = nativeControls[i]
		local hidden = false

		for j=1,#hiddenNatives do
			if ( hiddenNatives[j] == control ) then
				hidden = true
				break
			end
		end

		if ( not hidden ) then
			Control.showNative( control )
		end
	end

	for j=1,#hiddenNatives do
		hiddenNatives[j] = nil
	end

end

function Control.hideNative( control )
	if ( control.overBox ) then
		if ( not control.isSecure ) then
			control.overText.text = control.text
		end

		if ( control.isVisible ) then
			control.overText.isVisible = true
			control.overBox.isVisible = true
		end
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


return Control