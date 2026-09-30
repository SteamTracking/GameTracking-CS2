// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomVector : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "min"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecMin;
	// MPropertyFriendlyName = "max"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecMax;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters; // = { "m_bDistributeEvenly": false, "m_nSeed": -1 }
};
