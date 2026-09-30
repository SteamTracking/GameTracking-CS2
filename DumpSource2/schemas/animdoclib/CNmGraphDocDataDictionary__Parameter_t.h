class CNmGraphDocDataDictionary::Parameter_t
{
	// MPropertySuppressField
	V_uuid_t m_ID;
	// MPropertyFlattenIntoParentRow
	CUtlString m_name;
	CUtlString m_groupName;
	NmGraphValueType_t m_valueType; // = "ID"
	// MPropertyAutoExpandSelf
	// MPropertyAttrStateCallback
	CUtlVector< CGlobalSymbol > m_expectedValues;
};
