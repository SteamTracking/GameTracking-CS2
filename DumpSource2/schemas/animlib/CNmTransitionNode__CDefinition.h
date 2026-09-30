// MHasKV3TransferPolymorphicClassname
class CNmTransitionNode::CDefinition : public CNmPoseNode::CDefinition
{
	int16 m_nTargetStateNodeIdx; // = -1
	int16 m_nDurationOverrideNodeIdx; // = -1
	int16 m_timeOffsetOverrideNodeIdx; // = -1
	int16 m_startBoneMaskNodeIdx; // = -1
	float32 m_flDuration;
	NmPercent_t m_boneMaskBlendInTimePercentage; // = { "m_flValue": 0.33 }
	float32 m_flTimeOffset;
	CNmBitFlags m_transitionOptions; // = { "m_flags": 1 }
	int16 m_targetSyncIDNodeIdx; // = -1
	NmEasingOperation_t m_blendWeightEasing; // = "Linear"
	NmRootMotionBlendMode_t m_rootMotionBlend; // = "Blend"
};
