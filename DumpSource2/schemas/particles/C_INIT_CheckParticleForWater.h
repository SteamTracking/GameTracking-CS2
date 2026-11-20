// MHasKV3TransferPolymorphicClassname
class C_INIT_CheckParticleForWater : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "radius"
	CPerParticleFloatInput m_flRadius; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "output attribute"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 1
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
