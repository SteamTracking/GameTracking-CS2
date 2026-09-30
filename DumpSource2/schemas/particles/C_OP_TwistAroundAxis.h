// MHasKV3TransferPolymorphicClassname
class C_OP_TwistAroundAxis : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "amount of force"
	float32 m_fForceAmount;
	// MPropertyFriendlyName = "twist axis"
	// MVectorIsCoordinate
	Vector m_TwistAxis; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "object local space axis 0/1"
	bool m_bLocalSpace;
	// MPropertyFriendlyName = "control point"
	int32 m_nControlPointNumber;
};
