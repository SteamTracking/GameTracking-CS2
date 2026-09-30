// MHasKV3TransferPolymorphicClassname
class CNmGraphDocTransitionNode : public CNmGraphDocResultNode
{
	// MPropertyGroupName = "+Transition"
	float32 m_flDurationSeconds; // = 0.2
	// MPropertyGroupName = "+Transition"
	bool m_bClampDurationToSource;
	// MPropertyGroupName = "+Transition"
	NmRootMotionBlendMode_t m_rootMotionBlend; // = "Blend"
	// MPropertyGroupName = "+Transition"
	NmEasingOperation_t m_blendWeightEasing; // = "Linear"
	// MPropertyGroupName = "+Transition"
	float32 m_flBoneMaskBlendInTimePercentage; // = 0.33
	// MPropertyGroupName = "+Target Time"
	CNmGraphDocTransitionNode::TimeMatchMode_t m_timeMatchMode; // = "None"
	// MPropertyGroupName = "+Target Time"
	float32 m_flTimeOffset;
	// MPropertyGroupName = "Advanced"
	bool m_bCanBeForced;
};
