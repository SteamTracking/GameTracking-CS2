class NmGraphDocPin_t
{
	V_uuid_t m_ID;
	CUtlString m_name;
	NmGraphValueType_t m_type; // = "Unknown"
	bool m_bIsDynamicPin;
	bool m_bAllowMultipleOutConnections;
};
