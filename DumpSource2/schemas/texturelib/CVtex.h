class CVtex
{
	CUtlVector< CInputTexture > m_inputTextureArray;
	CUtlString m_outputTypeString;
	CUtlString m_outputFormat;
	Vector4D m_outputClearColor;
	int32 m_nOutputMinDimension;
	int32 m_nOutputMaxDimension;
	int32 m_nOutputDimensionReduce;
	CUtlVector< CTextureOutputChannel > m_textureOutputChannelArray;
	Vector m_vClamp;
	bool m_bNoLod;
	bool m_bHiddenAssetFlag;
	bool m_bNormalizeRange;
	bool m_bVirtualTexture;
	int32 m_nDisplayRectWidth;
	int32 m_nDisplayRectHeight;
	int32 m_nMotionVectorsMaxDistanceInPixels;
};
