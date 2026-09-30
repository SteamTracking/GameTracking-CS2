// MHasKV3TransferPolymorphicClassname
class CNmFootIKNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	CGlobalSymbol m_leftEffectorBoneID;
	CGlobalSymbol m_rightEffectorBoneID;
	int16 m_nLeftTargetNodeIdx; // = -1
	int16 m_nRightTargetNodeIdx; // = -1
	int16 m_nEnabledNodeIdx; // = -1
	float32 m_flBlendTimeSeconds;
	NmIKBlendMode_t m_blendMode; // = "Effector"
	bool m_bIsTargetInWorldSpace;
};
