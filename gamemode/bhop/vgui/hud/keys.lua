
DEFINE_BASECLASS( '3DPaintablePanel' )
local PANEL = {}

surface.CreateFont( 'BHOP.HUD.KEYS.Key',            { font = 'Bebas Neue', size = 16, italic = false } )

function PANEL:Init()
    BaseClass.Init( self )

    self:SetXAngle( 30 )
    self:SetYAngle( 0 )

    self:EnableMovement()
    self:SetMovementSensitivity( Vector( 0.5, 0.5, 0.5 ) )
    self:SetMovementMaxDistance( Vector( 1.5, 1.5, 1.5 ) )

    self.ply = nil

    self.xOffset = 80
    self.yOffset = 80
    self.keySize = 40
    self.keyGap  = 7
end

function PANEL:SetPlayer( ply )
    self:WatchPlayerMovement( ply )
    self.ply = ply
end

function PANEL:ExtendKeyWidth( multiplier )
    return self.keySize*multiplier + self.keyGap*(multiplier-1)
end

function PANEL:KeyRow( row )
    return self.keySize*row + self.keyGap*(row-1)
end

function PANEL:KeyCol( col )
    return self.keyGap*col + self.keySize*(col-1)
end

function PANEL:PaintKey( x, y, w, h, str, down )
    local color = self.ply:GetClassColor()
    local bgOpacity = down and 50 or 20
    local bdOpacity = down and 150 or 100
    local bgColor = down and ColorAlpha( color, bgOpacity ) or Color( 255, 255, 255, bgOpacity )
    local bdColor = down and ColorAlpha( color, bdOpacity ) or Color( 255, 255, 255, bdOpacity )

    -- Background
    draw.NoTexture()
    surface.SetDrawColor( bgColor )
    surface.DrawRect( x, y, w, h )

    -- Border top
    draw.NoTexture()
    surface.SetDrawColor( bdColor )
    surface.DrawRect( x, y, w, 1 )

    -- Border right
    draw.NoTexture()
    surface.SetDrawColor( bdColor )
    surface.DrawRect( x+w, y, 1, h )

    -- Border bottom
    draw.NoTexture()
    surface.SetDrawColor( bdColor )
    surface.DrawRect( x, y+h, w, 1 )

    -- Border left
    draw.NoTexture()
    surface.SetDrawColor( bdColor )
    surface.DrawRect( x, y, 1, h )

    -- Key name
    draw.SimpleText( str, 'BHOP.HUD.KEYS.Key', x+w*0.5, y+h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:Paint3D( w, h )
    local xOffset = ScrW()-self.xOffset
    local yOffset = ScrH()-self.yOffset
    local keySize = self.keySize
    local keyGap  = self.keyGap

    local duckKeyWidth = self:ExtendKeyWidth( 2 )
    local jumpKeyWidth = self:ExtendKeyWidth( 5 )

    local x, y = xOffset-jumpKeyWidth, yOffset
    local row1 = y-self:KeyRow( 1 )
    local row2 = y-self:KeyRow( 2 )
    local row3 = y-self:KeyRow( 3 )

    self:PaintKey( x, row1, jumpKeyWidth, keySize, 'JUMP', self.ply:KeyDown( IN_JUMP ) )

    self:PaintKey( x, row2, duckKeyWidth, keySize, 'DUCK', self.ply:KeyDown( IN_DUCK ) )
    self:PaintKey( x + duckKeyWidth + self:KeyCol( 1 ), row2, keySize, keySize, 'A', self.ply:KeyDown( IN_MOVELEFT ) )
    self:PaintKey( x + duckKeyWidth + self:KeyCol( 2 ), row2, keySize, keySize, 'S', self.ply:KeyDown( IN_BACK ) )
    self:PaintKey( x + duckKeyWidth + self:KeyCol( 3 ), row2, keySize, keySize, 'D', self.ply:KeyDown( IN_MOVERIGHT ) )

    self:PaintKey( x + duckKeyWidth + self:KeyCol( 2 ), row3, keySize, keySize, 'W', self.ply:KeyDown( IN_FORWARD ) )

    -- surface.SetDrawColor( 255, 255, 255, 50 )
    -- surface.DrawRect( 0, 0, w, h )
end

vgui.Register( 'BhopKeys', PANEL, '3DPaintablePanel' )