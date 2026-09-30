'use strict';


var OperationMain = ( function() 
{
	var _m_cp = $.GetContextPanel();
	var _m_nSeasonAccess;
	var _m_oProgressFlipModule = null;
	var _m_oNamesFlipModuleInspect = null;
	var _m_activeRewardBtn = null;
	const SECTIONS_IN_BAR = 100;

	var _CheckUsersOperationStatus = function()
	{
		_m_nSeasonAccess = $.GetContextPanel().GetAttributeInt( "season_access", 0 );

		OperationUtil.ValidateOperationInfo( _m_nSeasonAccess );
		var oStatus = OperationUtil.GetOperationInfo();

		if ( _m_nSeasonAccess === -1 ||
			!_m_nSeasonAccess ||
			oStatus.nCoinRank === -1 ||
			oStatus.nCoinRank === undefined ||
			oStatus.nCoinRank === null )
		{
			return;
		}

		_m_activeRewardBtn = null;
		_SetupHeader( oStatus );

		var indexToOpenTo = _m_cp.GetAttributeInt( "start_reward", -1 );
		                                                                                   
		_m_cp.SetAttributeInt( "start_reward", -1 );

		                                         
		_UpdateDefaultProgressData( oStatus, indexToOpenTo );

		                        
		_UpdateRewardTiles();

		var elVisibleBar = _m_oProgressFlipModule.DetermineVisiblePanel(
			_m_oProgressFlipModule.oData.animPanelA,
			_m_oProgressFlipModule.oData.animPanelB
		);

		                                                         
		_UpdateProgressBarSections( _m_oProgressFlipModule.oData, elVisibleBar );
		
		                                                                    
		var oRewardToHighlight = _GetRewardToHighlight( indexToOpenTo );

		                                                                 
		_UpdateRewardsOnProgressBar( elVisibleBar, oRewardToHighlight );
		
		var aChildren = elVisibleBar.FindChildInLayoutFile( 'op-main-progressbar-rewards' ).Children();
		                        

		_m_activeRewardBtn = aChildren.filter( element =>
			element.Data().oReward.itempremium.ids[ 0 ] === oRewardToHighlight.itempremium.ids[ 0 ] &&
			element.Data().oReward.idx === oRewardToHighlight.idx
		)[ 0 ];
		
		_SetActiveReward( _m_activeRewardBtn );
		_ShowPurchaseSpecificStarsBtn();
		_SetCheckedMatchingTile();

		                                                                                                                    
		$.Schedule( 0.3, _UpdateInspectPanel );
		_SetPurchaseBtn();
	};

	var _SetupHeader = function( oStatus )
	{
		if ( oStatus.bPremiumUser )
		{
			$.GetContextPanel().SetDialogVariableInt( 'total_value', oStatus.nTierUnlocked );
		}

		$.GetContextPanel().FindChildInLayoutFile( 'id-op-main-header' ).visible = oStatus.bPremiumUser;
		$.GetContextPanel().FindChildInLayoutFile( 'id-op-main-header-preview' ).visible = !oStatus.bPremiumUser;
	};

	var _SetPurchaseBtn = function( )
	{
		var elUpSell = $.GetContextPanel().FindChildInLayoutFile( 'op-main-upsell' );

		var bPremiumUser = OperationUtil.GetOperationInfo().bPremiumUser;
		var sUserOwnedOperationPassItemID = InventoryAPI.GetActiveSeasonPassItemId();
		var sFauxPassItemID = OperationUtil.GetPassFauxId();

		elUpSell.FindChildInLayoutFile( 'op-main-upsell-label' ).text = $.Localize( bPremiumUser ?
			'#op_get_more_stars' : sUserOwnedOperationPassItemID ? 
			'#SFUI_ConfirmBtn_ActivatePassNow' : '#op_get_premium'
			).toUpperCase();

		var imgPath = bPremiumUser ?
			'file://{images}/icons/ui/shoppingcart.svg' :
			'file://{images}/icons/ui/ticket.svg';
		
		elUpSell.FindChildInLayoutFile( 'op-main-upsell-image' ).SetImage( imgPath );
		elUpSell.SetPanelEvent( 'onactivate', OperationUtil.OpenUpSell.bind( undefined ) );

		  
		                               
		  
		var elPassSaleDiscount = elUpSell.FindChildInLayoutFile( 'id-op-reward-open-operation-hub-passsalediscount' );
		elPassSaleDiscount.visible = ( !bPremiumUser && sUserOwnedOperationPassItemID ) ? false : true;
		var sPctReduction = StoreAPI.GetStoreItemPercentReduction( sFauxPassItemID );
		if ( bPremiumUser )
		{
			sPctReduction = '';
			var minDiscount, maxDiscount;
			var storeids = OperationUtil.GetOperationStarDefIdxArray();
			storeids.forEach( function( defIndex )
			{
				var sPctReductionPerStar = StoreAPI.GetStoreItemPercentReduction(
					InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( defIndex, 0 )
					);
				if ( sPctReductionPerStar && sPctReductionPerStar !== '-0%' )
				{
					var numericStarDiscount = parseInt( sPctReductionPerStar );
					if ( sPctReduction )
					{
						sPctReduction += ' / ';
					}
					else
					{
						minDiscount = numericStarDiscount;
						maxDiscount = numericStarDiscount;
					}
					sPctReduction += sPctReductionPerStar;

					if ( numericStarDiscount < minDiscount ) minDiscount = numericStarDiscount;
					if ( numericStarDiscount > maxDiscount ) maxDiscount = numericStarDiscount;
				}
			} );
			
			if ( sPctReduction )
			{
				elPassSaleDiscount.SetDialogVariable( 'salediscount', ''+minDiscount+'%' );
				sPctReduction = $.Localize( '#Store_Price_UpToSale', elPassSaleDiscount ).toUpperCase();
			}
		}
		if ( sPctReduction && sPctReduction !== '-0%' )
			elPassSaleDiscount.text = sPctReduction;
		else
			elPassSaleDiscount.visible = false;
	};

	var _UpdateDefaultProgressData = function( oStatus, openToRewardIndex )
	{
		var oCallbackData = {
			nTierUnlocked: oStatus.nTierUnlocked,
			sectionStart: 0,
			sectionEnd: 0
		};

		                                    
		                                                
		                                                         
		var activeIndex = openToRewardIndex > -1 ? Math.floor( openToRewardIndex / SECTIONS_IN_BAR ) : Math.floor( oStatus.nTierUnlocked / SECTIONS_IN_BAR );
		_m_oProgressFlipModule.CallbackData = oCallbackData;
		_m_oProgressFlipModule.ActiveIndex = activeIndex;
		_m_oProgressFlipModule.AddParamToCallbackData( 'maxIndex', activeIndex );
		_m_oProgressFlipModule.AddParamToCallbackData( 'sectionStart', ( SECTIONS_IN_BAR * activeIndex ) );
		_m_oProgressFlipModule.AddParamToCallbackData( 'sectionEnd', ( SECTIONS_IN_BAR * activeIndex ) + SECTIONS_IN_BAR );

		_UpdateProgressBarEnableDisable( _m_oProgressFlipModule.oData );
		
		                                                                  
		                                        
	};

	                        
	                        
	                        
	var _UpdateRewardTiles = function(  )
	{
		var aTiles = _GetRewardsForTiles();

		if ( aTiles.length < 1 )
		{
			return;
		}

		function GetPanel ( idPrefix, modifier, elParent, panelType, snippetToLoad = '' )
		{
			var elPanel = elParent.FindChildInLayoutFile( idPrefix + modifier );
			if ( !elPanel )
			{
				elPanel = $.CreatePanel( panelType, elParent, idPrefix + modifier );

				if ( snippetToLoad )
				{
					elPanel.BLoadLayoutSnippet( snippetToLoad );
				}
			}
			
			return elPanel;
		}
		var elParent = _m_cp.FindChildInLayoutFile( 'id-op-rewards-list' );
		                                                                      
		var currentRow = 0;
		var maxTiles = 12;
		var numTileRow = 0;

		for ( var i = 0; i < maxTiles; i++ )
		{
			                                                            
			numTileRow = aTiles[ i ] ? parseInt( aTiles[ i ].rewardsData[ 0 ].uiOrder ) : numTileRow;
			if( numTileRow !== currentRow )
			{
				currentRow = numTileRow;
				var elTitle  = GetPanel( 'id-op-rewards-section-', currentRow, elParent, 'Label' );
				elTitle.text = $.Localize( '#op_rewards_section_'+ currentRow );
				elTitle.AddClass( 'op-main-progress__title' );

				var elRow = GetPanel( 'id-op-rewards-row-', currentRow, elParent, 'Panel' );
				elRow.AddClass( 'op-main-rewards_row' );
			}

			var elTile = GetPanel( 'id-op-rewards-list-tile-', i, elRow, 'RadioButton', 'reward-tile' );

			if( i >= aTiles.length)
			{
				elTile.SetHasClass( 'hidden', true );
				if( elTile.checked )
				{
					elTile.checked = false;
				}
				return;
			}

			elTile.SetHasClass( 'hidden', false );
			if ( aTiles[ i ].rewardsData[ 0 ].imagePath )
			{
				elTile.FindChildInLayoutFile( 'id-op-reward-image' ).SetImage( 'file://{images}' + aTiles[ i ].rewardsData[ 0 ].imagePath + '.png' );
			}
			else
			{
				elTile.FindChildInLayoutFile( 'id-op-reward-image' ).itemid = aTiles[ i ].rewardId;
			}

			elTile.SetHasClass( 'small', currentRow !== 1 );
			elTile.FindChildInLayoutFile( 'id-op-reward-name' ).text = InventoryAPI.GetItemName( aTiles[ i ].rewardId );
			                                                                                                 

			                                                                                                                                
			elTile.Data().oReward = aTiles[ i ].rewardsData[ 0 ];
			elTile.Data().showSingleReward = aTiles[ i ].rewardsData.length === 1 ? true : false;
			elTile.Data().nCategoryButtonIdx = i;                                                                                                                         
			elTile.SetPanelEvent( 'onactivate', _OnSelectReward.bind( undefined, elTile ) );

			_CacheWeaponMouseOver( elTile, aTiles[ i ].rewardId  );
		}
	};

	var _GetRewardsForTiles = function()
	{
		var aRewards = OperationUtil.GetRewardsData();
		var aTiles = [];

		for ( var i = _m_oProgressFlipModule.oData.oCallbackData.sectionStart;
			i < _m_oProgressFlipModule.oData.oCallbackData.sectionEnd;
			i++ )
		{
			if ( aRewards[ i ].isGap !== "none" )
			{
				var rewardId = aRewards[ i ].itempremium.ids[ 0 ];

				                                                                     

				if ( !aTiles.find( tile =>
				{
					return tile[ 'rewardId' ] && ( tile[ 'rewardId' ] === rewardId ) ? true : false;
				} ) )
				{
					aTiles.push( {
						rewardId: rewardId,
						rewardsData: aRewards.filter( reward =>
							( reward.idx >= _m_oProgressFlipModule.oData.oCallbackData.sectionStart &&
							reward.idx <= _m_oProgressFlipModule.oData.oCallbackData.sectionEnd ) &&
							reward.itempremium.ids[ 0 ] === rewardId )
					} );
				}
			}
		}
		aTiles.sort( function( a, b ) { return parseInt( a.rewardsData[ 0 ].uiOrder ) - parseInt( b.rewardsData[ 0 ].uiOrder ); } );
		return aTiles;
	};

	var _UpdateProgressBarEnableDisable = function( oData )
	{
		oData.controlBtnPrev.enabled = oData.activeIndex > 0;
		oData.controlBtnNext.enabled = oData.activeIndex < oData.oCallbackData.maxIndex;

		                                                                         
		oData.controlBtnPrev.visible = oData.oCallbackData.nTierUnlocked >= 100;
		oData.controlBtnNext.visible = oData.oCallbackData.nTierUnlocked >= 100;
	};

	var _UpdateProgressBarSections = function( oData, elBarParent )
	{
		                                                                  
		                                        
		
		var elBar = elBarParent.FindChildInLayoutFile( 'op-main-progressbar-sections' );
		elBar.RemoveAndDeleteChildren();

		for ( var i = oData.oCallbackData.sectionStart; i <= oData.oCallbackData.sectionEnd; i++ )
		{
			var elSection = $.CreatePanel( "Panel", elBar, "bar-section-" + i );
			elSection.BLoadLayoutSnippet( "progressbar-section" );
			elSection.SetHasClass( 'op-main-progress__bar__inner--fill', i < oData.oCallbackData.nTierUnlocked );
		}
	};

	var _UpdateRewardsOnProgressBar = function( elBar, oRewardTohighlight = null )
	{
		var aGetRewardsInRange = _GetRewardsInRange();

		if ( !aGetRewardsInRange || aGetRewardsInRange.length < 1 )
		{
			return;
		}

		_UpdateRewardPanelsOnProgressBar( _GetRewardsInRange(), elBar, oRewardTohighlight );
	};

	var _GetRewardToHighlight = function( rewardTohighlightIndex )
	{
		                                                                                         
		var oRewards = OperationUtil.GetRewardsData();
		var count = oRewards.length;

		if ( rewardTohighlightIndex > -1 )
		{
			return oRewards[ rewardTohighlightIndex ];
		}

		for ( var i = _m_oProgressFlipModule.oData.oCallbackData.nTierUnlocked; i < count; i++ )
		{
			if ( !oRewards[ i ].isUnlocked && !oRewards[ i ].isGap )
			{
				                                                            
				return oRewards[ i ];
			}
		}

		return undefined;
	};

	var _GetRewardsInRange = function()
	{
		var oAllRewards = OperationUtil.GetRewardsData();
		var aGetRewardsInRange = oAllRewards.filter( reward => !reward.isGap  &&
			( reward.idx >= _m_oProgressFlipModule.oData.oCallbackData.sectionStart &&
			reward.idx <= _m_oProgressFlipModule.oData.oCallbackData.sectionEnd ) 
		);
		
		return aGetRewardsInRange;
	};

	var _UpdateRewardPanelsOnProgressBar = function( aGetRewardsInRange, elBar, oRewardToHighlight = null )
	{
		var elRewardsPanel = elBar.FindChildInLayoutFile( "op-main-progressbar-rewards" );
		                                           

		aGetRewardsInRange.forEach(function( reward, index )
		{
			var elReward = elRewardsPanel.FindChildInLayoutFile( "bar-reward-" + reward.idx );
			var bPlayAnim = false;                                                   

			if ( !elReward )
			{
				var elReward = $.CreatePanel( "RadioButton", elRewardsPanel, "bar-reward-" + reward.idx, { group: 'bar-reward' } );
				elReward.BLoadLayoutSnippet( "progressbar-reward" );
				bPlayAnim = true;
				elReward.Data().showSingleReward = true;
				elReward.Data().oReward = reward;
			}

			                                                                                                          
			                                                       
			                                                                                          
			if( reward.idx !== elReward.Data().oReward.idx )
			{
				elReward.Data().oReward = reward;

				if( elReward.BHasClass( 'highlight' ) )
				{
					elReward.RemoveClass( 'highlight' );
				}
			}

			if ( reward.imagePathThumbnail )
			{
				elReward.FindChildInLayoutFile( 'id-op-progressbar-reward-image' ).SetImage( 'file://{images}' + reward.imagePathThumbnail + '.png' );
			}
			else
			{
				elReward.FindChildInLayoutFile( 'id-op-progressbar-reward-image' ).itemid = reward.itempremium.ids[ 0 ];
			}
	
			elReward.SetDialogVariableInt( 'reward_index', reward.idx + 1 );
			elReward.FindChildInLayoutFile( 'id-op-progressbar-reward-hitbox' ).SetPanelEvent(
				'onactivate',
				_OnSelectReward.bind(
					undefined,
					elReward,
					elBar
				) );
			
			var oAnimInfo = {
				panel: elReward,
				bar: elBar,
				idx: reward.idx,
				play_anim: bPlayAnim
			};

			_CacheWeaponMouseOver( elReward ,reward.itempremium.ids[ 0 ] );
			
			                                                                                           
			                                                                                                                             
			var rewardTohighlight = _m_activeRewardBtn ? _m_activeRewardBtn.Data().oReward : oRewardToHighlight;
			
			if ( rewardTohighlight )
			{
				if ( oRewardToHighlight || _m_activeRewardBtn.Data().showSingleReward )
				{
					elReward.SetHasClass( 'highlight',
						reward.idx === rewardTohighlight.idx
					);
				}
				else
				{
					elReward.SetHasClass( 'highlight',
						reward.itempremium.ids[ 0 ] === rewardTohighlight.itempremium.ids[ 0 ]
					);
				}
			}

			elReward.SetHasClass( 'claimed', reward.idx < _m_oProgressFlipModule.oData.oCallbackData.nTierUnlocked );

			if ( bPlayAnim )
			{
				$.Schedule( 0.25, _PositionRewardOnProgressBar.bind( undefined, oAnimInfo ) );
			}
		} );
	};

	var _PositionRewardOnProgressBar = function( oAnimInfo )
	{
		var elSectionsContainer = oAnimInfo.bar.FindChildInLayoutFile( "op-main-progressbar-sections" );
		var elSection = elSectionsContainer.FindChild( "bar-section-" + ( oAnimInfo.idx ));
		let pos = elSection.GetPositionWithinWindow();

		var widthOffset = -( Math.floor( oAnimInfo.panel.actuallayoutwidth / 2 ) - Math.floor( elSection.actuallayoutwidth / 2 ) ) /
			oAnimInfo.panel.actualuiscale_x;
		
		oAnimInfo.panel.style.x = (( pos.x / oAnimInfo.panel.actualuiscale_x ) + widthOffset ) + 'px;';

		if ( oAnimInfo.play_anim )
		{
			oAnimInfo.panel.TriggerClass( 'op-main-progress__bar__reward__show-anim' );
		}
	};

	                          
	                          
	                          
	var _OnSelectReward = function( elSelected, elBar = undefined, bTrackStats = true )
	{
		if ( _m_activeRewardBtn === elSelected )
		{
			return;
		}
		
		_SetActiveReward( elSelected );

		var visibleBar = elBar ?
			elBar : _m_oProgressFlipModule.DetermineVisiblePanel(
				_m_oProgressFlipModule.oData.animPanelA,
				_m_oProgressFlipModule.oData.animPanelB
			);

		_UpdateRewardsOnProgressBar( visibleBar );

		if ( _m_activeRewardBtn.Data().showSingleReward )
		{
			_SetCheckedMatchingTile();
		}

		_ShowPurchaseSpecificStarsBtn();
		
		                                                               
		$.Schedule( .3, _UpdateInspectPanel );
	};

	var _SetActiveReward = function( elSelected )
	{
		if ( _m_activeRewardBtn )
		{
			_m_activeRewardBtn.checked = false;
		}
		
		elSelected.checked = true;
		_m_activeRewardBtn = elSelected;
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE' );
	};

	var _SetCheckedMatchingTile = function()
	{
		var aChildren = _m_cp.FindChildInLayoutFile( 'id-op-rewards-list' ).FindChildrenWithClassTraverse( 'op-main-reward' );
		aChildren.forEach(element => {
			if (element.Data().oReward) {
				element.checked = element.Data().oReward.itempremium.ids[0] ===
					_m_activeRewardBtn.Data().oReward.itempremium.ids[0]
			}
		});
	};

	var _ShowPurchaseSpecificStarsBtn = function()
	{
		var elPurchaseBtn = _m_cp.FindChildInLayoutFile( 'id-op-rewards-upsell-stars-btn' );

		var bShow = _m_activeRewardBtn &&
			_m_activeRewardBtn.Data().showSingleReward && OperationUtil.GetOperationInfo().bPremiumUser &&
			( _m_activeRewardBtn.Data().oReward.idx >= OperationUtil.GetOperationInfo().nTierUnlocked );
		
		elPurchaseBtn.SetHasClass( 'hidden', !bShow );
		
		if ( bShow )
		{
			var starsNeeded = ( _m_activeRewardBtn.Data().oReward.idx + 1 ) - OperationUtil.GetOperationInfo().nTierUnlocked;
			elPurchaseBtn.SetDialogVariableInt( 'stars_needed', starsNeeded );
			elPurchaseBtn.TriggerClass( 'update' );
			elPurchaseBtn.SetPanelEvent( 'onactivate',
				OperationUtil.OpenUpSell.bind(
					undefined,
					starsNeeded
			) );
		}
	};

	                  
	                  
	                  
	var _UpdateInspectPanel = function()
	{
		if ( !_m_activeRewardBtn )
		{
			return;
		}

		_m_cp.FindChildInLayoutFile( 'id-op-main-inspect' ).SetHasClass( 'show', true );

		var rewardId = _m_activeRewardBtn.Data().oReward.itempremium.ids[ 0 ];
		_m_cp.FindChildInLayoutFile( 'id-op-reward-tag' ).SetHasClass( 'hidden', rewardId !== _GetRewardToHighlight().itempremium.ids[ 0 ] );

		var itemsList = [];
		var toolsKey = InventoryAPI.GetRawDefinitionKey( rewardId, "inv_container_and_tools" );
		var bIsCase = ( toolsKey === "weapon_case" );
		var bIsGraffiti = ( toolsKey === "graffiti_box" );
		var bIsCoin = ( InventoryAPI.GetRawDefinitionKey( rewardId, "item_type" ) === "operation_coin" );

		_m_activeRewardBtn.Data().bIsGraffiti = bIsGraffiti;
		_m_activeRewardBtn.Data().bIsCoin = bIsCoin;
		_UpdateWarning( bIsCoin, bIsCase );

		var btnPreviewCase = _m_cp.FindChildInLayoutFile( 'id-op-main-inspect-preview-item' );
		if( bIsCase )
		{
			if( bIsCase )
			{
				btnPreviewCase.SetPanelEvent( 'onactivate', function()
				{
					UiToolkitAPI.ShowCustomLayoutPopupParameters(
						'',
						'file://{resources}/layout/popups/popup_capability_decodable.xml',
						'key-and-case=,' + rewardId +
						'&' + 'inspectonly=true' +
						'&' + 'asyncworktype=decodeable' +
						'&' + 'asyncworkbtnstyle=hidden' +
						'&' + 'bluroperationpanel=true'
					);
				});
				btnPreviewCase.SetPanelEvent( 'onmouseover', function()
				{	                                                                                                        
				});
			}
		}
		else
		{
			var count = InventoryAPI.GetLootListItemsCount( rewardId );
			
			if ( !count )
			{
				itemsList.push( rewardId );
			}
			else
			{
				for ( var i = 0; i < count; i++ )
				{
					itemsList.push( InventoryAPI.GetLootListItemIdByIndex( rewardId , i ) );
				}
			}

			if( ItemInfo.IsCharacter( itemsList[0] )|| ItemInfo.IsWeapon( itemsList[0] ) )
			{
				var _getSelectedIdInLayoutChildrenRow = function() {
					var selectedId = '';
					var aPips = _m_cp.FindChildInLayoutFile( 'id-op-main-inspect-rarity' ).Children();
					if( aPips.length > 0 )
					{
						selectedId = aPips[0].GetSelectedButton().Data().itemid;
					}
					return selectedId;
				};

				btnPreviewCase.SetPanelEvent( 'onactivate', function()
				{
					var selectedId = _getSelectedIdInLayoutChildrenRow();
					UiToolkitAPI.ShowCustomLayoutPopupParameters(
						'',
						'file://{resources}/layout/popups/popup_inventory_inspect.xml',
						'itemid=' + selectedId +
						'&' + 'inspectonly=true' +
						'&' + 'showallitemactions=false' +
						'&' + 'allowsave=false' +
						'&' + 'bluroperationpanel=true' +
						'&' + 'showitemcert=false',
						'none'
					);
				});
				btnPreviewCase.SetPanelEvent( 'onmouseover', function()
				{
					var selectedId = _getSelectedIdInLayoutChildrenRow();
					var settingsForSelectedCharacter = ItemInfo.GetOrUpdateVanityCharacterSettings( selectedId );
					ItemInfo.PrecacheVanityCharacterSettings( settingsForSelectedCharacter );
				});
			}
		}

		btnPreviewCase.visible = bIsCase || ItemInfo.IsCharacter( itemsList[ 0 ] )|| ItemInfo.IsWeapon( itemsList[0] );

		_m_cp.SetDialogVariable(
			'reward_name',
			InventoryAPI.GetItemName(
				rewardId
			));

		_m_activeRewardBtn.Data().bShowPips = ( !bIsCoin && !bIsGraffiti && !bIsCase );

		_MakePips( itemsList, rewardId );
		_UpdateInpsectNameFlipModule( itemsList, rewardId );
	};

	var _UpdateWarning = function( bIsCoin, bIsCase, rewardId  )
	{
		var elWarning = _m_cp.FindChildInLayoutFile( 'id-op-main-inspect-warning' );
		var bHideWarning = bIsCase || ( bIsCoin && !OperationUtil.GetOperationInfo().bPremiumUser );
		elWarning.SetHasClass( 'hidden', bHideWarning );

		if ( bHideWarning )
		{
			return;
		}

		var warningText = '';
		if ( bIsCoin )
		{
			var id = InventoryAPI.GetActiveSeasonCoinItemId();
			var missionsThreshold = InventoryAPI.GetItemAttributeValue( id, 'upgrade threshold' );

			                                                                                  
			if ( !missionsThreshold || missionsThreshold < 0 || missionsThreshold > 1000 )
			{
				elWarning.SetHasClass( 'hidden', true );
				return;
			}

			var missionsRemaining = missionsThreshold - OperationUtil.GetOperationInfo().nMissionsCompleted;
			_m_cp.SetDialogVariableInt( 'missions_remaining', missionsRemaining );

			var missionText = missionsRemaining === 1 ? $.Localize( '#op_rewards_mission' ) : $.Localize( '#op_rewards_missions' );
			_m_cp.SetDialogVariable( 'mission_plural', missionText );
			warningText = $.Localize( '#op_rewards_inspect_coin_progress', _m_cp );
		}
		else
		{
			warningText = $.Localize( '#op_rewards_inspect_warning' );
		}

		elWarning.text = warningText;
	};

	var _MakePips = function( itemsList, rewardId )
	{
		var elPips = _m_cp.FindChildInLayoutFile( 'id-op-main-inspect-rarity' );
		elPips.RemoveAndDeleteChildren();

		elPips.SetHasClass( 'hidden', ( !_m_activeRewardBtn.Data().bShowPips ) );
		if( !_m_activeRewardBtn.Data().bShowPips )
		{
			return;
		}

		itemsList.forEach( function( itemId, index )
		{
			var elPip = $.CreatePanel(
				"RadioButton",
				elPips,
				'id-tier-pip-' + itemId, {
					class: 'op-mission-reward__rarity__pip',
					group:'rewardPip'
				}
			);

			$.CreatePanel(
				"ItemImage",
				elPip,
				'', {
					itemid: itemId,
					scaling:"stretch-to-fit-y-preserve-aspect"
				}
			);

			$.CreatePanel(
				"Panel",
				elPip,
				'id-pip-rarity', {
					class:"op-mission-reward__rarity__pip__rarity"
				}
			);

			elPip.Data().itemid = itemId;

			if ( ( itemsList.length <= 1 ) )
			{
				elPip.visible = false;
			}

			elPip.SetPanelEvent( 'onactivate', _OnPipActivate.bind( undefined, itemId, rewardId, index, itemsList.length ) );

			var rarityColor = ( itemId === '0' && bIsCase ) ?
				'#ffd700' :
				InventoryAPI.GetItemRarityColor( itemId );
		
			if ( ItemInfo.IsWeapon( itemId ) )
			{
				elPip.SetPanelEvent( 'onmouseover', _CacheWeapon.bind( undefined, itemId ) );
			}

			if ( rarityColor )
			{
				elPip.FindChild( 'id-pip-rarity' ).style.backgroundColor = rarityColor + ';';
			}
			elPip.checked = index === 0;
		} );
	};

	var _OnPipActivate = function( itemId, rewardId, index )
	{
		if ( _m_oNamesFlipModuleInspect.ActiveIndex === index )
		{
			return;
		}
		
		_m_oNamesFlipModuleInspect.ActiveIndex = index - 1;
		_m_oNamesFlipModuleInspect.UseCallback();
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE' );
	};

	var _UpdateInpsectNameFlipModule = function( aItems, rewardId )
	{	
		_m_oNamesFlipModuleInspect.CallbackData = {
			items: aItems,
			rewardid: rewardId
		};

		_m_oNamesFlipModuleInspect.ActiveIndex = -1;
		_m_oNamesFlipModuleInspect.AddParamToCallbackData( 'maxIndex', aItems.length - 1 );
		_m_oNamesFlipModuleInspect.UseCallback();
	};
	
	var _CacheWeapon = function( id )
	{
		InventoryAPI.PrecacheCustomMaterials( id );
	};

	var _CacheWeaponMouseOver = function( elTile, id, islootlistItem = false)
	{
		var count = 0;
		if( !islootlistItem )
		{
			count = InventoryAPI.GetLootListItemsCount( id );
		}

		if ( count > 0 || islootlistItem )
		{
			var lootListItem = islootlistItem ? id : InventoryAPI.GetLootListItemIdByIndex( id, 0 );
			if( ItemInfo.IsWeapon( lootListItem ) )
			{
				elTile.SetPanelEvent( 'onmouseover', _CacheWeapon.bind( undefined, lootListItem ) );
			}
		}
	};

	return {
		CheckUsersOperationStatus: _CheckUsersOperationStatus,
	};
} )();

(function () {

	$.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', OperationMain.CheckUsersOperationStatus );
})();

