// MHasKV3TransferPolymorphicClassname
class C_OP_RemapVisibilityScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "input field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldInput; // = 7
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "visibility minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "visibility maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "radius scale"
	float32 m_flRadiusScale; // = 1
};
