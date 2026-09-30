// MHasKV3TransferPolymorphicClassname
class CRagdollComponentUpdater : public CAnimComponentUpdater
{
	CUtlVector< CAnimNodePath > m_ragdollNodePaths;
	CUtlVector< CAnimNodePath > m_followAttachmentNodePaths;
	CUtlVector< int32 > m_boneIndices;
	CUtlVector< CUtlString > m_boneNames;
	CUtlVector< WeightList > m_weightLists;
	CUtlVector< int32 > m_boneToWeightIndices;
	float32 m_flSpringFrequencyMin;
	float32 m_flSpringFrequencyMax; // = 15
	float32 m_flMaxStretch; // = 56
	bool m_bSolidCollisionAtZeroWeight;
};
