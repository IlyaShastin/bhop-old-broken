
AddCSLuaFile()

DEFINE_BASECLASS( 'player_bhop' )
local PLAYER = {}

PLAYER.DisplayName = 'Autohop'

function PLAYER:Init()
    self.Color                  = Color( 25, 181, 254 )
    self.Description            = 'Holding your jump key will allow you to have perfectly timed jumps everytime you touch the ground.'
    self.ExperienceMultiplier   = 1
end

function PLAYER:StartMove( mv, cmd )
    if not self.Player:IsOnGround() 
    and self.Player:WaterLevel() < 2 
    and self.Player:GetMoveType() != MOVETYPE_LADDER then
        mv:SetButtons( bit.band( mv:GetButtons(), bit.bnot( IN_JUMP ) ) )
    end
end

player_manager.RegisterClass( 'player_bhop_autohop', PLAYER, 'player_bhop' )