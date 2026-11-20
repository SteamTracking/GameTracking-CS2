// MHasKV3TransferPolymorphicClassname
class C_OP_RemapExternalWindToCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point to sample wind"
	int32 m_nCP;
	// MPropertyFriendlyName = "output control point"
	int32 m_nCPOutput; // = 1
	// MPropertyFriendlyName = "wind scale"
	CParticleCollectionVecInput m_vecScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "set magnitude instead of vector"
	bool m_bSetMagnitude;
	// MPropertyFriendlyName = "magnitude output component"
	// MPropertyAttributeChoiceName = "vector_component"
	// MPropertySuppressExpr = "!m_bSetMagnitude"
	int32 m_nOutVectorField;
};
