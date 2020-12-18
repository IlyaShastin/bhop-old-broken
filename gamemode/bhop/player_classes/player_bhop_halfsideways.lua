
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop_autohop' )
local PLAYER = {}

PLAYER.DisplayName = 'Half-Sideways'

function PLAYER:Init()
    self.Color                  = Color( 244, 179, 80 )
    self.Description            = 'Autohop is enabled, but you have to hold down [W] while using [A] and [D] to bunnyhop.'
    self.ExperienceMultiplier   = 1.1
end

function PLAYER:StartMove( mv, cmd )
    BaseClass.StartMove( self, mv, cmd )

    -- Don't do anything if we're just walking
    if mv:GetVelocity():Length2D() > 250 then 
        -- Remove strafe speed if W isn't pressed
        if not mv:KeyDown( IN_FORWARD ) then
            mv:SetSideSpeed( 0 )
        end

        -- Don't change forward speed if we press S
        if mv:KeyDown( IN_BACK ) then
            mv:SetForwardSpeed( mv:KeyDown( IN_FORWARD ) and 10000 or 0 )
        end
    end
end

player_manager.RegisterClass( 'player_bhop_halfsideways', PLAYER, 'player_bhop_autohop' )