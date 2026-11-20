// MHasKV3TransferPolymorphicClassname
class C_OP_DecayMaintainCount : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "count to maintain"
	int32 m_nParticlesToMaintain; // = 100
	// MPropertyFriendlyName = "decay delay"
	float32 m_flDecayDelay;
	// MPropertyFriendlyName = "snapshot control point for count"
	int32 m_nSnapshotControlPoint; // = -1
	// MPropertyFriendlyName = "snapshot subset"
	// MPropertySuppressExpr = "m_nSnapshotControlPoint < 0"
	CUtlString m_strSnapshotSubset;
	// MPropertyFriendlyName = "decay on lifespan"
	bool m_bLifespanDecay; // = true
	// MPropertyFriendlyName = "total count scale"
	CParticleCollectionFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "kill newest instead of oldest"
	bool m_bKillNewest;
};
