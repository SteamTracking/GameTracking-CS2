// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_RtEnvCull : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "test direction"
	// MVectorIsCoordinate
	Vector m_vecTestDir; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "cull normal"
	// MVectorIsCoordinate
	Vector m_vecTestNormal;
	// MPropertyFriendlyName = "use velocity for test direction"
	bool m_bUseVelocity;
	// MPropertyFriendlyName = "cull on miss"
	bool m_bCullOnMiss;
	// MPropertyFriendlyName = "velocity test adjust lifespan"
	bool m_bLifeAdjust;
	// MPropertyFriendlyName = "ray trace environment name"
	char[128] m_RtEnvName; // = "PRECIPITATION"
	// MPropertyFriendlyName = "ray trace environment cp"
	int32 m_nRTEnvCP; // = -1
	// MPropertyFriendlyName = "rt env control point component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nComponent;
};
