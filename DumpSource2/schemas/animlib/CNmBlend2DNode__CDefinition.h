// MHasKV3TransferPolymorphicClassname
class CNmBlend2DNode::CDefinition : public CNmPoseNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_sourceNodeIndices;
	CUtlLeanVectorFixedGrowable< Vector2D, 10 > m_values;
	CUtlLeanVectorFixedGrowable< uint8, 30 > m_indices;
	CUtlLeanVectorFixedGrowable< uint8, 10 > m_hullIndices;
	int16 m_nInputParameterNodeIdx0; // = -1
	int16 m_nInputParameterNodeIdx1; // = -1
	bool m_bAllowLooping; // = true
};
