// MHasKV3TransferPolymorphicClassname
class C_INIT_CreationNoise : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "absolute value"
	bool m_bAbsVal;
	// MPropertyFriendlyName = "invert absolute value"
	bool m_bAbsValInv;
	// MPropertyFriendlyName = "time coordinate offset"
	float32 m_flOffset;
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "time noise coordinate scale"
	float32 m_flNoiseScale; // = 0.1
	// MPropertyFriendlyName = "spatial noise coordinate scale"
	float32 m_flNoiseScaleLoc; // = 0.001
	// MPropertyFriendlyName = "spatial coordinate offset"
	// MVectorIsCoordinate
	Vector m_vecOffsetLoc;
	// MPropertyFriendlyName = "world time noise coordinate scale"
	float32 m_flWorldTimeScale;
};
