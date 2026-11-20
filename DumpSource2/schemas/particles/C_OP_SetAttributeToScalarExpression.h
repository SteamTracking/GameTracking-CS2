// MHasKV3TransferPolymorphicClassname
class C_OP_SetAttributeToScalarExpression : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "expression"
	ScalarExpressionType_t m_nExpression; // = "SCALAR_EXPRESSION_ADD"
	// MPropertyFriendlyName = "input 1"
	CPerParticleFloatInput m_flInput1;
	// MPropertyFriendlyName = "input 2"
	CPerParticleFloatInput m_flInput2;
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
