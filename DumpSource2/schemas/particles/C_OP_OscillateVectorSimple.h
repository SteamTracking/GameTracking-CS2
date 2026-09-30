// MHasKV3TransferPolymorphicClassname
class C_OP_OscillateVectorSimple : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "oscillation rate"
	// MVectorIsSometimesCoordinate = "m_nField"
	Vector m_Rate;
	// MPropertyFriendlyName = "oscillation frequency"
	Vector m_Frequency; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "oscillation field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nField;
	// MPropertyFriendlyName = "oscillation multiplier"
	float32 m_flOscMult; // = 2
	// MPropertyFriendlyName = "oscillation start phase"
	float32 m_flOscAdd; // = 0.5
	// MPropertyFriendlyName = "offset instead of accelerate position"
	bool m_bOffset;
};
