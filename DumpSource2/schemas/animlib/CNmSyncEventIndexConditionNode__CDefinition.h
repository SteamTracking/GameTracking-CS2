// MHasKV3TransferPolymorphicClassname
class CNmSyncEventIndexConditionNode::CDefinition : public CNmBoolValueNode::CDefinition
{
	int16 m_nSourceStateNodeIdx; // = -1
	CNmSyncEventIndexConditionNode::TriggerMode_t m_triggerMode; // = "ExactlyAtEventIndex"
	int32 m_syncEventIdx; // = -1
};
