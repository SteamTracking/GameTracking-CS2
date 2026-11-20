// MHasKV3TransferPolymorphicClassname
class CLookAtUpdateNode : public CUnaryUpdateNode
{
	LookAtOpFixedSettings_t m_opFixedSettings;
	AnimVectorSource m_target; // = "MoveDirection"
	CAnimParamHandle m_paramIndex;
	CAnimParamHandle m_weightParamIndex;
	bool m_bResetChild;
	bool m_bLockWhenWaning;
};
