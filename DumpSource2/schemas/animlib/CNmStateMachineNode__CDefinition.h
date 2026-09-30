// MHasKV3TransferPolymorphicClassname
class CNmStateMachineNode::CDefinition : public CNmPoseNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< CNmStateMachineNode::StateDefinition_t, 5 > m_stateDefinitions;
	int16 m_nDefaultStateIndex; // = -1
};
