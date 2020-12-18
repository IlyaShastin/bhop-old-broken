
local PANEL = {}

AccessorFunc( PANEL, 'nStyle',          'Style',            FORCE_NUMBER )
AccessorFunc( PANEL, 'SegmentSize',     'SegmentSize',      FORCE_NUMBER )
AccessorFunc( PANEL, 'nGap',            'Gap',              FORCE_NUMBER )
AccessorFunc( PANEL, 'nThickness',      'Thickness',        FORCE_NUMBER )
AccessorFunc( PANEL, 'bDot',            'Dot',              FORCE_BOOL )
AccessorFunc( PANEL, 'nDotSize',        'DotSize',          FORCE_NUMBER )
AccessorFunc( PANEL, 'nColorPref',      'ColorPref',        FORCE_NUMBER )
AccessorFunc( PANEL, 'nColorR',         'ColorR',           FORCE_NUMBER )
AccessorFunc( PANEL, 'nColorG',         'ColorG',           FORCE_NUMBER )
AccessorFunc( PANEL, 'nColorB',         'ColorB',           FORCE_NUMBER )
AccessorFunc( PANEL, 'nOpacity',        'Opacity',          FORCE_NUMBER )

function PANEL:Init()
    self:SetPos( 0, 0 )
    self:SetSize( ScrW(), ScrH() )

    self.colors = {
        [ BHOP.ENUMS.CROSSHAIR.COLOR.GREEN ]  = Color( 63, 195, 128 ),
        [ BHOP.ENUMS.CROSSHAIR.COLOR.BLUE ]   = Color( 25, 181, 254 ),
        [ BHOP.ENUMS.CROSSHAIR.COLOR.RED ]    = Color( 236, 100, 75 ),
        [ BHOP.ENUMS.CROSSHAIR.COLOR.YELLOW ] = Color( 233, 212, 96 ),
        [ BHOP.ENUMS.CROSSHAIR.COLOR.PURPLE ] = Color( 155, 89, 182 ),
        [ BHOP.ENUMS.CROSSHAIR.COLOR.WHITE ]  = Color( 255, 255, 255 ),
    }
end

function PANEL:GetColor()
    if self:GetColorPref() != BHOP.ENUMS.CROSSHAIR.COLOR.CUSTOM then
        return self.colors[ self:GetColorPref() ] end

    return Color( self:GetColorR(), self:GetColorG(), self:GetColorB() )
end

function PANEL:PerformLayout( w,  h )
    self:SetStyle( GetConVar( 'cl_bhop_crosshair_style' ):GetInt() )
    self:SegmentSize( GetConVar( 'cl_bhop_crosshair_size' ):GetInt() )
    self:SetGap( GetConVar( 'cl_bhop_crosshair_gap' ):GetInt() )
    self:SetThickness( GetConVar( 'cl_bhop_crosshair_thickness' ):GetInt() )
    self:SetDot( GetConVar( 'cl_bhop_crosshair_dot' ):GetBool() )
    self:SetDotSize( GetConVar( 'cl_bhop_crosshair_dot_size' ):GetInt() )
    self:SetColorPref( GetConVar( 'cl_bhop_crosshair_color' ):GetInt() )
    self:SetColorR( GetConVar( 'cl_bhop_crosshair_color_r' ):GetInt() )
    self:SetColorG( GetConVar( 'cl_bhop_crosshair_color_g' ):GetInt() )
    self:SetColorB( GetConVar( 'cl_bhop_crosshair_color_b' ):GetInt() )
    self:SetOpacity( GetConVar( 'cl_bhop_crosshair_opacity' ):GetInt() )
end

vgui.Register( 'BhopCrosshairBase', PANEL )
