// MHasKV3TransferPolymorphicClassname
class CNmParameterizedSelectorNode::CDefinition : public CNmPoseNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 8 > m_optionNodeIndices;
	CUtlLeanVectorFixedGrowable< uint8, 8 > m_optionWeights;
	int16 m_parameterNodeIdx; // = -1
	bool m_bIgnoreInvalidOptions;
	bool m_bHasWeightsSet;
};
