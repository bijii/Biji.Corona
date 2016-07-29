
local loadsave = require( "libs.loadsave" )

local console = true
local file = false

function log( text, args )
	if (console) then
		if (type(args) == "table") then
			print( text )
			loadsave.printTable( args )
		elseif (args == nil) then
			print( text )
		else
			print( text .. tostring( args ))
		end
	end

	if (file) then
		
	end
end
