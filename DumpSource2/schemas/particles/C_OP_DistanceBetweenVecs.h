// MHasKV3TransferPolymorphicClassname
class C_OP_DistanceBetweenVecs : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "first vector"
	CPerParticleVecInput m_vecPoint1;
	// MPropertyFriendlyName = "second vector"
	CPerParticleVecInput m_vecPoint2;
	// MPropertyFriendlyName = "distance minimum"
	CPerParticleFloatInput m_flInputMin;
	// MPropertyFriendlyName = "distance maximum"
	CPerParticleFloatInput m_flInputMax; // = { "m_flLiteralValue": 128 }
	// MPropertyFriendlyName = "output minimum"
	CPerParticleFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CPerParticleFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "divide by deltatime (for comparing motion since last simulation)"
	bool m_bDeltaTime;
};
