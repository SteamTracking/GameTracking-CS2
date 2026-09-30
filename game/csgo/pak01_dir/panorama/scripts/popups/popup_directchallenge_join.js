"use strict";
	

var DirectChallengeJoin = ( function ()
{
	var m_submitFn = null;
	var m_elErrortext = $.GetContextPanel().FindChildInLayoutFile( 'id-error_text' );

	function _Init()
	{
		$.GetContextPanel().SetDialogVariable( 'text', $.Localize( '#DirectChallenge_EnterKeyField2' ) );

		m_submitFn = parseInt( $.GetContextPanel().GetAttributeInt( "submitCallback", -1 ) );

		$( "#submit" ).enabled = false;
		$( '#TextEntry' ).SetPanelEvent( 'ontextentrychange', OnTextEntryChanged );
		OnTextEntryChanged();
		$( '#TextEntry' ).SetFocus();
	}

	function OnTextEntryChanged ()
	{
		                                                

		                          
		var hasText = /.*\S.*/;
		if ( !hasText.test( $( '#TextEntry' ).text ) )
		{
			_Validate();
			return;
		}

		                                                                 
		var arrStrings = $( '#TextEntry' ).text.split( /\s/ ).filter( s => /^\w+$/.test( s ) );
		_Validate();

	}

	function _Submit()
	{
		var value = $( '#TextEntry' ).text;

		UiToolkitAPI.InvokeJSCallback( m_submitFn, value );
		_Close();
	}

	function _IsChallengeKeyValid ( key, oReturn = { value: [] }, how = '' )
	{
		var code = CompetitiveMatchAPI.ValidateDirectChallengeCode( key, how );

		var bValid = ( typeof code === 'string' ) && code.includes( ',' );

		if ( bValid )
		{
			oReturn.value = code.split( ',' );
		}

		return bValid;
	}

	function _IsPartOfGroup ( groupId )
	{
		var nNumClans = MyPersonaAPI.GetMyClanCount();
		for ( var i = 0; i < nNumClans; i++ )
		{
			                                                   
			var clanId32 = MyPersonaAPI.GetMyClanId32BitByIndex( i );

			if ( groupId === clanId32 )
			{
				return true;
			}
		}
		return false;
	}

	function _Validate ()
	{
		var elResultsPanel = $( "#validation-result" );
		if ( elResultsPanel && elResultsPanel.IsValid() )
		{
			elResultsPanel.RemoveAndDeleteChildren();
		}

		var bSuccess = false;
		var elAvatarContainer = $.CreatePanel( 'Panel', elResultsPanel, 'avatar-container', { class: 'avatar-container' } );

		var value = $( '#TextEntry' ).text;
		var oReturn = { value: [] };

		if ( _IsChallengeKeyValid( value.toUpperCase(), oReturn, '' ) )
		{
			                             
			var type = oReturn.value[ 2 ];                           
			var id = oReturn.value[ 3 ];                                 
			var id32 = parseInt( oReturn.value[ 4 ] );                                 

			var elTile = $.CreatePanel( "Panel", elAvatarContainer, 'JsKeyValidatedResult', { class: "directchallenge__join-validator" } );
			elTile.codeXuid = id;
			elTile.codeType = type ;

			elTile.SetAttributeString( 'xuid', id );
			elTile.BLoadLayout( 'file://{resources}/layout/friendtile.xml', false, false );
			$.GetContextPanel().FindChildInLayoutFile( 'id-direct-challenge-icon' ).SetHasClass( 'valid', true );

			                                               
			if ( type == 'g' )
			{
				elTile.SetAttributeString( 'isClan', 'true' );

				$.CreatePanel( "Image", elTile.FindChildInLayoutFile( 'JsFriendTileBtn' ), '', {
					src: "file://{images}/icons/ui/link.svg",
					class: "vertical-center left-padding right-padding horizontal-align-right",
					textureheight: "24",
					texturewidth: "24",
				});
			}

			                                                                
			$.Schedule( .1, function ()
			{
				if ( !elTile.IsValid() )
					return;
				FriendTile.Init( elTile );
				elTile.RemoveClass( 'hidden' );
			} );

			                                              
			if ( type == 'g' && !_IsPartOfGroup( id32 ) )
			{
				bSuccess = false;
				m_elErrortext.visible = true;
				m_elErrortext.text = $.Localize( "#DirectChallenge_not_member2" );
			}
			else
			{
				bSuccess = true;
				m_elErrortext.visible = false;
			}
		}
		else
		{

			m_elErrortext.visible = $( '#TextEntry' ).text === '' ? false : true;

			$.GetContextPanel().FindChildInLayoutFile( 'id-direct-challenge-icon' ).SetHasClass( 'valid', false );
			
			                          
			m_elErrortext.SetDialogVariable( 'code', $( '#TextEntry' ).text.toUpperCase() );
			m_elErrortext.text = $.Localize( '#DirectChallenge_BadKeyText', m_elErrortext );
		}

		$( "#submit" ).enabled = bSuccess;
		$.GetContextPanel().SetHasClass( 'results-panel-valid', bSuccess );
	}

	function _Cancel ()
	{
		_Close();
	}

	function _Close ()
	{
		if ( m_submitFn != -1 )
			UiToolkitAPI.UnregisterJSCallback( m_submitFn );
		
		$.DispatchEvent( 'UIPopupButtonClicked', '' );
	}

	return {
		Init: 					_Init,
		Submit:					_Submit,
		Close: 					_Close,
		Cancel: 				_Cancel,
		Validate: 				_Validate,
	};

} )();

                                                                                                    
                                            
                                                                                                    
( function ()
{
} )();