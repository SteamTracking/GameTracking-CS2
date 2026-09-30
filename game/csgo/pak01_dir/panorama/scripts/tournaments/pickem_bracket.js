
'use strict';

var PickEmBracket = ( function()
{
	var _Init = function ( elPickemPanel )
	{
		_UpdateAllSections( elPickemPanel );
		_UpdatePicksWorth( elPickemPanel );
	};

	var _UpdateAllSections = function ( elPickemPanel, showIdPickIsSaved )
	{
		if ( !elPickemPanel._oPickemData.oTournamentData || !elPickemPanel._oPickemData.oInitData )
		{
			return;
		}
		
		var sectionCount = elPickemPanel._oPickemData.oTournamentData.sections.length;
		var startIndex = elPickemPanel._oPickemData.oInitData.sectionindex;

		for( var i = startIndex; i < sectionCount; i++ )
		{
			_UpdateSection( elPickemPanel, i, showIdPickIsSaved );
		}
	};

	var _UpdateSection = function ( elPickemPanel, sectionIndex, showIdPickIsSaved )
	{
		var groupsCount = elPickemPanel._oPickemData.oTournamentData.sections[ sectionIndex ].groups.length;

		for( var i = 0; i < groupsCount; i++ )
		{
			                                                                                                
			                                     
			if( sectionIndex === elPickemPanel._oPickemData.oInitData.sectionindex )
			{
				_SetUpFirstDayTeams( elPickemPanel, sectionIndex, i );
			}

			_UpdatePicksInGroup( elPickemPanel, sectionIndex, i, showIdPickIsSaved );
		}
	};

	var _SetUpFirstDayTeams = function ( elPickemPanel, sectionIndex, groupIndex )
	{
		var oGroupInfoForUpdate = _GetDataNeededToUpdateTeams( elPickemPanel, sectionIndex, groupIndex );

		for( var i = 0; i < oGroupInfoForUpdate.oGroupData.teamscount; i++ )
		{
			var elTeam = elPickemPanel.FindChildInLayoutFile(
				'id-bracket-section' +
				( sectionIndex - oGroupInfoForUpdate.startIndex ) +
				'-group' +
				groupIndex +
				'-pick' +
				i
			);

			elTeam.AddClass( 'pickem-pick-placed' );

			var teamId = PredictionsAPI.GetGroupTeamIDByIndex( oGroupInfoForUpdate.tournamentId, oGroupInfoForUpdate.oGroupData.id, i );
			var elName = elTeam.FindChildInLayoutFile( 'id-team-name' );
			var elLogoImage = elTeam.FindChildInLayoutFile( 'id-team-logo' );

			if ( typeof elTeam._oteamData !== 'object' )
			{
				elTeam._oteamData = {};
			}
			
			elTeam._oteamData.sectionindex = sectionIndex;
			elTeam._oteamData.groupindex = groupIndex;

			if( !teamId )
			{
				elName.text = $.Localize( '#CSGO_PickEm_Team_TBD' );
				elLogoImage.AddClass( 'hidden' );
				elName.AddClass( 'pickem-bracket-team__name--long' );
			}
			else
			{
				elTeam._oteamData.teamid = teamId;
				elLogoImage.RemoveClass( 'hidden' );
				elName.RemoveClass( 'pickem-bracket-team__name--long' );
				PickemCommon.SetTeamImage( oGroupInfoForUpdate.tournamentId, elLogoImage, elTeam );

				elName.text = PredictionsAPI.GetTeamName( teamId );
				_SetUpIsDraggable( elPickemPanel, elTeam, oGroupInfoForUpdate.oGroupData );
				_SetUpMouseOverEvents( elTeam );
			}

			elTeam.AddClass( 'pickem-bracket-team-outline' );
		}
	};

	var _UpdatePicksInGroup = function ( elPickemPanel, sectionIndex, groupIndex, showIdPickIsSaved )
	{
		var oGroupInfoForUpdate = _GetDataNeededToUpdateTeams( elPickemPanel, sectionIndex, groupIndex );

		var elGroup = elPickemPanel.FindChildInLayoutFile(
			'id-bracket-section' +
			( sectionIndex - oGroupInfoForUpdate.startIndex ) +
			'-group' +
			groupIndex
		);

		var targetsList = _GetTargetsList( elGroup );
		var elPick = elPickemPanel.FindChildInLayoutFile( targetsList[0] );
		var localTeamId = oGroupInfoForUpdate.oGroupData.picks[0].localid;

		var oItemIdData = PickemCommon.GetYourPicksItemIdData( 
			elPickemPanel._oPickemData.oTournamentData.tournamentid, 
			localTeamId
			);

		PickemCommon.UpdateCorrectPickState(
			elPickemPanel._oPickemData.oTournamentData.tournamentid,
			oGroupInfoForUpdate.oGroupData,
			PredictionsAPI.GetGroupCorrectPicksByIndex( elPickemPanel._oPickemData.oTournamentData.tournamentid, oGroupInfoForUpdate.oGroupData.id, 0 ),
			localTeamId,
			elPick.FindChildInLayoutFile( 'id-pickem-points-for-pick' ),
			true
		);

		var isBracketActive = _SetIsLocked( elPickemPanel );

		                                                                                       
		                                 
		                                                           
		   	                                                                           
		   	           
		   	            
		   	                                                      
		   	                            
		     
		     
		var notOwned = false;

		oGroupInfoForUpdate.oGroupData.picks[0].storedefindex = notOwned ? 
			PickemCommon.GetTeamItemDefIndex( oGroupInfoForUpdate.oGroupData.picks[0].localid ):
			undefined;

		var elRemoveBtn = elPick.FindChildInLayoutFile( 'id-pick-cancelbtn' );
		var showRemoveBtn = PickemCommon.ShowHideRemoveBtn(
			isBracketActive,
			oGroupInfoForUpdate.oGroupData.canpick,
			localTeamId,
			elRemoveBtn
		);

		if ( showRemoveBtn )
		{
			elRemoveBtn.SetPanelEvent(
				'onactivate',
				_RemoveBracketsPicks.bind(
					undefined,
					elPickemPanel,
					elPick
				)
			);
		}

		_UpdatePick( elPickemPanel, elPick, oGroupInfoForUpdate, oItemIdData, sectionIndex, groupIndex );

		if( !elPick._oteamData.hasDragTargetEvents )
		{
			_SetUpDragTargets( elPickemPanel, elPick );
			elPick._oteamData.hasDragTargetEvents = true;
		}

		if ( showIdPickIsSaved && oGroupInfoForUpdate.oGroupData.canpick )
		{
			_ShowIfPickIsSaved( oGroupInfoForUpdate.oGroupData, elPick );
		}

		                                                                                                    
		PickemCommon.UpdateActionBarBtns( elPickemPanel, _GetListOfPicksWithNoOwnedItems, _MakePicksParams, _EnableApply );
	};

	var _UpdatePick = function( elPickemPanel, elPick, oGroupInfoForUpdate, oItemIdData, sectionIndex, groupIndex )
	{
		var elName = elPick.FindChildInLayoutFile( 'id-team-name' );
		var elLogoImage = elPick.FindChildInLayoutFile( 'id-team-logo' );
		var localTeamId = oGroupInfoForUpdate.oGroupData.picks[0].localid;
		
		if ( typeof elPick._oteamData !== 'object' )
		{
			elPick._oteamData = {};
		}
		
		if ( localTeamId )
		{
			elPick._oteamData.teamid = localTeamId;
			elLogoImage.RemoveClass( 'hidden' );
	
			PickemCommon.SetTeamImage(
				elPickemPanel._oPickemData.oTournamentData.tournamentid,
				elLogoImage,
				elPick,
				oItemIdData.type === 'fakeitem' ? oItemIdData.itemid : ''
			);

			elName.RemoveClass( 'hidden' );
			elName.text = PredictionsAPI.GetTeamName( localTeamId );

			if ( sectionIndex !== elPickemPanel._oPickemData.oTournamentData.sections.length - 1 )
			{
				_SetUpIsDraggable( elPickemPanel, elPick, oGroupInfoForUpdate.oGroupData );
				_SetUpMouseOverEvents( elPick );
			}
		}
		else
		{
			elLogoImage.AddClass( 'hidden' );
			elName.AddClass( 'hidden' );
		}

		elPick._oteamData.picksectionindex = sectionIndex;
		elPick._oteamData.pickgroupindex = groupIndex;

		var isBracketActive = _SetIsLocked( elPickemPanel );
		
		elPick.SetHasClass( 'pickem-pick-placed', localTeamId ? true : false );
		elPick.SetHasClass( 'is-saved-pick', ( PickemCommon.IsPickSaved( oGroupInfoForUpdate.oGroupData.picks[0] ) && oGroupInfoForUpdate.oGroupData.canpick ));
		elPick.GetParent().SetHasClass( 'pickem-pick-locked', !isBracketActive );
	};

	var _SetIsLocked = function( elPickemPanel )
	{
		var startIndex = elPickemPanel._oPickemData.oInitData.sectionindex;
		return elPickemPanel._oPickemData.oTournamentData.sections[ startIndex ].isactive;
	};

	var _ShowIfPickIsSaved = function( oGroupData, elPick )
	{
		if ( PickemCommon.IsPickSaved( oGroupData.picks[ 0 ] ) )
		{
			elPick.RemoveClass( 'dragdrop' );
			elPick.TriggerClass( 'pickem-group-pick-update' );
		}
	};

	var _GetListOfPicksWithNoOwnedItems = function( elPickemPanel )
	{
		                                                                                                      
		                            
		var startIndex = elPickemPanel._oPickemData.oInitData.sectionindex;
		var oSectionData = elPickemPanel._oPickemData.oTournamentData.sections[ startIndex ];
		var groupsCount = oSectionData.groups.length;
		var aNotOwnedItems = [];

		for ( var i = 0; i < groupsCount; i++ )
		{
			var storeIndex = oSectionData.groups[ i ].picks[ 0 ].storedefindex;
			
			if ( storeIndex )
			{
				aNotOwnedItems.push( oSectionData.groups[ i ].picks[ 0 ] );
			}
		}

		return aNotOwnedItems;
	};

	var _MakePicksParams = function( elPickemPanel, useFakeItems = false )
	{
		var sectionCount = elPickemPanel._oPickemData.oTournamentData.sections.length;
		var startIndex = elPickemPanel._oPickemData.oInitData.sectionindex;
		var tournamentId = elPickemPanel._oPickemData.oTournamentData.tournamentid;
		var args = [ tournamentId ];
		var idsForDisplayInConfimPopup = [];

		for ( var i = startIndex; i < sectionCount; i++ )
		{
			var groupsList= elPickemPanel._oPickemData.oTournamentData.sections[ i ].groups;
			var groupsCount = groupsList.length;

			for ( var j = 0; j < groupsCount; j++ )
			{
				var strStickerItemId = '';
				var groupId = groupsList[ j ].id;

				if ( groupsList[ j ].picks[ 0 ].localid )
				{	
					                                                    
					var oItemIdData = PickemCommon.GetYourPicksItemIdData( 
						tournamentId, 
						groupsList[j].picks[0].localid
					);

					strStickerItemId = oItemIdData.type === 'fakeitem' && !useFakeItems ? '' : oItemIdData.itemid;

					if ( strStickerItemId && ( idsForDisplayInConfimPopup.indexOf( strStickerItemId ) === -1 ))
					{
						idsForDisplayInConfimPopup.push( strStickerItemId );
					}
				}

				args.push( groupId, 0, strStickerItemId );                              
			}
		}

		return {
			args: args,
			idsForDisplayInConfimPopup: idsForDisplayInConfimPopup
		};
	};

	var _EnableApply = function( elPickemPanel )
	{
		var tournamentNum = PickemCommon.GetTournamentIdNumFromString( elPickemPanel._oPickemData.oInitData.tournamentid );

		if ( tournamentNum >= 15 )
		{
			var id = InventoryAPI.GetActiveTournamentCoinItemId( tournamentNum );
			if ( !id || id === '0' )
			{
				return false;
			}
		}

		var bFoundDifferenceToApply = false;
		var strErrorString = null;
		
		var sectionCount = elPickemPanel._oPickemData.oTournamentData.sections.length;
		var startIndex = elPickemPanel._oPickemData.oInitData.sectionindex;

		for ( var i = startIndex; i < sectionCount; i++ )
		{
			var groupsList= elPickemPanel._oPickemData.oTournamentData.sections[ i ].groups;
			var groupsCount = groupsList.length;

			for ( var j = 0; j < groupsCount; j++ )
			{
				if ( !groupsList[j].picks[0].storedefindex )
				{	                                                                  
					var idLocal = groupsList[j].picks[0].localid;
					var idSaved = groupsList[j].picks[0].savedid;
					if ( !idLocal ) idLocal = 0;
					if ( !idSaved ) idSaved = 0;
					if ( !idLocal && !strErrorString )
					{
						                                                                                                     
						strErrorString = '#pickem_apply_emptyslots';
					}
					if( !bFoundDifferenceToApply && idLocal !== idSaved )
					{
						                                                                                                                                                                
						bFoundDifferenceToApply = true;
					}
				}
			}
		}

		return bFoundDifferenceToApply ? ( strErrorString ? strErrorString : '#ok' ) : false;
	};

	var _RemoveBracketsPicks = function ( elPickemPanel, elPick )
	{
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE' );

		function ResetLocalId ( oGroupData, elPick )
		{
			if ( oGroupData.picks[ 0 ].localid === elPick._oteamData.teamid )
			{
				oGroupData.picks[ 0 ].localid = 0;
			}
		}

		var sectionIndex = elPick._oteamData.picksectionindex;
		var groupIndex = elPick._oteamData.pickgroupindex;
		var oGroupData = elPickemPanel._oPickemData.oTournamentData.sections[ sectionIndex ].groups[ groupIndex ];
		ResetLocalId( oGroupData, elPick );
		
		var validTargets = _GetTargetsList( elPick.GetParent() );
		var targetCount = validTargets.length;

		for ( var i = 0; i < targetCount; i++ )
		{
			var elValidTarget = elPickemPanel.FindChildInLayoutFile( validTargets[ i ] );
			sectionIndex = elValidTarget._oteamData.picksectionindex;
			groupIndex = elValidTarget._oteamData.pickgroupindex;
			oGroupData = elPickemPanel._oPickemData.oTournamentData.sections[ sectionIndex ].groups[ groupIndex ];

			ResetLocalId( oGroupData, elPick );
		}

		_UpdateAllSections( elPickemPanel );
	};

	var _GetDataNeededToUpdateTeams = function ( elPickemPanel, sectionIndex, groupIndex )
	{
		return {
			oGroupData: elPickemPanel._oPickemData.oTournamentData.sections[ sectionIndex ].groups[ groupIndex ],
			tournamentId: elPickemPanel._oPickemData.oTournamentData.tournamentid,
			startIndex: elPickemPanel._oPickemData.oInitData.sectionindex
		};
	};

	var _SetUpIsDraggable = function( elPickemPanel, elTeam, oGroupData )
	{	
		if ( !oGroupData.canpick )
		{
			elTeam.IsDraggable = false;
			return;
		}
		
		if ( elTeam._oteamData.dragStartHandle )
		{
			return;
		}

		elTeam.IsDraggable = true;

		elTeam._oteamData.dragStartHandle = $.RegisterEventHandler( 'DragStart', elTeam, function ( targetId, obj ) {
			
			var elDraggable = $.CreatePanel( "Panel", elTeam, 'draggable' + elTeam._oteamData.teamid, {
				class: 'pickem-bracket-draggable'
			} );
			
			$.CreatePanel( "Image", elDraggable, 'draggable' + elTeam._oteamData.teamid, {
				src: PickemCommon.GetTeamImage( elTeam ),
				class: 'vertical-center',
				textureheight: '48',
				texturewidth: '48'
			} );

			$.CreatePanel( "Label", elDraggable, 'draggable' + elTeam._oteamData.teamid, {
				text: PredictionsAPI.GetTeamName( elTeam._oteamData.teamid ),
				class: 'pickem-bracket-team__name'
			} );

			if ( typeof elDraggable._oteamData !== 'object' )
			{
				elDraggable._oteamData = {};
			}
			
			elDraggable._oteamData = elTeam._oteamData;
			elDraggable._oteamData.validtargets = _GetTargetsList( elTeam.GetParent() );

			obj.displayPanel = elDraggable;
			obj.removePositionBeforeDrop = false;
			elDraggable.AddClass( 'dragstart' );

			_HighlightValidTargets( elPickemPanel, elTeam, true );
		} );

		elTeam._oteamData.dragEndHandle = $.RegisterEventHandler( 'DragEnd', elTeam, function ( targetId, obj ) {
			obj.AddClass( 'dragend' );
			_HighlightValidTargets( elPickemPanel, elTeam, false );
			obj.DeleteAsync( 0.25 );
		} );
	};

	var _SetUpMouseOverEvents = function( elTeam )
	{
		var elImage = elTeam.FindChildInLayoutFile( 'id-team-logo' );
		var elLabel = elTeam.FindChildInLayoutFile( 'id-team-name' );
		
		var OnMouseOver = function( elTeam )
		{
			if( elTeam.IsDraggable )
			{
				elImage.AddClass( 'pickem-group-pick--wiggle' );
				elLabel.AddClass( 'pickem-group-pick--wiggle' );
			}
		};

		var OnMouseOut = function ( elTeam ) 
		{
			elImage.RemoveClass( 'pickem-group-pick--wiggle' );
			elLabel.RemoveClass( 'pickem-group-pick--wiggle' );
		};

		elTeam.SetPanelEvent( 'onmouseover', OnMouseOver.bind( undefined, elTeam ) );
		elTeam.SetPanelEvent( 'onmouseout', OnMouseOut.bind( undefined, elTeam ) );
	};

	var _HighlightValidTargets = function( elPickemPanel, elTeam, showTargets )
	{
		var targetsList = _GetTargetsList ( elTeam.GetParent() );
		if ( targetsList )
		{
			for ( var i = 0; i < targetsList.length; i++ )
			{
				elPickemPanel.FindChildInLayoutFile( targetsList[ i ] ).SetHasClass( 'drag-valid-target', showTargets );
			}
		}
	};

	var _GetTargetsList = function ( elGroup )
	{
		var targets = elGroup.GetAttributeString( 'data-valid-targets', '' );
		if ( !targets )
		{
			return false;
		}

		return targets.split( ',' );
	};

	var _SetUpDragTargets = function( elPickemPanel, elPick )
	{		
		if ( typeof elPickemPanel._odraggableData !== 'object' )
		{
			elPickemPanel._odraggableData = {};
		}

		var _DragEnter = function( elDragTarget )
		{
			elDragTarget.AddClass( 'dragenter' );

			                                                                                           
			elPickemPanel._odraggableData.dragtarget = elDragTarget;
		};

		var _DragLeave = function( elDragTarget )
		{
			elDragTarget.RemoveClass( 'dragenter' );
			elPickemPanel._odraggableData.dragtarget = null;
		};

			$.RegisterEventHandler(
				'DragEnter',
				elPick,
				_DragEnter.bind( undefined, elPick )
			);
			
			$.RegisterEventHandler(
				'DragLeave',
				elPick,
				_DragLeave.bind( undefined, elPick )
			);
		
			$.RegisterEventHandler(
				'DragDrop',
				elPick,
				function( dispayId, elDisplay )
				{
					                                  
					                                      
		
					_PlaceTempPick( elPickemPanel, elDisplay );
			
				}
			);
	};

	var _PlaceTempPick = function( elPickemPanel, elDisplay )
	{
		var validTargets = elDisplay._oteamData.validtargets;
		var tournamentId = elPickemPanel._oPickemData.oTournamentData.tournamentid;
		for( var i = 0; i < validTargets.length; i++ )
		{
			if ( elPickemPanel._odraggableData.dragtarget && elPickemPanel._odraggableData.dragtarget.IsValid() )
			{
				if ( validTargets[ i ] === elPickemPanel._odraggableData.dragtarget.id )
				{
					$.DispatchEvent( 'CSGOPlaySoundEffect', 'sticker_applySticker', 'MOUSE' );
					var teamsInGroup = '';

					var foundPick = false;
					for ( var j = 0; j < validTargets.length; j++ )
					{
						var elValidTarget = elPickemPanel.FindChildInLayoutFile( validTargets[ j ] );
						var sectionIndex = elValidTarget._oteamData.picksectionindex;
						var groupIndex = elValidTarget._oteamData.pickgroupindex;
						var oGroupData = elPickemPanel._oPickemData.oTournamentData.sections[ sectionIndex ].groups[ groupIndex ];

						if ( ( oGroupData.picks[ 0 ].localid !== elDisplay._oteamData.teamid ) && !foundPick )
						{
							oGroupData.picks[ 0 ].localid = elDisplay._oteamData.teamid;

							teamsInGroup = elValidTarget.GetAttributeString( 'data-teams-in-group', '' );
							elValidTarget.TriggerClass( 'dragdrop' );
						}
						else if ( _IsTeamIsFromSameGroup( elPickemPanel, teamsInGroup, oGroupData.picks[ 0 ].localid ) )
						{
							oGroupData.picks[ 0 ].localid = 0;
						}

						if ( validTargets[ j ] === elPickemPanel._odraggableData.dragtarget.id )
						{
							foundPick = true;
						}
					}
			
					_UpdateAllSections( elPickemPanel );
				}
			}
		}
	};

	var _IsTeamIsFromSameGroup = function ( elPickemPanel, teamsInGroup, localId )
	{
		if( !teamsInGroup )
		{
			return false;
		}
		
		var teamsList = teamsInGroup.split(',');
		var count = teamsList.length;

		for( var i = 0; i < count; i++ )
		{
			var elTeam = elPickemPanel.FindChildInLayoutFile( teamsList[i] );
			
			if( elTeam && ( elTeam._oteamData.teamid === localId ) )
			{
				return true;
			}
		}

		return false;
	}

	var _UpdatePicksWorth = function( elPickemPanel )
	{
		var fistDayOfBracketIndex = elPickemPanel._oPickemData.oInitData.sectionindex;
		var sectionCount = elPickemPanel._oPickemData.oTournamentData.sections.length - fistDayOfBracketIndex;

		for( var i = 0; i < sectionCount; i++ )
		{
			var elLabel = elPickemPanel.FindChildInLayoutFile( 'id-pickem-group-worth' + i );
			var points = elPickemPanel._oPickemData.oTournamentData.sections[ i + fistDayOfBracketIndex ].groups[ 0 ].pickworth;

			PickemCommon.SetPointsWorth( elLabel, points, elPickemPanel._oPickemData.oInitData.tournamentid, i + fistDayOfBracketIndex );
		}
	};

	var _UpdatePrediction = function( elPickemPanel )
	{
		                                      

		if( !elPickemPanel._oPickemData.oTournamentData )
		{
			return;
		}

		var sectionCount = elPickemPanel._oPickemData.oTournamentData.sections.length;

		for ( var i = 0; i < sectionCount; i++ )
		{
			var groupsList= elPickemPanel._oPickemData.oTournamentData.sections[ i ].groups;
			var groupsCount = groupsList.length;

			for ( var j = 0; j < groupsCount; j++ )
			{
				var userPickTeamID = PredictionsAPI.GetMyPredictionTeamID(
					elPickemPanel._oPickemData.oInitData.tournamentid,
					groupsList[ j ].id,
					0
				);

				groupsList[ j ].picks[ 0 ].savedid = userPickTeamID;
			}
		}

		_UpdateAllSections( elPickemPanel, true );
	};

	var _PurchaseComplete = function( elPickemPanel )
	{
		_UpdateAllSections( elPickemPanel );
	};

	return {
		Init: _Init,
		UpdatePrediction : _UpdatePrediction,
		PurchaseComplete : _PurchaseComplete
	};

} )();
