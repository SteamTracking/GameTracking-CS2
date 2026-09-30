class PulseScriptedSequenceData_t
{
	int32 m_nActorID;
	CUtlString m_szPreIdleSequence;
	CUtlString m_szEntrySequence;
	CUtlString m_szSequence;
	CUtlString m_szExitSequence;
	ScriptedMoveTo_t m_nMoveTo; // = "eWaitFacing"
	SharedMovementGait_t m_nMoveToGait; // = "eInvalid"
	ScriptedHeldWeaponBehavior_t m_nHeldWeaponBehavior; // = "eInvalid"
	bool m_bLoopPreIdleSequence;
	bool m_bLoopActionSequence;
	bool m_bLoopPostIdleSequence;
	bool m_bIgnoreLookAt;
};
