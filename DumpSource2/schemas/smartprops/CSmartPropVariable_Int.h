// MPropertyFriendlyName = "Integer"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable_Int : public CSmartPropVariable
{
	int32 m_DefaultValue;
	// MPropertySortPriority = -1
	// MPropertyReadonlyExpr = "m_bExposeAsParameter == false"
	int32 m_nParamaterMinValue;
	// MPropertySortPriority = -1
	// MPropertyReadonlyExpr = "m_bExposeAsParameter == false"
	int32 m_nParamaterMaxValue; // = 1
};
