// MObsoleteParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_RenderLights : public C_OP_RenderPoints
{
	// MPropertyFriendlyName = "animation rate"
	float32 m_flAnimationRate; // = 0.1
	// MPropertyFriendlyName = "animation type"
	AnimationType_t m_nAnimationType; // = "ANIMATION_TYPE_FIXED_RATE"
	// MPropertyFriendlyName = "set animation value in FPS"
	bool m_bAnimateInFPS;
	// MPropertyFriendlyName = "minimum visual size"
	float32 m_flMinSize;
	// MPropertyFriendlyName = "maximum visual size"
	float32 m_flMaxSize; // = 5000
	// MPropertyFriendlyName = "size at which to start fading"
	float32 m_flStartFadeSize; // = 100000000
	// MPropertyFriendlyName = "size at which to fade away"
	float32 m_flEndFadeSize; // = 200000000
};
