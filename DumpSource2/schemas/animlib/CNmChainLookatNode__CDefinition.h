// MHasKV3TransferPolymorphicClassname
class CNmChainLookatNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	CGlobalSymbol m_endEffectorBoneID;
	Vector m_endEffectorForwardAxis; // = [ 1, 0, 0 ]
	Vector m_endEffectorOffset; // = [ 1, 0, 0 ]
	int16 m_nLookatTargetNodeIdx; // = -1
	int16 m_nEnabledNodeIdx; // = -1
	float32 m_flBlendTimeSeconds;
	CUtlVectorFixedGrowable< float32, 5 > m_chainWeights;
	uint8 m_nChainLength; // = 2
	bool m_bIsTargetInWorldSpace;
};
