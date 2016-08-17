
local display = require( "display" )
local widget = require( "widget" )
local logger = require( "biji.logger" )
local flatColors = require( "biji.flatColors" )
local luaUsers = require( "libs.luausers" )
local theme = require( "theme" )

local G = { }

local columnSpace = 10


function onTableViewRowRender( event )
		
	local row = event.row
	local params = row.params
	local opt = event.target.opt
	local y = row.contentHeight / 2

	local lastX = 0

	-- log(params)

	for i=1,#params do
		
		local col = opt.columns[i]
		local x = lastX + col.width / 2
		
		lastX = x + col.width / 2 + columnSpace

		local font = theme.contentFont
		local fontSize = opt.rowTextSize
		local color = opt.rowTextColor
		local align = col.align or "left"
		local text = params[i]

		if ( row.isCategory ) then
			font = theme.titleFont
			fontSize = opt.headerTextSize
			color = opt.headerTextColor
			align = "center"
		end

		if ( col.isNumber and not row.isCategory ) then
			text = tonumber( text )
			
			if (text) then 
				text = tostring( format_num( text, 0)) 
			else
				text = text 
			end
		end

		local text = display.newText {
			parent = row, 
			text = text,
			x = x,
			y = y,
			width = col.width,
			height = 0,
			font = font,
			fontSize = fontSize,
			align = align,
		}

		text:setFillColor( unpack( color ) )
	end

end


function onTableViewListener( event )

	if (not event.x) then
		return
	end

	local scrollview = event.target.parent.scrollview

	log("parent", event.target.parent)
	
	-- if ( not scrollview.firstX or firstX == 0) then
	-- 	scrollview.firstX = scrollview:getContentPosition()
	-- end

	-- local delta = event.x - event.xStart
	-- local move = scrollview.firstX + delta
	-- local max = scrollview.tableview.width - scrollview.width

	-- if (move > 0) then
	-- 	move = 0
	-- end

	-- if (move < -max) then
	-- 	move = -max
	-- end

	-- scrollView:scrollToPosition {
	-- 	x = move,
	-- 	time = 0,
	-- }

	-- if (event.phase == "ended") then
	-- 	scrollview.firstX = 0
	-- end
	
end


function onScrollViewListener( event )
	
	if (event.phase == "ended") then
		local scrollview = event.target
		
		scrollview.firstX = 0
	end

end


function G.newGridView( opt )
	
	opt.x = opt.x or 0
	opt.y = opt.y or 0
	opt.width = opt.width or 50
	opt.height = opt.height or 100
	opt.backgroundColor = opt.backgroundColor or theme.backgroundColor

	opt.headerHeight = opt.headerHeight or 24
	opt.headerColor = opt.headerColor or theme.gridHeaderColor
	opt.headerTextColor = opt.headerTextColor or theme. gridHeaderTextColor
	opt.headerTextSize = opt.headerTextSize or 16

	-- header items: title, width, isNumber, align
	opt.columns = opt.columns or { }

	opt.rowHeight = opt.rowHeight or 32
	opt.rowColor = opt.rowColor or theme.gridRowColor
	opt.rowTextColor = opt.rowTextColor or theme.gridRowTextColor
	opt.rowTextSize = opt.rowTextSize or theme.gridRowTextSize

	local scrollview = widget.newScrollView {
		width = opt.width,
		height = opt.height,
		backgroundColor = opt.backgroundColor,
		x = opt.x,
		y = opt.y,
		listener = onScrollViewListener,
	}

	local gridWidth = columnSpace
	local gridHeader = { }

	for i,column in ipairs(opt.columns) do
		gridWidth = gridWidth + columnSpace + column.width
		gridHeader[ #gridHeader + 1 ] = column.title
	end

	scrollview.gridWidth = gridWidth
	scrollview.firstX = 0

	local tableview = widget.newTableView {
		width = gridWidth,
		height = opt.height - 50,
		x = scrollview.width / 2,
		-- y = scrollview.height / 2,
		backgroundColor = opt.backgroundColor,
		onRowRender = onTableViewRowRender,
		-- listener = onTableViewListener,

		listener = function ( event )
				
			if (not event.x) then
				return
			end

			if ( scrollview.firstX == 0) then
				scrollview.firstX = scrollview:getContentPosition()
			end

			local delta = event.x - event.xStart
			local move = scrollview.firstX + delta
			local max = scrollview.tableview.width - scrollview.width

			if (move > 0) then
				move = 0
			end

			if (move < -max) then
				move = -max
			end

			scrollview:scrollToPosition {
				x = move,
				time = 0,
			}

			if (event.phase == "ended") then
				scrollview.firstX = 0
			end
		end
	}

	tableview.opt = opt
	tableview.scrollview = scrollview

	scrollview:insert( tableview )
	scrollview.tableview = tableview

	-- init column headers
	tableview:insertRow {
		isCategory = true,
		rowHeight = opt.headerHeight,
		rowColor = { default = opt.headerColor, over = opt.headerColor },
		lineColor = opt.headerColor,
		params = gridHeader
	}

	-- rows
	scrollview.insertRow = function ( row )
		scrollview.tableview:insertRow {
			isCategory = false,
			rowHeight = opt.rowHeight,
			rowColor = { default = opt.rowColor, over = opt.headerColor },
			lineColor = flatColors.concrete,
			params = row,
			scrollview = scrollview,
		}
	end

	scrollview.insertRows = function ( rows )
		for i=1,#rows do
			scrollview.insertRow( rows[i] )
		end
	end

	return scrollview

end


return G