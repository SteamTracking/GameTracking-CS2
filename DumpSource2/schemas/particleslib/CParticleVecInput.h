// MCustomFGDMetadata = "{ SkipImprintFGDClassOnKV3 = true SkipRemoveKeysInKV3AtFGDDefault = true KV3DefaultTestFnName = 'CParticleVecInputDefaultTestFunc' }"
class CParticleVecInput : public CParticleInput
{
	ParticleVecType_t m_nType; // = "PVEC_TYPE_LITERAL"
	Vector m_vLiteralValue;
	Color m_LiteralColor;
	CParticleNamedValueRef m_NamedValue;
	bool m_bFollowNamedValue;
	ParticleAttributeIndex_t m_nVectorAttribute; // = 6
	Vector m_vVectorAttributeScale; // = [ 1, 1, 1 ]
	int32 m_nControlPoint;
	int32 m_nDeltaControlPoint;
	Vector m_vCPValueScale; // = [ 1, 1, 1 ]
	Vector m_vCPRelativePosition;
	Vector m_vCPRelativeDir; // = [ 1, 0, 0 ]
	CParticleFloatInput m_FloatComponentX;
	CParticleFloatInput m_FloatComponentY;
	CParticleFloatInput m_FloatComponentZ;
	CParticleFloatInput m_FloatInterp;
	float32 m_flInterpInput0;
	float32 m_flInterpInput1; // = 1
	Vector m_vInterpOutput0;
	Vector m_vInterpOutput1; // = [ 1, 1, 1 ]
	CColorGradient m_Gradient;
	Vector m_vRandomMin;
	Vector m_vRandomMax;
};
