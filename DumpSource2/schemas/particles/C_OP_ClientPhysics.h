// MHasKV3TransferPolymorphicClassname
class C_OP_ClientPhysics : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "client physics type"
	// MPropertyAttributeEditor = "VDataChoice( scripts/misc.vdata!generic_physics_particle_spawner )"
	CUtlString m_strPhysicsType;
	// MPropertyFriendlyName = "start all physics asleep"
	bool m_bStartAsleep;
	// MPropertyFriendlyName = "Player Wake Radius"
	CParticleCollectionFloatInput m_flPlayerWakeRadius; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Vehicle Wake Radius"
	CParticleCollectionFloatInput m_flVehicleWakeRadius; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "use high quality simulation"
	bool m_bUseHighQualitySimulation;
	// MPropertyFriendlyName = "max particle count"
	int32 m_nMaxParticleCount; // = 25000
	// MPropertyFriendlyName = "prevent spawning in exclusion volumes"
	// MPropertySuppressExpr = "m_bKillParticles == true"
	bool m_bRespectExclusionVolumes;
	// MPropertyFriendlyName = "kill physics particles"
	bool m_bKillParticles; // = true
	// MPropertyFriendlyName = "delete physics sim when stopped"
	// MPropertySuppressExpr = "m_bKillParticles == false"
	bool m_bDeleteSim;
	// MPropertyFriendlyName = "control point (for finding nearest sim)"
	// MPropertySuppressExpr = "m_bKillParticles == true"
	int32 m_nControlPoint;
	// MPropertyFriendlyName = "specific sim id"
	// MPropertySuppressExpr = "m_bKillParticles == true"
	int32 m_nForcedSimId; // = -1
	// MPropertyFriendlyName = "tint blend (color vs prop group gradient)"
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyFriendlyName = "forced status effect flags"
	ParticleAttrBoxFlags_t m_nForcedStatusEffects;
	// MPropertyFriendlyName = "Disable Non-Static Collision Duration"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "m_nForcedStatusEffects == 0"
	ParticleAttributeIndex_t m_nNoCollisionAttribute; // = 18
	// MPropertyFriendlyName = "Zero Gravity Duration"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "m_nForcedStatusEffects == 0"
	ParticleAttributeIndex_t m_nZeroGravityAttribute; // = 26
};
