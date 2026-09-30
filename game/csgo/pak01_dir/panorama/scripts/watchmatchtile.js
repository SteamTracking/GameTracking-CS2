'use strict';

var watchMatchTile = ( function (){

	var _m_isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;

	function _Init ( elTile, oMatch, oTeam1, oTeam2 )
	{
		elTile.SetDialogVariable( 'match_versus_tooltip', $.Localize( '#eventsched_match_tooltip', elTile ) );

		function _CreateTeamPanelsInContainerPanel ( elTeamContainer, teamNum, oTeam )
		{
			var teamName = oMatch[ 'team' + teamNum + '_name' ];
			var teamLogo = oMatch[ 'team' + teamNum +  '_logo_url' ]

			var elTeamLogo = $.CreatePanel( "Image", elTeamContainer, 'id-wmt-logo-' + teamName, { 
				class: 'wmt__datum wmt__datum--teamlogo img-shadow',
				clampfractionalpixelpositions: 'false',
				src: teamLogo
			} );

			var elLabel = $.CreatePanel( "Label", elTeamContainer, 'id-wmt-label-' + oMatch[ 'team' + teamNum + '_name' ], { 
				class: 'wmt__datum wmt__datum--teamname stratum-font',
				text: '{s:watchmatchtile_teamname}'
			} );

			elLabel.SetDialogVariable( 'watchmatchtile_teamname', teamName );

			_CreateTeamTooltip( elTeamLogo, oTeam );
		}

		var elTeam1Container = elTile.FindChildTraverse( 'id-wmt-team1-container' );
		_CreateTeamPanelsInContainerPanel( elTeam1Container, 1, oTeam1 );

		var elTeam2Container = elTile.FindChildTraverse( 'id-wmt-team2-container' );
		_CreateTeamPanelsInContainerPanel( elTeam2Container, 2, oTeam2 );

		                                                                                                               
		var elVersusContainer = elTile.FindChildTraverse( 'id-wmt-vs-container' );
		$.CreatePanel( "Label", elVersusContainer, 'id-wmt-label-vs', { 
			class: 'wmt__datum wmt__datum--vs stratum-font',
			text: $.Localize( '#eventsched_versus' )
		} );

		
		          
		var elWatchButton = elTile.FindChildTraverse( "id-wmt" );
		if ( elWatchButton )
		{
			          
			if ( 'streams' in oMatch && oMatch[ 'streams' ].length > 0 )
			{
				var elStatus = elTile.FindChildTraverse( "id-wmt__status" );
				elStatus.AddClass( 'streams_available' );
			}
			{
				function OnActivate ( matchId )
				{
					var elContextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(
						'id - watchmatchtile - match__watch',
						'',
						'file://{resources}/layout/context_menus/context_menu_watchnotice_match_streams.xml',
						'match_id=' + matchId +
						'&' + 'is_official=' + elTile.Data().isofficial,
						function() {$.DispatchEvent( 'ContextMenuEvent', '' );}
					)
					elContextMenuPanel.AddClass( "ContextMenu_NoArrow" );
					elContextMenuPanel.AddClass( "ContextMenu_Centered" );

					$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
				}

				function OnSimplePerfectWorldContextMenu( )
				{
					var items = [];

					                  
					if ( EmbeddedStreamAPI.GetStreamExternalLinkTypes().indexOf( 'B' ) >= 0 )
					{
						items.push( { label: $.Localize( '#CSGO_Watch_Info_live' ), jsCallback: function() {
							EmbeddedStreamAPI.OpenStreamInExternalBrowser( 'XB' );
							$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
						} } );
					}
					
					       
					if ( EmbeddedStreamAPI.GetStreamExternalLinkTypes().indexOf( 'G' ) >= 0 )
					{
						items.push( { label: $.Localize( '#CSGO_Watch_Watch_GOTV' ), jsCallback: function() {
							EmbeddedStreamAPI.OpenStreamInExternalBrowser( 'XG' );
							$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
						} } );
					}

					                                                                    
					if ( items.length <= 0 )
					{
						items.push( { label: $.Localize( '#CSGO_Watch_Info_live' ), jsCallback: function() {
							                        
							$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
						} } );
					}
				
					UiToolkitAPI.ShowSimpleContextMenu( '', 'externallink', items );
				}

				if ( _m_isPerfectWorld )
				{
					elWatchButton.SetPanelEvent( 'onactivate', OnSimplePerfectWorldContextMenu );
				}
				else
				{
					elWatchButton.SetPanelEvent( 'onactivate', OnActivate.bind( undefined, oMatch[ 'match_id' ] ) );
				}
			}
		}
	}

	function _CreateTeamTooltip ( panel, oTeam )
	{
		
		               
		  
		  
			
		var xmlsrc = 'file://{resources}/layout/tooltips/tooltip_eventsched_team_simple.xml';
		
		var parms = "team_id=" + oTeam[ 'name' ] +
			"&team_name=" + oTeam[ 'name' ] +
			"&team_logo_url=" + oTeam[ 'logo_url_large' ];

		if ( "lineup" in oTeam )
		{
			var bHaveAnyPhoto = false;

			for ( var pIdx in oTeam[ 'lineup' ] )
			{
				var oPlayer = oTeam[ 'lineup' ][ pIdx ];

				if ( 'profile_photo_url' in oPlayer && oPlayer[ 'profile_photo_url' ] !== "" )
				{
					parms += "&player_photo" + pIdx + "=" + oPlayer[ 'profile_photo_url' ];
					bHaveAnyPhoto = true;
				}
				else
				{
					parms += "&player_photo" + pIdx + "=" + "file://{images}/icons/ui/pro_player.svg";
				}

				parms += "&player_name" + pIdx + "=" + oPlayer[ 'nickname' ];
				parms += "&player_url" + pIdx + "=" + oPlayer[ 'profile_url' ];
			}

			if ( bHaveAnyPhoto ) 
			{
				xmlsrc = 'file://{resources}/layout/context_menus/context_menu_eventsched_team.xml';
				panel.AddClass( 'eventsched__teams__teamlogo--plus' );

				function _OnTeamContextMenu ( xmlsrc, parms )
				{
					var elTeamContextPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters( '', '', xmlsrc, parms );
					elTeamContextPanel.AddClass( "ContextMenu_NoArrow" );
				}

				panel.SetPanelEvent( 'onactivate', _OnTeamContextMenu.bind( undefined, xmlsrc, parms ) );

				panel.AddClass( 'has_data' );
			}
		}

	}

		                               
	  
	function _OnMouseOverCustomLayoutTooltip ( _panel, _tooltipId, _xmlsrc, _parms )
	{
		UiToolkitAPI.ShowCustomLayoutParametersTooltip(
			_panel,
			_tooltipId,
			_xmlsrc,
			_parms );
	}

	function _OnMouseOutCustomLayoutTooltip ( _tooltipId )
	{
		UiToolkitAPI.HideCustomLayoutTooltip( _tooltipId );
	}


	return {
		Init			: 	_Init,		                                              
	};
})();

( function (){

})();


