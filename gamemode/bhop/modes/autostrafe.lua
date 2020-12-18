
local MODE = {}

MODE.DisplayName            = 'Autostrafe'
MODE.Description            = 'While holding your jump key, you have perfectly timed jumps everytime you touch the gound and moving your mouse to the left or right will strafe for you in that direction.'
MODE.ExperienceMultiplier   = 0.85
MODE.Color                  = Color( 142, 68, 173 )

function MODE:StartCommand( ply, cmd )
    if cmd:KeyDown( IN_JUMP ) then
        if cmd:GetMouseX() < 0 then
            cmd:SetButtons( bit.bor( cmd:GetButtons(), IN_MOVELEFT ) )

        elseif cmd:GetMouseX() > 0 then
            cmd:SetButtons( bit.bor( cmd:GetButtons(), IN_MOVERIGHT ) )

        end
    end
end

BHOP.registerNewMode( 'autostrafe', MODE, 'autohop' )
