// MHasKV3TransferPolymorphicClassname
class C_OP_PerParticleForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "force scale"
	CPerParticleFloatInput m_flForceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "force to apply"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vForce;
	// MPropertyFriendlyName = "local space control point"
	int32 m_nCP; // = -1
};
