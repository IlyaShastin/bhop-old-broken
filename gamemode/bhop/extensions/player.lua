
local PLAYER = FindMetaTable( 'Player' )

local function formatTime( t )
    t = tonumber( t )
    
    local split      = string.FormattedTime( math.Round( t, 2 ) )
    local overAnHour = t >= 3600
    local pattern    = overAnHour and '%01i:%02i:%02i:%02i' or '%02i:%02i:%02i'
    local timeData   = { split.h, split.m, split.s, split.ms } 

    return string.FormattedTime( math.Round( t, 2 ), pattern )
end

function PLAYER:GetSpeed()
    return math.floor( self:GetVelocity():Length2D() )
end

function PLAYER:StartTimer()
    self:SetStartTime( RealTime() )
end

function PLAYER:StopTimer()
    self:SetStopTime( RealTime() )
    self:SetCompletedMap( true )
end

function PLAYER:StartTime()
    return self:GetStartTime() or RealTime()
end

function PLAYER:StopTime()
    return self:GetStopTime() or RealTime()
end

function PLAYER:GetTime()
    return 0
end

function PLAYER:GetTimeFormatted()
    local time = self:GetTime()
    return formatTime( time )
end

function PLAYER:IsPaused()
    return self:GetPaused()
end

function PLAYER:Pause()
    self:SetPaused( true )
    self:SetPauseTime( RealTime() )
    self:SetPausePosition( self:GetPos() )
    self:SetPauseAngles( self:EyeAngles() )
end

function PLAYER:UnPause()
    local prePauseLength = self:GetPauseLength()
    local addPauseLength = RealTime() - self:GetPauseTime()

    self:SetPaused( false )
    self:SetPauseLength( prePauseLength + addPauseLength )
    self:SetPos( self:GetPausePosition() )
    self:SetEyeAngles( self:GetPauseAngles() )
end

function PLAYER:SetClassColor( col )
    self.classColor = col
end

function PLAYER:GetClassColor()
    return self.classColor or color_white
end

function PLAYER:SetClassName( name )
    self.className = name
end

function PLAYER:GetClassName()
    return self.className or 'NAN'
end

function PLAYER:GetBestTime()
    return 0
end

function PLAYER:GetBestTimeFormatted()
    local time = self:GetBestTime()
    return formatTime( time )
end