'use strict';

var fakeStats = ( function()
{

	function _randomG(v){ 
		var r = 0;
		for(var i = v; i > 0; i --){
			r += Math.random();
		}
		return r / v;
	}
	
	function _RandomMap ()
	{
		switch ( Math.floor( Math.random() * 7 ) )
		{
			case 0: return 'dust ii';
			case 1: return 'nuke';
			case 2: return 'inferno';
			case 3: return 'aztec';
			case 4: return 'mirage';
			case 5: return 'overpass';
			case 6: return 'vertigo';
		}
	}

	function _RandomScore ()
	{
		return ( Math.floor( Math.random() * 15 ) )
	}


	function _RandomMatch ()
	{
		var win = Math.floor( Math.random() * 3 ) - 1;

		return {
			map: _RandomMap(),
			myScore: win == 1 ? 16 : win == 0 ? 15 : _RandomScore(),
			enemyScore: win == -1 ? 16 : win == 0 ? 15 : _RandomScore(),
			win: win
		}
	}

	function _RandomMatchSeries ()
	{
		var n = Math.ceil( 40 * ( _randomG( 50 ) - 0.5 ) );                                                

		var day = {};

		for ( var m = 0; m < n; m++ )
		{
			day[ m ] = _RandomMatch();
		}

		return day;
	}

	return {

		RandomMatch 	: _RandomMatch,
		RandomMatchSeries: _RandomMatchSeries,
	}


} )();
