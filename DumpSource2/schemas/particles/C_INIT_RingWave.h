// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_RingWave : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "input transform"
	CParticleTransformInput m_TransformInput;
	// MPropertyFriendlyName = "even distribution count"
	CParticleCollectionFloatInput m_flParticlesPerOrbit; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "initial radius"
	CPerParticleFloatInput m_flInitialRadius;
	// MPropertyFriendlyName = "thickness"
	CPerParticleFloatInput m_flThickness;
	// MPropertyFriendlyName = "min initial speed"
	CPerParticleFloatInput m_flInitialSpeedMin;
	// MPropertyFriendlyName = "max initial speed"
	CPerParticleFloatInput m_flInitialSpeedMax;
	// MPropertyFriendlyName = "roll"
	CPerParticleFloatInput m_flRoll;
	// MPropertyFriendlyName = "pitch"
	CPerParticleFloatInput m_flPitch;
	// MPropertyFriendlyName = "yaw"
	CPerParticleFloatInput m_flYaw;
	// MPropertyFriendlyName = "even distribution"
	bool m_bEvenDistribution;
	// MPropertyFriendlyName = "XY velocity only"
	bool m_bXYVelocityOnly; // = true
};
