'use strict';

var EventschedTeamContextMenu = ( function()
{

	var team_id;
	var team_name;
	var team_logo_url;
	var team_url;
	var player_photo_url = [];
	var player_name = [];
	var player_url = [];

	function _Init ()
	{
		team_id = $.GetContextPanel().GetAttributeString( "team_id", "" );
		team_name = $.GetContextPanel().GetAttributeString( "team_name", "" );
		team_logo_url = $.GetContextPanel().GetAttributeString( "team_logo_url", "" );
		team_url = $.GetContextPanel().GetAttributeString( "team_url", "" );
		
		player_photo_url[ 0 ] = $.GetContextPanel().GetAttributeString( "player_photo0", "" );
		player_photo_url[ 1 ] = $.GetContextPanel().GetAttributeString( "player_photo1", "" );
		player_photo_url[ 2 ] = $.GetContextPanel().GetAttributeString( "player_photo2", "" );
		player_photo_url[ 3 ] = $.GetContextPanel().GetAttributeString( "player_photo3", "" );
		player_photo_url[ 4 ] = $.GetContextPanel().GetAttributeString( "player_photo4", "" );

		player_name[ 0 ] = $.GetContextPanel().GetAttributeString( "player_name0", "" );
		player_name[ 1 ] = $.GetContextPanel().GetAttributeString( "player_name1", "" );
		player_name[ 2 ] = $.GetContextPanel().GetAttributeString( "player_name2", "" );
		player_name[ 3 ] = $.GetContextPanel().GetAttributeString( "player_name3", "" );
		player_name[ 4 ] = $.GetContextPanel().GetAttributeString( "player_name4", "" );

		player_url[ 0 ] = $.GetContextPanel().GetAttributeString( "player_url0", "" );
		player_url[ 1 ] = $.GetContextPanel().GetAttributeString( "player_url1", "" );
		player_url[ 2 ] = $.GetContextPanel().GetAttributeString( "player_url2", "" );
		player_url[ 3 ] = $.GetContextPanel().GetAttributeString( "player_url3", "" );
		player_url[ 4 ] = $.GetContextPanel().GetAttributeString( "player_url4", "" );

		            
		$.GetContextPanel().SetDialogVariable( 'eventsched-tt-teamname', team_name );
		
		            
		var elTeamLogo = $.GetContextPanel().FindChildTraverse( 'id-estt-header__team-logo' );
		if ( elTeamLogo )
		{
			elTeamLogo.SetImage( team_logo_url );
		}

		var elTeamLogoBlurBG = $.GetContextPanel().FindChildTraverse( 'id-estt-blur' );
		if ( elTeamLogoBlurBG )
		{
			elTeamLogoBlurBG.SetImage( team_logo_url );
		}

		var elTeamHeader = $.GetContextPanel().FindChildTraverse( 'id-estt-header' );
		if ( elTeamHeader && team_url !== "" )
		{
			elTeamHeader.AddClass( 'has_data' );

			var onActivate = function ( url )
			{
				SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser( url ); 
				
				$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
			}

			elTeamHeader.SetPanelEvent( 'onactivate', onActivate.bind( undefined, team_url ) );

		}
		
		_Populate();
	}

	function _Populate ()
	{
		          

		var elPlayerContainer = $.GetContextPanel().FindChildTraverse( 'id-estt-lineup-container' );

		elPlayerContainer.RemoveAndDeleteChildren();

		for ( var idx = 0; idx < 5; idx++ )
		{
			var elPlayer = $.CreatePanel( 'Panel', elPlayerContainer, player_photo_url[ idx ] );
			elPlayer.BLoadLayoutSnippet( 'snippet-estt-player' );

			var playerName = player_name[ idx ] !== "" ? player_name[ idx ] : "?"; 
			              
			elPlayer.SetDialogVariable( 'esttplayer-name', playerName );

			              
			var elPlayerImage = elPlayer.FindChildTraverse( 'id-estt-player__photo' );
			if ( elPlayerImage )
			{
				elPlayerImage.SetImage( player_photo_url[ idx ] );
			}

			if ( player_url[ idx ] !== "" )
			{
				elPlayer.AddClass( 'has_data' );

				var onActivate = function ( url )
				{
					SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser( url ); 
					
					$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
				}

				elPlayer.SetPanelEvent( 'onactivate', onActivate.bind( undefined, player_url[ idx ] ) );
			}
		}
	}

	return {
		Init: _Init,
	}


})();

(function()
{

})();