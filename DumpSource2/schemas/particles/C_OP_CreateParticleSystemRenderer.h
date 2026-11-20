// MHasKV3TransferPolymorphicClassname
class C_OP_CreateParticleSystemRenderer : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "effect"
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_hEffect;
	// MPropertyFriendlyName = "event type"
	EventTypeSelection_t m_nEventType; // = "PARTICLE_EVENT_TYPE_MASK_COLLISION"
	// MPropertyFriendlyName = "Control Points"
	CUtlLeanVector< CPAssignment_t > m_vecCPs;
	// MPropertyDescription = "Effect Config"
	// MPropertyAttributeEditor = "ParticleConfigName()"
	// MPropertyEditContextOverrideKey = "ToolEditContext_ID_VPCF"
	// MPropertyFriendlyName = "Particle Config"
	CUtlString m_szParticleConfig;
	// MPropertyFriendlyName = "Aggregation Position"
	CPerParticleVecInput m_AggregationPos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 0 }
};
