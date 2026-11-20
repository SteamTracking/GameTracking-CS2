// MHasKV3TransferPolymorphicClassname
class CStanceOverrideUpdateNode : public CUnaryUpdateNode
{
	CUtlVector< StanceInfo_t > m_footStanceInfo;
	CAnimUpdateNodeRef m_pStanceSourceNode;
	CAnimParamHandle m_hParameter;
	StanceOverrideMode m_eMode; // = "Sequence"
};
