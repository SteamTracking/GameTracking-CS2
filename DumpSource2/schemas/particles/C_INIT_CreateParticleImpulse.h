// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateParticleImpulse : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "radius"
	CPerParticleFloatInput m_InputRadius;
	// MPropertyFriendlyName = "magnitude"
	CPerParticleFloatInput m_InputMagnitude;
	// MPropertyFriendlyName = "force falloff function"
	ParticleFalloffFunction_t m_nFalloffFunction; // = "PARTICLE_FALLOFF_LINEAR"
	// MPropertyFriendlyName = "exponential falloff exponent"
	CPerParticleFloatInput m_InputFalloffExp; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "impulse type"
	ParticleImpulseType_t m_nImpulseType; // = "IMPULSE_TYPE_PARTICLE_SYSTEM"
};
