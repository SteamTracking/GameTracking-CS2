// MHasKV3TransferPolymorphicClassname
class C_OP_RemapVectorToRotations : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "vector input"
	CPerParticleVecInput m_vecInput; // = { "m_vLiteralValue": [ 1, 0, 0 ] }
	// MPropertyFriendlyName = "offset pitch/yaw/roll"
	CPerParticleVecInput m_vecRotation;
};
