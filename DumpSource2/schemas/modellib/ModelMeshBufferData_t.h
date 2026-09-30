class ModelMeshBufferData_t
{
	int32 m_nBlockIndex; // = -1
	uint32 m_nElementCount;
	uint32 m_nElementSizeInBytes;
	bool m_bMeshoptCompressed;
	bool m_bMeshoptIndexSequence;
	int8 m_nMeshoptMeshletEncodeVersion; // = -1
	bool m_bCompressedZSTD;
	bool m_bCreateBufferSRV;
	bool m_bCreateBufferUAV;
	bool m_bCreateRawBuffer;
	bool m_bCreatePooledBuffer;
	uint16 m_nBufferUsage;
	CUtlVector< RenderInputLayoutField_t > m_inputLayoutFields;
};
