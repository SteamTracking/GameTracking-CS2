// MHasKV3TransferPolymorphicClassname
class CNmGraphDocSyncEventIndexConditionNode : public CNmGraphDocFlowNode
{
	CNmSyncEventIndexConditionNode::TriggerMode_t m_triggerMode; // = "ExactlyAtEventIndex"
	int32 m_nSyncEventIdx; // = -1
};
