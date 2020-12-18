
local cssWeapons = {
    'weapon_awp', 'weapon_deagle', 'weapon_scout', 'weapon_knife',
	'weapon_m3', 'weapon_m249', 'weapon_p90', 'weapon_fiveseven',
	'weapon_ak47', 'weapon_aug', 'weapon_c4', 'weapon_elite',
	'weapon_flashbang', 'weapon_famas', 'weapon_g3sg1', 'weapon_galil',
	'weapon_glock', 'weapon_hegrenade', 'weapon_m4a1', 'weapon_mac10',
	'weapon_mp5navy', 'weapon_p228', 'weapon_sg550', 'weapon_sg552',
    'weapon_smokegrenade', 'weapon_tmp', 'weapon_ump45', 'weapon_usp',
	'weapon_xm1014'
}

function GM:Initialize()
    RunConsoleCommand( 'sv_airaccelerate',  100 )
    RunConsoleCommand( 'sv_accelerate',     5 )
    RunConsoleCommand( 'sv_friction',       4 )
    RunConsoleCommand( 'sv_maxvelocity',    3500 )
    RunConsoleCommand( 'sv_turbophysics',   1 )
    RunConsoleCommand( 'sv_stopspeed',      75 )
	RunConsoleCommand( 'sv_gravity',        800 )
	RunConsoleCommand( 'sv_sticktoground',  0 )
	RunConsoleCommand( 'sv_kickerrornum',   0 )
	RunConsoleCommand( 'sv_alltalk',        1 )

    -- TODO: Config option to use own css weapons
    for k, wep in pairs( cssWeapons ) do
        weapons.Register( weapons.Get( 'bhop_glock' ), wep )
    end
end

function GM:PlayerCanPickupWeapon( ply, wep )
    -- if ply:HasWeapon( wep:GetClass() ) or ply:IsSpectating() then
    --     return false end

    return true
end

function GM:PlayerInitialSpawn( ply )
    player_manager.SetPlayerClass( ply, 'player_bhop_autostrafe' )
end

function GM:OnPlayerHitGround( ply, bWater, bFloat, speed )
    -- TODO: hook onto player class to count jumps
end

function GM:GetFallDamage() 
    return 0 
end

function GM:PlayerSwitchFlashlight() 
    return true 
end

function GM:PlayerShouldTakeDamage() 
    return false 
end

function GM:AllowPlayerPickup() 
    return false
end

function GM:PlayerDeathSound() 
    return true 
end

