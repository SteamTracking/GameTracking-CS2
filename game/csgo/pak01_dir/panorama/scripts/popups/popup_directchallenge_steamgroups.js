"use strict";
	

var DirectChallengeSteamGroupSelector = ( function ()
{
	var m_key;

	function _Init()
	{
		m_key = $.GetContextPanel().GetAttributeString( 'currentkey', '' );

		$( "#submit" ).enabled = m_key != '';

		var elClansLister = $.GetContextPanel().FindChildTraverse( 'JsClansLister' );

		var nNumClans = MyPersonaAPI.GetMyClanCount();
		for ( var i = 0; i < nNumClans; i++ )
		{
			                                                   
			var clanID32 = MyPersonaAPI.GetMyClanId32BitByIndex( i );
			var clanChallengeKey = CompetitiveMatchAPI.GetDirectChallengeCodeForClan( clanID32 );
			var clanName = FriendsListAPI.GetClanInfoById32Bit( clanID32, 'name' );

			var elItem = $.CreatePanel( 'RadioButton', elClansLister, 'clan_' + clanID32, { group: 'clans'} );
			elItem.BLoadLayoutSnippet( 'snippet-clan-item' );
			elItem.AddClass( 'clan-item' );
			elItem.SetDialogVariable( 'clan-name', clanName );
			elItem.SetPanelEvent( 'onactivate', function ( clanChallengeKey )
			{
				$( "#submit" ).enabled = true;
				m_key = clanChallengeKey;

			}.bind( this, clanChallengeKey ) );
			
			if ( clanChallengeKey == m_key )
			{
				elItem.checked = true;
			}

			var elAvatar = elItem.FindChildTraverse( "id-clan__avatar" );
			elAvatar.PopulateFromSteamID( FriendsListAPI.GetClanInfoById32Bit( clanID32, 'steamid' ) );
		}

		$.GetContextPanel().SetFocus();
	}

	function _Submit()
	{
		$.DispatchEvent( 'DirectChallenge_ClanChallengeKeySelected', m_key );
		_Close();
	}


	function _Cancel ()
	{
		_Close();
	}

	function _Close ()
	{
		$.DispatchEvent( 'UIPopupButtonClicked', '' );
	}

	function _Create()
	{
		SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser( "https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/actions/GroupCreate" );
	}

	return {
		Init: _Init,
		Submit: _Submit,
		Close: _Close,
		Cancel: _Cancel,
		Create: _Create,
	};

} )();

                                                                                                    
                                            
                                                                                                    
( function ()
{
  	                                                                                                                  
} )();