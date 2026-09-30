// MPropertyArrayElementNameKey = "m_name"
// MVDataAnonymousNode
// MVDataOutlinerNameExpr = "m_name"
class CSndBeatTrack
{
	// MPropertyFriendlyName = "Track Name"
	CUtlString m_name;
	// MPropertyFriendlyName = "Playback Mode"
	SndBeatTrackPlaybackType_t m_playbackType; // = "eSndBeatTrackPlaybackTypeFwd"
	// MPropertyFriendlyName = "Transpose"
	int32 m_nTranspose;
	// MPropertyFriendlyName = "Sync To Voice"
	bool m_bSyncToVoice;
	// MPropertyFriendlyName = "BPM"
	float32 m_flBPM; // = 120
};
