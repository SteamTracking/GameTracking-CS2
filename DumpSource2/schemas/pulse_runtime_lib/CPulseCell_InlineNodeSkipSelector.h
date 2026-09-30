// MPulseFunctionHiddenInTool
// MHasKV3TransferPolymorphicClassname
class CPulseCell_InlineNodeSkipSelector : public CPulseCell_BaseFlow
{
	PulseDocNodeID_t m_nFlowNodeID; // = -1
	bool m_bAnd;
	PulseSelectorOutflowList_t m_PassOutflow;
	CPulse_OutflowConnection m_FailOutflow; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
