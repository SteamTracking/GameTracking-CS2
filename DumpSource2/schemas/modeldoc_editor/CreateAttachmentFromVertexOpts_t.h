// MPropertyElementNameFn
// MPropertyDescription = "Options for creating an attachment from a mesh vertex."
class CreateAttachmentFromVertexOpts_t
{
	// MPropertyFlattenIntoParentRow
	// MPropertyReadOnly
	CUtlString m_Name; // = "Create Attachment From Vertex Options"
	// MPropertyFriendlyName = "Attachment Name"
	// MPropertyDescription = "Base name for the created attachment.  A unique suffix is appended if needed."
	CUtlString m_AttachmentName; // = "attach"
	// MPropertyFriendlyName = "Alignment"
	// MPropertyDescription = "How the created attachment is oriented."
	VertexAttachmentAlignModeSchema_t m_eAlignMode; // = "VTX_ATTACH_ALIGN_NORMAL"
	// MPropertyFriendlyName = "Max Influences"
	// MPropertyDescription = "Maximum number of bone influences to copy (1-3).  A vertex can have more, but attachments support at most 3."
	int32 m_nMaxInfluences; // = 3
	// MPropertyFriendlyName = "Show Vertex Preview"
	// MPropertyDescription = "Draw the nearby-vertex point cloud while hovering.  Turn off if the attachment axis preview alone is enough."
	bool m_bShowPreview; // = true
	// MPropertyFriendlyName = "Hide Config Models"
	// MPropertyDescription = "Temporarily turn off Show Config during placement.  Config/SpawnConfig attached models can never be picked by this tool, so they only obscure the mesh."
	bool m_bHideConfigModels; // = true
};
