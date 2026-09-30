class MaterialResourceData_t
{
	CUtlString m_materialName;
	CUtlString m_shaderName;
	CUtlVector< MaterialParamInt_t > m_intParams;
	CUtlVector< MaterialParamFloat_t > m_floatParams;
	CUtlVector< MaterialParamVector_t > m_vectorParams;
	CUtlVector< MaterialParamTexture_t > m_textureParams;
	CUtlVector< MaterialParamBuffer_t > m_dynamicParams;
	CUtlVector< MaterialParamBuffer_t > m_dynamicTextureParams;
	CUtlVector< MaterialParamInt_t > m_intAttributes;
	CUtlVector< MaterialParamFloat_t > m_floatAttributes;
	CUtlVector< MaterialParamVector_t > m_vectorAttributes;
	CUtlVector< MaterialParamTexture_t > m_textureAttributes;
	CUtlVector< MaterialParamString_t > m_stringAttributes;
	CUtlVector< CUtlString > m_renderAttributesUsed;
};
