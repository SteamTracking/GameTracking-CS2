// MHasKV3TransferPolymorphicClassname
class C_OP_RemapAverageScalarValuetoCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "expression type"
	SetStatisticExpressionType_t m_nExpression; // = "SET_EXPRESSION_MEAN"
	// MPropertyFriendlyName = "mode # of decimal places"
	// MPropertySuppressExpr = "m_nExpression != SET_EXPRESSION_MODE"
	CParticleCollectionFloatInput m_flDecimalPlaces; // = { "m_flLiteralValue": 2 }
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = 1
	// MPropertyFriendlyName = "output field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutVectorField;
	// MPropertyFriendlyName = "input attribute to evaluate"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nField; // = 3
	// MPropertyFriendlyName = "output"
	CParticleRemapFloatInput m_flOutputRemap;
};
