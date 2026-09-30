// MHasKV3TransferPolymorphicClassname
class C_OP_FadeOut : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "fade out time min"
	float32 m_flFadeOutTimeMin; // = 0.25
	// MPropertyFriendlyName = "fade out time max"
	float32 m_flFadeOutTimeMax; // = 0.25
	// MPropertyFriendlyName = "fade out time exponent"
	float32 m_flFadeOutTimeExp; // = 1
	// MPropertyFriendlyName = "fade bias"
	float32 m_flFadeBias; // = 0.5
	// MPropertyFriendlyName = "proportional 0/1"
	bool m_bProportional; // = true
	// MPropertyFriendlyName = "ease in and out"
	bool m_bEaseInAndOut; // = true
};
