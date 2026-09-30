// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SubGraph
{
	CAnimGraphDoc_NodeManager m_nodeManager; // = { "_class": "CAnimGraphDoc_NodeManager", "m_nodes": [  ] }
	CAnimGraphDoc_ComponentManager m_componentManager; // = { "_class": "CAnimGraphDoc_ComponentManager", "m_components": [  ] }
	CUtlVector< CSmartPtr< CAnimParameterBase > > m_localParameters;
	CUtlVector< CSmartPtr< CAnimTagBase > > m_localTags;
	CUtlVector< CUtlString > m_referencedParamGroups;
	CUtlVector< CUtlString > m_referencedTagGroups;
};
