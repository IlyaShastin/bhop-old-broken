
local drawHUDElems = {
    [ 'CHudHealth' ]  = false,
    [ 'CHudBattery' ] = false,
    [ 'CHudAmmo' ]    = false
}

--
--  No death notices
--
function GM:DrawDeathNotice( x, y ) 
end

--
--  Target ID overriden by gamemode
--
function GM:HUDDrawTargetID() 
end

--
--  No weapon pickup notifications
--
function GM:HUDWeaponPickedUp( w )
end

--
--  No ammo pickup notifications
--
function GM:HUDAmmoPickedUp( n, a )
end

--
--  No item pickup notifications
--
function GM:HUDItemPickedUp() 
end

--
--  No drawing pickup history
--
function GM:HUDDrawPickupHistory()
end

--
--  Initialize client side
--
function GM:InitPostEntity()
    hook.Run( 'InitializeBhopClient' )
end

--
--  Refresh client side
--
function GM:OnReloaded()
    hook.Run( 'InitializeBhopClient' )
end

-- 
--  Calls all client side creation hooks
--
function GM:InitializeBhopClient()
    hook.Run( 'CreateBhopHUD' )
end

--
--  Create the BHOP User interface.
--
function GM:CreateBhopHUD()
    BHOP.HUD = {}

    -- Remove HUD elements if they're alreay created
    if BHOP.HUD.CROSSHAIR then BHOP.HUD.CROSSHAIR:Remove() end
    if BHOP.HUD.TIMER then BHOP.HUD.TIMER:Remove() end
    if BHOP.HUD.KEYS then BHOP.HUD.KEYS:Remove() end

    -- Re-create all HUD elements
    BHOP.HUD.CROSSHAIR = vgui.Create( 'BhopCrosshair' )
    BHOP.HUD.TIMER     = vgui.Create( 'BhopTimer' )
    BHOP.HUD.KEYS      = vgui.Create( 'BhopKeys' )


    BHOP.HUD.TIMER:SetPlayer( LocalPlayer() )
    BHOP.HUD.KEYS:SetPlayer( LocalPlayer() )
end

--
--  Hide default hud elements 
--
hook.Add( 'HUDShouldDraw', 'BHOP.hideDefaultHUD', function( elem )
    if drawHUDElems[ elem ] != nil then return drawHUDElems[ elem ] end
end )

--
--  Concommand to reset the HUD 
--
concommand.Add( 'bhop_reset_hud', function()
    hook.Run( 'CreateBhopHUD' )
end )
