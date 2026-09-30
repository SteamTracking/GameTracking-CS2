// MHasKV3TransferPolymorphicClassname
class CNmTwoBoneIKNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	CGlobalSymbol m_effectorBoneID;
	int16 m_nEffectorTargetNodeIdx; // = -1
	int16 m_nEnabledNodeIdx; // = -1
	float32 m_flBlendTimeSeconds;
	NmIKBlendMode_t m_blendMode; // = "Effector"
	bool m_bIsTargetInWorldSpace;
	float32 m_flChainRotationWeight;
};
