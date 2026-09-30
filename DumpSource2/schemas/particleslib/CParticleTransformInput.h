// MPropertyCustomEditor = "TransformInput()"
// MCustomFGDMetadata = "{ SkipImprintFGDClassOnKV3 = true SkipRemoveKeysInKV3AtFGDDefault = true KV3DefaultTestFnName = 'CParticleTransformInputDefaultTestFunc' }"
class CParticleTransformInput : public CParticleInput
{
	ParticleTransformType_t m_nType; // = "PT_TYPE_CONTROL_POINT"
	CParticleNamedValueRef m_NamedValue;
	bool m_bFollowNamedValue;
	bool m_bSupportsDisabled;
	bool m_bUseOrientation; // = true
	int32 m_nControlPoint;
	int32 m_nControlPointRangeMax;
	float32 m_flEndCPGrowthTime;
};
