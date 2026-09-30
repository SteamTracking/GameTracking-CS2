// MHasKV3TransferPolymorphicClassname
class C_INIT_LifespanFromVelocity : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "bias distance"
	// MVectorIsCoordinate
	Vector m_vecComponentScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "trace offset"
	float32 m_flTraceOffset;
	// MPropertyFriendlyName = "maximum trace length"
	float32 m_flMaxTraceLength; // = 1024
	// MPropertyFriendlyName = "trace recycle tolerance"
	float32 m_flTraceTolerance; // = 64
	// MPropertyFriendlyName = "maximum points to cache"
	int32 m_nMaxPlanes; // = 16
	// MPropertyFriendlyName = "trace collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "collide with water"
	bool m_bIncludeWater; // = true
};
