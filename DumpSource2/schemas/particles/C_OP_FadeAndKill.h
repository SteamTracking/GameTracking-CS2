// MHasKV3TransferPolymorphicClassname
class C_OP_FadeAndKill : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "start fade in time"
	float32 m_flStartFadeInTime;
	// MPropertyFriendlyName = "end fade in time"
	float32 m_flEndFadeInTime; // = 0.5
	// MPropertyFriendlyName = "start fade out time"
	float32 m_flStartFadeOutTime; // = 0.5
	// MPropertyFriendlyName = "end fade out time"
	float32 m_flEndFadeOutTime; // = 1
	// MPropertyFriendlyName = "start alpha"
	float32 m_flStartAlpha; // = 1
	// MPropertyFriendlyName = "end alpha"
	float32 m_flEndAlpha;
	// MPropertyFriendlyName = "force preserving particle order"
	bool m_bForcePreserveParticleOrder;
};
