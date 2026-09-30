class OutflowWithRequirements_t
{
	CPulse_OutflowConnection m_Connection; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	PulseDocNodeID_t m_DestinationFlowNodeID; // = -1
	CUtlVector< PulseDocNodeID_t > m_RequirementNodeIDs;
	CUtlVector< int32 > m_nCursorStateBlockIndex;
};
