// MHasKV3TransferPolymorphicClassname
class CHitReactUpdateNode : public CUnaryUpdateNode
{
	HitReactFixedSettings_t m_opFixedSettings;
	CAnimParamHandle m_triggerParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hitBoneParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hitOffsetParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hitDirectionParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hitStrengthParam; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	float32 m_flMinDelayBetweenHits;
	bool m_bResetChild;
};
