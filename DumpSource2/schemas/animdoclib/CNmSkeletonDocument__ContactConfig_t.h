// MPropertyAutoExpandSelf
class CNmSkeletonDocument::ContactConfig_t
{
	CGlobalSymbol m_ID;
	CGlobalSymbol m_boneID;
	Vector m_vBoneLocalProbeDir; // = [ 1, 0, 0 ]
	float32 m_flProbeMaxDist; // = 5
	// MPropertyFriendlyName = "Audio"
	NmContactAudioInfo_t m_audioInfo;
};
