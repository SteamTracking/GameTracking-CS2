// MHasKV3TransferPolymorphicClassname
class C_OP_InheritFromPeerSystem : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "read field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "written field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldInput; // = 3
	// MPropertyFriendlyName = "particle neighbor increment amount"
	int32 m_nIncrement; // = 1
	// MPropertyFriendlyName = "group id"
	int32 m_nGroupID;
};
