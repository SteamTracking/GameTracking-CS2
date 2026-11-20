// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateWithinSphereTransform : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "distance min"
	CPerParticleFloatInput m_fRadiusMin;
	// MPropertyFriendlyName = "distance max"
	CPerParticleFloatInput m_fRadiusMax;
	// MPropertyFriendlyName = "distance bias"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecDistanceBias; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "distance bias absolute value"
	// MVectorIsCoordinate
	Vector m_vecDistanceBiasAbs;
	// MPropertyFriendlyName = "input position transform"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "speed min"
	CPerParticleFloatInput m_fSpeedMin;
	// MPropertyFriendlyName = "speed max"
	CPerParticleFloatInput m_fSpeedMax;
	// MPropertyFriendlyName = "speed random exponent"
	float32 m_fSpeedRandExp; // = 1
	// MPropertyFriendlyName = "bias in local system"
	bool m_bLocalCoords;
	// MPropertyFriendlyName = "speed in local coordinate system min"
	// MVectorIsCoordinate
	CPerParticleVecInput m_LocalCoordinateSystemSpeedMin;
	// MPropertyFriendlyName = "speed in local coordinate system max"
	// MVectorIsCoordinate
	CPerParticleVecInput m_LocalCoordinateSystemSpeedMax;
	// MPropertyFriendlyName = "Output vector"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "Velocity vector"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nFieldVelocity; // = 2
};
