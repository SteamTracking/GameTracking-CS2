function setupTooltip()
{
	var wins = $.GetContextPanel().GetAttributeString( "wins", "" );
	var losses = $.GetContextPanel().GetAttributeString( "losses", "" );
	var ties = $.GetContextPanel().GetAttributeString( "ties", "" );
	var rndwin = $.GetContextPanel().GetAttributeString( "rndwin", "" );
	var rndlost = $.GetContextPanel().GetAttributeString( "rndlost", "" );
	var score = $.GetContextPanel().GetAttributeString( "score", "" );
	var mapid = parseInt( $.GetContextPanel().GetAttributeString( "mapid", "" ) );

	$.GetContextPanel().SetDialogVariableInt( "wins", parseInt( wins ) );
	$.GetContextPanel().SetDialogVariableInt( "losses", parseInt( losses ) );
	$.GetContextPanel().SetDialogVariableInt( "ties", parseInt( ties ) );
	$.GetContextPanel().SetDialogVariableInt( "rndwin", parseInt( rndwin ) );
	$.GetContextPanel().SetDialogVariableInt( "rndlost", parseInt( rndlost ) );
	$.GetContextPanel().SetDialogVariable( "score", parseInt( score*100 ) );
	if ( $.GetContextPanel().GetAttributeString( "scoretype", "rounds" ) === "rounds" )
	{
		$('#ScoreLabel').SetLocString('#playerstats_map_tooltip_round_winrate');
		$('#RecordLabel').SetLocString('#playerstats_map_tooltip_rndwin_rndloss');
		$('#RecordResults').SetAlreadyLocalizedText( "{d:rndwin}:{d:rndlost}", true );
	}
	else
	{
		$('#ScoreLabel').SetLocString('#playerstats_map_tooltip_match_winrate');
		$('#RecordLabel').SetLocString('#playerstats_map_tooltip_win_loss_tie');
		$('#RecordResults').SetAlreadyLocalizedText( "{d:wins}/{d:losses}/{d:ties}", true );
	}

	var mapNameShort = DeepStatsAPI.MapIDToString( mapid );
	                                                                                          
	$.GetContextPanel().SetDialogVariable( "map_name", $.Localize("#SFUI_Map_" + mapNameShort) );
}