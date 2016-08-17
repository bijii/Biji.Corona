
local display = require( "display" )
local flatColors = require( "biji.flatColors" )

local Theme = {
	
	backgroundColor = flatColors.white,

	headerColor = flatColors.shade( flatColors.nephritis, 0.3 ),
	headerTextColor = flatColors.white,

	menuColor = flatColors.nephritis,
	menuTextColor = flatColors.white,
	menuShadowColor = flatColors.midnightblue,

	notifInfoColor = flatColors.nephritis,
	notifWarningColor = flatColors.orange,
	notifLoadingColor = flatColors.belizehole,
	notifErrorColor = flatColors.pomegranate,
	notifTextColor = flatColors.clouds,

	buttonColor = flatColors.nephritis,
	buttonTextColor = flatColors.white,
	
	dialogColor = flatColors.orange,
	dialogTextColor = flatColors.black,

	dialogButtonColors = {
		ok = flatColors.nephritis,
		cancel = flatColors.asbestos,
		retry = flatColors.pomegranate,
		yes = flatColors.nephritis,
		no = flatColors.pomegranate,
	},

	contentFont = "fonts/Roboto-Regular",
	titleFont = "fonts/Roboto-Light",
	headerFont = "fonts/Fabrica",

	gridHeaderColor = flatColors.greensea, 
	gridHeaderTextColor = flatColors.clouds, 
	gridRowColor = flatColors.clouds, 
	gridRowTextColor = flatColors.shade( flatColors.greensea ), 
	 
}

return Theme