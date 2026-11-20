// MHasKV3TransferPolymorphicClassname
class C_OP_RenderSimpleModelCollection : public CParticleFunctionRenderer
{
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "center mesh"
	// MPropertySortPriority = 750
	bool m_bCenterOffset;
	// MPropertyStartGroup = "Model"
	// MPropertyFriendlyName = "model"
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	// MPropertyFriendlyName = "input model override"
	CParticleModelInput m_modelInput;
	// MPropertyStartGroup = "Rendering"
	// MPropertyFriendlyName = "size cull scale"
	CParticleCollectionFloatInput m_fSizeCullScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "disable shadows"
	bool m_bDisableShadows;
	// MPropertyFriendlyName = "disable motion blur"
	bool m_bDisableMotionBlur;
	// MPropertyFriendlyName = "accept decals"
	bool m_bAcceptsDecals; // = true
	// MPropertyFriendlyName = "render filter"
	CPerParticleFloatInput m_fDrawFilter; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "angular velocity attribute (improves motion blur)"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nAngularVelocityField; // = 19
};
