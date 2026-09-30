// MHasKV3TransferPolymorphicClassname
class C_OP_OscillateScalarSimple : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "oscillation rate"
	float32 m_Rate;
	// MPropertyFriendlyName = "oscillation frequency"
	float32 m_Frequency; // = 1
	// MPropertyFriendlyName = "oscillation field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nField; // = 7
	// MPropertyFriendlyName = "oscillation multiplier"
	float32 m_flOscMult; // = 2
	// MPropertyFriendlyName = "oscillation start phase"
	float32 m_flOscAdd; // = 0.5
};
