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
	CPathParameters m_PathParams;
};
