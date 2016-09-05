
local display = require( "display" )
local logger = require( "biji.logger" )


local N = { }


local natives = { }
local hiddenNatives = { }

local maxInputFields = { }


function N.setMaxInput( textField, max )
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


function N.register( control )
	
	natives[#natives + 1] = control

	if ( not control.overlayBox ) then
		local x = control.x
		local y = control.y

		local box = display.newRect( x, y, control.width, control.height )
		
		local text = display.newText{ 
			text = control.text, 
			x = x, 
			y = y, 
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

		control.overlayBox = box
		control.overlayText = text
	end

end


function N.destroyAll( )
	
	for i=1,#maxInputFields do
		local textField = maxInputFields[i]
		
		textField:removeEventListener( "userInput", textField.maxInput )
		
		maxInputFields[i] = nil
	end

	for i=1,#natives do
		if (natives[i].overlayBox) then
			natives[i].overlayBox:removeSelf( )
			natives[i].overlayText:removeSelf( )

			natives[i].overlayBox = nil
			natives[i].overlayText = nil
		end

		natives[i]:removeSelf( )
		natives[i] = nil
	end

	natives = nil
	hiddenNatives = nil
	maxInputFields = nil

end


function N.hideAll( )
	for i=1,#natives do
		local control = natives[i]

		if ( not control.isVisible ) then
			hiddenNatives[ #hiddenNatives + 1 ] = control
		end

		N.hide( control )
	end
end


function N.showAll( )
	for i=1,#natives do
		local control = natives[i]
		local hidden = false

		for j=1,#hiddenNatives do
			if ( hiddenNatives[j] == control ) then
				hidden = true
				break
			end
		end

		if ( not hidden ) then
			N.show( control )
		end
	end

	for j=1,#hiddenNatives do
		hiddenNatives[j] = nil
	end
end


function N.hide( control )
	if ( control.overlayBox ) then
		if ( not control.isSecure ) then
			control.overlayText.text = control.text
		end

		if ( control.isVisible ) then
			control.overlayText.isVisible = true
			control.overlayBox.isVisible = true
		end
	end

	control.isVisible = false
end


function N.show( control )
	if ( control.overlayBox ) then
		control.overlayBox.isVisible = false
		control.overlayText.isVisible = false
	end

	control.isVisible = true
end


return N
