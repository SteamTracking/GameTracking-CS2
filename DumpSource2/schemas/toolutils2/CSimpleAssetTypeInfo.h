// MHasKV3TransferPolymorphicClassname
class CSimpleAssetTypeInfo
{
	CUtlString m_FriendlyName;
	CUtlString m_Ext;
	CUtlString m_IconLg; // = "game:tools/images/assettypes/generic_lg.png"
	CUtlString m_IconSm; // = "game:tools/images/assettypes/generic_sm.png"
	CUtlVector< CUtlString > m_SuppressSubstrings;
	CUtlVector< CUtlString > m_AdditionalExtensions;
	CUtlVector< AssetEngineCommand_t > m_EngineCommands;
	CUtlVector< CUtlString > m_LimitToMods;
	CUtlVector< CUtlString > m_ExcludeFromMods;
	CUtlVector< CUtlString > m_HideForRetailMods;
	CUtlString m_PreviewThumbnailOverlayIcon;
	bool m_bErrorOnUnrecognizedOutboundRefs;
	CUtlVector< CUtlString > m_UnrecognizedOutboundRefsErrorTypeExceptions;
	bool m_bHideTypeByDefault;
	bool m_bCannotBeShown;
	bool m_bIsNontrivialChildAssetType;
	bool m_bSuppressFullFingerprintCalculation;
	bool m_bIgnoreCompiledState;
	bool m_bContentFileIsText;
	bool m_bPrefersLivePreview;
	bool m_bPresentInGameTree;
	bool m_bShouldCompileErrorFallbackToDisk;
	int32 m_nAssetTypeVersion;
	int32 m_nAssetThumbnailVersion;
	CUtlString m_Test_InjectSearchable;
};
