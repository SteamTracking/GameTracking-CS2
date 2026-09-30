// MHasKV3TransferPolymorphicClassname
class CStanceOverrideUpdateNode : public CUnaryUpdateNode
{
	CUtlVector< StanceInfo_t > m_footStanceInfo;
	CAnimUpdateNodeRef m_pStanceSourceNode; // = { "m_nodeIndex": -1 }
	CAnimParamHandle m_hParameter; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	StanceOverrideMode m_eMode; // = "Sequence"
};
