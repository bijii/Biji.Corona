
local loadsave = require( "libs.loadsave" )

local console = true
local file = false

function log( ... )
	
	if (console) then
		for i=1,#arg do
			if (type( arg[i] ) == "table") then
				loadsave.printTable( arg[i] )
			else
				print( arg[i] )
			end
		end
	end

	if (file) then

	end
	
end
