// MHasKV3TransferPolymorphicClassname
class C_OP_SetVariable : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "Variable"
	CParticleVariableRef m_variableReference;
	// MPropertyFriendlyName = "Value"
	// MPropertySuppressExpr = "m_variableReference.m_variableType != PVAL_TRANSFORM"
	CParticleTransformInput m_transformInput;
	// MPropertyFriendlyName = "Position Offset"
	// MPropertySuppressExpr = "m_variableReference.m_variableType != PVAL_TRANSFORM"
	Vector m_positionOffset;
	// MPropertyFriendlyName = "Rotation Offset"
	// MPropertySuppressExpr = "m_variableReference.m_variableType != PVAL_TRANSFORM"
	QAngle m_rotationOffset;
	// MPropertyFriendlyName = "Value"
	// MPropertySuppressExpr = "m_variableReference.m_variableType != PVAL_VEC3"
	CParticleCollectionVecInput m_vecInput;
	// MPropertyFriendlyName = "Value"
	// MPropertySuppressExpr = "m_variableReference.m_variableType != PVAL_FLOAT"
	CParticleCollectionFloatInput m_floatInput;
};
