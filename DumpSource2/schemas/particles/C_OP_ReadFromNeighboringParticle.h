// MHasKV3TransferPolymorphicClassname
class C_OP_ReadFromNeighboringParticle : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "read field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldInput; // = 3
	// MPropertyFriendlyName = "written field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "particle increment amount"
	int32 m_nIncrement; // = 1
	// MPropertyFriendlyName = "maximum distance"
	CPerParticleFloatInput m_DistanceCheck;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
