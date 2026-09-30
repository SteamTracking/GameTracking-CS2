// MHasKV3TransferPolymorphicClassname
class CCycleControlClipUpdateNode : public CLeafUpdateNode
{
	CUtlVector< TagSpan_t > m_tags;
	HSequence m_hSequence; // = -1
	float32 m_duration;
	AnimValueSource m_valueSource; // = "MoveHeading"
	CAnimParamHandle m_paramIndex; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bLockWhenWaning;
};
