class CNmClipDocEventTrack
{
	CUtlVector< CNmClipDocEvent* > m_events;
	CUtlString m_eventClassName;
	CNmClipDocEventTrack::Type_t m_type; // = "Duration"
	bool m_bIsSyncTrack;
	bool m_bIsDisabled;
};
