// MHasKV3TransferPolymorphicClassname
class ActiveModelConfig_t
{
	ModelConfigHandle_t m_Handle;
	CUtlSymbolLarge m_Name;
	CNetworkUtlVectorBase< CHandle< CBaseModelEntity > > m_AssociatedEntities;
	CNetworkUtlVectorBase< CUtlSymbolLarge > m_AssociatedEntityNames;
	CUtlLeanVector< bool > m_vecAssociatedEntityCollidesWithHierarchy;
	CUtlLeanVector< bool > m_vecAssociatedEntityCollidesOutsideHierarchy;
};
