// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapInitialDirectionToTransformToVector : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "scale factor"
	float32 m_flScale; // = 1
	// MPropertyFriendlyName = "offset rotation"
	float32 m_flOffsetRot;
	// MPropertyFriendlyName = "offset axis"
	// MVectorIsCoordinate
	Vector m_vecOffsetAxis;
	// MPropertyFriendlyName = "normalize"
	bool m_bNormalize;
};
