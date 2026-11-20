// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateWithinBox : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "min"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecMin;
	// MPropertyFriendlyName = "max"
	// MVectorIsCoordinate
	CPerParticleVecInput m_vecMax;
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "use local space"
	bool m_bLocalSpace;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters;
	// MPropertyFriendlyName = "use new code"
	bool m_bUseNewCode;
};
