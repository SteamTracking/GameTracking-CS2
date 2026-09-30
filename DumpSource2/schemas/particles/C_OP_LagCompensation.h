// MHasKV3TransferPolymorphicClassname
class C_OP_LagCompensation : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "desired velocity CP"
	int32 m_nDesiredVelocityCP; // = -1
	// MPropertyFriendlyName = "latency CP"
	int32 m_nLatencyCP; // = -1
	// MPropertyFriendlyName = "latency CP field"
	int32 m_nLatencyCPField;
	// MPropertyFriendlyName = "desired velocity CP field override(for speed only)"
	int32 m_nDesiredVelocityCPField; // = -1
};
