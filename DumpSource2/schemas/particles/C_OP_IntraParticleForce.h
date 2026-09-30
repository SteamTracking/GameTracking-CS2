// MHasKV3TransferPolymorphicClassname
class C_OP_IntraParticleForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "min attraction distance"
	float32 m_flAttractionMinDistance;
	// MPropertyFriendlyName = "max attraction distance"
	float32 m_flAttractionMaxDistance; // = 1
	// MPropertyFriendlyName = "max attraction force"
	float32 m_flAttractionMaxStrength;
	// MPropertyFriendlyName = "min repulsion distance"
	float32 m_flRepulsionMinDistance; // = 2
	// MPropertyFriendlyName = "max repulsion distance"
	float32 m_flRepulsionMaxDistance; // = 4
	// MPropertyFriendlyName = "max repulsion force"
	float32 m_flRepulsionMaxStrength;
	// MPropertyFriendlyName = "use aabbtree"
	bool m_bUseAABB; // = true
};
