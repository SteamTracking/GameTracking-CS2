// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_VelocityFromCP : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "velocity"
	CParticleCollectionVecInput m_velocityInput; // = { "m_nType": "PVEC_TYPE_CP_VALUE" }
	// MPropertyFriendlyName = "local space"
	// MParticleInputOptional
	CParticleTransformInput m_transformInput; // = { "m_nType": "PT_TYPE_INVALID" }
	// MPropertyFriendlyName = "velocity scale"
	float32 m_flVelocityScale; // = 1
	// MPropertyFriendlyName = "direction only"
	bool m_bDirectionOnly;
};
