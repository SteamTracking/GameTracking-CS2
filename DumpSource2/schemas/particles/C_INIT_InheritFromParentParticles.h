// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_InheritFromParentParticles : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "scale"
	float32 m_flScale; // = 1
	// MPropertyFriendlyName = "inherited field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "particle increment amount"
	int32 m_nIncrement; // = 1
	// MPropertyFriendlyName = "random parent particle distribution"
	bool m_bRandomDistribution;
	// MPropertyFriendlyName = "random seed"
	int32 m_nRandomSeed;
};
