// MHasKV3TransferPolymorphicClassname
class C_OP_RenderModels : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "Only Render in effects bloom pass"
	// MPropertySortPriority = 1100
	bool m_bOnlyRenderInEffectsBloomPass;
	// MPropertyFriendlyName = "Only Render in effects water pass"
	// MPropertySortPriority = 1050
	// MPropertySuppressExpr = "mod != csgo && mod != hlx"
	bool m_bOnlyRenderInEffectsWaterPass;
	// MPropertyFriendlyName = "Use Mixed Resolution Rendering"
	// MPropertySortPriority = 1200
	bool m_bUseMixedResolutionRendering;
	// MPropertyFriendlyName = "Only Render in effects game overlay pass"
	// MPropertySortPriority = 1210
	// MPropertySuppressExpr = "mod != csgo"
	bool m_bOnlyRenderInEffecsGameOverlay;
	// MPropertyFriendlyName = "models"
	// MParticleRequireDefaultArrayEntry
	// MPropertyAutoExpandSelf
	// MPropertySortPriority = 775
	CUtlVector< ModelReference_t > m_ModelList;
	// MPropertyFriendlyName = "bodygroup field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nBodyGroupField; // = 9
	// MPropertyFriendlyName = "submodel field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nSubModelField; // = 18
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "ignore normal"
	// MPropertySortPriority = 750
	bool m_bIgnoreNormal;
	// MPropertyFriendlyName = "orient model z to normal"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_bIgnoreNormal"
	bool m_bOrientZ;
	// MPropertyFriendlyName = "center mesh"
	// MPropertySortPriority = 750
	bool m_bCenterOffset;
	// MPropertyFriendlyName = "model local offset"
	// MPropertySortPriority = 750
	CPerParticleVecInput m_vecLocalOffset;
	// MPropertyFriendlyName = "model local rotation (pitch/yaw/roll)"
	// MPropertySortPriority = 750
	CPerParticleVecInput m_vecLocalRotation;
	// MPropertyStartGroup = "Model Scale"
	// MPropertyFriendlyName = "ignore radius"
	// MPropertySortPriority = 700
	bool m_bIgnoreRadius;
	// MPropertyFriendlyName = "model scale CP"
	// MPropertySortPriority = 700
	int32 m_nModelScaleCP; // = -1
	// MPropertyFriendlyName = "model component scale"
	// MPropertySortPriority = 700
	CPerParticleVecInput m_vecComponentScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "apply scales in local model space"
	// MPropertySortPriority = 700
	bool m_bLocalScale;
	// MPropertyFriendlyName = "model size cull bloat"
	// MPropertyAttributeChoiceName = "particlefield_size_cull_bloat"
	int32 m_nSizeCullBloat;
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "animated"
	// MPropertySortPriority = 500
	bool m_bAnimated;
	// MPropertyFriendlyName = "animation rate"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bAnimated"
	CPerParticleFloatInput m_flAnimationRate; // = { "m_flLiteralValue": 30 }
	// MPropertyFriendlyName = "scale animation rate"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bAnimated"
	bool m_bScaleAnimationRate;
	// MPropertyFriendlyName = "force looping animations"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bAnimated"
	bool m_bForceLoopingAnimation;
	// MPropertyFriendlyName = "reset animation frame on stop"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bAnimated"
	bool m_bResetAnimOnStop;
	// MPropertyFriendlyName = "set animation frame manually"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!m_bAnimated"
	bool m_bManualAnimFrame;
	// MPropertyFriendlyName = "animation rate scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!(m_bAnimated && m_bScaleAnimationRate)"
	ParticleAttributeIndex_t m_nAnimationScaleField; // = 10
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "animation sequence field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 500
	ParticleAttributeIndex_t m_nAnimationField; // = 13
	// MPropertyFriendlyName = "manual animation frame field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 500
	// MPropertySuppressExpr = "!(m_bAnimated && m_bManualAnimFrame)"
	ParticleAttributeIndex_t m_nManualFrameField; // = 8
	// MPropertyFriendlyName = "activity override"
	// MPropertySuppressExpr = "mod != dota"
	// MPropertySortPriority = 500
	char[256] m_ActivityName;
	// MPropertyFriendlyName = "sequence override"
	// MPropertySuppressExpr = "mod == dota"
	// MPropertySortPriority = 500
	char[256] m_SequenceName;
	// MPropertyFriendlyName = "Enable Cloth Simulation"
	bool m_bEnableClothSimulation;
	// MPropertyFriendlyName = "Disable Cloth Ground Collision"
	bool m_bDisableClothGroundCollision;
	// MPropertyFriendlyName = "With Cloth Effect"
	// MPropertySortPriority = 500
	char[64] m_ClothEffectName;
	// MPropertyStartGroup = "Material"
	// MPropertyFriendlyName = "material override"
	// MPropertySortPriority = 600
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hOverrideMaterial;
	// MPropertyFriendlyName = "override translucent materials"
	// MPropertySortPriority = 600
	bool m_bOverrideTranslucentMaterials; // = true
	// MPropertyFriendlyName = "skin number"
	// MPropertySortPriority = 600
	CPerParticleFloatInput m_nSkin;
	// MPropertyFriendlyName = "material variables"
	// MPropertyAutoExpandSelf
	// MPropertySortPriority = 600
	CUtlVector< MaterialVariable_t > m_MaterialVars;
	// MPropertyStartGroup = "Model Overrides"
	// MPropertyFriendlyName = "render filter"
	CPerParticleFloatInput m_flRenderFilter; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "model list selection override"
	CPerParticleFloatInput m_flManualModelSelection; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "input model"
	// MParticleInputOptional
	CParticleModelInput m_modelInput;
	// MPropertyFriendlyName = "model LOD"
	int32 m_nLOD; // = -1
	// MPropertyFriendlyName = "model override economy loadout slot type"
	char[256] m_EconSlotName;
	// MPropertyFriendlyName = "model override original model only (ignore shapeshift/hex/etc)"
	bool m_bOriginalModel;
	// MPropertyFriendlyName = "suppress tinting of the model"
	bool m_bSuppressTint;
	// MPropertyFriendlyName = "SubModel Field Type"
	RenderModelSubModelFieldType_t m_nSubModelFieldType; // = "SUBMODEL_AS_BODYGROUP_SUBMODEL"
	// MPropertyFriendlyName = "disable shadows"
	bool m_bDisableShadows;
	// MPropertyFriendlyName = "disable depth prepass"
	bool m_bDisableDepthPrepass;
	// MPropertyFriendlyName = "accept decals"
	bool m_bAcceptsDecals; // = true
	// MPropertyFriendlyName = "forcedrawinterlevedwithsiblings"
	bool m_bForceDrawInterlevedWithSiblings;
	// MPropertyFriendlyName = "do not draw in particle pass"
	bool m_bDoNotDrawInParticlePass;
	// MPropertyFriendlyName = "allow approximate transforms (cpu optimizaiton)"
	bool m_bAllowApproximateTransforms;
	// MPropertyFriendlyName = "render attribute"
	char[260] m_szRenderAttribute;
	// MPropertyStartGroup = "+Renderer Modifiers"
	// MPropertyFriendlyName = "Radius Scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flRadiusScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "alpha scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flAlphaScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "rotation roll scale"
	// MPropertySortPriority = 700
	CParticleCollectionFloatInput m_flRollScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "per-particle alpha scale attribute"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 700
	ParticleAttributeIndex_t m_nAlpha2Field; // = 16
	// MPropertyFriendlyName = "color blend"
	// MPropertySortPriority = 700
	CParticleCollectionVecInput m_vecColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "color blend type"
	// MPropertySortPriority = 700
	ParticleColorBlendType_t m_nColorBlendType; // = "PARTICLE_COLOR_BLEND_MULTIPLY"
	// MPropertyFriendlyName = "light style"
	// MPropertyAttributeEditor = "VDataChoice( scripts/light_styles.vdata )"
	// MPropertySortPriority = 700
	CUtlString m_strLightStyle;
	// MPropertyFriendlyName = "light style time"
	// MPropertySuppressExpr = "m_strLightStyle == ''"
	// MPropertySortPriority = 700
	CPerParticleFloatInput m_flLightStyleTime; // = { "m_nType": "PF_TYPE_PARTICLE_AGE" }
};
