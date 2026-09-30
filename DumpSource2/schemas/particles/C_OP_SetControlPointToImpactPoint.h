// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToImpactPoint : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point to set"
	int32 m_nCPOut; // = 1
	// MPropertyFriendlyName = "control point to trace from"
	int32 m_nCPIn; // = 1
	// MPropertyFriendlyName = "trace update rate"
	float32 m_flUpdateRate; // = 0.5
	// MPropertyFriendlyName = "max trace length"
	CParticleCollectionFloatInput m_flTraceLength; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 1024, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "offset start point amount"
	float32 m_flStartOffset;
	// MPropertyFriendlyName = "offset end point amount"
	float32 m_flOffset;
	// MPropertyFriendlyName = "trace direction override"
	// MVectorIsCoordinate
	Vector m_vecTraceDir;
	// MPropertyFriendlyName = "trace collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "set to trace endpoint if no collision"
	bool m_bSetToEndpoint;
	// MPropertyFriendlyName = "trace to closest surface along all cardinal directions"
	bool m_bTraceToClosestSurface;
	// MPropertyFriendlyName = "include water"
	bool m_bIncludeWater;
};
