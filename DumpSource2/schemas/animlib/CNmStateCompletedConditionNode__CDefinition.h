// MHasKV3TransferPolymorphicClassname
class CNmStateCompletedConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	int16 m_nTransitionDurationOverrideNodeIdx; // = -1
	float32 m_flTransitionDurationSeconds;
};
