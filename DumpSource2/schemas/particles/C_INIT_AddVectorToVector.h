// MHasKV3TransferPolymorphicClassname
class C_INIT_AddVectorToVector : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "component scale factor"
	Vector m_vecScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "input field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "random offset min"
	Vector m_vOffsetMin;
	// MPropertyFriendlyName = "random offset max"
	Vector m_vOffsetMax;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters; // = { "m_bDistributeEvenly": false, "m_nSeed": -1 }
};
