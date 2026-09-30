'use strict';

var PickEmGroup = ( function()
{
	                                                    
	                                                                                          
	                                                                                   
	                                                                                                     
	                                                                    

	var _Init = function ( elPanel )
	{
		_SetPointsWorth( elPanel );
		_SetUpDragTargets( elPanel );
		_UpdateGroupPicks( elPanel );
	};

	var _UpdateGroupPicks = function( elPanel )
	{
		                                                                                               

		if ( !elPanel._oPickemData.oTournamentData || !elPanel._oPickemData.oInitData )
		{
			                                                
			                                                                                                 
			                                                                                              
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
				PickemCommon.GetTournamentIdNumFromString( elPanel._oPickemData.oTournamentData.tournamentid ) >= 15                
			);

			PickemCommon.UpdateCorrectPickState(
				elPanel._oPickemData.oTournamentData.tournamentid,
				oGroupData,
				PredictionsAPI.GetGroupCorrectPicksByIndex( elPanel._oPickemData.oTournamentData.tournamentid, oGroupData.id, i ),
				oGroupData.picks[i].localid,
				elPick.FindChildInLayoutFile( 'id-pickem-points-for-pick' )
			);

			                                                                                       
			                                 
			                                                           
			   	                                                                           
			   	           
			   	            
			   	                                                      
			   	                            
			     
			     
			var notOwned = false;
			
			oGroupData.picks[i].storedefindex = notOwned ? 
				PickemCommon.GetTeamItemDefIndex( oGroupData.picks[i].localid ):
				undefined;

			                                                              
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
		{                                                                             
			var pickInGroupIndex = i;           
			var strStickerItemId = '';

			if ( listPicks[ i ].localid )
			{
				                                                    
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

			args.push( groupId, pickInGroupIndex, strStickerItemId );                              
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
			{	                                                                  
				var idLocal = picks[i].localid;
				var idSaved = picks[i].savedid;
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
		                                     

		var activeSectionIdx = elPanel._oPickemData.oInitData.sectionindex;

		if( !elPanel._oPickemData.oTournamentData )
		{
			return;
		}

		var oGroupData = elPanel._oPickemData.oTournamentData.sections[ activeSectionIdx ].groups[ 0 ];

		if ( !oGroupData )
		{
			                                                                      
			                                               
			return;
		}

		if ( !oGroupData || !oGroupData.pickscount )
			return;

		                                                               
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

                                     
    
	                                                         
	                                                 

	                                                         

	                                                                          
	    
	                                                                   
	                                            
	       

	                                                                        
	    
	                                                                     
	                                              
	       


	                                                                     
	                                                                                                                            
	                                                                                                                            
	                                                                                                                                                      
     