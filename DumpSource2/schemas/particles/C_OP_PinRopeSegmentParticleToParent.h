// MHasKV3TransferPolymorphicClassname
class C_OP_PinRopeSegmentParticleToParent : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "particle to use"
	ParticleSelection_t m_nParticleSelection; // = "PARTICLE_SELECTION_FIRST"
	// MPropertyFriendlyName = "particle number/offset"
	CParticleCollectionFloatInput m_nParticleNumber;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
