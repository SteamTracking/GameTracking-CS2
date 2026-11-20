// MHasKV3TransferPolymorphicClassname
class C_OP_MovementPlaceOnGround : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "offset"
	CPerParticleFloatInput m_flOffset;
	// MPropertyFriendlyName = "max trace length"
	float32 m_flMaxTraceLength; // = 128
	// MPropertyFriendlyName = "CP movement tolerance"
	float32 m_flTolerance; // = 32
	// MPropertyFriendlyName = "trace direction"
	CPerParticleVecInput m_vecTraceDir; // = { "m_vLiteralValue": [ 0, 0, -1 ] }
	// MPropertyFriendlyName = "trace offset"
	float32 m_flTraceOffset; // = 64
	// MPropertyFriendlyName = "interpolation rate"
	float32 m_flLerpRate;
	// MPropertyFriendlyName = "collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "reference CP 1"
	int32 m_nRefCP1; // = -1
	// MPropertyFriendlyName = "reference CP 2"
	int32 m_nRefCP2; // = -1
	// MPropertyFriendlyName = "interploation distance tolerance cp"
	int32 m_nLerpCP; // = -1
	// MPropertyFriendlyName = "No Collision Behavior"
	ParticleTraceMissBehavior_t m_nTraceMissBehavior; // = "PARTICLE_TRACE_MISS_BEHAVIOR_TRACE_END"
	// MPropertyFriendlyName = "include default contents trace hulls"
	bool m_bIncludeShotHull; // = true
	// MPropertyFriendlyName = "include water"
	bool m_bIncludeWater;
	// MPropertyFriendlyName = "set normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "treat offset as scalar of particle radius"
	bool m_bScaleOffset;
	// MPropertyFriendlyName = "preserve initial Z-offset relative to cp"
	int32 m_nPreserveOffsetCP; // = -1
	// MPropertyFriendlyName = "CP Entity to Ignore for Collisions"
	int32 m_nIgnoreCP; // = -1
};
