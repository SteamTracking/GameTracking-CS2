// MHasKV3TransferPolymorphicClassname
class C_OP_StopAfterCPDuration : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "duration at which to stop"
	CParticleCollectionFloatInput m_flDuration; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "destroy all particles immediately"
	bool m_bDestroyImmediately;
	// MPropertyFriendlyName = "play end cap effect"
	bool m_bPlayEndCap; // = true
};
