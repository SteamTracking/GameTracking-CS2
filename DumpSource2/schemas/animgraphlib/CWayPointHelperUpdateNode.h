// MHasKV3TransferPolymorphicClassname
class CWayPointHelperUpdateNode : public CUnaryUpdateNode
{
	float32 m_flStartCycle;
	float32 m_flEndCycle;
	bool m_bOnlyGoals; // = true
	bool m_bPreventOvershoot; // = true
	bool m_bPreventUndershoot;
};
