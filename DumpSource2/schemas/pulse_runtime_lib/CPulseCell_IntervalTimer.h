// MPropertyFriendlyName = "Interval Timer"
// MPropertyDescription = "Wait for a duration, firing a child cursor at regular (or randomized) intervals"
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/node_timer.png"
// MPulseEditorCanvasItemSpecKV3 = "{ item_factory = 'IntervalTimer' }"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_IntervalTimer : public CPulseCell_BaseYieldingInflow
{
	// MPropertyDescription = "Called when timer reaches the duration OR is stopped. NOTE: This will run a little while AFTER the last interval fires unless they line up perfectly."
	CPulse_ResumePoint m_Completed; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	// MPropertyDescription = "New child cursor starts here every time the wait interval elapses"
	SignatureOutflow_Continue m_OnInterval; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
