// MHasKV3TransferPolymorphicClassname
class CAnimUpdateSharedData
{
	CUtlVector< CSmartPtr< CAnimUpdateNodeBase > > m_nodes;
	CUtlHashtable< CAnimNodePath, int32 > m_nodeIndexMap;
	CUtlVector< CSmartPtr< CAnimComponentUpdater > > m_components;
	CSmartPtr< CAnimParameterManagerUpdater > m_pParamListUpdater;
	CSmartPtr< CAnimTagManagerUpdater > m_pTagManagerUpdater;
	CSmartPtr< CAnimScriptManager > m_scriptManager;
	CAnimGraphSettingsManager m_settings;
	CSmartPtr< CStaticPoseCacheBuilder > m_pStaticPoseCache;
	CSmartPtr< CAnimSkeleton > m_pSkeleton;
	CAnimNodePath m_rootNodePath;
};
