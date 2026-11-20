// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToCPVelocity : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point input"
	int32 m_nCPInput;
	// MPropertyFriendlyName = "control point number to set velocity"
	int32 m_nCPOutputVel; // = 1
	// MPropertyFriendlyName = "normalize output"
	bool m_bNormalize;
	// MPropertyFriendlyName = "control point number to set magnitude"
	int32 m_nCPOutputMag; // = -1
	// MPropertyFriendlyName = "control point field for magnitude"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPField;
	// MPropertyFriendlyName = "comparison velocity"
	CParticleCollectionVecInput m_vecComparisonVelocity;
};
