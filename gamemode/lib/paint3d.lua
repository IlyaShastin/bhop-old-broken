
local paint3D = { cache = {} }
local rtTemp = GetRenderTarget( 'paint_d3d_rt_temp', ScrW(), ScrH() )

-- Initial positions and angles
local pos = Vector( 0, 0, 0 )
local ang = Angle( 0, 90, 0 )

-- Initial camera and rendertarget position and angles
local camPos = pos -- Camera position
local camAng = ang -- Camera angle
local recAng = ang -- Render Target position

-- 3D camera adjustments
local zNear  = 2 -- Distance to near clip plane
local FOV    = 90 -- Camera feild of view

-- Frustum calculations
local fHeight = 2 * zNear * math.tan( math.rad(FOV * 0.5) ) -- View frustum height
local fWidth  = fHeight * (ScrW() / ScrH()) -- View frustum width
local fAspect = fWidth / fHeight -- View frustum aspect ratio

-- Render target distance from camera
local zOffset = recAng:Forward() *  ((zNear + 2) * fAspect)

-- Postion of render target
local recPos  = camPos + zOffset


--
-- Get the default options if not specified
--
local function getDefaultOptions( opts )
    opts = opts or {}

    return {
        -- The 3d offset of the 3d painting
        offset          = opts.offset          or Vector( 0, 0, 0 ),

        -- Angle of the 3d painting along the x-axis (tilt left or right)
        xAngle          = opts.xAngle          or 20,

        -- Angle of the 3d painting along the y-axis (tilt up or down)
        yAngle          = opts.yAngle          or 0,

        -- Rotation of the 3d painting (angle on the z-axis)
        rotate          = opts.rotate          or 0,

        -- Whether the 3d painting's position should reactive to movement
        moveReactive    = opts.moveReactive    or false,

        -- How sensitive the 3d painting is to player movement
        moveSensitivity = opts.moveSensitivity or Vector( 1, 1, 1 ),

        -- Max distane the 3d painting can move from player movement
        moveMaxDistance = opts.moveMaxDistance or Vector( 5, 5, 5 ),

        -- The player that effects the 3d painting movement (useful for spectating)
        movePlayer      = opts.movePlayer      or LocalPlayer(),

        -- Whether the 3d painting's position should react to cursor movement
        cursReactive    = opts.cursReactive    or false,

        -- How sensitive the 3d painting is to cursor movement 
        -- (z value has no effect since cusor movement is 2d)
        cursSensitivity = opts.cursSensitivity or Vector( 1, 1, 0 ),

        -- Max distance the 3d painting can move from cursor movement 
        -- (z value has no effect since cursor movement is 2d)
        cursMaxDistance = opts.cursMaxDistance or Vector( 10, 10, 0 )
    }
end

--
-- Adds cache for new 3d painting
--
local function setCache( id )
    D3D.cache[ id ] = {
        -- Whether the render target should be updated
        shouldUpdate = true,

        -- Render targets
        rt = {
            source = GetRenderTarget( 'paint_d3d_rt_source_' .. id, ScrW(), ScrH() ),
            threed = GetRenderTarget( 'paint_d3d_rt_threed_' .. id, ScrW(), ScrH() )
        },

        -- Materials
        mt = {
            source = CreateMaterial( 'paint_d3d_mt_source_' .. id, 
                'UnlitGeneric', {
                    [ '$translucent' ] = 1,
                    [ '$vertexalpha' ] = 1,
                    [ '$alpha' ]       = 1
            } ),
            threed = CreateMaterial( 'paint_d3d_mt_threed_' .. id, 
                'UnlitGeneric', {
                    [ '$translucent' ] = 1,
                    [ '$vertexalpha' ] = 1,
                    [ '$alpha' ]       = 1
            } )
        },

        opts = getDefaultOptions()
    }
end

--
-- Gets or creates cache for a 3d painting
--
local function getCache( id, shouldUpdate )
    local cache = D3D.cache[ id ]

    -- Create cache if not found
    if not cache then setCache( id ) end

    -- Set up the 3d painting to update
    if shouldUpdate then
        D3D.cache[ id ].shouldUpdate = true
    end

    -- Return new cached 3d painting
    return D3D.cache[ id ]
end

--
-- Debug func to draw 3D directions
--
local function renderDirections( pos, ang )
    render.SetColorMaterial()
    render.DrawLine( pos, pos + ang:Up() * 2, Color( 255, 0, 0 ) )

    render.SetColorMaterial()
    render.DrawLine( pos, pos + ang:Right() * 2, Color( 0, 255, 0 ) )

    render.SetColorMaterial()
    render.DrawLine( pos, pos + ang:Forward() * 2, Color( 0, 0, 255 ) )
end

local function update3DRT( id, opts )
    local cache = getCache( id )

    cache.mt.source:SetTexture( '$basetexture', cache.rt.source )

    -- Fill in default options
    opts = getDefaultOptions( opts )



    render.PushRenderTarget( cache.rt.threed )
    render.OverrideAlphaWriteEnable( true, true )
    render.Clear( 0, 0, 0, 0 )

        cam.Start3D( camPos, camAng, FOV, 0, 0, ScrW(), ScrH(), zNear )
            renderDirections( recPos, recAng )

            render.SetColorMaterial()
            render.DrawQuadEasy( recPos, -recAng:Forward(), fWidth, fHeight, Color( 255, 255, 255, 50 ), 180 )

            render.SetMaterial( cache.mt.source )
            render.DrawQuadEasy( recPos, -recAng:Forward(), fWidth, fHeight, color_white, 180 )
        cam.End3D()

    render.OverrideAlphaWriteEnable( false )
    render.PopRenderTarget()

    cache.shouldUpdate = false
end


--
-- Starts 3D painting
--
function paint3D.start( id, shouldUpdate )
    local cache = getCache( id, shouldUpdate )

    -- Set and clear temp render target to capture paint data
    render.PushRenderTarget( rtTemp )
    render.OverrideAlphaWriteEnable( true, true )
    render.Clear( 0, 0, 0, 0 )

    -- Start 2d rendering
    cam.Start2D()
end

--
-- Stops 3D painting
--
function paint3D.stop( id, opts )
    local cache = getCache( id )

    -- End 2d rendering
    cam.End2D()

    -- Copy paint data to cached render target and remove temp rt
    render.CopyRenderTargetToTexture( cache.rt.source )
    render.OverrideAlphaWriteEnable( false )
    render.PopRenderTarget()

    -- Update the 3D render target
    if cache.shouldUpdate then update3DRT( id, opts ) end

    -- Draw the 3d painting
    paint3D.draw( id, opts )
end


--
-- Draws 3D painting
--
function paint3D.draw( id, opts )
    local cache = getCache( id )

    -- Apply cached rendertarget to cached material
    cache.mt.threed:SetTexture( '$basetexture', cache.rt.threed )

    render.SetMaterial( cache.mt.threed )
    render.DrawScreenQuad()
end


return paint3D