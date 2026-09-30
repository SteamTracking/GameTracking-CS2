// MHasKV3TransferPolymorphicClassname
class C_OP_RampScalarSpline : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "ramp rate min"
	float32 m_RateMin;
	// MPropertyFriendlyName = "ramp rate max"
	float32 m_RateMax;
	// MPropertyFriendlyName = "start time min"
	float32 m_flStartTime_min;
	// MPropertyFriendlyName = "start time max"
	float32 m_flStartTime_max;
	// MPropertyFriendlyName = "end time min"
	float32 m_flEndTime_min; // = 1
	// MPropertyFriendlyName = "end time max"
	float32 m_flEndTime_max; // = 1
	// MPropertyFriendlyName = "bias"
	float32 m_flBias; // = 0.5
	// MPropertyFriendlyName = "ramp field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nField; // = 3
	// MPropertyFriendlyName = "start/end proportional"
	bool m_bProportionalOp; // = true
	// MPropertyFriendlyName = "ease out"
	bool m_bEaseOut;
};
