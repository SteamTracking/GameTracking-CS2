'use strict';

var PickEmGroup = ( function()
{
	// Groups stage layout is for tournaments 11 and up.
	// Tournaments 13 and up also use the groups layout and structure to show the prelim stage
	// The difference between the prelims and gourps is the dayIndex that is specified.
	// This is hard coded in the mainmanu_watch_tournament when we call _PopulateTournamentNavBarButtons.
	// When we call here we know that we are getting group/prelim stage.

	var _Init = function ( elPanel )
	{
		_SetPointsWorth( elPanel );
		_SetUpDragTargets( elPanel );
		_UpdateGroupPicks( elPanel );
	};

	var _UpdateGroupPicks = function( elPanel )
	{
		// Group Pickem Games only have one active section index and one active group that has 9 picks.

		if ( !elPanel._oPickemData.oTournamentData || !elPanel._oPickemData.oInitData )
		{
			// The data ahas not been assigned to exit early
			// This means you got here from an event that wants to update this but ther data is not there yet
			// This the case because the matchlist updates but user has not downloaded the tournament data
			return;
		}
		
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		var pickCount = oGroupData.pickscount;

		for ( var i = 0; i < pickCount; i++ )
		{
			var elPick = elPanel.FindChildInLayoutFile( 'id-pickem-pick' + i );
			var elItemImage = elPick.FindChildInLayoutFile( 'id-pick-itemimage' );

			var oItemIdData = PickemCommon.GetYourPicksItemIdData( 
				elPanel._oPickemData.oTournamentData.tournamentid, 
				oGroupData.picks[i].localid
			);
			
			PickemCommon.UpdateImageForPick( 
				oItemIdData,
				elItemImage, 
				oGroupData.picks[ i ].localid,
				PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oTournamentData.tournamentid ) >= 15 // use svg icon
			);

			PickemCommon.UpdateCorrectPickState(
				elPanel._oPickemData.oTournamentData.tournamentid,
				oGroupData,
				PredictionsAPI.GetGroupCorrectPicksByIndex( elPanel._oPickemData.oTournamentData.tournamentid, oGroupData.id, i ),
				oGroupData.picks[i].localid,
				elPick.FindChildInLayoutFile( 'id-pickem-points-for-pick' )
			);

			// START For Katowice 2019 we are using a pass that lets you play without the stickers.
			// Just going to set it to false.
			// var notOwned = PickemCommon.ShowPickItemNotOwnedWarning(
			// 	elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].isactive,
			// 	oGroupData,
			// 	oItemIdData,
			// 	elPick.FindChildInLayoutFile( 'id-pickem-not-owned' ),
			// 	oGroupData.picks[i].localid 
			// );
			//END
			var notOwned = false;
			
			oGroupData.picks[i].storedefindex = notOwned ? 
				PickemCommon.GetTeamItemDefIndex( oGroupData.picks[i].localid ):
				undefined;

			// we pass the panel object because we manipulate it on remove
			var elRemoveBtn = elPick.FindChildInLayoutFile( 'id-pick-cancelbtn' );
			var showRemoveBtn = PickemCommon.ShowHideRemoveBtn(
				elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].isactive,
				oGroupData.canpick,
				oGroupData.picks[i].localid,
				elRemoveBtn
			);

			if ( showRemoveBtn )
			{
				PickemCommon.UpdateRemoveBtn(
					elPanel,
					oGroupData,
					oGroupData.picks[i].localid,
					elPick.FindChildInLayoutFile( 'id-pick-cancelbtn' ),
					_UpdateGroupPicks
				);
			}

			elPick.SetHasClass( 'pickem-pick-placed', oGroupData.picks[ i ].localid ? true : false );
			elPick.SetHasClass( 'is-saved-pick', ( PickemCommon.IsPickSaved( oGroupData.picks[ i ] ) && oGroupData.canpick ));
			elPick.SetHasClass( 'pickem-pick-locked', !oGroupData.canpick );

			_UpdateTeams( elPanel );
		}

		// Since each pickem game has differnt rules for applying we pass functions that specify those rules
		PickemCommon.UpdateActionBarBtns( elPanel, _GetListOfPicksWithNoOwnedItems, _MakePicksParams, _EnableApply );
	};

	var _GetListOfPicksWithNoOwnedItems = function( elPanel )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		
		return oGroupData.picks.filter( index => index.storedefindex !== undefined );
	};

	var _MakePicksParams = function( elPanel, useFakeId = false )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var tournamentId = elPanel._oPickemData.oTournamentData.tournamentid;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		var count = oGroupData.pickscount;
		var args = [ tournamentId ];
		var groupId = oGroupData.id;
		var listPicks = oGroupData.picks;
		var idsForDisplayInConfimPopup = [];

		for ( var i = 0; i < count; ++i )
		{   // Add my prediction per each slot into the batch (3 params per each pick)
			var pickInGroupIndex = i; // integer
			var strStickerItemId = '';

			if ( listPicks[ i ].localid )
			{
				// empty string to clear, or ItemID string to assign
				var oItemIdData = PickemCommon.GetYourPicksItemIdData( 
					tournamentId, 
					oGroupData.picks[i].localid
				);

				strStickerItemId = oItemIdData.type === 'fakeitem' && !useFakeId ? '' : oItemIdData.itemid;

				if ( strStickerItemId )
				{
					idsForDisplayInConfimPopup.push( strStickerItemId );
				}
			}

			args.push( groupId, pickInGroupIndex, strStickerItemId ); // Add 3 params for this pick
		}

		return {
			args: args,
			idsForDisplayInConfimPopup: idsForDisplayInConfimPopup
		};
	};

	var _EnableApply = function( elPanel)
	{
		var tournamentNum = PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oInitData.tournamentid );

		if ( tournamentNum >= 15 )
		{
			var id = InventoryAPI.GetActiveTournamentCoinItemId( tournamentNum );
			if ( !id || id === '0' )
			{
				return false;
			}
		}
		
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		
		var picks = oGroupData.picks;

		var bFoundDifferenceToApply = false;
		var strErrorString = null;
	
		for ( var i = 0; i < oGroupData.pickscount; i++ )
		{
			if ( !picks[i].storedefindex )
			{	// Normalize null/undefined/zero as zeroes for comparison checking
				var idLocal = picks[i].localid;
				var idSaved = picks[i].savedid;
				if ( !idLocal ) idLocal = 0;
				if ( !idSaved ) idSaved = 0;
				if ( !idLocal && !strErrorString )
				{
					$.Msg( '_EnableAppy returning error because #' + i + ' local ' + picks[i].localid + ' has not been placed!' );
					strErrorString = '#pickem_apply_emptyslots';
				}
				if( !bFoundDifferenceToApply && idLocal !== idSaved )
				{
					$.Msg( '_EnableAppy found difference to apply because #' + i + ' local ' + picks[i].localid + ' != ' + picks[i].savedid );
					bFoundDifferenceToApply = true;
				}
			}
		}

		return bFoundDifferenceToApply ? ( strErrorString ? strErrorString : '#ok' ) : false;
	};


	var _SetPointsWorth = function( elPanel )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var points = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ].pickworth;
		var elLabel = elPanel.FindChildInLayoutFile( 'id-pickem-group-worth' );

		PickemCommon.SetPointsWorth( elLabel, points, elPanel._oPickemData.oInitData.tournamentid, activeSectionIdx );
	};

	var _UpdateTeams = function( elPanel )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		var groupId = oGroupData.id;
		var tournamentId = elPanel._oPickemData.oInitData.tournamentid;

		var teamCount = PredictionsAPI.GetGroupTeamsPickableCount( tournamentId, groupId );
		var elTeams = elPanel.FindChildInLayoutFile( 'id-pickem-groum-teams' );
		var isSectionActive = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].isactive;
		var groupCanPick = oGroupData.canpick;

		for ( var i = 0; i < teamCount; i++ )
		{
			var teamId = PredictionsAPI.GetGroupTeamIDByIndex( tournamentId, groupId, i );
			var uniqueId = tournamentId + elPanel._oPickemData.oInitData.xmltype + teamId;
			var elTeam = elTeams.FindChildInLayoutFile( uniqueId );

			if ( !teamId )
			{
				return;
			}
			
			if ( !elTeam )
			{
				elTeam = _CreateTeam( elTeams, uniqueId, teamId );
			}

			var elLogoImage = elTeam.FindChildInLayoutFile( 'id-team-logo' );
			PickemCommon.SetTeamImage( tournamentId, elLogoImage, elTeam );

			var isAlreadyPicked = _SetIsAlreadyPicked( elPanel, elTeam );

			$.Msg( 'isAlreadyPicked: ' + isAlreadyPicked + ', team: ' + PredictionsAPI.GetTeamName( elTeam._oteamData.teamid ) );

			if( isSectionActive && groupCanPick && !isAlreadyPicked )
			{
				_EnableDraggableEvents( elTeam );
			}
			else
			{
				_DisableDraggable( elTeam );
			}

			_TeamTooltips( elTeam );
		}
	};

	var _CreateTeam = function( elTeams, uniqueId, teamId )
	{
		var elTeam = $.CreatePanel( "Panel", elTeams, uniqueId );
		elTeam.BLoadLayoutSnippet( "team" );

		if ( typeof elTeam._oteamData !== 'object' )
		{
			elTeam._oteamData = {};
		}

		elTeam._oteamData.teamid = teamId;

		return elTeam;
	};

	var _SetIsAlreadyPicked = function ( elPanel, elTeam )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		
		var isAlreadyPick = PickemCommon.CheckIfTeamIsAlreadyPicked( oGroupData, elTeam._oteamData.teamid );
		var elUsed = elTeam.FindChildInLayoutFile( 'id-team-used' );
		elUsed.SetHasClass( 'hidden', !isAlreadyPick );

		return isAlreadyPick;
	};

	var _EnableDraggableEvents = function ( elTeam )
	{
		elTeam.IsDraggable = true;
		elTeam.enabled = true;

		if ( elTeam._oteamData.dragStartHandle ) 
		{
			return;
		}

		elTeam._oteamData.dragStartHandle = $.RegisterEventHandler( 'DragStart', elTeam, function ( targetId, obj ) {
			var elDraggable = $.CreatePanel( "Image", elTeam, 'draggable' + elTeam._oteamData.teamid, {
				src: PickemCommon.GetTeamImage( elTeam ),
				class: 'pickem-team-draggable',
				textureheight: '128',
				texturewidth: '128'
			} );

			if ( typeof elDraggable._oteamData !== 'object' )
			{
				elDraggable._oteamData = {};
			}
			
			elDraggable._oteamData = elTeam._oteamData;

			obj.displayPanel = elDraggable;
			obj.removePositionBeforeDrop = false;
			elDraggable.AddClass( 'dragstart' );
		} );

		$.RegisterEventHandler( 'DragEnd', elTeam, function ( targetId, obj ) {
			obj.AddClass( 'dragend' );
			obj.DeleteAsync( 0.25 );
		} );
	};
	
	var _DisableDraggable = function ( elTeam )
	{
		elTeam.IsDraggable = false;
		elTeam.enabled = false;
	};

	var _TeamTooltips = function( elTeam )
	{
		var OnMouseOver = function ( elTeam )
		{
			UiToolkitAPI.ShowTextTooltip( elTeam.id, PredictionsAPI.GetTeamName( elTeam._oteamData.teamid ) );

			if( elTeam.IsDraggable )
			{
				elTeam.AddClass('pickem-group-pick--wiggle');
			}
		};

		var OnMouseOut = function ( elTeam ) 
		{
			UiToolkitAPI.HideTextTooltip();
			elTeam.RemoveClass('pickem-group-pick--wiggle');
		};

		elTeam.SetPanelEvent( 'onmouseover', OnMouseOver.bind( undefined, elTeam ) );
		elTeam.SetPanelEvent( 'onmouseout', OnMouseOut.bind( undefined, elTeam ) );
	};

	var _SetUpDragTargets = function( elPanel )
	{
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var picksCount = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ].pickscount;
		
		if ( typeof elPanel._odraggableData !== 'object' )
		{
			elPanel._odraggableData = {};
		}

		var _DragEnter = function( elDragTarget )
		{
			elDragTarget.AddClass( 'dragenter' );

			//Store the active drag target so when we drop the draggable we know what we dropped it on.
			elPanel._odraggableData.dragtarget = elDragTarget.GetParent();
		};

		var _DragLeave = function( elDragTarget )
		{
			elDragTarget.RemoveClass( 'dragenter' );
			elPanel._odraggableData.dragtarget = null;
		};

		for ( var i = 0; i < picksCount; i++ )
		{
			var elPick = elPanel.FindChildInLayoutFile( 'id-pickem-pick' + i );
			var elDragTarget= elPick.FindChildInLayoutFile( 'id-pick-boundingbox' );

			$.RegisterEventHandler(
				'DragEnter',
				elDragTarget,
				_DragEnter.bind( undefined, elDragTarget )
			);
			
			$.RegisterEventHandler(
				'DragLeave',
				elDragTarget,
				_DragLeave.bind( undefined, elDragTarget )
			);
		
			$.RegisterEventHandler(
				'DragDrop',
				elDragTarget,
				function( dispayId, elDisplay )
				{
					// $.Msg( 'dispayId' + dispayId );
					// $.Msg( 'DragDrop' + elDisplay.id );
					_PlaceTempPick( elPanel, elDisplay._oteamData.teamid );
				}
			);
		}
	};

	var _PlaceTempPick = function( elPanel, teamid )
	{
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE' );
		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;
		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];
		
		//elPanel._dragtarget._pickdex = teamid;
		if ( elPanel._odraggableData.dragtarget && elPanel._odraggableData.dragtarget.IsValid() )
		{
			var pickIndex = elPanel._odraggableData.dragtarget.GetAttributeString( 'data-pick-index', '' );
		}
		else
		{
			return;
		}

		if( pickIndex )
		{
			oGroupData.picks[ Number( pickIndex ) ].localid = teamid;
		}

		_UpdateGroupPicks( elPanel );
	};

	var _UpdatePrediction = function( elPanel )
	{
		$.Msg( 'Groups Prediction Updated' );

		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;

		if( !elPanel._oPickemData.oTournamentData )
		{
			return;
		}

		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];

		if ( !oGroupData )
		{
			// This can be called by events fired after the panel closes, no work 
			// to be done but early out to avoid JS errors.
			return;
		}

		if ( !oGroupData || !oGroupData.pickscount )
			return;

		//Update the saved team ids with new ones then update the picks
		for ( var i = 0; i < oGroupData.pickscount; i++ )
		{
			var elPick = elPanel.FindChildInLayoutFile( 'id-pickem-pick' + i );
			var userPickTeamID = PredictionsAPI.GetMyPredictionTeamID( elPanel._oPickemData.oInitData.tournamentid, oGroupData.id, i );
			oGroupData.picks[i].savedid = userPickTeamID;
				
			if( PickemCommon.IsPickSaved( oGroupData.picks[i] ) && oGroupData.canpick )
			{
				elPick.FindChildInLayoutFile('id-pick-boundingbox').TriggerClass( 'pickem-group-pick-update' );
			}
		}

		_UpdateGroupPicks( elPanel );

	};
	
	var _PurchaseComplete = function( elPanel )
	{
		_UpdateGroupPicks( elPanel );
	}

	return{
		Init : _Init,
		UpdatePrediction : _UpdatePrediction,
		PurchaseComplete : _PurchaseComplete
	};
})();	

// var Dragtest = function( elPanel )
// {
	// var elTest = elPanel.FindChildInLayoutFile( "test1" );
	// $.Msg( 'isdraggable' + elTest.IsDraggable() );

	// var elTest = elPanel.FindChildInLayoutFile( "test1" );

	// $.RegisterEventHandler( 'DragStart', elTest, function( targetId,  obj )
	// {
	//     obj.displayPanel = elPanel.FindChildInLayoutFile( "test2" );
	//     obj.removePositionBeforeDrop = false;
	// } );

	// $.RegisterEventHandler( 'DragEnd', elTest, function( targetId,  obj )
	// {
	//     //obj.displayPanel = elPanel.FindChildInLayoutFile( "test2" );
	//    // obj.removePositionBeforeDrop = false;
	// } );


	// var elTestTarget = elPanel.FindChildInLayoutFile( "test1target" );
	// $.RegisterEventHandler( 'DragEnter', elTestTarget, function( dispayId, elDisplay ) { $.Msg( 'DragEnter' + dispayId ) } );
	// $.RegisterEventHandler( 'DragLeave', elTestTarget, function( dispayId, elDisplay ) { $.Msg( 'DragLeave' + dispayId ) } );
	// $.RegisterEventHandler( 'DragDrop', elTestTarget, function( dispayId, elDisplay ) { $.Msg( 'DragDrop' + dispayId ), elDisplay.DeleteAsync( .0 )} );
// };