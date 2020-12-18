
local PANEL = {}

function PANEL:Paint( w, h )
    local cx, cy = ScrW()*0.5, ScrH()*0.5

    surface.SetDrawColor( color_white )
    surface.DrawRect( cx, cy, 100, 100 )
end

vgui.Register( 'BhopCrosshairShapePlus', PANEL, 'BhopCrosshairBase' )