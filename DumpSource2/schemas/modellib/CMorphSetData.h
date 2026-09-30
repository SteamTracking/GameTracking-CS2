class CMorphSetData
{
	int32 m_nWidth;
	int32 m_nHeight;
	CUtlVector< MorphBundleType_t > m_bundleTypes;
	CUtlVector< CMorphData > m_morphDatas;
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureAtlas;
	CUtlVector< CFlexDesc > m_FlexDesc;
	CUtlVector< CFlexController > m_FlexControllers;
	CUtlVector< CFlexRule > m_FlexRules;
};
