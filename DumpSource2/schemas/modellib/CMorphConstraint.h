// MHasKV3TransferPolymorphicClassname
class CMorphConstraint : public CBaseConstraint
{
	CUtlString m_sTargetMorph;
	int32 m_nSlaveChannel;
	float32 m_flMin;
	float32 m_flMax; // = 1
};
