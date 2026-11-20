// MHasKV3TransferPolymorphicClassname
class C_OP_ChooseRandomChildrenInGroup : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID; // = 1
	// MPropertyFriendlyName = "Number of Children to Use"
	CParticleCollectionFloatInput m_flNumberOfChildren; // = { "m_flLiteralValue": 1 }
};
