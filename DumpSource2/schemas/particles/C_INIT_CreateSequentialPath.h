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
	CPathParameters m_PathParams; // = { "m_flBulge": 0, "m_flMidPoint": 0.5, "m_nBulgeControl": 0, "m_nEndControlPointNumber": 0, "m_nMidControlPointNumber": -1, "m_nStartControlPointNumber": 0, "m_vEndOffset": [ 0, 0, 0 ], "m_vMidPointOffset": [ 0, 0, 0 ], "m_vStartPointOffset": [ 0, 0, 0 ] }
};
