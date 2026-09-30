// MPropertyFriendlyName = "Listen for AnimGraph Tag"
// MPropertyDescription = "Creates new cursors for when an animgraph tag is handled. Will listen until canceled."
// MPulseEditorSubHeaderText = "{ 'TagName'='m_TagName' }"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_ListenForAnimgraphTag : public CPulseCell_BaseYieldingInflow
{
	CPulse_ResumePoint m_OnStart; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CPulse_ResumePoint m_OnEnd; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	// MPropertyAttributeEditor = "AnimGraphTag()"
	CGlobalSymbol m_TagName;
};
