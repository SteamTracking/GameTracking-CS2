// MHasKV3TransferPolymorphicClassname
class C_OP_LerpToOtherAttribute : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "input attribute from"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldInputFrom; // = 19
	// MPropertyFriendlyName = "input attribute to"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldInput;
	// MPropertyFriendlyName = "output attribute"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldOutput;
};
