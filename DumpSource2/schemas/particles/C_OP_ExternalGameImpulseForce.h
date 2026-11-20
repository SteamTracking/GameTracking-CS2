// MHasKV3TransferPolymorphicClassname
class C_OP_ExternalGameImpulseForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "force scale"
	CPerParticleFloatInput m_flForceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "rope shake"
	bool m_bRopes; // = true
	// MPropertyFriendlyName = "limit rope impulses to Z"
	bool m_bRopesZOnly; // = true
	// MPropertyFriendlyName = "explosions"
	bool m_bExplosions; // = true
	// MPropertyFriendlyName = "particle systems"
	bool m_bParticles; // = true
};
