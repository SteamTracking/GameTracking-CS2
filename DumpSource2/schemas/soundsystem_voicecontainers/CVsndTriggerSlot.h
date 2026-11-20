class CVsndTriggerSlot
{
	// MPropertyGroupName = "Vsnd"
	// MPropertyFriendlyName = "Enable Vsnd"
	bool m_bEnableVsnd; // = true
	// MPropertyGroupName = "Vsnd"
	// MPropertyFriendlyName = "Vsnd File"
	CSoundContainerReference m_vsnd;
	// MPropertyGroupName = "Endcap"
	// MPropertyFriendlyName = "Enable Endcap"
	bool m_bEnableEndcap;
	// MPropertyGroupName = "Endcap"
	// MPropertyFriendlyName = "Endcap Vsnd (Stop)"
	CSoundContainerReference m_endcapVsnd;
	// MPropertyGroupName = "Loopcap"
	// MPropertyFriendlyName = "Enable Loopcap"
	bool m_bEnableLoopcap;
	// MPropertyGroupName = "Loopcap"
	// MPropertyFriendlyName = "Loopcap Vsnd (Loop)"
	CSoundContainerReference m_loopcapVsnd;
	// MPropertyFriendlyName = "Volume"
	float32 m_volume; // = 1
	// MPropertyFriendlyName = "Fade Out (sec)"
	float32 m_fadeOut;
	// MPropertyFriendlyName = "Mode"
	EVsndTriggerMode m_mode; // = "Trigger"
};
