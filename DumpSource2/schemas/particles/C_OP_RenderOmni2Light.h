// MHasKV3TransferPolymorphicClassname
class C_OP_RenderOmni2Light : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "Type"
	ParticleOmni2LightTypeChoiceList_t m_nLightType; // = "PARTICLE_OMNI2_LIGHT_TYPE_POINT"
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
	// MPropertySortPriority = 700
	CUtlString m_strLightStyle;
	// MPropertyFriendlyName = "light style time"
	// MPropertySuppressExpr = "m_strLightStyle == ''"
	CPerParticleFloatInput m_flLightStyleTime; // = { "m_nType": "PF_TYPE_PARTICLE_AGE" }
	ParticleLightUnitChoiceList_t m_nBrightnessUnit; // = "PARTICLE_LIGHT_UNIT_LUMENS"
	// MPropertyFriendlyName = "Lumens"
	// MPropertySuppressExpr = "m_nBrightnessUnit != PARTICLE_LIGHT_UNIT_LUMENS"
	CPerParticleFloatInput m_flBrightnessLumens; // = { "m_flLiteralValue": 1000 }
	// MPropertyFriendlyName = "Candelas"
	// MPropertySuppressExpr = "m_nBrightnessUnit != PARTICLE_LIGHT_UNIT_CANDELAS"
	CPerParticleFloatInput m_flBrightnessCandelas; // = { "m_flLiteralValue": 1000 }
	// MPropertyFriendlyName = "Shadows"
	// MPropertySuppressExpr = "mod == csgo"
	bool m_bCastShadows;
	// MPropertyFriendlyName = "Dynamic Bounce (RTGI)"
	// MPropertySuppressExpr = "!m_bCastShadows || mod == csgo"
	bool m_bDynamicBounce;
	// MPropertyFriendlyName = "bounce scale"
	// MPropertySuppressExpr = "!m_bDynamicBounce"
	CParticleCollectionFloatInput m_flBounceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Fog"
	bool m_bFog;
	// MPropertyFriendlyName = "Fog Scale"
	// MPropertySuppressExpr = "!m_bFog"
	CPerParticleFloatInput m_flFogScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Light Radius"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_SPHERE"
	CPerParticleFloatInput m_flLuminaireRadius; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Light Orientation Type"
	ParticleOmni2LighOrientationChoiceList_t m_nOrientationType; // = "PARTICLE_OMNI2_LIGHT_ORIENTATION_ROTATIONS"
	// MPropertyFriendlyName = "Normal Vector"
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_OMNI2_LIGHT_ORIENTATION_NORMAL && m_nOrientationType != PARTICLE_OMNI2_LIGHT_ORIENTATION_NORMAL_ROLL"
	CPerParticleVecInput m_vNormal; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 21 }
	// MPropertyFriendlyName = "Target"
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_OMNI2_LIGHT_ORIENTATION_TARGET && m_nOrientationType != PARTICLE_OMNI2_LIGHT_ORIENTATION_TARGET_ROLL"
	CPerParticleVecInput m_vTarget;
	// MPropertyFriendlyName = "Barn FOV Angle"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flFOVAngle; // = { "m_flLiteralValue": 30 }
	// MPropertyFriendlyName = "Aperture Shape"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flBarnShape; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Aperture Near Size X"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flBarnNearSizeX; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Aperture Near Size Y"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flBarnNearSizeY; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Aperture Softness X"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flBarnSoftX; // = { "m_flLiteralValue": 0.25 }
	// MPropertyFriendlyName = "Aperture Softness Y"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flBarnSoftY; // = { "m_flLiteralValue": 0.25 }
	// MPropertyFriendlyName = "Skirt (far falloff)"
	CPerParticleFloatInput m_flSkirt; // = { "m_flLiteralValue": 0.1 }
	// MPropertyFriendlyName = "Range"
	CPerParticleFloatInput m_flRange; // = { "m_flLiteralValue": 512 }
	// MPropertyFriendlyName = "Inner Cone Angle"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flInnerConeAngle; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "Outer Cone Angle"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	CPerParticleFloatInput m_flOuterConeAngle; // = { "m_flLiteralValue": 180 }
	// MPropertyFriendlyName = "Cookie"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hLightCookie;
	// MPropertyFriendlyName = "Cookie is Spherically Mapped"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_OMNI2_LIGHT_TYPE_BARN"
	bool m_bSphericalCookie; // = true
};
