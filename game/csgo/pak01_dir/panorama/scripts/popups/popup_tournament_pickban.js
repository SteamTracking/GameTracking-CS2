'use strict';

var PopupTournamentPickBan = ( function ()
{
	var _m_thisPanel = null;
    var m_strTournament = "";
    var m_strTeamID = "";
    var m_pickbanTiles = [];
    var m_availableMaps = [];

	var _Init = function ()
    {
		_m_thisPanel = $.GetContextPanel();

        m_strTournament = MyPersonaAPI.GetMyOfficialTournamentName();
        m_strTeamID = MyPersonaAPI.GetMyOfficialTeamID();

        _DraftUpdate();
    }

    var _DraftUpdate = function ()
    {
        var numStartTeamID = MatchDraftAPI.GetFirstVetoTeamID();
        
        if ( numStartTeamID == undefined )
            return
        
                             
        $.GetContextPanel().SetHasClass( "pickban__initial-pick", false );
        $.GetContextPanel().SetHasClass( "pickban__initial-wait", false );
        $.GetContextPanel().SetHasClass( "pickban__draft", false );
        
                                                                                                           
        if ( numStartTeamID == 0 )
        {
            numStartTeamID = MatchDraftAPI.GetTeamID( 0 );
            _SetUpInitalVotePanel( numStartTeamID );
        }
        else
        {
            _ChooseTypeOfLayout();   
        }
    }
    
    var _SetUpInitalVotePanel = function ( numStartTeamID )
    {
        var isPicker = m_strTeamID == numStartTeamID;
        if ( isPicker )
        {
            var elText = $.GetContextPanel().FindChildInLayoutFile( 'InitialPickText' );
            var numMapsCount = MatchDraftAPI.GetMapsCount();
            var strLoc = numMapsCount == 1 ? "#SFUI_InitalPick_Maps_Picks_One" : "#SFUI_InitalPick_Maps_Picks_Three";
            elText.SetLocString( strLoc );
        }

        $.GetContextPanel().SetHasClass( "pickban__initial-pick", isPicker );
        $.GetContextPanel().SetHasClass( "pickban__initial-wait", !isPicker );
    }

    var _ChooseTypeOfLayout = function ()
    {
        var numMapsCount = MatchDraftAPI.GetMapsCount();
        var numEntriesCount = MatchDraftAPI.GetDraftEntriesCount();

        var allCompetitiveMaps = GameTypesAPI.GetMapGroupAttributeSubKeys( "mg_active", "maps" );
        m_availableMaps = allCompetitiveMaps.split(",");
            
                                     
        var numActiveIndex = MatchDraftAPI.GetDraftEntryActiveIndex();
        
        if ( MatchDraftAPI.GetDraft() == "completed" )
        {
            numActiveIndex = numEntriesCount;
        }

        function SetTeamLogo( elOption, numTeamID )
        {
            if ( numTeamID != undefined && numTeamID != 0 )
            {
                var elTeamLogo = elOption.FindChildTraverse( 'TeamLogo' );
				var strTeamTag = CompetitiveMatchAPI.GetTournamentTeamTagByID( m_strTournament, numTeamID );
				if ( !strTeamTag )
				{
					strTeamTag = PredictionsAPI.GetTeamTag( numTeamID );
				}
                elTeamLogo.SetImage( 'file://{images}/tournaments/teams/' + strTeamTag + '.svg' );
            }
        }

        var _GetTile = function( i, strTileType, strMapName, numTeamID, numCtTeamID, numTeamPickingSideID )
        {
            var strTileName = 'Tile' + i;
            if ( strTileName in m_pickbanTiles )
                return m_pickbanTiles[ strTileName ];
            
                                              
            var elDraftContainer = $.GetContextPanel().FindChildInLayoutFile( 'DraftContainer' );
            var elNewTile = $.CreatePanel( 'Panel', elDraftContainer, 'Tile' + i );
            elNewTile.AddClass( 'pickban_draft_tile' );
            if ( strTileType == 'veto' )
            {
                var elVetoMap = $.CreatePanel( 'Panel', elNewTile, 'vetomap' )
                elVetoMap.BLoadLayoutSnippet( "PickBanOptionSnippet" );
                elVetoMap.AddClass( 'pickban__map' );
                SetTeamLogo( elVetoMap, numTeamID );

                elNewTile.AddClass( 'pickban__veto' );
            }
            else
            {
                var elPickMap = $.CreatePanel( 'Panel', elNewTile, 'pickmap' )
                elPickMap.BLoadLayoutSnippet( "PickBanOptionSnippet" );
                elPickMap.AddClass( 'pickban__map' );
                SetTeamLogo( elPickMap, numTeamID );

                var elPickTeam = $.CreatePanel( 'Panel', elNewTile, 'pickteam' )
                elPickTeam.BLoadLayoutSnippet( "PickBanOptionSnippet" );
                elPickTeam.AddClass( 'pickban__team' );
                SetTeamLogo( elPickTeam, numTeamPickingSideID );

                elNewTile.AddClass( 'pickban__pick' );
            }
            m_pickbanTiles[ strTileName ] = elNewTile;
            return elNewTile;
        }

        function AddDropdownOption( elDropdown, entryID, strText, strData, strSelectedData )
        {
            var newEntry = $.CreatePanel( 'Label', elDropdown, entryID, { data: strData } );
            newEntry.text = strText;
            elDropdown.AddOption( newEntry );

                           
            if ( strSelectedData === strData )
            {
                elDropdown.SetSelected( entryID );
            }
        }

        function GetSelectedDataFromDropdown( elDropdown )
        {
            if ( !elDropdown.GetSelected() )
                return '';
            
            var strData = elDropdown.GetSelected().GetAttributeString( 'data', '' );
            return strData;
        }

        function SetupMapSelection( elOption, numIndex, strDefaultDropdownLoc, strConfirmBtnLoc )
        {
                                                    
            var elPickDropdown = elOption.FindChildTraverse( 'PickDropdown' );
            elPickDropdown.RemoveAllOptions();
            AddDropdownOption( elPickDropdown, "default", $.Localize( strDefaultDropdownLoc ), '', '' );
            for ( var i = 0; i < m_availableMaps.length; i++ )
            {
                var strMapName = m_availableMaps[ i ];
                var NiceMapName = $.Localize( GameTypesAPI.GetMapGroupAttribute( "mg_" + strMapName, "nameID" ) );
                AddDropdownOption( elPickDropdown, 'map' + i, $.Localize( NiceMapName ), strMapName, '' );
            }

            var elConfirmBtn = elOption.FindChildTraverse( 'ConfirmBtn' );
            elConfirmBtn.enabled = false;                       

            var _OnMapDropdownSelected = function ( elOption, elDropdown, elConfirmBtn )
            {
                var strMapName = GetSelectedDataFromDropdown( elDropdown );
                elConfirmBtn.enabled = strMapName != '';
                SetMapImage( elOption, strMapName );
            }
            elPickDropdown.SetPanelEvent( 'oninputsubmit', _OnMapDropdownSelected.bind( undefined, elOption, elPickDropdown, elConfirmBtn ) );

            var _OnMapConfirmed = function ( numIndex, elDropdown )
            {
                var strMapName = GetSelectedDataFromDropdown( elDropdown );
                MatchDraftAPI.UploadDraftEntryMap( numIndex, strMapName )
            }
            elConfirmBtn.SetPanelEvent( 'onactivate', _OnMapConfirmed.bind( undefined, numIndex, elPickDropdown ) );

            var elConfirmBtnLabel = elConfirmBtn.FindChildTraverse( 'ConfirmBtnLabel' );
            elConfirmBtnLabel.SetLocString( strConfirmBtnLoc );
        }

        function SetMapImage( elOption, strMapName )
        {
            var elMapImage = elOption.FindChildTraverse( 'SelectedImage' );
            elMapImage.SetImage( 'file://{images}/map_icons/screenshots/360p/' + strMapName + '.png' );
        }

        function SetupSelectedMap( elOption, strMapName, numTeamID, strSelectedMapLoc, strCustomClass )
        {
            var NiceMapName = $.Localize( GameTypesAPI.GetMapGroupAttribute( "mg_" + strMapName, "nameID" ) );
            var strTeamName = CompetitiveMatchAPI.GetTournamentTeamNameByID( m_strTournament, numTeamID );
            
            var elInfoLabel = elOption.FindChildTraverse( 'InfoLabel' );
            elInfoLabel.SetLocString( strSelectedMapLoc );
            elInfoLabel.SetDialogVariable( "s1", strTeamName );
            elInfoLabel.SetDialogVariable( "s2", NiceMapName );
            
            SetMapImage( elOption, strMapName );

            elOption.AddClass( strCustomClass );
        }

        function SetupTeamSelection( elOption, numIndex )
        {
                                                    
            var elPickDropdown = elOption.FindChildTraverse( 'PickDropdown' );
            elPickDropdown.RemoveAllOptions();
            AddDropdownOption( elPickDropdown, "default", $.Localize( "#SFUI_Tournament_Starting_Side" ), '', '' );
            AddDropdownOption( elPickDropdown, "t-side", $.Localize( "#counter-terrorists" ), "#counter-terrorists", '' );
            AddDropdownOption( elPickDropdown, "ct-side", $.Localize( "#terrorists" ), "#terrorists", '' );

            var elConfirmBtn = elOption.FindChildTraverse( 'ConfirmBtn' );
            elConfirmBtn.enabled = false;                       

            var _OnTeamDropdownSelected = function ( elOption, elDropdown, elConfirmBtn )
            {
                var strSide = GetSelectedDataFromDropdown( elDropdown );
                elConfirmBtn.enabled = strSide != '';
                SetSideImage( elOption, strSide );
            }
            elPickDropdown.SetPanelEvent( 'oninputsubmit', _OnTeamDropdownSelected.bind( undefined, elOption, elPickDropdown, elConfirmBtn ) );

            var _OnTeamConfirmed = function ( numIndex, elDropdown )
            {
                var strTeamName = GetSelectedDataFromDropdown( elDropdown );
                
                if( strTeamName == "#counter-terrorists" )
                    MatchDraftAPI.UploadDraftEntryCTTeamID( numIndex, m_strTeamID );
                else
                {
                    var Team0ID = MatchDraftAPI.GetTeamID( 0 );
                    var Team1ID = MatchDraftAPI.GetTeamID( 1 );
                    
                    if ( m_strTeamID != Team0ID )
                    {
                        MatchDraftAPI.UploadDraftEntryCTTeamID( numIndex, Team0ID );
                    }
                    else
                    {
                        MatchDraftAPI.UploadDraftEntryCTTeamID( numIndex, Team1ID );
                    }
                }
            }
            elConfirmBtn.SetPanelEvent( 'onactivate', _OnTeamConfirmed.bind( undefined, numIndex, elPickDropdown ) );

            var elConfirmBtnLabel = elConfirmBtn.FindChildTraverse( 'ConfirmBtnLabel' );
            elConfirmBtnLabel.SetLocString( "#SFUI_Tournament_Pick" );
        }

        function SetSideImage( elOption, strSide )
        {
            var elSideImage = elOption.FindChildTraverse( 'SelectedImage' );
            var strIcon = strSide == "#counter-terrorists" ? "ct_logo" : "t_logo";
            elSideImage.SetImage( 'file://{images}/icons/' + strIcon + '.svg' );
        }

        function SetupSelectedTeam( elOption, numTeamID, numCtTeamID )
        {   
            var strTeamName = CompetitiveMatchAPI.GetTournamentTeamNameByID( m_strTournament, numTeamID );
            var strSideLoc = numCtTeamID == numTeamID ? "#counter-terrorists" : "#terrorists";
            
            var elInfoLabel = elOption.FindChildTraverse( 'InfoLabel' );
            elInfoLabel.SetLocString( "#SFUI_Tournament_PickedTeam_Title" );
            elInfoLabel.SetDialogVariable( "s1", strTeamName );
            elInfoLabel.SetDialogVariable( "s2", $.Localize( strSideLoc ) );
            
            SetSideImage( elOption, strSideLoc );

            elOption.AddClass( 'pickban__draft_picked' );
        }

        function SetupFutureEntry( elOption, strFutureLoc )
        {
            var elInfoLabel = elOption.FindChildTraverse( 'InfoLabel' );
            elInfoLabel.SetLocString( strFutureLoc );
        }

        function SetUpVetoTile( elTile, strMapName, numActiveIndex, numTeamID, numIndex )
        {
            var isActive = numActiveIndex == numIndex;
            var isPicking = numTeamID == m_strTeamID;

            var elOption = elTile.FindChildTraverse( 'vetomap' );

            elOption.SetHasClass( 'pickban__picking', isActive && isPicking );
            elOption.SetHasClass( 'pickban__waiting', isActive && !isPicking );
            
            if ( isActive && strMapName == "" )
            {
                if ( isPicking )
                {
                    SetupMapSelection( elOption, numIndex, "#SFUI_Tournament_ChooseMap", "#SFUI_Tournament_Veto" );
                }
            }
            else if ( numActiveIndex > numIndex && strMapName != "" )
            {
                SetupSelectedMap( elOption, strMapName, numTeamID, "#SFUI_Tournament_Vetoed_Title", 'pickban__draft_vetoed' );
            }
            else
            {
                SetupFutureEntry( elOption, "#SFUI_Tournament_Upcoming_Veto" );
            }
        }

        function RemoveFromAvailableMap( strMapName )
        {
            for ( var i = 0; i < m_availableMaps.length; i++ )
            {
                if ( m_availableMaps[ i ] == strMapName )
                {
                    m_availableMaps.splice( i, 1 );
                    return;
                }
            }
        }

        function SetUpPickTile( elTile, strMapName, numActiveIndex, numTeamID, numTeamPickingSideID, numCtTeamID, numIndex )
        {
            var elMapOption = elTile.FindChildTraverse( 'pickmap' );
            var elTeamOption = elTile.FindChildTraverse( 'pickteam' );

            var isActive = numActiveIndex == numIndex;
            var isPickingMap = numTeamID == m_strTeamID;
            var isPickingSide = numTeamPickingSideID == m_strTeamID;
            var isChoosingMap = strMapName == "";
            var isChoosingTeam = numCtTeamID == 0;

                                                    
            elMapOption.SetHasClass( 'pickban__picking', isActive && isChoosingMap && isPickingMap );
            elMapOption.SetHasClass( 'pickban__waiting', isActive && isChoosingMap && !isPickingMap );
            elTeamOption.SetHasClass( 'pickban__picking', isActive && !isChoosingMap && isChoosingTeam && isPickingSide );
            elTeamOption.SetHasClass( 'pickban__waiting', isActive && !isChoosingMap && isChoosingTeam && !isPickingSide );
            
            if ( numActiveIndex == numIndex )
            {
                if ( isChoosingMap )
                {
                    if ( isPickingMap )
                    {
                        SetupMapSelection( elMapOption, numIndex, "#SFUI_Tournament_ChooseMapPick", "#SFUI_Tournament_Pick" );
                    }
                    SetupFutureEntry( elTeamOption, "#SFUI_Tournament_Upcoming_Side_Pick" );
                }
                else
                {
                    SetupSelectedMap( elMapOption, strMapName, numTeamID, "#SFUI_Tournament_Picked_Title", 'pickban__draft_picked' );
                    
                    if ( isChoosingTeam && isPickingSide )
                    {
                        SetupTeamSelection( elTeamOption, numIndex );
                    }
                }
            }
            else if ( numActiveIndex > numIndex && strMapName != "" )
            {
                SetupSelectedMap( elMapOption, strMapName, numTeamID, "#SFUI_Tournament_Picked_Title", 'pickban__draft_picked' );
                SetupSelectedTeam( elTeamOption, numTeamPickingSideID, numCtTeamID );
            }
            else
            {
                SetupFutureEntry( elMapOption, "#SFUI_Tournament_Upcoming_Pick" );
                SetupFutureEntry( elTeamOption, "#SFUI_Tournament_Upcoming_Side_Pick" );
            }
        }
        
        for ( var i = 0; i < numEntriesCount; i++ )
        {
            var strTileType = MatchDraftAPI.GetDraftEntryType(i);
            var strMapName = MatchDraftAPI.GetDraftEntryMap(i);
            var numTeamID = MatchDraftAPI.GetDraftEntryMapChoiceTeamID(i);
            var numCtTeamID = MatchDraftAPI.GetDraftEntryCTTeamID(i);
            var numTeamPickingSideID = MatchDraftAPI.GetDraftEntryCTChoiceTeamID( i );
        
            RemoveFromAvailableMap( strMapName );
            
            var elTile = _GetTile( i, strTileType, strMapName, numTeamID, numCtTeamID, numTeamPickingSideID );
            
            if( strTileType == "veto" )
            {
                SetUpVetoTile( elTile, strMapName, numActiveIndex, numTeamID, i );
            }
            else
            {
                SetUpPickTile( elTile, strMapName, numActiveIndex, numTeamID, numTeamPickingSideID, numCtTeamID, i );
            }
        }

        $.GetContextPanel().SetHasClass( "pickban__draft", true );
    }

    var _OnCancel = function ()
    {
		LobbyAPI.StopMatchmaking();
		
		_CloseThisPopupWindow();
	}
	
	var _SessionSettingsUpdate = function( sessionState ) 
	{
		                                                     
		if ( !LobbyAPI.GetMatchmakingStatusString() )
		{
			_CloseThisPopupWindow();
		}
	};

	var _CloseThisPopupWindow = function()
	{
		if ( _m_thisPanel && _m_thisPanel.IsValid() )
		{
			$.DispatchEvent( 'UIPopupButtonClicked', _m_thisPanel, '' );
		}
	}

	return {
		Init				:	_Init,
		DraftUpdate         :   _DraftUpdate,
		SessionSettingsUpdate	: _SessionSettingsUpdate,
        OnCancel            :   _OnCancel,
	};
})();

                                                                                                    
                                           
                                                                                                    
( function()
{
	$.RegisterForUnhandledEvent( "PanoramaComponent_TournamentMatch_DraftUpdate", PopupTournamentPickBan.DraftUpdate );
	$.RegisterForUnhandledEvent( "PanoramaComponent_Lobby_MatchmakingSessionUpdate", PopupTournamentPickBan.SessionSettingsUpdate );
} )();

