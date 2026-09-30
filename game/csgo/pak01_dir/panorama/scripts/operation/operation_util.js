'use strict';

var OperationUtil = ( function () {

	var m_nSeasonAccess = -1;
	var m_numTierUnlocked = 0;
	var m_numMissionsCompleted = 0;

	// Used to populate store
	var m_nRedeemableGoodsCount = 0;

	var m_numMissionsRewardThresholds = 0;
	var m_bPremiumUser = false;
	var m_nCoinRank = 0;
	var m_nActiveCardIndex = 0;
	var m_nRewardsCount = 0;
	var m_numRedeemableBalance = 0;
	var m_nLoopingRewardsCount = 0;
	var m_bPrime = false;
	var m_aStarDefIndexes = [4763, 4764, 4765]
	var m_passStoreId = 4758;

	var _ValidateOperationInfo = function( nSeasonAccess )
	{
		// Get the operation number we want to look at.
		// Then store the data for hit.
		// If you want the data updated the call this again to get the latest data
		m_nSeasonAccess = nSeasonAccess;
		
		if ( nSeasonAccess < 0 || nSeasonAccess === null || nSeasonAccess === undefined )
			return false;
		
		m_nSeasonAccess = nSeasonAccess;
		$.Msg( ' --- season_access=' + m_nSeasonAccess );

		m_nCoinRank = MyPersonaAPI.GetMyMedalRankByType( ( m_nSeasonAccess + 1 ) + "Operation$OperationCoin" );
		$.Msg( ' --- m_nCoinRank=' + m_nCoinRank );

		m_bPrime = PartyListAPI.GetFriendPrimeEligible( MyPersonaAPI.GetXuid() );
		m_nRewardsCount = MissionsAPI.GetSeasonalOperationTrackRewardsCount( m_nSeasonAccess );
		m_nRedeemableGoodsCount = MissionsAPI.GetSeasonalOperationRedeemableGoodsCount( m_nSeasonAccess );
		m_nLoopingRewardsCount = MissionsAPI.GetSeasonalOperationLoopingRewardsCount( m_nSeasonAccess );
		m_numMissionsRewardThresholds = MissionsAPI.GetSeasonalOperationXpRewardsThresholds( m_nSeasonAccess );

		// Find the index of the SO cache entry representing the requested operation (and double-check the matching season value)
		var idxOperation = InventoryAPI.GetCacheTypeElementIndexByKey( 'SeasonalOperations', m_nSeasonAccess );
		if ( idxOperation != undefined && idxOperation != null
			&& InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'season_value' ) == m_nSeasonAccess )
		{	// double-check the matching season value and print stats
			m_numMissionsCompleted = InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'missions_completed' );
			m_numTierUnlocked = InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'tier_unlocked' );
			if ( m_nRedeemableGoodsCount && m_nRedeemableGoodsCount > 0 )
			{
				var spt = InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'season_pass_time' );
				m_bPremiumUser = ( spt && ( spt > 0 ) ) ? true : false;
			}
			else
			{
				var spt = InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'premium_tiers' );
				m_bPremiumUser = ( spt && ( spt >= 1 ) ) ? true : false;
			}
			m_nActiveCardIndex = MissionsAPI.GetSeasonalOperationMissionCardActiveIdx( m_nSeasonAccess );
			m_numRedeemableBalance = InventoryAPI.GetCacheTypeElementFieldByIndex( 'SeasonalOperations', idxOperation, 'redeemable_balance' );
		}
		else
		{
			$.Msg( '--- user is new to this operation' );

			m_numMissionsCompleted = 0;
			m_numTierUnlocked = 0;
			m_bPremiumUser = false;
			m_nActiveCardIndex = -1;
			m_numRedeemableBalance = 0;
		}

		_AddLoopingRewardsToDisplay();

		$.Msg( '--- active card=' + m_nActiveCardIndex );
		$.Msg( '--- missions_completed=' + m_numMissionsCompleted );
		$.Msg( '--- xprewards=' + m_numMissionsRewardThresholds );
		$.Msg( '--- redeemable_balance=' + m_numRedeemableBalance );
		$.Msg( '--- tier_unlocked=' + m_numTierUnlocked );
		$.Msg( '--- premium=' + m_bPremiumUser );
		$.Msg( '--- prime=' + m_bPrime );
		$.Msg( '--- m_nRewardsCount=' + m_nRewardsCount );
		$.Msg( '--- m_nRedeemableGoodsCount=' + m_nRedeemableGoodsCount );

		return true;
	};

	var _AddLoopingRewardsToDisplay = function()
	{
		// How many rewards will we display?
		if ( m_nLoopingRewardsCount > 0 )
		{	// also display one full extra loop of the track
			m_nRewardsCount += m_nLoopingRewardsCount;
			// and if the user is already on the loop then display the next loop too
			while ( m_numTierUnlocked > m_nRewardsCount - m_nLoopingRewardsCount )
			{
				m_nRewardsCount += m_nLoopingRewardsCount;
			}
		}
	};

	var _GetObjValue= function( bHasStoreItems, rewardIndex, item )
	{
		// console.log(item);
		var data;
		
		if( bHasStoreItems )
		{
			data = MissionsAPI.GetSeasonalOperationRedeemableGoodsSchema( m_nSeasonAccess, rewardIndex, item.value );
		}
		else
		{
			data = MissionsAPI.GetSeasonalOperationTrackRewardSchema( m_nSeasonAccess, rewardIndex, item.value );
		}

		$.Msg( '---_rewardData.item.objHandle=' + rewardIndex + ": " + item.value + ": " + data );
		if( item.value === 'ui_order')
		{
			return data ? data : '';
		}
		else{
			return data;
		}
	};

	var _GetContainerTypeForReward = function( oRewardData )
	{
		var rewardId = oRewardData.itempremium.ids[ 0 ];
		
		var toolsKey = InventoryAPI.GetRawDefinitionKey( rewardId, "inv_container_and_tools" ); 

		$.Msg( '---toolsKey' + toolsKey );

		if( ( toolsKey === "weapon_case" ) )
		{
			return 'isWeaponsCase';
		}
		else if ( toolsKey === "graffiti_box" ){
			return 'isGraffitiBox';
		}
		else if( InventoryAPI.GetRawDefinitionKey( rewardId, "item_type" ) === "operation_coin" )
		{
			return 'isCoin';
		}
		else if( ItemInfo.IsCharacter( oRewardData.lootlist[0] ) )
		{
			return 'isCharacterLootlist';
		}
		else if( ItemInfo.IsWeapon( oRewardData.lootlist[0] ) )
		{
			return 'isWeaponLootlist';
		}

		return 'isStickerLootlist';
	};

	var _GetRewardsData = function()
	{
		//Run validate before you call this.
		if ( !m_nSeasonAccess || m_nSeasonAccess === -1 )
		{
			return;
		}
		var bHasStoreItems = _HasStoreItems();
		var nRewardsCount  = bHasStoreItems ? m_nRedeemableGoodsCount : m_nRewardsCount;
		$.Msg( '---_GetRewardsData nRewardsCount=' + bHasStoreItems );

		var aRewardDataFields = [
			{ objHandle:'points', value: 'points'},
			{ objHandle:'flags', value: 'flags'},
			{ objHandle:'uiOrder', value: 'ui_order'},
			{ objHandle:'imagePath', value: 'ui_image'},
			{ objHandle:'imagePathInspect', value: 'ui_image_inspect'},
			{ objHandle:'imagePathThumbnail', value: 'ui_image_thumbnail'},
			{ objHandle:'RewardItemsNames', value: 'item_name'},
			{ objHandle:'RewardItemGroups', value: 'item_name_groups'},
			{ objHandle:'FreeRewardItemsNames', value: 'item_name_free'},
			{ objHandle:'useAsCallout', value: 'callout'},
			{ objHandle:'isGap', value: 'none'},
			{ objHandle:'lootlist', value: []},
			{ containerType:'' }
		];

		var _allRewardsData = [];

		for ( var i = 0; i < nRewardsCount; i++ )
		{
			var _rewardData = {};
			_rewardData.idx = i;
			aRewardDataFields.forEach(function( item, index ) 
			{
				$.Msg( '---ASK objHandle=' + item.objHandle );
				_rewardData[item.objHandle] = _GetObjValue( bHasStoreItems, i, item );
			});

			// NOTE: both "sRewardName" and "sRewardFree" can be empty strings (missing rewards, definitely not every tier gives free rewards)
			// we can have arbitrary reward schema for the client, for now let's assume that they are item definition names, 
			// could change the layout to be defidx number or additional fields later too
			// if we hang multiple rewards per tier, then we can comma-separate them and split them up, something like:
			// "item_name_free" "capsule,nametag,sticker";
			var rewardTypes = [
				{ type: 'premium', names: _rewardData.RewardItemsNames },
				{ type: 'free', names: _rewardData.FreeRewardItemsNames }
			];

			rewardTypes.forEach( rType =>
			{
				if( !rType.names )
				{
					rType.names = '';
				}
				
				var items = { type: rType.type, ids: [] };
				var nameList = rType.names.split( ',' );
				nameList.forEach( reward =>
				{
					if ( reward )
					{
						var itemidForReward;
						if ( reward.startsWith( 'lootlist:' ) )
						{ // use first item from the lootlist to display
							itemidForReward = InventoryAPI.GetLootListItemIdByIndex( reward, 0 );
						} else
						{	// real item definition, use that item for display
							var nDefinitionIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName( reward );
							itemidForReward = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( nDefinitionIndex, 0 );
						}
						items.ids.push( itemidForReward );
					}
				} );

				_rewardData[ 'item' + rType.type ] = items;
			} );
			
			if ( _rewardData.RewardItemGroups )
			{
				var posUnderscore = _rewardData.RewardItemGroups.lastIndexOf('_');
				var numGroups = parseInt( _rewardData.RewardItemGroups.substr( posUnderscore + 1 ) ) + 1;
				var strBaseLootlistName = _rewardData.RewardItemGroups.substr( 0, posUnderscore + 1 );
				_rewardData.lootlistGroups = [];
				_rewardData.lootlist = [];
				for ( var k = 0; k < numGroups; ++ k )
				{
					var idxFistGroupElement = _rewardData.lootlist.length;
					var strListName = 'lootlist:'+strBaseLootlistName+k;
					var moreItems = _GetLootListForReward( strListName );
					$.Msg( '_GetLootListForReward for ' + strListName + ' --> ' + ( moreItems ? moreItems.length : 0 ) );
					if ( moreItems.length > 0 )
					{
						for ( var mm = 0; mm < moreItems.length; ++ mm )
						{
							_rewardData.lootlist.push( moreItems[mm] );
						}
						_rewardData.lootlistGroups.push( { idxBegin: idxFistGroupElement, idxEnd: _rewardData.lootlist.length } );
					}
				}
			}
			else
			{
				_rewardData.lootlist = _GetLootListForReward( _rewardData.itempremium.ids[ 0 ] );
			}
			_rewardData.containerType = _GetContainerTypeForReward( _rewardData );

			_allRewardsData.push( _rewardData );
		}

		return _allRewardsData;
	};

	var _GetLootListForReward = function( rewardId )
	{
		var count = InventoryAPI.GetLootListItemsCount( rewardId );
		var itemsList = [];
		if ( !count )
		{
			itemsList.push( rewardId );
		}
		else
		{
			for ( var i = 0; i < count; i++ )
			{
				//
				// Special operation code -- graffiti items inside lootlists for
				// operation rewards get some random tints so that display was
				// a little more interesting
				//
				var itemId = InventoryAPI.GetLootListItemIdByIndex( rewardId, i );
				if ( ItemInfo.IsSprayPaint( itemId ) || ItemInfo.IsSpraySealed( itemId ) )
				{
					itemId = InventoryAPI.GenerateSprayTintedItemID( itemId );
				}
				itemsList.push( itemId );
			}
		}

		return itemsList;
	};

	function _IfOperationEndedGetExtendedSeasonWithRedeemableBalance( bAlwaysShowOperationEndedMessageBox )
	{
		var nActiveSeason = 10; // April 2021 <vitaliy> Limited time after the operation is over we still allow users to access the operation shop
		
		if ( bAlwaysShowOperationEndedMessageBox )
		{
			nActiveSeason = -1;
		}
		else
		{
			_ValidateOperationInfo( nActiveSeason );
			if ( m_numRedeemableBalance <= 0 )
				nActiveSeason = -1;
		}
			
		if ( nActiveSeason < 0 )
			UiToolkitAPI.ShowGenericPopup( '#op_stars_shop_title', '#op_stars_shop_operation_over', "" );
			
		return nActiveSeason;
	}

	function _OpenUpSell( starsNeeded = 0, bForceOpenStarsPurchase = false )
	{
		function _OpenStarStore()
		{
			var elPopup = UiToolkitAPI.ShowCustomLayoutPopupParameters(
				'',
				'file://{resources}/layout/popups/popup_operation_store.xml',
				'bluroperationpanel=true',
				'none'
			);

			elPopup.SetAttributeInt( "starsneeded", starsNeeded );
			$.Msg( 'starsNeeded' + starsNeeded + ' , id: ' + elPopup.id );
			
			var oOldStarsActivate = _UpdateOldStars();
			$.Msg( 'oOldStarsActivate: ' + oOldStarsActivate.ids.length + ' ' + ( ( oOldStarsActivate.ids.length > 0 ) ? oOldStarsActivate.ids.join( ', ' ) : 'n/a' ) );
			if ( oOldStarsActivate.ids.length > 0 )
			{
				elPopup.SetAttributeString( "oldstarstoactivate", oOldStarsActivate.ids.join( ',' ) );
				elPopup.SetAttributeInt( "oldstarstoactivatevalue", oOldStarsActivate.value );
			}
		}

		function _OpenStoreForPass( passId )
		{
			if( passId )
			{
				UiToolkitAPI.ShowCustomLayoutPopupParameters(
					'',
					'file://{resources}/layout/popups/popup_inventory_inspect.xml',
					'itemid=' + passId +
					'&' + 'asyncworktype=useitem' + 
					'&' + 'seasonpass=true' +
					'&' + 'bluroperationpanel=true'
				);
				return;
			}
			
			var passDefIndex = _GetPassFauxId();
			UiToolkitAPI.ShowCustomLayoutPopupParameters(
				'',
				'file://{resources}/layout/popups/popup_inventory_inspect.xml',
				'itemid=' + passDefIndex +
				'&' + 'inspectonly=false' +
				'&' + 'asyncworkitemwarning=no' +
				'&' + 'bluroperationpanel=true' +
				'&' + 'storeitemid=' + passDefIndex +
				'&' + 'overridepurchasemultiple=0',
				'none'
			);
		}

		$.DispatchEvent( 'CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE' );

		// If the operation is over then nothing to open
		var nActiveSeason = GameTypesAPI.GetActiveSeasionIndexValue();
		if ( nActiveSeason < 0 )
		{
			_IfOperationEndedGetExtendedSeasonWithRedeemableBalance( true );
			return;
		}

		var passId = InventoryAPI.GetActiveSeasonPassItemId();

		if ( m_bPremiumUser || bForceOpenStarsPurchase )
		{
			_OpenStarStore();
		}
		else
		{
			_OpenStoreForPass( passId );
		}
	}

	var _GetPassFauxId = function()
	{
		return  InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( m_passStoreId, 0 );
	};

	var _GetOperationStarDefIdxArray = function()
	{
		return m_aStarDefIndexes;
	}

	var _UpdateOldStars = function()
	{
		var oDefNames = [ {},{},{} ];
		oDefNames[0] = {def:InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( m_aStarDefIndexes[0], 0 )),value:1};
		oDefNames[1] = {def:InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( m_aStarDefIndexes[1], 0 )),value:10};
		oDefNames[2] = {def:InventoryAPI.GetItemDefinitionName(InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( m_aStarDefIndexes[2], 0 )),value:100};

		var oTotalStars = { ids: [], value: 0 };
		oDefNames.forEach( element =>
		{
			InventoryAPI.SetInventorySortAndFilters( 'inv_sort_age', false, 'item_definition:' + element.def, '', '' );
			var count = InventoryAPI.GetInventoryCount();
			for ( var i = 0; i < count; i++ )
			{
				oTotalStars.ids.push( InventoryAPI.GetInventoryItemIDByIndex( i ) );
				oTotalStars.value += element.value;
			}
		} );

		return oTotalStars;
	};

	var _MissionsThatMatchYourMatchMakingSettings = function( SessionGameMode, sessionMaps, nSeasonAccess )
	{
		// var activeCardIndx = MissionsAPI.GetSeasonalOperationMissionCardActiveIdx( nSeasonAccess );

		var numMissionCards = MissionsAPI.GetSeasonalOperationMissionCardsCount( nSeasonAccess );
		for ( var i = 0; i < numMissionCards; ++ i )
		{
			var jsoCardDetails = MissionsAPI.GetSeasonalOperationMissionCardDetails( nSeasonAccess, i );
			_GetMatchingMission( i, jsoCardDetails, SessionGameMode, sessionMaps );
		}
	};

	var _GetMatchingMission = function( idx, jsoCardDetails, SessionGameMode, sessionMaps )
	{
		var oMatchingMissions = {};
		for ( var iMission = 0; iMission < jsoCardDetails.quests.length; ++iMission )
		{
			var MissionItemID = InventoryAPI.GetQuestItemIDFromQuestID( Number( jsoCardDetails.quests[ iMission ] ) );
			var gameMode = InventoryAPI.GetQuestGameMode( MissionItemID );
			var mapGroup = InventoryAPI.GetQuestMapGroup( MissionItemID );

			if ( !mapGroup )
			{	// some quests in schema do not specify a map group, so build from the map name
				mapGroup = 'mg_' + InventoryAPI.GetQuestMap( MissionItemID );
			}

			if ( SessionGameMode === gameMode &&
				_HasMatchtingMapGroup( sessionMaps, mapGroup ) &&
				jsoCardDetails.isunlocked &&
				MissionsAPI.GetQuestPoints( jsoCardDetails.quests[ iMission ], "remaining" ) === 0 )
			{
				if ( !oMatchingMissions.hasOwnProperty( 'card' + idx ) )
				{
					oMatchingMissions[ 'card' + idx ] = idx;
					oMatchingMissions.missions = [];
				}
				
				oMatchingMissions.missions.push( MissionItemID );
			}
		}

		return oMatchingMissions;
	};

	var _HasMatchtingMapGroup = function( sessionMaps, mapGroup )
	{
		return sessionMaps.filter( element => mapGroup.includes( element ) ).length > 0 ? true : false;
	};

	var _HasStoreItems = function ( )
	{
		return m_nRedeemableGoodsCount > 0 && m_nRedeemableGoodsCount !== null && m_nRedeemableGoodsCount != undefined ? true : false;
	};

	var _GetOperationInfo = function()
	{
		return {
			nSeasonAccess: m_nSeasonAccess,
			nTierUnlocked: m_numTierUnlocked,
			nRewardsCount: m_nRewardsCount,
			bShopIsFreeForAll: false,
			nRedeemableGoodsCount: m_nRedeemableGoodsCount,
			nRedeemableBalance : m_numRedeemableBalance,
			nMissionsCompleted: m_numMissionsCompleted,
			nMissionsRewardThresholds: m_numMissionsRewardThresholds,
			bPremiumUser: m_bPremiumUser,
			nCoinRank: m_nCoinRank,
			nActiveCardIndex: m_nActiveCardIndex,
			bPrime: m_bPrime
		};
	};

	return {
		ValidateOperationInfo: _ValidateOperationInfo,
		GetOperationInfo: _GetOperationInfo,
		GetRewardsData: _GetRewardsData,
		OpenUpSell: _OpenUpSell,
		GetPassFauxId: _GetPassFauxId,
		GetOperationStarDefIdxArray: _GetOperationStarDefIdxArray,
		MissionsThatMatchYourMatchMakingSettings: _MissionsThatMatchYourMatchMakingSettings,
	};

})();
