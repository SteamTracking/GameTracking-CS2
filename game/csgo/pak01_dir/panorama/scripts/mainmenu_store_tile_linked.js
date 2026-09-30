'use strict';

var MainMenuStoreTileLinked = ( function()
{
	var elItem = $.GetContextPanel();
	
	var _Init = function()
	{
		_FillOutLinkedItemData();
		_SetOnActivateEventLinkedItemTile();
	}
	
	var _FillOutLinkedItemData = function()
	{
		var itemId = elItem.Data().oData.itemid;
		var itemIdLinked = elItem.Data().oData.linkedid;

		var LootListItemID = ( InventoryAPI.GetItemTypeFromEnum( itemId ) !== 'coupon' ) ? itemId : InventoryAPI.GetLootListItemIdByIndex( itemId, 0 );
		var elImage = elItem.FindChildInLayoutFile( 'StoreItemImage' );
		elImage.itemid = LootListItemID;

		LootListItemID =  ( InventoryAPI.GetItemTypeFromEnum( itemIdLinked ) !== 'coupon' ) ? itemIdLinked : InventoryAPI.GetLootListItemIdByIndex( itemIdLinked, 0 );
		elImage = elItem.FindChildInLayoutFile( 'StoreItemImageLinked' );
		elImage.itemid = LootListItemID;

		var elStattrak = elImage.FindChildInLayoutFile( 'StoreItemStattrak' );
		elStattrak.SetHasClass( 'hidden', !ItemInfo.IsStatTrak( itemIdLinked ) && !ItemInfo.IsStatTrak( itemId ) );

		var elStoreItemName = elItem.FindChildInLayoutFile( 'StoreItemName' );
		var elShortNameHeader = elItem.FindChildInLayoutFile( 'ShortName' );
		var strItemName = '';
		if ( elItem.Data().oData.usegroupname )
			strItemName = $.Localize( elItem.Data().oData.usegroupname );
		else if ( elItem.Data().oData.usetinynames )
			strItemName = $.Localize( InventoryAPI.GetRawDefinitionKey(LootListItemID, 'item_name') + '_tinyname' );
		else
			strItemName = InventoryAPI.GetItemName( LootListItemID );
		
		if ( elItem.Data().oData.usegroupname )
		{
			elShortNameHeader.text = strItemName;
			elShortNameHeader.visible = true;
			elStoreItemName.text = '';
		}
		else
		{
			elShortNameHeader.text = '';
			elShortNameHeader.visible = false;
			elStoreItemName.text = strItemName;
		}

		var elSale = elItem.FindChildInLayoutFile( 'StoreItemSalePrice' );
		var elPrecent = elItem.FindChildInLayoutFile( 'StoreItemPercent' );
		var reduction = StoreAPI.GetStoreItemPercentReduction( itemId, 1 );

		  
		                 
		  
		var priceItemFirst = itemIdLinked;
		var priceItemLast = itemId;
		if ( elItem.Data().oData.linkpricing === 'reverse' )
		{
			priceItemFirst = itemId;
			priceItemLast = itemIdLinked;
		}

		if ( reduction )
		{
			elSale.visible = true;
			elSale.text = ItemInfo.GetStoreOriginalPrice( priceItemFirst, 1 ) + ' - ' +  ItemInfo.GetStoreOriginalPrice( priceItemLast, 1 );

			elPrecent.visible = true;
			elPrecent.text = reduction;
		}
		else
		{
			elSale.visible = false;
			elPrecent.visible = false;
		}

		var elPrice = elItem.FindChildInLayoutFile( 'StoreItemPrice' );
		if ( ItemInfo.GetStoreSalePrice( priceItemFirst, 1 ) )
		{
			elPrice.text = ItemInfo.GetStoreSalePrice( priceItemFirst, 1 ) + ' - ' + ItemInfo.GetStoreSalePrice( priceItemLast, 1 );
		}
		else
		{
			elPrice.text = '';
		}
	};

	var _SetOnActivateEventLinkedItemTile = function()
	{
		var OpenContextMenu = function( itemId, itemIdLinked, usetinynames )
		{
			var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParameters(
				'',
				'',
				'file://{resources}/layout/context_menus/context_menu_store_linked_items.xml',
				'itemids=' + itemId + ',' + itemIdLinked +
				( usetinynames ? '&usetinynames=' + usetinynames : '' ) +
				( elItem.Data().oData.extrapopupfullscreenstyle ? '&extrapopupfullscreenstyle=solidbkgnd' : '' ) +
				( elItem.Data().oData.isdisabled ? '&disablepurchase=true' : '' ) +
				( elItem.Data().oData.warningtext ? '&warningtext=' + elItem.Data().oData.warningtext  : '' )
			);
			contextMenuPanel.AddClass( "ContextMenu_NoArrow" );
		};

		elItem.SetPanelEvent( 'onactivate', OpenContextMenu.bind(
			undefined,
			elItem.Data().oData.itemid,
			elItem.Data().oData.linkedid,
			elItem.Data().oData.usetinynames
		) );
		elItem.SetPanelEvent( 'oncontextmenu', OpenContextMenu.bind(
			undefined,
			elItem.Data().oData.itemid,
			elItem.Data().oData.linkedid,
			elItem.Data().oData.usetinynames
		) );
	}

	return {
		Init: _Init
	};

} )();