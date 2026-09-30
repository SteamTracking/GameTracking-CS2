'use strict';


var PlayerStatsLineGraphAvgTooltip = ( function()
{

	function _IsPerRound ( index )
	{
		return index == 0 ||
			index == 1 ||
			index == 2;
	}

	function _isPerDeath ( index )
	{
		return index == 3; 
	}

	function _isPercentage ( index )
	{
		return index == 4;
	}
	
	function _GetUnitSuffix ( index )
	{
		if ( _IsPerRound( index ) )
			return $.Localize('#playerstats_suffix_per_round');
		else if ( _isPerDeath( index ) )
			return "";                                             
		else if ( _isPercentage( index ) )
			return $.Localize('#playerstats_suffix_per_cent');
		
		return '';
	}

	function _Init ()
	{
		var unixtime = Number( $.GetContextPanel().GetAttributeString( "timestamp", "" ) ) * 1000;
		var statvalue = $.GetContextPanel().GetAttributeString( "stat_value", "" );
		var stat_index= $.GetContextPanel().GetAttributeString( "stat_index", "" );

		var date = new Date( unixtime );

		DateUtil.PopulateDateFormatStrings( $.GetContextPanel(), date );

		var statname = $.Localize( "#playerstat_name_" + stat_index );
		$.GetContextPanel().SetDialogVariable( 'statname', statname );
		$.GetContextPanel().SetDialogVariable( 'statvalue', statvalue + _GetUnitSuffix(stat_index) );

	}


	return {
		Init: _Init,
	}


})();

(function()
{
})();