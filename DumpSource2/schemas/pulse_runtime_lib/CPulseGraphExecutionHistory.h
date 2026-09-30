class CPulseGraphExecutionHistory
{
	PulseGraphInstanceID_t m_nInstanceID;
	CUtlString m_strFileName;
	CUtlVector< PulseGraphExecutionHistoryEntry_t* > m_vecHistory;
	CUtlOrderedMap< PulseDocNodeID_t, PulseGraphExecutionHistoryNodeDesc_t* > m_mapCellDesc;
	CUtlOrderedMap< PulseCursorID_t, PulseGraphExecutionHistoryCursorDesc_t* > m_mapCursorDesc;
};
