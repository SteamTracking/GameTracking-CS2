// MHasKV3TransferPolymorphicClassname
class C_OP_OscillateScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "oscillation rate min"
	float32 m_RateMin;
	// MPropertyFriendlyName = "oscillation rate max"
	float32 m_RateMax;
	// MPropertyFriendlyName = "oscillation frequency min"
	float32 m_FrequencyMin; // = 1
	// MPropertyFriendlyName = "oscillation frequency max"
	float32 m_FrequencyMax; // = 1
	// MPropertyFriendlyName = "oscillation field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nField; // = 7
	// MPropertyFriendlyName = "proportional 0/1"
	bool m_bProportional; // = true
	// MPropertyFriendlyName = "start/end proportional"
	bool m_bProportionalOp; // = true
	// MPropertyFriendlyName = "start time min"
	float32 m_flStartTime_min;
	// MPropertyFriendlyName = "start time max"
	float32 m_flStartTime_max;
	// MPropertyFriendlyName = "end time min"
	float32 m_flEndTime_min; // = 1
	// MPropertyFriendlyName = "end time max"
	float32 m_flEndTime_max; // = 1
	// MPropertyFriendlyName = "oscillation multiplier"
	float32 m_flOscMult; // = 2
	// MPropertyFriendlyName = "oscillation start phase"
	float32 m_flOscAdd; // = 0.5
};
