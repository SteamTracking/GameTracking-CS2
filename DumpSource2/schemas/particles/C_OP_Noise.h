// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_Noise : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "noise coordinate scale"
	float32 m_fl4NoiseScale; // = 0.1
	// MPropertyFriendlyName = "additive"
	bool m_bAdditive;
	// MPropertyFriendlyName = "Noise animation time scale"
	float32 m_flNoiseAnimationTimeScale;
};
