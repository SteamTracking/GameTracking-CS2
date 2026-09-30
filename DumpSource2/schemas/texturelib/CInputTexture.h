class CInputTexture
{
	CUtlString m_name;
	CUtlString m_fileName;
	CUtlString m_colorSpace;
	CUtlString m_fileExt;
	int32 m_nMinBitsPerChannel; // = -1
	CUtlString m_typeString;
	bool m_bPassThroughToCompiledVtex;
	int32 m_n3DSliceCount; // = -1
	int32 m_n3DSliceWidth; // = -1
	int32 m_n3DSliceHeight; // = -1
	CUtlVector< CImageProcessor > m_imageProcessorArray;
};
