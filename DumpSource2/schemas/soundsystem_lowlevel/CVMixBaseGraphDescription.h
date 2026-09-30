class CVMixBaseGraphDescription
{
	// MKV3TransferName = "Name"
	CUtlString m_name;
	int32 m_nGraphOutputChannels; // = -1
	bool m_bIsMainGraph;
	// MKV3TransferName = "m_Processors"
	CUtlLeanVector< std::unique_ptr< CVMixBaseProcessorDesc > > m_processorNodes;
	CUtlLeanVector< CVMixGraphInput > m_graphInputs;
	CUtlLeanVector< CVMixControlInput > m_controlTransientInputs;
	CUtlLeanVector< CVMixControlOutput > m_controlOutputs;
	CUtlLeanVector< CVMixImpulseResponseInput > m_impulseResponseInputs;
	// MKV3TransferName = "m_MixCommands"
	CUtlLeanVector< CVMixCommand > m_mixCommands;
	CVMixHeap m_heap;
	CUtlLeanVector< CVMixAudioMeter > m_audioMeters;
	CUtlLeanVector< CVMixControlMeter > m_controlMeters;
	CUtlLeanVector< CVMixNameInputMeter > m_nameInputMeters;
	CUtlLeanVector< CVMixAdditionalOutput > m_additionalOutputs;
	CUtlLeanVector< CVMixAutomaticControlInput > m_automaticControlInputs;
};
