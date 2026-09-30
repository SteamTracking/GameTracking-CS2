'use strict';

var PopupConfirmPickemPicks = ( function(){

    var m_timeoutHandle = false;
    var _Init = function()
    {
                                                                                      
        
        var applyImmediate = $.GetContextPanel()._oPicksData.applyImmediate;


        if ( !applyImmediate )
        {
            _ShowStickers();
            _ShowTeams();
            _ShowAllClearingMsg();
        }
        else
        {
            _ApplyPicks();
        }

        $.GetContextPanel().SetHasClass( 'apply-immediate', applyImmediate );
    };

    var _ShowStickers = function()
    {
        var aPicksForConfirm = $.GetContextPanel()._oPicksData.picksforconfirm;
        var elStickerItemImages = $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-apply' );
        elStickerItemImages.visible = aPicksForConfirm.length > 0;

        if( aPicksForConfirm.length > 0 )
        {
           for( var i = 0; i < aPicksForConfirm.length; i++ )
           {
                $.CreatePanel( 
                    "ItemImage", 
                    $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-stickers' ), 
                    aPicksForConfirm[i],
                    {
                        class:"popup-confirm-picks-icons__stickers",
                        large:"true",
                        scaling:"stretch-to-fit-preserve-aspect",
                        itemid: aPicksForConfirm[i]
                    } );
           }
        }
    };

    var _ShowTeams = function()
    {
        var aTeamIds = $.GetContextPanel()._oPicksData.picksnoitems;
        var elTeamItemImages = $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-purchase' );
        elTeamItemImages.visible = aTeamIds.length > 0;

        if( aTeamIds.length > 0 )
        {
           for( var i = 0; i < aTeamIds.length; i++ )
           {
            var teamTag = PredictionsAPI.GetTeamTag( aTeamIds[i] );    
            $.CreatePanel( 
                    "Image", 
                    $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-teams' ),
                    aTeamIds[i],
                    {
                        textureheight: '52',
                        texturewidth: '52',
                        src: 'file://{images}/tournaments/teams/' + teamTag + '.svg',
                        class:'popup-confirm-picks-icons__teams'
                    } );
           }
        }
	};
	
	var _ShowAllClearingMsg = function()
	{
		var aPicksForConfirm = $.GetContextPanel()._oPicksData.picksforconfirm;
		var aTeamIds = $.GetContextPanel()._oPicksData.picksnoitems;
		                                                                       
		var elStickerItemImages = $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-clearall' );
		elStickerItemImages.visible = ( aPicksForConfirm.length <= 0 && aTeamIds.length <= 0 );
	}

    var _ApplyPicks = function()
    {
        $.DispatchEvent( 'CSGOPlaySoundEffect', 'UIPanorama.inventory_new_item_accept', 'MOUSE' );	
        $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confrim-apply-btn').enabled = false;
        $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-spinner' ).RemoveClass('hidden');
        PredictionsAPI.SetMyPredictionUsingItemID.apply( PredictionsAPI, $.GetContextPanel()._oPicksData.args );
        $.Schedule( 5, _OnTimeout );
    };

    var _OnTimeout = function ()
    {
        m_timeoutHandle = false;

        $.GetContextPanel().FindChildInLayoutFile( 'id-popup-confirm-spinner' ).AddClass('hidden');
        _Close();

        UiToolkitAPI.ShowGenericPopupOk(
			$.Localize( '#SFUI_SteamConnectionErrorTitle' ),
			$.Localize( '#pickem_apply_timeout' ),
			'',
			function()
			{
			},
			function()
			{
			}
		);
    };

    var _CancelTimeout= function()
    {
        if( m_timeoutHandle )
        {
            $.CancelScheduled( m_timeoutHandle );
            m_timeoutHandle = false;
        }
    };

    var _Close = function()
    {
        _CancelTimeout();
        $.DispatchEvent( 'UIPopupButtonClicked', '' );
    };

	return {
        Init: _Init,
        ApplyPicks: _ApplyPicks,
        CancelTimeout: _CancelTimeout,
        Close: _Close
	};

})();

(function(){

    $.RegisterForUnhandledEvent( 'PanoramaComponent_MatchList_PredictionUploaded', PopupConfirmPickemPicks.Close );

})();