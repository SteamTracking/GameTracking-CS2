class CPulse_RegisterInfo
{
	PulseRuntimeRegisterIndex_t m_nReg; // = -1
	CPulseValueFullType m_Type; // = "PVAL_VOID"
	CKV3MemberNameWithStorage m_OriginName;
	int32 m_nWrittenByInstruction; // = -1
	int32 m_nLastReadByInstruction; // = -1
};
