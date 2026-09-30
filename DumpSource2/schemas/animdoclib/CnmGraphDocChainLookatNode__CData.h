// MHasKV3TransferPolymorphicClassname
class CnmGraphDocChainLookatNode::CData : public CNmGraphDocVariationDataNode::CData
{
	CUtlString m_endEffectorBoneName;
	// MPropertyDescription = "The axis that you want to point at the target"
	Vector m_endEffectorForwardAxis;
	// MPropertyDescription = "Add an additional local space offset to the end effector to use for aiming the lookat"
	Vector m_endEffectorOffset;
	// MPropertyDescription = "The length of the IK chain"
	// MPropertyAttributeRange = "2 7"
	uint8 m_nChainLength; // = 2
	// MPropertyDescription = "How long should the blend in/out take"
	float32 m_flBlendTimeSeconds;
	// MPropertyAutoExpandSelf
	// MPropertyDescription = "The weights from the tip of the chain to the base. 0 is the effector/tip of the chain weight, N is the base of the chain."
	CUtlVector< float32 > m_chainWeights;
};
