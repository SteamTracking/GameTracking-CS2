// MHasKV3TransferPolymorphicClassname
class CFootAdjustmentUpdateNode : public CUnaryUpdateNode
{
	CUtlVector< HSequence > m_clips;
	CPoseHandle m_hBasePoseCacheHandle; // = { "m_eType": "POSETYPE_INVALID", "m_nIndex": 65535 }
	CAnimParamHandle m_facingTarget; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	float32 m_flTurnTimeMin;
	float32 m_flTurnTimeMax;
	float32 m_flStepHeightMax;
	float32 m_flStepHeightMaxAngle;
	bool m_bResetChild;
	bool m_bAnimationDriven;
};
