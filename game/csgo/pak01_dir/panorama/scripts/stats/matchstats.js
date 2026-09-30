"use strict"; 

var MatchStats = ( function()
{

	                               
	                       
	                          
	                                                                                                                        
	   				                                             			    
	   				                                               			    
	   				                                               			    
	   				                                                  		    
	   				                                                       	                               
	   				                                                		    
	   				                                                 		                              
	   				                                                 		                              
	   				                                             			                              
	   				                                             			                            
	                                
	                                                        
	                                                                                 
	                                   
	                                      
	                                        
	                      	                                                        
	                  		                                                  
	                          
	                                                                                                                                   
	                      
	                      
	                      
	                             
	                                                             
	                                                          
	                                                   
	                                                
	                                                   
	                                                
	                                                
	                                                                     
	                                                                   
	                                        
	                                                                        
	                                                               
	                                 


	function _GetMatchId ( oMatch ) {return oMatch.match_id};

	function _GetTotalRounds ( oMatch ) {return parseInt( oMatch.rounds_won + oMatch.rounds_lost )};
	function _GetTotalDeaths ( oMatch ) {return parseInt(oMatch.stat_deaths )};
	function _GetTotalHEThrown ( oMatch ) {return parseInt(oMatch.utility_count)  };
	function _GetTotalFBThrown ( oMatch ) {return parseInt(oMatch.flash_count) };
	function _GetTotal1v1Engagements( oMatch ) {return parseInt(oMatch.engagements_1v1_count) };
	function _GetTotal1v2Engagements( oMatch ) {return parseInt(oMatch.engagements_1v2_count) };
	function _GetTotalEntries ( oMatch ) {return parseInt(oMatch.engagements_entry_count) };
	function _GetTotalEntryDeaths ( oMatch ) {return parseInt(_GetTotalEntries( oMatch ) - _GetTotalEntryKills( oMatch ))};
	
	function _GetTotalScore ( oMatch ) {return parseInt(oMatch.stat_score )};			
	function _GetScorePerRound ( oMatch ) { return (_GetTotalRounds( oMatch ) == 0 ? _GetTotalScore( oMatch ) : _GetTotalScore( oMatch ) / _GetTotalRounds( oMatch )).toPrecision(3)};
	
	function _GetTotalKills ( oMatch ) {return parseInt(oMatch.enemy_kills )};
	function _GetKillsPerRound ( oMatch ) {return (_GetTotalRounds( oMatch ) == 0 ? _GetTotalKills( oMatch ) : _GetTotalKills( oMatch ) / _GetTotalRounds( oMatch )).toPrecision(3)};		
	
	function _GetTotalDamage ( oMatch ) {return parseInt(oMatch.total_damage ) };	
	function _GetDamagePerRound ( oMatch ) {return _GetTotalRounds( oMatch ) == 0 ? _GetTotalDamage( oMatch ) : (_GetTotalDamage( oMatch ) / _GetTotalRounds( oMatch )).toPrecision(3)};
	
	function _GetKillsPerDeath ( oMatch ) { return (_GetTotalDeaths( oMatch ) == 0 ? _GetTotalKills( oMatch ) : _GetTotalKills( oMatch ) / _GetTotalDeaths( oMatch )).toPrecision(3)};
	
	function _GetTotalMVPs ( oMatch ) {return parseInt(oMatch.stat_mvps )};	
	function _GetMVPsPerRound ( oMatch ) {return (_GetTotalRounds( oMatch ) == 0 ? _GetTotalMVPs( oMatch ) : _GetTotalMVPs( oMatch ) / _GetTotalRounds( oMatch )).toPrecision(3)};
	
	function _GetTotalHeadShotKills ( oMatch ) {return parseInt(oMatch.enemy_headshots )};		
	function _GetHeadShotKillRate ( oMatch ) {return (_GetTotalKills( oMatch ) == 0 ? 0 : (_GetTotalHeadShotKills( oMatch ) / _GetTotalKills( oMatch ) * 100)).toPrecision(3)};	
	
	function _GetTotalHESuccesses ( oMatch ) {return parseInt(oMatch.utility_success )};		
	function _GetHESuccessRate ( oMatch ) { return ((_GetTotalHEThrown(oMatch) == 0 ? 0 : _GetTotalHESuccesses( oMatch ) / _GetTotalHEThrown(oMatch) * 100).toPrecision(3))};		
	
	function _GetTotalFBSuccesses ( oMatch ) {return parseInt(oMatch.flash_success )};	
	function _GetFBSuccessRate ( oMatch ) { return ((_GetTotalFBThrown(oMatch) == 0 ? 0 : _GetTotalFBSuccesses( oMatch ) / _GetTotalFBThrown(oMatch) * 100).toPrecision(3))};		
	
	function _GetTotal2Ks ( oMatch ) {return parseInt(oMatch.enemy_2ks )};
	function _GetTotal3ks ( oMatch ) {return parseInt(oMatch.enemy_3ks )};
	function _GetTotal4Ks ( oMatch ) {return parseInt( oMatch.enemy_4ks )};
	
	function _GetTotalMultiKills( oMatch ) {return _GetTotal2Ks( oMatch ) + _GetTotal3ks( oMatch ) + _GetTotal4Ks( oMatch ) };
	
	function _GetTotal1v1Successes ( oMatch ) {return parseInt(oMatch.engagements_1v1_wins )};
	function _Get1v1SuccessRate ( oMatch ) { return (_GetTotal1v1Engagements(oMatch) == 0 ? 0 : ( _GetTotal1v1Successes( oMatch ) / _GetTotal1v1Engagements(oMatch) * 100)).toPrecision(3)};
	
	function _GetTotal1v2Successes ( oMatch ) {return parseInt(oMatch.engagements_1v2_wins )};		
	function _Get1v2SuccessRate ( oMatch ) { return (_GetTotal1v2Engagements(oMatch) == 0 ? 0 : (_GetTotal1v2Successes( oMatch ) / _GetTotal1v2Engagements(oMatch) * 100)).toPrecision(3)};		
	
	function _GetTotalEntryKills ( oMatch ) {return parseInt( oMatch.engagements_entry_wins  )};	
	function _GetEntryKillsPerDeath( oMatch ){ return ((_GetTotalEntryDeaths(oMatch) == 0 ? _GetTotalEntryKills( oMatch ) : _GetTotalEntryKills( oMatch ) / _GetTotalEntryDeaths( oMatch )).toPrecision(3))};	

	return {
		GetMatchId:					_GetMatchId,

		GetTotalScore:				_GetTotalScore,						
		GetScorePerRound:			_GetScorePerRound,	
			
		GetTotalKills: 				_GetTotalKills,				
		GetKillsPerRound: 			_GetKillsPerRound, 		
			
		GetTotalDamage:				_GetTotalDamage,
		GetDamagePerRound:			_GetDamagePerRound,
		
		GetKillsPerDeath:			_GetKillsPerDeath,	
		
		GetTotalMVPs:				_GetTotalMVPs,	
		GetMVPsPerRound:			_GetMVPsPerRound,
		
		GetTotalHeadShotKills:		_GetTotalHeadShotKills,		
		GetHeadShotKillRate:		_GetHeadShotKillRate,		
		
		GetTotalHESuccesses:		_GetTotalHESuccesses,		
		GetHESuccessRate: 			_GetHESuccessRate,	
		GetTotalHEThrown:			_GetTotalHEThrown,
		
		GetTotalFBSuccesses:		_GetTotalFBSuccesses,		
		GetFBSuccessRate:			_GetFBSuccessRate,	
		GetTotalFBThrown:			_GetTotalFBThrown,

		GetTotal2Ks:				_GetTotal2Ks,
		GetTotal3ks:				_GetTotal3ks,
		GetTotal4Ks:				_GetTotal4Ks,	
		GetTotalMultiKills:			_GetTotalMultiKills,		
		
		GetTotal1v1Successes:		_GetTotal1v1Successes,	
		Get1v1SuccessRate: 			_Get1v1SuccessRate,
		GetTotal1v1Engagements:		_GetTotal1v1Engagements,
		
		GetTotal1v2Successes:		_GetTotal1v2Successes,		
		Get1v2SuccessRate:			_Get1v2SuccessRate,		
		GetTotal1v2Engagements:		_GetTotal1v2Engagements,

		GetTotalEntryKills:			_GetTotalEntryKills,		
		GetEntryKillsPerDeath: 		_GetEntryKillsPerDeath,			
		GetTotalEntryDeaths:		_GetTotalEntryDeaths,
 };
})();

                                                                                                    
                                           
                                                                                                    
(function()
{

})();
