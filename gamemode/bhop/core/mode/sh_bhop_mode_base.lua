
--[[--------------------------------------------------
    Base BHOP mode used by all other modes...
--------------------------------------------------]]--

local MODE = {}

MODE.DisplayName   = 'Base Mode'
MODE.Description   = 'Base Bunny Hop mode description.'
MODE.ExpMultiplier = 0
MODE.Color         = color_white
MODE.DisabledKeys  = {}
MODE.IsKeyDisabled = {}
MODE.Autohop       = true

function MODE:Name()
    return self.DisplayName
end

function MODE:Description()
    return self.Description
end

function MODE:GetExpMultiplier()
    return self.ExpMultiplier
end

function MODE:Exp( amount )
    return amount * self:GetExpMultiplier()
end

function MODE:GetColor()
    return self.Color
end

function MODE:GetDisabledKeys()
    return self.DisabledKeys
end

function MODE:IsKeyDisabled( key )
    return self.IsKeyDisabled[ key ]
end 

function MODE:DisableKeys( ... )
    self.DisabledKeys = { ... }
    for k, key in pairs( self.DisabledKeys ) do
        self.IsKeyDisabled[ key ] = true
    end
end

function MODE:AutohopEnabled()
    return self.Autohop
end

function MODE:Init()
    -- Override and disable keys here
end

function MODE:SetupNWVars()
    self.ply:SetNWInt( 'BhopJumps', 0 )

    self.ply:SetNWFloat( 'BhopStartTime', 0 )
    self.ply:SetNWFloat( 'BhopStopTime', 0 )

    self.ply:SetNWBool( 'BhopTimerFinished', false )
    self.ply:SetNWBool( 'BhopCanPrespeed', true )

    self.ply:SetNWBool( 'BhopIsSpectating', false )
    self.ply:SetNWEntity( 'BhopSpectating', nil )

    self.ply:SetNWBool( 'BhopPaused', false )
    self.ply:SetNWFloat( 'BhopPauseTime', 0 )
    self.ply:SetNWFloat( 'BhopPauseLength', 0 )
    self.ply:SetNWVector( 'BhopPausePos', Vector() )
    self.ply:SetNWAngle( 'BhopPauseAng', Angle() )
end

function MODE:InitialSpawn()
    self:SetupNWVars()
end

function MODE:Spawn()
    self.ply:StartTimer()
end

function MODE:StartMove( mv, cmd )

end

baseclass.Set( 'bhop_mode_base', MODE )
