
local VECTOR = FindMetaTable( 'Vector' )

local math_Approach = math.Approach

function VECTOR:Approach( to, rate )
    return Vector(
        math_Approach( self.x, to.x, rate ),
        math_Approach( self.y, to.y, rate ),
        math_Approach( self.z, to.z, rate )
    )
end