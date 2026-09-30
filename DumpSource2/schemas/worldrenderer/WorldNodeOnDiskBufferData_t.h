class WorldNodeOnDiskBufferData_t
{
	int32 m_nElementCount;
	int32 m_nElementSizeInBytes;
	CUtlVector< RenderInputLayoutField_t > m_inputLayoutFields;
	CUtlVector< uint8 > m_pData;
};
