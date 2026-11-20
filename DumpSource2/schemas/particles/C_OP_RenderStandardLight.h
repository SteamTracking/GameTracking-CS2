// MHasKV3TransferPolymorphicClassname
class C_OP_RenderStandardLight : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "light type"
	ParticleLightTypeChoiceList_t m_nLightType; // = "PARTICLE_LIGHT_TYPE_POINT"
	// MPropertyFriendlyName = "maximum light count"
	// MPropertyAttributeRange = "1 512"
	uint16 m_nMaxAllowed; // = 32
	// MPropertyFriendlyName = "color blend"
	CParticleCollectionVecInput m_vecColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "color blend type"
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyFriendlyName = "light style"
	// MPropertyAttributeEditor = "VDataChoice( scripts/light_styles.vdata )"
	CUtlString m_strLightStyle;
	// MPropertyFriendlyName = "light style time"
	// MPropertySuppressExpr = "m_strLightStyle == ''"
	CPerParticleFloatInput m_flLightStyleTime; // = { "m_nType": "PF_TYPE_PARTICLE_AGE" }
	// MPropertyFriendlyName = "intensity"
	CPerParticleFloatInput m_flIntensity; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "cast shadows"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	bool m_bCastShadows;
	// MPropertyFriendlyName = "dynamic bounce (RTGI)"
	// MPropertySuppressExpr = "!m_bCastShadows || m_nLightType == PARTICLE_LIGHT_TYPE_FX || mod == csgo"
	bool m_bDynamicBounce;
	// MPropertyFriendlyName = "bounce scale"
	// MPropertySuppressExpr = "!m_bDynamicBounce"
	CParticleCollectionFloatInput m_flBounceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "inner cone angle"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_LIGHT_TYPE_SPOT"
	CParticleCollectionFloatInput m_flTheta; // = { "m_flLiteralValue": 45 }
	// MPropertyFriendlyName = "outer cone angle"
	// MPropertySuppressExpr = "m_nLightType != PARTICLE_LIGHT_TYPE_SPOT"
	CParticleCollectionFloatInput m_flPhi; // = { "m_flLiteralValue": 60 }
	// MPropertyFriendlyName = "light radius multiplier"
	CParticleCollectionFloatInput m_flRadiusMultiplier; // = { "m_flLiteralValue": 8 }
	// MPropertyFriendlyName = "attenuation type"
	StandardLightingAttenuationStyle_t m_nAttenuationStyle; // = "LIGHT_STYLE_OLD"
	// MPropertyFriendlyName = "falloff linearity"
	// MPropertySuppressExpr = "m_nAttenuationStyle == LIGHT_STYLE_NEW || ( m_nAttenuationStyle == LIGHT_STYLE_OLD && m_nLightType == PARTICLE_LIGHT_TYPE_FX )"
	CParticleCollectionFloatInput m_flFalloffLinearity;
	// MPropertyFriendlyName = "falloff fifty percent"
	// MPropertySuppressExpr = "m_nAttenuationStyle == LIGHT_STYLE_OLD"
	CParticleCollectionFloatInput m_flFiftyPercentFalloff; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "falloff zero percent"
	// MPropertySuppressExpr = "m_nAttenuationStyle == LIGHT_STYLE_OLD"
	CParticleCollectionFloatInput m_flZeroPercentFalloff; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "render diffuse"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	bool m_bRenderDiffuse; // = true
	// MPropertyFriendlyName = "render specular"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	bool m_bRenderSpecular; // = true
	// MPropertyFriendlyName = "light cookie string"
	CUtlString m_lightCookie;
	// MPropertyFriendlyName = "light priority"
	int32 m_nPriority;
	// MPropertyFriendlyName = "fog lighting mode"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	ParticleLightFogLightingMode_t m_nFogLightingMode; // = "PARTICLE_LIGHT_FOG_LIGHTING_MODE_NONE"
	// MPropertyFriendlyName = "fog contribution"
	// MPropertySuppressExpr = "m_nLightType == PARTICLE_LIGHT_TYPE_FX"
	CParticleCollectionRendererFloatInput m_flFogContribution; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "capsule behavior"
	ParticleLightBehaviorChoiceList_t m_nCapsuleLightBehavior; // = "PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION"
	// MPropertyStartGroup = "Capsule Light Controls"
	// MPropertyFriendlyName = "capsule length"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_TRAILS"
	float32 m_flCapsuleLength; // = 100
	// MPropertyFriendlyName = "reverse point order"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_TRAILS"
	bool m_bReverseOrder;
	// MPropertyFriendlyName = "Closed loop"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_TRAILS"
	bool m_bClosedLoop;
	// MPropertyFriendlyName = "Anchor point source"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	ParticleAttributeIndex_t m_nPrevPntSource; // = 2
	// MPropertyFriendlyName = "max length"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	float32 m_flMaxLength; // = 2000
	// MPropertyFriendlyName = "min length"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	float32 m_flMinLength;
	// MPropertyFriendlyName = "ignore delta time"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	bool m_bIgnoreDT;
	// MPropertyFriendlyName = "constrain radius to no more than this times the length"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	float32 m_flConstrainRadiusToLengthRatio; // = 1
	// MPropertyFriendlyName = "amount to scale trail length by"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	float32 m_flLengthScale; // = 1
	// MPropertyFriendlyName = "how long before a trail grows to its full length"
	// MPropertySuppressExpr = "m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_FOLLOW_DIRECTION || m_nCapsuleLightBehavior == PARTICLE_LIGHT_BEHAVIOR_ROPE"
	float32 m_flLengthFadeInTime;
};
