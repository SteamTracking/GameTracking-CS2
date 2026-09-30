// MParticleMaxVersion = 7
// MParticleReplacementOp = "C_OP_LockToSavedSequentialPathV2"
// MHasKV3TransferPolymorphicClassname
class C_OP_LockToSavedSequentialPath : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "start fade time"
	float32 m_flFadeStart; // = 1
	// MPropertyFriendlyName = "end fade time"
	float32 m_flFadeEnd; // = 1
	// MPropertyFriendlyName = "Use sequential CP pairs between start and end point"
	bool m_bCPPairs;
	CPathParameters m_PathParams; // = { "m_flBulge": 0, "m_flMidPoint": 0.5, "m_nBulgeControl": 0, "m_nEndControlPointNumber": 0, "m_nMidControlPointNumber": -1, "m_nStartControlPointNumber": 0, "m_vEndOffset": [ 0, 0, 0 ], "m_vMidPointOffset": [ 0, 0, 0 ], "m_vStartPointOffset": [ 0, 0, 0 ] }
};
