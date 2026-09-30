'use strict';


var mainmenu_watch_eventsched = ( function()
{

	var _m_cP = $.GetContextPanel();
	var _m_ElEventLister = $( "#id-eventsched-master" );
	var _m_arrEvents = undefined;                         
	var _m_arrFavorites = undefined;                                             
	var _m_prevSchedeventsString = "";
	var _m_IsPrime = false;
	var _m_isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld";
	var _m_InventoryUpdatedHandle;


	function _Init ()
	{
		if ( _m_isPerfectWorld )
			return;
		
		                                                                      
		$.RegisterForUnhandledEvent( 'Tournaments_EventsReceived', _EventsReceived );
		$.RegisterForUnhandledEvent( 'Tournaments_FavoritesReceived', _FavoritesReceived );
		$.RegisterForUnhandledEvent( 'Tournaments_RequestMatch', _RequestMatchString );
		_m_InventoryUpdatedHandle = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _PopulateLister );

		                            
		_m_cP.RegisterForReadyEvents( true );
		                                                                             
		$.RegisterEventHandler( 'ReadyForDisplay', _m_cP, function()
		{
			if ( !_m_InventoryUpdatedHandle )
			{
				_m_InventoryUpdatedHandle = $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _PopulateLister );
			}
		} );
		$.RegisterEventHandler( 'UnreadyForDisplay', _m_cP, function()
		{
			if ( _m_InventoryUpdatedHandle )
			{
				$.UnregisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', _m_InventoryUpdatedHandle );
				_m_InventoryUpdatedHandle = null;
			}
		} );


		TournamentsAPI.RequestFavorites();
		TournamentsAPI.RequestTournaments();
	};

	                               
	  
	function _OnMouseOverCustomLayoutTooltip ( _panel, _tooltipId, _xmlsrc, _parms )
	{
		UiToolkitAPI.ShowCustomLayoutParametersTooltip(
			_panel,
			_tooltipId,
			_xmlsrc,
			_parms );
	}

	function _CheckForPrime ()
	{
		_m_IsPrime = MyPersonaAPI.GetElevatedState() == "elevated";
	}

	function _OnMouseOutCustomLayoutTooltip ( _tooltipId )
	{
		UiToolkitAPI.HideCustomLayoutTooltip( _tooltipId );
	}

	                              
	  
	function _OnMouseOverTextTooltip ( _panel, _text )
	{
		UiToolkitAPI.ShowTextTooltip(
			_panel,
			_text );
	}

	function _OnMouseOutTextTooltip ( __tooltipId )
	{
		UiToolkitAPI.HideTextTooltip();
	}

	function _RequestMatchString ( matchId )
	{
		_m_arrEvents.forEach( o =>
		{
			o[ 'live_matches' ].forEach( m =>
			{
				if ( m[ 'match_id' ] == matchId )
				{
					$.DispatchEvent( 'Tournaments_RequestMatch_Response', JSON.stringify( m ) );
					return;
				}
			} )
		} )

		return undefined;

	}

	function _StartDateCompareFunction ( a, b )
	{
		return a[ 'start_date_time' ][ 'seconds' ] - b[ 'start_date_time' ][ 'seconds' ];
	}

	  
	                                   
	 
		                                                                                           

		                                 
			                       
	 

	                                   
	 
		                                                                        
		              
	 
	  

	function _EventsReceived ( eventsAsString )
	{
		if ( eventsAsString != _m_prevSchedeventsString )
		{
			_IngestEvents( eventsAsString );

			_m_prevSchedeventsString = eventsAsString;
		}

		_PopulateLister();
	}

	function _FavoritesReceived ( jsonFavorites, jsonFeatured )
	{
		_m_arrFavorites = JSON.parse( jsonFavorites );

		_PopulateLister();
	}

	function _DisplayAsFavorite ( element, stateToSet )
	{
		element.SetHasClass( 'eventsched-favorite', stateToSet );

		_AddToFavoriteCountAndDisplay( element, stateToSet ? +1 : -1 );

		                                                                       
		if ( stateToSet )
		{
			element.m_elMonthContainer.AddClass( 'eventsched-month-show' );
		}
		else
		{
			                                                                            
			_ClearEmptyMonth( element.m_elMonthContainer );
		}
	}

	function _ClearEmptyMonth ( elMonth )
	{
		  
		                                 
		  
		{
			var bAnyVisible = false;

			elMonth.Children().forEach( element =>
			{
				if ( element.visible == true && element.BHasClass( 'eventsched__capsule' ) )
					bAnyVisible = true;
			} )

			if ( !bAnyVisible )
				elMonth.RemoveClass( 'eventsched-month-show' );
		}
	}

	function _ClearAllEmptyMonths ()
	{
		_m_ElEventLister.Children().forEach( elMonth => _ClearEmptyMonth( elMonth ) );
	}

	function _UpdateAllFavorites ()
	{
		if ( !_m_cP || !_m_cP.IsValid() )
			return;

		if ( !_m_arrFavorites || _m_arrFavorites.length === 0 )
			return;

		for ( var idx in _m_arrEvents )
		{
			var oEvent = _m_arrEvents[ idx ];
			var elEvent = _m_cP.FindChildTraverse( oEvent[ 'event_id' ] );

			if ( elEvent && elEvent.IsValid() )
			{
				var bFavorite = _m_arrFavorites.includes( Number( oEvent[ 'event_id' ] ) );

				_DisplayAsFavorite( elEvent, bFavorite );

				var elFavoriteBtn = elEvent.FindChildTraverse( 'id-capsule__main__favorite' );
				if ( elFavoriteBtn && elFavoriteBtn.IsValid() )
				{
					elFavoriteBtn.checked = bFavorite;
				}

			}
		}
	}

	function GetEventMonthString ( oEvent )
	{
		var startTimeUTCSeconds = -1;
		var endTimeUTCSeconds = -1;

		var startDate = new Date( 0 );
		var endDate = new Date( 0 );

		if ( 'start_date_time' in oEvent && 'seconds' in oEvent[ 'start_date_time' ] )
		{
			startTimeUTCSeconds = Number( oEvent[ 'start_date_time' ][ 'seconds' ] );
			startDate.setUTCSeconds( startTimeUTCSeconds );

			if ( 'end_date_time' in oEvent && 'seconds' in oEvent[ 'end_date_time' ] )
			{
				endTimeUTCSeconds = Number( oEvent[ 'end_date_time' ][ 'seconds' ] );
				endDate.setUTCSeconds( endTimeUTCSeconds );
			}

			var monthPaddedNumber = ( '0' + ( startDate.getMonth() + 1 ) ).slice( -2 );
			return $.Localize( '#MonthName' + monthPaddedNumber + '_long' );                      
		}
	}

	                          
	function _IngestEvents ( eventsAsString )
	{
		if ( eventsAsString != undefined && eventsAsString != "" )
		{
			var jsonEvents = JSON.parse( eventsAsString );
			_m_arrEvents = EventUtil.AnnotateOfficialEvents( jsonEvents );
			_m_arrEvents.sort( _StartDateCompareFunction );
		}

		if ( ADD_DEBUG_EVENT == 1 )
		{
			watchEventLiveExample_01[ 'DEBUG_IGNORE_DATES_FORCE_SHOW' ] = true;
			watchEventLiveExample_02[ 'DEBUG_IGNORE_DATES_FORCE_SHOW' ] = true;
			watchEventLiveExample_03[ 'DEBUG_IGNORE_DATES_FORCE_SHOW' ] = true;
			_m_arrEvents.unshift( watchEventLiveExample_01 );
			_m_arrEvents.unshift( watchEventLiveExample_02 );
			_m_arrEvents.unshift( watchEventLiveExample_03 );
		}
	}

	function _AddToFavoriteCountAndDisplay ( element, amount )
	{
		element.m_favoriteCount += amount;

		if ( element.m_favoriteCount < 0 )
		{
			element.m_favoriteCount = 0;
		}

		var displayFavorites = FormatText.AbbreviateNumber( element.m_favoriteCount );
		element.SetDialogVariable( 'eventsched_fave_count', displayFavorites );

	}

	var openUrl = function( url )
	{
		SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser( url );
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
	}


	                   
	function _PopulateLister ()
	{
		if ( !_m_cP || !_m_cP.IsValid() )
			return;

		_CheckForPrime();

		_m_ElEventLister.RemoveAndDeleteChildren();

		var isOddEvent = true;

		for ( var idx in _m_arrEvents )
		{
			var oEvent = _m_arrEvents[ idx ];

			var startTimeUTCSeconds = -1;
			var endTimeUTCSeconds = -1;

			var startDate = new Date( 0 );
			var endDate = new Date( 0 );


			if ( 'start_date_time' in oEvent && 'seconds' in oEvent[ 'start_date_time' ] )
			{
				startTimeUTCSeconds = Number( oEvent[ 'start_date_time' ][ 'seconds' ] );
				startDate.setUTCSeconds( startTimeUTCSeconds );

				if ( 'end_date_time' in oEvent && 'seconds' in oEvent[ 'end_date_time' ] )
				{
					endTimeUTCSeconds = Number( oEvent[ 'end_date_time' ][ 'seconds' ] );
					endDate.setUTCSeconds( endTimeUTCSeconds );
				}
			}

			var curDateUTCSeconds = Date.now() / 1000;

			var isOngoing = false;


			if ( 'DEBUG_IGNORE_DATES_FORCE_SHOW' in oEvent )
			{
				isOngoing = true;
				startTimeUTCSeconds = curDateUTCSeconds;
			}
			else
			{
				                                
				if ( endTimeUTCSeconds > -1 && curDateUTCSeconds > endTimeUTCSeconds )
				{
					                          
					continue;
				}
				else if ( startTimeUTCSeconds > -1 &&
					endTimeUTCSeconds > -1 &&
					curDateUTCSeconds > startTimeUTCSeconds &&
					curDateUTCSeconds < endTimeUTCSeconds )
				{
					                                       
					isOngoing = true;
				}
				else if ( endTimeUTCSeconds == -1 && curDateUTCSeconds > startTimeUTCSeconds )
				{
					                                                     
					continue;
				}
			}


			var elYearContainer;
			var elMonthContainer;

			if ( isOngoing )
			{
				var idOngoing = "id-eventsched-ONGOING";

				var elMonthContainer = _m_ElEventLister.FindChildTraverse( idOngoing );
				if ( !elMonthContainer || !elMonthContainer.IsValid() )
				{
					elMonthContainer = $.CreatePanel( 'Panel', _m_ElEventLister, idOngoing );
					elMonthContainer.BLoadLayoutSnippet( 'snippet_eventsched_month_container' );
					elMonthContainer.AddClass( "eventsched__month-container--ongoing" );
					var elHeader = elMonthContainer.FindChildTraverse( "id-eventsched__month-container__header" );
					if ( elHeader )
					{
						elHeader.text = $.Localize( '#eventsched_ongoing' );
					}
				}

			}
			else
			{
				                
				const ID_YEAR_PREFIX = 'eventsched__year__';
				var idYear = ID_YEAR_PREFIX + startDate.getFullYear();

				elYearContainer = _m_ElEventLister.FindChildTraverse( idYear );
				if ( !elYearContainer || !elYearContainer.IsValid() )
				{
					elYearContainer = $.CreatePanel( 'Panel', _m_ElEventLister, idYear );
					elYearContainer.BLoadLayoutSnippet( 'snippet_eventsched_year_container' );
					var elYearHeader = elYearContainer.FindChildTraverse( "id-eventsched__year-container__header" );
					if ( elYearHeader )
					{
						elYearHeader.text = startDate.getFullYear();

						                           
						if ( new Date().getFullYear() == startDate.getFullYear() )
						{
							elYearHeader.visible = false;
						}
					}
				}				

				                      
				const ID_MONTH_PREFIX = 'eventsched__month__';
				var idMonth = ID_MONTH_PREFIX + ( startDate.getMonth() + 1 );

				elMonthContainer = elYearContainer.FindChildTraverse( idMonth );
				if ( !elMonthContainer || !elMonthContainer.IsValid() )
				{
					elMonthContainer = $.CreatePanel( 'Panel', elYearContainer, idMonth );
					elMonthContainer.BLoadLayoutSnippet( 'snippet_eventsched_month_container' );
					var elMonthHeader = elMonthContainer.FindChildTraverse( "id-eventsched__month-container__header" );
					if ( elMonthHeader )
					{
						var monthPaddedNumber = ( '0' + ( startDate.getMonth() + 1 ) ).slice( -2 );
						elMonthHeader.text = $.Localize( '#MonthName' + monthPaddedNumber + '_long' );                      
					}

					isOddEvent = true;
				}
			}

			                 
			  
			var elEvent = $.CreatePanel( 'Panel', elMonthContainer, oEvent[ 'event_id' ] );
			elEvent.BLoadLayoutSnippet( 'snippet_eventsched__capsule' );
			elEvent.SetHasClass( "eventsched__capsule--odd", isOddEvent );
			elEvent.SetHasClass( "eventsched__capsule--ongoing", isOngoing );
			elEvent.m_elMonthContainer = elMonthContainer;

			                 
			elEvent.m_event_id = oEvent[ 'event_id' ];

			             
			elEvent.m_favoriteCount = ( 'favorites' in oEvent ) ? Number( oEvent[ 'favorites' ] ) : 0;
			_AddToFavoriteCountAndDisplay( elEvent, 0 );                                  

			           

			
			if ( oEvent[ 'is_official'] )
			{
				var elEventBtn = elEvent.FindChildTraverse( 'id-eventsched__capsule__main__btn' );

				elEventBtn.SetPanelEvent( 'onmouseover', _OnMouseOverTextTooltip.bind( undefined, elEvent.id, $.Localize( "#eventsched_official" ) ) );
				elEventBtn.SetPanelEvent( 'onmouseout', _OnMouseOutTextTooltip );

				elEvent.AddClass( 'eventsched-official' );
			}
			else if ( oEvent[ 'is_featured' ] )
			{
				elEvent.AddClass( 'eventsched-featured' );

				var elEventBtn = elEvent.FindChildTraverse( 'id-eventsched__capsule__main__btn' );

				elEvent.SetDialogVariable( 'eventsched_fave_month', GetEventMonthString( oEvent ) );
				elEvent.SetDialogVariable( 'eventsched_featured', $.Localize( '#eventsched_featured', elEvent ) )

				elEventBtn.SetPanelEvent( 'onmouseover', _OnMouseOverTextTooltip.bind( undefined, elEvent.id, $.Localize( '{s:eventsched_featured}', elEvent ) ) );
				elEventBtn.SetPanelEvent( 'onmouseout', _OnMouseOutTextTooltip );
			}

			       

			var elLogo = elEvent.FindChildTraverse( "id-eventsched__logo" );

			if ( oEvent.hasOwnProperty( "logo_url" ) && oEvent[ 'logo_url' ] !== "" )
			{
				elLogo.SetImage( oEvent[ 'logo_url' ] );
			}
			else
			{
				elLogo.SetImage( "file://{images}/icons/ui/pro_event.svg" );
			}

			       
			elEvent.SetDialogVariable( 'eventsched_name', oEvent[ 'name' ] );


			           
			if ( 'flag_url' in oEvent )
			{
				CommonUtil.SetRegionOnLabel( oEvent[ 'country_iso' ], elEvent, false );
				                                                                   

				                                           
				  			                                                                       

				                                                                                                                           

				                                                                                                                                      
				var cc = $.Localize( '#SFUI_Country_' + oEvent[ 'country_iso' ]);

				                                     
				          
				          
				 
					                                   
					                                                
				 
				          

				elEvent.SetDialogVariable( 'eventsched_country', cc );
			}

			       

			var elStartDateLabel = elEvent.FindChildTraverse( 'id-eventsched__dates__start' );
			var elEndDateLabel = elEvent.FindChildTraverse( 'id-eventsched__dates__end' );
			var elDateHyphen = elEvent.FindChildTraverse( 'id-eventsched__dates__hyphen' );

			var startMonthString;
			var startDatePaddedDayNumber;
			var startDayString;

			var endMonthString;
			var endDatePaddedDayNumber;
			var endDayString;



			if ( startDate != undefined )
			{
				startMonthString = $.Localize( '#SFUI_Date_Format_Month' + Number( startDate.getMonth() + 1 ) );
				elStartDateLabel.SetDialogVariable( 'eventsched_date_month', startMonthString );
				startDatePaddedDayNumber = ( '0' + ( startDate.getDate() ) ).slice( -2 );
				startDayString = $.Localize( '#SFUI_Date_Format_DayOfMonth' + startDatePaddedDayNumber );
				elStartDateLabel.SetDialogVariable( 'eventsched_date_day', startDayString );
			}

			if ( endDate != undefined )
			{
				endMonthString = $.Localize( '#SFUI_Date_Format_Month' + Number( endDate.getMonth() + 1 ) );
				elEndDateLabel.SetDialogVariable( 'eventsched_date_month', endMonthString );
				endDatePaddedDayNumber = ( '0' + ( endDate.getDate() ) ).slice( -2 );
				endDayString = $.Localize( '#SFUI_Date_Format_DayOfMonth' + endDatePaddedDayNumber );

				                
				if ( endDayString == startDayString )
				{
					elEndDateLabel.visible = false;
					elDateHyphen.visible = false;
				}
				else
				{
					elEndDateLabel.SetDialogVariable( 'eventsched_date_day', endDayString );
				}
			}
			else
			{
				                    
				elEndDateLabel.visible = false;
			}

			                          

			                                                                     
			                                                                                      
			                                                                                  


			        

			var arrTeams = oEvent[ 'teams' ];

			var numKnownTeams = 0;

			var elTeamMasterContainer = elEvent.FindChildTraverse( 'id-eventsched__teams' );

			var TEAMS_PER_ROW = 16;

			if ( arrTeams )
			{

				numKnownTeams = arrTeams.length;

				for ( var idx in arrTeams )
				{
					
					var nRow = Math.floor( idx / TEAMS_PER_ROW );

					                                         
					var elTeamSubContainer = elEvent.FindChildTraverse( 'id-eventsched__teams__' + nRow );
					if ( !elTeamSubContainer || !elTeamSubContainer.IsValid() )
					{
						elTeamSubContainer = $.CreatePanel( "Panel", elTeamMasterContainer, 'id-eventsched__teams__' + nRow );
						elTeamSubContainer.AddClass( 'eventsched__teams' );
					}

					var oTeam = arrTeams[ idx ];

	  				                                                

					                                  
					var elTeamButton = $.CreatePanel( "Button", elTeamSubContainer, 'button-' + oEvent[ 'event_id' ] + "_" + oTeam[ 'name' ] );
					elTeamButton.AddClass( 'eventsched__teams__team__button' );

					var elTeamLogo = $.CreatePanel( "Image", elTeamButton, oTeam[ 'name' ], {
						clampfractionalpixelpositions: 'false'
					} );

					elTeamLogo.SetImage( oTeam[ 'logo_url' ] );
					elTeamLogo.AddClass( 'eventsched__teams__teamlogo' );
					  	                                    

					               
					  
					  

					var parms = "team_id=" + oTeam[ 'name' ] +
						"&team_name=" + oTeam[ 'name' ] +
						"&team_logo_url=" + oTeam[ 'logo_url_large' ] +
						"&team_url=" + oTeam[ 'link' ];

					var onTeamActivate_f = undefined;
					var onTeamHoverOn_f = undefined;
					var onTeamHoverOff_f = undefined;
					var xmlsrc = undefined;

					if ( "lineup" in oTeam && Object.keys( oTeam[ 'lineup' ] ).length != 0 ) 
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

							if ( 'profile_url' in oPlayer )
								parms += "&player_url" + pIdx + "=" + oPlayer[ 'profile_url' ];
						}

						if ( bHaveAnyPhoto ) 
						{
							xmlsrc = 'file://{resources}/layout/context_menus/context_menu_eventsched_team.xml';
							elTeamLogo.AddClass( 'eventsched__teams__teamlogo--plus' );

							function _OnTeamContextMenu ( xmlsrc, parms )
							{
								var elTeamContextPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters( '', '', xmlsrc, parms );
								elTeamContextPanel.AddClass( "ContextMenu_NoArrow" );
							}

							onTeamActivate_f = _OnTeamContextMenu.bind( undefined, xmlsrc, parms );
							elTeamButton.AddClass( 'has_data' );
						}

                                                                                  
						{
							                                    
							    
							   	                                                          
							   	                                                                                
							    

							                                                                    

							function OnSimpleContextMenu ( url )
							{
								var items = [];
								items.push( {
									label: $.Localize( '#eventsched_team_link' ), jsCallback: function()
									{
										StoreAPI.RecordUIEvent( "WatchEventSchedTeamLink" );
										openUrl( url );
									}
								} );

								UiToolkitAPI.ShowSimpleContextMenu( '', 'externallink', items );
							}

							if ( !onTeamActivate_f)
								onTeamActivate_f = OnSimpleContextMenu.bind( undefined, oTeam[ 'link' ] );

							xmlsrc = 'file://{resources}/layout/tooltips/tooltip_eventsched_team_simple.xml';

							onTeamHoverOn_f = _OnMouseOverCustomLayoutTooltip.bind( undefined, elTeamButton.id, 'tt_' + elTeamButton.id, xmlsrc, parms );
							onTeamHoverOff_f = _OnMouseOutCustomLayoutTooltip.bind( undefined, 'tt_' + elTeamButton.id );
						}



					}
					else
					{
						function textTooltipOn ( panelId, text )
						{
							UiToolkitAPI.ShowTextTooltip( panelId, text );
						}

						onTeamHoverOn_f = textTooltipOn.bind( undefined, elTeamButton.id, oTeam[ 'name' ] );
						onTeamHoverOff_f = function() {UiToolkitAPI.HideTextTooltip()};

						                                    
						    
						   	                                                          
						   	                                                                                
						    

						                                                                    

						function OnSimpleContextMenu ( url )
						{
							var items = [];
							items.push( {
								label: $.Localize( '#eventsched_team_link' ), jsCallback: function()
								{
									StoreAPI.RecordUIEvent( "WatchEventSchedTeamLink" );
									openUrl( url );
								}
							} );

							UiToolkitAPI.ShowSimpleContextMenu( '', 'externallink', items );
						}

						onTeamActivate_f = OnSimpleContextMenu.bind( undefined, oTeam[ 'link' ] );


					}

					if ( onTeamHoverOn_f )
						elTeamButton.SetPanelEvent( 'onmouseover', onTeamHoverOn_f );

					if ( onTeamHoverOff_f )
						elTeamButton.SetPanelEvent( 'onmouseout', onTeamHoverOff_f );

					if ( onTeamActivate_f )
						elTeamButton.SetPanelEvent( 'onactivate', onTeamActivate_f );

				}
			}

			                                       
			if ( 'number_of_teams' in oEvent )
			{
				var numOfTeams = Number( oEvent[ 'number_of_teams' ] );

				for ( var idx = numKnownTeams; idx < numOfTeams; idx++ )
				{
					var nRow = Math.floor( idx / TEAMS_PER_ROW );

					var elTeamSubContainer = elEvent.FindChildTraverse( 'id-eventsched__teams__' + nRow );
					if ( !elTeamSubContainer || !elTeamSubContainer.IsValid() )
					{
						elTeamSubContainer = $.CreatePanel( "Panel", elTeamMasterContainer, 'id-eventsched__teams__' + nRow );
						elTeamSubContainer.AddClass( 'eventsched__teams' );
					}

					var teamLogoId = 'id-eventsched__teams__' + oEvent[ 'event_id' ] + '_' + idx;
					var elTeamLogo = $.CreatePanel( "Image", elTeamSubContainer, teamLogoId );
					elTeamLogo.AddClass( 'eventsched__teams__teamlogo' );
					elTeamLogo.AddClass( 'eventsched__teams__teamlogo--unknown' );

					elTeamLogo.SetPanelEvent( 'onmouseover', _OnMouseOverTextTooltip.bind( undefined, elTeamLogo.id, $.Localize( "#eventsched_tbd" ) ) );
					elTeamLogo.SetPanelEvent( 'onmouseout', _OnMouseOutTextTooltip );

				}
			}

			elMonthContainer.AddClass( "eventsched-month-show" );
			  
			                                   
			                                 
			 
				                                                                     
				                                                                           

				                                                                                     
				                                                                                           

				                                                 
				 
					           
						                                                     
						      
					
					              
						                                                  
						      
				 
			 
			  

			      
			if ( 'event_page_url' in oEvent )
			{

				var url = oEvent[ 'event_page_url' ];
				var elLinkBtn = elEvent.FindChildTraverse( "id-eventsched__capsule__main__btn" );

				function OnSimpleContextMenu ( url )
				{
					var items = [];
					items.push( {
						label: $.Localize( '#eventsched_event_link' ), jsCallback: function()
						{
							StoreAPI.RecordUIEvent( "WatchEventSchedEventLink" );
							openUrl( url );
						}
					} );

					UiToolkitAPI.ShowSimpleContextMenu( '', 'externallink', items );
				}

				elLinkBtn.SetPanelEvent( 'onactivate', OnSimpleContextMenu.bind( undefined, url ) );
			}

			                  
			var elFavoriteBtn = elEvent.FindChildTraverse( 'id-capsule__main__favorite' );
			if ( elFavoriteBtn && elFavoriteBtn.IsValid() )
			{
				elFavoriteBtn.enabled = false;

				var tooltipText = _m_IsPrime ? "#eventsched_favorite_tooltip_prime" : "#eventsched_favorite_tooltip_not_prime";

				var onMouseOver = function( id, tooltipText ) {UiToolkitAPI.ShowTextTooltip( id, tooltipText );};
				elFavoriteBtn.SetPanelEvent( 'onmouseover', onMouseOver.bind( undefined, oEvent[ 'event_id' ], tooltipText ) );
				elFavoriteBtn.SetPanelEvent( 'onmouseout', function() {UiToolkitAPI.HideTextTooltip();} );

				if ( _m_arrFavorites )
				{
					var onActivate = function( element, btn )
					{
						_DisplayAsFavorite( element, btn.IsSelected() );

						TournamentsAPI.SetTournamentFavorite( Number( element.m_event_id ), btn.IsSelected() );

						if ( btn.IsSelected() )
						{
							_m_arrFavorites.push( Number( element.m_event_id ) );
						}
						else
						{
							var idx = _m_arrFavorites.indexOf( Number( element.m_event_id ) );
							if ( idx !== -1 )
								_m_arrFavorites.splice( idx, 1 );
						}

						$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.sidemenu_select', 'MOUSE' );
					}

					elFavoriteBtn.SetPanelEvent( 'onactivate', onActivate.bind( undefined, elEvent, elFavoriteBtn ) );

					elFavoriteBtn.enabled = _m_IsPrime;
				}
			}

			          	
			if ( 'live_matches' in oEvent && oEvent[ 'live_matches' ].length > 0 )
			{
				var elMatchContainer = elEvent.FindChildTraverse( 'id-eventsched__capsule-container__matches' );
				elMatchContainer.RemoveClass( 'hidden' );

				for ( var idx in oEvent[ 'live_matches' ] )
				{
					var oMatch = oEvent[ 'live_matches' ][ idx ];

					var elMatch = $.CreatePanel( "Panel", elMatchContainer, oMatch[ 'match_id' ] );
					elMatch.BLoadLayout( 'file://{resources}/layout/watchmatchtile.xml', false, false );
					elMatch.Data().isofficial = oEvent[ 'is_official'];

					function _GetTeam ( num )
					{
						var arrTeams = oEvent[ 'teams' ];

						if ( !arrTeams )
							return undefined;

						{
							for ( var idx in arrTeams )
							{
								var oTeam = arrTeams[ idx ];

								var matchTeamName = num == 1 ? 'team1_name' : 'team2_name';

								if ( oTeam[ 'name' ] == oMatch[ matchTeamName ] )
									return oTeam;
							}
						}

						return undefined;
					}

					                                    
					                                                                       
				}
			}
			else if ( isOngoing )
			{
				var elMatchContainer = elEvent.FindChildTraverse( 'id-eventsched__capsule-container__matches' );
				elMatchContainer.RemoveClass( 'hidden' );

				var elNoLiveMatchNotice = elMatchContainer.FindChildTraverse( 'id-no-live-matches-notice' );
				elNoLiveMatchNotice.RemoveClass( 'hidden' );
			}

			isOddEvent = !isOddEvent;
		}

		_UpdateAllFavorites();
	}


	return {
		Init: _Init,
		Refresh: _EventsReceived,

		  
		                                                
		  
	};

} )();

( function()
{
	mainmenu_watch_eventsched.Init();


} )();