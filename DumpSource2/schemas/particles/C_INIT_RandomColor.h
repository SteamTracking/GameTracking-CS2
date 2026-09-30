// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomColor : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "color1"
	Color m_ColorMin; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "color2"
	Color m_ColorMax; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "tint clamp min"
	Color m_TintMin;
	// MPropertyFriendlyName = "tint clamp max"
	Color m_TintMax; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "tint perc"
	float32 m_flTintPerc;
	// MPropertyFriendlyName = "tint update movement threshold"
	float32 m_flUpdateThreshold; // = 32
	// MPropertyFriendlyName = "tint control point"
	int32 m_nTintCP;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 6
	// MPropertyFriendlyName = "tint blend mode"
	ParticleColorBlendMode_t m_nTintBlendMode; // = "PARTICLEBLEND_DEFAULT"
	// MPropertyFriendlyName = "light amplification amount"
	float32 m_flLightAmplification; // = 1
};
