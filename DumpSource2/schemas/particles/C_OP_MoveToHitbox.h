// MHasKV3TransferPolymorphicClassname
class C_OP_MoveToHitbox : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "model input"
	CParticleModelInput m_modelInput; // = { "m_nControlPoint": 0, "m_nType": "PM_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_transformInput;
	// MPropertyFriendlyName = "lifetime lerp start"
	float32 m_flLifeTimeLerpStart;
	// MPropertyFriendlyName = "lifetime lerp end"
	float32 m_flLifeTimeLerpEnd; // = 1
	// MPropertyFriendlyName = "previous position scale"
	float32 m_flPrevPosScale; // = 1
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "lerp type"
	HitboxLerpType_t m_nLerpType; // = "HITBOX_LERP_LIFETIME"
	// MPropertyFriendlyName = "Constant Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
