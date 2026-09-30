// MPropertyFriendlyName = "Direct Playback"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_DirectPlaybackNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Finish Early"
	bool m_bFinishEarly;
	// MPropertyFriendlyName = "Reset Child On Finish"
	bool m_bResetOnFinish; // = true
};
