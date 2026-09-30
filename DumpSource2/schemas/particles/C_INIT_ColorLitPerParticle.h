// MHasKV3TransferPolymorphicClassname
class C_INIT_ColorLitPerParticle : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "color1"
	Color m_ColorMin; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "color2"
	Color m_ColorMax; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "tint clamp min"
	Color m_TintMin;
	// MPropertyFriendlyName = "tint clamp max"
	Color m_TintMax; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "light bias"
	float32 m_flTintPerc;
	// MPropertyFriendlyName = "tint blend mode"
	ParticleColorBlendMode_t m_nTintBlendMode; // = "PARTICLEBLEND_DEFAULT"
	// MPropertyFriendlyName = "light amplification amount"
	float32 m_flLightAmplification; // = 1
};
