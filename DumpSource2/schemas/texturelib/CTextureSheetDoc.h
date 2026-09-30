// MVDataRoot
// MVDataSingleton
// MVDataPreviewWidget = "sheet_file_preview"
// MVDataFileExtension = "mks"
class CTextureSheetDoc
{
	PackingMode_t m_ePackingMode; // = "PCKM_FLAT"
	int32 m_NumMips; // = 2
	// MPropertySuppressExpr = "m_sLayoutOwnerSheet != "" "
	bool m_bHasDecalParams;
	// MPropertyAttributeEditor = "AssetBrowse( mks )"
	CUtlString m_sLayoutOwnerSheet;
	// MVDataPromoteField = 1
	CUtlStringMap< CTextureSheetDoc_Sequence* > m_Sequences;
};
