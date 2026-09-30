// MHasKV3TransferPolymorphicClassname
class CNmTargetSelectorNode::CDefinition : public CNmClipReferenceNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 8 > m_optionNodeIndices;
	float32 m_flOrientationScoreWeight; // = 1
	float32 m_flPositionScoreWeight; // = 1
	int16 m_parameterNodeIdx; // = -1
	bool m_bIgnoreInvalidOptions;
	bool m_bIsWorldSpaceTarget; // = true
	CGlobalSymbol m_alignmentBoneID;
};
