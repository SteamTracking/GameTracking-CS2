// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapTransformToVector : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "input minimum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vInputMin;
	// MPropertyFriendlyName = "input maximum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vInputMax;
	// MPropertyFriendlyName = "output minimum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vOutputMin;
	// MPropertyFriendlyName = "output maximum"
	// MVectorIsSometimesCoordinate = "m_nFieldOutput"
	Vector m_vOutputMax;
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "local space transform"
	// MParticleInputOptional
	CParticleTransformInput m_LocalSpaceTransform; // = { "m_NamedValue": "", "m_bFollowNamedValue": false, "m_bSupportsDisabled": false, "m_bUseOrientation": true, "m_flEndCPGrowthTime": 0, "m_nControlPoint": 0, "m_nControlPointRangeMax": 0, "m_nType": "PT_TYPE_INVALID" }
	// MPropertyFriendlyName = "emitter lifetime start time (seconds)"
	float32 m_flStartTime; // = -1
	// MPropertyFriendlyName = "emitter lifetime end time (seconds)"
	float32 m_flEndTime; // = -1
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "offset position"
	bool m_bOffset;
	// MPropertyFriendlyName = "accelerate position"
	bool m_bAccelerate;
	// MPropertyFriendlyName = "remap bias"
	float32 m_flRemapBias; // = 0.5
};
