
local display = require( "display" )
local composer = require( "composer" )
local logger = require( "biji.logger" )
local button = require( "biji.button" )
local colors = require( "biji.colors" )
local header = require( "biji.header" )
local natives = require( "biji.native" )
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

local box
local shadeBox
local group
local menuItems = { }

local swipeThresh = 100
local minXStart = 75
local slideTime = 400


if (system.orientation ~= "portrait") then
	Menu.width = display.actualContentHeight * 0.7
end


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


local function toggleSubMenu( itemName )
	local menuItem = menuItems[itemName]

	if ( not menuItem.isSubVisible ) then
		local topY = menuItem.y
		
		for _,subItem in ipairs(menuItem.subMenuItems) do
			subItem.y = topY + subItem.height
			topY = topY + subItem.height
			subItem:toFront( )
		end

		menuItem.setColor( colors.shade(menuItem.button.opt.color) )
	else
		local topY = menuItem.y
		
		for _,subItem in ipairs(menuItem.subMenuItems) do
			subItem.y = topY
			subItem:toBack( )
		end

		menuItem.setColor( menuItem.button.opt.color )
	end

	menuItem.isSubVisible = not menuItem.isSubVisible
end


local function onMenuItemRelease( event )
	if ( event.target.opt.sceneName and event.target.pressed ) then
		local effect = "slideLeft"

		composer.gotoScene( event.target.opt.sceneName, { time = 250, effect = effect } )
	end

	if ( event.target.parent.onRelease and event.target.pressed ) then
		event.target.parent.onRelease( )
	end

	if ( event.target.parent.subItems ) then
		event.target.parent.expandIcon.isVisible = not event.target.parent.expandIcon.isVisible
		event.target.parent.collapseIcon.isVisible = not event.target.parent.collapseIcon.isVisible

		toggleSubMenu( event.target.opt.text )
	else
		Menu.toggle( )
	end

end


local function newMenuItem( item, lastBottomY, lastTopY )

	local itemButton = button.newButton {
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
		onRelease = onMenuItemRelease,
	}

	menuItems[item.text] = itemButton

	if ( item.subItems ) then
		itemButton.subItems = item.subItems
		itemButton.expandIcon = display.newImageRect( "icons/expand_arrow.png", system.ResourceDirectory, 18, 18 )
		itemButton.expandIcon.x = Menu.width / 2 - 18

		itemButton.collapseIcon = display.newImageRect( "icons/collapse_arrow.png", system.ResourceDirectory, 18, 18 )
		itemButton.collapseIcon.x = Menu.width / 2 - 18
		itemButton.collapseIcon.isVisible = false

		itemButton:insert( itemButton.expandIcon )
		itemButton:insert( itemButton.collapseIcon )

		itemButton.subMenuItems = { }
		
		for _,sub in ipairs(item.subItems) do

			local subColor = item.color or Menu.color

			subColor = colors.shade( subColor )

			local subItemButton = button.newButton {
				text = sub.text,
				textSize = Menu.textSize,
				textColor = item.textColor or Menu.textColor,
				textAlign = item.textAlign or Menu.textAlign,

				color = subColor,
				iconName = sub.iconName,
				iconAlign = "left",

				width = Menu.width,
				height = item.height or header.height,
				
				y = lastTopY,

				sceneName = sub.sceneName,
				onRelease = onMenuItemRelease,
			}

			itemButton.subMenuItems[#itemButton.subMenuItems + 1] = subItemButton

			group:insert( subItemButton )
		end
	end

	itemButton.onRelease = item.onRelease

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


function Menu.toggle( )
	shadeBox:toFront( )
	group:toFront( )

	local boxX
	local shadeBoxAlpha

	if (Menu.isVisible) then
		boxX = -(display.screenOriginX + Menu.width)
		shadeBoxAlpha = 0
		natives.showAll( )
	else
		boxX = display.screenOriginX + Menu.width / 2
		shadeBoxAlpha = 1
		natives.hideAll( )
	end

	transition.to( group, { time = slideTime, x = boxX, transition = easing.outQuint } )

	Menu.isVisible = not Menu.isVisible

	transition.to( shadeBox, { time = slideTime / 2, alpha = shadeBoxAlpha } )
end


function Menu.destroy( )
	for i=1,group.numChildren do
		group[i]:removeSelf( )
		group[i] = nil
	end

	shadeBox:removeSelf( )
	box:removeSelf( )
	group:removeSelf( )

	shadeBox = nil 
	box = nil 
	group = nil 
end

Runtime:addEventListener("touch", onScreenTouched)

return Menu
