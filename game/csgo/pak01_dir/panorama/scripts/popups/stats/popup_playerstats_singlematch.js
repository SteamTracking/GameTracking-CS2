'use strict';

var singlematch = ( function()
{
	var _m_matchId;
	var _m_sToken;

	var _m_EventHandle;

	function _Appear ()
	{
		_m_matchId = $.GetContextPanel().GetAttributeString( 'matchid', '' );

		_m_EventHandle = $.RegisterForUnhandledEvent( 'PanoramaComponent_MatchInfo_StateChange', _OnMatchReadyForDisplay );

		$.GetContextPanel().AddClass( 'reveal' );

		  
		                                   
		  
		let sState = MatchListAPI.GetState( 'downloaded' );
		if ( sState !== 'ready' ) 
		{
			MatchListAPI.Refresh( 'downloaded' );
		}

		_m_sToken = MatchListAPI.FindMatchByID( 'downloaded', _m_matchId );
		if ( !_m_sToken )
		{	                                                                      
			_m_sToken = MatchListAPI.FindMatchByID( 'inmemory', _m_matchId );
		}

		  
		                                                              
		  
		if ( _m_sToken )
		{
			var elMatchInfo = $.GetContextPanel().FindChildTraverse( 'MatchInfo' );
			_PopulateMatchInfo( elMatchInfo );
		}
		else
		{
			MatchInfoAPI.DownloadWithShareToken( 'MATCH-' + _m_matchId );
		}

	}

	function _OnMatchReadyForDisplay ( )
	{
		_m_sToken = MatchListAPI.FindMatchByID( 'inmemory', _m_matchId );
    if ( !_m_sToken )
    {
      return;
    }

		var elMatchInfo = $.GetContextPanel().FindChildTraverse( 'MatchInfo' );
		_PopulateMatchInfo( elMatchInfo );

	}

	function _Dismiss ()
	{
		$.GetContextPanel().RemoveClass( 'reveal' );
		$.Schedule( 0.1, _ => UiToolkitAPI.CloseAllVisiblePopups() );
		$.UnregisterForUnhandledEvent( 'PanoramaComponent_MatchInfo_StateChange', _m_EventHandle );

	}

    function _PopulateMatchInfo( parentPanel )
    {
		var activeMatchInfoPanel = $.GetContextPanel().FindChildTraverse( 'MatchInfo' );

		activeMatchInfoPanel.matchId = _m_sToken;
		activeMatchInfoPanel.matchListDescriptor = _m_matchId;
		activeMatchInfoPanel.BLoadLayout( "file://{resources}/layout/matchinfo.xml", true, false );

		matchInfo.Init( activeMatchInfoPanel );

		var elSpinner = $.GetContextPanel().FindChildTraverse( 'PageSpinner' );
		elSpinner.visible = false;
		
    }


		                      
	return {

		Appear: 	_Appear,
		Dismiss: 	_Dismiss
	};

} )();
	
                                                                                                    
                                           
                                                                                                    
( function()
{
	                              
} )();
