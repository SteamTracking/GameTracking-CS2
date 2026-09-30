// MHasKV3TransferPolymorphicClassname
class C_OP_GlobalLight : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "initial color bias"
	float32 m_flScale;
	// MPropertyFriendlyName = "clamp minimum light value to initial color"
	bool m_bClampLowerRange;
	// MPropertyFriendlyName = "clamp maximum light value to initial color"
	bool m_bClampUpperRange;
};
