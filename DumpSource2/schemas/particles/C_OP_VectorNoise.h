// MHasKV3TransferPolymorphicClassname
class C_OP_VectorNoise : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 6
	// MPropertyFriendlyName = "output minimum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecOutputMin;
	// MPropertyFriendlyName = "output maximum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vecOutputMax; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "noise coordinate scale"
	float32 m_fl4NoiseScale; // = 0.1
	// MPropertyFriendlyName = "additive"
	bool m_bAdditive;
	// MPropertyFriendlyName = "offset instead of accelerate position"
	bool m_bOffset;
	// MPropertyFriendlyName = "Noise animation time scale"
	float32 m_flNoiseAnimationTimeScale;
};
