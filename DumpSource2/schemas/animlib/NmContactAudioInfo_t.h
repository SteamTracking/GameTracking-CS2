// MPropertyAutoExpandSelf
class NmContactAudioInfo_t
{
	// MPropertyFriendlyName = "Audio Action"
	// MPropertyAttributeEditor = "VDataChoice( scripts/nm_contact_audio_actions.vdata )"
	CGlobalSymbol m_audioActionID;
	// MPropertyFriendlyName = "Audio Type"
	// MPropertyAttributeEditor = "VDataChoice( scripts/nm_contact_audio_types.vdata )"
	// MPropertyAutoRebuildOnChange
	CGlobalSymbol m_audioTypeID;
	// MPropertyFriendlyName = "Audio Soundevent Override"
	// MPropertyAttrStateCallback
	CGlobalSymbol m_soundeventOverrideID;
};
