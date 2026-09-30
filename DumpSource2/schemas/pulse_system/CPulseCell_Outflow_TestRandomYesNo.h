// MPropertyFriendlyName = "[Test] Random Yes/No Outflow"
// MPropertyDescription = "Test node that randomly picks between two outflows."
// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_TestRandomYesNo : public CPulseCell_BaseFlow
{
	// MPropertyFriendlyName = "Yes"
	// MPropertyDescription = "Randomly taken half of the time"
	CPulse_OutflowConnection m_Yes; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	// MPropertyFriendlyName = "No"
	// MPropertyDescription = "Randomly taken half of the time"
	CPulse_OutflowConnection m_No; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
