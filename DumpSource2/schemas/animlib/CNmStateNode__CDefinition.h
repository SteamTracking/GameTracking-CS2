// MHasKV3TransferPolymorphicClassname
class CNmStateNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nChildNodeIdx; // = -1
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 3 > m_entryEvents;
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 3 > m_executeEvents;
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 3 > m_exitEvents;
	CUtlLeanVectorFixedGrowable< CNmStateNode::TimedEvent_t, 1 > m_timedRemainingEvents;
	CUtlLeanVectorFixedGrowable< CNmStateNode::TimedEvent_t, 1 > m_timedElapsedEvents;
	int16 m_nLayerWeightNodeIdx; // = -1
	int16 m_nLayerRootMotionWeightNodeIdx; // = -1
	int16 m_nLayerBoneMaskNodeIdx; // = -1
	bool m_bIsOffState;
	bool m_bUseActualElapsedTimeInStateForTimedEvents;
};
