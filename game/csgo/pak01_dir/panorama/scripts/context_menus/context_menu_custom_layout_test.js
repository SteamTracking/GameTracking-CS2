function SetupContextMenu()
{
	var strValue = $.GetContextPanel().GetAttributeString( "test", "(not found)" );
	$( '#DynamicButton' ).text = "Parameter 'test' had value '" + strValue + "'";
}

function OnTestPressed()
{
	                   
	                                                                      
	
	                                                      
	var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
	if ( callbackHandle != -1 )
	{
		UiToolkitAPI.InvokeJSCallback( callbackHandle, 'Test' );
	}
	
	                                                                  
	                                           
	$.DispatchEvent( 'ContextMenuEvent', '' );
}