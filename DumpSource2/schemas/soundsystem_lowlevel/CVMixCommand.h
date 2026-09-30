class CVMixCommand
{
	// MKV3TransferName = "command"
	VMixGraphCommandID_t m_nCommand; // = "CMD_INVALID"
	// MKV3TransferName = "paramName"
	uint32 m_nParameterNameHash;
	// MKV3TransferName = "outputSubmix"
	CVMixDataOffset m_nOutputSubmix; // = { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" }
	// MKV3TransferName = "inputSubmix0"
	CVMixDataOffset m_nInputSubmix0; // = { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" }
	// MKV3TransferName = "inputSubmix1"
	CVMixDataOffset m_nInputSubmix1; // = { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" }
	// MKV3TransferName = "processor"
	int32 m_nProcessor; // = -1
	CVMixDataOffset m_nInputValue0; // = { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" }
	CVMixDataOffset m_nInputValue1; // = { "category": "NULL_POINTER", "index": 0, "type": "VO_CHAR" }
};
