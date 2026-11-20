// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_CurlNoiseForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "noise type"
	ParticleDirectionNoiseType_t m_nNoiseType; // = "PARTICLE_DIR_NOISE_PERLIN"
	// MPropertyFriendlyName = "noise frequency"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecNoiseFreq; // = { "m_vLiteralValue": [ 0.02, 0.02, 0.02 ] }
	// MPropertyFriendlyName = "noise amplitude"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecNoiseScale; // = { "m_vLiteralValue": [ 1000, 1000, 1000 ] }
	// MPropertyFriendlyName = "offset"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecOffset;
	// MPropertyFriendlyName = "offset rate"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecOffsetRate;
	// MPropertyFriendlyName = "worley seed"
	CPerParticleFloatInput m_flWorleySeed;
	// MPropertyFriendlyName = "worley jitter"
	CPerParticleFloatInput m_flWorleyJitter; // = { "m_flLiteralValue": 0.875 }
};
