// MHasKV3TransferPolymorphicClassname
class C_OP_SetToCP : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "offset"
	Vector m_vecOffset;
	// MPropertyFriendlyName = "offset in local space"
	bool m_bOffsetLocal;
};
