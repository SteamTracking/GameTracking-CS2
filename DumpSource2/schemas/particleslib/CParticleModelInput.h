// MPropertyCustomEditor = "ModelInput()"
// MCustomFGDMetadata = "{ KV3DefaultTestFnName = 'CParticleModelInputDefaultTestFunc' }"
class CParticleModelInput : public CParticleInput
{
	ParticleModelType_t m_nType; // = "PM_TYPE_INVALID"
	CParticleNamedValueRef m_NamedValue;
	int32 m_nControlPoint; // = -1
};
