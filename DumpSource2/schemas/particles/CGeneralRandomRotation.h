// MHasKV3TransferPolymorphicClassname
class CGeneralRandomRotation : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "rotation field"
	// MPropertyAttributeChoiceName = "particlefield_rotation"
	ParticleAttributeIndex_t m_nFieldOutput;
	// MPropertyFriendlyName = "rotation initial"
	float32 m_flDegrees;
	// MPropertyFriendlyName = "rotation offset from initial min"
	float32 m_flDegreesMin;
	// MPropertyFriendlyName = "rotation offset from initial max"
	float32 m_flDegreesMax;
	// MPropertyFriendlyName = "rotation offset exponent"
	float32 m_flRotationRandExponent;
	// MPropertyFriendlyName = "randomly flip direction"
	bool m_bRandomlyFlipDirection;
};
