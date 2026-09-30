
"use strict"; 

var MatchLister = ( function ()
{
	function _Init( elPanel ) 
	{
		$.RegisterEventHandler( 'ScrolledIntoView', elPanel.FindChildTraverse( 'MatchContainer' ), _OnScrollIntoView );
		$.RegisterEventHandler( 'ScrolledOutOfView', elPanel.FindChildTraverse( 'MatchContainer' ), _OnScrollOutOfView );

		$.Msg( 'matchlister init ', elPanel.id );

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
		// if ( elPanelId == _m_mostRecentMatchDay )
		// 	_ToggleGoToMostRecentButton( false );
	}

	function _OnScrollOutOfView ( elPanelId )
	{
		// if ( elPanelId == _m_mostRecentMatchDay )
		// 	_ToggleGoToMostRecentButton( true );
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

				// Scroll to the desired date
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
		
		$.Msg( 'Matchlister.Update', " ", $.GetContextPanel().id );

		Scheduler.Cancel( 'MATCHES' );	

		var elLister = elPanel.FindChildTraverse( 'MatchContainer' );

		// clear the lister if the range is shorter
		if ( !elPanel.m_nDays || ( nDays < elPanel.m_nDays && nDays != -1 ) || elPanel.m_nDays == -1 || ( nMode != elPanel.m_nMode ))
		{
			// we have some data, so clear the lister. Otherwise leave the dummy matches alone
			if ( !elPanel.m_hasDummyMatches )
				elLister.RemoveAndDeleteChildren();
			
			elPanel.SetHasClass( 'no-data', true );

		}

		elPanel.m_nMode = nMode;
		elPanel.m_nDays = nDays;

		var oDeepStats = DeepStatsAPI.GetDataForRangeJS( nDays , nMode);
		var arrMatches = oDeepStats.matches;

		elPanel.SetHasClass( 'stats-loading', oDeepStats.status != 'complete' );

		// we have no matches but we're not done checking. keep asking.
		if ( ( !arrMatches || arrMatches.length == 0 ) && oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 1.0, _Populate.bind( this, elPanel, nDays, nMode, sortStat ), 'MATCHES' );
			return;
		}

		// we have no matches and we're done checking. populate with blanks
		if ( !arrMatches || arrMatches.length == 0 && oDeepStats.status == 'complete' )
		{
			if ( !elPanel.m_hasDummyMatches )
			{
				_PopulateDummy( elPanel );
			}
			
			return;
		}

		// only clear the panels if they're dummy matches
		if ( elPanel.m_hasDummyMatches )
		{
			elLister.RemoveAndDeleteChildren();
			elPanel.m_hasDummyMatches = false;
		}

		arrMatches = arrMatches.sort( _SortTimeDescending_f );

		elPanel.SetHasClass( 'no-data', false );

		// create the match panels

		$.Msg( "------------MATCHLISTER: days: ", nDays, " num matches: ", arrMatches.length );

		arrMatches.forEach( function( oMatch, index )
		{
			var timestamp = DeepStatsAPI.MatchIDToLocalTime( oMatch.match_id );

			// skip matches we already have
			if ( elLister.FindChildTraverse( oMatch.match_id ))
				return;

			var matchDate = new Date( timestamp * 1000 );

			var dateKey = _GetDateKeyFromTimestamp( timestamp );

			// put the match in the panel for the day of the match
			// or, if it doesn't exist it, create it and sort it into the day panels
			var elDayContainer = elLister.FindChildTraverse( dateKey );
			if ( !elDayContainer )
			{
				elDayContainer = $.CreatePanel( "Panel", elLister, dateKey );
				elDayContainer.AddClass( 'matchlister__day-container' );

				var elDayTitle = $.CreatePanel( "Panel", elDayContainer, 'title-' + dateKey );
				elDayTitle.BLoadLayoutSnippet( 'snippet-separator' );

				DateUtil.PopulateDateFormatStrings( elDayTitle, matchDate );

				// SORT THE DAY INTO PLACE
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

	//		$.Msg( DateUtil.UUU_dd( matchDate ), " ", numMatchesForTheDay );

			// Create the match panel
			var elMatch = $.CreatePanel( "Button", elDayContainer, oMatch.match_id );
			elMatch.BLoadLayoutSnippet( 'snippet-match' );

			// sort the match into place in descending order
			{
				var arrChildren = elDayContainer.Children();
				var numChildren = arrChildren.length;

				// js comparison tests
				// var num = parseInt( elMatch.id );
				// var a = "aa";
				// var b = "b";
				// var sum = a < b;
				// a = "c";
				// sum = a < b;

				var idx = 1; // SKIP THE DAY TITLE
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

			// match details page
			var elMatchDetails = elMatch.FindChildTraverse( 'Details' );
			elMatchDetails.SetPanelEvent( 'onactivate', onActivate_f.bind( this, oMatch.match_id ) );

			// TOOLTIP /////////////////////////
			//////////////////////////////////////
			var parms = "class=" + 'mode' + nMode + "&matchdata=" + JSON.stringify( oMatch );
			var xmlsrc = 'file://{resources}/layout/tooltips/stats/tooltip_playerstats_matchlister_matchstats.xml';

			// FOR DEBUGGING TIME
			// var xmlsrc = 'file://{resources}/layout/tooltips/stats/tooltip_playerstats_generic.xml';
			// var time = new Date();
			// time.setTime( DeepStatsAPI.MatchIDToLocalTime( oMatch.match_id ) * 1000 );
			// var parms = "&text=" + time;

			
			var ttid = 'tt_' + elMatch.id;
			var onDayHoverOn_f = _OnMouseOverCustomLayoutTooltip.bind( undefined, elMatch.id, ttid, xmlsrc, parms );
			var onDayHoverOff_f = _OnMouseOutCustomLayoutTooltip.bind( undefined, ttid );

			elMatch.SetPanelEvent( 'onmouseover', onDayHoverOn_f );
			elMatch.SetPanelEvent( 'onmouseout', onDayHoverOff_f );
			//////////////////////////////// END TOOLTIP

		} );

		// // Scroll to the desired date
		// var elDay = elPanel.FindChildTraverse(  );
		// if ( elDay )
		// {
		// 	elDay.ScrollParentToMakePanelFit( 1, false );
		// 	if ( bHighlight )
		// 		elDay.TriggerClass( 'highlight' );
		// }

		if ( oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 1.0, _Populate.bind( this, elPanel, nDays, nMode, sortStat ), 'MATCHES' );
			return;
		}
		else
		{
			$.Msg( "------------MATCHLISTER: COMPLETE. days: ", nDays, " num matches: ", arrMatches.length );

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

//--------------------------------------------------------------------------------------------------
// Entry point called when panel is created
//--------------------------------------------------------------------------------------------------
(function()
{
})();
