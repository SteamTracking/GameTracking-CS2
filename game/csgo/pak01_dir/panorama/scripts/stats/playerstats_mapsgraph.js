// playerstats_mapsgraph.js
// 
// 

"use strict"; 

var MapSpiderGraph = ( function ()
{
	function _Init() 
	{
	}

	return {
		Init 					: _Init
	 };
})();

//--------------------------------------------------------------------------------------------------
// Entry point called when panel is created
//--------------------------------------------------------------------------------------------------
(function()
{
	MapSpiderGraph.Init();
	//$.RegisterForUnhandledEvent( "EvtName", MapSpiderGraph.EvtHook );
	//$.RegisterEventHandler( "EvtName", $.GetContextPanel(), Chat.EvtHook );

})();
