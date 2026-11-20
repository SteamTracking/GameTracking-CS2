// MHasKV3TransferPolymorphicClassname
class C_OP_RepeatedTriggerChildGroup : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "group ID to affect"
	int32 m_nChildGroupID; // = 1
	// MPropertyFriendlyName = "Within-Cluster Refire Time"
	CParticleCollectionFloatInput m_flClusterRefireTime;
	// MPropertyFriendlyName = "Within-Cluster Fire Count Before Cooldown"
	CParticleCollectionFloatInput m_flClusterSize;
	// MPropertyFriendlyName = "Cluster Cooldown Time"
	CParticleCollectionFloatInput m_flClusterCooldown;
	// MPropertyFriendlyName = "limit active children to parent particle count"
	bool m_bLimitChildCount;
};
