
local json = require( "json" )
local logger = require( "biji.logger" )
local loadsave = require( "libs.loadsave" )
local luausers = require( "libs.luausers" )


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


function N.postJson( url, data, onComplete )
	local headers = {}
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"

	data = data or { }
	local body = ""
	
	for i,v in pairs(data) do
		body = body .. i .. "=" .. tostring(v) .. "&"
	end

	network.request( 
		url, 
		"POST", 
		function( event )
			log(event)
	    	if ( event.isError ) then
	    		if ( not onComplete ) then
	    			return
	    		end
	    	
	    		onComplete {
		    		isError = true,
		    		response = event.response,
	    		}
    		
	    	elseif ( event.phase == "ended" ) then
	    	
	    		if ( not onComplete ) then
	    			return
	    		end

    			local status = tostring( event.status )
    			local errorStatus = string.starts( status, "4" ) or string.starts( status, "5" )

	    		local response = event.response or status
	    		
	    		onComplete {
		    		isError = false or errorStatus,
		    		response = response,
	    		}
    		
	    	end
		end,
		{
			headers = headers,
			body = body
		}
	)
end


function N.getJson( url, onComplete )
	local ev = { isError, success, response, result }
	
	network.request( url, "GET", function( event )
    	if ( event.isError ) then
    		onComplete {
	    		isError = true,
	    		response = event.response,
    		}
    	elseif ( event.phase == "ended" ) then
			local status = tostring( event.status )
			local errorStatus = string.starts( status, "4" ) or string.starts( status, "5" )
    		
    		local response = event.response or status

    		onComplete {
	    		isError = false or errorStatus,
	    		response = response,
    		}

    		onComplete( ev )
    	end
	end)
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
