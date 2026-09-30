class CPulseCell_Outflow_PlaySceneBase::CursorState_t
{
	CHandle< CBaseEntity > m_sceneInstance;
	CHandle< CBaseEntity > m_mainActor;
	CUtlHashtable< PulseCursorID_t, int32 > m_cursorIDToEventID;
};
