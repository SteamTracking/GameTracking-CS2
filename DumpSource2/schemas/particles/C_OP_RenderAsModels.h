// MHasKV3TransferPolymorphicClassname
class C_OP_RenderAsModels : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "models"
	// MParticleRequireDefaultArrayEntry
	CUtlVector< ModelReference_t > m_ModelList;
	// MPropertyFriendlyName = "scale factor for radius"
	float32 m_flModelScale; // = 1
	// MPropertyFriendlyName = "scale model to match particle size"
	bool m_bFitToModelSize; // = true
	// MPropertyFriendlyName = "non-uniform scaling"
	bool m_bNonUniformScaling;
	// MPropertyFriendlyName = "X axis scaling scalar field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nXAxisScalingAttribute; // = 18
	// MPropertyFriendlyName = "Y axis scaling scalar field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nYAxisScalingAttribute; // = 18
	// MPropertyFriendlyName = "Z axis scaling scalar field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nZAxisScalingAttribute; // = 18
	// MPropertyFriendlyName = "model size cull bloat"
	// MPropertyAttributeChoiceName = "particlefield_size_cull_bloat"
	int32 m_nSizeCullBloat;
};
