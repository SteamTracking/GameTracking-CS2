// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateWithinCone : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "input position transform"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "inner angle"
	// MVectorIsCoordinate
	CPerParticleFloatInput m_flInnerAngle;
	// MPropertyFriendlyName = "outer angle"
	// MVectorIsCoordinate
	CPerParticleFloatInput m_flOuterAngle; // = { "m_flLiteralValue": 30 }
	// MPropertyFriendlyName = "speed"
	// MVectorIsCoordinate
	CPerParticleFloatInput m_flSpeed;
	// MPropertyFriendlyName = "offset"
	// MVectorIsCoordinate
	CPerParticleFloatInput m_flOffset;
	// MPropertyFriendlyName = "collapse offset"
	// MVectorIsCoordinate
	bool m_bCollapseOffset;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters;
};
