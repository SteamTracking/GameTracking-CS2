// MHasKV3TransferPolymorphicClassname
class CSelectorUpdateNode : public CAnimUpdateNodeBase
{
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CUtlVector< int8 > m_tags;
	CBlendCurve m_blendCurve;
	CAnimValue< float32 > m_flBlendTime; // = { "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	CAnimParamHandle m_hParameter;
	int32 m_nTagIndex; // = -1
	SelectorTagBehavior_t m_eTagBehavior; // = "SelectorTagBehavior_OnWhileCurrent"
	bool m_bResetOnChange;
	bool m_bLockWhenWaning;
	bool m_bSyncCyclesOnChange;
};
