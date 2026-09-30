class PulseGraphExecutionHistoryCursorDesc_t
{
	CUtlVector< PulseCursorID_t > vecAncestorCursorIDs;
	PulseDocNodeID_t nSpawnNodeID; // = -1
	PulseDocNodeID_t nRetiredAtNodeID; // = -1
	float32 flLastReferenced;
	int32 nLastValidEntryIdx;
	bool bWasAnObservableComputation;
};
