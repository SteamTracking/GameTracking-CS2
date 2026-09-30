// MVDataRoot
// MVDataSingleton
// MPropertyFriendlyName = "Beat Pattern Library"
class CSndBeatPatternManager
{
	// MPropertyFriendlyName = "Patterns"
	// MVDataPromoteField = 0
	CUtlVector< CSndBeatPattern > m_vecPatterns;
	// MPropertyFriendlyName = "Tracks"
	// MVDataPromoteField = 0
	CUtlVector< CSndBeatTrack > m_vecActiveTracks;
};
