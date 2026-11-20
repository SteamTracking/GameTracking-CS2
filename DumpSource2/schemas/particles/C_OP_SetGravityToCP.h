// MHasKV3TransferPolymorphicClassname
class C_OP_SetGravityToCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point to sample gravity"
	int32 m_nCPInput;
	// MPropertyFriendlyName = "output control point"
	int32 m_nCPOutput; // = 1
	// MPropertyFriendlyName = "gravity scale"
	CParticleCollectionFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "set position to gravity vector"
	bool m_bSetPosition; // = true
	// MPropertyFriendlyName = "set orientation"
	bool m_bSetOrientation; // = true
	// MPropertyFriendlyName = "set gravity orientation to Z Down (instead of X)"
	// MPropertySuppressExpr = "!m_bSetOrientation"
	bool m_bSetZDown; // = true
};
