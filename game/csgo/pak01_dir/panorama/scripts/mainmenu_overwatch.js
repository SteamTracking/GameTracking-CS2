'use strict';

var mainmenu_overwatch = ( function()
{
	var _m_btnDownload;
	var _m_btnReview;
	var _m_panError;
	var _m_lblErrorText;
	var _m_downloadingProgressBar;

    function _Init()
    {
        _m_btnDownload = $( "#overwatch-download-evidence" );
        _m_btnReview = $( "#overwatch-review-evidence" );
		_m_panError = $("#overwatch-error-message");
		_m_lblErrorText = $("#overwatch-error-message-textlabel");
        _m_downloadingProgressBar = $( "#overwatch-downloading-progress" );

		_UpdateAllControlsFromComponent();
	}
	
	function _OnReadyForDisplay()
	{
		_UpdateAllControlsFromComponent();
	};

	function _UpdateAllControlsFromComponent()
	{
		  
		                      
		  
		var strErrorCode = OverwatchAPI.GetEvidencePreparationError();
        if ( !strErrorCode )
        {
			var strCaseDescription = OverwatchAPI.GetAssignedCaseDescription();
            if( strCaseDescription == "" )
            {
				strErrorCode = "#Overwatch_Error_DownloadFailed";
			}
		}
		_m_lblErrorText.text = strErrorCode ? $.Localize( strErrorCode ) : '';
		_m_panError.enabled = !!strErrorCode;

		  
		                              
		                  
		                    
		                              
		  
		var nProgress = OverwatchAPI.GetEvidencePreparationPercentage();
		_m_btnDownload.enabled = ( nProgress === 0 );
		_m_btnReview.enabled = ( nProgress === 100 );
		_m_downloadingProgressBar.value = ( nProgress / 100 );
	};

    function _DownloadEvidence()
    {
        OverwatchAPI.StartDownloadingCaseEvidence();
    }

                                                    
    function _CaseUpdated()
    {
        _UpdateAllControlsFromComponent();
    }

    function _ReviewEvidence()
    {
		$.DispatchEvent( 'HideContentPanel' );
        OverwatchAPI.PlaybackEvidence();
    }

	var _m_overwatchPopupPanel = null;
	
	function _ShowVerdictPopup ()
    {
		if ( !_m_overwatchPopupPanel || !_m_overwatchPopupPanel.IsValid())
		{
			_m_overwatchPopupPanel = UiToolkitAPI.ShowGlobalCustomLayoutPopup( 'PopupVerdict', 'file://{resources}/layout/popups/popup_mainmenu_overwatch_verdict.xml', '' );
		}
    }

                          
    return {
		Init                : _Init,
		OnReadyForDisplay	: _OnReadyForDisplay,
        DownloadEvidence    : _DownloadEvidence,
        ReviewEvidence      : _ReviewEvidence,
        CaseUpdated         : _CaseUpdated,
        ShowVerdictPopup    : _ShowVerdictPopup,
    };

})();

                                                                                                    
                                           
                                                                                                    
(function()
{
	mainmenu_overwatch.Init();

	var elJsMainMenuOverwatch = $( '#JsOverwatch' );

	$.RegisterEventHandler( 'ReadyForDisplay', elJsMainMenuOverwatch, mainmenu_overwatch.OnReadyForDisplay );

    $.RegisterForUnhandledEvent( 'PanoramaComponent_Overwatch_CaseUpdated', mainmenu_overwatch.CaseUpdated );
    $.RegisterForUnhandledEvent( 'PanoramaComponent_Overwatch_DemoFileEndReached', mainmenu_overwatch.ShowVerdictPopup );
})();
