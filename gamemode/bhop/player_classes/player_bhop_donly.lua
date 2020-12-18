
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop_autohop' )
local PLAYER = {}

PLAYER.DisplayName = 'D-Only'

function PLAYER:Init()
    self.Color                  = Color( 244, 179, 80 )
    self.Description            = 'Autohop is enabled, but you can only use [D] to strafe in the air.'
    self.ExperienceMultiplier   = 1.6
end

function PLAYER:StartMove( mv, cmd )
    BaseClass.StartMove( self, mv, cmd )

    -- Don't do anything if we're just walking
    if mv:GetVelocity():Length2D() > 250 then 
        if mv:KeyDown( IN_FORWARD ) or mv:KeyDown( IN_BACK ) then
            mv:SetForwardSpeed( 0 )
        end

        if mv:KeyDown( IN_MOVELEFT ) then
            mv:SetSideSpeed( mv:KeyDown( IN_MOVERIGHT ) and 10000 or 0 )
        end
    end
end

player_manager.RegisterClass( 'player_bhop_donly', PLAYER, 'player_bhop_autohop' )