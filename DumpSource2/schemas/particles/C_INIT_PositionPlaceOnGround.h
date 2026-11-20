// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_PositionPlaceOnGround : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "offset"
	CPerParticleFloatInput m_flOffset;
	// MPropertyFriendlyName = "max trace length"
	CPerParticleFloatInput m_flMaxTraceLength; // = { "m_flLiteralValue": 128 }
	// MPropertyFriendlyName = "trace direction"
	CPerParticleVecInput m_vecTraceDir; // = { "m_vLiteralValue": [ 0, 0, -1 ] }
	// MPropertyFriendlyName = "collision group"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "No Collision Behavior"
	ParticleTraceMissBehavior_t m_nTraceMissBehavior; // = "PARTICLE_TRACE_MISS_BEHAVIOR_TRACE_END"
	// MPropertyFriendlyName = "include water"
	// MPropertySuppressExpr = "m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	bool m_bIncludeWater;
	// MPropertyFriendlyName = "Attribute to Set"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nAttribute;
	// MPropertyFriendlyName = "set Previous XYZ only"
	// MPropertySuppressExpr = "m_nAttribute != PARTICLE_ATTRIBUTE_XYZ"
	bool m_bSetPXYZOnly;
	// MPropertyFriendlyName = "set attribute from ground normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "Attribute to Set to Ground Normal"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	// MPropertySuppressExpr = "!m_bSetNormal"
	ParticleAttributeIndex_t m_nGroundNormalAttribute; // = 21
	// MPropertyFriendlyName = "Offset only if trace hit"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	bool m_bOffsetonColOnly;
	// MPropertyFriendlyName = "offset final position by this fraction of the particle radius"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	float32 m_flOffsetByRadiusFactor;
	// MPropertyFriendlyName = "preserve initial Z-offset relative to cp"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	int32 m_nPreserveOffsetCP; // = -1
	// MPropertyFriendlyName = "CP Entity to Ignore for Collisions"
	// MPropertySuppressExpr = "is_gpu_particle_system || m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	int32 m_nIgnoreCP; // = -1
};
