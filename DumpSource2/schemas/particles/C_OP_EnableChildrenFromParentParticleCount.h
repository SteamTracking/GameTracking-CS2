// MHasKV3TransferPolymorphicClassname
class C_OP_EnableChildrenFromParentParticleCount : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID;
	// MPropertyFriendlyName = "first child to enable"
	int32 m_nFirstChild;
	// MPropertyFriendlyName = "max # of children to enable (-1 for max particle count)"
	CParticleCollectionFloatInput m_nNumChildrenToEnable; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "remove children when particle count lowers"
	bool m_bDisableChildren;
	// MPropertyFriendlyName = "play endcap when children are removed"
	// MPropertySuppressExpr = "!m_bDisableChildren"
	bool m_bPlayEndcapOnStop; // = true
	// MPropertyFriendlyName = "destroy particles immediately when child is removed"
	// MPropertySuppressExpr = "!m_bDisableChildren"
	bool m_bDestroyImmediately;
};
