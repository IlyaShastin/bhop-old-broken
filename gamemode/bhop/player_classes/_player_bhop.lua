
AddCSLuaFile()

DEFINE_BASECLASS( 'player_default' )
local PLAYER = {}

PLAYER.DisplayName       = 'Bhopper'
PLAYER.WalkSpeed         = 250
PLAYER.RunSpeed          = 250
PLAYER.JumpPower         = 280
PLAYER.CrouchedWalkSpeed = 0.5

function PLAYER:Init()
    self.Color                  = color_white
    self.Description            = 'Base Bunny Hop mode description.'
    self.ExperienceMultiplier   = 0
end

function PLAYER:SetupDataTables()
    self.Player:NetworkVar( 'Int',    0, 'Jumps' )

    self.Player:NetworkVar( 'Float',  0, 'StartTime' )
    self.Player:NetworkVar( 'Float',  1, 'StopTime' )

    self.Player:NetworkVar( 'Bool',   0, 'CompletedMap' )
    self.Player:NetworkVar( 'Bool',   1, 'InStartingZone' )

    self.Player:NetworkVar( 'Bool',   3, 'Spectating' )
    self.Player:NetworkVar( 'Entity', 0, 'SpectateTarget' )

    self.Player:NetworkVar( 'Bool',   4, 'Paused' )
    self.Player:NetworkVar( 'Float',  2, 'PauseTime' )
    self.Player:NetworkVar( 'Float',  3, 'PauseLength' )
    self.Player:NetworkVar( 'Vector', 0, 'PausePosition' )
    self.Player:NetworkVar( 'Angle',  0, 'PauseAngle' )
end

function PLAYER:Spawn()
    self.Player:SetTeam( BHOP.ENUMS.TEAM_BHOP )

    self.Player:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    self.Player:GodEnable()
    
    self:SetViews()
    self:SetDefaultNetworkVars()
    self:SetPlayerModelColor()

    self.Player:StartTimer()
end

function PLAYER:SetDefaultNetworkVars()
    self.Player:SetJumps( 0 )

    self.Player:SetStartTime( RealTime() )
    self.Player:SetStopTime( 0 )

    self.Player:SetCompletedMap( false )
    self.Player:SetInStartingZone( false )
    
    self.Player:SetSpectating( false )
    self.Player:SetSpectateTarget( nil )

    self.Player:SetPaused( false )
    self.Player:SetPauseTime( 0 )
    self.Player:SetPauseLength( 0 )
    self.Player:SetPausePosition( Vector( 0, 0, 0 ) )
    self.Player:SetPauseAngle( Angle( 0, 0, 0 ) )
end

function PLAYER:SetPlayerModelColor()
    local classColor  = self.Color
    local playerColor = Vector( classColor.r/255, classColor.g/255, classColor.b/255 )
    self.Player:SetPlayerColor( playerColor )
end

function PLAYER:SetModel()
    local gender       = math.random() > 0.5 and 'male' or 'female'
    local variation    = math.random( gender == 'male' and 18 or 12 )
    local strVariation = variation < 10 and '0' .. variation or tostring( variation )
    local model        = player_manager.TranslatePlayerModel( gender .. variation )

    util.PrecacheModel( model )
    self.Player:SetModel( model )
end

function PLAYER:Loadout()
    self.Player:RemoveAllItems()
    self.Player:Give( 'bhop_glock' )
end

function PLAYER:SetViews()
    self.setViews = self.setViews or false
    if not self.setViews then
        self.Player:SetDuckSpeed( 0.4 )
        self.Player:SetUnDuckSpeed( 0.4 )
        self.Player:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 62 ) )
        self.Player:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 45 ) )
        self.Player:SetCurrentViewOffset( Vector( 0, 0, 64 ) )
        self.Player:SetViewOffsetDucked( Vector( 0, 0, 47 ) )
        self.setViews = true
    end
end

function PLAYER:CalcView( view )
    self:SetViews()
    self.Player:SetClassColor( self.Color )
    self.Player:SetClassName( self.DisplayName )

    return view
end

function PLAYER:Move( mv )
    if not self.PLayer or not self.Player:IsValid() then 
        return end

    self:SetViews()

    if self.Player:IsOnGround() or not self.Player:Alive() or self.Player:WaterLevel() > 0 then
        return end

    local aim = mv:GetMoveAngles()
    local forward, right = aim:Forward(), aim:Right()
    local fmove = mv:GetForwardSpeed()
    local smove = mv:GetSideSpeed()

    if self.Player:KeyDown( IN_MOVERIGHT ) then
        smove = smove * 10 + 500
    elseif self.Player:KeyDown( IN_MOVELEFT ) then
        smove = smove * 10 + 500
    end

    forward.z, right.z = 0, 0
    forward:Normalize()
    right:Normalize()

    local targetVel = forward*fmove + right*smove
    targetVel.z = 0

    local targetSpeed = targetVel:Length()

    if targetSpeed > mv:GetMaxSpeed() then
        targetVel = targetVel * (mv:GetMaxSpeed()/targetSpeed)
        targetSpeed = mv:GetMaxSpeed()
    end

    local newTargetSpeed  = math.Clamp( targetSpeed, 0, 30 )
    local targetDirection = targetVel:GetNormal()
    local currentSpeed    = mv:GetVelocity():Dot( targetDirection )
    local speedIncrease   = newTargetSpeed - currentSpeed

    if speedIncrease <= 0 then return end

    local accelSpeed = 120 * targetSpeed * FrameTime()

    if accelSpeed > speedIncrease then 
        accelSpeed = speedIncrease
    end

    local newVelocity = mv:GetVelocity() + (targetDirection * accelSpeed)
    mv:SetVelocity( newVelocity )

    return true
end

player_manager.RegisterClass( 'player_bhop', PLAYER, 'player_default' )
