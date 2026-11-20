// MHasKV3TransferPolymorphicClassname
class C_OP_VectorFieldSnapshot : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "extra velocity field to write"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nAttributeToWrite; // = 19
	// MPropertyFriendlyName = "local space control point number"
	int32 m_nLocalSpaceCP;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Component Scale"
	CPerParticleVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "Boundary Dampening"
	float32 m_flBoundaryDampening;
	// MPropertyFriendlyName = "Set Velocity"
	bool m_bSetVelocity; // = true
	// MPropertyFriendlyName = "Lock to Surface"
	bool m_bLockToSurface; // = true
	// MPropertyFriendlyName = "Vector Field Grid Spacing Override"
	float32 m_flGridSpacing; // = -1
};
