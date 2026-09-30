// MHasKV3TransferPolymorphicClassname
class C_OP_RampCPLinearRandom : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = 1
	// MPropertyFriendlyName = "ramp rate min"
	Vector m_vecRateMin;
	// MPropertyFriendlyName = "ramp rate max"
	Vector m_vecRateMax;
};
