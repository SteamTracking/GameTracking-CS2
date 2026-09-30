// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SetParameterAction : public CAnimGraphDoc_Action
{
	// MPropertyHideField
	CUtlString m_paramName;
	// MPropertyFriendlyName = "Parameter"
	// MPropertyAttributeChoiceName = "Parameter"
	AnimParamID m_param;
	// MPropertyFriendlyName = "Value"
	CAnimVariant m_value;
};
