// MModelGameData
class CDestructiblePartsSystemData
{
	// MPropertyDescription = "Destructible Parts"
	CUtlOrderedMap< HitGroup_t, CDestructiblePart > m_PartsDataByHitGroup;
	// MPropertyDescription = "Min/Max number parts to destroy when gibbing"
	CRangeInt m_nMinMaxNumberHitGroupsToDestroyWhenGibbing; // = [ 1, 3 ]
};
