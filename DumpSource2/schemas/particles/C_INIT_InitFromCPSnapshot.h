// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_InitFromCPSnapshot : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "snapshot subset"
	// MPropertySuppressExpr = "m_nControlPointNumber < 0"
	CUtlString m_strSnapshotSubset;
	// MPropertyFriendlyName = "field to read"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nAttributeToRead; // = -1
	// MPropertyFriendlyName = "field to write"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nAttributeToWrite;
	// MPropertyFriendlyName = "local space control point number"
	int32 m_nLocalSpaceCP;
	// MPropertyFriendlyName = "random order"
	bool m_bRandom;
	// MPropertyFriendlyName = "reverse order"
	// MPropertySuppressExpr = "m_bRandom == true"
	bool m_bReverse;
	// MPropertyFriendlyName = "Snapshot increment amount"
	// MPropertySuppressExpr = "m_bRandom == true"
	CParticleCollectionFloatInput m_nSnapShotIncrement; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Manual Snapshot Index"
	// MPropertySuppressExpr = "m_bRandom == true"
	CPerParticleFloatInput m_nManualSnapshotIndex; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "random seed"
	// MPropertySuppressExpr = "m_bRandom == false"
	int32 m_nRandomSeed;
	// MPropertyFriendlyName = "local space angles"
	bool m_bLocalSpaceAngles;
};
