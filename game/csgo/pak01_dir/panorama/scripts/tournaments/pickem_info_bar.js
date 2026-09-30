'use strict';

var PickEmInfoBar = ( function()
{
	var _Init = function ( elPanel )
	{
		_SetUpHowToPlayLink( elPanel );
		_SetUpLeaderboardButton( elPanel );
		_UpdateTimer( elPanel );
		_UpdateScore( elPanel );
		_SetUpLiveButton( elPanel );
	};

	var _SetUpHowToPlayLink = function( elPanel )
	{
		var elParent = elPanel.FindChildTraverse( 'id-pickem-info' );
		var elLink = elParent.FindChildTraverse( 'id-pickem-how-to-play' );
		var olinks = {
			16: "http://www.counter-strike.net/pickem/berlin2019#team_instructions",
			15: "http://www.counter-strike.net/pickem/katowice2019#team_instructions",
			14: "http://www.counter-strike.net/pickem/london2018#team_instructions",
			13: "http://www.counter-strike.net/pickem/boston2018#team_instructions",
			12: "http://www.counter-strike.net/pickem/krakow2017#team_instructions"
		};

		var tournamentNum = PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oInitData.tournamentid );

		if ( olinks.hasOwnProperty( tournamentNum ) )
		{
			var link = olinks[ tournamentNum ];
			elLink.SetPanelEvent( 'onactivate', function() { SteamOverlayAPI.OpenURL( link ); } );
			return;
		}

		elLink.visible = false;
	};

	var _SetUpLeaderboardButton = function( elPanel )
	{
		var elParent = elPanel.FindChildTraverse( 'id-pickem-info' );
		var elLink = elParent.FindChildTraverse( 'id-pickem-leaderboards' );
		var olinks = {
			14: "official_leaderboard_pickem_london2018_team",
			13: "official_leaderboard_pickem_boston2018_team",
			12: "official_leaderboard_pickem_krakow2017_team"
		};

		var tournamentNum = PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oInitData.tournamentid );

		var _OnActivate = function()
		{
			UiToolkitAPI.ShowCustomLayoutPopupParameters( 
				'', 
				'file://{resources}/layout/popups/popup_leaderboards.xml',
				'type=' + olinks[ tournamentNum  ],
				'none'
			);
		};

		if ( olinks.hasOwnProperty( tournamentNum ) )
		{
			var link = olinks[ tournamentNum ];
			elLink.enabled = true;

			elLink.SetPanelEvent( 'onactivate', _OnActivate );
			return;
		}

		elLink.enabled = false;
	};

	var _UpdateTimer = function( elPanel, optbFromScheduledEvent )
	{
		if ( optbFromScheduledEvent && elPanel._oPickemData.oInitData.schPickEmInfoBarUpdateTimer )
		{	                                                                                      
			elPanel._oPickemData.oInitData.schPickEmInfoBarUpdateTimer = null;
			                                                                             
		}

		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		
		var elStatus = elPanel.FindChildTraverse( 'id-pickem-lock-status' );
		var elIcon = elPanel.FindChildTraverse( 'id-pickem-lock-status-icon' );
		var secRemaining = PredictionsAPI.GetGroupRemainingPredictionSeconds( elPanel._oPickemData.oInitData.tournamentid, oGroupData.id );

		var sectionId = PredictionsAPI.GetEventSectionIDByIndex( elPanel._oPickemData.oInitData.tournamentid, elPanel._oPickemData.oInitData.sectionindex );
		var isActive = PredictionsAPI.GetSectionIsActive( elPanel._oPickemData.oInitData.tournamentid, sectionId );
		var canPick = PredictionsAPI.GetGroupCanPick( elPanel._oPickemData.oInitData.tournamentid, oGroupData.id );

		var elStatusBar = elPanel.FindChildTraverse( 'id-pickem-status' );
		elStatusBar.SetHasClass( 'pickem-header-status--active', ( isActive && canPick && secRemaining > 0 ) );

		if ( !isActive && canPick )
		{
			                                                                                
			elIcon.SetImage( 'file://{images}/icons/ui/locked.svg' );
			elStatus.text = $.Localize( '#pickem_timer_inactive' );
		   
		}
		else if ( canPick && secRemaining > 0 )
		{
			                                                                               
			elIcon.SetImage( 'file://{images}/icons/ui/clock.svg' );
			elStatus.SetDialogVariable( 'time', FormatText.SecondsToSignificantTimeString( secRemaining ) );
			elStatus.text = $.Localize( '#pickem_timer', elStatus );

			if ( !elPanel._oPickemData.oInitData.schPickEmInfoBarUpdateTimer )
			{
				elPanel._oPickemData.oInitData.schPickEmInfoBarUpdateTimer = $.Schedule( 1, _UpdateTimer.bind( undefined, elPanel, true ));
			}
			return;

		}
		else if ( !canPick )
		{
			                                                         
			elIcon.SetImage( 'file://{images}/icons/ui/locked.svg' );
			elStatus.text = $.Localize( '#pickem_timer_locked' );
		}
		else
		{
			                                            
			elIcon.SetImage( 'file://{images}/icons/ui/clock.svg' );
			elStatus.SetDialogVariable( 'time', FormatText.SecondsToSignificantTimeString( 60 ) );
			elStatus.text = $.Localize( '#pickem_timer', elStatus );
		}
	};


	var _UpdateScore = function( elPanel )
	{
		                                                                                            
		if ( PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oInitData.tournamentid ) >= 15 )
			return;
		
		var pointsEarned = PredictionsAPI.GetMyPredictionsTotalPoints( elPanel._oPickemData.oInitData.tournamentid );
		var bronzePoints = PredictionsAPI.GetRequiredPredictionsPointsBronze( elPanel._oPickemData.oInitData.tournamentid );
		var silverPoints = PredictionsAPI.GetRequiredPredictionsPointsSilver( elPanel._oPickemData.oInitData.tournamentid );
		var goldPoints = PredictionsAPI.GetRequiredPredictionsPointsGold( elPanel._oPickemData.oInitData.tournamentid );
		var doesTournamentHaveAWinner = DoesTournamentHaveAWinner( elPanel._oPickemData.oInitData.tournamentid );

		var elYourPoints = elPanel.FindChildTraverse( 'id-pickem-your-points' );
		elYourPoints.text = ( pointsEarned && pointsEarned > 0 ) ? pointsEarned : '-';

		var nextLevel = '';
		var resultLevel = '';
		var pointsNeeded = null;
		var elbar = elPanel.FindChildTraverse( 'id-pickem-info' );
		var elPointsNeeded = elPanel.FindChildTraverse( 'id-pickem-points-needed' );
		var elPointsNeededLabel = elPointsNeeded.FindChildTraverse( 'id-pickem-points-needed-Label' );
		var elPointsResultLabel = elPointsNeeded.FindChildTraverse( 'id-pickem-points-result-Label' );

		if ( pointsEarned < bronzePoints )
		{
			nextLevel = 'bronze';
			elPointsResultLabel.visible = false;
			resultLevel = '';
			pointsNeeded = bronzePoints - pointsEarned;
		}
		else if ( pointsEarned >= bronzePoints && pointsEarned < silverPoints )
		{
			nextLevel = 'silver';
			resultLevel = 'bronze';
			pointsNeeded = silverPoints - pointsEarned;
		}
		else if ( pointsEarned < goldPoints )
		{
			nextLevel = 'gold';
			resultLevel = 'silver';
			pointsNeeded = goldPoints - pointsEarned;
		}
		else if ( pointsEarned >= goldPoints )
		{
			nextLevel = 'gold';
			resultLevel = 'gold';
			pointsNeeded = 0;
		}

		if ( doesTournamentHaveAWinner )
		{
			elPointsNeededLabel.visible = false;
			elPointsResultLabel.visible = ( resultLevel !== '' ) ? true : false;

			elbar.AddClass( 'pickem-info-bar--'+ resultLevel );

			if( resultLevel )
			{
                elPointsResultLabel.text = '#pickem_points_result_' + resultLevel;
				SetTrophyImage( elPanel, resultLevel );
			}
		}
		else
		{
			elPointsNeededLabel.visible = true;
			elPointsResultLabel.visible = false;

			elPointsNeeded.SetDialogVariable( 'level', $.Localize( '#pickem_level_' + nextLevel ));
			elPointsNeeded.SetDialogVariableInt( 'points', pointsNeeded );
			
			var pluralString = pointsNeeded === 1 ? $.Localize( '#pickem_point' ) : $.Localize( '#pickem_points' );
			elPointsNeeded.SetDialogVariable( 'plural', pluralString );

			elPointsNeededLabel.text = $.Localize( '#pickem_points_needed_next_level', elPointsNeeded );
		}
	};

	var _SetUpLiveButton = function ( elPanel )
	{
		var elParent = elPanel.FindChildTraverse( 'id-pickem-info' );
		var elBtn = elParent.FindChildInLayoutFile( 'JsTournamentLiveMatch' );
		var matchId = GetLiveMatchId( elPanel._oPickemData.oInitData.tournamentid );

		                                                 
		var bIsMinimalMatchInfo = MatchInfoAPI.IsServerLogTournamentMatch( matchId ); 
		if ( bIsMinimalMatchInfo )
			matchId = '';
		
		if( matchId )
		{

			for( var i = 0; i < 2; i ++ )
			{
				var teamId = MatchInfoAPI.GetMatchTournamentTeamID( matchId, i );
				var teamTag = PredictionsAPI.GetTeamTag( teamId );
				var iconFilename = 'file://{images}/tournaments/teams/' + teamTag + '.svg';
				
				elBtn.FindChildInLayoutFile( 'JsTournamentLiveMatchTeam' + i ).SetImage(  iconFilename );
			}

			elBtn.SetPanelEvent( 'onactivate', function (){
				MatchInfoAPI.Watch( matchId, 0 );
			});
		}

		elBtn.SetHasClass( 'hidden', matchId === '' );
	};

	function GetLiveMatchId( listerType )
	{
		var liveMatchesCount = 0;
		
		if ( MatchListAPI.GetCount( listerType ) != undefined )
		{
			liveMatchesCount = MatchListAPI.GetCount( listerType );
		}
		else
		{
			return '';
		}
		
		if ( liveMatchesCount > 0 )
		{
			for ( var i = 0; i < liveMatchesCount; i++ )
			{
				var MatchId = MatchListAPI.GetMatchByIndex( listerType , i )
				var TName = MatchInfoAPI.GetMatchTournamentName ( MatchId );
				var Status = MatchInfoAPI.GetMatchState( MatchId );
				
				if (( TName != "" && TName != null && TName != undefined ) && Status == "live" )
				{
					return MatchId;
				}
			}
		}
		
		return '';
	}

	var SetTrophyImage = function( elPanel, resultLevel )
	{
		var tournamentId = elPanel._oPickemData.oInitData.tournamentid;
		
		function GetTrophyIconPath( tournamentId )
		{
			if ( tournamentId == "tournament:4" )
				return "econ/status_icons/cologne_prediction_";
			else if ( tournamentId == "tournament:5" )
				return "econ/status_icons/dhw14_prediction_";
			else if ( tournamentId == "tournament:6" )
				return "econ/status_icons/kat_2015_prediction_";
			else if ( tournamentId == "tournament:7" )
				return "econ/status_icons/col_2015_prediction_";
			else if ( tournamentId == "tournament:8" )
				return "econ/status_icons/cluj_2015_prediction_";
			else if ( tournamentId == "tournament:9" )
				return "econ/status_icons/mlg_2016_pickem_";
			else if ( tournamentId == "tournament:10" )
				return "econ/status_icons/cologne_pickem_2016_";
			else if ( tournamentId == "tournament:11" )
				return "econ/status_icons/atlanta_pickem_2017_";
			else if ( tournamentId == "tournament:12" )
				return "econ/status_icons/krakow_pickem_2017_";
			else if ( tournamentId == "tournament:13" )
				return "econ/status_icons/boston_pickem_2018_";
			else if ( tournamentId == "tournament:14" )
				return "econ/status_icons/london_pickem_2018_";
			else
				return '';
		}

		if ( GetTrophyIconPath( tournamentId ) !== '' )
		{
			var elTrophyImage = elPanel.FindChildTraverse( 'id-pickem-trophy-image' );
			elTrophyImage.RemoveClass( 'hidden' );
			elTrophyImage.SetImage( 'file://{images}/' + GetTrophyIconPath( tournamentId ) + resultLevel + '.png' );
		}
	};

	var DoesTournamentHaveAWinner = function ( tournamentId )
	{
		var numSections = PredictionsAPI.GetEventSectionsCount( tournamentId );
		var numDayID = PredictionsAPI.GetEventSectionIDByIndex( tournamentId, numSections - 1 );
		var numGroups = PredictionsAPI.GetSectionGroupsCount( tournamentId, numDayID );
		var numGroupId = PredictionsAPI.GetSectionGroupIDByIndex( tournamentId, numDayID, numGroups - 1 );
		var WinnerTeamId = PredictionsAPI.GetGroupCorrectPicksByIndex( tournamentId, numGroupId, 0 );
		var srtTeamTag = PredictionsAPI.GetTeamTag( Number( WinnerTeamId ));
		
		if( srtTeamTag != undefined && srtTeamTag != "" && srtTeamTag != null )
			return true;
		else
			return false;
	};

	return{
		Init : _Init
	};


} )();
