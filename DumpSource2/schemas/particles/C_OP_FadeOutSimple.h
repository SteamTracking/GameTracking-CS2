// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_FadeOutSimple : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "proportional fade out time"
	float32 m_flFadeOutTime; // = 0.25
	// MPropertyFriendlyName = "alpha field"
	// MPropertyAttributeChoiceName = "particlefield_alpha"
	ParticleAttributeIndex_t m_nFieldOutput; // = 7
};
