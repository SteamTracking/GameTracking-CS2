// MHasKV3TransferPolymorphicClassname
class CGameChoreoServices : public IChoreoServices
{
	CHandle< CBaseModelEntity > m_hOwner;
	CHandle< CScriptedSequence > m_hScriptedSequence;
	IChoreoServices::ScriptState_t m_scriptState; // = "SCRIPT_PLAYING"
	IChoreoServices::ChoreoState_t m_choreoState; // = "STATE_PRE_SCRIPT"
	GameTime_t m_flTimeStartedState;
};
