// MHasKV3TransferPolymorphicClassname
class CResourceAssetTypeInfo : public CSimpleAssetTypeInfo
{
	CUtlString m_CompilerIdentifier;
	CUtlVector< CUtlString > m_CompileDependsOnResourceTypes;
	CUtlVector< ResourceBlockTypeInfo_t > m_Blocks;
	CUtlString m_RequiredSpecialDependency;
	bool m_bPreventDirectCompile;
	bool m_bCannotBeAMultiParentChildCompile;
	bool m_bPrefersIconForThumbnail;
	bool m_bAllowedToCompileInTestMode;
};
