// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_Graph : public CAnimGraphDoc_SubGraph
{
	CSmartPtr< CAnimGraphSettingsManager > m_pSettingsManager; // = { "_class": "CAnimGraphSettingsManager", "m_settingsGroups": [ { "_class": "CAnimGraphNetworkSettings", "m_bNetworkingEnabled": true } ] }
	CAnimGraphDoc_ClipDataManager m_clipDataManager; // = { "_class": "CAnimGraphDoc_ClipDataManager", "m_itemTable": {  } }
	CUtlString m_modelName;
	CUtlString m_previewModelName;
};
