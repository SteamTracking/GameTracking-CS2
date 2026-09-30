// MPropertyFriendlyName = "[Test] Explicit Yes/No Outflow"
// MPropertyDescription = "Test node that picks between two outflows as specified in the test domain."
// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_TestExplicitYesNo : public CPulseCell_BaseFlow
{
	// MPropertyFriendlyName = "Yes"
	CPulse_OutflowConnection m_Yes; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	// MPropertyFriendlyName = "No"
	CPulse_OutflowConnection m_No; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
