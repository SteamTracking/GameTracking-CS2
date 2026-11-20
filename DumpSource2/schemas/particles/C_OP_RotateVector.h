// MHasKV3TransferPolymorphicClassname
class C_OP_RotateVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput; // = 21
	// MPropertyFriendlyName = "rotation axis min"
	// MVectorIsCoordinate
	Vector m_vecRotAxisMin; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "rotation axis max"
	// MVectorIsCoordinate
	Vector m_vecRotAxisMax; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "rotation rate min"
	float32 m_flRotRateMin; // = 180
	// MPropertyFriendlyName = "rotation rate max"
	float32 m_flRotRateMax; // = 180
	// MPropertyFriendlyName = "normalize output"
	bool m_bNormalize; // = true
	// MPropertyFriendlyName = "per particle scale"
	CPerParticleFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
};
