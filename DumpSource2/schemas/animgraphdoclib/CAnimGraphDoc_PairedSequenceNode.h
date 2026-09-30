// MPropertyFriendlyName = "Paired Animation Clip"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_PairedSequenceNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Paired Role"
	CGlobalSymbol m_sPairedRole;
	// MPropertyFriendlyName = "Preview Sequence"
	// MPropertyAttributeChoiceName = "Sequence"
	CUtlString m_previewSequenceName;
	// MPropertyFriendlyName = "Playback Speed"
	float32 m_flPlaybackSpeed; // = 1
	// MPropertyFriendlyName = "Loop"
	bool m_bLoop;
};
