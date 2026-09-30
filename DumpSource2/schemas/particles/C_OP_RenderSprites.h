// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_RenderSprites : public CBaseRendererSource2
{
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "sequence id override"
	// MPropertySortPriority = 500
	CParticleCollectionRendererFloatInput m_nSequenceOverride; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": -1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Sequence Numbers Are Indices (Tools Particles Only)"
	// MParticleAdvancedField
	bool m_bSequenceNumbersAreRawSequenceIndices;
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "orientation type"
	// MPropertySortPriority = 750
	ParticleOrientationChoiceList_t m_nOrientationType; // = "PARTICLE_ORIENTATION_SCREEN_ALIGNED"
	// MPropertyFriendlyName = "orientation control point"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_ORIENTATION_ALIGN_TO_PARTICLE_NORMAL && m_nOrientationType != PARTICLE_ORIENTATION_SCREENALIGN_TO_PARTICLE_NORMAL"
	int32 m_nOrientationControlPoint; // = -1
	// MPropertyFriendlyName = "enable yaw for particles aligned to normals"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_ORIENTATION_ALIGN_TO_PARTICLE_NORMAL && m_nOrientationType != PARTICLE_ORIENTATION_SCREENALIGN_TO_PARTICLE_NORMAL"
	bool m_bUseYawWithNormalAligned;
	// MPropertyStartGroup = "Fading and culling"
	// MPropertyFriendlyName = "minimum visual screen size"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flMinSize; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "maximum visual screen size"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flMaxSize; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 5000, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "sub-pixel AA scale"
	// MPropertySuppressExpr = "mod != hlx"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flSubPixelAAScale; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 1, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "screen size to start fading"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flStartFadeSize; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 100000000, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "screen size to fade away"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flEndFadeSize; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 200000000, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "start fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flStartFadeDot; // = 1
	// MPropertyFriendlyName = "end fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flEndFadeDot; // = 2
	// MPropertyStartGroup = "Distance to alpha coding"
	// MPropertyFriendlyName = "distance alpha"
	// MPropertySortPriority = 0
	bool m_bDistanceAlpha;
	// MPropertyFriendlyName = "use soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	bool m_bSoftEdges;
	// MPropertyFriendlyName = "start value for soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	float32 m_flEdgeSoftnessStart; // = 0.6
	// MPropertyFriendlyName = "end value for soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	float32 m_flEdgeSoftnessEnd; // = 0.5
	// MPropertyStartGroup = "Outlining"
	// MPropertyFriendlyName = "enable particle outlining"
	// MPropertySortPriority = 0
	bool m_bOutline;
	// MPropertyFriendlyName = "outline color"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	Color m_OutlineColor; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "outline alpha"
	// MPropertyAttributeRange = "0 255"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	int32 m_nOutlineAlpha; // = 255
	// MPropertyFriendlyName = "outline start 0"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineStart0; // = 0.5
	// MPropertyFriendlyName = "outline start 1"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineStart1; // = 0.6
	// MPropertyFriendlyName = "outline end 0"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineEnd0; // = 0.7
	// MPropertyFriendlyName = "outline end 1"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineEnd1; // = 0.8
	// MPropertyStartGroup = "Lighting and Shadows"
	// MPropertyFriendlyName = "lighting mode"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx"
	ParticleLightingQuality_t m_nLightingMode; // = "PARTICLE_LIGHTING_PER_PARTICLE"
	// MPropertyFriendlyName = "lighting override"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "m_nLightingMode != PARTICLE_LIGHTING_OVERRIDE_POSITION && m_nLightingMode != PARTICLE_LIGHTING_OVERRIDE_COLOR && m_nLightingMode != PARTICLE_LIGHTING_ADD_EXTRA_LIGHT"
	CParticleCollectionRendererVecInput m_vecLightingOverride; // = { "m_FloatComponentX": { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }, "m_FloatComponentY": { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }, "m_FloatComponentZ": { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }, "m_FloatInterp": { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }, "m_Gradient": { "m_Stops": [  ] }, "m_LiteralColor": [ 255, 255, 255 ], "m_NamedValue": "", "m_bFollowNamedValue": false, "m_flInterpInput0": 0, "m_flInterpInput1": 1, "m_nControlPoint": 0, "m_nDeltaControlPoint": 0, "m_nType": "PVEC_TYPE_LITERAL_COLOR", "m_nVectorAttribute": 6, "m_vCPRelativeDir": [ 1, 0, 0 ], "m_vCPRelativePosition": [ 0, 0, 0 ], "m_vCPValueScale": [ 1, 1, 1 ], "m_vInterpOutput0": [ 0, 0, 0 ], "m_vInterpOutput1": [ 1, 1, 1 ], "m_vLiteralValue": [ 0, 0, 0 ], "m_vRandomMax": [ 0, 0, 0 ], "m_vRandomMin": [ 0, 0, 0 ], "m_vVectorAttributeScale": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "vertex lighting tessellation (0-5)"
	// MPropertyAttributeRange = "0 5"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx || m_nLightingMode != PARTICLE_LIGHTING_PER_VERTEX"
	CParticleCollectionRendererFloatInput m_flLightingTessellation; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "lighting directionality"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx"
	CParticleCollectionRendererFloatInput m_flLightingDirectionality; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "Particle Shadows"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != csgo"
	bool m_bParticleShadows;
	// MPropertyFriendlyName = "Shadow Density"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "!m_bParticleShadows"
	float32 m_flShadowDensity; // = 1
};
