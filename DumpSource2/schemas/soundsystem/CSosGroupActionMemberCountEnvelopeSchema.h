// MPropertyFriendlyName = "Count Envelope"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionMemberCountEnvelopeSchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Min Threshold Count"
	int32 m_nBaseCount;
	// MPropertyFriendlyName = "Max Target Count"
	int32 m_nTargetCount; // = 1
	// MPropertyFriendlyName = "Threshold Value"
	float32 m_flBaseValue;
	// MPropertyFriendlyName = "Target Value"
	float32 m_flTargetValue;
	// MPropertyFriendlyName = "Attack"
	float32 m_flAttack; // = 1
	// MPropertyFriendlyName = "Decay"
	float32 m_flDecay; // = 1
	// MPropertyFriendlyName = "Result Variable Name"
	CUtlString m_resultVarName; // = "envelope_result"
	// MPropertyFriendlyName = "Save Result to Group"
	bool m_bSaveToGroup;
};
