// MHasKV3TransferPolymorphicClassname
class CNmAnimationPoseNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nPoseTimeValueNodeIdx; // = -1
	int16 m_nDataSlotIdx; // = -1
	Range_t m_inputTimeRemapRange; // = { "m_flMax": 1, "m_flMin": 0 }
	float32 m_flUserSpecifiedTime;
	bool m_bUseFramesAsInput;
};
