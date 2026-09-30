// MHasKV3TransferPolymorphicClassname
class C_OP_VelocityMatchingForce : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "direction matching strength"
	float32 m_flDirScale; // = 0.25
	// MPropertyFriendlyName = "speed matching strength"
	float32 m_flSpdScale; // = 0.25
	// MPropertyFriendlyName = "neighbor distance"
	float32 m_flNeighborDistance; // = -1
	// MPropertyFriendlyName = "facing strength falloff"
	float32 m_flFacingStrength; // = 1
	// MPropertyFriendlyName = "use AABB"
	// MPropertySuppressExpr = "m_flNeighborDistance > 0"
	bool m_bUseAABB;
	// MPropertyFriendlyName = "control point to broadcast speed and direction to"
	int32 m_nCPBroadcast; // = -1
};
