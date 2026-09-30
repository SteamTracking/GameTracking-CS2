// MHasKV3TransferPolymorphicClassname
class C_OP_ParentVortices : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "amount of force"
	float32 m_flForceScale;
	// MPropertyFriendlyName = "twist axis"
	// MVectorIsCoordinate
	Vector m_vecTwistAxis; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "flip twist axis with yaw"
	bool m_bFlipBasedOnYaw;
};
