// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateFromParentParticles : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "inherited velocity scale"
	float32 m_flVelocityScale;
	// MPropertyFriendlyName = "particle increment amount"
	float32 m_flIncrement; // = 1
	// MPropertyFriendlyName = "random parent particle distribution"
	bool m_bRandomDistribution;
	// MPropertyFriendlyName = "random seed"
	int32 m_nRandomSeed;
	// MPropertyFriendlyName = "sub frame interpolation"
	bool m_bSubFrame; // = true
	// MPropertyFriendlyName = "set rope segment id"
	bool m_bSetRopeSegmentID;
};
