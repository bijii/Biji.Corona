
local flatColors = { }

flatColors["turqoise"] 		= {  26 / 255, 188 / 255, 156 / 255, 1 }
flatColors["greensea"] 		= {  22 / 255, 160 / 255, 133 / 255, 1 }
flatColors["emerald"] 		= {  46 / 255, 204 / 255, 113 / 255, 1 }
flatColors["nephritis"] 	= {  39 / 255, 174 / 255,  96 / 255, 1 }
flatColors["peterriver"] 	= {  52 / 255, 152 / 255, 219 / 255, 1 }
flatColors["belizehole"] 	= {  41 / 255, 128 / 255, 185 / 255, 1 }
flatColors["amethyst"] 		= { 155 / 255,  89 / 255, 182 / 255, 1 }
flatColors["wisteria"] 		= { 142 / 255,  68 / 255, 173 / 255, 1 }
flatColors["wetasphalt"] 	= {  52 / 255,  73 / 255,  94 / 255, 1 }
flatColors["midnightblue"] 	= {  44 / 255,  62 / 255,  80 / 255, 1 }
flatColors["sunflower"] 	= { 241 / 255, 196 / 255,  15 / 255, 1 }
flatColors["orange"] 		= { 243 / 255, 156 / 255,  18 / 255, 1 }
flatColors["carrot"] 		= { 230 / 255, 126 / 255,  34 / 255, 1 }
flatColors["pumpkin"] 		= { 211 / 255,  84 / 255,   0 / 255, 1 }
flatColors["alizarin"] 		= { 231 / 255,  76 / 255,  60 / 255, 1 }
flatColors["pomegranate"] 	= { 192 / 255,  57 / 255,  43 / 255, 1 }
flatColors["clouds"] 		= { 236 / 255, 240 / 255, 241 / 255, 1 }
flatColors["silver"] 		= { 189 / 255, 195 / 255, 199 / 255, 1 }
flatColors["concrete"] 		= { 149 / 255, 165 / 255, 166 / 255, 1 }
flatColors["asbestos"] 		= { 127 / 255, 140 / 255, 141 / 255, 1 }

function flatColors.shade( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] * (1 - factor), 
		color[2] * (1 - factor), 
		color[3] * (1 - factor), 
		1 
	}
end

function flatColors.tint( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] + (1 - color[1]) * factor, 
		color[2] + (1 - color[2]) * factor, 
		color[3] + (1 - color[3]) * factor, 
		1 
	}
end

return flatColors