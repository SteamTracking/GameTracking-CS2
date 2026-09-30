// MHasKV3TransferPolymorphicClassname
class C_OP_Cull : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "cull percentage"
	float32 m_flCullPerc; // = 0.5
	// MPropertyFriendlyName = "cull start time"
	float32 m_flCullStart;
	// MPropertyFriendlyName = "cull end time"
	float32 m_flCullEnd; // = 1
	// MPropertyFriendlyName = "cull time exponent"
	float32 m_flCullExp; // = 1
};
