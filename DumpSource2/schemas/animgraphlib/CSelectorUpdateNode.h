// MHasKV3TransferPolymorphicClassname
class CSelectorUpdateNode : public CAnimUpdateNodeBase
{
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CUtlVector< int8 > m_tags;
	CBlendCurve m_blendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
	CAnimValue< float32 > m_flBlendTime; // = { "m_constValue": 0, "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	CAnimParamHandle m_hParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	int32 m_nTagIndex; // = -1
	SelectorTagBehavior_t m_eTagBehavior; // = "SelectorTagBehavior_OnWhileCurrent"
	bool m_bResetOnChange;
	bool m_bLockWhenWaning;
	bool m_bSyncCyclesOnChange;
};
