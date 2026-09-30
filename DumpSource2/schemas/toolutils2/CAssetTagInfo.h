// MVDataRoot
// MVDataOutlinerDetailExpr = "m_TagName"
// MVDataOutlinerIconExpr = "m_TagIcon"
class CAssetTagInfo
{
	// MPropertyDescription = "User-facing tag name"
	CUtlString m_TagName;
	// MPropertyDescription = "User-facing description of the tag"
	// MPropertyAttributeEditor = "TextBlock()"
	CUtlString m_TagDescription;
	// MPropertyDescription = "Icon associated with the tag"
	// MPropertyAttributeEditor = "ToolImage( 16 )"
	CUtlString m_TagIcon;
	// MPropertyDescription = "Color for the tag badge"
	Color m_TagColor; // = [ 255, 255, 255 ]
	// MPropertyDescription = "Alternate strings this tag will match when searching for assets by name."
	// MPropertyAutoExpandSelf
	CUtlVector< CUtlString > m_TagAliases;
	// MPropertyDescription = "If set, draw this as an overlay image on the asset preview"
	// MPropertyAttributeEditor = "ToolImage( 64 )"
	CUtlString m_ThumbnailOverlayImage;
	// MPropertyDescription = "If set, the presence of this tag will cause the tools to suppress or dissuade use in several ways (and draw a red X over the asset preview)"
	bool m_bTagIndicatesRejectedAsset;
	// MPropertyDescription = "If set, the presence of this tag will cause the tools to hide the asset from users by default. NOTE: This means if an asset gets tagged with this it might 'dissapear' from the UI!"
	bool m_bTagHidesAssetByDefault;
	// MPropertyStartGroup = "+Auto Tags"
	// MPropertyDescription = "Required for any auto-tag. Restricts the auto-application of this tag to a specific asset type (string from assettypes_common.txt like 'material_asset' or 'model_asset')"
	CUtlString m_RestrictAutoTagToAssetType;
	// MPropertyDescription = "Set this to automatically apply this tag based on an asset filter string. (NOTE: Auto tag names MUST start with an '@' character!)"
	// MPropertyAutoExpandSelf
	// MPropertySuppressExpr = "m_RestrictAutoTagToAssetType == """
	CUtlString m_AutoFilterTag;
	// MPropertyDescription = "Set this to automatically apply this tag to assets based on references from a VData file. (NOTE: Auto tag names MUST start with an '@' character!)"
	// MPropertyAutoExpandSelf
	// MPropertySuppressExpr = "m_RestrictAutoTagToAssetType == """
	AutoTagVDataCondition_t m_AutoDataTag;
};
