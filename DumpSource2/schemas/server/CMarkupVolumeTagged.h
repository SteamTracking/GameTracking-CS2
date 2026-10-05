// MConstructibleClassBase
class CMarkupVolumeTagged : public CMarkupVolume
{
	CUtlVector< CGlobalSymbol > m_GroupNames;
	CUtlVector< CGlobalSymbol > m_Tags;
	// MNotSaved
	bool m_bIsGroup;
	bool m_bGroupByPrefab;
	bool m_bGroupByVolume;
	bool m_bGroupOtherGroups;
	// MNotSaved
	bool m_bIsInGroup;
};
