// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_FadeInSimple : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "proportional fade in time"
	float32 m_flFadeInTime; // = 0.25
	// MPropertyFriendlyName = "alpha field"
	// MPropertyAttributeChoiceName = "particlefield_alpha"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
};
