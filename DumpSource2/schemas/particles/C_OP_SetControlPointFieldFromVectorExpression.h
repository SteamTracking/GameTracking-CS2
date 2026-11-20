// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointFieldFromVectorExpression : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "expression"
	VectorFloatExpressionType_t m_nExpression; // = "VECTOR_FLOAT_EXPRESSION_DOTPRODUCT"
	// MPropertyFriendlyName = "input 1"
	CParticleCollectionVecInput m_vecInput1;
	// MPropertyFriendlyName = "input 2"
	CParticleCollectionVecInput m_vecInput2;
	// MPropertyFriendlyName = "lerp value"
	// MPropertySuppressExpr = "m_nExpression != VECTOR_EXPRESSION_LERP"
	CPerParticleFloatInput m_flLerp;
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputCP; // = 2
	// MPropertyFriendlyName = "output component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutVectorField;
};
