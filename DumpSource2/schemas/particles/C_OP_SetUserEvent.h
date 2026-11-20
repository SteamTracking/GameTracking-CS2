// MHasKV3TransferPolymorphicClassname
class C_OP_SetUserEvent : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "input value"
	CPerParticleFloatInput m_flInput;
	// MPropertyFriendlyName = "rising edge value"
	CPerParticleFloatInput m_flRisingEdge;
	// MPropertyFriendlyName = "rising edge event type"
	EventTypeSelection_t m_nRisingEventType; // = "PARTICLE_EVENT_TYPE_MASK_USER_1"
	// MPropertyFriendlyName = "falling edge value"
	CPerParticleFloatInput m_flFallingEdge;
	// MPropertyFriendlyName = "falling edge event type"
	EventTypeSelection_t m_nFallingEventType; // = "PARTICLE_EVENT_TYPE_MASK_NONE"
};
