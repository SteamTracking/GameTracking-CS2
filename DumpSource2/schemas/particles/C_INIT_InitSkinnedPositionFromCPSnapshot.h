// MHasKV3TransferPolymorphicClassname
class C_INIT_InitSkinnedPositionFromCPSnapshot : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nSnapshotControlPointNumber; // = 1
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "random order"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	bool m_bRandom;
	// MPropertyFriendlyName = "random seed"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	int32 m_nRandomSeed;
	// MPropertyFriendlyName = "prepare for rigid lock"
	bool m_bRigid;
	// MPropertyFriendlyName = "set normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "normal velocity ignore delta time"
	bool m_bIgnoreDt;
	// MPropertyFriendlyName = "normal velocity min"
	float32 m_flMinNormalVelocity;
	// MPropertyFriendlyName = "normal velocity max"
	float32 m_flMaxNormalVelocity;
	// MPropertyFriendlyName = "Snapshot Read Type"
	SnapshotIndexType_t m_nIndexType; // = "SNAPSHOT_INDEX_INCREMENT"
	// MPropertyFriendlyName = "Snapshot Index"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_DIRECT"
	CPerParticleFloatInput m_flReadIndex;
	// MPropertyFriendlyName = "particle increment amount"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	float32 m_flIncrement; // = 1
	// MPropertyFriendlyName = "Full Loop Increment Amount"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	int32 m_nFullLoopIncrement;
	// MPropertyFriendlyName = "Snapshot start point"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	int32 m_nSnapShotStartPoint;
	// MPropertyFriendlyName = "inherited bone velocity"
	float32 m_flBoneVelocity;
	// MPropertyFriendlyName = "max inherited bone velocity"
	float32 m_flBoneVelocityMax;
	// MPropertyFriendlyName = "Set Color"
	bool m_bCopyColor;
	// MPropertyFriendlyName = "Set Alpha"
	bool m_bCopyAlpha;
	// MPropertyFriendlyName = "Set Radius"
	bool m_bSetRadius;
};
