// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointFieldToWater : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "source CP"
	int32 m_nSourceCP;
	// MPropertyFriendlyName = "dest CP"
	int32 m_nDestCP;
	// MPropertyFriendlyName = "dest control point component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPField;
};
