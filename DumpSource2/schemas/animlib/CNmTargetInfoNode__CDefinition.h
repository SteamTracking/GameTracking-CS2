// MHasKV3TransferPolymorphicClassname
class CNmTargetInfoNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	int16 m_nInputValueNodeIdx; // = -1
	CNmTargetInfoNode::Info_t m_infoType; // = "Distance"
	bool m_bIsWorldSpaceTarget; // = true
};
