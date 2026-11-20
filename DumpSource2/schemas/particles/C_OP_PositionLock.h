// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_PositionLock : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "start fadeout min"
	float32 m_flStartTime_min; // = 1
	// MPropertyFriendlyName = "start fadeout max"
	float32 m_flStartTime_max; // = 1
	// MPropertyFriendlyName = "start fadeout exponent"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	float32 m_flStartTime_exp; // = 1
	// MPropertyFriendlyName = "end fadeout min"
	float32 m_flEndTime_min; // = 1
	// MPropertyFriendlyName = "end fadeout max"
	float32 m_flEndTime_max; // = 1
	// MPropertyFriendlyName = "end fadeout exponent"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	float32 m_flEndTime_exp; // = 1
	// MPropertyFriendlyName = "distance fade range"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	float32 m_flRange;
	// MPropertyFriendlyName = "distance fade bias"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	CParticleCollectionFloatInput m_flRangeBias; // = { "m_flLiteralValue": 0.2 }
	// MPropertyFriendlyName = "instant jump threshold"
	float32 m_flJumpThreshold; // = 512
	// MPropertyFriendlyName = "previous position scale"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	float32 m_flPrevPosScale; // = 1
	// MPropertyFriendlyName = "lock rotation"
	bool m_bLockRot;
	// MPropertyFriendlyName = "component scale"
	CParticleCollectionVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "output field prev"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutputPrev; // = 2
};
