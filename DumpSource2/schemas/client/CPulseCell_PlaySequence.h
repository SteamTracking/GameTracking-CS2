// MPropertyFriendlyName = "Play Sequence"
// MPropertyDescription = "Play the specified animation sequence on a NON-ANIMGRAPH entity, and wait for it to complete."
// MHasKV3TransferPolymorphicClassname
class CPulseCell_PlaySequence : public CPulseCell_BaseYieldingInflow
{
	// MPropertyAttributeSuggestionName = "pulse_model_sequence_name"
	CUtlString m_SequenceName;
	PulseNodeDynamicOutflows_t m_PulseAnimEvents;
	CPulse_ResumePoint m_OnFinished; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
