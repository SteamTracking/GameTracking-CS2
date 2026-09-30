class CEngineToolInfo : public CBaseToolInfo
{
	CUtlString m_Library;
	CUtlString m_InterfaceName;
	bool m_bShowInRevisionSubMenu;
	bool m_bShowInToolsMenu; // = true
	bool m_bIsSecondaryTool;
	bool m_bDoNotWarnAboutLargeAssetBatches;
	bool m_bIsWorkshopManagerTool;
	bool m_bIsWorkshopItemTool;
	bool m_bCanHighlightSubassets;
	CUtlVector< CUtlString > m_AssetTypes;
	CUtlVector< CUtlString > m_LimitToMods;
	CUtlVector< CUtlString > m_ExcludeFromMods;
};
