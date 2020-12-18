
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop_sideways' )
local PLAYER = {}

PLAYER.DisplayName = 'W-Only'

function PLAYER:Init()
    self.Color                  = Color( 226, 106, 106 )
    self.Description            = 'Autohop is enabled, but only the use of [W] is allowed, forcing you to Bunny Hop in an awkward fashion.'
    self.ExperienceMultiplier   = 1.5
end

function PLAYER:StartMove( mv, cmd )
    BaseClass.StartMove( self, mv, cmd )

    -- Don't remove the key if we're just walking
    if mv:GetVelocity():Length2D() > 250 then
        -- Don't change forward speed if we're holding S
        if mv:KeyDown( IN_BACK ) then
            mv:SetForwardSpeed( mv:KeyDown( IN_FORWARD ) and 10000 or 0 )
        end
    end
end

player_manager.RegisterClass( 'player_bhop_wonly', PLAYER, 'player_bhop_sideways' )