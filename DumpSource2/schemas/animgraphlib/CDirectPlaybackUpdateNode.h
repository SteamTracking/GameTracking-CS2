// MHasKV3TransferPolymorphicClassname
class CDirectPlaybackUpdateNode : public CUnaryUpdateNode
{
	bool m_bFinishEarly;
	bool m_bResetOnFinish;
	CUtlVector< CDirectPlaybackTagData > m_allTags;
};
