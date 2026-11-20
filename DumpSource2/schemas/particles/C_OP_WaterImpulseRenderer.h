// MHasKV3TransferPolymorphicClassname
class C_OP_WaterImpulseRenderer : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "impulse position"
	CPerParticleVecInput m_vecPos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 0 }
	// MPropertyFriendlyName = "impulse radius"
	CPerParticleFloatInput m_flRadius; // = { "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "impulse magnitude"
	CPerParticleFloatInput m_flMagnitude; // = { "m_nScalarAttribute": 7, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "impulse wave roundness"
	CPerParticleFloatInput m_flShape; // = { "m_nScalarAttribute": 10, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "impulse wind speed (when wind is true)"
	CPerParticleFloatInput m_flWindSpeed; // = { "m_nScalarAttribute": 26, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "impulse wobble radius"
	CPerParticleFloatInput m_flWobble; // = { "m_nScalarAttribute": 27, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "impulse is wind"
	bool m_bIsRadialWind;
	// MPropertyFriendlyName = "event type"
	EventTypeSelection_t m_nEventType; // = "PARTICLE_EVENT_TYPE_MASK_COLLISION"
};
