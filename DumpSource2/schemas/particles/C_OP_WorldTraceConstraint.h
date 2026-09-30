// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_WorldTraceConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "control point for fast collision tests"
	int32 m_nCP;
	// MPropertyFriendlyName = "control point offset for fast collisions"
	// MVectorIsCoordinate
	Vector m_vecCpOffset;
	// MPropertyFriendlyName = "collision mode"
	ParticleCollisionMode_t m_nCollisionMode; // = "COLLISION_MODE_PER_PARTICLE_TRACE"
	// MPropertyFriendlyName = "minimum detail collision mode"
	ParticleCollisionMode_t m_nCollisionModeMin; // = "COLLISION_MODE_DISABLED"
	// MPropertyStartGroup = "Collision Options"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "World Only"
	bool m_bWorldOnly;
	// MPropertyFriendlyName = "brush only"
	bool m_bBrushOnly;
	// MPropertyFriendlyName = "include water"
	// MPropertySuppressExpr = "m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	bool m_bIncludeWater;
	// MPropertyFriendlyName = "CP Entity to Ignore for Collisions"
	// MPropertySuppressExpr = "m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	int32 m_nIgnoreCP; // = -1
	// MPropertyFriendlyName = "control point movement distance tolerance"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_flCpMovementTolerance; // = 5
	// MPropertyFriendlyName = "plane cache retest rate"
	// MPropertySuppressExpr = "m_nCollisionMode != COLLISION_MODE_PER_FRAME_PLANESET"
	float32 m_flRetestRate; // = -1
	// MPropertyFriendlyName = "trace accuracy tolerance"
	// MPropertySuppressExpr = "m_nCollisionMode != COLLISION_MODE_USE_NEAREST_TRACE"
	float32 m_flTraceTolerance; // = 24
	// MPropertyFriendlyName = "Confirm Collision Speed Threshold"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_flCollisionConfirmationSpeed; // = 24
	// MPropertyFriendlyName = "Max Confirmation Traces Per Fame"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_nMaxTracesPerFrame; // = -1
	// MPropertyStartGroup = "Impact Options"
	// MPropertyFriendlyName = "radius scale"
	CPerParticleFloatInput m_flRadiusScale; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "amount of bounce"
	CPerParticleFloatInput m_flBounceAmount; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "amount of slide"
	CPerParticleFloatInput m_flSlideAmount; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Random Direction scale"
	CPerParticleFloatInput m_flRandomDirScale; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Add Decay to Bounce"
	bool m_bDecayBounce;
	// MPropertyFriendlyName = "kill particle on collision"
	bool m_bKillonContact;
	// MPropertyFriendlyName = "minimum speed to kill on collision"
	float32 m_flMinSpeed; // = -1
	// MPropertyFriendlyName = "calculate bounce on killed particles (for child events)"
	// MPropertySuppressExpr = "m_bKillonContact == false"
	bool m_bKillonContactBounce;
	// MPropertyFriendlyName = "Set Normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "Stick On Collision Cache Field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nStickOnCollisionField; // = 19
	// MPropertyFriendlyName = "Speed to stop when sticking"
	CPerParticleFloatInput m_flStopSpeed; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": -1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Entity Hitbox Cache Field (Requires Stick on Collision)"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nEntityStickDataField; // = 19
	// MPropertyFriendlyName = "Entity Normal Cache Field (Requires Stick on Collision)"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nEntityStickNormalField; // = 19
};
