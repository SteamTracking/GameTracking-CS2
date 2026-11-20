// MHasKV3TransferPolymorphicClassname
class C_OP_RenderLightBeam : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "maximum light count"
	// MPropertyAttributeRange = "1 512"
	uint16 m_nMaxAllowed; // = 32
	// MPropertyFriendlyName = "Color Blend"
	CParticleCollectionVecInput m_vColorBlend; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "Color Blend Type"
	// MPropertySortPriority = 700
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyFriendlyName = "light style"
	// MPropertyAttributeEditor = "VDataChoice( scripts/light_styles.vdata )"
	CUtlString m_strLightStyle;
	// MPropertyFriendlyName = "light style time"
	// MPropertySuppressExpr = "m_strLightStyle == ''"
	CPerParticleFloatInput m_flLightStyleTime; // = { "m_nType": "PF_TYPE_PARTICLE_AGE" }
	// MPropertyFriendlyName = "Lumens Per Meter"
	CParticleCollectionFloatInput m_flBrightnessLumensPerMeter; // = { "m_flLiteralValue": 1000 }
	// MPropertyFriendlyName = "Number Of Lights To Create"
	CParticleCollectionFloatInput m_flNumberOfLightsToCreate; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Shadows"
	// MPropertySuppressExpr = "mod == csgo"
	bool m_bCastShadows;
	// MPropertyFriendlyName = "Dynamic Bounce (RTGI)"
	// MPropertySuppressExpr = "!m_bCastShadows || mod == csgo"
	bool m_bDynamicBounce;
	// MPropertyFriendlyName = "Bounce Scale"
	// MPropertySuppressExpr = "!m_bDynamicBounce"
	CParticleCollectionFloatInput m_flBounceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Skirt"
	CParticleCollectionFloatInput m_flSkirt; // = { "m_flLiteralValue": 0.1 }
	// MPropertyFriendlyName = "Range"
	CParticleCollectionFloatInput m_flRange; // = { "m_flLiteralValue": 512 }
	// MPropertyFriendlyName = "Thickness"
	CParticleCollectionFloatInput m_flThickness; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Inner Cone Angle"
	CParticleCollectionFloatInput m_flInnerConeAngle; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "Outer Cone Angle"
	CParticleCollectionFloatInput m_flOuterConeAngle; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "Cone Angle Offset"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecConeRotationOffset;
	// MPropertyFriendlyName = "fog lighting mode"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	ParticleLightFogLightingMode_t m_nFogLightingMode; // = "PARTICLE_LIGHT_FOG_LIGHTING_MODE_NONE"
	// MPropertyFriendlyName = "fog contribution"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	CParticleCollectionRendererFloatInput m_flFogContribution; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "render filter"
	CPerParticleFloatInput m_flRenderFilter; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "debug orientation"
	bool m_bDebugOrientation;
};
