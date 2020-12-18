
local MODE = {}

MODE.DisplayName            = 'Autohop'
MODE.Description            = 'Holding your jump key will allow you to have perfectly timed jumps everytime you touch the ground.'
MODE.ExperienceMultiplier   = 1
MODE.Color                  = Color( 25, 181, 254 )

function MODE:SetupMove( ply, move )
    if not ply:IsOnGround() 
    and ply:WaterLevel() < 2 
    and ply:GetMoveType() != MOVETYPE_LADDER then
        move:SetButtons( bit.band( move:GetButtons(), bit.bnot( IN_JUMP ) ) )
    end
end

BHOP.registerNewMode( 'autohop', MODE )
