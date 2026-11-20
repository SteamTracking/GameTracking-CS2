// MHasKV3TransferPolymorphicClassname
class CHitReactUpdateNode : public CUnaryUpdateNode
{
	HitReactFixedSettings_t m_opFixedSettings;
	CAnimParamHandle m_triggerParam;
	CAnimParamHandle m_hitBoneParam;
	CAnimParamHandle m_hitOffsetParam;
	CAnimParamHandle m_hitDirectionParam;
	CAnimParamHandle m_hitStrengthParam;
	float32 m_flMinDelayBetweenHits;
	bool m_bResetChild;
};
