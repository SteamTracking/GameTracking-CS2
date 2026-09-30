'use strict';

var mainmenu_watch_tournament = (function () {

	var _m_activeTab;
	var _m_bInitializedTournamentOnce = false;
	var _m_matchesTab;

	var _NavigateToTab = function( tab, tournament_id, oInitData = null )
	{
		if ( tab !== 'JsTournamentMatches' )
		{
			var restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
			if ( restrictions !== false )
			{
				LicenseUtil.ShowLicenseRestrictions( restrictions );
				if ( _m_matchesTab )
				{
					_m_matchesTab.checked = true;
				}
				_NavigateToTab( "JsTournamentMatches", tournament_id );
				return false;
			}
		}

		                                                                 
		var pressedTab = $.FindChildInContext( '#' + tab );
		if ( !pressedTab && oInitData )
		{
			                                                               
			                                                                   
			                                                                                            

			pressedTab = $.CreatePanel( 'Panel', $.FindChildInContext( '#JsTournamentContainer' ), tab );
			                                                      

			pressedTab.BLoadLayout('file://{resources}/layout/tournaments/pickem_' + oInitData.xmltype + '.xml', false, false );
			pressedTab.RegisterForReadyEvents( true );
			pressedTab.SetReadyForDisplay( false );

			                                                                      
			if ( typeof pressedTab._oPickemData !== 'object' )
			{
				pressedTab._oPickemData = {};
			}

			pressedTab._oPickemData.oInitData = oInitData;
			PickemCommon.Init( pressedTab );
			_AddEventHandlers( pressedTab );
		}

		if ( _m_activeTab !== pressedTab )
		{
			if ( _m_activeTab )
			{
				                                                                     
				                                                                                          
				                          
				                                   
				    
				   	                                              
				    
				
				_m_activeTab.AddClass( 'tournament-content-container--hidden' );
			}

			_m_activeTab = pressedTab;
			_m_activeTab.RemoveClass( 'tournament-content-container--hidden' );

			_m_activeTab.visible = true;
			_m_activeTab.SetReadyForDisplay( true );
		}

		if ( _m_activeTab.id === "JsTournamentMatches" )
		{
			_RefreshMatchesTab(tournament_id );
		}
	};

	var _RefreshMatchesTab = function( tournament_id )
	{
		matchList.UpdateMatchList( _m_activeTab, tournament_id );
	};

	var _RefreshActivePage = function( tournament_id )
	{
		if ( _m_activeTab.id === "JsTournamentMatches" )
		{
			_RefreshMatchesTab( tournament_id );
			return;
		}
		
		PickemCommon.RefreshData( _m_activeTab );
	}

	var _AddEventHandlers = function( elPanel )
	{
		$.RegisterEventHandler( 'ReadyForDisplay', elPanel, PickemCommon.ReadyForDisplay.bind( undefined, elPanel ) );
		$.RegisterEventHandler( 'UnreadyForDisplay', elPanel, PickemCommon.UnregisterEvents.bind( undefined, elPanel )  );

		                                                                          
		                                                       
		elPanel.OnPropertyTransitionEndEvent = function ( panelName, propertyName )
		{
			if( elPanel.id === panelName && propertyName === 'opacity' )
			{
				                                         
				if( elPanel.visible === true && elPanel.BIsTransparent() )
				{
					                                               
					elPanel.visible = false;
					elPanel.SetReadyForDisplay( false );
					return true;
				}
			}

			return false;
		};

		$.RegisterEventHandler( 'PropertyTransitionEnd', elPanel, elPanel.OnPropertyTransitionEndEvent );
	};

	function _UpdateMatchList( listId )
	{
		if ( _m_activeTab && ( _m_activeTab.tournament_id === listId ) )
		{
			_RefreshActivePage(listId);
		}
	}

	                        
	var _PopulateTournamentNavBarButtons = function( tournament_id, elTournamentTab )
	{
		var tournamentNumber = PickemCommon.GetTournamentIdNumFromString( tournament_id );
		var navBarPanel = elTournamentTab.FindChildTraverse( 'content-navbar__tabs' );

		if ( !elTournamentTab.hasSetUpNavBar )
		{

			var _CreateNavBarButton = function( buttonId, buttonTitle, targetTab, oInitData = null, isSelected = false )
			{
				                                                                                                 
				
				var elButton = $.CreatePanel( 'RadioButton', navBarPanel, buttonId, {
					selected: isSelected,
					group: 'TournamentNavBar' + tournamentNumber
				} );

				$.CreatePanel( 'Label', elButton, '', {
					text: buttonTitle,
					hittest: false
				} );

				elButton.SetPanelEvent( 'onactivate', _NavigateToTab.bind( undefined, targetTab, tournament_id, oInitData ) );

				return elButton;
			};

			var isCurrentTourament = ( tournamentNumber === g_ActiveTournamentInfo.eventid );

			var restrictions = LicenseUtil.GetCurrentLicenseRestrictions();
			var bDefaultToMatches = ( ( restrictions === false ) && isCurrentTourament ) ? false : true;

			                                                
			
			                           
			if ( tournamentNumber <= g_ActiveTournamentInfo.eventid && tournamentNumber >= 13 )
			{
				_CreateNavBarButton( 
					'id-nav-pick-prelims', 
					$.Localize( '#CSGO_Fantasy_PickEm_Qualifier_Title' ), 
					'JsPickemPrelims', 
					{	
						tournamentid: tournament_id, 
						sectionindex: 0, 
						xmltype: 'group',
						oPickemType: PickEmGroup
					} ,
					!bDefaultToMatches
				);
				_CreateNavBarButton( 'id-nav-pick-group', $.Localize( '#CSGO_Fantasy_PickEm_Groups_Title' ), 'JsPickemGroup', 
					{	
						tournamentid: tournament_id, 
						sectionindex: 1, 
						xmltype: 'group',
						oPickemType: PickEmGroup
					},
					!bDefaultToMatches
				);

				_CreateNavBarButton( 'id-nav-pick-playoffs', $.Localize( '#CSGO_Fantasy_PickEm_Playoffs_Title' ), 'JsPickemPlayoffs', 
					{	
						tournamentid: tournament_id, 
						sectionindex: 2, 
						xmltype: 'bracket',
						oPickemType: PickEmBracket
					},
					!bDefaultToMatches
				);
			}

			if ( tournamentNumber === 12 )
			{
				_CreateNavBarButton( 'id-nav-pick-group', $.Localize( '#CSGO_Fantasy_PickEm_Groups_Title' ), 'JsPickemGroup', 
					{	
						tournamentid: tournament_id, 
						sectionindex: 0, 
						xmltype: 'group',
						oPickemType: PickEmGroup
					},
					!bDefaultToMatches
				);

				_CreateNavBarButton( 'id-nav-pick-playoffs', $.Localize( '#CSGO_Fantasy_PickEm_Playoffs_Title' ), 'JsPickemPlayoffs', 
					{	
						tournamentid: tournament_id, 
						sectionindex: 1, 
						xmltype: 'bracket',
						oPickemType: PickEmBracket
					},
					!bDefaultToMatches
				);
			}

			         
			_m_matchesTab = _CreateNavBarButton( 'id-nav-matches', $.Localize( '#CSGO_Watch_Tournament_Matches_T2' ), 'JsTournamentMatches', null, bDefaultToMatches );


			                                
			                                                            
			    
			   	                                                                                                                     
			   		 	
			   			                             
			   			                 
			   			                   
			   			                        
			   		    
			   	                                                                                                              
			   		 	
			   			                             
			   			                 
			   			                 
			   			                        
			   		    
			    

			          
			             
			                                                      
			 
				                                                                                                   
			 

			              
			                                                      
			 
				                                                                                                            
			 

			          
			elTournamentTab.hasSetUpNavBar = true;
		}
	};

	                                                                
	var _InitializeTournamentsPage = function( tournament_id )
	{
		                                                                                                                            
		if ( _m_bInitializedTournamentOnce )
			return;

        var elParentPanel = _GetParentPanel(tournament_id);
        if ( !elParentPanel )
            return;

		_m_bInitializedTournamentOnce = true;
		elParentPanel.SetDialogVariable( 'tournament_name', $.Localize( "#CSGO_Tournament_Event_Name_" + tournament_id.split( ':' )[ 1 ] ) );
			
		                                                                                                      
		elParentPanel.FindChildInLayoutFile( "id-tournament-title-bar" ).visible = elParentPanel.id !== 'JsActiveTournament';

		_PopulateTournamentNavBarButtons( tournament_id, elParentPanel );
		elParentPanel.FindChildInLayoutFile( "JsTournamentMatches" ).tournament_id = tournament_id;
		elParentPanel.isInitialized = true;
			
		var tournamentNumber = PickemCommon.GetTournamentIdNumFromString( tournament_id );
		var isCurrentTourament = ( tournamentNumber === g_ActiveTournamentInfo.eventid );

		var navBarPanel = elParentPanel.FindChildTraverse( 'content-navbar__tabs' );

		if ( isCurrentTourament )
		{
			var tabIdToActivate = 'id-nav-pick-prelims';

			$.DispatchEvent( "Activated", navBarPanel.FindChildInLayoutFile( tabIdToActivate ), "mouse" );	
		}
		else
		{
			$.DispatchEvent( "Activated", navBarPanel.FindChildInLayoutFile( 'id-nav-matches' ), "mouse" );
		}

		_SetUpTournamentInfoLink( elParentPanel, tournament_id );
		_SetUpTournamentControlRoom( elParentPanel, tournament_id );
		_SetStyleOverridesForTournament( elParentPanel, tournamentNumber )
	};

	var _SetStyleOverridesForTournament = function( elParentPanel, tournamentNumber )
	{
		if ( tournamentNumber >= 15 )
		{
			                                                                           
			elParentPanel.AddClass( 'tournament-has-challenges' );
		}
	};

	var _GetParentPanel = function( tournament_id )
	{
		                                           
		                                               
		
		var elParent =  $( '#tournament_content_' + tournament_id );
		if ( elParent )
		{
			return elParent;
		}

		elParent =  $( '#JsActiveTournament' );
		if ( elParent )
		{
			return elParent;
		}
	};

	var _SetUpTournamentInfoLink = function( elPanel, tournament_id )
    {
        var elLink = elPanel.FindChildInLayoutFile( 'JsTournamentInfoLink' );
		var olinks = {
			26: "https://store.steampowered.com/sale/csmajorcologne2026",
			25: "https://store.steampowered.com/sale/csmajorbud2025",
			24: "https://store.steampowered.com/sale/csmajoraus2025",
			23: "https://store.steampowered.com/sale/csmajorsha2024",
			22: "https://store.steampowered.com/sale/csmajorcph2024",
			21: "https://store.steampowered.com/sale/csgoparis2023",
			20: "https://store.steampowered.com/sale/csgorio2022",
			19: "https://store.steampowered.com/sale/csgomajorantwerp2022",
			18: "https://store.steampowered.com/sale/csgostockholm",
			16: "https://csgomajor.starladder.com/",
			15: "https://www.intelextrememasters.com/season-13/katowice/schedule/",
            14: "https://www.faceitmajor.com/",
            13: "http://www.eleague.com/major-2018",
            12: "https://major.pglesports.com/"
        };

        var tournamentNum = PickemCommon.GetTournamentIdNumFromString( tournament_id );

		if ( olinks.hasOwnProperty( tournamentNum ) )
		{
			var link = olinks[ tournamentNum ];
			
			elLink.SetPanelEvent( 'onactivate', function() { SteamOverlayAPI.OpenURL( link ); } );
            return;
        }

        elLink.visible = false;
	};
	
	var _SetUpTournamentControlRoom = function( elPanel, tournament_id )
    {
        var elBtn = elPanel.FindChildInLayoutFile( 'JsTournamentOperatorBtn' );
		var tournamentNum = PickemCommon.GetTournamentIdNumFromString( tournament_id );
		var bCanControl = false;
		if ( MyPersonaAPI.GetMyOfficialTournamentName() &&                                                       
			tournamentNum === NewsAPI.GetActiveTournamentEventID() )
		{
			bCanControl = true;
			elBtn.SetPanelEvent( 'onactivate', function() {
				UiToolkitAPI.ShowCustomLayoutPopupParameters(
					'',
					'file://{resources}/layout/popups/popup_tournament_controlroom.xml',
					'type=matches' +
					'&' + 'eventid=' + tournament_id +
					'&' + 'titleoverride=#Control',
					'none'
				);
			} );
		}
		elBtn.SetHasClass( 'hidden', !bCanControl );
    };

	                                                       
	var _CloseSubMenu = function()
	{
		$.DispatchEvent( 'CloseSubMenuContent' );
	};

	function _Refresh( tabid )
	{
		if ( tabid === 'JsWatch' )
		{
			if ( _m_activeTab )
			{
				if ( _m_activeTab.activeMatchInfoPanel )
				{
					matchList.ReselectActiveTile( _m_activeTab );
				}
			}
		}
	}

	var _RefreshBtnPress = function ()
	{
		_RefreshActivePage( _m_activeTab.tournament_id );
	};


	function _Init()
	{
		_m_activeTab = undefined;
		$.RegisterEventHandler( "InitializeTournamentsPage", $.GetContextPanel(), _InitializeTournamentsPage );
		$.RegisterForUnhandledEvent( "RefreshPickemPage", _RefreshActivePage );
		$.RegisterForUnhandledEvent( "PanoramaComponent_MatchList_StateChange", _UpdateMatchList );
		$.RegisterForUnhandledEvent( "MainMenuTabShown", _Refresh );
	}

	return {
		CloseSubMenu: _CloseSubMenu,
		NavigateToTab: _NavigateToTab,
		Init: _Init,
		RefreshActivePage: _RefreshActivePage,
		RefreshBtnPress: _RefreshBtnPress
	};

})();

(function()
{
	mainmenu_watch_tournament.Init();
})();