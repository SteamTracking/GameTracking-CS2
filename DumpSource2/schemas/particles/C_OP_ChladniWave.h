// MHasKV3TransferPolymorphicClassname
class C_OP_ChladniWave : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "wave minimum"
	CPerParticleFloatInput m_flInputMin; // = { "m_flLiteralValue": -2 }
	// MPropertyFriendlyName = "wave maximum"
	CPerParticleFloatInput m_flInputMax; // = { "m_flLiteralValue": 2 }
	// MPropertyFriendlyName = "output minimum"
	CPerParticleFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CPerParticleFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "wave length"
	CPerParticleVecInput m_vecWaveLength; // = { "m_vLiteralValue": [ 64, 64, 64 ] }
	// MPropertyFriendlyName = "harmonics"
	CPerParticleVecInput m_vecHarmonics; // = { "m_vLiteralValue": [ 2, 3, 0 ] }
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "local space control point"
	int32 m_nLocalSpaceControlPoint; // = -1
	// MPropertyFriendlyName = "3D"
	bool m_b3D;
};
