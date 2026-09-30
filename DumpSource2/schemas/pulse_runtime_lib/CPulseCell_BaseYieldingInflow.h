// MCustomFGDMetadata = "{ standard_yielding_flow = true }"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_BaseYieldingInflow : public CPulseCell_BaseFlow
{
	// MPulseFGDSkipField
	CPulse_ResumePoint m_BaseFlow_OnAfterCancel;
	// MPulseFGDSkipField
	CPulse_ResumePoint m_BaseFlow_WhileActive;
};
