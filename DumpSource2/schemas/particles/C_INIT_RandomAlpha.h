// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomAlpha : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "alpha field"
	// MPropertyAttributeChoiceName = "particlefield_alpha"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
	// MPropertyFriendlyName = "alpha min"
	// MPropertyAttributeRange = "0 255"
	int32 m_nAlphaMin; // = 255
	// MPropertyFriendlyName = "alpha max"
	// MPropertyAttributeRange = "0 255"
	int32 m_nAlphaMax; // = 255
	// MPropertyFriendlyName = "alpha random exponent"
	float32 m_flAlphaRandExponent; // = 1
};
