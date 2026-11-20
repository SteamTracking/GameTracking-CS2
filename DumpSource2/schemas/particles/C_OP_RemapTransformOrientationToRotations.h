// MHasKV3TransferPolymorphicClassname
class C_OP_RemapTransformOrientationToRotations : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "offset pitch/yaw/roll"
	Vector m_vecRotation;
	// MPropertyFriendlyName = "Use Quaternians Internally"
	bool m_bUseQuat;
	// MPropertyFriendlyName = "Write normal instead of rotation"
	bool m_bWriteNormal;
};
