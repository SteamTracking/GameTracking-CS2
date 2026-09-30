'use strict';

var PopupTournamentControlRoom = ( function()
{
	var m_eventid = '';
	var m_type = '';
	var m_status = 'none';
	var m_myXuid = MyPersonaAPI.GetXuid();
	var m_cp = $.GetContextPanel();
	var m_scheduled = null;

	var _Init = function()
	{
		m_eventid = $.GetContextPanel().GetAttributeString( 'eventid', '' );

		var type = $.GetContextPanel().GetAttributeString( 'type', '' );
		var aTypes = type.split( ',' );
		m_type = aTypes[0];

		_SetTitle( aTypes[ 0 ] );
		_MakeTabs( aTypes );

		$( '#id-popup-tournamentcontrolroom-refresh-button' ).visible = false;

		                                            
		TournamentsAPI.RequestManagementMatchList( m_eventid );
		_StartScheduledCountdown();
	};

	function _StartScheduledCountdown()
	{
		if ( m_scheduled )
		{
			$.CancelScheduled( m_scheduled );
			m_scheduled = null;
		}

		m_scheduled = $.Schedule( 15.0, function() {
			m_scheduled = null;
			if ( !m_cp || !m_cp.IsValid() ) return;
			if ( m_status !== 'none' ) return;
			
			m_status = 'error';
			_Updatetournamentcontrolroom( m_type );
		} );
	}

	function _WaitForReloadedDataEvent()
	{
		m_status = 'none';
		_Updatetournamentcontrolroom( m_type );
		_StartScheduledCountdown();
	}

	var _ManagementMatchListReceived = function( eventid )
	{
		if ( m_eventid !== eventid )
			return;

		if ( m_scheduled )
		{
			$.CancelScheduled( m_scheduled );
			m_scheduled = null;
		}

		m_status = 'ready';
		_Updatetournamentcontrolroom( m_type );
	}

	var _SetTitle = function( type )
	{
		var titleOverride = $.GetContextPanel().GetAttributeString( 'titleoverride', '' );
		var title = titleOverride !== '' ? titleOverride : '#CSGO_' + type;
		$.GetContextPanel().FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-title' ).text = $.Localize( title );
	};

	var _MakeTabs = function( aTypes )
	{
		if ( aTypes.length <= 1 )
		{
			m_type = aTypes[ 0 ];
			_Updatetournamentcontrolroom( aTypes[ 0 ] );
			return;
		}

		var elNavBar = $.GetContextPanel().FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-navbar' );
		elNavBar.RemoveClass( 'hidden' );

		var elTabs = elNavBar.FindChild( 'id-popup-tournamentcontrolroom-tabs' );

		for ( var i = 0; i < aTypes.length; i++ )
		{
			var elTab = $.CreatePanel( "RadioButton", elTabs, aTypes[ i ] );
			elTab.BLoadLayoutSnippet( "tournamentcontrolroom-tab" );
			elTab.SetPanelEvent(
				'onactivate',
				_Updatetournamentcontrolroom.bind( undefined, aTypes[ i ] )
			);

			elTab.FindChildInLayoutFile( 'tournamentcontrolroom-tab-label' ).text = $.Localize( '#CSGO_' + aTypes[ i ] + '_tab' );
		}
		
		$.DispatchEvent( "Activated", elTabs.Children()[ 0 ], "mouse" );
	};

	var _Updatetournamentcontrolroom = function( type )
	{
		                                                               
		m_type = type;

		                                                     

		var elStatus = m_cp.FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-loading' );
		var elData = m_cp.FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-nodata' );
		var eltournamentcontrolroomList = m_cp.FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-list' );

		if ( "none" == m_status )
		{
			elStatus.SetHasClass( 'hidden', false );
			elData.SetHasClass( 'hidden', true );
			eltournamentcontrolroomList.SetHasClass( 'hidden', true );
		}

		if ( "error" === m_status )
		{
			elData.SetHasClass( 'hidden', false );
			elStatus.SetHasClass( 'hidden', true );
			eltournamentcontrolroomList.SetHasClass( 'hidden', true );
		}
	
		if ( "ready" == m_status )
		{
			var count = TournamentsAPI.GetManagementMatchListCount( m_eventid );
			
			eltournamentcontrolroomList.SetHasClass( 'hidden', false );
			elStatus.SetHasClass( 'hidden', true );
			elData.SetHasClass( 'hidden', true );

			_FillOutEntries( type, count );
		}
	};

	function _AddDropdownOption( elDropdown, entryID, strText, strData, strSelectedData )
	{
		var newEntry = $.CreatePanel( 'Label', elDropdown, entryID, { data: strData } );
		newEntry.text = strText;
		elDropdown.AddOption( newEntry );

		               
		if ( strSelectedData === strData )
		{
			elDropdown.SetSelected( entryID );
		}
	}

	var _FillOutEntries = function( type, count )
	{
		var elParent = m_cp.FindChildInLayoutFile( 'id-popup-tournamentcontrolroom-entries' );
		elParent.RemoveAndDeleteChildren();

		  
		                    
		  
		{
			var strTournament = MyPersonaAPI.GetMyOfficialTournamentName();
			var strCurrentStage = '';

			var el = $.CreatePanel( 'Panel', elParent, 'new' );
			el.BLoadLayoutSnippet( 'tournamentcontrolroom-entry' );
			el.SetHasClass( 'newentry', true );

			  
			                 
			  
			var elStageDropdown = el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-edit-type' );
			elStageDropdown.RemoveAllOptions();
			_AddDropdownOption( elStageDropdown, 'PickStage', $.Localize( '#SFUI_Tournament_Stage' ), '', strCurrentStage );
			var stageCount = CompetitiveMatchAPI.GetTournamentStageCount( strTournament );
			for ( var i = 0; i < stageCount; i++ )
			{
				var strStage = CompetitiveMatchAPI.GetTournamentStageNameByIndex( strTournament, i );
				_AddDropdownOption( elStageDropdown, 'stage_' + i, strStage, strStage, strCurrentStage );
			}

			  
			               
			  
			var elMapDropdown = el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-edit-map' );
			elMapDropdown.RemoveAllOptions();
			_AddDropdownOption( elMapDropdown, 'PickMap', $.Localize( '#SFUI_Tournament_Pick_Map_Title' ), '', '' );
			var mymaps = TournamentsAPI.GetManagementMapsJSO( strTournament );
			for ( const mmap in mymaps )
			{
				_AddDropdownOption( elMapDropdown, 'map_' + mymaps[ mmap ], $.Localize( '#SFUI_Map_' + mmap ), mmap, '' );
			}

			  
			                 
			  
			for ( var kk = 0; kk < 2; ++ kk )
			{
				var elTeamDropdown = el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-edit-team' + kk );
				elTeamDropdown.RemoveAllOptions();
				_AddDropdownOption( elTeamDropdown, 'PickOpponent', $.Localize( '#SFUI_Tournament_Pick_Opponent' ), '', '' );
				var teamCount = CompetitiveMatchAPI.GetTournamentTeamCount( strTournament );
				for ( var i = 0; i < teamCount; i++ )
				{
					var strTeam = CompetitiveMatchAPI.GetTournamentTeamNameByIndex( strTournament, i );
					_AddDropdownOption( elTeamDropdown, 'team_' + i, strTeam, strTeam, '' );
				}
			}

			  
			                       
			  
			for ( var kk = 0; kk < 2; ++ kk )
			{
				var elScoreDropdown = el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-edit-score' + kk );
				elScoreDropdown.RemoveAllOptions();
				_AddDropdownOption( elScoreDropdown, 'PickScore', $.Localize( '#teams_pip_rounds_won' ), '', '' );
				for ( var i = 0; i < 69; i++ )
				{
					_AddDropdownOption( elScoreDropdown, 'teamscore'+kk+'id' + i, '' + i, '' + i, '' );
				}
			}

			el.FindChildInLayoutFile( 'ButtonAdd' ).SetPanelEvent( 'onactivate', function() {
				var fnGetDropDownData = function( elid ) {
					var eldd = $.GetContextPanel().FindChildInLayoutFile( elid );
					if ( !eldd ) return '';
					if ( !eldd.GetSelected() ) return '';
					return eldd.GetSelected().GetAttributeString( 'data', '' );
				};

				TournamentsAPI.RequestAddManagementMatch( m_eventid, 'add',
					                                                     
					'[' + fnGetDropDownData( 'popup-tournamentcontrolroom-edit-score0' )
					+ ':' + fnGetDropDownData( 'popup-tournamentcontrolroom-edit-score1' )
					+ ']@' + ( new Date().getTime() ),
					'1',
					fnGetDropDownData( 'popup-tournamentcontrolroom-edit-type' ),
					fnGetDropDownData( 'popup-tournamentcontrolroom-edit-map' ),
					fnGetDropDownData( 'popup-tournamentcontrolroom-edit-team0' ),
					fnGetDropDownData( 'popup-tournamentcontrolroom-edit-team1' )
				);
				
				var btn = $.GetContextPanel().FindChildInLayoutFile( 'ButtonAdd' );
				if ( btn ) btn.visible = false;
				$.Schedule( 1.0, function() {
					if ( btn && btn.IsValid() ) btn.visible = true;
				} )
			} );
		}

		  
		                                                    
		  
		for ( var i = 0; i < count; i++ )
		{
			var jso = TournamentsAPI.GetManagementMatchJSO( m_eventid, i );
			if ( !jso ) continue;
			if ( !jso.id ) continue;

			var fnSetFlags = function( matchid, flags ) {
				TournamentsAPI.RequestAddManagementMatch( m_eventid, 'edit', matchid, flags );
				_WaitForReloadedDataEvent();
			};

			  
			                                         
				                                           
				                                                                                                          
			  
			  

			var el = $.CreatePanel( 'Panel', elParent, jso.id );
			el.BLoadLayoutSnippet( 'tournamentcontrolroom-entry' );

			                                                                                      
			el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-team0' ).text = jso.team0;
			el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-team1' ).text = jso.team1;
			el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-score' ).text = jso.info;

			                                 
			if ( jso.pwd.length > 6 && jso.pwd[0] == '[' )
			{
				let a = jso.pwd.split( ']' );
				a = ( ( a && a.length > 0 ) ? a[0].slice( 1 ) : '0:0' ).split( ':' );
				if ( a.length == 2 )
				{
					el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-score0' ).text = '' + parseInt( a[0] );
					el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-score1' ).text = '' + parseInt( a[1] );
				}
			}

			var strStatus = '';
			if ( !jso.updates )
			{
				if ( jso.flags & 1 )
					strStatus = '#Store_Price_New';
				else
					strStatus = '#SFUI_Settings_Disabled';
			}
			else if ( jso.updates === 'ongoing' )
			{
				if ( jso.flags & 1 )
				{
					strStatus = '#SFUI_ScoreControl_OngoingMatch';
				}
				else
				{
					strStatus = '#SFUI_ScoreControl_PausedScore';

					el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-updates' ).visible = false;
					el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-score' ).visible = false;

					if ( jso.info )
					{
						let parts = jso.info.split( ':' );
						if ( ( parts.length === 2 )
							&& ( parseInt( parts[0] ) >= 13 || parseInt( parts[1] ) >= 13 )
							&& ( parseInt( parts[0] ) > parseInt( parts[1] ) || parseInt( parts[0] ) < parseInt( parts[1] ) ) )
						{
							let elBtn = el.FindChildInLayoutFile( 'ButtonFinalize');
							elBtn.SetPanelEvent( 'onactivate',
								fnSetFlags.bind( null, jso.id, '1073741824' )                                     
							);
							elBtn.RemoveClass( 'hidden' );
						}
					}
				}
			}
			else if ( jso.updates === 'final' )
			{
				strStatus = '#SFUI_Scoreboard_Final';
			}
			
			if ( strStatus )
				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-updates' ).text = $.Localize( strStatus );

			                
			var sValue = jso.stage;
			                                          
			                                        
			el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-type' ).text = sValue;
			el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-map' ).text = jso.map;

			function fnDelayAction( str )
			{
				let btn = el.FindChildInLayoutFile( str );
				btn.enabled = false;
				$.Schedule( 1.0, function() { if ( btn && btn.IsValid() ) btn.enabled = true; } );
				return btn;
			}

			if ( i % 2 === 0 )
				el.AddClass( 'background' );

			if ( jso.updates === 'final' )
			{
				el.FindChildInLayoutFile( 'IconButtonsRow').visible = false;
			}
			else if ( jso.flags & 1 )
			{
				el.AddClass( 'green' );

				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-remove').visible = false;

				fnDelayAction( 'popup-tournamentcontrolroom-entry-ignore').SetPanelEvent( 'onactivate',
					fnSetFlags.bind( null, jso.id, '0' )
				);

				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-recover').visible = false;

				fnDelayAction( 'popup-tournamentcontrolroom-entry-makelive').SetPanelEvent( 'onactivate',
					fnSetFlags.bind( null, jso.id, '1073741823' )                                           
				);
			}
			else if ( jso.updates === 'ongoing' )
			{
				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-remove').visible = false;
				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-ignore').visible = false;
				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-recover').visible = false;
				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-makelive').visible = false;
			}
			else
			{
				fnDelayAction( 'popup-tournamentcontrolroom-entry-remove').SetPanelEvent( 'onactivate',
					fnSetFlags.bind( null, jso.id, '1073741822' )                                              
				);

				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-ignore').visible = false;

				fnDelayAction( 'popup-tournamentcontrolroom-entry-recover').SetPanelEvent( 'onactivate',
					fnSetFlags.bind( null, jso.id, '1' )
				);

				el.FindChildInLayoutFile( 'popup-tournamentcontrolroom-entry-makelive').visible = false;
			}
		}
	};

	var _Refresh = function( type )
	{
		if ( m_type === type )
		{
			_Updatetournamentcontrolroom( type );
			return;
		}
	};

	var _Close = function()
	{
		                   
		$.DispatchEvent( 'UIPopupButtonClicked', '' );
	};

	return {
		Init: _Init,
		ManagementMatchListReceived: _ManagementMatchListReceived,
		Refresh: _Refresh,
		Close: _Close
	};

})();

(function(){

	$.RegisterForUnhandledEvent( 'PanoramaComponent_Tournaments_ManagementMatchListReceived', PopupTournamentControlRoom.ManagementMatchListReceived );
	                                                                
})();