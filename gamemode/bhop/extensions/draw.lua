
local draw_SimpleTextOutlined = draw.SimpleTextOutlined

function draw.TextSmoothShadowed( str, font, x, y, color, alignX, alignY, darkness )
    draw_SimpleTextOutlined( str, font, x, y, color, alignX, alignY, 1, Color( 0, 0, 0, darkness ) )
    return draw_SimpleTextOutlined( str, font, x, y, color, alignX, alignY, 2, Color( 0, 0, 0, darkness*0.5 ) )
end