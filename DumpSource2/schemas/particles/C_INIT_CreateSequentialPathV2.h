// MParticleMinVersion = 8
// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateSequentialPathV2 : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "maximum distance"
	CPerParticleFloatInput m_fMaxDistance;
	// MPropertyFriendlyName = "particles to map from start to end"
	CParticleCollectionFloatInput m_flNumToAssign; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "restart behavior (0 = bounce, 1 = loop )"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "use sequential CP pairs between start and end point"
	bool m_bCPPairs;
	// MPropertyFriendlyName = "save offset"
	bool m_bSaveOffset;
	CPathParameters m_PathParams;
};
