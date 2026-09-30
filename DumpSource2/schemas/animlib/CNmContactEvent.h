// MHasKV3TransferPolymorphicClassname
class CNmContactEvent : public CNmEvent
{
	CGlobalSymbol m_configID;
	CGlobalSymbol m_probeBoneID;
	Vector m_vBoneLocalProbeDir; // = [ 1, 0, 0 ]
	float32 m_flProbeMaxDist; // = 3
	NmContactAudioInfo_t m_audioInfo;
};
