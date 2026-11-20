// MHasKV3TransferPolymorphicClassname
class C_OP_SpringToVectorConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "slack"
	CPerParticleFloatInput m_flRestLength; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "minimum segment length %"
	CPerParticleFloatInput m_flMinDistance;
	// MPropertyFriendlyName = "maximum segment length %"
	CPerParticleFloatInput m_flMaxDistance; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "resting spacing"
	CPerParticleFloatInput m_flRestingLength; // = { "m_flLiteralValue": 64 }
	// MPropertyFriendlyName = "anchor vector"
	CPerParticleVecInput m_vecAnchorVector;
};
