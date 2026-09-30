// MPropertyFriendlyName = "Choice"
// MVDataAnonymousNode
// MVDataOutlinerNameExpr = "m_Name"
// MHasKV3TransferPolymorphicClassname
class CSmartPropChoice : public CSmartPropParameter
{
	// MPropertyFriendlyName = "Choice Name"
	CUtlString m_Name;
	// MPropertyAttributeChoiceName = "smartprop_choice_options"
	CUtlString m_DefaultOption;
	// MPropertyAutoExpandSelf
	CUtlVector< CSmartPropChoiceOption > m_Options;
};
