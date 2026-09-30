// MCustomFGDMetadata = "{ SkipImprintFGDClassOnKV3 = true SkipRemoveKeysInKV3AtFGDDefault = true KV3DefaultTestFnName = 'CParticleFloatInputDefaultTestFunc' }"
class CParticleFloatInput : public CParticleInput
{
	ParticleFloatType_t m_nType; // = "PF_TYPE_LITERAL"
	ParticleFloatMapType_t m_nMapType; // = "PF_MAP_TYPE_DIRECT"
	float32 m_flLiteralValue;
	CParticleNamedValueRef m_NamedValue;
	int32 m_nControlPoint;
	ParticleAttributeIndex_t m_nScalarAttribute; // = 3
	ParticleAttributeIndex_t m_nVectorAttribute; // = 6
	int32 m_nVectorComponent;
	bool m_bReverseOrder;
	float32 m_flRandomMin;
	float32 m_flRandomMax; // = 1
	bool m_bHasRandomSignFlip;
	int32 m_nRandomSeed;
	ParticleFloatRandomMode_t m_nRandomMode; // = "PF_RANDOM_MODE_CONSTANT"
	CUtlString m_strSnapshotSubset;
	float32 m_flLOD0;
	float32 m_flLOD1;
	float32 m_flLOD2;
	float32 m_flLOD3;
	ParticleAttributeIndex_t m_nNoiseInputVectorAttribute;
	float32 m_flNoiseOutputMin;
	float32 m_flNoiseOutputMax; // = 1
	float32 m_flNoiseScale; // = 0.1
	Vector m_vecNoiseOffsetRate;
	float32 m_flNoiseOffset;
	int32 m_nNoiseOctaves; // = 1
	PFNoiseTurbulence_t m_nNoiseTurbulence; // = "PF_NOISE_TURB_NONE"
	PFNoiseType_t m_nNoiseType; // = "PF_NOISE_TYPE_PERLIN"
	PFNoiseModifier_t m_nNoiseModifier; // = "PF_NOISE_MODIFIER_NONE"
	float32 m_flNoiseTurbulenceScale; // = 1
	float32 m_flNoiseTurbulenceMix; // = 0.5
	float32 m_flNoiseImgPreviewScale; // = 1
	bool m_bNoiseImgPreviewLive; // = true
	float32 m_flNoCameraFallback;
	bool m_bUseBoundsCenter;
	ParticleFloatInputMode_t m_nInputMode; // = "PF_INPUT_MODE_CLAMPED"
	float32 m_flMultFactor; // = 1
	float32 m_flInput0;
	float32 m_flInput1; // = 1
	float32 m_flOutput0;
	float32 m_flOutput1; // = 1
	float32 m_flNotchedRangeMin;
	float32 m_flNotchedRangeMax; // = 1
	float32 m_flNotchedOutputOutside;
	float32 m_flNotchedOutputInside; // = 1
	ParticleFloatRoundType_t m_nRoundType; // = "PF_ROUND_TYPE_NEAREST"
	ParticleFloatBiasType_t m_nBiasType; // = "PF_BIAS_TYPE_STANDARD"
	float32 m_flBiasParameter;
	CPiecewiseCurve m_Curve;
	float32 m_flCompareValue;
};
