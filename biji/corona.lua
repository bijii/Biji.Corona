
local controller = require( "biji.controller" )
local helper = require( "biji.helper" )
local natives = require( "biji.native" )
local button = require( "biji.button" )
local chart = require( "biji.chart" )
local gridview = require( "biji.gridview" )
local tabbar = require( "biji.tabbar" )
local textbox = require( "biji.textbox" )


local B = { 

	colors = require( "biji.colors" ),
	
	header = require( "biji.header" ),
	menu = require( "biji.menu" ),
	notif = require( "biji.notif" ),
	dialog = require( "biji.dialog" ),
	network = require( "biji.network" ),

	controller = controller,
	helper = helper,
	init = controller.init,

	newTextBox = textbox.newTextBox,
	newButton = button.newButton,
	newGridView = gridview.newGridView,
	newSummaryBox = chart.newSummaryBox,
	newTabbar = tabbar.newTabbar,

	registerNative = natives.register,
	setMaxInput = natives.setMaxInput,
	setUnderline = textbox.setUnderline,

}


return B
