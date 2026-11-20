// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToVectorExpression : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "expression"
	VectorExpressionType_t m_nExpression; // = "VECTOR_EXPRESSION_ADD"
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputCP; // = 2
	// MPropertyFriendlyName = "input 1"
	CParticleCollectionVecInput m_vInput1;
	// MPropertyFriendlyName = "input 2"
	CParticleCollectionVecInput m_vInput2;
	// MPropertyFriendlyName = "lerp value"
	// MPropertySuppressExpr = "m_nExpression != VECTOR_EXPRESSION_LERP"
	CPerParticleFloatInput m_flLerp;
	// MPropertyFriendlyName = "normalize result"
	bool m_bNormalizedOutput;
};
