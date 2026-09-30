
'use-strict';

var CapabilityOperationStore = ( function()
{
	var _GetStarsCountForOperation = function()
	{
		var oi = OperationUtil.GetOperationInfo();
		if ( oi.nRedeemableGoodsCount && oi.nRedeemableGoodsCount > 0 )
			return oi.nRedeemableBalance;
		else
			return oi.nTierUnlocked;
	};

	var _CanUserDoShopping = function()
	{
		var oi = OperationUtil.GetOperationInfo();
		return oi.bShopIsFreeForAll ? true : oi.bPremiumUser;
	};

	var _Init = function()
	{
		var nActiveSeason = GameTypesAPI.GetActiveSeasionIndexValue();

		if( !OperationUtil.ValidateOperationInfo( nActiveSeason ) || !_CanUserDoShopping() )
		{
			              
			$.DispatchEvent( 'UIPopupButtonClicked', '' );
			return;
		}

		StarsShoppingCart.Init();

		var blurOperationPanel = ( $.GetContextPanel().GetAttributeString( 'bluroperationpanel', 'false' ) === 'true' ) ? true : false;
		if ( blurOperationPanel )
		{
			$.DispatchEvent( 'BlurOperationPanel' );
		}

		var oldStarItemIdsToActivate = $.GetContextPanel().GetAttributeString( 'oldstarstoactivate', '' );
		if ( oldStarItemIdsToActivate )
		{
			var oldStarsValue = $.GetContextPanel().GetAttributeInt( 'oldstarstoactivatevalue', 0 );
			StarsShoppingCart.SetNewStarsTotalDialogVar( oldStarsValue );
			StarsShoppingCart.SetOldStarItemIdsForApply( oldStarItemIdsToActivate );
			
			SetCurrrentStars();
			return;
		}

		               
		$.GetContextPanel().SetDialogVariableInt( 'after_purchase_stars', OperationUtil.GetOperationInfo().nCoinRank );
		SetCurrrentStars();

		                                                                                             
		                          
		      

		StarsShoppingCart.SelectStoreTab();

		                                                                                             
		                                            
		      
	};

	var SetCurrrentStars = function( )
	{
		var starsEarned = _GetStarsCountForOperation();
		
		$.GetContextPanel().SetDialogVariableInt( 'total_stars', starsEarned );
		$.GetContextPanel().Data().starsEarned = starsEarned;
	};

	var _SetStarsLevelsAfterPurchase = function( nStarsInCart )
	{
		$.GetContextPanel().SetHasClass( 'popup-operation-store-cart-empty', nStarsInCart <= 0 );

		if ( !nStarsInCart )
		{
			return;
		}
		
		var newStarValue = $.GetContextPanel().Data().starsEarned + nStarsInCart;
		var animName = ( $.GetContextPanel().Data().oldStarsTotal &&  $.GetContextPanel().Data().oldStarsTotal <= newStarValue ) ?
			'popup-operation-progress-anim' : 
			'popup-operation-progress-remove-anim';

		$.GetContextPanel().Data().oldStarsTotal = newStarValue;
	
		$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-progress-after').AddClass( animName );
		$.Schedule( 0.2, function() { $.GetContextPanel().SetDialogVariableInt( 'after_purchase_stars', newStarValue ); } );
		$.Schedule( 0.5, function() { $.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-progress-after').RemoveClass( animName ); } );
	};

	var _ClosePopup = function()
	{
		$.DispatchEvent( 'UnblurOperationPanel' );
		$.DispatchEvent( 'UIPopupButtonClicked', '' );
		$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.mainmenu_press_home', 'MOUSE' );
		StarsShoppingCart.ResetTimeouthandle();
	};

	return {
		Init: _Init,
		GetStarsCountForOperation: _GetStarsCountForOperation,
		SetStarsLevelsAfterPurchase: _SetStarsLevelsAfterPurchase,
		ClosePopup: _ClosePopup
	};
} )();

var StarsShoppingCart = ( function()
{
	var ARRAY_STORE_ITEMS = [
		{
			rank_restriction: 2,
			storeids: OperationUtil.GetOperationStarDefIdxArray(),
			coinid: 4550
		}
		           
		                             
		    
		   	                    
		   	                         
		   	            
		     
		    
		   	                    
		   	                         
		   	            
		     
		          
	];

	var MAX_QUANTITY = StoreAPI.GetStoreCartItemLimit();
	var MAX_QUANTITY_EACH = 9;
	var _nStarsInCart = 0;
	var m_scheduleHandle = null;
	var m_aCartItemIds = [];
	var m_NewItemsList = [];

	var elParent = $.GetContextPanel().FindChildInLayoutFile( 'popup-operation-store-rows' );

	var _Init = function()
	{
		var elOK = $.GetContextPanel().FindChildInLayoutFile( 'AsyncItemWorkAcceptConfirm' );
		elOK.SetPanelEvent( 'onactivate', _OnActivate.bind( undefined, elOK, 'purchase') );

		var elApply = $.GetContextPanel().FindChildInLayoutFile( 'AsyncItemWorkUseItem' );
		elApply.SetPanelEvent( 'onactivate', _OnActivate.bind( undefined, elApply, 'useitem' ) );

		                                                                                     
		                          
	};


	                                                                                     
	          
	                                     
	 
		                                 
		                                                                                                          
		                                                             

		                                           
		 
			                                                                                                                            

			                                           
			 
				                                                                               
				                                                                                

				                                   
				                                                                                    
				                                                
				
				                                                                           
				 
					                                                                        
				 

				                                                                                     
			    

			                                                                                                                         
			                                                                                                   
			                                                                         
			                                                                              
			                                                                   
			                                                                     
			
			                                          
			 
				                                                                                  
				                                                                                              
				                                                                                                                                  
				                                                                                                       

				                                                                 
			 
			                                                                                                      
			 
				                                                                                             
				                                                                                            
					                                             
			 
			     
			 
				                        
			 
		    
	  
	          

	var _SelectStoreTab = function()
	{
		                                                                                                
		var nRank = OperationUtil.GetOperationInfo().nCoinRank > 1 ? 2 : 0;
		
		                                                                                             
		                                                                                                     
		      

		_UpdateStoreBasedOnCoinRank( nRank );
		_PreFillCart();
	};

	                                                                                     
	          
	                                      
	 
		                                                                                                          
		
		                                                                                                                                           
			            
				                                                         
		   
	  
	          

	var _UpdateStoreBasedOnCoinRank = function( nRank, bIsPreview = false )
	{
		                                                         
		var oStoreData = ARRAY_STORE_ITEMS[0];                                                                      

		                                  
		oStoreData.storeids.forEach( element => {

			var elRow = $.CreatePanel( 'Panel', elParent, element );
			elRow.BLoadLayoutSnippet( 'store-row' );

			var fauxItemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex( element, 0 );
			var starsCount = InventoryAPI.GetItemAttributeValue( fauxItemId, 'upgrade level' );
			var discount = StoreAPI.GetStoreItemPercentReduction( fauxItemId, 1 );
			elRow.Data().itemid = fauxItemId;
			elRow.Data().quantity = 0;
			elRow.Data().starsCount = starsCount;

			                          
			if ( !discount )
			{
				elRow.AddClass( 'popup-operation-store-row--no-discount' );
			}
			else
			{
				elRow.SetDialogVariable( 'store-item-discount', discount );
				elRow.SetDialogVariable( 'store-item-original-price', ItemInfo.GetStoreOriginalPrice( fauxItemId, 1 ) );
			}

			elRow.SetHasClass( 'quantity-count1', starsCount === 1 );
			elRow.SetDialogVariable( 'quantity_name', starsCount );
			elRow.SetDialogVariable( 'store-item-name', InventoryAPI.GetItemName( fauxItemId ) );
			elRow.SetDialogVariable( 'store-item-sale-price', ItemInfo.GetStoreSalePrice( fauxItemId, 1 ) );
			elRow.SetDialogVariableInt( 'store-item-quantity', elRow.Data().quantity );

			                              
			elRow.FindChildInLayoutFile( 'popup-operation-store-count-increment' ).enabled = !bIsPreview;
			elRow.FindChildInLayoutFile( 'popup-operation-store-count-increment' ).SetPanelEvent(
				'onactivate',
				_AddItem.bind( undefined, elRow ) );
			
			elRow.FindChildInLayoutFile( 'popup-operation-store-count-decrement' ).enabled = !bIsPreview;
			elRow.FindChildInLayoutFile( 'popup-operation-store-count-decrement' ).SetPanelEvent(
				'onactivate',
				_RemoveItem.bind( undefined, elRow ) );
			
			_UpdateRowPurchasePriceQuantity( elRow );
		} );
		
		elParent.Children()[ elParent.Children().length - 1 ].AddClass( 'popup-operation-store-row-bottom-border' );
	};
	
	var _AddItem = function( elRow )
	{
		if ( elRow.Data().quantity + 1 > ( MAX_QUANTITY / elRow.Data().starsCount) )
			return;
		if ( elRow.Data().quantity + 1 > MAX_QUANTITY_EACH )
			return;

		if ( elRow.Data().starsCount == MAX_QUANTITY )
		{	                                                     
			elRow.GetParent().Children().forEach( elOtherRow => {
				if ( elOtherRow.Data() && elOtherRow.Data().starsCount ) {
					while ( elOtherRow.Data().quantity > 0 )
						_RemoveItem( elOtherRow );
				}
			} );
		}
		
		elRow.Data().quantity = ++elRow.Data().quantity;
		elRow.SetDialogVariableInt( 'store-item-quantity', elRow.Data().quantity );
		_UpdateRowPurchasePriceQuantity( elRow );
	};

	var _RemoveItem = function( elRow )
	{
		if ( elRow.Data().quantity - 1 < 0 )
		{
			return;
		}
		
		elRow.Data().quantity = --elRow.Data().quantity;
		elRow.SetDialogVariableInt( 'store-item-quantity', elRow.Data().quantity );
		_UpdateRowPurchasePriceQuantity( elRow );
	};

	var _UpdateRowPurchasePriceQuantity = function( elRow )
	{
		var quantity = elRow.Data().quantity * Number( elRow.Data().starsCount );
		var price = !quantity ? '-' : ItemInfo.GetStoreSalePrice( elRow.Data().itemid, elRow.Data().quantity );
		var dispQuantity = !quantity ? '-' : quantity; 
		
		elRow.SetDialogVariable( 'store-item-purchase-price', price );
		elRow.SetDialogVariable( 'store-item-stars-quantity', dispQuantity );
		
		                                 
		var totalStarCount = _UpdateTotals();
		elRow.GetParent().Children().forEach( elOtherRow => {
			if ( elOtherRow.Data() && elOtherRow.Data().starsCount ) {
				_UpdateRowBtnState( elOtherRow, totalStarCount );
			}
		} );
	};

	var _UpdateRowBtnState = function( elRow, totalStarCount )
	{
		elRow.FindChildInLayoutFile( 'popup-operation-store-count-decrement' ).enabled = elRow.Data().quantity > 0;
		elRow.FindChildInLayoutFile( 'popup-operation-store-count-increment' ).enabled =
			( elRow.Data().quantity < ( MAX_QUANTITY / elRow.Data().starsCount) ) &&
			( elRow.Data().quantity < MAX_QUANTITY_EACH ) &&
			( totalStarCount < MAX_QUANTITY );
	};

	var _UpdateTotals = function()
	{
		var rows = elParent.Children();
		var aCartItems = _GetCartItems( rows );
		m_aCartItemIds = _GetItemsInCartAsList( aCartItems );
		var totalStarCount = _GetTotalStarCount( aCartItems );
		var dispTotalStarCount = !totalStarCount ? '-' : totalStarCount;
		var dispPrice = !totalStarCount  ? '-' : _GetTotalPriceOfItems( m_aCartItemIds );

		$.GetContextPanel().SetDialogVariable( 'store-item-price-total', dispPrice );
		_SetNewStarsTotalDialogVar( dispTotalStarCount );
		CapabilityOperationStore.SetStarsLevelsAfterPurchase( totalStarCount );

		var elOK = $.GetContextPanel().FindChildInLayoutFile( 'AsyncItemWorkAcceptConfirm' );
		elOK.enabled = m_aCartItemIds.length > 0;

		return totalStarCount;
	};

	var _SetNewStarsTotalDialogVar = function( count )
	{
		$.GetContextPanel().SetDialogVariable( 'store-item-stars-total', count );
	};

	var _GetCartItems = function( rows )
	{
		var aCartItems = [];

		rows.forEach( function( row, index )
		{
			aCartItems[ index ] = {};
			aCartItems[ index ].id = row.Data().itemid;
			aCartItems[ index ].quantity = row.Data().quantity;
		} );

		return aCartItems;
	};

	var _GetItemsInCartAsList = function( aCartItems )
	{
		var aItemsIdsList = [];
		aCartItems.forEach( function( item )
		{
			for ( var i = 0; i < item.quantity; i++ )
			{
				aItemsIdsList.push( item.id );
			}
		} );

		return aItemsIdsList;
	};

	var _GetTotalPriceOfItems = function( aItemsIdsList )
	{
		return StoreAPI.GetStoreItemsSalePrice( aItemsIdsList.join( ',' ) );
	};

	var _GetTotalStarCount = function( aCartItems )
	{
		var total = 0;
		aCartItems.forEach( function( item )
		{
			total += item.quantity * InventoryAPI.GetItemAttributeValue( item.id, 'upgrade level' );
		} );

		return total;
	};

	var _OnActivate= function( btn, workType )
	{
		if ( workType == 'useitem' )
		{
			if ( m_scheduleHandle )
			{
				$.CancelScheduled( m_scheduleHandle );
				m_scheduleHandle = null;
			}

			m_scheduleHandle = $.Schedule( 5, _CancelWaitforCallBack );
			                                                                                          

			$.GetContextPanel().FindChildInLayoutFile( 'op-Store-spinner' ).RemoveClass( 'hidden' );
			btn.AddClass( 'hidden' );
		}

		_PerformAsyncAction( workType );
	};

	var _PerformAsyncAction = function( workType )
	{
		if ( workType === 'useitem' )
		{
			m_NewItemsList.forEach( item => InventoryAPI.UseTool( item, '' ) );
		}
		else if ( workType == 'purchase' )
		{
			StoreAPI.StoreItemPurchase( m_aCartItemIds.join( ',' ) );
		}
	};

	var _CancelWaitforCallBack = function( )
	{
		                                                                                       
		if ( !m_scheduleHandle ) return;                                                                                              
		m_scheduleHandle = null;
		
		var elSpinner = $.GetContextPanel().FindChildInLayoutFile( 'op-Store-spinner' );
		elSpinner.AddClass( 'hidden' );

		CapabilityOperationStore.ClosePopup();

		UiToolkitAPI.ShowGenericPopupOk(
			$.Localize( '#SFUI_SteamConnectionErrorTitle' ),
			$.Localize( '#SFUI_InvError_Item_Not_Given' ),
			'',
			() => {},
			() => {}
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

	var _ItemAcquired = function( ItemId )
	{
		$.DispatchEvent( "CSGOPlaySoundEffect", "rename_purchaseSuccess", "MOUSE" );

		function onlyUnique ( value, index, arr ) 
		{ 
			return arr.indexOf(value) === index;
		}
		
		var unique = m_aCartItemIds.filter( onlyUnique );
		var aDefNames = [];
		unique.forEach( function( item, idx )
		{
			aDefNames.push( InventoryAPI.GetItemDefinitionName( item ) );
		} );
		
		if ( aDefNames.includes( InventoryAPI.GetItemDefinitionName( ItemId ) ) )
		{
			                
			_ResetTimeouthandle();

			$.DispatchEvent( 'HideStoreStatusPanel' );
			_AcknowlegeStars( aDefNames );
			_SetApplyStarsStyles();
		}
	};

	var _AcknowlegeStars = function( aDefNames )
	{
		var bShouldAcknowledge = true;
		m_NewItemsList = AcknowledgeItems.GetItemsByType( aDefNames, bShouldAcknowledge );
		
		if ( m_NewItemsList.length < 1 )
		{
			CapabilityOperationStore.ClosePopup();
			return;
		}
	};

	var _SetOldStarItemIdsForApply = function( ids )
	{
		m_NewItemsList = ids.split( ',' );
		_SetApplyStarsStyles();
		_UpdateApplyDialogLabels( true );
	};

	var _SetApplyStarsStyles = function()
	{
		$.GetContextPanel().AddClass( 'popup-operation-store-apply-stars' );
		$.GetContextPanel().FindChildInLayoutFile( 'op-Store-spinner' ).AddClass( 'hidden' );
		$.GetContextPanel().FindChildInLayoutFile( 'AsyncItemWorkUseItem' ).RemoveClass( 'hidden' );
		$.GetContextPanel().FindChildInLayoutFile( 'AsyncItemWorkAcceptConfirm' ).AddClass( 'hidden' );
		_UpdateApplyDialogLabels( false );
	};

	var _UpdateApplyDialogLabels = function( bhasUnused, bNewStars )
	{
		if ( bNewStars )
		{
			$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_title' ).text = '#CSGO_PickEm_Trophy_Status_Gold';
			$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_desc' ).text = '#op_store_stars_applied';
		}
		else
		{
			$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_title' ).text = bhasUnused ? '#op_store_apply_stars_unused' : '#op_store_apply_stars';
			$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_desc' ).text = bhasUnused ? '#op_store_apply_stars_desc_unused' : '#op_store_apply_stars_desc';
		}
	
		$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_type_desc' ).text = bhasUnused ? '#op_store_new_stars_unused' : '#op_store_new_stars';

		$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-apply_warning' ).visible = !bNewStars;
	};
	
	var _PreFillCart = function()
	{
		var nStarsNeeded = $.GetContextPanel().GetAttributeInt( 'starsneeded', 0 );

		                                      
		if ( nStarsNeeded < 1 )
		{
			return;
		}

		var elRows = $.GetContextPanel().FindChildInLayoutFile( 'popup-operation-store-rows' ).Children();
		elRows.sort( function( a, b ) { return b.Data().starsCount - a.Data().starsCount } );
		var amount = nStarsNeeded;

		elRows.forEach( row =>
		{
			                                                                          
			amount = amount / row.Data().starsCount;

			if ( Math.floor( amount ) > 0 )
			{
				                                             
				for ( var i = 0; i < Math.floor( amount ); i++ )
				{
					_AddItem( row );
				}

				amount = nStarsNeeded % row.Data().starsCount;
			}
			else if( amount !== 0 )
			{
				amount = nStarsNeeded;
			}
		} );
	};

	var _OnInventoryUpdate = function()
	{
		var prevStars = $.GetContextPanel().Data().starsEarned;

		OperationUtil.ValidateOperationInfo( OperationUtil.GetOperationInfo().nSeasonAccess );
		var StarsEarned = CapabilityOperationStore.GetStarsCountForOperation();

		if ( StarsEarned > prevStars )
		{
			_ResetTimeouthandle();
			$.Schedule( 0.3, function() { $.GetContextPanel().SetDialogVariableInt( 'total_stars', StarsEarned ); } );
			$.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.popup_newweapon', 'MOUSE' );
			$.GetContextPanel().FindChildInLayoutFile( 'id-operation-store-progress-apply' ).AddClass( 'popup-operation-apply-stars' );
			$.GetContextPanel().AddClass( 'popup-operation-store-reveal-new-stars' );
			$.GetContextPanel().FindChildInLayoutFile( 'op-Store-spinner' ).AddClass( 'hidden' );
			_UpdateApplyDialogLabels( false, true );
		}
	};

	return {
		Init: _Init,
		nStarsInCart: _nStarsInCart,
		SelectStoreTab: _SelectStoreTab,
	          
		                                            
	          
		UpdateStoreBasedOnCoinRank: _UpdateStoreBasedOnCoinRank,
		ResetTimeouthandle: _ResetTimeouthandle,
		ItemAcquired: _ItemAcquired,
		OnInventoryUpdate: _OnInventoryUpdate,
		SetOldStarItemIdsForApply: _SetOldStarItemIdsForApply,
		SetNewStarsTotalDialogVar: _SetNewStarsTotalDialogVar
	};

} )();

( function()
{
	$.RegisterForUnhandledEvent( 'PanoramaComponent_MyPersona_InventoryUpdated', StarsShoppingCart.OnInventoryUpdate );
	$.RegisterForUnhandledEvent( 'PanoramaComponent_Store_PurchaseCompleted', StarsShoppingCart.ItemAcquired );
} )();