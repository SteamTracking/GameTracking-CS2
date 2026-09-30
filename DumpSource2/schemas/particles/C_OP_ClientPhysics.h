// MHasKV3TransferPolymorphicClassname
class C_OP_ClientPhysics : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "client physics type"
	// MPropertyAttributeEditor = "VDataChoice( scripts/misc.vdata!generic_physics_particle_spawner )"
	CUtlString m_strPhysicsType;
	// MPropertyFriendlyName = "start all physics asleep"
	bool m_bStartAsleep;
	// MPropertyFriendlyName = "Player Wake Radius"
	CParticleCollectionFloatInput m_flPlayerWakeRadius; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": -1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Vehicle Wake Radius"
	CParticleCollectionFloatInput m_flVehicleWakeRadius; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": -1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
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
