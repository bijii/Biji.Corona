
local display = require( "display" )
local composer = require( "composer" )
local logger = require( "biji.logger" )
local flatButton = require( "biji.flatButton" )
local flatColors = require( "biji.flatColors" )
local header = require( "biji.header" )
local control = require( "biji.control" )

local Menu = {
	width = 200,
	height = display.actualContentHeight,
	
	color = flatColors.clouds,
	
	textSize = 18,
	textColor = flatButton.white,

	items = nil,

	isVisible = false,
}

local box
local shadeBox
local group


local function onShadeBoxTouch( event )
	if (event.phase == "ended") then
		Menu:toggle( )
	end

	return true
end


local function onBoxTouch( event )
	return true
end


function Menu.init( opt )

	if (header.bottom) then
		Menu.height = display.actualContentHeight - header.bottom
	end

	if (opt) then
		Menu.width = opt.width or Menu.width
		Menu.color = opt.color or Menu.color
		Menu.items = opt.items
		Menu.textSize = opt.textSize or Menu.textSize
		Menu.textColor = opt.textColor or Menu.textColor
	end

	if (not group) then
		group = display.newGroup( )
	end

	if (not shadeBox) then
		local x = display.contentCenterX
		local y = display.screenOriginY + header.bottom + Menu.height / 2

		shadeBox = display.newRect( x, y, display.actualContentWidth, Menu.height )
		shadeBox.fill = { 0, 0, 0, 0.7 }
		shadeBox.alpha = 0
		shadeBox:addEventListener( "touch", onShadeBoxTouch )
	end

	if (not box) then
		box = display.newRect( 0, 0, Menu.width, Menu.height)
		box.fill = Menu.color
		box:addEventListener( "touch", onBoxTouch )

		group:insert( box )
	end

	if (Menu.items) then
		local lastY = -Menu.height / 2 + header.height / 2

		for _,item in ipairs(Menu.items) do

			item.textColor = item.textColor or Menu.textColor

			local itemButton = flatButton.newButton {
				text = item.text,
				textSize = Menu.textSize,
				textColor = item.textColor,

				color = item.color or Menu.color,
				iconName = item.iconName,
				iconAlign = "left",

				width = Menu.width,
				height = header.height,
				y = lastY,

				sceneName = item.sceneName,
				onClick = item.onClick,

				onRelease = function ( event )
					if ( event.target.sceneName ) then
						composer.gotoScene( event.target.sceneName, { time = 500, event = "flip" } )
					end

					if ( event.target.onClick ) then
						event.target.onClick( )
					end

					Menu:toggle( )
				end
			}

			lastY = lastY + header.height

			group:insert(itemButton)
		end
	end

	group.x = -(display.screenOriginX + Menu.width)
	group.y = display.screenOriginY + header.bottom + Menu.height / 2

	return Menu

end

local slideTime = 400

function Menu:toggle( )
	shadeBox:toFront( )
	group:toFront( )

	local boxX
	local shadeBoxAlpha

	if (self.isVisible) then
		boxX = -(display.screenOriginX + Menu.width)
		shadeBoxAlpha = 0
		control.showNatives( )
	else
		boxX = display.screenOriginX + Menu.width / 2
		shadeBoxAlpha = 1
		control.hideNatives( )
	end

	transition.to( group, { time = slideTime, x = boxX, transition = easing.outQuint } )

	self.isVisible = not self.isVisible

	transition.to( shadeBox, { time = slideTime / 2, alpha = shadeBoxAlpha } )
end

function Menu:destroy( )
	-- remove event listener
	for i=1,group.numChildren do
		control.destroy( group[i] )
	end

	control.destroy( shadeBox )
	control.destroy( box )
	control.destroy( group )

end

return Menu