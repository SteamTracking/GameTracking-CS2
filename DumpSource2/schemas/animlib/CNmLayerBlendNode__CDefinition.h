// MHasKV3TransferPolymorphicClassname
class CNmLayerBlendNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nBaseNodeIdx; // = -1
	bool m_bOnlySampleBaseRootMotion; // = true
	CUtlLeanVectorFixedGrowable< CNmLayerBlendNode::LayerDefinition_t, 3 > m_layerDefinition;
};
