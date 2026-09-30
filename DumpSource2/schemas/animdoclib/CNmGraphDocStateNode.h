// MHasKV3TransferPolymorphicClassname
class CNmGraphDocStateNode : public CNmGraphDocStateMachineGraphNode
{
	// MPropertyHideField
	CNmGraphDocStateNode::StateType_t m_type; // = "BlendTreeState"
	// MPropertySuppressField
	V_uuid_t m_cloneSourceStateID; // = "00000000-0000-0000-0000-000000000000"
	// MPropertySuppressField
	V_uuid_t m_cloneStateVersion;
	// MPropertyAutoExpandSelf
	CUtlVector< CNmGraphDocStateNode::StateEvent_t > m_stateEvents;
	// MPropertyAutoExpandSelf
	CUtlVector< CNmGraphDocStateNode::TimedStateEvent_t > m_timedStateEvents;
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_events;
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_entryEvents;
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_executeEvents;
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_exitEvents;
	// MPropertySuppressField
	CUtlVector< CNmGraphDocStateNode::TimedStateEvent_t > m_timeRemainingEvents;
	// MPropertySuppressField
	CUtlVector< CNmGraphDocStateNode::TimedStateEvent_t > m_timeElapsedEvents;
	// MPropertyGroupName = "Advanced"
	bool m_bUseActualElapsedTimeInStateForTimedEvents;
};
