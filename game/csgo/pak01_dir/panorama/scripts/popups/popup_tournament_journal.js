'use strict';

var TournamentJournal = ( function()
{
    var m_test_challenges = [
                                                                                                                                    
    ];

                                                                                         
                                                                                                                            
                                                         
                                                                                                                                   
    var m_activeTournament = 18;
    var m_tokenItemDefName = null;
    var m_scheduleHandle = null;

    var m_isInMatch = GameStateAPI.IsDemoOrHltv() || GameStateAPI.IsLocalPlayerPlayingMatch(); 

    var _Init = function()
    {
        var journalId = $.GetContextPanel().GetAttributeString( "journalid", '' );
        var tournamentId = InventoryAPI.GetItemAttributeValue( journalId, "tournament event id" );
                           
		                      
		
		switch ( tournamentId ) {                                                               
			case 18: m_tokenItemDefName = 'tournament_pass_stockh2021_charge'; break;
		}
		
                                     
        var nCampaignID = parseInt( InventoryAPI.GetItemAttributeValue( journalId, "campaign id" ) );
                                                
        var numTotalChallenges = InventoryAPI.GetCampaignNodeCount( nCampaignID );
                                                            
                                                              
        for ( var jj = 0; jj < numTotalChallenges; ++jj )
        {
            var nMissionNodeID = InventoryAPI.GetCampaignNodeIDbyIndex( nCampaignID, jj );
                                         
            var strNodeState = InventoryAPI.GetCampaignNodeState( nCampaignID, nMissionNodeID, journalId, true );
                                            
            var nQuestID = InventoryAPI.GetCampaignNodeQuestID( nCampaignID, nMissionNodeID );
            var strFauxQuestItem = InventoryAPI.GetQuestItemIDFromQuestID( nQuestID );
            var strQuestIcon = InventoryAPI.GetQuestIcon( strFauxQuestItem );
            var strQuestName = InventoryAPI.GetItemName( strFauxQuestItem );
                                                      
                                                                                                               
            m_test_challenges.push( {
                text: strQuestName,
                context: ( strQuestIcon === 'watchem' ) ? 'watch' : ( strQuestIcon === 'pickem' ) ?'trophy' : strQuestIcon,                                                   
                value: ( strNodeState === "complete" ) ? 1 : 0                                              
            } );
        }

        $.GetContextPanel().SetHasClass( 'tournament-over', m_activeTournament !== tournamentId );
                                               
        _SetTitle( journalId );
        _SetSubtitle( journalId );
        _SetModel( journalId );
        _SetBannerColor( journalId );
        _SetFaqBtn(tournamentId);
        _UpdateStoreItems();
        _UpdateActivateBtn();
        
                         
        if( !_IsValidJournalId( journalId ) )
        {
                       
            $.GetContextPanel().SetHasClass( 'no-active-pass', true );
            return;
        }

        $.GetContextPanel().SetHasClass( 'no-active-pass', false );

        _SetThesholdText( journalId, tournamentId );
        _UpdateChallengesList( journalId, tournamentId );
        _SouvenirsEarned( journalId, tournamentId );
        _SouvenirsImage( tournamentId );
        _SetEventSticker( tournamentId );
        _UpdateSetChargesBtn( ( m_activeTournament === tournamentId ) ? InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( g_ActiveTournamentInfo.itemid_charge, 0 ) : null );
        _UpdateApplyCharges();
        _SetWinners( tournamentId, journalId );
        _SetUpSpray( journalId );
        _WatchStreamBtn( journalId );
    };
    
    var GetPassToActivate = function()
    {
        var journalId = $.GetContextPanel().GetAttributeString( "journalid", '' );
        var id = InventoryAPI.GetActiveTournamentCoinItemId( g_ActiveTournamentInfo.eventid * -1 );
        return (!_IsValidJournalId( journalId ) && ( id && id !== '0' )) ? id : '';
    }

    var _UpdateActivateBtn = function()
    {
        var activateBtn = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-active' );

        var id = GetPassToActivate();
        activateBtn.SetPanelEvent(
            'onactivate',
            _ActivatePass.bind( undefined, id )
        );
        activateBtn.visible = ( id && id !== '') ? true : false;
    }

    var _ClosePopup = function()
    {
        $.DispatchEvent( 'UIPopupButtonClicked', '' );
    };

    var _SetBackgroundMovie = function( id )
    {
        if ( id > 15 )
        {
            $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-container' ).style.backgroundImage = "url( 'file://{images}/tournaments/backgrounds/background_" + id + ".png' );";
        }
    };

    var _SetTitle = function( journalId )
    {
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-title' ).text = !_IsValidJournalId( journalId ) ? 
            $.Localize('#CSGO_TournamentPass_stockh2021_store_title') : 
            InventoryAPI.GetItemName( journalId );
    };

    var _SetSubtitle = function( journalId )
    {
        var srtText = !_IsValidJournalId( journalId ) ? '#CSGO_TournamentPass_stockh2021_store_desc' : '#tournament_coin_desc_token';
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-subtitle' ).text = $.Localize( srtText );
    };

    var _SetModel = function( id )
    {
        var fakeId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( 4800, 0 );                                            
        id = !_IsValidJournalId( id ) ? fakeId : id;

        var elModel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-model' );
        var modelPath = ItemInfo.GetModelPathFromJSONOrAPI( id );
        
        var manifest = "resource/ui/econ/ItemModelPanelCharWeaponInspect.res";
        elModel.SetScene( manifest, modelPath, false );
        elModel.SetCameraPreset( 1, false );
        elModel.SetSceneIntroRotation( -10.0, 20, 1 );
    };

    var _SetBannerColor = function( journalId )
    {
        var coinLevel = InventoryAPI.GetItemAttributeValue( journalId, "upgrade level" );
                                                                                                 

        var style = coinLevel < 1 ? 'bronze' : coinLevel === 1 ? 'silver' : coinLevel > 1 ? 'gold' : 'bronze';
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-container' ).AddClass( style );
    };

    var _SetThesholdText = function( journalId, tournamentId )
    {
        var threshold = InventoryAPI.GetItemAttributeValue( journalId, "upgrade threshold" );
        var completedChallenges = m_test_challenges.filter( function( entry ) { return entry.value === 1; } );

        _SetPoints( completedChallenges );
        if ( !threshold || ( completedChallenges.length === m_test_challenges.length ) )
        {
            $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-remaining' ).visible = false;
            return;
        }

        var challengesRemain = threshold - completedChallenges.length;
    
        $.GetContextPanel().SetDialogVariableInt( 'challenges', challengesRemain );
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-remaining' ).text = tournamentId < 16 ?
            $.Localize( '#tournament_coin_remaining_challenges',  $.GetContextPanel() ) :
            $.Localize( '#tournament_coin_remaining_challenges_token',  $.GetContextPanel() );
    };

    var _SetPoints = function( completedChallenges )
    {
        $.GetContextPanel().SetDialogVariableInt( 'challenges_complete', completedChallenges.length );
    };

    var _SouvenirsEarned = function( journalId, tournamentId )
    {
        if ( !_IsValidJournalId( journalId ) )
        {

            return;
        }

        var coinLevel = InventoryAPI.GetItemAttributeValue( journalId, "upgrade level" );
		var coinRedeemsPurchased = InventoryAPI.GetItemAttributeValue( journalId, "operation drops awarded 1" );
		if ( coinRedeemsPurchased )                                                                          
			coinLevel += coinRedeemsPurchased;

        var redeemed = InventoryAPI.GetItemAttributeValue( journalId, "operation drops awarded 0" );
        var redeemsAvailable = coinLevel - redeemed;
        var redeemsEarned = ( coinLevel !== undefined ) ? coinLevel : 0;

        $.GetContextPanel().SetDialogVariableInt( 'redeems_earned', redeemsEarned );
        $.GetContextPanel().SetDialogVariableInt( 'redeems_remain', ( redeemsAvailable !== undefined ) ? redeemsAvailable : 0 );

                 
        var elLabel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-redeem-btn-label' );

        elLabel.text = redeemsAvailable === 1 ?
            $.Localize( '#tournament_coin_redeem_action', elLabel ) :
            $.Localize( '#tournament_coin_redeem_action_multi', elLabel );
        
        _RedeemBtn( redeemsAvailable );

                 
        elLabel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-souvenir-earned' );
        
        var locStringModifier = tournamentId < 16 ? 'souvenir_v2' : 'token';
        
        elLabel.text = redeemsEarned === 1?
            $.Localize( '#tournament_coin_earned_' + locStringModifier, elLabel ) :
            $.Localize( '#tournament_coin_earned_' + locStringModifier + '_multi', elLabel );
        
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-info-block-subtitle' ).text = tournamentId < 16 ?
            $.Localize( '#tournament_coin_redeem_souvenir' ) :
            $.Localize( '#tournament_coin_redeem_souvenir_' + tournamentId );
    };

    var _SouvenirsImage = function( tournamentId )
    {
        var elImage = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-ticket-icon' );
        if ( tournamentId < 16 )
        {
            elImage.SetImage( 'file://{images}/tournaments/souvenir/souvenir_blank_tournament_' + tournamentId + '.png' );
        }
        else
        {
            elImage.itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( g_ActiveTournamentInfo.itemid_charge, 0 );
        }
    };

    var _RedeemBtn = function( redeemsAvailable )
    {   
        var elbtn = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-redeem-btn' );
        elbtn.enabled = !m_isInMatch && redeemsAvailable > 0;
    };

    var _AnimRedeemValue = function()
    {
        var elbtn = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-souvenir-earned-value' );
        elbtn.AddClass( 'tournament-journal__info-block__title--update-anim' );

        $.Schedule( 1, function(){
            elbtn.RemoveClass( 'tournament-journal__info-block__title--update-anim' );
        });
    };

    var _SetEventSticker = function( tournamentId )
    {
        var elTitleBar = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-title-bar' );
        
        $.CreatePanel(
            "Image",
            elTitleBar,
            '',
            {
                texturewidth: '98',
                textureheight: '-1',
                src: 'file://{images}/tournaments/events/tournament_logo_' + tournamentId + '.svg',
                class: 'tournament-journal__titlebar__logo'
        });
    };

    var _UpdateChallengesList = function( journalId, tournamentId )
    {
        var elList = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal__challenges-list' );
        if ( !_IsValidJournalId( journalId ) )
        {
            return;
        }

        m_test_challenges.forEach( function( obj, index )
        {
            var elChallenge = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal__challenges' + index );
            
            if ( !elChallenge )
            {
                elChallenge = _CreateChallenge( obj, elList, index );
            }
            _UpdateChallenge( obj, elChallenge, index, tournamentId );
        } );

        function _CreateChallenge ( objData, elList, index )
        {
            var elChallenge = $.CreatePanel( "Panel", elList, 'id-tournament-journal__challenges' + index );
            elChallenge.BLoadLayoutSnippet( "tournament-challenge" );
            elChallenge.SetHasClass( 'dark', true );

			                            
			    
			   	                                                                        
			    
                                            
                
                                                                                
                
                    
                
                                     
                    
                                                                     
                    

                                                                            
                    
                                                
                                                                     
                    
                

            $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-container' ).AddBlurPanel( elChallenge );
            
            return elChallenge;
        }

        function _UpdateChallenge ( objData, elChallenge, index, tournamentId )
        {
            var elName = elChallenge.FindChildInLayoutFile( 'id-tournament-journal__challenge__name' );
            var elIcon = elChallenge.FindChildInLayoutFile( 'id-tournament-journal__challenge__icon' );
            elName.text = objData.text;

            var iconPath = objData.value === 1 ? 'file://{images}/icons/ui/check.svg' :
                'file://{images}/icons/ui/' + objData.context + '.svg';

            elIcon.SetImage( iconPath );
            elChallenge.SetHasClass( 'complete', objData.value === 1 );

                                                                                                          
            var bForceEnablePlayContext = false;                                                                        

            elChallenge.enabled = objData.value !== 1 && !m_isInMatch && ( m_activeTournament === tournamentId || bForceEnablePlayContext );

            if ( objData.context === "trophy" || objData.context === "calender" )
            {
                _OnActivatePickemChallenge( elChallenge, index, tournamentId );
            }
            else if ( objData.context === 'watch' )
            {
                _OnWatchStream( elChallenge );
			}
			else if ( objData.context === 'play' )
            {
                _OnActivatePlayChallenge( elChallenge, index );
            }
        }

        function _OnActivatePickemChallenge ( elPanel, index, tournamentId )
        {
			var idforTab = '';
			if ( tournamentId >= 18 )
			{
				switch ( index )
				{
					case 1:
					case 2:
						idforTab = 'id-nav-pick-prelims';
						break;
					case 3:
					case 4:
						idforTab = 'id-nav-pick-group';
						break;
					default: 
						idforTab = 'id-nav-pick-playoffs';
						break;
				}
			}
			else
			{
				switch ( index )
				{
					case 8: 
						idforTab = 'id-nav-pick-prelims';
						break;
					case 10: 
						idforTab = 'id-nav-pick-group';
						break;
					default: 
						idforTab = 'id-nav-pick-playoffs';
						break;
				}
			}
            
            elPanel.SetPanelEvent( 'onactivate', OnActivate.bind( undefined, idforTab ) );
            
            function OnActivate ( idforTab )
            {
                $.DispatchEvent( 'OpenWatchMenu' );
                $.DispatchEvent( 'ShowActiveTournamentPage', idforTab );
                _ClosePopup();
            }
		}
		
		function _OnActivatePlayChallenge( elPanel, index )
        {
			var maps = [
				'de_inferno',
				'de_mirage', 
				'de_dust2',
				'de_overpass',
				'de_train',
				'de_nuke',
				'de_vertigo'
			];
			var pickedMap = ( index > 0 && index <= maps.length ) ? maps[ index - 1 ] : '';
			if ( !pickedMap ) return;

            elPanel.SetPanelEvent( 'onactivate', OnActivate.bind( undefined, 'mg_'+pickedMap ) );
            
            function OnActivate ( mapGroup )
            {
				                                                          
				if ( LobbyAPI.IsSessionActive() && !LobbyAPI.BIsHost() )
				{	                                                                                                                                       
					LobbyAPI.CloseSession();
				}

				                                            
				if ( LobbyAPI.IsSessionActive() )
				{
					var settingsGame = LobbyAPI.GetSessionSettings().game;
					if ( settingsGame && settingsGame.mmqueue )
					{
						LobbyAPI.StopMatchmaking();
					}

					settingsGame = LobbyAPI.GetSessionSettings().game;
					if ( settingsGame && settingsGame.mmqueue )
					{	                                          
						return;
					}
				}

				if ( !LobbyAPI.IsSessionActive() )
				{
					LobbyAPI.CreateSession();
				}

				var gameType = 'classic';
				var gameMode = 'competitive';

				if ( !LobbyAPI.IsSessionActive() )
					return;

				  
				                            
				  
				                                                                                              
				var settings = {
					update: {
						Options: {
							action: "custommatch",
							server: "official"
						},
						Game: {
							mode: gameMode,
							type: gameType,
							mapgroupname: mapGroup,
						},
					}
				};

				LobbyAPI.UpdateSessionSettings( settings );

				var bStartMatchmaking = true;
				if ( bStartMatchmaking )
				{
					LobbyAPI.StartMatchmaking( '', '', '', '' );
				}

				$.DispatchEvent( 'UIPopupButtonClicked', '' );
				$.DispatchEvent( 'OpenPlayMenu', '' );
                
                _ClosePopup();
            }
        }
    };

    var _OnWatchStream = function( elPanel )
    {
        elPanel.SetPanelEvent( 'onactivate', function()
        {
            SteamOverlayAPI.OpenURL( 'https://steam.tv/csgo' );
        } );
    };

    var _SetUpSpray = function( journalId )
    {
        var elPanel = $.GetContextPanel().FindChildInLayoutFile( 'id-graffiti-block' );
        if ( !_IsValidJournalId( journalId ) )
        {
            return;
        }

        var journalId = $.GetContextPanel().GetAttributeString( "journalid", '' );
        var elImage = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-spray' );
        elImage.itemid = ItemInfo.GetFauxReplacementItemID( journalId, 'graffiti' );

                                                
        
        var elIBtn = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-selectspray-btn' );
        elIBtn.SetPanelEvent( 'onactivate', function(){
                UiToolkitAPI.ShowCustomLayoutPopupParameters(
                    '',
                    'file://{resources}/layout/popups/popup_tournament_select_spray.xml',
                    'journalid=' + journalId
                );
            }
        );
    };

    var _OnActivateRedeem = function()
    {
        $.DispatchEvent( 'OpenWatchMenu' );
        $.DispatchEvent( 'ShowActiveTournamentPage', 'id-nav-matches' );
        _ClosePopup();
    };

    var _WatchStreamBtn = function( journalId )
    {   
        var elPanel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-watch-stream' );
        var isPerfectWorld = MyPersonaAPI.GetLauncherType() === "perfectworld" ? true : false;
        if ( !_IsValidJournalId( journalId ) || isPerfectWorld )
        {
            if( elPanel && elPanel.IsValid() )
            {
                                           
                elPanel.enabled = false;
                elPanel.SetHasClass('opacity-none', true )
            }

            return;
        }

        elPanel.enabled = true;
        elPanel.SetHasClass('opacity-none', false )
        _OnWatchStream( elPanel );
    };

    var _SetWinners = function( tournamentId, journalId )
    {
        if ( !_IsValidJournalId( journalId ) || m_activeTournament === tournamentId )
        {
            return false;
        }

                                                                      
        var aData = [
            { tournamentId: 15, team: 'astr', teamname: '#CSGO_TeamID_60', descString: '#CSGO_CollectibleCoin_Katowice2019_Champion' },
            { tournamentId: 16, team: 'astr', teamname: '#CSGO_TeamID_60', descString: '#CSGO_CollectibleCoin_berlin2019_Champion' }
                                      
        ];

        var ObjWinner = aData.filter( winner => winner.tournamentId == tournamentId )[0];

        $.GetContextPanel().FindChildInLayoutFile( 'tournament-journal-winners-img' ).SetImage( "file://{images}/tournaments/teams/" + ObjWinner.team +".svg"); 
        $.GetContextPanel().FindChildInLayoutFile( 'tournament-journal-winners-desc' ).text = $.Localize( ObjWinner.descString );
        $.GetContextPanel().FindChildInLayoutFile( 'tournament-journal-winners-title' ).text = $.Localize( ObjWinner.teamname );

        var elModel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-trophy' );
        elModel.SetCameraPreset( 1, false );
        elModel.SetSceneIntroRotation( -12.0, 30, 1 );
        elModel.SetFlashlightColor( 2, 2, 2 );
    };

    var _UpdateSetChargesBtn = function( id )
    {
        var btn = $.GetContextPanel().FindChildInLayoutFile( 'id-get-charges-btn' );
        btn.visible = false;
        
        if ( id && id !== '0' && id !== '-1' && ItemInfo.GetStoreSalePrice( id, 1, '' ) )
        {
            btn.visible = true;
            btn.SetPanelEvent( 'onactivate', function()
            {
                UiToolkitAPI.ShowCustomLayoutPopupParameters(
                '',
                'file://{resources}/layout/popups/popup_inventory_inspect.xml',
                'itemid=' + id + '&' +
                'inspectonly=false' +
                '&' + 'extrapopupfullscreenstyle=solidbkgnd' +
                '&' + 'asyncworkitemwarning=no' +
                '&' + 'storeitemid=' + id,
                'none'
		        );
            } );
        }
    };

    var _UpdateApplyCharges = function()
    {
        var btn = $.GetContextPanel().FindChildInLayoutFile( 'id-activate-charges-btn' );  
        $.GetContextPanel().FindChildInLayoutFile( 'id-activate-spinner' ).visible = false;
		btn.visible = false;
		
		if ( !m_tokenItemDefName )
			return;

        InventoryAPI.SetInventorySortAndFilters( 'inv_sort_age', false, 'item_definition:' + m_tokenItemDefName, '', '' );
        var count = InventoryAPI.GetInventoryCount();
        var aItemIds = [];

        for ( var i = 0; i < count; i++ )
        {
            aItemIds.push( InventoryAPI.GetInventoryItemIDByIndex( i ));
        }

        if ( aItemIds.length > 0 )
        {
            btn.SetDialogVariableInt( 'tokens', aItemIds.length );
            btn.SetPanelEvent( 'onactivate', function()
            {
                if ( m_scheduleHandle )
                {
                    $.CancelScheduled( m_scheduleHandle );
                    m_scheduleHandle = null;
                }

                aItemIds.forEach( item => InventoryAPI.UseTool( item, '' ) );

                $.GetContextPanel().FindChildInLayoutFile( 'id-activate-spinner' ).visible = true;
                btn.visible = false;
                m_scheduleHandle = $.Schedule( 5, _CancelWaitforCallBack );
            } );

            
            btn.text = aItemIds.length === 1 ?
                $.Localize( '#tournament_activate_tokens', btn ) :
                $.Localize( '#tournament_activate_tokens_multi', btn );
            
            btn.visible = true;
        }

    };

    var _CancelWaitforCallBack = function()
	{
		m_scheduleHandle = null;
		
        $.GetContextPanel().FindChildInLayoutFile( 'id-activate-spinner' ).visible = false;

        _ClosePopup();

		UiToolkitAPI.ShowGenericPopupOk(
			$.Localize( '#SFUI_SteamConnectionErrorTitle' ),
			$.Localize( '#SFUI_InvError_Item_Not_Given' ),
			'',
			function()
			{
			},
			function()
			{
			}
		);
    };
    
    var _ResetTimeouthandle = function()
	{
		if ( m_scheduleHandle )
		{
			$.CancelScheduled( m_scheduleHandle );
			m_scheduleHandle = null;
		}
    };
    
    var _OnItemCustomization =  function( numericType, type, itemid )
    {
        if ( type === 'ticket_activated' )
        {
            _ResetTimeouthandle();
            _UpdateApplyCharges();

            var journalId = itemid;
            var tournamentId = InventoryAPI.GetItemAttributeValue( journalId, "tournament event id" );

            _AnimRedeemValue();
            $.Schedule( .25, _SouvenirsEarned.bind( undefined, journalId, tournamentId ));
        }
    };

    var _OnInventoryUpdated = function()
    {
        _ResetTimeouthandle();
        _SetUpSpray( $.GetContextPanel().GetAttributeString( "journalid", '' ) );
        _UpdateActivateBtn();
        _UpdateApplyCharges();
    };

    var _SetFaqBtn = function( tournamentId )
    {
        $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-faq' ).SetPanelEvent( 'onactivate', function(){
            SteamOverlayAPI.OpenURL( 'https://store.steampowered.com/sale/csgostockholm' );
        });
    };

    var _UpdateStoreItems = function()
    {
        var elItemsPanel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-items' );
		var elBlurPanel = $.GetContextPanel().FindChildInLayoutFile( 'id-tournament-journal-container' );
		
		                                        
		var sRestriction = InventoryAPI.GetDecodeableRestriction( "capsule" );
		var bCanSellCapsules = ( sRestriction !== "restricted" && sRestriction !== "xray" );

		var fnCreateOffering = function ( ids, i ) {

            if ( !elItemsPanel.FindChildInLayoutFile( 'tournament-items' + i ) )
            {
                var itemid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( g_ActiveTournamentStoreLayout[ i ][ 0 ], 0 );
                var linkedid = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( g_ActiveTournamentStoreLayout[ i ][ 1 ], 0 );
                var bIsPurchaseable = _IsPurchaseable( itemid )
                
                var elItem = $.CreatePanel( 'Panel', elItemsPanel, 'tournament-items' + i );
                elItem.Data().oData = {
                    itemid: itemid,
                    linkedid: linkedid,
					linkpricing: 'reverse',
					usetinynames: true,
                    usegroupname: g_ActiveTournamentStoreLayout[ i ][ 2 ],
                    warningtext: !bIsPurchaseable ?
                        '#tournament_items_not_released' : InventoryAPI.GetItemTypeFromEnum( itemid ) === 'type_tool' ?
                        '#tournament_items_notice' : '',
                    isdisabled: !bIsPurchaseable,
                    extrapopupfullscreenstyle: true
                }
                elItem.BLoadLayout( "file://{resources}/layout/mainmenu_store_tile_linked.xml", false, false );
                

                elBlurPanel.AddBlurPanel( elItem );
            }
		};
		
		if ( bCanSellCapsules )
			g_ActiveTournamentStoreLayout.forEach( fnCreateOffering );
		else
			fnCreateOffering( g_ActiveTournamentStoreLayout[0], 0 );
    };

    var _IsPurchaseable = function( itemid )
    {
        
                                                                                         
        var itemSchemaDef = ItemInfo.BuildItemSchemaDef( itemid );
        return itemSchemaDef[ "cannot_inspect" ] === 1 ? false : true;
    };

    var _ActivatePass = function ( id )
	{
        UiToolkitAPI.ShowCustomLayoutPopupParameters(
            '',
            'file://{resources}/layout/popups/popup_capability_decodable.xml',
            'key-and-case=,' + id +
            '&' + 'asyncworktype=decodeable'
        );
        
        _ClosePopup();
	};

    var _IsValidJournalId = function( id )
    {
        return ( !id || id === 0 || id === '0' ) ? false : true;
    }

	return{
		Init: _Init,
        ClosePopup: _ClosePopup,
        SetUpSpray: _SetUpSpray,
        OnInventoryUpdated: _OnInventoryUpdated,
        OnItemCustomization: _OnItemCustomization,
        OnActivateRedeem: _OnActivateRedeem
	};
} )();

( function()
{
    $.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', TournamentJournal.OnInventoryUpdated );
    $.RegisterForUnhandledEvent( 'PanoramaComponent_Inventory_ItemCustomizationNotification', TournamentJournal.OnItemCustomization );
} )();