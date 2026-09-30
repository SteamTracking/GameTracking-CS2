// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_Contact : public CNmClipDocEvent
{
	// MPropertyAutoRebuildOnChange
	CGlobalSymbol m_configID;
	// MPropertyAttrStateCallback
	CGlobalSymbol m_probeBoneID;
	// MPropertyAttrStateCallback
	Vector m_vBoneLocalProbeDir; // = [ 1, 0, 0 ]
	// MPropertyAttrStateCallback
	float32 m_flProbeMaxDist; // = 3
	// MPropertyFriendlyName = "Audio"
	// MPropertyAttrStateCallback
	NmContactAudioInfo_t m_audioInfo;
};
