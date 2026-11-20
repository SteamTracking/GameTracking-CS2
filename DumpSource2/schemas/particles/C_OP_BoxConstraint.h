// MHasKV3TransferPolymorphicClassname
class C_OP_BoxConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "min coords"
	CParticleCollectionVecInput m_vecMin;
	// MPropertyFriendlyName = "max coords"
	CParticleCollectionVecInput m_vecMax;
	// MPropertyFriendlyName = "control point"
	int32 m_nCP;
	// MPropertyFriendlyName = "use local space"
	bool m_bLocalSpace;
	// MPropertyFriendlyName = "Take radius into account"
	bool m_bAccountForRadius;
};
