
local display = require( "display" )
local widget = require( "widget" )
local logger = require( "biji.logger" )
local colors = require( "biji.colors" )
local luaUsers = require( "libs.luausers" )
local theme = require( "theme" )


local G = { }


local columnSpace = 10


function onTableViewRowRender( event )
		
	local row = event.row
	local opt = event.target.opt
	local params = row.params
	local columns = opt.columns
	local y = row.contentHeight / 2

	local lastX = columnSpace

	for field,col in spairs(columns, function(t, a, b) return t[a].id < t[b].id end ) do
		-- log(field, col)
		-- print(field)
		-- log(row)

		local x = lastX + col.width / 2
		
		lastX = x + col.width / 2 + columnSpace

		local font = theme.contentFont
		local fontSize = opt.rowTextSize
		local color = opt.rowTextColor
		local align = col.align or "left"
		local content = params[field]

		if ( row.isCategory ) then
			font = theme.titleFont
			fontSize = opt.headerTextSize
			color = opt.headerTextColor
			align = "center"
			content = col.title
		end

		if ( col.isNumber and not row.isCategory ) then
			content = tonumber( content )
			
			if (content) then 
				content = tostring( format_num( content, 0)) 
			else
				content = content 
			end
		end

		if ( not content ) then
			content = "?"
		end

		local text = display.newText {
			parent = row, 
			text = content,
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

	for i,column in pairs(opt.columns) do
		gridWidth = gridWidth + columnSpace + column.width
	end

	scrollview.gridWidth = gridWidth
	scrollview.firstX = 0

	local tableview = widget.newTableView {
		width = gridWidth,
		height = opt.height,
		x = scrollview.width / 2,
		-- y = scrollview.height / 2,
		backgroundColor = opt.backgroundColor,
		onRowRender = onTableViewRowRender,
		onRowTouch = opt.onRowTouch,

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
		-- params = { no = "NO", name = "NAME", salary = "SALARY" }
	}

	scrollview.insertRow = function ( row )
		scrollview.tableview:insertRow {
			isCategory = false,
			rowHeight = opt.rowHeight,
			rowColor = { default = opt.rowColor, over = opt.headerColor },
			lineColor = colors.concrete,
			params = row,
			scrollview = scrollview,
		}
	end

	scrollview.insertRows = function ( rows )
		if ( type(rows) == "function" ) then
			for k,row in rows do
				scrollview.insertRow( row )
			end
		else
			for k,row in pairs(rows) do
				scrollview.insertRow( row )
			end
		end
	end

	scrollview.deleteAllRows = function ( )
		tableview:deleteAllRows( )

		-- init column headers
		tableview:insertRow {
			isCategory = true,
			rowHeight = opt.headerHeight,
			rowColor = { default = opt.headerColor, over = opt.headerColor },
			lineColor = opt.headerColor,
		}
	end

	return scrollview

end


return G
