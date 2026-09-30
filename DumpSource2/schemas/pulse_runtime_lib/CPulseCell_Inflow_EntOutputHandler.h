// MHasKV3TransferPolymorphicClassname
class CPulseCell_Inflow_EntOutputHandler : public CPulseCell_Inflow_BaseEntrypoint
{
	PulseSymbol_t m_SourceEntity;
	PulseSymbol_t m_SourceOutput;
	CPulseValueFullType m_ExpectedParamType; // = "PVAL_VOID"
};
