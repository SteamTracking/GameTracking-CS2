// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_PositionOffset : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "offset min"
	// MVectorIsCoordinate
	CPerParticleVecInput m_OffsetMin;
	// MPropertyFriendlyName = "offset max"
	// MVectorIsCoordinate
	CPerParticleVecInput m_OffsetMax;
	// MPropertyFriendlyName = "transform input"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "offset in local space 0/1"
	bool m_bLocalCoords;
	// MPropertyFriendlyName = "offset proportional to radius 0/1"
	bool m_bProportional;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters;
};
