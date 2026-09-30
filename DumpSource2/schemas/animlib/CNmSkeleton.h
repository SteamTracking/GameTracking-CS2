class CNmSkeleton
{
	CGlobalSymbol m_ID;
	CUtlLeanVector< CGlobalSymbol > m_boneIDs;
	CUtlVector< int32 > m_parentIndices;
	CUtlVector< CTransform > m_parentSpaceReferencePose;
	CUtlVector< CTransform > m_modelSpaceReferencePose;
	int32 m_numBonesToSampleAtLowLOD;
	bool m_bIsPropSkeleton;
	CUtlLeanVector< NmBoneMaskSetDefinition_t > m_maskDefinitions;
	CUtlLeanVector< CNmSkeleton::SecondarySkeleton_t > m_secondarySkeletons;
	CUtlLeanVector< CNmFloatChannelSet_t > m_floatChannelSets;
	CUtlVector< CNmSkeleton::ContactConfig_t > m_contactConfigs;
	CUtlVector< int32 > m_gameplayRelevantBoneIndices;
	int64 m_nSpecialDependencyHash;
};
