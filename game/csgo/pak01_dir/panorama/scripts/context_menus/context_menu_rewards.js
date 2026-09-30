'use strict';
var ContextMenuRewards = ( function()
{
    var _Init = function()
    {
        _AddContexTMenuEntries();
    };

    var _AddContexTMenuEntries = function()
    {
        var elParent = $.GetContextPanel();
        var aList = elParent.Data().aRewardsList;

        aList.forEach( element => 
        {
            var elButton = $.CreatePanel( 'Button', elParent, 'ContextMenuItem' + element.idx );
            var elLabel = $.CreatePanel( 'Label', elButton, '', { html: 'true' } );
            elLabel.text = InventoryAPI.GetItemName( element.itemLists[ 0 ].itemIds[ 0 ] );

            elButton.SetPanelEvent( 'onactivate', _OnActivate.bind( undefined, element.idx ) );
            elButton.SetPanelEvent( 'onmouseover', _CacheWeapon.bind( undefined, element.itemLists[ 0 ].itemIds[ 0 ] ) );
        } );
    };

    var _OnActivate = function( idx )
    {
                           
                                                                                
        
                                                              
        var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
        if ( callbackHandle != -1 )
        {
            UiToolkitAPI.InvokeJSCallback( callbackHandle, idx );
        }

                                                   
        $.DispatchEvent( 'ContextMenuEvent', '' );
    };

    var _CacheWeapon = function( id )
    {
        InventoryAPI.PrecacheCustomMaterials( id );
    };
    
    return { Init: _Init };
}());