// MHasKV3TransferPolymorphicClassname
class CAnimGraphDebugReplay
{
	CUtlString m_animGraphFileName;
	CUtlVector< CSmartPtr< CAnimReplayFrame > > m_frameList;
	int32 m_startIndex;
	int32 m_writeIndex;
	int32 m_frameCount;
};
