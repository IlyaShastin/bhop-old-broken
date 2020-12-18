
local PANEL = {}

function PANEL:SetShape( shape )
    --shape = shape or GetConVar( 'cl_bhop_crosshair_shape' ):GetDefault()
    --self.shape = vgui.Create( BHOP.ENUMS.CROSSHAIR.SHAPE.VGUI[ shape ] )
end

vgui.Register( 'BhopCrosshair', PANEL )