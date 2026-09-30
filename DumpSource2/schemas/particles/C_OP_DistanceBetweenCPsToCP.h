// MHasKV3TransferPolymorphicClassname
class C_OP_DistanceBetweenCPsToCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "starting control point"
	int32 m_nStartCP;
	// MPropertyFriendlyName = "ending control point"
	int32 m_nEndCP; // = 1
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputCP; // = 2
	// MPropertyFriendlyName = "output control point field"
	int32 m_nOutputCPField;
	// MPropertyFriendlyName = "only set distance once"
	bool m_bSetOnce;
	// MPropertyFriendlyName = "distance minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "distance maximum"
	float32 m_flInputMax; // = 128
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "maximum trace length"
	float32 m_flMaxTraceLength; // = -1
	// MPropertyFriendlyName = "LOS Failure Scale"
	float32 m_flLOSScale;
	// MPropertyFriendlyName = "ensure line of sight"
	bool m_bLOS;
	// MPropertyFriendlyName = "LOS collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "set parent"
	ParticleParentSetMode_t m_nSetParent; // = "PARTICLE_SET_PARENT_NO"
};
