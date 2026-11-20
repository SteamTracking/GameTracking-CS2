// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_VelocityRandom : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "random speed min"
	CPerParticleFloatInput m_fSpeedMin;
	// MPropertyFriendlyName = "random speed max"
	CPerParticleFloatInput m_fSpeedMax;
	// MPropertyFriendlyName = "speed in local coordinate system min"
	// MVectorIsCoordinate
	CPerParticleVecInput m_LocalCoordinateSystemSpeedMin;
	// MPropertyFriendlyName = "speed in local coordinate system max"
	// MVectorIsCoordinate
	CPerParticleVecInput m_LocalCoordinateSystemSpeedMax;
	// MPropertyFriendlyName = "Ignore delta time (RenderTrails)"
	bool m_bIgnoreDT;
	// MPropertyFriendlyName = "Random number generator controls"
	CRandomNumberGeneratorParameters m_randomnessParameters;
};
