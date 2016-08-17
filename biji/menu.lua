
local display = require( "display" )
local composer = require( "composer" )
local logger = require( "biji.logger" )
local flatButton = require( "biji.flatButton" )
local header = require( "biji.header" )
local control = require( "biji.control" )
local sceneHandler = require( "biji.sceneHandler" )
local theme = require( "theme" )

local Menu = {
	width = display.actualContentWidth * 0.7,
	height = display.actualContentHeight - header.height - display.topStatusBarContentHeight,
	
	color = theme.menuColor,
	
	textSize = 18,
	textColor = theme.menuTextColor,
	textAlign = "center",

	items = nil,

	isVisible = false,
}

if (system.orientation ~= "portrait") then
	Menu.width = display.actualContentHeight * 0.7
end

local box
local shadeBox
local group


local swipeThresh = 100
local minXStart = 75

function onScreenTouched( event )
	local phase = event.phase

	if (phase == "ended" or phase == "cancelled") then
		local distance = event.x - event.xStart

		if (distance > swipeThresh) then
			if (event.xStart < minXStart and header.isVisible and not Menu.isVisible) then
				Menu.toggle( )
			end
		elseif (distance < -swipeThresh) then
			if (Menu.isVisible) then
				Menu.toggle( )
			end
		end
	end

	return true
end


local function onShadeBoxTouch( event )
	if (event.phase == "ended") then
		Menu:toggle( )
	end

	return true
end

local function initShadeBox(  )
	if (not shadeBox) then
		local x = display.contentCenterX
		local y = header.bottom + Menu.height / 2

		shadeBox = display.newRect( x, y, display.actualContentWidth, Menu.height )
		shadeBox:addEventListener( "touch", onShadeBoxTouch )
		shadeBox:addEventListener( "touch", onScreenTouched )
	end	

	shadeBox.fill = { 0, 0, 0, 0.7 }
	shadeBox.alpha = 0
end


local function initMenuBox(  )
	if (not box) then
		box = display.newRect( 0, 0, Menu.width, Menu.height)
		box:addEventListener( "touch", onScreenTouched )

		group:insert( box )
	end

	box.fill = Menu.color
end


local function onMenuItemRelease( event )
	if ( event.target.opt.sceneName and event.target.pressed ) then
		local effect = "slideLeft"

		if ( event.target.opt.sceneName == sceneHandler.homeScene ) then
			effect = "slideRight"
		end

		composer.gotoScene( event.target.opt.sceneName, { time = 250, effect = effect } )
	end

	if ( event.target.opt.onItemRelease and event.target.pressed ) then
		event.target.opt.onItemRelease( )
	end

	Menu:toggle( )
end


local function newMenuItem( item, lastBottomY, lastTopY )

	local itemButton = flatButton.newButton {

		text = item.text,
		textSize = Menu.textSize,
		textColor = item.textColor or Menu.textColor,
		textAlign = item.textAlign or Menu.textAlign,

		color = item.color or Menu.color,
		iconName = item.iconName,
		iconAlign = "left",

		width = Menu.width,
		height = item.height or header.height,
		
		y = item.position == "bottom" and lastBottomY or lastTopY,

		sceneName = item.sceneName,
		onItemRelease = item.onRelease,

		onRelease = onMenuItemRelease,
	}

	return itemButton

end

local function initMenuItems(  )

	if (Menu.items) then
		-- based on group box
		local lastTopY = -Menu.height / 2 + header.height / 2
		local lastBottomY = Menu.height / 2 - header.height / 2
		
		for _,item in ipairs(Menu.items) do

			local itemButton = newMenuItem( item, lastBottomY, lastTopY )

			item.position = item.position or "top"

			if ( item.position == "top" ) then
				lastTopY = lastTopY + itemButton.height
			else
				lastBottomY = lastBottomY - itemButton.height				
			end

			group:insert( itemButton )
		end
	end

end


function Menu.init( opt )

	if (opt) then
		Menu.width = opt.width or Menu.width
		Menu.color = opt.color or Menu.color
		Menu.items = opt.items
		Menu.textSize = opt.textSize or Menu.textSize
		Menu.textColor = opt.textColor or Menu.textColor
		Menu.textAlign = opt.textAlign or Menu.textAlign
	end

	if (not group) then
		group = display.newGroup( )
	end

	initShadeBox( )
	initMenuBox( )
	initMenuItems( )

	group.x = -( display.screenOriginX + Menu.width )
	group.y = header.bottom + Menu.height / 2

	return Menu
end

local slideTime = 400

function Menu:toggle( )
	shadeBox:toFront( )
	group:toFront( )

	local boxX
	local shadeBoxAlpha

	if (Menu.isVisible) then
		boxX = -(display.screenOriginX + Menu.width)
		shadeBoxAlpha = 0
		control.showNatives( )
	else
		boxX = display.screenOriginX + Menu.width / 2
		shadeBoxAlpha = 1
		control.hideNatives( )
	end

	transition.to( group, { time = slideTime, x = boxX, transition = easing.outQuint } )

	Menu.isVisible = not Menu.isVisible

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

Runtime:addEventListener("touch", onScreenTouched)

return Menu
