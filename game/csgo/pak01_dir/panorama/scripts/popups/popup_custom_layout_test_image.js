"use strict";

var SetupPopup = function()
{
    // Set the message
    var strMsg = $.GetContextPanel().GetAttributeString( "message", "(not found)" );
    $.GetContextPanel().SetDialogVariable( "message", strMsg );

    // Set the image
    $( "#popupimage" ).SetImage( $.GetContextPanel().GetAttributeString( "image", "" ) );

    // Set spinner visibility
    var spinnerVisible = $.GetContextPanel().GetAttributeInt( "spinner", 0 );
    $( "#Spinner" ).SetHasClass( "SpinnerVisible", spinnerVisible );

    // Loading bar is visible if loadingBarCallback is set up
    var loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt( "loadingBarCallback", -1 );
    if ( loadingBarCallbackHandle != -1 )
    {
        $.Msg( 'Loading bar should be visible' );
        var progressBar = $( "#ProgressBar" );
        progressBar.SetHasClass( "ProgressBarVisible", true );
        // Min / Max could be passed as attributes as well
        progressBar.min = 0.0;
        progressBar.max = 1.0;
        progressBar.value = 0.0;
        // Set up first update of the progress bar
        $.Schedule( 0.1, UpdateProgressBar );
    }
};

function OnOKPressed()
{
    // Run some js code
    $.Msg('OnComplexPressed: Running from \'popup custom layout\'\n');
    
    // Invoke callback set up in the parent panel (if set)
    var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
    if ( callbackHandle != -1 )
    {
        UiToolkitAPI.InvokeJSCallback( callbackHandle, 'OK' );
    }
    
    // Do not forget to dispatch the UIPopupButtonClicked() panorama event
    // responsible for closing the popup
    $.DispatchEvent( 'UIPopupButtonClicked', '' );
}

function UpdateProgressBar()
{
    var loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt( "loadingBarCallback", -1 );
    if ( loadingBarCallbackHandle != -1 )
    {
        $( "#ProgressBar" ).value = UiToolkitAPI.InvokeJSCallback( loadingBarCallbackHandle );
        
        // Set up next update
        $.Schedule( 0.1, UpdateProgressBar );
    }
}