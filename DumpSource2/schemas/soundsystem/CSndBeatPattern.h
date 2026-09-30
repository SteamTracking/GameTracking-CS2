// MPropertyArrayElementNameKey = "m_name"
// MVDataAnonymousNode
// MVDataOutlinerNameExpr = "m_name"
class CSndBeatPattern
{
	// MPropertyFriendlyName = "Pattern Name"
	CUtlString m_name;
	// MPropertyFriendlyName = "Pattern Priority"
	float32 m_flSyncPriority;
	// MPropertyFriendlyName = "Sync Start Type"
	SndBeatSyncStartType_t m_syncStartType; // = "eSndBeatSyncStartTypeImmediate"
	// MPropertyFriendlyName = "Sync Type"
	SndBeatSyncType_t m_syncType; // = "eSndBeatSyncTypeReset"
	// MPropertyFriendlyName = "Time Signature"
	SndBeatTimeSignature_t m_timeSignature; // = { "nDenominator": 4, "nNumerator": 4 }
	// MPropertyFriendlyName = "Length (beats)"
	float32 m_flLength; // = 4
	// MPropertyFriendlyName = "Looping"
	bool m_bLooping;
	// MPropertyStartGroup = "Playback"
	// MPropertyFriendlyName = "Playback Event Type"
	SndBeatEventType_t m_playEventType; // = "eSndBeatEventTypeBeat"
	// MPropertySuppressExpr = "m_playEventType == eSndBeatEventTypeKeys"
	// MPropertyFriendlyName = "Playback Event Beat/Bar/Phrase/Length Multiplier"
	float32 m_flPlayBeatMult; // = 1
	// MPropertySuppressExpr = "m_playEventType != eSndBeatEventTypeKeys"
	// MPropertyFriendlyName = "Key Type"
	SndBeatKeyType_t m_playKeyType; // = "eSndBeatPatternTypeKeys"
	// MPropertySuppressExpr = "m_playKeyType != eSndBeatPatternTypeKeys"
	CUtlVector< SndBeatEventKeys_t > m_vecPatternKeys;
	// MPropertySuppressExpr = "m_playKeyType != eSndBeatPatternTypeKeyedFloats"
	CUtlVector< SndBeatEventKeyedFloats_t > m_vecPatternFloats;
	// MPropertySuppressExpr = "m_playKeyType != eSndBeatPatternTypeKeyedSndEvts"
	CUtlVector< SndBeatEventKeyedSndEvts_t > m_vecPatternSndEvts;
	// MPropertySuppressExpr = "m_playKeyType != eSndBeatPatternTypeKeyedMidi"
	CUtlVector< SndBeatEventKeyedMidiNotes_t > m_vecPatternMidi;
	// MPropertyStartGroup = "Queue"
	// MPropertyFriendlyName = "Queue Event Type"
	SndBeatEventType_t m_syncEventType; // = "eSndBeatEventTypeBeat"
	// MPropertySuppressExpr = "m_syncEventType == eSndBeatEventTypeKeys"
	// MPropertyFriendlyName = "Queue Beat/Bar/Phrase/Length Multiplier"
	float32 m_flSyncBeatMult; // = 1
	// MPropertySuppressExpr = "m_syncEventType != eSndBeatEventTypeKeys"
	CUtlVector< SndBeatEventKeys_t > m_vecSyncPatternKeys;
};
