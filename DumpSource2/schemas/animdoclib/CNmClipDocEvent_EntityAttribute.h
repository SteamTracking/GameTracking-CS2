// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_EntityAttribute : public CNmClipDocEvent
{
	CNmEventTargetEntity_t m_target; // = "Self"
	CUtlString m_attributeName;
	// MPropertyAutoRebuildOnChange
	// MPropertyFriendlyName = "Type"
	CNmClipDocEvent_EntityAttribute_Type_t m_nValueType; // = "EVENT_ENTITY_ATTR_TYPE_INT"
	// MPropertyAttrStateCallback
	int32 m_nIntValue;
	// MPropertyAttrStateCallback
	CPiecewiseCurve m_FloatValue;
};
