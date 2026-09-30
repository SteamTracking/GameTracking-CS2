// MPropertyFriendlyName = "Wait For Cursors With Tag"
// MPropertyDescription = "Causes this execution cursor to wait for the completion of other cursors with the given tag. Can optionally kill the tag while waiting."
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/cursor_tag.png"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_WaitForCursorsWithTag : public CPulseCell_WaitForCursorsWithTagBase
{
	// MPropertyDescription = "Apply the same tag we're waiting on to the resulting cursor upon wait completion. Can be used to wait on our result cursor with the same tag."
	bool m_bTagSelfWhenComplete;
	// MPropertyDescription = "When we start waiting, how should we handle existing cursors?"
	PulseCursorCancelPriority_t m_nDesiredKillPriority; // = "None"
};
