
if SERVER then return end

local math_atan2 = math.atan2
local math_sqrt  = math.sqrt
local math_deg   = math.deg

local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated


function surface.DrawLineEx( x1, y1, x2, y2, w )
	w   = w or 1
	col = col

	local dx,dy = x1-x2, y1-y2
	local ang   = math_atan2( dx, dy )
	local dst   = math_sqrt( (dx * dx) + (dy * dy) )

	x1 = x1 - dx * 0.5
	y1 = y1 - dy * 0.5

	surface_DrawTexturedRectRotated( x1, y1, w, dst, math_deg( ang ) )
end