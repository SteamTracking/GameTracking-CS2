"use strict";
	
function SetupPopup()
{
	const MAX_OPTIONS = 10;

	var strToken = $.GetContextPanel().GetAttributeString( "textToken", "" );
	$.GetContextPanel().SetDialogVariable( "title", $.Localize( strToken + '_title' ) );
	$.GetContextPanel().SetDialogVariable( "desc", $.Localize( strToken + '_desc' ) );

	var currentValue = $.GetContextPanel().GetAttributeString( "currentvalue", "" );
	
	var elOptionsContainer = $.GetContextPanel().FindChildTraverse( 'RadioOptionsContainer' );

	function _CreateOption ( value, strToken )
	{
		var elOption = $.CreatePanel( 'RadioButton', elOptionsContainer, 'id-' + value );
		elOption.BLoadLayoutSnippet( 'option' );
		elOption.SetDialogVariable( 'optiontext', $.Localize( strToken + '_' + value ) );
		elOption.SetDialogVariable( 'optiontextdesc', $.Localize( strToken + '_' + value + '_desc' ) );
		elOption.SetPanelEvent( 'onactivate', _OnRadioButtonPressed.bind( undefined, value ) );

		return elOption;
	}

	for ( var i = 0; i < MAX_OPTIONS; i++ )
	{
		var value = $.GetContextPanel().GetAttributeString( "option" + i, '' );

		if ( value )
		{
			var elOption = _CreateOption( value, strToken );

			if ( value == currentValue )
			{
				elOption.checked = true;
				_OnRadioButtonPressed( value );
			}
		}
	}
}


function _OnRadioButtonPressed ( value )
{
	$.GetContextPanel().SetAttributeString( "selected", value );
}


function _Return ( bProceed )
{
	                                                      


	var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
	var cancelCallbackHandle = $.GetContextPanel().GetAttributeInt( "cancelcallback", -1 );

	var callback = bProceed ? callbackHandle : cancelCallbackHandle;

	if ( callbackHandle != -1 )
	{
		var resumeMatchmakingHandle = $.GetContextPanel().GetAttributeString( "searchfn", '' );

		var value = $.GetContextPanel().GetAttributeString( "selected", "" );

		UiToolkitAPI.InvokeJSCallback( callback, value, resumeMatchmakingHandle );
	}

	                               
	if ( callbackHandle != -1 )
		UiToolkitAPI.UnregisterJSCallback( callbackHandle );

	if ( cancelCallbackHandle != -1 )
		UiToolkitAPI.UnregisterJSCallback( cancelCallbackHandle );

	                                                                                                                                  


	                                                                      
	                                    
	$.DispatchEvent( 'UIPopupButtonClicked', '' );
}

function OnOKPressed()
{
	_Return( true );
}

function CancelPopup ()
{
	_Return( false );
}
