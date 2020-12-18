
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop_autohop' )
local PLAYER = {}

PLAYER.DisplayName = 'Autostrafe'

function PLAYER:Init()
    self.Color                  = Color( 190, 144, 212 )
    self.Description            = 'While holding your jump key, you have perfectly timed jumps everytime you touch the gound and moving your mouse to the left or right will strafe for you in that direction.'
    self.ExperienceMultiplier   = 0.85
end

function PLAYER:StartMove( mv, cmd )
    BaseClass.StartMove( self, mv, cmd )

    if cmd:KeyDown( IN_JUMP ) then
        if cmd:GetMouseX() < 0 then
            mv:SetSideSpeed( -10000 )

        elseif cmd:GetMouseX() > 0 then
            mv:SetSideSpeed( 10000 )

        end
    end
end

player_manager.RegisterClass( 'player_bhop_autostrafe', PLAYER, 'player_bhop_autohop' )