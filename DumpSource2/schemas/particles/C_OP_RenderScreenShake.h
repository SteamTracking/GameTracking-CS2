// MHasKV3TransferPolymorphicClassname
class C_OP_RenderScreenShake : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "duration scale"
	float32 m_flDurationScale; // = 1
	// MPropertyFriendlyName = "radius scale"
	float32 m_flRadiusScale; // = 1
	// MPropertyFriendlyName = "frequence scale"
	float32 m_flFrequencyScale; // = 1
	// MPropertyFriendlyName = "amplitude scale"
	float32 m_flAmplitudeScale; // = 1
	// MPropertyFriendlyName = "radius field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nRadiusField; // = 3
	// MPropertyFriendlyName = "duration field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nDurationField; // = 1
	// MPropertyFriendlyName = "frequency field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFrequencyField; // = 16
	// MPropertyFriendlyName = "amplitude field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nAmplitudeField; // = 7
	// MPropertyFriendlyName = "control point of shake recipient (-1 = global)"
	int32 m_nFilterCP;
};
