// MHasKV3TransferPolymorphicClassname
class CTurnHelperUpdateNode : public CUnaryUpdateNode
{
	AnimValueSource m_facingTarget; // = "MoveHeading"
	float32 m_turnStartTimeOffset;
	float32 m_turnDuration; // = 1
	bool m_bMatchChildDuration; // = true
	float32 m_manualTurnOffset;
	bool m_bUseManualTurnOffset;
};
