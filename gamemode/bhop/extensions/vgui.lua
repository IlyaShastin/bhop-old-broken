
if SERVER then return end

vgui.Paint3D          = {} -- Table in global vgui table to hold our stuff
vgui.Paint3D.Panels   = {} -- Table containing panels to be 3D painted
vgui.Paint3D.Movement = {} -- Table containing panels to be affected by movement
vgui.Paint3D.Cache    = {}

--
--  Grab a few important variables for view calc and save them in the global vgui table.
--
hook.Add( 'CalcView', 'vgui.Paint3D.CalcView', function( ply, pos, ang, fov, znear, zfar )
    -- Only want our view
    if IsValid( LocalPlayer() ) and ply == LocalPlayer() then
        vgui.Paint3D._viewznear = znear
        vgui.Paint3D._viewfov   = fov
        vgui.Paint3D._viewang   = ang
        vgui.Paint3D._viewpos   = pos
    end
end )

--
--  Create the 3D cam and start building the 3D2D cam
--
hook.Add( 'HUDPaint', 'vgui.Paint3D.HUDPaint', function()
    local viewPos = vgui.Paint3D.GetViewPos()
    local viewAng = vgui.Paint3D.GetViewAng()
    local viewFOV = vgui.Paint3D.GetViewFOV()

    cam.Start3D( viewPos, viewAng, viewFOV )
    cam.IgnoreZ( true )
        for pnl, paint in pairs( vgui.Paint3D.Panels ) do
            if IsValid( pnl ) and paint then
                pnl:Build3D2DCam()
            end
        end
    cam.IgnoreZ( false )
    cam.End3D()
end )

--
--  Send movement data to 3D panels that enable it
--
hook.Add( 'FinishMove', 'vgui.Paint3D.FinishMove', function( ply, mv )
    for pnl, move in pairs( vgui.Paint3D.Movement ) do
        if IsValid( pnl ) and move then
            pnl:FinishMove( ply, mv )
        end
    end
end )

--
--  Get the view origin distance from the znear plane
--
function vgui.Paint3D.GetViewZNear()
    return vgui.Paint3D._viewznear or 0
end

--
--  Get the current view's fov
--
function vgui.Paint3D.GetViewFOV()
    return vgui.Paint3D._viewfov or 70
end

--
--  Get the current view's angles
--  
function vgui.Paint3D.GetViewAng()
    return vgui.Paint3D._viewang or Angle()
end

--
--  Get the position of the current view
--
function vgui.Paint3D.GetViewPos()
    return vgui.Paint3D._viewpos or Vector()
end

--
--  Gets the width and height of the view frustum
--
function vgui.Paint3D.GetFrustumSize()
    local updateCache = false
    if vgui.Paint3D.Cache.screenHeight != ScrH() then
        updateCache = true
    end

    -- Return the cached size if its there so we don't have to call
    -- expensive math funcs all the time...
    if vgui.Paint3D.Cache.frustumSize and not updateCache then
        return vgui.Paint3D.Cache.frustumSize.w, vgui.Paint3D.Cache.frustumSize.h
    end

    local znear  = vgui.Paint3D.GetViewZNear()
    local fov    = vgui.Paint3D.GetViewFOV()
    local height = 2 * znear * (math.tan( math.rad(fov*0.5) ))
    local width  = height * (ScrW()/ScrH())

    -- Update our cache
    vgui.Paint3D.Cache.frustumSize = { w = width, h = height }
    vgui.Paint3D.Cache.screenHeight  = ScrH()

    return width, height
end

--
--  Adds a panel to be 3D painted
--
function vgui.Paint3D.AddPanel( pnl )
    vgui.Paint3D.Panels[ pnl ] = true
end

--
--  Removes a panel from being 3D painted
--
function vgui.Paint3D.RemovePanel( pnl )
    vgui.Paint3D.Panels[ pnl ] = nil
end

function vgui.Paint3D.AddMovement( pnl )
    vgui.Paint3D.Movement[ pnl ] = true
end

function vgui.Paint3D.RemoveMovement( pnl )
    vgui.Paint3D.Movement[ pnl ] = nil
end

--[[------------------------------------------------------------
    
------------------------------------------------------------]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW(), ScrH() )
    self:SetPos( 0, 0 )

    self.xAngle = 0
    self.yAngle = 0

    self.movementEnabled     = false
    self.movementPlayer      = nil
    self.movementOffset      = Vector()
    self.movementSensitivity = Vector( 1, 1, 1 )
    self.movementMax         = nil

    vgui.Paint3D.AddPanel( self )
end

function PANEL:EnableMovement()
    self.movementEnabled = true
    vgui.Paint3D.AddMovement( self )
end

function PANEL:DisableMovement()
    self.movementEnabled = false
    vgui.Paint3D.RemoveMovement( self )
end

function PANEL:WatchPlayerMovement( ply )
    self.movementPlayer = ply
end

function PANEL:SetMovementSensitivity( sensitivity )
    self.movementSensitivity = sensitivity
end

function PANEL:SetMovementMaxDistance( max )
    self.movementMax = max
end

--
--  Once the panel is removed, remove it from being 3D painted
--
function PANEL:OnRemove()
    self:DisableMovement()
    vgui.Paint3D.RemovePanel( self )
end

function PANEL:PerformLayout( w, h )

end

--
--  Set the angle along the x axis of the paint 
--
function PANEL:SetXAngle( ang )
    if ang > 0 then
        self.xAngle = math.Clamp( ang, 0, 90 )
    else
        self.xAngle = math.Clamp( ang, -90, 0 )
    end
end

--
--  Set the angle along the y axis of the paint
--
function PANEL:SetYAngle( ang )
    if ang > 0 then
        self.yAngle = math.Clamp( ang, 0, 90 )
    else
        self.yAngle = math.Clamp( ang, -90, 0 )
    end
end

--
--  Returns the x,y,z offset for the 3D2D camera.
--  The offset centers the 2D plane in the middle of the camera
--  and moves it just in front of the znear clipping plane.
--
function PANEL:Get3D2DCamPos()
    local viewPos = vgui.Paint3D.GetViewPos()
    local viewAng = vgui.Paint3D.GetViewAng()
    local viewZnr = vgui.Paint3D.GetViewZNear()

    local fwidth, fheight = vgui.Paint3D.GetFrustumSize()
    local fAspectRatio    = fwidth / fheight

    -- Center the 3D2D cam in 3D cam and move forward
    local zOffset = viewAng:Forward() * (viewZnr*fAspectRatio) 
    local xOffset = viewAng:Right() * -(fwidth*0.5) 
    local yOffset = viewAng:Up() * (fheight*0.5) 

    return viewPos + zOffset + xOffset + yOffset
end

--
--  Returns the correct angle for the camera's
--  orientation in the 3D cam.
--
function PANEL:Get3D2DCamAng()
    local viewAng = vgui.Paint3D.GetViewAng()
    local camAng  = Angle( viewAng.p - 90, viewAng.y, 0 )
    
    camAng:RotateAroundAxis( camAng:Up(), -90 )

    return camAng
end

--
--  Creates the 3D2D camera and applies any cam modifications
--
function PANEL:Build3D2DCam()
    local camPos = self:Get3D2DCamPos()
    local camAng = self:Get3D2DCamAng()

    local old = camPos
    local new = camPos

    local fwidth, fheight    = vgui.Paint3D.GetFrustumSize()
    local fdiff, sdiff       = (fwidth-fheight), (ScrW()-ScrH())
    local frustumScreenRatio = fdiff / sdiff

    -- Camera position before angle adjustments
    local old = camPos + camAng:Forward()*fwidth

    camAng:RotateAroundAxis( camAng:Right(), self.xAngle )
    camAng:RotateAroundAxis( camAng:Up(), self.yAngle )

    -- Camera position after angle adjustments
    local new = camPos + camAng:Forward()*fwidth

    -- Apply movement offset
    camPos = camPos - self.movementOffset

    -- Move camera forward if angle adjustment is positive
    if self.xAngle > 0 then
        camPos = camPos - (new-old)
    end

    cam.Start3D2D( camPos, camAng, frustumScreenRatio )
        self:Paint3D( ScrW(), ScrH() )
    cam.End3D2D()
end

function PANEL:MaxVector( vector, max )
    return Vector(
        math.Clamp( vector.x, -max.x, max.x ),
        math.Clamp( vector.y, -max.y, max.y ),
        0
    )
end

function PANEL:FinishMove( ply, mv )
    if self.movementEnabled and (self.movementPlayer == ply) then
        local sens    = self.movementSensitivity / 250
        local offset  = 0.2 * mv:GetVelocity() * sens
        local max     = 0.2 * self.movementMax
        local vOffset = Vector( offset.x, offset.y, 0 )

        self.movementOffset = max and self:MaxVector( offset, max ) or offset
    end
end

--
--  Where the 2D is painted in 3D
--
function PANEL:Paint3D( w, h )
    -- Overriden
end

vgui.Register( '3DPaintablePanel', PANEL )