
"use strict"; 

var MatchLister = ( function ()
{
	function _Init( elPanel ) 
	{
		$.RegisterEventHandler( 'ScrolledIntoView', elPanel.FindChildTraverse( 'MatchContainer' ), _OnScrollIntoView );
		$.RegisterEventHandler( 'ScrolledOutOfView', elPanel.FindChildTraverse( 'MatchContainer' ), _OnScrollOutOfView );

		                                         

		elPanel.AddClass( 'no-data' );
		elPanel.AddClass( 'stats-loading' );
		_PopulateDummy( elPanel );
	}

	function _GetDateKeyFromTimestamp ( timestamp )
	{
		var time = new Date(timestamp*1000 );

		var d = FormatText.PadNumber( time.getDate(), 2 );
		var m = FormatText.PadNumber( time.getMonth(), 2 );
		var y = FormatText.PadNumber( time.getFullYear(), 4 );

		return ( String(y) +String(m) + String(d) );
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

	function _OnScrollIntoView ( elPanelId )
	{
		                                            
		   	                                     
	}

	function _OnScrollOutOfView ( elPanelId )
	{
		                                            
		   	                                    
	}

	function _SortTimeDescending_f ( a, b )
	{
		return ( a.match_id - b.match_id );
	}

	
	function _Highlight ( elPanel, strDateKey )
	{
		if ( !elPanel )
		return;
	
		var elLister = elPanel.FindChildTraverse( 'MatchContainer' );

				                             
		var elDay = elLister.FindChildTraverse( strDateKey );
		if ( elDay )
		{
			elDay.ScrollParentToMakePanelFit( 1, false );
			elDay.TriggerClass( 'highlight' );
		}
	}

	function _PopulateDummy ( elPanel )
	{
		if ( !elPanel )
			return;
		
		var elLister = elPanel.FindChildTraverse( 'MatchContainer' );
		
		const NUM_DUMMY = 12;

		for ( var i = 0; i < NUM_DUMMY; i++ )
		{
			_CreateDummyMatchPanel( elLister );
		}

		elPanel.m_hasDummyMatches = true;

	}


	function _CreateDummyMatchPanel ( elParent )
	{
		var elMatch = $.CreatePanel( "Button", elParent, '' );
		elMatch.BLoadLayoutSnippet( 'snippet-match' );

		elMatch.SetDialogVariable( 'map', '' );
		elMatch.SetDialogVariable( 'myscore', '' );
		elMatch.SetDialogVariable( 'enemyscore', '' );

		var elMapLogo = elMatch.FindChildTraverse( 'MapLogo' );
		if ( elMapLogo )
			elMapLogo.SetImage( "file://{images}/map_icons/map_icon_NONE.png" );
		
		elMatch.enabled = false;
	}


	function _Populate ( elPanel, nDays, nMode, sortStat )
	{
		if ( !elPanel || !elPanel.IsValid() )
			return;
		
		                                                           

		Scheduler.Cancel( 'MATCHES' );	

		var elLister = elPanel.FindChildTraverse( 'MatchContainer' );

		                                           
		if ( !elPanel.m_nDays || ( nDays < elPanel.m_nDays && nDays != -1 ) || elPanel.m_nDays == -1 || ( nMode != elPanel.m_nMode ))
		{
			                                                                                  
			if ( !elPanel.m_hasDummyMatches )
				elLister.RemoveAndDeleteChildren();
			
			elPanel.SetHasClass( 'no-data', true );

		}

		elPanel.m_nMode = nMode;
		elPanel.m_nDays = nDays;

		var oDeepStats = DeepStatsAPI.GetDataForRangeJS( nDays , nMode);
		var arrMatches = oDeepStats.matches;

		elPanel.SetHasClass( 'stats-loading', oDeepStats.status != 'complete' );

		                                                               
		if ( ( !arrMatches || arrMatches.length == 0 ) && oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 1.0, _Populate.bind( this, elPanel, nDays, nMode, sortStat ), 'MATCHES' );
			return;
		}

		                                                                   
		if ( !arrMatches || arrMatches.length == 0 && oDeepStats.status == 'complete' )
		{
			if ( !elPanel.m_hasDummyMatches )
			{
				_PopulateDummy( elPanel );
			}
			
			return;
		}

		                                                 
		if ( elPanel.m_hasDummyMatches )
		{
			elLister.RemoveAndDeleteChildren();
			elPanel.m_hasDummyMatches = false;
		}

		arrMatches = arrMatches.sort( _SortTimeDescending_f );

		elPanel.SetHasClass( 'no-data', false );

		                          

		                                                                                       

		arrMatches.forEach( function( oMatch, index )
		{
			var timestamp = DeepStatsAPI.MatchIDToLocalTime( oMatch.match_id );

			                               
			if ( elLister.FindChildTraverse( oMatch.match_id ))
				return;

			var matchDate = new Date( timestamp * 1000 );

			var dateKey = _GetDateKeyFromTimestamp( timestamp );

			                                                      
			                                                                        
			var elDayContainer = elLister.FindChildTraverse( dateKey );
			if ( !elDayContainer )
			{
				elDayContainer = $.CreatePanel( "Panel", elLister, dateKey );
				elDayContainer.AddClass( 'matchlister__day-container' );

				var elDayTitle = $.CreatePanel( "Panel", elDayContainer, 'title-' + dateKey );
				elDayTitle.BLoadLayoutSnippet( 'snippet-separator' );

				DateUtil.PopulateDateFormatStrings( elDayTitle, matchDate );

				                          
				var arrChildren = elLister.Children();
				var numChildren = arrChildren.length;
				var idx = 0;

				if ( elDayContainer.id > arrChildren[ numChildren - 1 ].id)
				{
					elLister.MoveChildAfter( elDayContainer, arrChildren[ numChildren - 1 ] );
				}
				else
				{
					while ( idx < numChildren && arrChildren[ idx ] && elDayContainer.id < arrChildren[ idx ].id )
						idx++;

					elLister.MoveChildBefore( elDayContainer, arrChildren[ idx ] );
				}
			}

	  		                                                                

			                         
			var elMatch = $.CreatePanel( "Button", elDayContainer, oMatch.match_id );
			elMatch.BLoadLayoutSnippet( 'snippet-match' );

			                                                
			{
				var arrChildren = elDayContainer.Children();
				var numChildren = arrChildren.length;

				                      
				                                    
				                
				               
				                   
				           
				               

				var idx = 1;                      
				while ( idx < numChildren && arrChildren[ idx ] && elMatch.id < arrChildren[ idx ].id )
					idx++;

				elDayContainer.MoveChildBefore( elMatch, arrChildren[ idx ] );
			}

			var mapid = oMatch[ 'mapid' ];

			var myScore = Number( oMatch[ 'rounds_won' ] ? oMatch[ 'rounds_won' ] : 0 );
			var enemyScore = Number( oMatch[ 'rounds_lost' ] ? oMatch[ 'rounds_lost' ] : 0 );

			var mapName = $.Localize( '#SFUI_Map_' + DeepStatsAPI.MapIDToString( mapid ) );
			elMatch.SetDialogVariable( 'map', mapName );
			elMatch.SetDialogVariable( 'myscore', myScore );
			elMatch.SetDialogVariable( 'enemyscore', enemyScore );

			var elMapLogo = elMatch.FindChildTraverse( 'MapLogo' );
			if ( elMapLogo )
			{
				var strMap = DeepStatsAPI.MapIDToString( mapid );
				elMapLogo.SetImage( "file://{images}/map_icons/map_icon_" + strMap + ".svg" );
				IconUtil.SetupFallbackMapIcon( elMapLogo, 'file://{images}/map_icons/map_icon_NONE.png' );
			}

			var elMatchDot = elMatch.FindChildTraverse( 'MatchDot' );

			elMatchDot.SetHasClass( 'match--win', ( oMatch.match_outcome & 0x3 ) == 1 );
			elMatchDot.SetHasClass( 'match--loss', ( oMatch.match_outcome & 0x3 ) == 2 );
			elMatchDot.SetHasClass( 'match--tie', ( oMatch.match_outcome & 0x3 ) == 0 );

			elMatch.SetHasClass( 'match--dnf', ( oMatch.match_outcome & 0x4 ) );

			_AddTeammates( elMatch, oMatch );

			var onActivate_f = function( matchid )
			{
				UiToolkitAPI.ShowCustomLayoutPopupParametersWithStyle(
					'PlayerStats_SingleMatch',
					'file://{resources}/layout/popups/stats/popup_playerstats_singlematch.xml',
					'matchid=' + matchid,
					'blur_dismiss' );
			}

			                     
			var elMatchDetails = elMatch.FindChildTraverse( 'Details' );
			elMatchDetails.SetPanelEvent( 'onactivate', onActivate_f.bind( this, oMatch.match_id ) );

			                                    
			                                      
			var parms = "class=" + 'mode' + nMode + "&matchdata=" + JSON.stringify( oMatch );
			var xmlsrc = 'file://{resources}/layout/tooltips/stats/tooltip_playerstats_matchlister_matchstats.xml';

			                     
			                                                                                           
			                         
			                                                                             
			                               

			
			var ttid = 'tt_' + elMatch.id;
			var onDayHoverOn_f = _OnMouseOverCustomLayoutTooltip.bind( undefined, elMatch.id, ttid, xmlsrc, parms );
			var onDayHoverOff_f = _OnMouseOutCustomLayoutTooltip.bind( undefined, ttid );

			elMatch.SetPanelEvent( 'onmouseover', onDayHoverOn_f );
			elMatch.SetPanelEvent( 'onmouseout', onDayHoverOff_f );
			                                            

		} );

		                                
		                                             
		               
		    
		   	                                             
		   	                 
		   		                                  
		    

		if ( oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 1.0, _Populate.bind( this, elPanel, nDays, nMode, sortStat ), 'MATCHES' );
			return;
		}
		else
		{
			                                                                                                 

			}
	}

	function _AddTeammates ( elMatch, oMatch )
	{
		var elMates = elMatch.FindChildTraverse( 'Mates' );

		Object.values( oMatch.mates ).forEach( function( accountId, index )
		{
			var xuid = DeepStatsAPI.GetXUIDByAccountID( accountId );

			var elAvatar = $.CreatePanel( 'CSGOAvatarImage', elMates, index );
			elAvatar.PopulateFromSteamID(xuid);
			elAvatar.AddClass( 'avatar-image__icon' );
			
			elAvatar.SetPanelEvent( 'onactivate', function( xuid )
			{

				UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(
					'',
					'',
					'file://{resources}/layout/context_menus/context_menu_playercard.xml',
					'xuid=' + xuid,
					function() {}
				)

			}.bind( this, xuid ) );
		} );

	}


	function _OnDismissSingleMatch ()
	{
	}

	return {
		Init: 					_Init,
		Populate: 				_Populate,
		Highlight:				_Highlight
	 };
})();

                                                                                                    
                                           
                                                                                                    
(function()
{
})();
