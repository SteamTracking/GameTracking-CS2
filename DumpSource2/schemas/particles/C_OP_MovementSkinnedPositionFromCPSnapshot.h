// MHasKV3TransferPolymorphicClassname
class C_OP_MovementSkinnedPositionFromCPSnapshot : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nSnapshotControlPointNumber; // = 1
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "random order"
	bool m_bRandom;
	// MPropertyFriendlyName = "random seed"
	int32 m_nRandomSeed;
	// MPropertyFriendlyName = "set normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "set radius"
	bool m_bSetRadius;
	// MPropertyFriendlyName = "Snapshot Read Type"
	SnapshotIndexType_t m_nIndexType; // = "SNAPSHOT_INDEX_INCREMENT"
	// MPropertyFriendlyName = "Snapshot Index"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_DIRECT"
	CPerParticleFloatInput m_flReadIndex;
	// MPropertyFriendlyName = "particle increment amount"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	CParticleCollectionFloatInput m_flIncrement; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Full Loop Increment Amount"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	CParticleCollectionFloatInput m_nFullLoopIncrement;
	// MPropertyFriendlyName = "Snapshot start point"
	// MPropertySuppressExpr = "m_nIndexType != SNAPSHOT_INDEX_INCREMENT"
	CParticleCollectionFloatInput m_nSnapShotStartPoint;
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
