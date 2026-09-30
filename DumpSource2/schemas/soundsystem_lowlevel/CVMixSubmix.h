class CVMixSubmix
{
	CUtlString m_name;
	CUtlString[4] m_SendNames;
	uint32 m_nSoloNameHash;
	int32 m_nChannels; // = -1
	// MPropertyFriendlyName = "Send Operator"
	VMixSendOperator_t m_nSendOperator; // = "NAMED_SEND"
	VMixMixDownRule_t m_nMixDownRule; // = "SUM"
};
