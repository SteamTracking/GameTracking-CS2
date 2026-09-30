class CNmGraphDocument::DebugParameterSet_t
{
	CGlobalSymbol m_ID;
	CUtlLeanVector< std::pair< CGlobalSymbol, bool > > m_boolValues;
	CUtlLeanVector< std::pair< CGlobalSymbol, float32 > > m_floatValues;
	CUtlLeanVector< std::pair< CGlobalSymbol, CGlobalSymbol > > m_IDValues;
	CUtlLeanVector< std::pair< CGlobalSymbol, Vector > > m_vectorValues;
	CUtlLeanVector< std::pair< CGlobalSymbol, CNmTarget > > m_targetValues;
};
