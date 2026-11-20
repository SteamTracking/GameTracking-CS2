// MHasKV3TransferPolymorphicClassname
class CFootAdjustmentUpdateNode : public CUnaryUpdateNode
{
	CUtlVector< HSequence > m_clips;
	CPoseHandle m_hBasePoseCacheHandle;
	CAnimParamHandle m_facingTarget;
	float32 m_flTurnTimeMin;
	float32 m_flTurnTimeMax;
	float32 m_flStepHeightMax;
	float32 m_flStepHeightMaxAngle;
	bool m_bResetChild;
	bool m_bAnimationDriven;
};
