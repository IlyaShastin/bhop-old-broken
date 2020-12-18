
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop_autohop' )
local PLAYER = {}

PLAYER.DisplayName = 'Sideways'

function PLAYER:Init()
    self.Color                  = Color( 244, 179, 80 )
    self.Description            = 'Autohop is enabled, but only the use of [W] and [S] are allowed, forcing you to Bunny Hop sideways.'
    self.ExperienceMultiplier   = 1.2
end

function PLAYER:StartMove( mv, cmd )
    BaseClass.StartMove( self, mv, cmd )

    -- Don't remove keys if we're just walking
    if mv:GetVelocity():Length2D() > 250 then 
        -- Remove strafe speed if A or D are pressed
        if mv:KeyDown( IN_MOVELEFT ) or mv:KeyDown( IN_MOVERIGHT ) then
            mv:SetSideSpeed( 0 )
        end
    end
end

player_manager.RegisterClass( 'player_bhop_sideways', PLAYER, 'player_bhop_autohop' )