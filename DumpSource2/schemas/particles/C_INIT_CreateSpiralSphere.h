// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateSpiralSphere : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "input position transform"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "density"
	CPerParticleFloatInput m_flDensity;
	// MPropertyFriendlyName = "initial radius"
	CPerParticleFloatInput m_flInitialRadius;
	// MPropertyFriendlyName = "min initial speed"
	CPerParticleFloatInput m_flInitialSpeedMin;
	// MPropertyFriendlyName = "max initial speed"
	CPerParticleFloatInput m_flInitialSpeedMax;
	// MPropertyFriendlyName = "use particle count as density scale"
	bool m_bUseParticleCount;
};
