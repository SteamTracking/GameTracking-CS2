// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_VelocityFromNormal : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "random speed min"
	float32 m_fSpeedMin;
	// MPropertyFriendlyName = "random speed max"
	float32 m_fSpeedMax;
	// MPropertyFriendlyName = "ignore delta time"
	bool m_bIgnoreDt;
};
