// MHasKV3TransferPolymorphicClassname
class C_OP_RopeSpringConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "slack"
	CParticleCollectionFloatInput m_flRestLength; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "minimum segment length %"
	CParticleCollectionFloatInput m_flMinDistance; // = { "m_flLiteralValue": 0.9 }
	// MPropertyFriendlyName = "maximum segment length %"
	CParticleCollectionFloatInput m_flMaxDistance; // = { "m_flLiteralValue": 1.1 }
	// MPropertyFriendlyName = "scale factor for spring correction"
	float32 m_flAdjustmentScale; // = 15
	// MPropertyFriendlyName = "manual resting spacing"
	CParticleCollectionFloatInput m_flInitialRestingLength; // = { "m_flLiteralValue": -1 }
};
