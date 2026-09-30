// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_InitFromParentKilled : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "field to init"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nAttributeToCopy; // = -1
	// MPropertyFriendlyName = "event type"
	EventTypeSelection_t m_nEventType; // = "PARTICLE_EVENT_TYPE_MASK_KILLED"
};
