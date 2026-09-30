// MHasKV3TransferPolymorphicClassname
class C_OP_SetCPOrientationToGroundNormal : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "interpolation rate"
	float32 m_flInterpRate;
	// MPropertyFriendlyName = "max trace length"
	float32 m_flMaxTraceLength; // = 128
	// MPropertyFriendlyName = "CP movement tolerance"
	float32 m_flTolerance; // = 32
	// MPropertyFriendlyName = "trace offset"
	float32 m_flTraceOffset; // = 64
	// MPropertyFriendlyName = "collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "CP to trace from"
	int32 m_nInputCP;
	// MPropertyFriendlyName = "CP to set"
	int32 m_nOutputCP; // = 1
	// MPropertyFriendlyName = "include water"
	bool m_bIncludeWater;
};
