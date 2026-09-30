// MPropertyFriendlyName = "Follow Attachment"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_FollowAttachmentNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_boneName;
	// MPropertyFriendlyName = "Target Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentName;
	// MPropertyFriendlyName = "Match Translation"
	bool m_bMatchTranslation;
	// MPropertyFriendlyName = "Match Rotation"
	bool m_bMatchRotation;
};
