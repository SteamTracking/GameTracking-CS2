// MPropertyFriendlyName = "Cursor Queue"
// MPropertyDescription = "Causes each execution cursor to wait for the completion of all prior cursors that have visited this node. Use this to safely support multiple triggers to areas of the graph that take time to complete."
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/cursor_wait_zone.png"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_CursorQueue : public CPulseCell_WaitForCursorsWithTagBase
{
	// MPropertyDescription = "Any cursors above this count will wait, up to the limit."
	int32 m_nCursorsAllowedToRunParallel; // = 1
};
