// MHasKV3TransferPolymorphicClassname
class CNmParameterizedBlendNode::CDefinition : public CNmPoseNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_sourceNodeIndices;
	int16 m_nInputParameterValueNodeIdx; // = -1
	bool m_bAllowLooping; // = true
};
