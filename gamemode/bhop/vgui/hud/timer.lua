
DEFINE_BASECLASS( '3DPaintablePanel' )
local PANEL = {}

local gradientDown = Material( 'vgui/gradient-d', 'smooth noclamp' )
local gradientLeft = Material( 'vgui/gradient-l', 'smooth noclamp' )

surface.CreateFont( 'BHOP.HUD.TIMER.Speed',            { font = 'Bebas Neue', size = 25, italic = true } )
surface.CreateFont( 'BHOP.HUD.TIMER.SpeedUnits',       { font = 'Bebas Neue', size = 17, italic = true } )
surface.CreateFont( 'BHOP.HUD.TIMER.Time',             { font = 'Bebas Neue', size = 27, italic = true } )
surface.CreateFont( 'BHOP.HUD.TIMER.BestTime',         { font = 'Bebas Neue', size = 14, italic = true } )
surface.CreateFont( 'BHOP.HUD.TIMER.Mode',             { font = 'Bebas Neue', size = 18, italic = true } )
surface.CreateFont( 'BHOP.HUD.TIMER.Hops',             { font = 'Bebas Neue', size = 16, italic = true } )

function PANEL:Init()
    BaseClass.Init( self )

    self:SetXAngle( -30 )

    self:EnableMovement()
    self:SetMovementSensitivity( Vector( 0.5, 0.5, 0.5 ) )
    self:SetMovementMaxDistance( Vector( 1.5, 1.5, 1.5 ) )

    -- Graph segment settings
    self.segments          = {}
    self.nextSegment       = true
    self.maxSegmentHeight  = 60
    self.maxSegmentSpeed   = 1200
    self.segmentGap        = 0
    self.segmentSize       = 5
    self.segmentMaxOpacity = 30

    -- Graph settings
    self.graphWidth = 300
    self.xOffset    = 80
    self.yOffset    = 80
    self.yFadeSize  = self.maxSegmentHeight*0.4
    self.xFadeSize  = self.graphWidth*0.3
end

function PANEL:SetPlayer( ply )
    self.ply = ply
    self:WatchPlayerMovement( ply )
end

local function expoInterpolate( t, from, to )
    t = t > 1 and 1 or t

    local diff = to - from
    return (t<=0) and from or from + math.pow( 2, 10 * (t-1) ) * diff
end

function PANEL:AddSegment()
    if self.nextSegment then
        local speed = self.ply:GetSpeed()
        local height = Lerp( speed/self.maxSegmentSpeed, 0, self.maxSegmentHeight )

        -- Insert a new segment and don't allow new ones to be created
        self.segments[ #self.segments+1 ] = { x = 0, height = height }
        self.nextSegment = false
    end
end

function PANEL:GetSegmentOpacity( segment )
    local x       = segment.x
    local fadeEnd = self.graphWidth*0.15
    local opacity = expoInterpolate( x/fadeEnd, 0, self.segmentMaxOpacity )

    return opacity 
end

function PANEL:GetNextSegment( k )
    return self.segments[ k+1 ] or self.segments[ k ]
end

function PANEL:MoveSegments()
    for k, segment in pairs( self.segments ) do
        segment.x = segment.x + 1

        -- Allow for new segment if the last one has moved over enough
        if k == #self.segments and segment.x >= (self.segmentSize+self.segmentGap) then
            self.nextSegment = true
        end

        -- Remove the segment once it is out of view
        if segment.x > self.graphWidth + (self.segmentSize+self.segmentGap) then
            table.remove( self.segments, k )
        end
    end
end

function PANEL:RenderSegments( x, y )
    for k, segment in pairs( self.segments ) do
        -- Skip the last segment since it has no segment after it
        if k == #self.segments then 
            continue 
        end

        -- Don't render if its out of view and pending deletion
        if segment.x >= self.graphWidth + 2 then continue end

        -- Build the polygon based on the current segment and next segment
        local nextSegment = self:GetNextSegment( k )
        local bottomLeft  = { x = x-segment.x,     y = y-0 }
        local topLeft     = { x = x-segment.x,     y = y-segment.height }
        local topRight    = { x = x-nextSegment.x, y = y-nextSegment.height }
        local bottomRight = { x = x-nextSegment.x, y = y-0 }

        -- Get all needed graph colors
        local color         = self.ply:GetClassColor()
        local opacity       = self:GetSegmentOpacity( segment )
        local borderOpacity = (opacity/self.segmentMaxOpacity) * 255

        -- Draw segment polygon
        draw.NoTexture()
        surface.SetDrawColor( ColorAlpha( color, opacity ) )
        surface.DrawPoly( { bottomLeft, topLeft, topRight, bottomRight } )

        -- Draw segment top border
        draw.NoTexture()
        surface.SetDrawColor( ColorAlpha( color, borderOpacity ) )
        surface.DrawLineEx( topLeft.x, topLeft.y, topRight.x, topRight.y, 1 )
    end
end

function PANEL:Paint3D( w, h )
    if not self.ply and not IsValid( self.ply ) then return end
    local tw, th = 0, 0

    local xPos  = self.xOffset
    local yPos  = h-self.yOffset
    local maxH  = self.maxSegmentHeight
    local speed = self.ply:GetSpeed()

    self:RenderSegments( xPos + self.graphWidth, yPos )

    -- Draw x-axis
    draw.NoTexture()
    surface.SetDrawColor( color_white )
    surface.DrawRect( xPos-1, yPos, self.graphWidth-self.xFadeSize, 1 )

    -- Draw x-axis fade
    surface.SetDrawColor( color_white )
    surface.SetMaterial( gradientLeft )
    surface.DrawTexturedRect( xPos-1 + (self.graphWidth-self.xFadeSize), yPos, self.xFadeSize, 1 )

    -- Draw y-axis
    draw.NoTexture()
    surface.SetDrawColor( color_white )
    surface.DrawRect( xPos-1, yPos-maxH + self.yFadeSize, 1, maxH-self.yFadeSize )

    -- Draw y-axis fade
    local yFadeExtension = 20
    surface.SetDrawColor( color_white )
    surface.SetMaterial( gradientDown )
    surface.DrawTexturedRect( xPos-1, yPos-maxH-yFadeExtension, 1, self.yFadeSize+yFadeExtension )

    -- Draw current speed
    tw, th = 
    draw.SimpleText( '  u/s' , 'BHOP.HUD.TIMER.SpeedUnits', xPos-8 + self.graphWidth, yPos-5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( string.Comma( speed ), 'BHOP.HUD.TIMER.Speed', xPos-8 + self.graphWidth - tw, yPos-3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

    -- Draw current time
    tw, th = 
    draw.SimpleText( self.ply:GetTimeFormatted(), 'BHOP.HUD.TIMER.Time', xPos+5, yPos-maxH-yFadeExtension, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    -- Draw best time
    draw.SimpleText( self.ply:GetBestTimeFormatted(), 'BHOP.HUD.TIMER.BestTime', xPos+9, yPos-maxH-yFadeExtension + th-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    -- Draw current mode
    draw.SimpleText( self.ply:GetClassName(), 'BHOP.HUD.TIMER.Mode', xPos, yPos+5, self.ply:GetClassColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    -- Draw hop count
    draw.SimpleText( '0 HOPS', 'BHOP.HUD.TIMER.Hops', xPos+8, yPos-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    -- Debug rect
    -- surface.SetDrawColor( 255, 255, 255, 50 )
    -- surface.DrawRect( 0, 0, w, h )

    self:MoveSegments()
end

function PANEL:Think()
    if self.ply and IsValid( self.ply ) then
        self:AddSegment()
    end
end

vgui.Register( 'BhopTimer', PANEL, '3DPaintablePanel' )