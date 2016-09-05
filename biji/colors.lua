
local C = { }

C["white"] 			= { 255 / 255, 255 / 255, 255 / 255, 1 }
C["black"] 			= {   0 / 255,   0 / 255,   0 / 255, 1 }
C["turquoise"] 		= {  26 / 255, 188 / 255, 156 / 255, 1 }
C["greensea"] 		= {  22 / 255, 160 / 255, 133 / 255, 1 }
C["emerald"] 		= {  46 / 255, 204 / 255, 113 / 255, 1 }
C["nephritis"] 		= {  39 / 255, 174 / 255,  96 / 255, 1 }
C["peterriver"] 	= {  52 / 255, 152 / 255, 219 / 255, 1 }
C["belizehole"] 	= {  41 / 255, 128 / 255, 185 / 255, 1 }
C["amethyst"] 		= { 155 / 255,  89 / 255, 182 / 255, 1 }
C["wisteria"] 		= { 142 / 255,  68 / 255, 173 / 255, 1 }
C["wetasphalt"] 	= {  52 / 255,  73 / 255,  94 / 255, 1 }
C["midnightblue"] 	= {  44 / 255,  62 / 255,  80 / 255, 1 }
C["sunflower"] 		= { 241 / 255, 196 / 255,  15 / 255, 1 }
C["orange"] 		= { 243 / 255, 156 / 255,  18 / 255, 1 }
C["carrot"] 		= { 230 / 255, 126 / 255,  34 / 255, 1 }
C["pumpkin"] 		= { 211 / 255,  84 / 255,   0 / 255, 1 }
C["alizarin"] 		= { 231 / 255,  76 / 255,  60 / 255, 1 }
C["pomegranate"] 	= { 192 / 255,  57 / 255,  43 / 255, 1 }
C["clouds"] 		= { 236 / 255, 240 / 255, 241 / 255, 1 }
C["silver"] 		= { 189 / 255, 195 / 255, 199 / 255, 1 }
C["concrete"] 		= { 149 / 255, 165 / 255, 166 / 255, 1 }
C["asbestos"] 		= { 127 / 255, 140 / 255, 141 / 255, 1 }

function C.shade( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] * (1 - factor), 
		color[2] * (1 - factor), 
		color[3] * (1 - factor), 
		1 
	}
end

function C.tint( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] + (1 - color[1]) * factor, 
		color[2] + (1 - color[2]) * factor, 
		color[3] + (1 - color[3]) * factor, 
		1 
	}
end

return C
