// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_SetVec : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "value"
	CPerParticleVecInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nOutputField; // = 6
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "interpolation"
	CPerParticleFloatInput m_Lerp; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "normalize result"
	bool m_bNormalizedOutput;
};
