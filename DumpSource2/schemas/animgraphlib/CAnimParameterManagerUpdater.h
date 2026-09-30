// MHasKV3TransferPolymorphicClassname
class CAnimParameterManagerUpdater
{
	CUtlVector< CSmartPtr< CAnimParameterBase > > m_parameters;
	CUtlHashtable< AnimParamID, int32 > m_idToIndexMap;
	CUtlHashtable< CUtlString, int32 > m_nameToIndexMap;
	CUtlVector< CAnimParamHandle > m_indexToHandle;
	CUtlVector< std::pair< CAnimParamHandle, CAnimVariant > > m_autoResetParams;
	CUtlHashtable< CAnimParamHandle, int16 > m_autoResetMap;
};
