// MPropertyFriendlyName = "Ragdoll"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_RagdollNode : public CAnimGraphDoc_Node
{
	CUtlString m_weightListName;
	RagdollPoseControl m_poseControlMethod; // = "Absolute"
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
};
