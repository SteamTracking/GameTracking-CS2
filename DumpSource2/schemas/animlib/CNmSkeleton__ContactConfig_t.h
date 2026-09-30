class CNmSkeleton::ContactConfig_t
{
	CGlobalSymbol m_ID;
	int32 m_nBoneIdx; // = -1
	Vector m_vBoneLocalProbeDir; // = [ 1, 0, 0 ]
	float32 m_flProbeMaxDist; // = 5
	NmContactAudioInfo_t m_audioInfo;
};
