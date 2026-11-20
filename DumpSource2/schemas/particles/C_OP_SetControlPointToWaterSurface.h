// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointToWaterSurface : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "source CP"
	int32 m_nSourceCP;
	// MPropertyFriendlyName = "CP to set to surface"
	int32 m_nDestCP;
	// MPropertyFriendlyName = "CP to set to surface current flow velocity"
	// MPropertySuppressExpr = "mod != hlx"
	int32 m_nFlowCP; // = -1
	// MPropertyFriendlyName = "CP to set component of if water"
	int32 m_nActiveCP; // = -1
	// MPropertyFriendlyName = "CP component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nActiveCPField;
	// MPropertyFriendlyName = "retest rate"
	CParticleCollectionFloatInput m_flRetestRate; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "adaptive retest on moving surface"
	bool m_bAdaptiveThreshold;
};
