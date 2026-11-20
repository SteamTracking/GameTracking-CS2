// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapTransformOrientationToRotations : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "Transform input"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "Offset pitch/yaw/roll"
	Vector m_vecRotation;
	// MPropertyFriendlyName = "Use quaternions internally"
	bool m_bUseQuat;
	// MPropertyFriendlyName = "Write normal instead of rotation"
	bool m_bWriteNormal;
};
