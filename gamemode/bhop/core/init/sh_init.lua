
function GM:CreateTeams()
    team.SetUp( BHOP.ENUMS.TEAM_BHOP, 'Bunny Hopper', Color( 25, 181, 254 ) )
	team.SetSpawnPoint( BHOP.ENUMS.TEAM_BHOP, {
		'info_player_start',
		'info_player_rebel',
		'info_player_combine',
		'info_player_deathmatch',
		'info_player_terrorist',
		'info_player_counterterrorist'
	} )
end