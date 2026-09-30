// MPropertyFriendlyName = "Wait for Entity Output"
// MPropertyDescription = "Waits for the entity to fire a specific output. By default, this listens once, but can be configured to listen until canceled."
// MPulseEditorSubHeaderText = "{ 'Output'='m_strEntityOutput' 'Until Canceled'='m_bListenUntilCanceled' }"
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/inflow_wait.png"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_ListenForEntityOutput : public CPulseCell_BaseYieldingInflow
{
	SignatureOutflow_Resume m_OnFired; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CGlobalSymbol m_strEntityOutput;
	// MPropertyDescription = "Continue listening for the output until canceled."
	bool m_bListenUntilCanceled;
};
