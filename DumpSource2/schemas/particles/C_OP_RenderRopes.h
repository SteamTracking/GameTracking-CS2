// MHasKV3TransferPolymorphicClassname
class C_OP_RenderRopes : public CBaseRendererSource2
{
	// MPropertyStartGroup = "Screenspace Fading and culling"
	// MPropertyFriendlyName = "enable fading and clamping"
	// MPropertySortPriority = 1000
	bool m_bEnableFadingAndClamping;
	// MPropertyFriendlyName = "minimum visual screen-size"
	// MPropertySuppressExpr = "!m_bEnableFadingAndClamping"
	float32 m_flMinSize;
	// MPropertyFriendlyName = "maximum visual screen-size"
	// MPropertySuppressExpr = "!m_bEnableFadingAndClamping"
	float32 m_flMaxSize; // = 2000
	// MPropertyFriendlyName = "start fade screen-size"
	// MPropertySuppressExpr = "!m_bEnableFadingAndClamping"
	float32 m_flStartFadeSize; // = 1000
	// MPropertyFriendlyName = "end fade and cull screen-size"
	// MPropertySuppressExpr = "!m_bEnableFadingAndClamping"
	float32 m_flEndFadeSize; // = 2000
	// MPropertyFriendlyName = "start fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flStartFadeDot; // = 1
	// MPropertyFriendlyName = "end fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flEndFadeDot; // = 2
	// MPropertyFriendlyName = "sub-pixel AA scale"
	// MPropertySuppressExpr = "mod != hlx"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flSubPixelAAScale; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0.75, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyStartGroup = "Rope Tesselation"
	// MPropertyFriendlyName = "amount to taper the width of the trail end by"
	float32 m_flRadiusTaper; // = 1
	// MPropertyFriendlyName = "minium number of quads per render segment"
	// MPropertySortPriority = 850
	int32 m_nMinTesselation; // = 1
	// MPropertyFriendlyName = "maximum number of quads per render segment"
	int32 m_nMaxTesselation; // = 128
	// MPropertyFriendlyName = "tesselation resolution scale factor"
	float32 m_flTessScale; // = 1
	// MPropertyStartGroup = "+Rope Global UV Controls"
	// MPropertyFriendlyName = "global texture V World Size"
	// MPropertySortPriority = 800
	CParticleCollectionRendererFloatInput m_flTextureVWorldSize; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 10, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "global texture V Scroll Rate"
	CParticleCollectionRendererFloatInput m_flTextureVScrollRate; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "global texture V Offset"
	CParticleCollectionRendererFloatInput m_flTextureVOffset; // = { "m_Curve": { "m_spline": [  ], "m_tangents": [  ], "m_vDomainMaxs": [ 0, 0 ], "m_vDomainMins": [ 0, 0 ] }, "m_NamedValue": "", "m_bHasRandomSignFlip": false, "m_bNoiseImgPreviewLive": true, "m_bReverseOrder": false, "m_bUseBoundsCenter": false, "m_flBiasParameter": 0, "m_flCompareValue": 0, "m_flInput0": 0, "m_flInput1": 1, "m_flLOD0": 0, "m_flLOD1": 0, "m_flLOD2": 0, "m_flLOD3": 0, "m_flLiteralValue": 0, "m_flMultFactor": 1, "m_flNoCameraFallback": 0, "m_flNoiseImgPreviewScale": 1, "m_flNoiseOffset": 0, "m_flNoiseOutputMax": 1, "m_flNoiseOutputMin": 0, "m_flNoiseScale": 0.1, "m_flNoiseTurbulenceMix": 0.5, "m_flNoiseTurbulenceScale": 1, "m_flNotchedOutputInside": 1, "m_flNotchedOutputOutside": 0, "m_flNotchedRangeMax": 1, "m_flNotchedRangeMin": 0, "m_flOutput0": 0, "m_flOutput1": 1, "m_flRandomMax": 1, "m_flRandomMin": 0, "m_nBiasType": "PF_BIAS_TYPE_STANDARD", "m_nControlPoint": 0, "m_nInputMode": "PF_INPUT_MODE_CLAMPED", "m_nMapType": "PF_MAP_TYPE_DIRECT", "m_nNoiseInputVectorAttribute": 0, "m_nNoiseModifier": "PF_NOISE_MODIFIER_NONE", "m_nNoiseOctaves": 1, "m_nNoiseTurbulence": "PF_NOISE_TURB_NONE", "m_nNoiseType": "PF_NOISE_TYPE_PERLIN", "m_nRandomMode": "PF_RANDOM_MODE_CONSTANT", "m_nRandomSeed": 0, "m_nRoundType": "PF_ROUND_TYPE_NEAREST", "m_nScalarAttribute": 3, "m_nType": "PF_TYPE_LITERAL", "m_nVectorAttribute": 6, "m_nVectorComponent": 0, "m_strSnapshotSubset": "", "m_vecNoiseOffsetRate": [ 0, 0, 0 ] }
	// MPropertyFriendlyName = "global texture V Params CP"
	int32 m_nTextureVParamsCP; // = -1
	// MPropertyFriendlyName = "Clamp Non-Sheet texture V coords"
	bool m_bClampV;
	// MPropertyStartGroup = "Rope Global UV Controls/CP Scaling"
	// MPropertyFriendlyName = "scale CP start"
	int32 m_nScaleCP1; // = -1
	// MPropertyFriendlyName = "scale CP end"
	int32 m_nScaleCP2; // = -1
	// MPropertyFriendlyName = "scale V world size by CP distance"
	float32 m_flScaleVSizeByControlPointDistance;
	// MPropertyFriendlyName = "scale V scroll rate by CP distance"
	float32 m_flScaleVScrollByControlPointDistance;
	// MPropertyFriendlyName = "scale V offset by CP distance"
	float32 m_flScaleVOffsetByControlPointDistance;
	// MPropertyStartGroup = "Rope Global UV Controls"
	// MPropertyFriendlyName = "Use scalar attribute for texture coordinate"
	bool m_bUseScalarForTextureCoordinate;
	// MPropertyFriendlyName = "scalar to use for texture coordinate"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySuppressExpr = "!m_bUseScalarForTextureCoordinate"
	ParticleAttributeIndex_t m_nScalarFieldForTextureCoordinate; // = 8
	// MPropertyFriendlyName = "scale value to map attribute to texture coordinate"
	// MPropertySuppressExpr = "!m_bUseScalarForTextureCoordinate"
	float32 m_flScalarAttributeTextureCoordScale; // = 1
	// MPropertyStartGroup = "Rope Order Controls"
	// MPropertyFriendlyName = "reverse point order"
	// MPropertySortPriority = 800
	bool m_bReverseOrder;
	// MPropertyFriendlyName = "Closed loop"
	bool m_bClosedLoop;
	// MPropertyFriendlyName = "attribute to use for rope segment id"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nSplitField; // = 47
	// MPropertyFriendlyName = "sort by rope segment id"
	// MPropertySuppressExpr = "m_nSplitField == PARTICLE_ATTRIBUTE_UNUSED"
	bool m_bSortBySegmentID;
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "orientation_type"
	// MPropertySortPriority = 750
	ParticleOrientationChoiceList_t m_nOrientationType; // = "PARTICLE_ORIENTATION_SCREEN_ALIGNED"
	// MPropertyFriendlyName = "attribute to use for normal"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_ORIENTATION_ALIGN_TO_PARTICLE_NORMAL && m_nOrientationType != PARTICLE_ORIENTATION_SCREENALIGN_TO_PARTICLE_NORMAL"
	ParticleAttributeIndex_t m_nVectorFieldForOrientation; // = 21
	// MPropertyStartGroup = "Material"
	// MPropertyFriendlyName = "draw as opaque"
	bool m_bDrawAsOpaque;
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "generate normals for cylinder"
	bool m_bGenerateNormals;
};
