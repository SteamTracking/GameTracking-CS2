// MHasKV3TransferPolymorphicClassname
class C_OP_TimeVaryingForce : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "time to start transition"
	float32 m_flStartLerpTime;
	// MPropertyFriendlyName = "starting force"
	// MVectorIsCoordinate
	Vector m_StartingForce;
	// MPropertyFriendlyName = "time to end transition"
	float32 m_flEndLerpTime; // = 10
	// MPropertyFriendlyName = "ending force"
	// MVectorIsCoordinate
	Vector m_EndingForce;
};
