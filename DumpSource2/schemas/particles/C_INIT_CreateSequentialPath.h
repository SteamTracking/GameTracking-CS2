// MParticleMaxVersion = 7
// MParticleReplacementOp = "C_INIT_CreateSequentialPathV2"
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateSequentialPath : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "maximum distance"
	float32 m_fMaxDistance;
	// MPropertyFriendlyName = "particles to map from start to end"
	float32 m_flNumToAssign; // = 100
	// MPropertyFriendlyName = "restart behavior (0 = bounce, 1 = loop )"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "use sequential CP pairs between start and end point"
	bool m_bCPPairs;
	// MPropertyFriendlyName = "save offset"
	bool m_bSaveOffset;
	CPathParameters m_PathParams;
};
