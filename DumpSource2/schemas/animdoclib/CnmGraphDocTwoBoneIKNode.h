// MHasKV3TransferPolymorphicClassname
class CnmGraphDocTwoBoneIKNode : public CNmGraphDocVariationDataNode
{
	bool m_bIsTargetInWorldSpace;
	NmIKBlendMode_t m_blendMode; // = "Effector"
	// MPropertyDescription = "ChainRotationWeight - this controls how we solve for effector rotations, 0.0f will try to fully rotate the effector, 1.0f will try to solve the rotation by rotating the IK chain"
	float32 m_flChainRotationWeight;
};
