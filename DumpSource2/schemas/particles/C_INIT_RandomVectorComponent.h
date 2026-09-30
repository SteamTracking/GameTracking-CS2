// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomVectorComponent : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "min"
	float32 m_flMin;
	// MPropertyFriendlyName = "max"
	float32 m_flMax;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "component 0/1/2 X/Y/Z"
	// MPropertyAttributeChoiceName = "vector_component"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	int32 m_nComponent;
};
