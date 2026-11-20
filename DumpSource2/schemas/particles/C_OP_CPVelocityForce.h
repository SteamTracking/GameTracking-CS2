// MHasKV3TransferPolymorphicClassname
class C_OP_CPVelocityForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "control point"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "velocity scale"
	CPerParticleFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
};
