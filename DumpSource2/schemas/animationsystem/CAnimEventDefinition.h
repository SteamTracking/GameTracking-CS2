class CAnimEventDefinition
{
	int32 m_nFrame;
	int32 m_nEndFrame; // = -1
	float32 m_flCycle;
	float32 m_flDuration;
	KeyValues3 m_EventData;
	// MKV3TransferName = "m_sOptions"
	CBufferString m_sLegacyOptions;
	CGlobalSymbol m_sEventName;
};
