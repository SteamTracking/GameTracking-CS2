// MHasKV3TransferPolymorphicClassname
class C_INIT_DistanceToCPInit : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "distance minimum"
	CPerParticleFloatInput m_flInputMin;
	// MPropertyFriendlyName = "distance maximum"
	CPerParticleFloatInput m_flInputMax; // = { "m_flLiteralValue": 128 }
	// MPropertyFriendlyName = "output minimum"
	CPerParticleFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CPerParticleFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "control point"
	int32 m_nStartCP;
	// MPropertyFriendlyName = "ensure line of sight"
	bool m_bLOS;
	// MPropertyFriendlyName = "LOS collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "Maximum Trace Length"
	CPerParticleFloatInput m_flMaxTraceLength; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "LOS Failure Scalar"
	float32 m_flLOSScale;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "only active within specified distance"
	bool m_bActiveRange;
	// MPropertyFriendlyName = "distance component scale"
	Vector m_vecDistanceScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "remap bias"
	float32 m_flRemapBias; // = 0.5
};
