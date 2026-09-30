// MHasKV3TransferPolymorphicClassname
class C_OP_RestartAfterDuration : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "minimum restart time"
	float32 m_flDurationMin;
	// MPropertyFriendlyName = "maximum restart time"
	float32 m_flDurationMax; // = 1
	// MPropertyFriendlyName = "control point to scale duration"
	int32 m_nCP; // = -1
	// MPropertyFriendlyName = "control point field X/Y/Z"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPField;
	// MPropertyFriendlyName = "child group ID"
	int32 m_nChildGroupID;
	// MPropertyFriendlyName = "only restart children"
	bool m_bOnlyChildren;
};
