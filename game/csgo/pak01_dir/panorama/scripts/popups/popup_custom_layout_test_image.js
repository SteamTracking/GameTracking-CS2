"use strict";

var SetupPopup = function()
{
                      
    var strMsg = $.GetContextPanel().GetAttributeString( "message", "(not found)" );
    $.GetContextPanel().SetDialogVariable( "message", strMsg );

                    
    $( "#popupimage" ).SetImage( $.GetContextPanel().GetAttributeString( "image", "" ) );

                             
    var spinnerVisible = $.GetContextPanel().GetAttributeInt( "spinner", 0 );
    $( "#Spinner" ).SetHasClass( "SpinnerVisible", spinnerVisible );

                                                             
    var loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt( "loadingBarCallback", -1 );
    if ( loadingBarCallbackHandle != -1 )
    {
                                                 
        var progressBar = $( "#ProgressBar" );
        progressBar.SetHasClass( "ProgressBarVisible", true );
                                                          
        progressBar.min = 0.0;
        progressBar.max = 1.0;
        progressBar.value = 0.0;
                                                  
        $.Schedule( 0.1, UpdateProgressBar );
    }
};

function OnOKPressed()
{
                       
                                                                      
    
                                                          
    var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
    if ( callbackHandle != -1 )
    {
        UiToolkitAPI.InvokeJSCallback( callbackHandle, 'OK' );
    }
    
                                                                          
                                        
    $.DispatchEvent( 'UIPopupButtonClicked', '' );
}

function UpdateProgressBar()
{
    var loadingBarCallbackHandle = $.GetContextPanel().GetAttributeInt( "loadingBarCallback", -1 );
    if ( loadingBarCallbackHandle != -1 )
    {
        $( "#ProgressBar" ).value = UiToolkitAPI.InvokeJSCallback( loadingBarCallbackHandle );
        
                             
        $.Schedule( 0.1, UpdateProgressBar );
    }
}