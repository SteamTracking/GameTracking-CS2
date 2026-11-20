// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_SetFloat : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "value"
	CPerParticleFloatInput m_InputValue;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
	// MPropertyFriendlyName = "interpolation"
	CPerParticleFloatInput m_Lerp; // = { "m_flLiteralValue": 1 }
};
