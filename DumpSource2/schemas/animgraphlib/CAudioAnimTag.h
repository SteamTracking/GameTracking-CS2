// MPropertyFriendlyName = "Audio Tag"
// MHasKV3TransferPolymorphicClassname
class CAudioAnimTag : public CAnimTagBase
{
	// MPropertyFriendlyName = "Sound Event"
	// MPropertyAttributeEditor = "SoundPicker()"
	CUtlString m_clipName;
	// MPropertyFriendlyName = "Attachment"
	// MPropertyAttributeChoiceName = "Attachment"
	CUtlString m_attachmentName;
	// MPropertyFriendlyName = "Volume"
	// MPropertyAttributeRange = "0 1"
	float32 m_flVolume; // = 1
	// MPropertyFriendlyName = "Stop on Tag End"
	bool m_bStopWhenTagEnds;
	// MPropertyFriendlyName = "Stop When Graph Destroyed"
	bool m_bStopWhenGraphEnds; // = true
	// MPropertyFriendlyName = "Play on Server"
	bool m_bPlayOnServer; // = true
	// MPropertyFriendlyName = "Play on Client"
	bool m_bPlayOnClient; // = true
};
