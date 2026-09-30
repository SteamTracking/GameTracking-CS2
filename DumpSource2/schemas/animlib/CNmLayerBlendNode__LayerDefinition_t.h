class CNmLayerBlendNode::LayerDefinition_t
{
	int16 m_nInputNodeIdx; // = -1
	int16 m_nWeightValueNodeIdx; // = -1
	int16 m_nBoneMaskValueNodeIdx; // = -1
	int16 m_nRootMotionWeightValueNodeIdx; // = -1
	bool m_bIsSynchronized;
	bool m_bIgnoreEvents;
	bool m_bIsStateMachineLayer;
	NmPoseBlendMode_t m_blendMode; // = "Overlay"
};
