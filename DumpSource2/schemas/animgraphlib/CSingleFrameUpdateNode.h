// MHasKV3TransferPolymorphicClassname
class CSingleFrameUpdateNode : public CLeafUpdateNode
{
	CUtlVector< CSmartPtr< CAnimActionUpdater > > m_actions;
	CPoseHandle m_hPoseCacheHandle;
	HSequence m_hSequence; // = -1
	float32 m_flCycle;
};
