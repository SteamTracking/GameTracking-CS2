// MHasKV3TransferPolymorphicClassname
class C_OP_OscillateVector : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "oscillation rate min"
	// MVectorIsSometimesCoordinate = "m_nField"
	Vector m_RateMin;
	// MPropertyFriendlyName = "oscillation rate max"
	// MVectorIsSometimesCoordinate = "m_nField"
	Vector m_RateMax;
	// MPropertyFriendlyName = "oscillation frequency min"
	// MVectorIsSometimesCoordinate = "m_nField"
	Vector m_FrequencyMin; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "oscillation frequency max"
	// MVectorIsSometimesCoordinate = "m_nField"
	Vector m_FrequencyMax; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "oscillation field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nField;
	// MPropertyFriendlyName = "proportional 0/1"
	bool m_bProportional; // = true
	// MPropertyFriendlyName = "start/end proportional"
	bool m_bProportionalOp; // = true
	// MPropertyFriendlyName = "offset instead of accelerate position"
	bool m_bOffset;
	// MPropertyFriendlyName = "start time min"
	float32 m_flStartTime_min;
	// MPropertyFriendlyName = "start time max"
	float32 m_flStartTime_max;
	// MPropertyFriendlyName = "end time min"
	float32 m_flEndTime_min; // = 1
	// MPropertyFriendlyName = "end time max"
	float32 m_flEndTime_max; // = 1
	// MPropertyFriendlyName = "oscillation multiplier"
	CPerParticleFloatInput m_flOscMult; // = { "m_flLiteralValue": 2 }
	// MPropertyFriendlyName = "oscillation start phase"
	CPerParticleFloatInput m_flOscAdd; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "rate scale"
	CPerParticleFloatInput m_flRateScale; // = { "m_flLiteralValue": 1 }
};
