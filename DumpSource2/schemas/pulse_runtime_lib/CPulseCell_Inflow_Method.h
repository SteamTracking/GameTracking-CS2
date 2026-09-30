// MHasKV3TransferPolymorphicClassname
class CPulseCell_Inflow_Method : public CPulseCell_Inflow_BaseEntrypoint
{
	PulseSymbol_t m_MethodName;
	CUtlString m_Description;
	bool m_bIsPublic;
	CUtlLeanVector< CPulseRuntimeMethodArg > m_Args;
	CUtlLeanVector< CPulseRuntimeMethodArg > m_ReturnValues;
};
