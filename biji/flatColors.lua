
local FlatColors = { }

FlatColors["white"] 		= { 255 / 255, 255 / 255, 255 / 255, 1 }
FlatColors["black"] 		= {   0 / 255,   0 / 255,   0 / 255, 1 }
FlatColors["turqoise"] 		= {  26 / 255, 188 / 255, 156 / 255, 1 }
FlatColors["greensea"] 		= {  22 / 255, 160 / 255, 133 / 255, 1 }
FlatColors["emerald"] 		= {  46 / 255, 204 / 255, 113 / 255, 1 }
FlatColors["nephritis"] 	= {  39 / 255, 174 / 255,  96 / 255, 1 }
FlatColors["peterriver"] 	= {  52 / 255, 152 / 255, 219 / 255, 1 }
FlatColors["belizehole"] 	= {  41 / 255, 128 / 255, 185 / 255, 1 }
FlatColors["amethyst"] 		= { 155 / 255,  89 / 255, 182 / 255, 1 }
FlatColors["wisteria"] 		= { 142 / 255,  68 / 255, 173 / 255, 1 }
FlatColors["wetasphalt"] 	= {  52 / 255,  73 / 255,  94 / 255, 1 }
FlatColors["midnightblue"] 	= {  44 / 255,  62 / 255,  80 / 255, 1 }
FlatColors["sunflower"] 	= { 241 / 255, 196 / 255,  15 / 255, 1 }
FlatColors["orange"] 		= { 243 / 255, 156 / 255,  18 / 255, 1 }
FlatColors["carrot"] 		= { 230 / 255, 126 / 255,  34 / 255, 1 }
FlatColors["pumpkin"] 		= { 211 / 255,  84 / 255,   0 / 255, 1 }
FlatColors["alizarin"] 		= { 231 / 255,  76 / 255,  60 / 255, 1 }
FlatColors["pomegranate"] 	= { 192 / 255,  57 / 255,  43 / 255, 1 }
FlatColors["clouds"] 		= { 236 / 255, 240 / 255, 241 / 255, 1 }
FlatColors["silver"] 		= { 189 / 255, 195 / 255, 199 / 255, 1 }
FlatColors["concrete"] 		= { 149 / 255, 165 / 255, 166 / 255, 1 }
FlatColors["asbestos"] 		= { 127 / 255, 140 / 255, 141 / 255, 1 }

function FlatColors.shade( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] * (1 - factor), 
		color[2] * (1 - factor), 
		color[3] * (1 - factor), 
		1 
	}
end

function FlatColors.tint( color, factor )
	if (not factor) then factor = 0.25 end

	return { 
		color[1] + (1 - color[1]) * factor, 
		color[2] + (1 - color[2]) * factor, 
		color[3] + (1 - color[3]) * factor, 
		1 
	}
end

return FlatColors