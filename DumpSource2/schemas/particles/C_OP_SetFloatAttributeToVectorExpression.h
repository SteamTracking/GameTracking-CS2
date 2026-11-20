// MHasKV3TransferPolymorphicClassname
class C_OP_SetFloatAttributeToVectorExpression : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "expression"
	VectorFloatExpressionType_t m_nExpression; // = "VECTOR_FLOAT_EXPRESSION_DOTPRODUCT"
	// MPropertyFriendlyName = "input 1"
	CPerParticleVecInput m_vInput1;
	// MPropertyFriendlyName = "input 2"
	CPerParticleVecInput m_vInput2;
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nOutputField; // = 3
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod; // = "PARTICLE_SET_REPLACE_VALUE"
};
