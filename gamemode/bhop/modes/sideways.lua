
local MODE = {}

MODE.DisplayName            = 'Sideways'
MODE.Description            = 'Autohop is enabled, but only the use of [W] and [S] are allowed, forcing you to Bunny Hop sideways.'
MODE.ExperienceMultiplier   = 1.2
MODE.Color                  = Color( 104, 195, 163 )

function MODE:StartCommand( ply, cmd )
    self.__base:StartCommand( ply, cmd )

    if cmd:KeyDown( IN_MOVELEFT ) then
        cmd:SetButtons( bit.band( cmd:GetButtons(), bit.bnot( IN_MOVELEFT ) ) )
    end

    if cmd:KeyDown( IN_MOVERIGHT ) then
        cmd:SetButtons( bit.band( cmd:GetButtons(), bit.bnot( IN_MOVERIGHT ) ) )
    end
end