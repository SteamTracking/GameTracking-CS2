// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToImpactPoint : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point to set"
	int32 m_nCPOut; // = 1
	// MPropertyFriendlyName = "control point to trace from"
	int32 m_nCPIn; // = 1
	// MPropertyFriendlyName = "trace update rate"
	float32 m_flUpdateRate; // = 0.5
	// MPropertyFriendlyName = "max trace length"
	CParticleCollectionFloatInput m_flTraceLength; // = { "m_flLiteralValue": 1024 }
	// MPropertyFriendlyName = "offset start point amount"
	float32 m_flStartOffset;
	// MPropertyFriendlyName = "offset end point amount"
	float32 m_flOffset;
	// MPropertyFriendlyName = "trace direction override"
	// MVectorIsCoordinate
	Vector m_vecTraceDir;
	// MPropertyFriendlyName = "trace collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "set to trace endpoint if no collision"
	bool m_bSetToEndpoint;
	// MPropertyFriendlyName = "trace to closest surface along all cardinal directions"
	bool m_bTraceToClosestSurface;
	// MPropertyFriendlyName = "include water"
	bool m_bIncludeWater;
};
