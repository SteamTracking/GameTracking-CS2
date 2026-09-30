function SetupContextMenu()
{
	var strValue = $.GetContextPanel().GetAttributeString( "test", "(not found)" );
	$( '#DynamicButton' ).text = "Parameter 'test' had value '" + strValue + "'";
}

function OnTestPressed()
{
	// Run some js code
	$.Msg('OnTestPressed: Running from \'context menu custom layout\'\n');
	
	// Invoke callback set up in the parent panel (if set)
	var callbackHandle = $.GetContextPanel().GetAttributeInt( "callback", -1 );
	if ( callbackHandle != -1 )
	{
		UiToolkitAPI.InvokeJSCallback( callbackHandle, 'Test' );
	}
	
	// Do not forget to dispatch the ContextMenuEvent() panorama event
	// responsible for closing the context menu
	$.DispatchEvent( 'ContextMenuEvent', '' );
}