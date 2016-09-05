
local colors = require( "biji.colors" )
local logger = require( "biji.logger" )
local theme = require( "theme" )


local F = { }


function F.newTabbar( opt )
	
	opt.color = opt.color or theme.buttonColor
	opt.textColor = opt.textColor or theme.textColor
	opt.overColor = opt.overColor or colors.shade( opt.color )

	local group = display.newGroup( )

	for i=1,#opt.buttons do
		local button = opt.buttons[i]
		button.button.tabbar = group
		group:insert( button )
	end

	local firstButton = opt.buttons[1]
	local buttonX = -(firstButton.width / 2)

	for i=1,#opt.buttons do
		local button = opt.buttons[i]
		
		button.x = button.width / 2 + buttonX
		
		if ( i < #opt.buttons ) then
			buttonX = buttonX + button.width
		end
	end
	
	local lastButton = opt.buttons[#opt.buttons]
	
	-- local line = display.newLine( -firstButton.width / 2, firstButton.height / 2, lastButton.x + lastButton.width / 2, firstButton.height / 2 )
	-- line.fill = colors.white
	-- group:insert( line )

	local focusBox = display.newRect( 0, firstButton.height / 2 - 2, firstButton.width, 4)
	focusBox.fill = colors.orange

	group.focusBox = focusBox
	group:insert( focusBox )

	group.color = opt.color
	group.overColor = opt.overColor

	group.setFocus = function ( buttonText )
		for i=1,group.numChildren do
			local button = group[i]

			if (button.button.text == buttonText) then
				transition.to( focusBox, { x = button.x, width = button.width, time = 100, transition = easing.inQuint } )
				break
			end
		end

	end

	return group

end


return F
