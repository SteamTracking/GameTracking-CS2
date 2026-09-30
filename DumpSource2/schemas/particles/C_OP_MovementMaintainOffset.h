// MHasKV3TransferPolymorphicClassname
class C_OP_MovementMaintainOffset : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "desired offset"
	// MVectorIsCoordinate
	Vector m_vecOffset;
	// MPropertyFriendlyName = "local space CP"
	int32 m_nCP; // = -1
	// MPropertyFriendlyName = "scale by radius"
	bool m_bRadiusScale;
};
