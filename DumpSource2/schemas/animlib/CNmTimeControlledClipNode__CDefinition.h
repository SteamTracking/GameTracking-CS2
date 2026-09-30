// MHasKV3TransferPolymorphicClassname
class CNmTimeControlledClipNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nPlayInReverseValueNodeIdx; // = -1
	bool m_bSampleRootMotion; // = true
	int16 m_nDataSlotIdx; // = -1
	int16 m_nTimeValueNodeIdx; // = -1
	CUtlVectorFixedGrowable< CGlobalSymbol, 2 > m_graphEvents;
};
