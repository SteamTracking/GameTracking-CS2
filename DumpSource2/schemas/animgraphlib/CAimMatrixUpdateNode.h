// MHasKV3TransferPolymorphicClassname
class CAimMatrixUpdateNode : public CUnaryUpdateNode
{
	AimMatrixOpFixedSettings_t m_opFixedSettings;
	AnimVectorSource m_target; // = "MoveDirection"
	CAnimParamHandle m_paramIndex;
	HSequence m_hSequence; // = -1
	bool m_bResetChild;
	bool m_bLockWhenWaning;
};
