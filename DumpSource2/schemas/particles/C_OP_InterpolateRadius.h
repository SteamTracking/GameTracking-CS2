// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_InterpolateRadius : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "start time"
	float32 m_flStartTime;
	// MPropertyFriendlyName = "end time"
	float32 m_flEndTime; // = 1
	// MPropertyFriendlyName = "radius start scale"
	float32 m_flStartScale; // = 1
	// MPropertyFriendlyName = "radius end scale"
	float32 m_flEndScale; // = 1
	// MPropertyFriendlyName = "ease in and out"
	bool m_bEaseInAndOut;
	// MPropertyFriendlyName = "scale bias"
	float32 m_flBias; // = 0.5
};
