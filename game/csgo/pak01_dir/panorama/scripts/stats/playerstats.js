'use strict';




var playerstats = ( function()
{
	const GRAPH_JOBS = 'graph_jobs';

	var _m_visible;
	var _m_timedOutWhileAway;

	var _m_elSingleMatch; // our match details panel

	var _m_LineGraph = $.GetContextPanel().FindChildTraverse( 'id-playerstats__linegraph' );
	var _m_MapGraph = $.GetContextPanel().FindChildTraverse( 'id-playerstats__web-maps' );
	var _m_WeaponGraph = $.GetContextPanel().FindChildTraverse( 'id-playerstats__web-weapons' );
	var _m_Heatmap = $.GetContextPanel().FindChildTraverse( 'id-playerstats__heatmap' );

	var _m_elMatchHistory = $.GetContextPanel().FindChildTraverse( 'PlayerStatsMatchHistory' );

	var _m_arrLinegraphStats = [
		"score",
		"kills",
		"health_removed",
		"kd",
		"hsp",
		"2k",
		"3k",
		"4k",
		"grenade_success",
		"flash_success",
		"1v1",
		"1v2",
		"entrykd",
		"rounds_played",
		"deaths",
		"1v1_attempts",
		"1v2_attempts",
		"entry_attempts",
		"flash_attempts",
		"grenade_attempts",
	];

	var oStatAvgSuffix = {
		"score":				"",
		"kills":				"",
		"health_removed":		"",
		"kd":					"",
		"hsp":					"#playerstats_suffix_per_cent",
		"2k":					"",
		"3k":					"",
		"4k":					"",
		"grenade_success":		"#playerstats_suffix_per_cent",
		"flash_success":		"#playerstats_suffix_per_cent",
		"1v1":					"#playerstats_suffix_per_cent",
		"1v2":					"#playerstats_suffix_per_cent",
		"entrykd":				"",
		"wins":					"",
		"losses":				"",
		"ties":					"",
		"rounds_played":		"",
		"deaths":				"",
		"1v1_attempts":			"",
		"1v2_attempts":			"",
		"entry_attempts":		"",
		"flash_attempts":		"",
		"grenade_attempts":		"",
	}

	var strStatTotalPrefix = "stat_total_";
	var strStatAveragePrefix = "stat_average_";
	var _m_InventoryUpdatedHandler = null;
	var _m_SubscriptionStatusChangeUpdatedHandler = null;
	
	var _m_mode = _InitializeModeFilterFromSettings(); // runs the bulk of settings plumbing into the controls
	var _m_days = _InitializeTimeRangeFilter(); // runs after _InitializeModeFilterFromSettings

	// _m_arrLinegraphStats.forEach( stat =>
	// {
	// 	$.Msg( '"' + strStatTotalPrefix + stat + '"' + '\t\t' + '"' + strStatTotalPrefix + stat + '"');
	// 	$.Msg( '"' + strStatAveragePrefix + stat + '"' + '\t\t' + '"' + strStatAveragePrefix + stat + '"');
	// } );

	function _InitializeTimeRangeFilter()
	{
		var ival = parseInt( $.GetContextPanel().FindChildTraverse( 'id-playerstats__range' ).GetSelected().GetAttributeString( "value", "" ));
		$.Msg( 'Time range filter initialized as ' + ival );

		var nDays = parseInt( ival );
		_m_MapGraph.timerangeindays = nDays;
		_m_LineGraph.timerangeindays = nDays;
		_m_WeaponGraph.timerangeindays = nDays;
		_m_Heatmap.timerangeindays = nDays;

		return ival;
	}

	function _InitializeModeFilterFromSettings()
	{
		var elDropdown = $.GetContextPanel().FindChildTraverse('id-playerstats__mode');
		var val = GameInterfaceAPI.GetSettingString( 'ui_deepstats_toplevel_mode' );
		var valID = null;

		// Determine the setting based on the last match played
		var lastMatch = DeepStatsAPI.GetLastCachedMatchJS();
		if ( lastMatch && lastMatch.matches.length > 0 )
		{
			var oMatch = lastMatch.matches[ 0 ].player;
			var mode = DeepStatsAPI.GetMatchTypeString( oMatch.mm_game_mode );
			switch ( mode )
			{
				default:
					$.Msg( 'Last match mode "' + mode + '" failed to auto-detect, ERROR!' );

				case "Competitive":
				case "CompetitiveCaptains":
				case "CompetitiveScrimmage":
					$.Msg( 'Last match mode "' + mode + '" auto-determined as competitive' );
					val = 240;
					valID = "mode_id_11";
					break;
				
				case "Wingman":
					$.Msg( 'Last match mode "' + mode + '" auto-determined as wingman' );
					val = 12288;
					valID = "mode_id_16";
					break;
			}

			// See if we should adjust the filter from 14 days to a longer period
			var timestamp = DeepStatsAPI.MatchIDToLocalTime( oMatch.match_id );
			$.Msg( 'Last match ID = ' + oMatch.match_id + ' -> local time = ' + timestamp );
			// 1606723200 -> <<31 = 3450411798862233600 + random = 3450411799665595200
			timestamp += 1606723200 - DeepStatsAPI.MatchIDToLocalTime( "3450411799665595200" );
			// see if this was 14 days ago?
			var ndaysago = NewsAPI.GetNumSecondsTillGcTimestamp( timestamp );
			if ( ndaysago && ( ndaysago < 0 ) )
			{
				ndaysago = Math.floor( ( -ndaysago ) / ( 24*3600 ) );
				var nSelectID;
				if ( ndaysago < 14 ) {}
				else if ( ndaysago < 30 ) { nSelectID = "30d"; }
				else if ( ndaysago < 90 ) { nSelectID = "90d"; }
				else { nSelectID = "alltime"; }
				if ( nSelectID )
				{
					$.Msg( 'Last match timestamp "' + timestamp + '" auto-determined range as ' + nSelectID );
					$.GetContextPanel().FindChildTraverse( 'id-playerstats__range' ).SetSelected( nSelectID );
				}
			}
		}

		elDropdown.AccessDropDownMenu().Children().forEach( function( ch )
		{
			if ( val === ch.GetAttributeString( "value", "" ) )
			{
				valID = ch.id;
			}
		} );
		if ( valID )
		{
			$.Msg( 'playerstats.js : _InitializeModeFilterFromSettings setting = ' + val + ', id = ' + valID );
			elDropdown.SetSelected( valID );
		}
		else
		{
			elDropdown.SetSelectedIndex( 0 );
			val = elDropdown.GetSelected().GetAttributeString( "value", "" );
			$.Msg( 'playerstats.js : _InitializeModeFilterFromSettings default write setting = ' + val );
			GameInterfaceAPI.SetSettingString( 'ui_deepstats_toplevel_mode', val );
		}
		
		_m_mode = val;
		$.GetContextPanel().AddClass( 'mode' + _m_mode );
		_SetModeToEmbeddedControls();
		elDropdown.SetPanelEvent( 'oninputsubmit', _OnModeChanged.bind( undefined ) );
		return val;
	}

	function _SetModeToEmbeddedControls()
	{
		var nMode = parseInt( _m_mode );
		_m_LineGraph.gamemode = nMode;
		_m_MapGraph.gamemode = nMode;
		_m_WeaponGraph.gamemode = nMode;
		_m_Heatmap.gamemode = nMode;
	}

	function _GetModeFilter ()
	{
		return $.GetContextPanel().FindChildTraverse('id-playerstats__mode').GetSelected().GetAttributeString( "value", "" );
	}

	function _GetDataForRange ( nDays, nMode )
	{
		return DeepStatsAPI.GetDataForRangeJS( nDays, nMode );
	}

	function _OnStatsReceived () 
	{
		$.Msg( '_OnStatsReceived' );
		/*
			Deep Stats Chunk format:
			account_id: local user account id
			range: DeepStatsRange (see below)
			matches: array of DeepStatsMatch objects (see below)
			DeepStatsRange:
			begin: begin timestamp of this chunk in gctime
			end: end timestamp in gc time
			frozen: true if this chunk will not be updated and we can ingore in future stats received calls

			DeepStatsMatch format:
			player: DeepPlayerStatsEntry object (see below)
			events: DeepPlayerMatchEvent object (see below)

			DeepPlayerStatsEntry format:
			accountid: AccountID
			match_id: UniqueMatchID
			mm_game_mode: game mode of the match this progress happened in. Number is a EMsgGCCStrike15_v2_MatchmakingGame_t enum
							k_EMsgGCCStrike15_v2_MatchmakingGame_ArmsRace			= 4,
							k_EMsgGCCStrike15_v2_MatchmakingGame_Demolition			= 5,
							k_EMsgGCCStrike15_v2_MatchmakingGame_Deathmatch			= 6,
							k_EMsgGCCStrike15_v2_MatchmakingGame_ClassicCasual		= 7,
							k_EMsgGCCStrike15_v2_MatchmakingGame_ClassicCompetitive	= 8, // Used since October 2012
							k_EMsgGCCStrike15_v2_MatchmakingGame_Cooperative		= 9,
							k_EMsgGCCStrike15_v2_MatchmakingGame_ScrimComp2v2		= 10, // Used since April 2017
							k_EMsgGCCStrike15_v2_MatchmakingGame_ScrimComp5v5		= 11, // Used since April 2017
							k_EMsgGCCStrike15_v2_MatchmakingGame_Skirmish			= 12, // Used since April 2017
							k_EMsgGCCStrike15_v2_MatchmakingGame_Survival			= 13, // Used since Nov 2017
			mapid: // map id of the match
			b_starting_ct: whether user is starting CT this match
			match_outcome: 
					& 0x3 for outcome (0 = tie, 1 = MY team WIN, 2 = other team win, so my team LOST)
					& 0x4 for Did Not Finish ( player left early due to abandon or kick)
			rounds_won: number of round wins
			rounds_lost: number of round losses
			stat_score: total score points earned
			stat_deaths: Deaths	... add up all the kills/assists/deaths, then divide ...
			stat_mvps: MVPs		... the totals and you'll get AVG kills per round)
			enemy_kills: EnemyKills
			enemy_headshots: EnemyKillHeadshots (EnemyKillHeadshots divided by EnemyKills = HSP%, regular StatKills get reduced from TKs...)
			enemy_2ks: Enemy2Ks
			enemy_3ks: Enemy3Ks
			enemy_4ks: Enemy4Ks
			total_damage: Total Damage
			engagements_entry_count: Engagements count for entry frags
			engagements_entry_wins: Engagements won for entry frags
			engagements_1v1_count: Engagements count for 1v1
			engagements_1v1_wins: Engagements won for 1v1
			engagements_1v2_count: Engagements count for 1v2
			engagements_1v2_wins: Engagements won for 1v2
			utility_count: Number of Utility Nades Thrown
			utility_success: Number of utilities that resulted in enemy damage
			utility_enemies: Number of enemies damaged with utilities thrown
			flash_count: Number of Flashes Thrown
			flash_success: Number of flashes that resulted in enemy being blinded
			flash_enemies: Number of flashed enemies with flashes thrown
			mates: Teammates of the player

			DeepPlayerMatchEvent format:
			We dont need this in JS afaik, check the proto if you really need to know.
		*/
	}

	function _InitMatchDetailsPanel ()
	{
		// move match panel up in the heirarchy for blur
		if ( !_m_elSingleMatch )
		{
			_m_elSingleMatch = $.GetContextPanel().FindChildTraverse( 'PlayerStats_SingleMatch' );
			if ( _m_elSingleMatch )
			{
				// Create a panel outside mainmenucore so we can blur the stats page
				var elMainMenuInput = $.GetContextPanel();
				while ( elMainMenuInput ) 
				{
					elMainMenuInput = elMainMenuInput.GetParent();
					if ( elMainMenuInput.id === 'MainMenuInput' )
						break;
				}

				if ( elMainMenuInput )
				{
					// var elSingleMatchPanel = $.CreatePanel( 'Panel', elMainMenuInput, 'PlayerStats_SingleMatch' );
					// 	elSingleMatchPanel.BLoadLayoutSnippet( "snippet_playerstats_single_match" );

					_m_elSingleMatch.SetParent( elMainMenuInput );
				}
			}
		}
	}

	function _InitMatchLister ( panel )
	{
		$.Msg( '_InitMatchLister' );
		MatchLister.Init( panel );
	}

	function _InitAnims()
	{
		// animate the panels in the first time
		var arrPanelsToAnimateIn = $.GetContextPanel().FindChildrenWithClassTraverse('rotatein');
		arrPanelsToAnimateIn.sort(function (a, b) {

			var score_a = parseInt(a.GetAttributeString('introorder', 0));
			var score_b = parseInt(b.GetAttributeString('introorder', 0));

			return score_a - score_b;
		})

		const delay = 0.1;
		const init = 0.2;

		arrPanelsToAnimateIn.forEach(function (panel, idx) {
			Scheduler.Schedule(init + (delay * idx), () =>
			{
				if ( panel && panel.IsValid() )
					panel.RemoveClass('rotatein');
			});
		});
    }

	function _Init ()
	{
		_InitMatchDetailsPanel();

		// _ResetMatchHistory();
		// _UpdateMatchHistory();

		_ResetYourRecord();
		//		_UpdateYourRecord();

		_ResetLinegraph();
		//		_UpdateGraphStatButtons();

		_InitMatchLister( _m_elMatchHistory );
		MatchLister.Populate( _m_elMatchHistory, _m_days, _m_mode, '' );

		if ( !_m_InventoryUpdatedHandler )
		{
			_m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _UpdateSubscriptionStatus );
		}
		if ( !_m_SubscriptionStatusChangeUpdatedHandler )
		{
			_m_SubscriptionStatusChangeUpdatedHandler = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_RecurringSubscriptionStatusChange', _UpdateSubscriptionStatus );
		}

		$.RegisterForUnhandledEvent( 'DeepStatsReceived', _OnStatsReceived );
		$.RegisterForUnhandledEvent( 'StatsProgressGraph_OnGraphUpdated', _UpdateLineGraph );
		$.RegisterEventHandler( 'ReadyForDisplay', $.GetContextPanel(), _OnReadyForDisplay );
		$.RegisterEventHandler( 'UnreadyForDisplay', $.GetContextPanel(), _OnUnreadyForDisplay );
		$.RegisterForUnhandledEvent( 'DeepStatsTimeoutGiveUp', _OnDeepStatsTimeOut );

		// we listen to different little panels for changes in their stats because they are reflected in our big panel
		$.RegisterEventHandler( 'DeepStatsPanel_OnStatDownloadProgress', _m_LineGraph, function() {$.Schedule( 0.01, _OnStatDownloadProgress_LineGraph )} );
		$.RegisterEventHandler( 'DeepStatsPanel_OnStatDownloadProgress', _m_MapGraph, function() {$.Schedule( 0.01, _OnStatDownloadProgress_MapGraph )} );
		$.RegisterEventHandler( 'DeepStatsPanel_OnStatDownloadProgress', _m_WeaponGraph, function() {$.Schedule( 0.01, _OnStatDownloadProgress_WeaponGraph )} );

		$.GetContextPanel().RegisterForReadyEvents( true );
		$.GetContextPanel().SetReadyForDisplay( false );
		$.GetContextPanel().SetReadyForDisplay( true );

		var elRoot = $.GetContextPanel().FindChildTraverse( 'id-playerstats__record' );
		elRoot.RemoveClass( 'prereveal' );

		_UpdateSubscriptionStatus();
		_InitAnims();
	}

	function _OnReadyForDisplay()
	{
		_m_visible = true;

		if ( _m_timedOutWhileAway )
		{
			DeepStatsAPI.ForceRefresh();
			_m_timedOutWhileAway = false;
		}

		if ( !_m_InventoryUpdatedHandler )
		{
			_m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _UpdateSubscriptionStatus );
		}
		if ( !_m_SubscriptionStatusChangeUpdatedHandler )
		{
			_m_SubscriptionStatusChangeUpdatedHandler = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_RecurringSubscriptionStatusChange', _UpdateSubscriptionStatus );
		}

		_OnModeChanged();
		_UpdateSubscriptionStatus();
		_InitAnims();
	}

	function _OnUnreadyForDisplay()
	{
		_m_visible = false;
		Scheduler.Cancel( 'RECORD' );
		Scheduler.Cancel( 'MATCHES' );
		Scheduler.Cancel();

		if ( _m_InventoryUpdatedHandler )
		{
			$.UnregisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _m_InventoryUpdatedHandler );
			_m_InventoryUpdatedHandler = null;
		}
		if ( _m_SubscriptionStatusChangeUpdatedHandler )
		{
			$.UnregisterForUnhandledEvent( 'PanoramaComponent_MyPersona_RecurringSubscriptionStatusChange', _m_SubscriptionStatusChangeUpdatedHandler );
			_m_SubscriptionStatusChangeUpdatedHandler= null;
		}
	}

	function _OnDeepStatsTimeOut ()
	{
		if ( _m_visible )
		{
			UiToolkitAPI.ShowGenericPopupOk(
				$.Localize( '#SFUI_SteamConnectionErrorTitle' ),
				$.Localize( '#playerstats_forceretry' ),
				'',
				function() { DeepStatsAPI.ForceRefresh(); _OnModeChanged(); },
				function() {}
			);
		}
		else
		{
			_m_timedOutWhileAway = true;
		}
	}

	function _GetBestMateForPeriod ( arrMatches )
	{
		var oMatesData = {};
		var oMates = {
			w3: [], // 3+ shared wins
			w2: [], // 2+ shared wins
			w1: [], // 1+ shared wins
			all: [], // everyone
		}

		arrMatches.forEach( function( oMatch, index ) 
		{
			oMatch.mates.forEach( function(mate,index)
			{
				// if( (oMatch.match_outcome & 0x4) != 0 ) // skip if we didn't finish
				// 	return;

				if( !oMatesData.hasOwnProperty(mate) )
				{
					oMatesData[mate] = { 
						sharedWins: 0,
						rounds_won: 0,
						rounds_lost: 0
					};
				}

				oMatesData[ mate ].rounds_won += oMatch.rounds_won;
				oMatesData[ mate ].rounds_lost += oMatch.rounds_lost;

				// count the wins. this is the most important stat. fallback to round win/loss if there are no shared wins with any player.
				if ( ( oMatch.match_outcome & 0x3 ) == 1 )
				{
					oMatesData[ mate ].sharedWins++;
				}

				if( oMatesData[mate].sharedWins >= 3 && !oMates.w3.includes( mate ) )
				{
					oMates.w3.push(mate);
				}
				else if ( oMatesData[ mate ].sharedWins == 2 )
				{
					oMates.w2.push(mate);
				}
				else if ( oMatesData[ mate ].sharedWins == 1 )
				{
					oMates.w1.push(mate);
				}

				// everyone goes in here
				oMates.all.push( mate );
				
			});

		});		

	//	select from the min 3 shared wins, else 2, else 1, else compare rounds won to lost.
		var arrFilteredMates = Object.values( oMates.w3 ).length > 0 ? oMates.w3 :
			Object.keys( oMates.w2 ).length > 0 ? oMates.w2 :
				Object.keys( oMates.w1 ).length > 0 ? oMates.w1 :
					oMates.all;
		
		var bestMate = -1;
		var bestRatio = -1; // worst case, pick the first mate, even if no rounds won or lost

		if ( arrFilteredMates.length == 0 )
			return [0,0];

		arrFilteredMates.forEach( function( mate, index ) 
		{
			var ratio = oMatesData[mate].rounds_lost == 0 ? oMatesData[mate].rounds_won : ( oMatesData[mate].rounds_won / oMatesData[mate].rounds_lost );
			if( ratio >= bestRatio )
			{
				bestRatio = ratio;
				bestMate = parseInt( mate );
			}
		});

		return [ DeepStatsAPI.GetXUIDByAccountID(bestMate), bestRatio ] ;
	}

	function _UpdateSubscriptionStatus()
	{
		var strGetSubscriptionGreenButton = ''; // string to use for showing the green button

		var labelDesc = $.GetContextPanel().FindChildInLayoutFile( 'id-subscription-status-desc' );
		var rtRecurringSubscriptionNextBillingCycle = InventoryAPI.GetCacheTypeElementFieldByIndex( 'RecurringSubscription', 0, 'time_next_cycle' );
		if ( rtRecurringSubscriptionNextBillingCycle )
		{
			// ENROLLED at some point, could be operation and has data
			$.Msg( 'Recurring subscription cycle = ' + rtRecurringSubscriptionNextBillingCycle );
			var numSecondsTillNextBillingCycle = NewsAPI.GetNumSecondsTillGcTimestamp( rtRecurringSubscriptionNextBillingCycle );
			if ( numSecondsTillNextBillingCycle < 60 )
			{
				$.Msg( 'Recurring subscription expired! (' + numSecondsTillNextBillingCycle + ' seconds ago)' );
				// EXPIRED
				labelDesc.text = $.Localize( '#playerstats_subscription_expired', labelDesc );
				labelDesc.SetHasClass( 'subscription-status__label--yellow', true );
				labelDesc.SetHasClass( 'subscription-status__label--green', false );
				strGetSubscriptionGreenButton = "#playerstats_link_reactivate";
			}
			else
			{
				var status = MyPersonaAPI.GetMyRecurringSubscriptionStatus();
				$.Msg( 'Recurring subscription status '+ status );

				// IS RECURRING OR MANUAL
				var decString = status ? '#playerstats_subscription_' + status
					: '#playerstats_subscription_renew_unknown';
					
				labelDesc.SetHasClass( 'subscription-status__label--yellow', status === 'renew_manually' );
				labelDesc.SetHasClass( 'subscription-status__label--green', status === 'renew_automatically' );
				
				if ( numSecondsTillNextBillingCycle <= 24*3600 && status === 'renew_manually' )
				{
					// RENEW MANUALLY LAST DAY
					$.Msg( 'Recurring subscription is in last day of its active cycle.' );
					labelDesc.text = $.Localize( '#playerstats_subscription_expire_warning' );
				}
				else
				{
					// ACTIVE - DAYS LEFT TILL NEXT BILLING
					var daysLeft = Math.floor( numSecondsTillNextBillingCycle / (( 24*3600 ) + 1 ));
	
					$.Msg( 'Recurring subscription cycle has ' + Math.floor( numSecondsTillNextBillingCycle / ( 24*3600 ) + 1 ) + ' days remaining.' );
					labelDesc.SetDialogVariableInt( "days", daysLeft );
					var daysString = $.ConstructString( '#SFUI_Store_Timer_Day:f', { value: daysLeft } );
					labelDesc.SetDialogVariable( "daystext", daysString );
					labelDesc.text = $.Localize( decString, labelDesc );
				}
			}
		}
		else
		{
			$.Msg( 'Recurring subscription never had billing established, but has stats' );
			// NO SUBSCRIPTION (users coming from operation with previous data)
			labelDesc.text = $.Localize( '#playerstats_subscription_not_enrolled', labelDesc );
			labelDesc.SetHasClass( 'subscription-status__label--yellow', false );
			labelDesc.SetHasClass( 'subscription-status__label--green', false );
			strGetSubscriptionGreenButton = "#playerstats_link_get";
		}

		// Big green button? Or 'manage subscription' external link? One of them should be visible at all times.
		var btnGetSubscription = $.GetContextPanel().FindChildInLayoutFile( 'id-get-subscription' );
		var btnManageSubscription = $.GetContextPanel().FindChildInLayoutFile( 'id-manage-subscription' );
		if ( strGetSubscriptionGreenButton )
		{
			btnGetSubscription.text = $.Localize( "#playerstats_link_get" );
			btnGetSubscription.SetHasClass( 'hide', false );
			btnManageSubscription.SetHasClass( 'hide', true );
		}
		else
		{
			btnGetSubscription.SetHasClass( 'hide', true );
			btnManageSubscription.SetHasClass( 'hide', false );
		}
	}

	function _CreateTooltip ( elPanel, text, title = '', additionalClass = null,fnon = null, fnoff = null )
	{
		var xmlsrc = 'file://{resources}/layout/tooltips/stats/tooltip_playerstats_generic.xml';
		var ttid = 'tt_' + elPanel.id;
		var parms = "title=" + title + "&text=" + text + '&class=' + additionalClass;
		var onStatHoverOn_f = _OnMouseOverCustomLayoutTooltip.bind( undefined, elPanel.id, ttid, xmlsrc, parms );
		var onStatHoverOff_f = _OnMouseOutCustomLayoutTooltip.bind( undefined, ttid );

		elPanel.SetPanelEvent( 'onmouseover', function() {onStatHoverOn_f(); if (typeof fnon === 'function') fnon() } );
		elPanel.SetPanelEvent( 'onmouseout', function() {onStatHoverOff_f(); if (typeof fnoff === 'function') fnoff()} );
	}

	function _ResetYourRecord ()
	{
		$.Msg( '_ResetYourRecord' );

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		elRecordFrame.AddClass( 'no-data' );
		elRecordFrame.enabled = false;
	}



	function _UpdateYourRecordAsycDeepstats ()
	{
		$.Msg( '_UpdateYourRecordAsycDeepstats' );
		Scheduler.Cancel( 'RECORD' );			

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		var oDeepStats = _GetDataForRange( _m_days, _m_mode );
		var arrMatches = oDeepStats.matches;

		var elPageSpinner = $.GetContextPanel().FindChildTraverse( 'PageSpinner' );
		elPageSpinner.SetHasClass( 'stats-loading', oDeepStats.status != 'complete' );
		elRecordFrame.SetHasClass( 'stats-loading', oDeepStats.status != 'complete' );

		elRecordFrame.SetHasClass( 'no-data',  arrMatches.length == 0 );
		elRecordFrame.enabled = arrMatches.length != 0;

		var elBlocker = $.GetContextPanel().FindChildTraverse( 'NoDataBlocker' );
		if ( elBlocker )
			elBlocker.visible = arrMatches.length == 0;
		
		var elNoDataNotice = $.GetContextPanel().FindChildTraverse( 'NoDataNotice' );
		if ( elNoDataNotice )
			elNoDataNotice.style.opacity = ( arrMatches.length == 0 && oDeepStats.status == 'complete') ? 1 : 0;

		if ( ( !arrMatches || arrMatches.length == 0 ) && oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 1.0, _UpdateYourRecordAsycDeepstats, 'RECORD' );
			return;
		}

		////////////////////

		var bValid = false;

		var elBestMate = elRecordFrame.FindChildTraverse( 'BestMate' );
		if ( elBestMate )
		{
			var xuid = _GetBestMateForPeriod( arrMatches )[0];

			bValid = xuid != '';
		//	bValid = _m_days >= 90;

			elBestMate.SetHasClass( 'no-data', !bValid );

			if ( bValid )
			{
				elBestMate.SetDialogVariable( 'value', FriendsListAPI.GetFriendName( xuid ));

				var elAvatar = elBestMate.FindChildTraverse( 'JsAvatarImage' );
				elAvatar.PopulateFromSteamID(xuid);

				elBestMate.SetPanelEvent( 'onactivate', function( xuid )
				{
					var playerCard = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(
						'',
						'',
						'file://{resources}/layout/context_menus/context_menu_playercard.xml',
						'xuid=' + xuid,
						function() {}
					)

					playerCard.AddClass( "ContextMenu_NoArrow" );

				}.bind( this, xuid ) );
			}
		}

		if ( oDeepStats.status != 'complete' )
		{
			Scheduler.Schedule( 2.0, _UpdateYourRecordAsycDeepstats, 'RECORD' );
			return;
		}
	}


	function _OnStatDownloadProgress_LineGraph()
	{
		$.Msg( '_OnStatDownloadProgress_LineGraph' );

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		_m_arrLinegraphStats.forEach( function( stat, idx )
		{
			var total = _m_LineGraph.GetAttributeInt( strStatTotalPrefix + stat, 0 );
			var avg = _m_LineGraph.GetAttributeInt( strStatAveragePrefix + stat, 0 );

			// if the number is only 5 digits, display it with commas. Otherwise, abbreviate it.
			var prettyTotal = total < 100000 ? total.toString().replace( /\B(?=(\d{3})+(?!\d))/g, ',' ) :
				FormatText.AbbreviateNumber( total );

			$.GetContextPanel().SetDialogVariable( strStatTotalPrefix + stat, prettyTotal );

			var denom = oStatAvgSuffix[ stat ] == "#playerstats_suffix_per_cent" ? 10 : 1000;
			$.GetContextPanel().SetDialogVariable( strStatAveragePrefix + stat, ( avg / denom ).toPrecision( 3 ) + $.Localize( oStatAvgSuffix[ stat ] ) );
		} )

		$.GetContextPanel().SetDialogVariable( 'stat_total_wins', _m_LineGraph.GetAttributeInt( 'wins', 0 ) );
		$.GetContextPanel().SetDialogVariable( 'stat_total_losses', _m_LineGraph.GetAttributeInt( 'losses', 0 ) );
		$.GetContextPanel().SetDialogVariable( 'stat_total_ties', _m_LineGraph.GetAttributeInt( 'ties', 0 ) );

		/// digit panels
		var elMatches = elRecordFrame.FindChildTraverse( 'matches' );
		if ( elMatches )
		{
			var value = _m_LineGraph.GetAttributeInt( 'matches', 0 );
			var arrValue = FormatText.SplitAbbreviateNumber( value );
			if ( elMatches && !elMatches.FindChildTraverse( 'DigitPanel' ) )
				DigitPanelFactory.MakeDigitPanel( elMatches, 5 );
			
			DigitPanelFactory.SetDigitPanelString( elMatches, arrValue[ 0 ], arrValue[ 1 ] );
		}	

		var elADR = elRecordFrame.FindChildTraverse( 'stat_average_health_removed' );
		if ( elADR )
		{
			var value = _m_LineGraph.GetAttributeInt( 'stat_average_health_removed', 0 );
			value = ( value / 1000 ).toPrecision( 3 );
			if ( elADR && !elADR.FindChildTraverse( 'DigitPanel' ) )
				DigitPanelFactory.MakeDigitPanel( elADR, 5 );
			
			DigitPanelFactory.SetDigitPanelString( elADR, value );
		}

		var elKDR = elRecordFrame.FindChildTraverse( 'stat_average_kd' );
		if ( elKDR )
		{
			var value = _m_LineGraph.GetAttributeInt( 'stat_average_kd', 0 );
			value = ( value / 1000 ).toPrecision( 3 );
			if ( elKDR && !elKDR.FindChildTraverse( 'DigitPanel' ) )
				DigitPanelFactory.MakeDigitPanel( elKDR, 5 );
			
			DigitPanelFactory.SetDigitPanelString( elKDR, value );
		}

		var elKills = elRecordFrame.FindChildTraverse( 'stat_total_kills' );
		if ( elKills )
		{
			var value = _m_LineGraph.GetAttributeInt( 'stat_total_kills', 0 );

			var abbr = FormatText.SplitAbbreviateNumber( value, 1 );
			var string = abbr[ 0 ];
			var suffix = abbr[ 1 ];
			
			var bAbbreviate = value >= 10000;
			var string = bAbbreviate ? abbr[ 0 ] : value.toString().replace( /\B(?=(\d{3})+(?!\d))/g, ',' ) ;
			
			if ( elKills && !elKills.FindChildTraverse( 'DigitPanel' ) )
				DigitPanelFactory.MakeDigitPanel( elKills, 5 );
			
			DigitPanelFactory.SetDigitPanelString( elKills, string, bAbbreviate ? suffix : '' );
		}
	}

	function _OnStatDownloadProgress_MapGraph()
	{
		$.Msg( '_OnStatDownloadProgress_MapGraph' );

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		var elBestMap = elRecordFrame.FindChildTraverse( 'BestMap' );
		if ( elBestMap )
		{
			var mapString = DeepStatsAPI.MapIDToString( _m_MapGraph.best_map );
			$.Msg( 'Setting best map from property = "' + _m_MapGraph.best_map + '" -> "' + mapString + '"' );

			var bValid = mapString != '';
			//bValid = _m_days > 15;

			if ( bValid )
			{
				elBestMap.SetDialogVariable( 'value', $.Localize( '#SFUI_Map_' + mapString ));
							
				var elMapIcon = elBestMap.FindChildTraverse( 'MapIcon' );
				var strMap = DeepStatsAPI.MapIDToString( _m_MapGraph.best_map );
				elMapIcon.SetImage( "file://{images}/map_icons/map_icon_" + strMap + ".svg" );
				IconUtil.SetupFallbackMapIcon( elMapIcon, 'file://{images}/map_icons/map_icon_NONE.png' );
			}
		}
		
		_UpdateYourRecordAsycDeepstats();
	}

	function _OnStatDownloadProgress_WeaponGraph()
	{
		$.Msg( '_OnStatDownloadProgress_WeaponGraph' );

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		var arrWeapons = _m_WeaponGraph.GetWeaponScores();	
		var elBestWeaponContainer = elRecordFrame.FindChildTraverse( "BestWeapons" );
		if ( elBestWeaponContainer )
		{
			arrWeapons.sort( (a,b) => b.score - a.score );
			var weaponIdx = 0;
			elBestWeaponContainer.FindChildrenWithClassTraverse( "weapons__row" ).forEach( function( elWeaponPanel ) {
				var elImage = elWeaponPanel.FindChild( "WeaponImage" );
				var weaponScore = arrWeapons[weaponIdx++];
				if ( elImage ) 
				{
					elImage.SetImage( "file://{images}/icons/equipment/"+ InventoryAPI.GetHudIconFileName( weaponScore.weapon_id ) +".svg" );
				}
				elWeaponPanel.SetDialogVariable( "score", weaponScore.score.toPrecision(3) );
				elWeaponPanel.SetDialogVariable( "total", weaponScore.total );
				var itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( weaponScore.weapon_id, 0 )
				_CreateTooltip( elWeaponPanel, InventoryAPI.GetItemName( itemid ));
			});
      	}
	}


/////////////////////////////////////////
/// LINE GRAPH
////////////////////////////////////////
	

	function _ResetLinegraph ()
	{
		
		// center the today label on the final bar
		var elToday = $.GetContextPanel().FindChildTraverse( 'LinegraphTodayLabel' );
		if ( elToday )
		{
				//
		}
		
		var elStart = $.GetContextPanel().FindChildTraverse( 'LinegraphStartLabel' );
		if ( elStart )
		{
			var startDate = new Date();

			if ( _m_days == -1 )
			{
				startDate.setTime( DeepStatsAPI.GetDeepStatsStartTime() * 1000 );
			}
			else
			{
				startDate.setDate( startDate.getDate() - _m_days + 1 );
			}

			DateUtil.PopulateDateFormatStrings( elStart, startDate );
		}
	}


	function _UpdateLineGraph ()
	{

		$.Msg( "_UpdateLineGraph" );

		_UpdateGraphStatButtons();

		var arrGraphPoints = $.GetContextPanel().FindChildrenWithClassTraverse( 'graph-point-avg' );

		arrGraphPoints.forEach( function( elPoint, index )
		{
			var timeslice = 0.02;

			var timestamp = elPoint.GetAttributeInt( 'timestamp', 0 );

			// make it a button that populates the match lister
			var onActivate_f = function( strDateKey )
			{
				MatchLister.Highlight( _m_elMatchHistory, strDateKey );
			}

			elPoint.SetPanelEvent( 'onactivate', onActivate_f.bind( this, _GetDateKeyFromTimestamp( timestamp ) ) );
			

			Scheduler.Schedule( index * timeslice, function( elPoint )
			{
				if ( elPoint && elPoint.IsValid() )
					elPoint.TriggerClass( 'graph-point--reveal' );
		
			}.bind( this, elPoint), GRAPH_JOBS );
		} );

		// set the Y axis 
		/* UNDONE: Positioning in C now since width can vary and a fixed transform offset doesn't cover every situation
		var elStatButtons = $.GetContextPanel().FindChildTraverse( 'StatSelectionButtonContainer' ).GetChild( 0 );
		var index = parseInt( elStatButtons.GetSelectedButton().GetAttributeString( 'statidx', 0 ) );

		
		function formatLabel(elLabel, statValue) {
	      	statValue = _isPercentage(index) ? 100 * statValue : statValue;
    	  	statValue = statValue.toPrecision(2);
     		statValue += _GetUnitSuffix(index);
      		elLabel.SetDialogVariable("statval", statValue );
    	}
		
		var vecGraphContainer = $.GetContextPanel().FindChildTraverse( "LineGraphOuter" );
		var vecLabels = vecGraphContainer.FindChildrenWithClassTraverse( "linegraph__yaxis-range_label" );
		vecLabels.forEach( function ( elLabel ) {
			var statValue = elLabel.GetAttributeInt("statval", -1) / 1000;
			formatLabel( elLabel, statValue );
		});
		
		var elYMin = $.GetContextPanel().FindChildTraverse( 'YMinLabel' );
		formatLabel( elYMin, elYMin.GetAttributeInt( "statval", -1 ) / 1000 );
		var elYMax = $.GetContextPanel().FindChildTraverse( 'YMaxLabel' );
		formatLabel( elYMax, elYMax.GetAttributeInt( "statval", -1 ) / 1000 );
		var elThird = $.GetContextPanel().FindChildTraverse( 'ThirdLabel' );
		formatLabel( elThird, elThird.GetAttributeInt( "statval", -1 ) / 1000 );
		var elTwoThird = $.GetContextPanel().FindChildTraverse( 'TwoThirdLabel' );
		formatLabel( elTwoThird, elTwoThird.GetAttributeInt( "statval", -1 ) / 1000 );
		*/

	}
	
	function _IsPerRound ( index )
	{
		return index == 0 ||
			index == 1 ||
			index == 2;
	}

	function _isPercentage ( index )
	{
		return index == 4 ||
			index == 8 ||
			index == 9 ||
			index == 10 ||
			index == 11;
	}

	function _HasHistogram ( index )
	{
		return index == 0 ||
			index == 1 ||
			index == 2 ||
			index == 3 ||
			index == 4;
		
	}

	function _AddAUniqueTooltipTarget ( elPanel, id, classname )
	{
		// make a tooltip target
		var strTooltipTargetId = 'JSTTTarget-' + id;
		var elTooltipTarget = elPanel.FindChildTraverse( strTooltipTargetId );
		if ( !elTooltipTarget )
		{
			elTooltipTarget = $.CreatePanel( 'Panel', elPanel, strTooltipTargetId );
			elTooltipTarget.AddClass( classname );
		}
		
		return elTooltipTarget;
	}

	function _GetUnitSuffix ( index )
	{
		// if ( _IsPerRound( index ) )
		// 	return $.Localize( 'playerstats_suffix_per_round' );
		// // else if ( _isPerDeath( index ) )
		// 	return $.Localize('playerstats_suffix_per_death');
		if ( _isPercentage( index ) )
			return $.Localize( '#playerstats_suffix_per_cent' );
		else
			return '';
	}

	// we've switched 
	function _UpdateGraphStatButtons ()
	{

		/////////////////////////////////////
		// set up digit panels in the stat buttons
		_m_LineGraph.FindChildrenWithClassTraverse( 'stats-panel--graphbtn' ).forEach( function( elBtn, index )
		{

			// NORMAL VALUE 
			////////////////////////////////////////////////////////////////////////////////
			var valueNormal = parseInt( elBtn.GetAttributeInt( "stat_average", 0 ) );
			var valueNormal = valueNormal == 0 ? 0 : ( valueNormal / ( _isPercentage( index ) ? 10.0 : 1000.0 )).toPrecision( 3 );

			var elStatStatNormalLabel = elBtn.FindChildTraverse( 'StatNormalValue' );
			if ( elStatStatNormalLabel )
			{
				elStatStatNormalLabel.SetDialogVariable( 'value', valueNormal );
				if ( _isPercentage( index ) )
				{
					elStatStatNormalLabel.text = $.Localize( '#playerstats_per_cent', elStatStatNormalLabel );
				}
				else
				{
					elStatStatNormalLabel.text = $.Localize( '#playerstats_no_units', elStatStatNormalLabel );
				}
			}
			// RANK VALUE
			////////////////////////////////////////////////////////////////////////////////
			var rank = elBtn.GetAttributeInt( "stat_ranking", 0 );
			rank = _HasHistogram( index ) ? rank : -1;

			var elStatRankLabel = elBtn.FindChildTraverse( 'StatRankLabel' );
			if ( elStatRankLabel )
			{
				var title = $.Localize( "#playerstat_name_" + index + '_long' );
				var tt_text;
				if ( _HasHistogram( index ) )
				{
					elStatRankLabel.SetDialogVariable( 'tt_value', valueNormal + _GetUnitSuffix( index ) );
					elStatRankLabel.SetDialogVariable( 'tt_rank', rank );

					tt_text = $.Localize( '#playerstats_percentile_subscribers', elStatRankLabel );
				}
				else
				{
					tt_text = $.Localize( '#playerstats_no_percentile', elStatRankLabel );
				}
				_CreateTooltip( elBtn, tt_text, title, 'limit-width' );

				elStatRankLabel.SetDialogVariable( 'value', rank != -1 ? rank.toPrecision( 2 ) : '' );

				if ( _HasHistogram( index ))
					elStatRankLabel.text = $.Localize( '#playerstats_per_cent', elStatRankLabel );
			}
		})
	}

	function _OnModeChanged ()
	{
		$.GetContextPanel().RemoveClass( 'mode' + _m_mode );
		_m_mode = _GetModeFilter();
		$.GetContextPanel().AddClass( 'mode' + _m_mode );

		if ( GameInterfaceAPI.GetSettingString( 'ui_deepstats_toplevel_mode' ) !== _m_mode )
		{
			$.Msg( 'playerstats.js : _OnModeChanged setting = ' + _m_mode );
			GameInterfaceAPI.SetSettingString( 'ui_deepstats_toplevel_mode', _m_mode );
		}

		_SetModeToEmbeddedControls();

		Scheduler.Cancel();

	//	_ResetYourRecord();

		_ResetLinegraph();

		MatchLister.Populate( _m_elMatchHistory, _m_days, _m_mode, '' );
	}


	function _OnTimeRangeChanged ()
	{

		// set the time range
		_m_days = _InitializeTimeRangeFilter();

		Scheduler.Cancel();`	`
//		Scheduler.Cancel( GRAPH_JOBS );

//		_ResetYourRecord();
		_ResetLinegraph();

		MatchLister.Populate( _m_elMatchHistory, _m_days, _m_mode, '' );

	//	_UpdateAll();	
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

	function _GetDateKeyFromTimestamp ( timestamp )
	{
		var time = new Date(timestamp*1000 );

		var d = FormatText.PadNumber( time.getDate(), 2 );
		var m = FormatText.PadNumber( time.getMonth(), 2 );
		var y = FormatText.PadNumber( time.getFullYear(), 4 );

		return ( String(y) +String(m) + String(d) );
	}
	
	/* Public interface */
	return {
		Init:							_Init,
		OnModeChanged: 					_OnModeChanged,
		OnTimeRangeChanged:				_OnTimeRangeChanged
	};

} )();

//--------------------------------------------------------------------------------------------------
// Entry point called when panel is created
//--------------------------------------------------------------------------------------------------
( function()
{
	playerstats.Init();
} )();
