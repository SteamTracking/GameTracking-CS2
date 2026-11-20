// MHasKV3TransferPolymorphicClassname
class C_OP_RenderCables : public CParticleFunctionRenderer
{
	// MPropertyStartGroup = "Renderer Modifiers"
	// MPropertyFriendlyName = "Radius Scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flRadiusScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "alpha scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flAlphaScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "color blend"
	// MPropertySortPriority = 700
	CParticleCollectionVecInput m_vecColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "color blend type"
	// MPropertySortPriority = 700
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyStartGroup = ""
	// MPropertyFriendlyName = "cable material"
	// MPropertyAttributeEditor = "AssetBrowse( vmat, *extraFilterString=(shader=cables.vfx) )"
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hMaterial;
	// MPropertyFriendlyName = "texture repetition mode"
	TextureRepetitionMode_t m_nTextureRepetitionMode; // = "TEXTURE_REPETITION_PARTICLE"
	// MPropertyFriendlyName = "texture repetitions"
	CParticleCollectionFloatInput m_flTextureRepeatsPerSegment; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "texture repetitions around cable"
	CParticleCollectionFloatInput m_flTextureRepeatsCircumference; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "color map offset along path"
	CParticleCollectionFloatInput m_flColorMapOffsetV;
	// MPropertyFriendlyName = "color map offset around cable"
	CParticleCollectionFloatInput m_flColorMapOffsetU;
	// MPropertyFriendlyName = "normal map offset along path"
	CParticleCollectionFloatInput m_flNormalMapOffsetV;
	// MPropertyFriendlyName = "normal map offset around cable"
	CParticleCollectionFloatInput m_flNormalMapOffsetU;
	// MPropertyFriendlyName = "draw caps at each end of the cable"
	bool m_bDrawCableCaps;
	// MPropertyFriendlyName = "cable end cap shape factor"
	// MPropertyAttributeRange = "0 2"
	float32 m_flCapRoundness; // = 1
	// MPropertyFriendlyName = "cable end cap offset amount"
	// MPropertyAttributeRange = "0 2"
	float32 m_flCapOffsetAmount; // = 1
	// MPropertyFriendlyName = "tessellation scale factor"
	float32 m_flTessScale; // = 1
	// MPropertyFriendlyName = "minimum steps between particles"
	int32 m_nMinTesselation; // = 1
	// MPropertyFriendlyName = "maximum steps between particles"
	int32 m_nMaxTesselation; // = 128
	// MPropertyFriendlyName = "roundness factor"
	// MPropertyAttributeRange = "0 3"
	int32 m_nRoundness; // = 1
	// MPropertyFriendlyName = "force roundness factor fixed"
	bool m_nForceRoundnessFixed;
	// MPropertyFriendlyName = "Only Render in effects bloom pass"
	// MPropertySortPriority = 1100
	bool m_bOnlyRenderInEffectsBloomPass;
	// MPropertyFriendlyName = "diffuse lighting origin"
	// MParticleInputOptional
	CParticleTransformInput m_LightingTransform; // = { "m_nType": "PT_TYPE_INVALID" }
	// MPropertyFriendlyName = "material float variables"
	CUtlLeanVector< FloatInputMaterialVariable_t > m_MaterialFloatVars;
	// MPropertyFriendlyName = "material vector variables"
	CUtlLeanVector< VecInputMaterialVariable_t > m_MaterialVecVars;
};
