// MHasKV3TransferPolymorphicClassname
class C_OP_GameDecalRenderer : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "decal name"
	// MPropertyAttributeEditor = "VDataChoice( scripts/decalgroups.vdata )"
	CGlobalSymbol m_sDecalGroupName;
	// MPropertyFriendlyName = "event type"
	EventTypeSelection_t m_nEventType; // = "PARTICLE_EVENT_TYPE_MASK_COLLISION"
	// MPropertyFriendlyName = "Collision Interaction Mask"
	ParticleCollisionMask_t m_nInteractionMask; // = "PARTICLE_MASK_SOLID"
	// MPropertyFriendlyName = "Collision Group"
	ParticleCollisionGroup_t m_nCollisionGroup; // = "PARTICLE_COLLISION_GROUP_DEFAULT"
	// MPropertyFriendlyName = "Trace Start Position"
	CPerParticleVecInput m_vecStartPos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 2 }
	// MPropertyFriendlyName = "Trace End Position"
	CPerParticleVecInput m_vecEndPos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 0 }
	// MPropertyFriendlyName = "Trace Bloat Radius Scale"
	CPerParticleFloatInput m_flTraceBloat; // = { "m_flLiteralValue": 10 }
	// MPropertyFriendlyName = "Decal Size"
	// MPropertySuppressExpr = "m_bUseGameDefaultDecalSize == true"
	CPerParticleFloatInput m_flDecalSize; // = { "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "Decal Group Choice Index"
	// MPropertySuppressExpr = "m_bRandomlySelectDecalInGroup == false"
	CPerParticleFloatInput m_nDecalGroupIndex; // = { "m_nScalarAttribute": 9, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "Decal Rotation"
	// MPropertySuppressExpr = "m_bRandomDecalRotation == true"
	CPerParticleFloatInput m_flDecalRotation; // = { "m_nScalarAttribute": 4, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "Decal Modulation Color"
	CPerParticleVecInput m_vModulationColor; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR" }
	// MPropertyFriendlyName = "Use Game's Default Decal Size"
	bool m_bUseGameDefaultDecalSize;
	// MPropertyFriendlyName = "Randomly Rotate Decal"
	bool m_bRandomDecalRotation; // = true
	// MPropertyFriendlyName = "Randomly Select Decal in Decal Group"
	bool m_bRandomlySelectDecalInGroup; // = true
	// MPropertyFriendlyName = "Dont Apply Decals to Owner"
	bool m_bNoDecalsOnOwner; // = true
	// MPropertyFriendlyName = "Debug Traces"
	bool m_bVisualizeTraces;
};
