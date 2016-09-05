
local logger = require( "biji.logger" )
local loadsave = require( "libs.loadsave" )


local N = { }


function N.isOnline( url, onComplete )
	network.request( url, "GET", function ( event )

		local ev = { 
			success = not event.isError,
			response = event.response
		}

		onComplete( ev )
	end )
end


function N.downloadJson( url, fileName, baseDir, onComplete )
	local params = {}
	params.progress = true

	local ev = { success, response, result }

	network.download(
	    url,
	    "GET",
	    function ( event )
	    	if ( event.isError ) then
	    		ev.success = false
	    		ev.response = event.response
	    		ev.result = loadsave.loadTable( fileName, baseDir )
	    		
	    		onComplete( ev )
	    	elseif ( event.phase == "ended" ) then
	    		ev.success = not event.isError
	    		ev.response = event.response
	    		ev.result = loadsave.loadTable( fileName, baseDir )
	    		
	    		onComplete( ev )
	    	end
	    end,
	    params,
	    fileName,
	    baseDir
	)
end


return N
