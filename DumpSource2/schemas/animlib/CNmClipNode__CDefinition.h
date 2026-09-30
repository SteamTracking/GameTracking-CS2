// MHasKV3TransferPolymorphicClassname
class CNmClipNode::CDefinition : public CNmClipReferenceNode::CDefinition
{
	int16 m_nPlayInReverseValueNodeIdx; // = -1
	bool m_bSampleRootMotion; // = true
	bool m_bAllowLooping;
	int16 m_nDataSlotIdx; // = -1
	int16 m_nResetTimeValueNodeIdx; // = -1
	CUtlVectorFixedGrowable< CGlobalSymbol, 2 > m_graphEvents;
	float32 m_flSpeedMultiplier; // = 1
	int32 m_nStartSyncEventOffset;
};
