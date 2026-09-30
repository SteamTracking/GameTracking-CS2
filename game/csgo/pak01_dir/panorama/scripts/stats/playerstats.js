'use strict';




var playerstats = ( function()
{
	const GRAPH_JOBS = 'graph_jobs';

	var _m_visible;
	var _m_timedOutWhileAway;

	var _m_elSingleMatch;                           

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
	
	var _m_mode = _InitializeModeFilterFromSettings();                                                        
	var _m_days = _InitializeTimeRangeFilter();                                                

	                                        
	    
	   	                                                                                               
	   	                                                                                                   
	       

	function _InitializeTimeRangeFilter()
	{
		var ival = parseInt( $.GetContextPanel().FindChildTraverse( 'id-playerstats__range' ).GetSelected().GetAttributeString( "value", "" ));
		                                                    

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

		                                                       
		var lastMatch = DeepStatsAPI.GetLastCachedMatchJS();
		if ( lastMatch && lastMatch.matches.length > 0 )
		{
			var oMatch = lastMatch.matches[ 0 ].player;
			var mode = DeepStatsAPI.GetMatchTypeString( oMatch.mm_game_mode );
			switch ( mode )
			{
				default:
					                                                                        

				case "Competitive":
				case "CompetitiveCaptains":
				case "CompetitiveScrimmage":
					                                                                         
					val = 240;
					valID = "mode_id_11";
					break;
				
				case "Wingman":
					                                                                     
					val = 12288;
					valID = "mode_id_16";
					break;
			}

			                                                                     
			var timestamp = DeepStatsAPI.MatchIDToLocalTime( oMatch.match_id );
			                                                                                
			                                                                          
			timestamp += 1606723200 - DeepStatsAPI.MatchIDToLocalTime( "3450411799665595200" );
			                               
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
			                                                                                                   
			elDropdown.SetSelected( valID );
		}
		else
		{
			elDropdown.SetSelectedIndex( 0 );
			val = elDropdown.GetSelected().GetAttributeString( "value", "" );
			                                                                                             
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
		                            
		  
			                        
			                                 
			                                 
			                                                    
			               
			                                              
			                             
			                                                                                               

			                      
			                                               
			                                               

			                            
			                    
			                       
			                                                                                                                     
							                                             			    
							                                               			    
							                                               			    
							                                                  		    
							                                                       	                               
							                                                		    
							                                                 		                              
							                                                 		                              
							                                             			                              
							                                             			                            
			                             
			                                                     
			               
					                                                                                 
					                                                                    
			                                
			                                   
			                                     
			                   	                                                        
			               		                                                  
			                       
			                                                                                                                                
			                   
			                   
			                   
			                          
			                                                          
			                                                       
			                                                
			                                             
			                                                
			                                             
			                                             
			                                                                  
			                                                                
			                                     
			                                                                     
			                                                            
			                              

			                            
			                                                                          
		  
	}

	function _InitMatchDetailsPanel ()
	{
		                                                
		if ( !_m_elSingleMatch )
		{
			_m_elSingleMatch = $.GetContextPanel().FindChildTraverse( 'PlayerStats_SingleMatch' );
			if ( _m_elSingleMatch )
			{
				                                                                    
				var elMainMenuInput = $.GetContextPanel();
				while ( elMainMenuInput ) 
				{
					elMainMenuInput = elMainMenuInput.GetParent();
					if ( elMainMenuInput.id === 'MainMenuInput' )
						break;
				}

				if ( elMainMenuInput )
				{
					                                                                                                 
					   	                                                                            

					_m_elSingleMatch.SetParent( elMainMenuInput );
				}
			}
		}
	}

	function _InitMatchLister ( panel )
	{
		                            
		MatchLister.Init( panel );
	}

	function _InitAnims()
	{
		                                       
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

		                        
		                         

		_ResetYourRecord();
		  		                    

		_ResetLinegraph();
		  		                          

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
			w3: [],                  
			w2: [],                  
			w1: [],                  
			all: [],            
		}

		arrMatches.forEach( function( oMatch, index ) 
		{
			oMatch.mates.forEach( function(mate,index)
			{
				                                                                      
				   	       

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

				                        
				oMates.all.push( mate );
				
			});

		});		

	  	                                                                                   
		var arrFilteredMates = Object.values( oMates.w3 ).length > 0 ? oMates.w3 :
			Object.keys( oMates.w2 ).length > 0 ? oMates.w2 :
				Object.keys( oMates.w1 ).length > 0 ? oMates.w1 :
					oMates.all;
		
		var bestMate = -1;
		var bestRatio = -1;                                                                  

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
		var strGetSubscriptionGreenButton = '';                                              

		var labelDesc = $.GetContextPanel().FindChildInLayoutFile( 'id-subscription-status-desc' );
		var rtRecurringSubscriptionNextBillingCycle = InventoryAPI.GetCacheTypeElementFieldByIndex( 'RecurringSubscription', 0, 'time_next_cycle' );
		if ( rtRecurringSubscriptionNextBillingCycle )
		{
			                                                          
			                                                                                     
			var numSecondsTillNextBillingCycle = NewsAPI.GetNumSecondsTillGcTimestamp( rtRecurringSubscriptionNextBillingCycle );
			if ( numSecondsTillNextBillingCycle < 60 )
			{
				                                                                                                
				          
				labelDesc.text = $.Localize( '#playerstats_subscription_expired', labelDesc );
				labelDesc.SetHasClass( 'subscription-status__label--yellow', true );
				labelDesc.SetHasClass( 'subscription-status__label--green', false );
				strGetSubscriptionGreenButton = "#playerstats_link_reactivate";
			}
			else
			{
				var status = MyPersonaAPI.GetMyRecurringSubscriptionStatus();
				                                                  

				                         
				var decString = status ? '#playerstats_subscription_' + status
					: '#playerstats_subscription_renew_unknown';
					
				labelDesc.SetHasClass( 'subscription-status__label--yellow', status === 'renew_manually' );
				labelDesc.SetHasClass( 'subscription-status__label--green', status === 'renew_automatically' );
				
				if ( numSecondsTillNextBillingCycle <= 24*3600 && status === 'renew_manually' )
				{
					                          
					                                                                      
					labelDesc.text = $.Localize( '#playerstats_subscription_expire_warning' );
				}
				else
				{
					                                       
					var daysLeft = Math.floor( numSecondsTillNextBillingCycle / (( 24*3600 ) + 1 ));
	
					                                                                                                                                   
					labelDesc.SetDialogVariableInt( "days", daysLeft );
					var daysString = $.ConstructString( '#SFUI_Store_Timer_Day:f', { value: daysLeft } );
					labelDesc.SetDialogVariable( "daystext", daysString );
					labelDesc.text = $.Localize( decString, labelDesc );
				}
			}
		}
		else
		{
			                                                                               
			                                                                   
			labelDesc.text = $.Localize( '#playerstats_subscription_not_enrolled', labelDesc );
			labelDesc.SetHasClass( 'subscription-status__label--yellow', false );
			labelDesc.SetHasClass( 'subscription-status__label--green', false );
			strGetSubscriptionGreenButton = "#playerstats_link_get";
		}

		                                                                                                        
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
		                            

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		elRecordFrame.AddClass( 'no-data' );
		elRecordFrame.enabled = false;
	}



	function _UpdateYourRecordAsycDeepstats ()
	{
		                                          
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

		                    

		var bValid = false;

		var elBestMate = elRecordFrame.FindChildTraverse( 'BestMate' );
		if ( elBestMate )
		{
			var xuid = _GetBestMateForPeriod( arrMatches )[0];

			bValid = xuid != '';
		  	                       

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
		                                             

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		_m_arrLinegraphStats.forEach( function( stat, idx )
		{
			var total = _m_LineGraph.GetAttributeInt( strStatTotalPrefix + stat, 0 );
			var avg = _m_LineGraph.GetAttributeInt( strStatAveragePrefix + stat, 0 );

			                                                                                    
			var prettyTotal = total < 100000 ? total.toString().replace( /\B(?=(\d{3})+(?!\d))/g, ',' ) :
				FormatText.AbbreviateNumber( total );

			$.GetContextPanel().SetDialogVariable( strStatTotalPrefix + stat, prettyTotal );

			var denom = oStatAvgSuffix[ stat ] == "#playerstats_suffix_per_cent" ? 10 : 1000;
			$.GetContextPanel().SetDialogVariable( strStatAveragePrefix + stat, ( avg / denom ).toPrecision( 3 ) + $.Localize( oStatAvgSuffix[ stat ] ) );
		} )

		$.GetContextPanel().SetDialogVariable( 'stat_total_wins', _m_LineGraph.GetAttributeInt( 'wins', 0 ) );
		$.GetContextPanel().SetDialogVariable( 'stat_total_losses', _m_LineGraph.GetAttributeInt( 'losses', 0 ) );
		$.GetContextPanel().SetDialogVariable( 'stat_total_ties', _m_LineGraph.GetAttributeInt( 'ties', 0 ) );

		                
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
		                                            

		var elRecordFrame = $.GetContextPanel().FindChildTraverse( 'PlayerStatsRecordFrame' );

		var elBestMap = elRecordFrame.FindChildTraverse( 'BestMap' );
		if ( elBestMap )
		{
			var mapString = DeepStatsAPI.MapIDToString( _m_MapGraph.best_map );
			                                                                                                  

			var bValid = mapString != '';
			                        

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


                                         
              
                                        
	

	function _ResetLinegraph ()
	{
		
		                                          
		var elToday = $.GetContextPanel().FindChildTraverse( 'LinegraphTodayLabel' );
		if ( elToday )
		{
				  
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

		                            

		_UpdateGraphStatButtons();

		var arrGraphPoints = $.GetContextPanel().FindChildrenWithClassTraverse( 'graph-point-avg' );

		arrGraphPoints.forEach( function( elPoint, index )
		{
			var timeslice = 0.02;

			var timestamp = elPoint.GetAttributeInt( 'timestamp', 0 );

			                                                   
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
		                              
		   	                                                    
		                                      
		   	                                                  
		if ( _isPercentage( index ) )
			return $.Localize( '#playerstats_suffix_per_cent' );
		else
			return '';
	}

	                  
	function _UpdateGraphStatButtons ()
	{

		                                     
		                                          
		_m_LineGraph.FindChildrenWithClassTraverse( 'stats-panel--graphbtn' ).forEach( function( elBtn, index )
		{

			                
			                                                                                
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
			                                                                
			GameInterfaceAPI.SetSettingString( 'ui_deepstats_toplevel_mode', _m_mode );
		}

		_SetModeToEmbeddedControls();

		Scheduler.Cancel();

	  	                   

		_ResetLinegraph();

		MatchLister.Populate( _m_elMatchHistory, _m_days, _m_mode, '' );
	}


	function _OnTimeRangeChanged ()
	{

		                     
		_m_days = _InitializeTimeRangeFilter();

		Scheduler.Cancel();`	`
  		                               

  		                   
		_ResetLinegraph();

		MatchLister.Populate( _m_elMatchHistory, _m_days, _m_mode, '' );

	  	             	
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
	
	                      
	return {
		Init:							_Init,
		OnModeChanged: 					_OnModeChanged,
		OnTimeRangeChanged:				_OnTimeRangeChanged
	};

} )();

                                                                                                    
                                           
                                                                                                    
( function()
{
	playerstats.Init();
} )();
