// MParticleMinVersion = 9
// MHasKV3TransferPolymorphicClassname
class C_OP_InheritFromParentParticlesV2 : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "scale"
	CPerParticleFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "inherited field"
	// MPropertyAttributeChoiceName = "particlefield"
	ParticleAttributeIndex_t m_nFieldOutput; // = 3
	// MPropertyFriendlyName = "particle increment amount"
	CPerParticleFloatInput m_nIncrement; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "sub-sample parent particles"
	bool m_bSubSample;
	// MPropertyFriendlyName = "random parent particle distribution"
	bool m_bRandomDistribution;
	// MPropertyFriendlyName = "start at last parent particle in reverse"
	bool m_bReverse;
	// MPropertyFriendlyName = "behavior if parent particle dies"
	MissingParentInheritBehavior_t m_nMissingParentBehavior; // = "MISSING_PARENT_DO_NOTHING"
	// MPropertyFriendlyName = "Interpolation"
	CPerParticleFloatInput m_flInterpolation; // = { "m_flLiteralValue": 1 }
};
