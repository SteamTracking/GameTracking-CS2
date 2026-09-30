class CPulse_CallInfo
{
	PulseSymbol_t m_PortName;
	PulseDocNodeID_t m_nEditorNodeID; // = -1
	PulseRegisterMap_t m_RegisterMap;
	PulseDocNodeID_t m_CallMethodID; // = -1
	PulseRuntimeChunkIndex_t m_nSrcChunk; // = -1
	int32 m_nSrcInstruction; // = -1
	PulseRuntimeChunkIndex_t m_nBreakDestChunk; // = -1
	int32 m_nBreakDestInstruction; // = -1
};
