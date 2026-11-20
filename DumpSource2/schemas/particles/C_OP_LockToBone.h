// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_LockToBone : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "model input"
	CParticleModelInput m_modelInput; // = { "m_nControlPoint": 0, "m_nType": "PM_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_transformInput;
	// MPropertyFriendlyName = "lifetime fade start"
	float32 m_flLifeTimeFadeStart;
	// MPropertyFriendlyName = "lifetime fade end"
	float32 m_flLifeTimeFadeEnd;
	// MPropertyFriendlyName = "instant jump threshold"
	float32 m_flJumpThreshold; // = 100
	// MPropertyFriendlyName = "previous position scale"
	float32 m_flPrevPosScale; // = 1
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "rigid lock"
	bool m_bRigid;
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "output field prev"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutputPrev; // = 2
	// MPropertyStartGroup = "Set Rotations to Bones"
	// MPropertyFriendlyName = "lock rotations to bone orientation"
	ParticleRotationLockType_t m_nRotationSetType; // = "PARTICLE_ROTATION_LOCK_NONE"
	// MPropertyFriendlyName = "rigid set rotation from bones"
	bool m_bRigidRotationLock;
	// MPropertyFriendlyName = "rigid rotation offset pitch/yaw/roll"
	CPerParticleVecInput m_vecRotation;
	// MPropertyFriendlyName = "rigid rotation interpolation"
	CPerParticleFloatInput m_flRotLerp; // = { "m_flLiteralValue": 1 }
};
