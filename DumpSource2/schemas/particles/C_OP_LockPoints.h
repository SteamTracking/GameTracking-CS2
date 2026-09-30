// MHasKV3TransferPolymorphicClassname
class C_OP_LockPoints : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "min column/particle index to affect"
	int32 m_nMinCol;
	// MPropertyFriendlyName = "max column/particle index to affect"
	int32 m_nMaxCol;
	// MPropertyFriendlyName = "min row/particle index to affect"
	int32 m_nMinRow;
	// MPropertyFriendlyName = "max row/particle index to affect"
	int32 m_nMaxRow;
	// MPropertyFriendlyName = "control point to lock to"
	int32 m_nControlPoint;
	// MPropertyFriendlyName = "amount of current position to preserve"
	float32 m_flBlendValue;
};
