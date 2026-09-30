"use-strict";

var ItemContextMenu = ( function (){

	var m_hBackupFileNamesEventReg = null;

	function MakeVoteButton( elParent, id, name, voteFunc, snippetType )
	{
		var elChoicesContainer = elParent.FindChildInLayoutFile( 'ChoicesContainer' );

		var p = $.CreatePanel( "Button", elChoicesContainer, id );
		if ( p.BLoadLayoutSnippet( snippetType ) ) {
			p.FindChild( "Name" ).text = name;
			p.SetPanelEvent( "onactivate", function () {
				voteFunc();
				$.DispatchEvent('UIPopupButtonClicked', '');
				                                                                                                                            
				                                                                                                                      
				$.DispatchEventAsync( 0.0, 'CSGOMainMenuResumeGame' );
			});
		}

		return p;
	}

	function GetMapIcon( map )
	{
		return "file://{images}/map_icons/map_icon_"+ map +".svg";
	}

	function GetMapDisplayName( map )
	{
		return GameStateAPI.GetMapDisplayNameToken( map );
	}

	function GetKickTargets() 
	{
		var kickTargets = GameStateAPI.GetKickTargets();
		return Object.keys( kickTargets ).map( function ( value ) { 
			return { displayName: value, voteParam: kickTargets[value] };
		});
	}
	function GetMapTargets() 
	{
		var strMaps = GameStateAPI.GetMapsInCurrentMapGroup();
		if ( strMaps === null || strMaps === "" )
			return [];

		var mapsInMapGroup = strMaps.split( ',' );
		                            
		return mapsInMapGroup.map( function ( curMap ) {
			return { displayName: $.Localize( GetMapDisplayName( curMap ) ).toUpperCase(), voteParam: curMap };
		});
	}

	function GetBackupFilenames( elPopup )
	{
		GameInterfaceAPI.ConsoleCommand( "send_round_backup_file_list" );
		m_hBackupFileNamesEventReg = $.RegisterForUnhandledEvent( 'BackupFileNamesReceived',  
		_Event_BackupFileNamesReceived.bind( null, elPopup ) );
	}

	function _Event_BackupFileNamesReceived( elPopup, objFileNames ) {
		var voteFunc = function ( param )
		{
			GameInterfaceAPI.ConsoleCommand( 'callvote loadbackup ' + param );
		}
		var arrDisplayNames = objFileNames.display_names.split( ',' );
		var arrFileNames = objFileNames.file_names.split( ',' );
		arrDisplayNames.forEach(function (item, idx) {
			var elButton = MakeVoteButton(elPopup, "voteoption_" + idx,
				item,
				voteFunc.bind( undefined, arrFileNames[ idx ] ),
				"ChoiceEntry"
			);
			elButton.FindChild("Icon").SetImage( "file://{images}/icons/ui/competitive.svg" );
			$.UnregisterForUnhandledEvent('BackupFileNamesReceived', m_hBackupFileNamesEventReg);
		});
	}

	function ConstructBaseVoteIssue( voteCommand, locToken )
	{
		this.id = "voteissue_" + voteCommand;
		this.name = locToken;
		this.desc = locToken + "_Desc";
		this.icon = "file://{images}/icons/ui/Vote" + voteCommand + ".svg";
		this.cmd = function ()
		{
			GameInterfaceAPI.ConsoleCommand( 'callvote ' + voteCommand );
			$.DispatchEvent( 'ContextMenuEvent', '' );
			$.DispatchEventAsync( 0.0, 'CSGOMainMenuResumeGame' );
		};
		this.enabled = true;
	}

	function ConstructBaseVoteIssueEnabled( voteCommand, locToken, bEnabled )
	{
		ConstructBaseVoteIssue.call( this, voteCommand, locToken );
		this.enabled = bEnabled;
	}

	function CreateVotePopupChoices( locToken )
	{
		var elPopup = UiToolkitAPI.ShowCustomLayoutPopup( "voteissuechoices", "file://{resources}/layout/popups/popup_choices.xml" );
		var elPopupTitle = elPopup.FindChild( "ChoiceTitle" );
		elPopupTitle.text = $.Localize( locToken );

		return elPopup;
	}

	function ConstructPopupMapChoicesVoteIssue( voteCommand, locToken, choiceListFunc )
	{
		ConstructBaseVoteIssue.call( this, voteCommand, locToken );
		this.cmd = function () {
			var elPopup = CreateVotePopupChoices( locToken );
			elPopup.AddClass( 'popup-map-vote' );
			var voteFunc = function ( param )
			{
				GameInterfaceAPI.ConsoleCommand( 'callvote ' + voteCommand + " " + param );
			}
			
			choiceListFunc().forEach(function (item) {
				var elButton = MakeVoteButton(elPopup, "voteoption_" + item.voteParam,
					item.displayName,
					voteFunc.bind( undefined, item.voteParam ),
					"ChoiceEntry"
				);

				var elIcon = elButton.FindChild( "Icon" );
				IconUtil.SetupFallbackMapIcon( elIcon, "file://{images}/map_icons/map_icon_" + item.voteParam );
				elIcon.SetImage( "file://{images}/map_icons/map_icon_" + item.voteParam + ".svg" );
			});
		}
		this.enabled = choiceListFunc().length > 0;
	}

	function ConstructPopupAvatarChoicesVoteIssue( voteCommand, locToken, choiceListFunc )
	{
		ConstructBaseVoteIssue.call(this, voteCommand, locToken );
		this.cmd = function () {
			var elPopup = CreateVotePopupChoices( locToken );
			var voteFunc = function ( param ) { GameInterfaceAPI.ConsoleCommand( 'callvote ' + voteCommand + " " + param ); }
			
			choiceListFunc().forEach(function (item) {
				var elButton = MakeVoteButton(elPopup, "voteoption_" + item.voteParam,
					item.displayName,
					voteFunc.bind( undefined, item.voteParam ),
					"AvatarChoiceEntry"
				);
				elButton.FindChild("AvatarImage").PopulateFromSteamID(GameStateAPI.GetPlayerXuidStringFromPlayerSlot(item.voteParam));
			});
		}
		this.enabled = choiceListFunc().length > 0;
	}

	function ConstructRoundBackupVoteIssue( voteCommand, locToken, bEnabled, pollForBackups )
	{
		ConstructBaseVoteIssueEnabled.call(this, voteCommand, locToken, bEnabled );
		this.cmd = function () {
			$.DispatchEvent( 'ContextMenuEvent', '' );
			var elPopup = CreateVotePopupChoices( locToken );
			pollForBackups( elPopup );
		}
	}
	

	    
	                                       
	   
	function GetCurrentVoteIssues() {
		var VoteIssues = [];

		                                                             
		var bIsQueuedMatchmaking 	= GameStateAPI.IsQueuedMatchmaking();
		var bIsTournamentMatch 		= MatchStatsAPI.IsTournamentMatch();
		var bIsWarmup 				= FriendsListAPI.IsGameInWarmup();
		var bIsPaused 				= FriendsListAPI.IsGamePaused();
		var curGameMode 			= MatchStatsAPI.GetGameMode();
		var mapsInMapGroup			= GetMapTargets().length;
		var kickablePlayers			= GetKickTargets().length;
		var nLocalPlayerTeamNum		= GameStateAPI.GetAssociatedTeamNumber( GameStateAPI.GetLocalPlayerXuid() );
		var bLocalPlayerActiveTeam = ( nLocalPlayerTeamNum === 2 || nLocalPlayerTeamNum === 3 );

		  
		                                            
		                                                                                  
		                            
		                                     
		  

		if ( !bIsQueuedMatchmaking )
		{
			VoteIssues.push(new ConstructPopupMapChoicesVoteIssue("ChangeLevel", "#SFUI_Vote_ChangeMap", GetMapTargets ));
		}

		if ( bIsQueuedMatchmaking && !bIsTournamentMatch )
		{
			VoteIssues.push(new ConstructBaseVoteIssue("Surrender", "#SFUI_vote_surrender" ));
		}

		if ( bIsQueuedMatchmaking && bIsTournamentMatch )
		{
			if ( bLocalPlayerActiveTeam )
			{	                                              
				VoteIssues.push(new ConstructBaseVoteIssueEnabled( "starttimeout", "#SFUI_Vote_StartTimeout", !bIsWarmup && !bIsPaused ) );
				VoteIssues.push( new ConstructBaseVoteIssueEnabled( "PauseMatch", "#SFUI_Vote_pause_match", !bIsWarmup && !bIsPaused ) );
			}
			else
			{
				if ( bIsWarmup )
				{
					if ( !bIsPaused )
						VoteIssues.push( new ConstructBaseVoteIssue( "NotReadyForMatch", "#SFUI_Vote_not_ready_for_match") );
					else
						VoteIssues.push( new ConstructBaseVoteIssue( "ReadyForMatch", "#SFUI_Vote_ready_for_match") );
				}
				else
				{
					if ( bIsPaused )
						VoteIssues.push( new ConstructBaseVoteIssue( "UnpauseMatch", "#SFUI_Vote_unpause_match" ) );
					else
						VoteIssues.push( new ConstructBaseVoteIssue( "PauseMatch", "#SFUI_Vote_pause_match" ) );
				}

				VoteIssues.push( new ConstructRoundBackupVoteIssue("LoadBackup", "#SFUI_Vote_loadbackup1", !bIsWarmup, GetBackupFilenames ) );
			}
		}

		if ( !bIsTournamentMatch )
		{
			if  ( curGameMode === "competitive" || curGameMode === "scrimcomp5v5" || curGameMode === "scrimcomp2v2" )
			{
				VoteIssues.push(new ConstructBaseVoteIssue("starttimeout", "#SFUI_Vote_StartTimeout" ));
			}

			VoteIssues.push(new ConstructPopupAvatarChoicesVoteIssue("Kick", "#SFUI_Vote_KickPlayer", GetKickTargets));
		}

		return VoteIssues;
	}

	function _OnTabActivate() {
	
	}

	var _SetupContextMenu = function()
	{
		$.GetContextPanel().RemoveAndDeleteChildren();
		GetCurrentVoteIssues().forEach( function ( item ) {
			var p = $.CreatePanel( "Button", $.GetContextPanel(), "voteoption_" + item.id );
			p.BLoadLayoutSnippet( "VoteOption" );
			p.FindChild( "VoteOptionName" ).text = $.Localize( item.name );
			p.FindChild( "VoteOptionIcon" ).SetImage( item.icon );
			p.SetPanelEvent( "onactivate", function() {
				item.cmd();
				$.DispatchEvent( 'UIPopupButtonClicked', '' );
			});
			p.enabled = item.enabled;
		});
	};

	return {
		SetupContextMenu: _SetupContextMenu
	};
})();
