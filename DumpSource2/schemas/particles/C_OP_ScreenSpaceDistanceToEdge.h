// MHasKV3TransferPolymorphicClassname
class C_OP_ScreenSpaceDistanceToEdge : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
	// MPropertyFriendlyName = "max distance from edge"
	CPerParticleFloatInput m_flMaxDistFromEdge; // = { "m_flLiteralValue": 10 }
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
