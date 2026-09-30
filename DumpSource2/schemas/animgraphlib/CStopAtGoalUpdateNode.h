// MHasKV3TransferPolymorphicClassname
class CStopAtGoalUpdateNode : public CUnaryUpdateNode
{
	float32 m_flOuterRadius;
	float32 m_flInnerRadius;
	float32 m_flMaxScale;
	float32 m_flMinScale;
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
